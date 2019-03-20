Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:49770 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfCTTgK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Mar 2019 15:36:10 -0400
Date: Wed, 20 Mar 2019 12:36:08 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 40/36] xfs_io: fix label parsing and validation
Message-ID: <20190320193608.GD1183@magnolia>
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155259742281.31886.17157720770696604377.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When we're trying to set a new label, check the length to make sure we
won't overflow the label size, and size label[] so that we can use
strncpy without static checker complaints.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 io/label.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/io/label.c b/io/label.c
index 602ece89..72e07964 100644
--- a/io/label.c
+++ b/io/label.c
@@ -40,7 +40,7 @@ label_f(
 {
 	int		c;
 	int		error;
-	char		label[FSLABEL_MAX];
+	char		label[FSLABEL_MAX + 1];
 
 	if (argc == 1) {
 		memset(label, 0, sizeof(label));
@@ -54,7 +54,13 @@ label_f(
 			label[0] = '\0';
 			break;
 		case 's':
-			strncpy(label, optarg, sizeof(label));
+			if (strlen(optarg) > FSLABEL_MAX) {
+				errno = EINVAL;
+				error = 1;
+				goto out;
+			}
+			strncpy(label, optarg, sizeof(label) - 1);
+			label[sizeof(label) - 1] = 0;
 			break;
 		default:
 			return command_usage(&label_cmd);
