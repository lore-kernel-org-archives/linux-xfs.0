Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n242ruWO048011 for <xfs@oss.sgi.com>; Tue, 3 Mar 2009 20:53:58 -0600
Message-Id: <6.0.0.20.2.20090304114824.06985898@172.19.0.2>
Date: Wed, 04 Mar 2009 11:50:06 +0900
From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: [PATCH] XFS: Pagecache usage optimization on XFS
Mime-Version: 1.0
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
To: xfs-masters@oss.sgi.com, xfs@oss.sgi.com

Hi.

I introduced "is_partially_uptodate" aops for XFS.

A page can have multiple buffers and even if a page is not uptodate, some buffers 
can be uptodate on pagesize != blocksize environment.
This aops checks that all buffers which correspond to a part of a file 
that we want to read are uptodate. If so, we do not have to issue actual 
read IO to HDD even if a page is not uptodate because the portion we 
want to read are uptodate. 
"block_is_partially_uptodate" function is already used by ext2/3/4.
With the following patch random read/write mixed workloads or random read after 
random write workloads can be optimized and we can get performance improvement.

I did a performance test using the sysbench.

#sysbench --num-threads=4 --max-requests=100000 --test=fileio --file-num=1 
--file-block-size=8K --file-total-size=1G --file-test-mode=rndrw --file-fsync-freq=0 
--file-rw-ratio=0.5 run

-2.6.29-rc6
Test execution summary:
    total time:                          123.8645s
    total number of events:              100000
    total time taken by event execution: 442.4994
    per-request statistics:
         min:                            0.0000s
         avg:                            0.0044s
         max:                            0.3387s
         approx.  95 percentile:         0.0118s


-2.6.29-rc6-patched
Test execution summary:
    total time:                          108.0757s
    total number of events:              100000
    total time taken by event execution: 417.7505
    per-request statistics:
         min:                            0.0000s
         avg:                            0.0042s
         max:                            0.3217s
         approx.  95 percentile:         0.0118s


arch: ia64
pagesize: 16k
blocksize: 4k


Please merge following patch.
Thanks.

Signed-off-by: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>

diff -Nrup linux-2.6.29-rc6.org/fs/xfs/linux-2.6/xfs_aops.c linux-2.6.29-rc6.xfs/fs/xfs/linux-2.6/xfs_aops.c
--- linux-2.6.29-rc6.org/fs/xfs/linux-2.6/xfs_aops.c	2009-03-02 09:26:08.000000000 +0900
+++ linux-2.6.29-rc6.xfs/fs/xfs/linux-2.6/xfs_aops.c	2009-03-04 10:26:21.000000000 +0900
@@ -1623,4 +1623,5 @@ const struct address_space_operations xf
 	.bmap			= xfs_vm_bmap,
 	.direct_IO		= xfs_vm_direct_IO,
 	.migratepage		= buffer_migrate_page,
+	.is_partially_uptodate  = block_is_partially_uptodate,
 };

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
