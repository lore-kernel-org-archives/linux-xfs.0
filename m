Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 388847F67
	for <xfs@oss.sgi.com>; Sat,  9 Mar 2013 12:51:30 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 18BA1304032
	for <xfs@oss.sgi.com>; Sat,  9 Mar 2013 10:51:26 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id Jr9mDQ34TWqppfh1
	for <xfs@oss.sgi.com>; Sat, 09 Mar 2013 10:51:26 -0800 (PST)
Message-ID: <513B84AD.2000603@hardwarefreak.com>
Date: Sat, 09 Mar 2013 12:51:25 -0600
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
In-Reply-To: <20130309091152.GH23616@dastard>
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

On 3/9/2013 3:11 AM, Dave Chinner wrote:
> On Fri, Mar 08, 2013 at 12:59:22PM -0600, Stan Hoeppner wrote:
>> On 3/8/2013 6:20 AM, Ric Wheeler wrote:
>>> On 03/08/2013 03:39 AM, Stan Hoeppner wrote:
>>>> On 3/6/2013 5:12 PM, Ric Wheeler wrote:
>>>>
>>>>> We actually test brutal "Power off" for xfs, ext4 and other file
>>>>> systems. If your storage is configured properly and you have barriers
>>>>> enabled, they all pass without corruption.
>>
>> I think you missed the context.  Please reread this:
>>
>>>> Something that none of us mentioned WRT write barriers is that while the
>>>> filesystem structure may avoid corruption when the power is cut, files
>>>> may still be corrupted, in conditions such as any/all of these:
>>
>> I made it very clear I was discussing file corruption here, not
>> filesystem corruption.  You already covered that base.  I was
>> specifically addressing the fact that XFS performs barriers on metadata
>> writes but not file data writes.
> 
> Actually, you're not correct there, either, Stan. ;)

With "either" you're implying I was incorrect twice, and I wasn't, not
in whole anyway, maybe in part. ;)

> XFS only issues cache flushes/FUA writes for log IO. Metadata IO is
> done exactly the same way that data IO is done - without barriers.
> It's because metadata lost in drive caches at the time of a crash is
> rewritten by journal replay that filesystem corruption does not
> occur.

Technical semantics.  Geeze, give the non dev a break now and then.  ;)
 Does everyone remember the transitive property of equality from math
class decades ago?  It states "If A=B and B=C then A=C".  Thus if
barrier writes to the journal protect the journal, and the journal
protects metadata, then barrier writes to the journal protect metadata.
 I had a detail incorrect, but not the big picture.  And I'd bet the OP
is more interested in the big picture.  So surely I'd get a B or a C
here, but certainly not an F.

> As it is, if the application uses direct IO (likely, as it
> sounds like video capture/editing/playout here) then log IO
> will also ensure that the data written by the app is on disk (i.e.
> that's ithe mechanism by which fsync works).

So this would be an interesting upside down case for XFS, as the file
data may be intact, but the filesystem gets corrupted, the opposite of
the design point.

> Hence even assumptions that there will be data loss are dependent on
> how the application is doing it's IO....

I didn't assume there _will_ be data loss.  I'm simply trying to help
the guy think about covering all the bases, which is the smart thing to
do, is it not?  I've never designed any system with the "assumption"
that pulling the plug is the standard mode of system shutdown. ;)  I
doubt anyone else here has either.  So we're all working a bit "outside
the box" here, yes?

>>> Also, if there are active writers, this is inherently racy. A better
>>> script would unmount the file systems :)
>>
>> Yes, a umount would be even better.
> 
> Change the bios so that the power button does not cause a power down
> so the OS can capture the button event and trigger an orderly
> shutdown.

Dare I say "Dave you're incorrect". ;)

The OP already stated that all the gear, whatever that is, in the vans
is controlled by a master switch, probably something like an 8 outlet
surge protector/power strip, and the techs power down all the gear by
this one switch.  So this solution doesn't work either.  I think someone
already suggested this upstream in the thread.  This is one of those
classic cases of computers being injected into a field application where
the users are so used to dumb/analog devices that they simply
can't/won't adapt, resist, or simply take a long time to assimilate.
Reminds me of a similar case some time ago...

When I ordered my first aDSL circuit back in ~2000 it took SW Bell 6
weeks to get it working.  The field techs had been trained and worked in
the analog phone world for 70+ years and these guys are the antithesis
of technical folks.  In my case the port on the brand new Alcatel DSLAM
was defective.  Took 4 weeks and a dozen different techs to finally
diagnose it, and another 2 weeks of "paperwork" to reassign my circuit
to another DSLAM port, though the bureaucracy issue wasn't the techs'
fault.  From what I understand it took about 2 years for these guys to
become proficient with DSL installations.

Let's hope for OP's sake that it doesn't take two years for his guys to
learn and adapt to this "new" digital recording system.  I put "new" in
quotes, as having worked for SGI Dave you know this direct to disk
recording technology has been around for over a decade.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
