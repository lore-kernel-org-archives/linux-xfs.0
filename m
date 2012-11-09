Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA978b1c083506 for <xfs@oss.sgi.com>; Fri, 9 Nov 2012 01:08:37 -0600
Received: from Ishtar.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id ajW41TbNLh7cs88j (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 08 Nov 2012 23:10:36 -0800 (PST)
Message-ID: <509CAC62.3040508@tlinx.org>
Date: Thu, 08 Nov 2012 23:10:26 -0800
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: better perf and memory uage for xfs_fsr? Trivial patch
	against	xfstools-3.16 included...
References: <509BAABF.3030608@tlinx.org> <509C1653.7050906@tlinx.org>
	<20121108213911.GS6434@dastard>
In-Reply-To: <20121108213911.GS6434@dastard>
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
Cc: xfs-oss <xfs@oss.sgi.com>



Dave Chinner wrote:
> On Thu, Nov 08, 2012 at 12:30:11PM -0800, Linda Walsh wrote:
>> FWIW, the benefit, probably comes from the read-file, as the written file
>> is written with DIRECT I/O and I can't see that it should make a difference
>> there.
> 
> Hmmm, so it does. I think that's probably the bug that needs to be
> fixed, not so much using posix_fadvise....
---
	Well... using direct I/O might be another way of fixing it...
but I notice that neither the reads nor the writes seem to use the optimal
I/O size that takes into consideration RAID alignment.  It aligns for memory
alignment and aligns for a 2-4k device alignment, but doesn't seem to take
into consideration minor things like a 64k strip-unit x 12-wide-data-width
(768k).. if you do direct I/O. might want to be sure to RAID align it...


	Doing <64k at a time would cause heinous perf... while using
the SEQUENTIAL+READ-ONCE params seem to cause a notable I/O smoothing
(no dips/valleys on the I/O charts), though I don't know how much
(if any) real performance increase (or decrease) there was, as setting
up exactly fragmentation cases would be a pain...

	If you do LARGE I/O's on the READs.. say 256MB at a time, I
don't think exact alignment will matter that much, but I notice speed
improvements up to a 1GB buffer size in reads + writes in 'dd' using
direct I/O (couldn't test larger size, as device driver doesn't seem
to allow anything > 2GB-8k.. (this on a 64bit machine)
at least I think it is the dev.driver, hasn't been important enough
to chase down.

	While such large buffers might be bad on a memory tight
machine, on many 64-bit machines, it's well worth the throughput
and lower disk-transfer-time usage.  Meanwhile, that posix
call added on the read side really does seem to benefit...
Try it, you'll like it!  ;-) (not to say it is the 'best' fix,
but it's pretty low cost!)...

> Cheers,
> 
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
