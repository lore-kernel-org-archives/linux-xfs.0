Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from tyo162.gate.nec.co.jp ([114.179.232.162]:40678 "EHLO
        tyo162.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750934AbeFVIqf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Jun 2018 04:46:35 -0400
From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH v2] xfs_quota: don't stop the directory tree walk when DEPTH
 is hit
Date: Fri, 22 Jun 2018 08:44:21 +0000
Message-ID: <C26C67884C4B7A48980D574635594864034842C9@BPXM20GP.gisp.nec.co.jp>
Content-Language: ja-JP
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

To set/check/clear a project quota, xfs_quota performs a pre-order tree
traversal by using nftw(3).  The documentation states that the -d option
can be used to skip subtrees below a certain level in the directory
hierarchy.  Unfortunately, {check,setup,clear}_project returns -1 when
DEPTH is hit, which stops the directory tree walk immediately.  We only
wanted to skip the subtree, so return 0 instead.

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
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


