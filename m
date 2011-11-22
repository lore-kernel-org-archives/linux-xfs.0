Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAM5HvtE118745 for <xfs@oss.sgi.com>; Mon, 21 Nov 2011 23:17:58 -0600
Received: from song.cn.fujitsu.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0F99F26B674
	for <xfs@oss.sgi.com>; Mon, 21 Nov 2011 21:17:55 -0800 (PST)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id GKAA0exzQAbGnCFT for
	<xfs@oss.sgi.com>; Mon, 21 Nov 2011 21:17:55 -0800 (PST)
Message-ID: <4ECB30EB.7010109@cn.fujitsu.com>
Date: Tue, 22 Nov 2011 13:19:39 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
MIME-Version: 1.0
Subject: [PATCH v2] 254: avoid output mismatch due to space cache
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
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com

This reverts commit a0c92a5871082c0aa6a7caae496e67a6e57bb0b6 (disable
space cache), as option nospace_cache was newly introduced in linux-3.2,
so we'll fail to mount btrfs in older kernels.

As an alternative fix, we just list subvolme names, don't assume
what ID numbers those subvolumes will have.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 254     |    4 ++--
 254.out |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/254 b/254
index 1cd4832..7b74a02 100755
--- a/254
+++ b/254
@@ -48,7 +48,7 @@ _supported_os Linux
 _require_scratch
 
 _scratch_mkfs > /dev/null 2>&1
-_scratch_mount -o nospace_cache
+_scratch_mount
 
 # First test basic snapshotting
 echo "Creating file foo in root dir"
@@ -95,7 +95,7 @@ ls $SCRATCH_MNT
 
 # Test listing the subvolumes
 echo "Listing subvolumes"
-btrfs subvolume list $SCRATCH_MNT | _filter_scratch
+btrfs subvolume list $SCRATCH_MNT | awk '{ print $NF }'
 
 # Delete the snapshot
 btrfs subvolume delete $SCRATCH_MNT/snap | _filter_scratch
diff --git a/254.out b/254.out
index 582357a..d4b5346 100644
--- a/254.out
+++ b/254.out
@@ -31,8 +31,8 @@ List root dir
 snap
 subvol
 Listing subvolumes
-ID 256 top level 5 path snap
-ID 257 top level 5 path subvol
+snap
+subvol
 Delete subvolume 'SCRATCH_MNT/snap'
 List root dir
 subvol
-- 
1.7.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
