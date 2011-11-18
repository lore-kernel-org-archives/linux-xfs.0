Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAI3Orpb089079 for <xfs@oss.sgi.com>; Thu, 17 Nov 2011 21:24:54 -0600
Received: from song.cn.fujitsu.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A7B931D1743D
	for <xfs@oss.sgi.com>; Thu, 17 Nov 2011 19:24:48 -0800 (PST)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id mAlkhtiolZk3483y for
	<xfs@oss.sgi.com>; Thu, 17 Nov 2011 19:24:48 -0800 (PST)
Message-ID: <4EC5D05A.4000503@cn.fujitsu.com>
Date: Fri, 18 Nov 2011 11:26:18 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
MIME-Version: 1.0
Subject: [PATCH] 254: fix to pass subvolid=0 to set default btrfs subvolme
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

The usage is 'btrfs subvolume set-default <id> <path>', not
'<path> <path>'.

The code happens to work because strotoull(path) returns 0, but it
will fail if in the future we check the argument more strict in
btrfs-progs.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 254 |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/254 b/254
index 6320291..5216120 100755
--- a/254
+++ b/254
@@ -78,7 +78,7 @@ ls $SCRATCH_MNT/subvol
 echo "Creating file bar in subvol"
 dd if=/dev/zero of=$SCRATCH_MNT/subvol/bar bs=1M count=1 &> /dev/null
 echo "Setting subvol to the default"
-btrfs subvolume set-default $SCRATCH_MNT/subvol $SCRATCH_MNT/subvol | _filter_scratch
+btrfs subvolume set-default 0 $SCRATCH_MNT/subvol | _filter_scratch
 _scratch_remount
 echo "List root dir which is now subvol"
 ls $SCRATCH_MNT
@@ -88,7 +88,7 @@ _scratch_mount "-o subvolid=0"
 echo "List root dir"
 ls $SCRATCH_MNT
 echo "Setting the root dir as the default again"
-btrfs subvolume set-default $SCRATCH_MNT $SCRATCH_MNT | _filter_scratch
+btrfs subvolume set-default 0 $SCRATCH_MNT | _filter_scratch
 _scratch_remount
 echo "List root dir"
 ls $SCRATCH_MNT
-- 1.7.3.1 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
