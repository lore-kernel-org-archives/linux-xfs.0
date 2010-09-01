Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8105vhb091171 for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 19:05:57 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5319240EF3
	for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 17:06:35 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	e0M4XG3vb8DlsDHf for <xfs@oss.sgi.com>;
	Tue, 31 Aug 2010 17:06:35 -0700 (PDT)
Date: Wed, 1 Sep 2010 10:06:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: deleting 2TB lots of files with delaylog: sync helps?
Message-ID: <20100901000631.GO705@dastard>
References: <201009010130.41500@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201009010130.41500@zmi.at>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Wed, Sep 01, 2010 at 01:30:41AM +0200, Michael Monnerie wrote:
> I'm just trying the delaylog mount option on a filesystem (LVM over 
> 2x 2TB 4K sector drives), and I see this while running 8 processes 
> of "rm -r * & 2>/dev/null":
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await  svctm  %util
> sdc               2,80    33,40  125,00   64,60   720,00   939,30    17,50     0,55    2,91   1,71  32,40
> sdd               0,00    25,60  122,80   63,40   662,40   874,40    16,51     0,52    2,77   1,96  36,54
> dm-0              0,00     0,00  250,60  123,00  1382,40  1941,70    17,79     1,64    4,39   1,74  65,08
> 
> Then I issue "sync", and utilisation increases:
> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await  svctm  %util
> sdc               0,00     0,20   15,80  175,40    84,00  2093,30    22,78     0,62    3,26   2,93  55,94
> sdd               0,00     1,00   13,40  177,60    79,20  2114,10    22,97     0,69    3,63   3,34  63,80
> dm-0              0,00     0,00   29,20  101,20   163,20  4207,40    67,03     1,11    8,51   7,56  98,60
> 
> This is reproducible.

You're probably getting RMW cycles on inode writeback. I've been
noticing this lately with my benchmarking - the VM is being _very
aggressive_ reclaiming page cache pages vs inode caches and as a
result the inode buffers used for IO are being reclaimed between the
time it takes to create the inodes and when they are written back.
Hence you get lots of reads occurring during inode writeback.

By issuing a sync, you clear out all the inode writeback and all the
RMW cycles go away. As a result, there is more disk throughput
availble for the unlink processes.  There is a good chance this is
the case as the number of reads after the sync drop by an order of
magnitude...

> Now it can be that the sync just causes more writes and stalls reads
> so overall it's slower, but I'm wondering why none of the devices says "100% util", which
> should be the case on deletes? Or is this again the "mistake" of the utilization calculation
> that writes do not really show up there?

You're probably CPU bound, not IO bound.

> I know I should have benchmarked and tested, I just wanted to raise eyes on this as it 
> could be possible there's something to optimize.
> 
> Another strange thing: After the 8 "rm -r" finished, there were some subdirs left over 
> that hadn't been deleted - running one "rm -r" cleaned them out then. Could that be
> a problem with "delaylog"?

Unlikely - files not being deleted is not a function of the way
transactions are written to disk. It's a function of whether the
operation was performed or not.

> Or can that happen when several "rm" compete in the same dirs?

Most likely.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
