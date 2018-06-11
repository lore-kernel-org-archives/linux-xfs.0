Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from tyo162.gate.nec.co.jp ([114.179.232.162]:45438 "EHLO
        tyo162.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753797AbeFKFlH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jun 2018 01:41:07 -0400
From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH] xfs_quota: fix -d option to limit directory depth correctly
Date: Mon, 11 Jun 2018 05:39:59 +0000
Message-ID: <C26C67884C4B7A48980D5746355948640347D54C@BPXM20GP.gisp.nec.co.jp>
Content-Language: ja-JP
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "darrick.wong@oracle.com" <darrick.wong@oracle.com>

xfs_quota -x -c "project -d DEPTH" stops in the middle of its operation
if a directory whose level is more than DEPTH was found.

To set/check/clear a project quota, xfs_quota performs pre-order tree traversal
by using nftw(3). However, if the directory whose level is more than
the recursion level specified by -d option is found, the function called
by nftw() returns -1 and nftw() stops the tree walk.

The following steps show that only one directory is set a project quota,
even though another directory whose level is the same as the recursion level
isn't set a project quota.

# mkfs.xfs -f /dev/sdb1
# mount -o pquota /dev/sdb1 /mnt
# mkdir -p /mnt/pquota/dirA/dirAA /mnt/pquota/dirB/dirBB
# xfs_quota -x -c "project -d 1 -s -p /mnt/pquota 100" 
# xfs_io -c stat /mnt/pquota/dirA | grep projid
fsxattr.projid = 100
# xfs_io -c stat /mnt/pquota/dirB | grep projid
fsxattr.projid = 0

To fix above problem, if the directory whose level is more than the recursion
level is found, the function called by nftw() returns 0 instead of -1.

Note that the time of tree traversal is the same as no limitation of
recursion level. To reduce the time, we have to use FTW_SKIP_SUBTREE
that is glibc-specified flag. Is it better to use this flag?

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
 quota/project.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)
diff --git a/quota/project.c b/quota/project.c
index e4e7a01..20bc01b 100644
--- a/quota/project.c
+++ b/quota/project.c
@@ -101,7 +101,7 @@ check_project(
 	int			fd;
 
 	if (recurse_depth >= 0 && data->level > recurse_depth)
-		return -1;
+		return 0;
 
 	if (flag == FTW_NS ){
 		exitcode = 1;
@@ -146,7 +146,7 @@ clear_project(
 	int			fd;
 
 	if (recurse_depth >= 0 && data->level > recurse_depth)
-		return -1;
+		return 0;
 
 	if (flag == FTW_NS ){
 		exitcode = 1;
@@ -193,7 +193,7 @@ setup_project(
 	int			fd;
 
 	if (recurse_depth >= 0 && data->level > recurse_depth)
-		return -1;
+		return 0;
 
 	if (flag == FTW_NS ){
 		exitcode = 1;

