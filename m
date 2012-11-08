Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA8CnGMp253236 for <xfs@oss.sgi.com>; Thu, 8 Nov 2012 06:49:16 -0600
Received: from Ishtar.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id P5ANTWX9qcPwklpc (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 08 Nov 2012 04:51:14 -0800 (PST)
Received: from [192.168.3.12] (Athenae [192.168.3.12])
	by Ishtar.tlinx.org (8.14.5/8.14.4/SuSE Linux 0.8) with ESMTP id
	qA8CpBLE004210 for <xfs@oss.sgi.com>; Thu, 8 Nov 2012 04:51:13 -0800
Message-ID: <509BAABF.3030608@tlinx.org>
Date: Thu, 08 Nov 2012 04:51:11 -0800
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: better perf and memory uage for xfs_fsr? Trivial patch against
	xfstools-3.16 included...
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
To: xfs-oss <xfs@oss.sgi.com>

I was looking at output of xosview and watched a daily run of xfs_fsr take
off as normal, and do it's normal thing of allocating remaining buffer
memory during it's run -- and, as seems normal, it would go up to the
machine's limit, then the kernel's memory reclaiming would kick in for a few
hundred ms, and take memory usage down from 48G to maybe 30+G.

During this time, I'd see xfs_fsr stop or pause for a bit, then resume and
I'd see a used-buffer memory look like slow ramps followed by sharp drops
with xfs_fsr showing i/o gaps as the ramps peaked.

I wondered why it lumped all this memory reclaiming and thought to try using
the posix_fadvise calls in xfs_fsr to tell the kernel what data was unneeded
and such...

It seems to have increased overall perf, and there doesn't seem to be
anymore contention or I/O drops... no more ramping either ... it goes to the
top and stays there, with the free-memory process keeping pace with fsr's
usage.

If it doesn't look like it would cause problems (seems to reduce memory
manager thrashing), maybe you'd like to add the patch to the source tree?
It's *WAY* trivial:

-------------------------
--- fsr/xfs_fsr.c 2011-02-11 02:42:15.000000000 -0800
+++ fsr/xfs_fsr.c 2012-11-08 04:10:18.608718948 -0800
@@ -1163,6 +1163,10 @@
   }
   unlink(tname);

+ posix_fadvise(fd, 0, 0, POSIX_FADV_NOREUSE|POSIX_FADV_SEQUENTIAL);
+
+ posix_fadvise(tfd, 0, 0, POSIX_FADV_DONTNEED);
+
   /* Setup extended attributes */
   if (fsr_setup_attr_fork(fd, tfd, statp) != 0) {
     fsrprintf(_("failed to set ATTR fork on tmp: %s:\n"), tname);



-------

That's it... set the input files for sequential access and no-reuse after
the read, and set the output descriptor to tell the kernel I won't need the
data that will be going into it.


It hasn't been **extensively*** tested... just plopped it in and it seems to
have good behavior... but it's simple enough and advisory, so the risk
should be minimal...(besides short-term testing showing it to be
beneficial)...

It doesn't increase or decrease the memory usage, just makes alloc'ing and
freeing it in the kernel a bit smoother...

hope you find it useful?

Maybe other utils might benefit as well, dunno, ...but fsr was the most
obvious to see the changes with.




_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
