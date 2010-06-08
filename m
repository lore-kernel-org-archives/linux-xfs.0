Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o58KVVCK231406 for <xfs@oss.sgi.com>; Tue, 8 Jun 2010 15:31:31 -0500
Received: from isrv.corpit.ru (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 25A9010C987A
	for <xfs@oss.sgi.com>; Tue,  8 Jun 2010 13:36:59 -0700 (PDT)
Received: from isrv.corpit.ru (isrv.corpit.ru [81.13.33.159]) by cuda.sgi.com
	with ESMTP id lGCYKdLnZLdSm9gE for <xfs@oss.sgi.com>;
	Tue, 08 Jun 2010 13:36:59 -0700 (PDT)
Message-ID: <4C0EA938.9000104@msgid.tls.msk.ru>
Date: Wed, 09 Jun 2010 00:34:00 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
MIME-Version: 1.0
Subject: xfs, 2.6.27=>.32 sync write 10 times slowdown [was: xfs, aacraid
	2.6.27 => 2.6.32 results in 6 times slowdown]
References: <4C0E13A7.20402@msgid.tls.msk.ru> <20100608122919.GC7869@dastard>
In-Reply-To: <20100608122919.GC7869@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

08.06.2010 16:29, Dave Chinner wrote:
> On Tue, Jun 08, 2010 at 01:55:51PM +0400, Michael Tokarev wrote:
>> Hello.
>>
>> I've got a.. difficult issue here, and am asking if anyone else
>> has some expirence or information about it.
>>
>> Production environment (database).  Machine with an Adaptec
>> RAID SCSI controller, 6 drives in raid10 array, XFS filesystem
>> and Oracle database on top of it (with - hopefully - proper
>> sunit/swidth).
>>
>> Upgrading kernel from 2.6.27 to 2.6.32, and users starts screaming
>> about very bad performance.  Iostat reports increased I/O latencies,
>> I/O time increases from ~5ms to ~30ms.  Switching back to 2.6.27,
>> and everything is back to normal (or, rather, usual).
>>
>> I tried testing I/O with a sample program which performs direct random
>> I/O on a given device, and all speeds are actually better in .32
>> compared with .27, except of random concurrent r+w test, where .27
>> gives a bit more chances to reads than .32.  Looking at the synthetic
>> tests I'd expect .32 to be faster, but apparently it is not.
>>
>> This is only one machine here which is still running 2.6.27, all the
>> rest are upgraded to 2.6.32, and I see good performance of .32 there.
>> But this is also the only machine with hardware raid controller, which
>> is onboard and hence not easy to get rid of, so I'm sorta forced to
>> use it (I prefer software raid solution because of numerous reasons).
>>
>> One possible cause of this that comes to mind is block device write
>> barriers.  But I can't find when they're actually implemented.
>>
>> The most problematic issue here is that this is only one machine that
>> behaves like this, and it is a production server, so I've very little
>> chances to experiment with it.
>>
>> So before the next try, I'd love to have some suggestions about what
>> to look for.   In particular, I think it's worth the effort to look
>> at write barriers, but again, I don't know how to check if they're
>> actually being used.
>>
>> Anyone have suggestions for me to collect and to look at?
>
> http://xfs.org/index.php/XFS_FAQ#Q._Should_barriers_be_enabled_with_storage_which_has_a_persistent_write_cache.3F

Yes, I've seen this.  We use xfs for quite long time.  The on-board
controller does not have battery unit, so it should be no different
than a software raid array or single drive.

But I traced the issue to a particular workload -- see $subject.

Simple test doing random reads or writes of 4k blocks in a 1Gb
file located on an xfs filesystem, Mb/sec:

                      sync  direct
              read   write   write
2.6.27 xfs   1.17    3.69    3.80
2.6.32 xfs   1.26    0.52    5.10
                      ^^^^
2.6.32 ext3  1.19    4.91    5.02

Note the 10 times difference between O_SYNC and O_DIRECT writes
in 2.6.32.  This is, well, huge difference, and this is where
the original slowdown comes from, apparently.  In 2.6.27 both
sync and direct writes are on-par with each other, in .32
direct write has improved, but sync write is just pathetic now.
And compared with previous o_sync, that's about 6 times the
difference which I reported previously.

We're running a legacy oracle application here, on Oracle8,
which does not support O_DIRECT and uses O_SYNC.  So it gets
hit by this issue quite badly - no doubt users start screaming
after switching to .32.

I also tested ext3fs, for comparison.  This one does not have
that problem and works just fine in both .32 and .27.  I also
tried disabling barriers for xfs, which made no difference
whatsoever.

So it's O_SYNC writes on XFS which are problematic.  Together
with hw raid apparently, since no one noticed when I switched
other machines (with sw raid) from .27 to .32.

I'll _try_ to find when the problem first appeared, but it is
not that simple since I've only very small time window for
testing.

Thanks!

/mjt

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
