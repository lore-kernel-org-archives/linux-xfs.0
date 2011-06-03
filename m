Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p53DqxET015077 for <xfs@oss.sgi.com>; Fri, 3 Jun 2011 08:52:59 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2EDA41688658
	for <xfs@oss.sgi.com>; Fri,  3 Jun 2011 06:52:56 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id rrI93nEh0fDLXMxE for <xfs@oss.sgi.com>;
	Fri, 03 Jun 2011 06:52:56 -0700 (PDT)
From: David Sterba <dsterba@suse.cz>
Subject: [PATCH] xfstests: fix hardcoded path in output of 254
Date: Fri,  3 Jun 2011 15:52:42 +0200
Message-Id: <1307109162-21811-1-git-send-email-dsterba@suse.cz>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, David Sterba <dsterba@suse.cz>, josef@redhat.com

Add filters after btrfs commands, else the test would incorrectly appear
failed.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 254     |   13 +++++++------
 254.out |    6 +++---
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/254 b/254
index 3c1a5a1..6320291 100755
--- a/254
+++ b/254
@@ -40,6 +40,7 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common.rc
+. ./common.filter
 
 # real QA test starts here
 _supported_fs btrfs
@@ -55,7 +56,7 @@ dd if=/dev/zero of=$SCRATCH_MNT/foo bs=1M count=1 &> /dev/null
 echo "List root dir"
 ls $SCRATCH_MNT
 echo "Creating snapshot of root dir"
-btrfs subvolume snapshot $SCRATCH_MNT $SCRATCH_MNT/snap
+btrfs subvolume snapshot $SCRATCH_MNT $SCRATCH_MNT/snap | _filter_scratch
 echo "List root dir after snapshot"
 ls $SCRATCH_MNT
 echo "List snapshot dir"
@@ -67,7 +68,7 @@ echo "List snapshot dir"
 ls $SCRATCH_MNT/snap
 
 # Test creating a normal subvolme
-btrfs subvolume create $SCRATCH_MNT/subvol
+btrfs subvolume create $SCRATCH_MNT/subvol | _filter_scratch
 echo "Listing root dir"
 ls $SCRATCH_MNT
 echo "Listing subvol"
@@ -77,7 +78,7 @@ ls $SCRATCH_MNT/subvol
 echo "Creating file bar in subvol"
 dd if=/dev/zero of=$SCRATCH_MNT/subvol/bar bs=1M count=1 &> /dev/null
 echo "Setting subvol to the default"
-btrfs subvolume set-default $SCRATCH_MNT/subvol $SCRATCH_MNT/subvol
+btrfs subvolume set-default $SCRATCH_MNT/subvol $SCRATCH_MNT/subvol | _filter_scratch
 _scratch_remount
 echo "List root dir which is now subvol"
 ls $SCRATCH_MNT
@@ -87,17 +88,17 @@ _scratch_mount "-o subvolid=0"
 echo "List root dir"
 ls $SCRATCH_MNT
 echo "Setting the root dir as the default again"
-btrfs subvolume set-default $SCRATCH_MNT $SCRATCH_MNT
+btrfs subvolume set-default $SCRATCH_MNT $SCRATCH_MNT | _filter_scratch
 _scratch_remount
 echo "List root dir"
 ls $SCRATCH_MNT
 
 # Test listing the subvolumes
 echo "Listing subvolumes"
-btrfs subvolume list $SCRATCH_MNT
+btrfs subvolume list $SCRATCH_MNT | _filter_scratch
 
 # Delete the snapshot
-btrfs subvolume delete $SCRATCH_MNT/snap
+btrfs subvolume delete $SCRATCH_MNT/snap | _filter_scratch
 echo "List root dir"
 ls $SCRATCH_MNT
 _scratch_remount
diff --git a/254.out b/254.out
index e1c19ee..582357a 100644
--- a/254.out
+++ b/254.out
@@ -3,7 +3,7 @@ Creating file foo in root dir
 List root dir
 foo
 Creating snapshot of root dir
-Create a snapshot of '/mnt/scratch' in '/mnt/scratch/snap'
+Create a snapshot of 'SCRATCH_MNT' in 'SCRATCH_MNT/snap'
 List root dir after snapshot
 foo
 snap
@@ -13,7 +13,7 @@ List root dir after rm of foo
 snap
 List snapshot dir
 foo
-Create subvolume '/mnt/scratch/subvol'
+Create subvolume 'SCRATCH_MNT/subvol'
 Listing root dir
 snap
 subvol
@@ -33,7 +33,7 @@ subvol
 Listing subvolumes
 ID 256 top level 5 path snap
 ID 257 top level 5 path subvol
-Delete subvolume '/mnt/scratch/snap'
+Delete subvolume 'SCRATCH_MNT/snap'
 List root dir
 subvol
 List root dir
-- 
1.7.5.2.353.g5df3e

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
