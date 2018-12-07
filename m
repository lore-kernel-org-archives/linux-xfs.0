Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:56314 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725952AbeLGGXa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Dec 2018 01:23:30 -0500
Subject: [PATCH 01/12] fsstress: fix compiler warnings
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 06 Dec 2018 22:23:18 -0800
Message-ID: <154416379882.15344.9436421202591701307.stgit@magnolia>
In-Reply-To: <154416379233.15344.4377231692638417530.stgit@magnolia>
References: <154416379233.15344.4377231692638417530.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Allison Henderson <allison.henderson@oracle.com>, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix all the gcc warnings in fsstress, and resize buffers to avoid
overflows.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-By: Allison Henderson <allison.henderson@oracle.com>
---
 ltp/fsstress.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index edbb3f2f..8d0734fc 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -499,7 +499,7 @@ int main(int argc, char **argv)
 		exit(1);
 	}
 	if (logname) {
-		char path[PATH_MAX];
+		char path[PATH_MAX + NAME_MAX + 1];
 		snprintf(path, sizeof(path), "%s/%s", rpath, logname);
 		if (freopen(path, "a", stdout) == NULL) {
 			perror("freopen logfile failed");
@@ -583,7 +583,7 @@ int main(int argc, char **argv)
 				return 0;
 #endif
 			if (logname) {
-				char path[PATH_MAX];
+				char path[PATH_MAX + NAME_MAX + 2 + 11];
 				snprintf(path, sizeof(path), "%s/%s.%d",
 					 rpath, logname, i);
 				if (freopen(path, "a", stdout) == NULL) {
