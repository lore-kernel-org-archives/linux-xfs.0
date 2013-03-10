Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 68D567CBF
	for <xfs@oss.sgi.com>; Sun, 10 Mar 2013 18:55:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2AC18304053
	for <xfs@oss.sgi.com>; Sun, 10 Mar 2013 16:54:57 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id gyL1qe01voxY7ywX
	for <xfs@oss.sgi.com>; Sun, 10 Mar 2013 16:54:56 -0700 (PDT)
Message-ID: <513D1D51.7010905@hardwarefreak.com>
Date: Sun, 10 Mar 2013 18:54:57 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS filesystem corruption
References: <CAPcwv6wZJSBtgF-L6KNSn6N6Y+wUZJFXdbcg+zYRwoaB2sDdjw@mail.gmail.com>
	<20130306161519.2c28d911@galadriel.home>
	<CAPcwv6wqv0b_CPqDpBfOwVDg23uBi=tpGQSy9XuH2uWS5oVMWQ@mail.gmail.com>
	<20130306232100.6286f640@galadriel.home>
	<5137CD46.6070909@redhat.com> <5139A3B6.3040805@hardwarefreak.com>
	<5139D792.4090304@redhat.com> <513A350A.508@hardwarefreak.com>
	<20130309091152.GH23616@dastard>
	<513B84AD.2000603@hardwarefreak.com>
	<20130310224536.GK23616@dastard>
In-Reply-To: <20130310224536.GK23616@dastard>
Reply-To: stan@hardwarefreak.com
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
Cc: Julien FERRERO <jferrero06@gmail.com>, Ric Wheeler <rwheeler@redhat.com>, xfs@oss.sgi.com

On 3/10/2013 5:45 PM, Dave Chinner wrote:
> On Sat, Mar 09, 2013 at 12:51:25PM -0600, Stan Hoeppner wrote:
>> On 3/9/2013 3:11 AM, Dave Chinner wrote:
>>> On Fri, Mar 08, 2013 at 12:59:22PM -0600, Stan Hoeppner wrote:
>>>> On 3/8/2013 6:20 AM, Ric Wheeler wrote:
>>>>>> Something that none of us mentioned WRT write barriers is that while the
>>>>>> filesystem structure may avoid corruption when the power is cut, files
>>>>>> may still be corrupted, in conditions such as any/all of these:
>>>>
>>>> I made it very clear I was discussing file corruption here, not
>>>> filesystem corruption.  You already covered that base.  I was
>>>> specifically addressing the fact that XFS performs barriers on metadata
>>>> writes but not file data writes.
>>>
>>> Actually, you're not correct there, either, Stan. ;)
>>
>> With "either" you're implying I was incorrect twice, and I wasn't, not
>> in whole anyway, maybe in part. ;)
> 
> The "either" was in reference to you correcting someone else...

I wasn't attempting to correct Ric on the technicals, as that's simply
not really possible, me being a user talking to a dev.  That would be
really presumptuous on my part, not to mention dumb.  I had made a point
about file data corruption, and he replied talking about metadata
corruption.  My "correction" was simply to clarify I was talking about
file data not metadata.

>>> XFS only issues cache flushes/FUA writes for log IO. Metadata IO is
>>> done exactly the same way that data IO is done - without barriers.
>>> It's because metadata lost in drive caches at the time of a crash is
>>> rewritten by journal replay that filesystem corruption does not
>>> occur.
>>
>> Technical semantics.  Geeze, give the non dev a break now and then.  ;)
> 
> It's the technical semantics that matter when it comes to behaviour
> at power loss.  That's why I pick on "technical semantics" - it's
> makes your analysis and understanding of problems better, and that
> means there's less for me to do in future ;)

I do my best to grab the low hanging fruit when I can so you guys can
concentrate on more important stuff.

>>  Does everyone remember the transitive property of equality from math
>> class decades ago?  It states "If A=B and B=C then A=C".  Thus if
>> barrier writes to the journal protect the journal, and the journal
>> protects metadata, then barrier writes to the journal protect metadata.
> 
> Yup, but the devil is in the detail - we don't protect individual
> metadata writes at all and that difference is significant enough to
> comment on.... :P

Elaborate on this a bit, if you have time.  I was under the impression
that all directory updates were journaled first.

>>  I had a detail incorrect, but not the big picture.  And I'd bet the OP
>> is more interested in the big picture.  So surely I'd get a B or a C
>> here, but certainly not an F.
> 
> Certainly a B+ - like I said, I'm being picky because you seem to
> understand the details once explained... :)

Usually. ;)  Sometimes it takes a couple of sessions before it fully
sinks in.  I must say I've learned a tremendous amount from the devs on
this list, and I'm grateful that you specifically Dave have taken the
time to 'tutor' me, and others, over the last couple of years.

>>> As it is, if the application uses direct IO (likely, as it
>>> sounds like video capture/editing/playout here) then log IO
>>> will also ensure that the data written by the app is on disk (i.e.
>>> that's ithe mechanism by which fsync works).
>>
>> So this would be an interesting upside down case for XFS, as the file
>> data may be intact, but the filesystem gets corrupted, the opposite of
>> the design point.
> 
> Well, if barriers are working correctly, then there won't be any
> filesystem corruption, either...

Ok, see, this is odd part here.  The OP didn't seem to have this
metadata corruption issue with the old 2.6.18 kernel, at least I think
that's the one he mentioned.  Then he switched to 2.6.35.  IIRC there
were a number of commits around that time and some regressions.  I also
recall 2.6.35 is not a long term stable kernel.  I'd guess there were
reasons for that.  So, I'm wondering if there was a bug/regression
relating to XFS metadata in 2.6.35 corrected in .36 or later and simply
not backported.  Seems to ring a bell, vaguely.  I have no idea
where/how to search for such information.

>>>>> Also, if there are active writers, this is inherently racy. A better
>>>>> script would unmount the file systems :)
>>>>
>>>> Yes, a umount would be even better.
>>>
>>> Change the bios so that the power button does not cause a power down
>>> so the OS can capture the button event and trigger an orderly
>>> shutdown.
>>
>> Dare I say "Dave you're incorrect". ;)
> 
> Heh.  Not so much incorrect as "unaware of the entire scope". I
> browsed the thread and didn't pick up on this little detail...

I know.  That was a bit of a cheap shot, hence the judicious use of
quotes and winkies. ;)  I knew you'd missed it or you'd not have
mentioned the ACPI soft power switch option.

-- 
Stan


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
