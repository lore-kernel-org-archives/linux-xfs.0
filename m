Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9F6557F3F
	for <xfs@oss.sgi.com>; Sun, 27 Apr 2014 19:20:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 999968F8037
	for <xfs@oss.sgi.com>; Sun, 27 Apr 2014 17:20:11 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id qAo9Xmy6FzWlP6Ii for <xfs@oss.sgi.com>;
	Sun, 27 Apr 2014 17:20:10 -0700 (PDT)
Message-ID: <535D9EB9.50902@sandeen.net>
Date: Sun, 27 Apr 2014 19:20:09 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH, RFC] xfs: add heuristic to flush on rename
References: <535ABA9D.2060305@redhat.com> <20140427212026.GX18672@dastard>
	<535D7CF7.2070409@sandeen.net> <20140427231523.GZ18672@dastard>
In-Reply-To: <20140427231523.GZ18672@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 4/27/14, 6:15 PM, Dave Chinner wrote:
> On Sun, Apr 27, 2014 at 04:56:07PM -0500, Eric Sandeen wrote:
>> On 4/27/14, 4:20 PM, Dave Chinner wrote:
>>> On Fri, Apr 25, 2014 at 02:42:21PM -0500, Eric Sandeen wrote:
>>>> Add a heuristic to flush data to a file which looks like it's
>>>> going through a tmpfile/rename dance, but not fsynced.
>>>>
>>>> I had a report of a system with many 0-length files after
>>>> package updates; as it turns out, the user had basically
>>>> done 'yum update' and punched the power button when it was
>>>> done.
>>>
>>> So yum didn't run sync() on completion of the update? That seems
>>> rather dangerous to me - IMO system updates need to be guaranteed to
>>> be stable by the update mechanisms, not to leave the system state to
>>> chance if power fails or the system crashes immediately after an
>>> update...
>>>
>>>
>>>> Granted, the admin should not do this.  Granted, the package
>>>> manager should ensure persistence of files it updated.
>>>
>>> Yes, yes it should. Problem solved without needing to touch XFS.
>>
>> Right, I first suggested it 5 years or so ago for RPM.  But hey, who
>> knows, someday maybe.
> 
> grrrrr.
> 
>> So no need to touch XFS, just every godawful userspace app out there...
>>
>> Somebody should bring up the topic to wider audience, I'm sure they'll
>> all get fixed in short order.  Wait, or did we try that already?  :)
> 
> I'm not talking about any random application. Package managers are
> *CRITICAL SYSTEM INFRASTRUCTURE*. They should be architectected to
> handle failures gracefully; following *basic data integrity rules*
> is a non-negotiable requirement for a system upgrade procedure.
> Leaving the system in an indeterminate and potentially inoperable
> state after a successful upgrade completion is reported is a
> completely unacceptable outcome for any system management operation.
> 
> Critical infrastructure needs to Do Things Right, not require other
> people to hack around it's failings and hope that they might be able
> to save the system when shit goes wrong.  There is no excuse for
> critical infrastructure developers failing to acknowledge and
> address the data integrity requirements of their infrastructure.

Yeah, I know - choir, preaching, etc.

>>>> Ext4, however, added a heuristic like this for just this case;
>>>> someone who writes file.tmp, then renames over file, but
>>>> never issues an fsync.
>>>
>>> You mean like rsync does all the time for every file it copies?
>>
>> Yeah, I guess rsync doesn't fsync either.  ;)
> 
> That's because rsync doesn't need to sync until it completes all of
> the data writes. A failed
> rsync can simply be re-run after the system comes back up and
> nothing is lost. That's a very different situation to a package
> manager replacing binaries that the system may need to boot, yes?

yeah, my point is that rsync overwrites exiting files and _never_ syncs.
Not per-file, not at the end, not with any available option, AFAICT.

Different situation, yes, but arguably just as bad under the
wrong circumstances.

>>>> Now, this does smack of O_PONIES, but I would hope that it's
>>>> fairly benign.  If someone already synced the tmpfile, it's
>>>> a no-op.
>>>
>>> I'd suggest it will greatly impact rsync speed and have impact on
>>> the resultant filesystem layout as it guarantees interleaving of
>>> metadata and data on disk....
>>
>> Ok, well, based on the responses thus far, sounds like a non-starter.
>>
>> I'm not wedded to it, just thought I'd float the idea.
>>
>> OTOH, it is an interesting juxtaposition to say the open O_TRUNC case
>> is worth catching, but the tempfile overwrite case is not.
> 
> We went through this years ago - the O_TRUNC case is dealing with
> direct overwrite of data which we can reliably detect, usually only
> occurs one file at a time, has no major performance impact and data
> loss is almost entirely mitigated by the flush-on-close behaviour.
> It's a pretty reliable mitigation mechanism.

[citation needed] for a some of that, but *shrug*

> Rename often involves many files (so much larger writeback delay on
> async flush), it has cases we can't catch (e.g. rename of a
> directory containing unsynced data files) and has much more
> unpredictable behaviour (e.g. rename of files being actively written
> to). There's nothing worse than having unpredictable/non-repeatable
> data loss scenarios - if we can't handle all rename cases with the
> same guarantees, then we shouldn't provide any data integrity
> guarantees at all.

Ok, so it's a NAK.

I'm over it already,
-Eric

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
