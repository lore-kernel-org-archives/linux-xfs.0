Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7DE137F3F
	for <xfs@oss.sgi.com>; Sun, 27 Apr 2014 16:56:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6BC278F8033
	for <xfs@oss.sgi.com>; Sun, 27 Apr 2014 14:56:09 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id UVPj2pALIMaCA4dA for <xfs@oss.sgi.com>;
	Sun, 27 Apr 2014 14:56:08 -0700 (PDT)
Message-ID: <535D7CF7.2070409@sandeen.net>
Date: Sun, 27 Apr 2014 16:56:07 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH, RFC] xfs: add heuristic to flush on rename
References: <535ABA9D.2060305@redhat.com> <20140427212026.GX18672@dastard>
In-Reply-To: <20140427212026.GX18672@dastard>
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
To: Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 4/27/14, 4:20 PM, Dave Chinner wrote:
> On Fri, Apr 25, 2014 at 02:42:21PM -0500, Eric Sandeen wrote:
>> Add a heuristic to flush data to a file which looks like it's
>> going through a tmpfile/rename dance, but not fsynced.
>>
>> I had a report of a system with many 0-length files after
>> package updates; as it turns out, the user had basically
>> done 'yum update' and punched the power button when it was
>> done.
> 
> So yum didn't run sync() on completion of the update? That seems
> rather dangerous to me - IMO system updates need to be guaranteed to
> be stable by the update mechanisms, not to leave the system state to
> chance if power fails or the system crashes immediately after an
> update...
> 
> 
>> Granted, the admin should not do this.  Granted, the package
>> manager should ensure persistence of files it updated.
> 
> Yes, yes it should. Problem solved without needing to touch XFS.

Right, I first suggested it 5 years or so ago for RPM.  But hey, who
knows, someday maybe.

So no need to touch XFS, just every godawful userspace app out there...

Somebody should bring up the topic to wider audience, I'm sure they'll
all get fixed in short order.  Wait, or did we try that already?  :)

>> Ext4, however, added a heuristic like this for just this case;
>> someone who writes file.tmp, then renames over file, but
>> never issues an fsync.
> 
> You mean like rsync does all the time for every file it copies?

Yeah, I guess rsync doesn't fsync either.  ;)

>> Now, this does smack of O_PONIES, but I would hope that it's
>> fairly benign.  If someone already synced the tmpfile, it's
>> a no-op.
> 
> I'd suggest it will greatly impact rsync speed and have impact on
> the resultant filesystem layout as it guarantees interleaving of
> metadata and data on disk....

Ok, well, based on the responses thus far, sounds like a non-starter.

I'm not wedded to it, just thought I'd float the idea.

OTOH, it is an interesting juxtaposition to say the open O_TRUNC case
is worth catching, but the tempfile overwrite case is not.

-Eric

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
