Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o39L3n2X137938 for <xfs@oss.sgi.com>; Fri, 9 Apr 2010 16:03:49 -0500
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 99DB4FCFF0E
	for <xfs@oss.sgi.com>; Fri,  9 Apr 2010 14:05:16 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de
	[212.227.126.187]) by cuda.sgi.com with ESMTP id
	0a7NLtcxZEbp0L9N for <xfs@oss.sgi.com>;
	Fri, 09 Apr 2010 14:05:16 -0700 (PDT)
Received: from localhost ([127.0.0.1])
	by bogon.housecafe.de with esmtp (Exim 4.69)
	(envelope-from <lists@nerdbynature.de>) id 1O0LO6-0007XB-84
	for xfs@oss.sgi.com; Fri, 09 Apr 2010 23:05:14 +0200
Date: Fri, 9 Apr 2010 14:05:14 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: 2.6.34-rc3: inode 0x401afe0 background reclaim flush failed with
 11
Message-ID: <alpine.DEB.2.01.1004091348010.29272@bogon.housecafe.de>
MIME-Version: 1.0
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
To: xfs@oss.sgi.com

Hi,

while running some filesystem benchmarks, this happend in my logs when 
bonnie++ was running:

[14610.114155] Filesystem "md0": inode 0x401afe0 background reclaim flush failed with 11
[14610.114171] Filesystem "md0": inode 0x401afe1 background reclaim flush failed with 11
[14610.114183] Filesystem "md0": inode 0x401afe2 background reclaim flush failed with 11
[...]

...and so forth for a couple of inodes.

I can reproduce this pretty reliably with bonnie++ now. This did not 
happen with 2.6.33, but the bonnie++ version has been upgraded too, so I'm 
still not sure if this is a real regression.

I've put a few details on http://nerdbynature.de/bits/2.6.34-rc3/xfs/

Is this something to worry about?

Thanks,
Christian.

PS: Why is the inode shown in hex and not in decimal? Would something 
like this do:

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 05cd853..30c7bcb 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -825,7 +825,7 @@ xfs_reclaim_inode(
 	 */
 	if (error && !XFS_FORCED_SHUTDOWN(ip->i_mount)) {
 		xfs_fs_cmn_err(CE_WARN, ip->i_mount,
-			"inode 0x%llx background reclaim flush failed with %d",
+			"inode 0x%llu background reclaim flush failed with %d",
 			(long long)ip->i_ino, error);
 	}
 out:


[0] http://nerdbynature.de/benchmarks/v40z/2010-04-06/
-- 
BOFH excuse #329:

Server depressed, needs Prozac

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
