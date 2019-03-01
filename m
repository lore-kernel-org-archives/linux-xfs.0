Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:41850 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbfCAX1V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Mar 2019 18:27:21 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x21NP8WJ123288
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:27:20 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2qtupetehw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 01 Mar 2019 23:27:20 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x21NREbp006084
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:27:15 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x21NREBK007595
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:27:14 GMT
Subject: [PATCH 04/23] xfs_scrub_all: walk the lsblk device/fs hierarchy
 correctly
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 01 Mar 2019 15:27:13 -0800
Message-ID: <155148283348.16677.13557626525564289346.stgit@magnolia>
In-Reply-To: <155148280859.16677.6057998944865066232.stgit@magnolia>
References: <155148280859.16677.6057998944865066232.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

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
