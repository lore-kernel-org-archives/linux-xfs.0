Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o597QhrE001612 for <xfs@oss.sgi.com>; Wed, 9 Jun 2010 02:26:44 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CB41D3A987C
	for <xfs@oss.sgi.com>; Wed,  9 Jun 2010 00:29:14 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	1MBqN5PChKWIlpaY for <xfs@oss.sgi.com>;
	Wed, 09 Jun 2010 00:29:14 -0700 (PDT)
Date: Wed, 9 Jun 2010 17:29:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: avoid synchronous transaction in xfs_fs_write_inode
Message-ID: <20100609072911.GI7869@dastard>
References: <20100608195905.GA577@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100608195905.GA577@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, Jun 08, 2010 at 03:59:07PM -0400, Christoph Hellwig wrote:
> 
> We already rely on the fact that the sync code will cause a synchronous
> log force later on (currently via xfs_fs_sync_fs -> xfs_quiesce_data ->
> xfs_sync_data), so no need to do this here.  This allows us to avoid
> a lot of synchronous log forces during sync, which pays of especially
> with delayed logging enabled.   Some compilebench numbers that show
> this:
> 
> xfs (delayed logging, 256k logbufs)
> ===================================
> 
> intial create		  25.94 MB/s	  25.75 MB/s	  25.64 MB/s
> create			   8.54 MB/s	   9.12 MB/s	   9.15 MB/s
> patch			   2.47 MB/s	   2.47 MB/s	   3.17 MB/s
> compile			  29.65 MB/s	  30.51 MB/s	  27.33 MB/s
> clean			  90.92 MB/s	  98.83 MB/s	 128.87 MB/s
> read tree		  11.90 MB/s	  11.84 MB/s	   8.56 MB/s
> read compiled		  28.75 MB/s	  29.96 MB/s	  24.25 MB/s
> delete tree		8.39 seconds	8.12 seconds	8.46 seconds
> delete compiled		8.35 seconds	8.44 seconds	5.11 seconds
> stat tree		6.03 seconds	5.59 seconds	5.19 seconds
> stat compiled tree	9.00 seconds	9.52 seconds	8.49 seconds
> 
> 
> xfs + write_inode log_force removal
> ===================================
> intial create		  25.87 MB/s	  25.76 MB/s	  25.87 MB/s
> create			  15.18 MB/s	  14.80 MB/s	  14.94 MB/s
> patch			   3.13 MB/s	   3.14 MB/s	   3.11 MB/s
> compile			  36.74 MB/s	  37.17 MB/s	  36.84 MB/s
> clean			 226.02 MB/s	 222.58 MB/s	 217.94 MB/s
> read tree		  15.14 MB/s	  15.02 MB/s	  15.14 MB/s
> read compiled tree	  29.30 MB/s	  29.31 MB/s	  29.32 MB/s
> delete tree		6.22 seconds	6.14 seconds	6.15 seconds
> delete compiled tree	5.75 seconds	5.92 seconds	5.81 seconds
> stat tree		4.60 seconds	4.51 seconds	4.56 seconds
> stat compiled tree	4.07 seconds	3.87 seconds	3.96 seconds
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

All great - I attempted this myself - but it breaks bulkstat. See
xfstest 183:

183 2s ... - output mismatch (see 183.out.bad)
--- 183.out     2010-04-28 15:00:22.000000000 +1000
+++ 183.out.bad 2010-06-09 17:10:23.000000000 +1000
@@ -1,4 +1,4 @@
 QA output created by 183
 Start original bulkstat_unlink_test with -r switch
 Runing extended checks.
-Iteration 0 ... (100 files)passed
+Iteration 0 ... (100 files)ERROR, count(2) != scount(1).
Ran: 183
Failures: 183
Failed 1 of 1 tests

Test 183 fails with this patch because it leaves the inode pinned in
the WB_SYNC_ALL case after calling xfs_log_inode(), and so the inode
can't be flushed to the backing buffer. Hence bulkstat may not see
changes to an inode after a sync becuase they weren't flushed during
the sync.

I think that we need to revisit bulkstat's use of the backing
buffers for performance reasons now we have a much more scalable
inode cache. Having to keep the backing buffers coherent is only
going to be more problematic in future as things get even more
asynchronous....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
