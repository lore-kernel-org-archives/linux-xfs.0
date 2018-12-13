Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:36318 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726442AbeLMVa4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Dec 2018 16:30:56 -0500
Date: Thu, 13 Dec 2018 13:30:50 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs_scrub_all: walk the lsblk device/fs hierarchy correctly
Message-ID: <20181213213050.GD24487@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Back when I was designing xfs_scrub_all, I naïvely assumed that the
emitted output would always list physical storage before the virtual
devices stacked atop it.  However, this is not actually true when one
omits the "NAME" column, which is crucial to forcing the output (json or
otherwise) to capture the block device hierarchy.  If the assumption is
violated, the program crashes with a python exception.

To fix this, force the hierarchal json output and restructure the
discovery routines to walk the json object that we receive, from the top
(physical devices) downwards to wherever there are live xfs filesystems.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/xfs_scrub_all.in |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
index c4e9899d..5b76b49a 100644
--- a/scrub/xfs_scrub_all.in
+++ b/scrub/xfs_scrub_all.in
@@ -28,9 +28,21 @@ def DEVNULL():
 
 def find_mounts():
 	'''Map mountpoints to physical disks.'''
+	def find_xfs_mounts(bdev, fs, lastdisk):
+		'''Attach lastdisk to each fs found under bdev.'''
+		if bdev['fstype'] == 'xfs' and bdev['mountpoint'] is not None:
+			mnt = bdev['mountpoint']
+			if mnt in fs:
+				fs[mnt].add(lastdisk)
+			else:
+				fs[mnt] = set([lastdisk])
+		if 'children' not in bdev:
+			return
+		for child in bdev['children']:
+			find_xfs_mounts(child, fs, lastdisk)
 
 	fs = {}
-	cmd=['lsblk', '-o', 'KNAME,TYPE,FSTYPE,MOUNTPOINT', '-J']
+	cmd=['lsblk', '-o', 'NAME,KNAME,TYPE,FSTYPE,MOUNTPOINT', '-J']
 	result = subprocess.Popen(cmd, stdout=subprocess.PIPE)
 	result.wait()
 	if result.returncode != 0:
@@ -38,18 +50,12 @@ def find_mounts():
 	sarray = [x.decode(sys.stdout.encoding) for x in result.stdout.readlines()]
 	output = ' '.join(sarray)
 	bdevdata = json.loads(output)
+
 	# The lsblk output had better be in disks-then-partitions order
 	for bdev in bdevdata['blockdevices']:
-		if bdev['type'] in ('disk', 'loop'):
-			lastdisk = bdev['kname']
-		if bdev['fstype'] == 'xfs':
-			mnt = bdev['mountpoint']
-			if mnt is None:
-				continue
-			if mnt in fs:
-				fs[mnt].add(lastdisk)
-			else:
-				fs[mnt] = set([lastdisk])
+		lastdisk = bdev['kname']
+		find_xfs_mounts(bdev, fs, lastdisk)
+
 	return fs
 
 def kill_systemd(unit, proc):
