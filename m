Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o123pc7R151877 for <xfs@oss.sgi.com>; Mon, 1 Feb 2010 21:51:39 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 62ED71C97B46
	for <xfs@oss.sgi.com>; Mon,  1 Feb 2010 19:52:44 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id kGrsNSW9m32gcf2o for
	<xfs@oss.sgi.com>; Mon, 01 Feb 2010 19:52:44 -0800 (PST)
Message-ID: <4B67A18C.8010009@sandeen.net>
Date: Mon, 01 Feb 2010 21:52:44 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: State of XFS on ARM
References: <13bb8ce11002011924h611099feh4955eedcc6e588a6@mail.gmail.com>
In-Reply-To: <13bb8ce11002011924h611099feh4955eedcc6e588a6@mail.gmail.com>
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
To: Daniel Goller <morfic@gmail.com>
Cc: xfs@oss.sgi.com

Daniel Goller wrote:
> Dear Sir or Madam,
> 
> I Would like to find out about the current state of XFS on ARM.
> I have been using XFS for a while successfully on my laptop, and was
> using XFS on a ARM device (little endian) since it would hold the same
> data i had on the laptop.
> It seems i have not been able to unmount it and then mounting it
> cleanly once, always required xfs_repair -L   /dev/sdc3
> I Could understand power issues or lockups causing this, but on clean
> umount and followed mount to see it fail is surprising.

well, actually neither power issues nor lockups should cause it either ;)

> When mounting fails on the headless arm machine i move the drive to a
> x86_64 and run xfs_repair there when mounting there fails too (so log
> can't be replayed, making -L necessary).
> All of this leads me to ask:  "Is XFS as well maintained on ARM as it
> is on x86/x86_64?"

Short answer no, but effort is made.  The last known issue, as far
as I know, is a cache aliasing problem.

This patch is a big-hammer approach, better things have been proposed
but not yet upstream as far as I know.

With "what doesn't work" helpfully commented out  ;) 

Index: linux-2.6.22.18/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- linux-2.6.22.18.orig/fs/xfs/linux-2.6/xfs_buf.c
+++ linux-2.6.22.18/fs/xfs/linux-2.6/xfs_buf.c
@@ -1185,6 +1185,8 @@ _xfs_buf_ioapply(
 		bio->bi_end_io = xfs_buf_bio_end_io;
 		bio->bi_private = bp;
 
+		//flush_dcache_page(bp->b_pages[0]);
+		flush_cache_all();
 		bio_add_page(bio, bp->b_pages[0], PAGE_CACHE_SIZE, 0);
 		size = 0;
 
@@ -1211,6 +1213,8 @@ next_chunk:
 		if (nbytes > size)
 			nbytes = size;
 
+		//flush_dcache_page(bp->b_pages[map_i]);
+		flush_cache_all();
 		rbytes = bio_add_page(bio, bp->b_pages[map_i], nbytes, offset);
 		if (rbytes < nbytes)
 			break;



> Thank you in advance for any info you can provide,
> 
> Daniel Goller
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
