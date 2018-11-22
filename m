Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:36778 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395487AbeKWEjK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Nov 2018 23:39:10 -0500
Subject: [PATCH 01/12] fsstress: fix compiler warnings
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 22 Nov 2018 09:58:28 -0800
Message-ID: <154290950874.1218.16162093723366805081.stgit@magnolia>
In-Reply-To: <154290950237.1218.9937108728673485814.stgit@magnolia>
References: <154290950237.1218.9937108728673485814.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix all the gcc warnings in fsstress.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
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
