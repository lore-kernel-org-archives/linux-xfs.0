Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:52988 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727749AbeKBIYd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Nov 2018 04:24:33 -0400
Subject: [PATCH 4/8] dump: don't fail if multi-file dumps don't all contain
 quota info
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 01 Nov 2018 16:19:27 -0700
Message-ID: <154111436733.6577.618179444183829859.stgit@magnolia>
In-Reply-To: <154111434286.6577.15010861884505931015.stgit@magnolia>
References: <154111434286.6577.15010861884505931015.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When xfsdump is making multi-file dumps, the quota information are
written into the last dump file.  However, the multi-file restore script
(as written) expects to see quota information restored by every dump
file and fails.  This is silly, so fix it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/dump |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)


diff --git a/common/dump b/common/dump
index b6b7fb46..c45b8a5a 100644
--- a/common/dump
+++ b/common/dump
@@ -1432,16 +1432,19 @@ _check_quota()
 			    print "Found extra:", $0
 			}
 			next
+	}
+	$0 ~ "Restore Status: INCOMPLETE" {
+			incomplete = 1
 	}
 			{ print }
 	END {
-		if (uquota && !found_uquota) {
+		if (uquota && !found_uquota && !incomplete) {
 		    print "Missing user quota msg:", usermsg
 		}
-		if (gquota && !found_gquota) {
+		if (gquota && !found_gquota && !incomplete) {
 		    print "Missing group quota msg:", groupmsg
 		}
-		if (pquota && !found_pquota) {
+		if (pquota && !found_pquota && !incomplete) {
 		    print "Missing project quota msg:", projectmsg
 		}
 	}
