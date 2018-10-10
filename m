Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56220 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727776AbeJKDZV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Oct 2018 23:25:21 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 14/18] xfs_logprint: fix shadow var in xlog_print_trans_buffer
Date: Wed, 10 Oct 2018 15:01:18 -0500
Message-Id: <1539201682-22198-15-git-send-email-sandeen@redhat.com>
In-Reply-To: <1539201682-22198-1-git-send-email-sandeen@redhat.com>
References: <1539201682-22198-1-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

xlog_print_trans_buffer takes 'i' as an argument, but then uses it later
as a local byte counter.  Give the local var more useful, non-shadow
name of "byte"

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 logprint/log_misc.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 99d9920..c325f04 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -395,15 +395,15 @@ xlog_print_trans_buffer(char **ptr, int len, int *i, int num_ops)
 		if (print_data) {
 			uint *dp  = (uint *)*ptr;
 			int  nums = be32_to_cpu(head->oh_len) >> 2;
-			int  i = 0;
+			int  byte = 0;
 
-			while (i < nums) {
-				if ((i % 8) == 0)
-					printf("%2x ", i);
+			while (byte < nums) {
+				if ((byte % 8) == 0)
+					printf("%2x ", byte);
 				printf("%8x ", *dp);
 				dp++;
-				i++;
-				if ((i % 8) == 0)
+				byte++;
+				if ((byte % 8) == 0)
 					printf("\n");
 			}
 			printf("\n");
-- 
1.8.3.1
