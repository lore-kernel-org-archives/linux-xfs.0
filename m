Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:50164 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbfCTTgh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Mar 2019 15:36:37 -0400
Date: Wed, 20 Mar 2019 12:36:30 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 41/36] xfs_repair: better cli option parameter checking
Message-ID: <20190320193630.GE1183@magnolia>
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

For the xfs_repair options that require a parameter, check that the user
actually provided one instead of segfaulting.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/xfs_repair.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 2d333d50..9657503f 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -233,10 +233,16 @@ process_args(int argc, char **argv)
 					if (max_mem_specified)
 						do_abort(
 		_("-o bhash option cannot be used with -m option\n"));
+					if (!val)
+						do_abort(
+		_("-o bhash requires a parameter\n"));
 					libxfs_bhash_size = (int)strtol(val, NULL, 0);
 					bhash_option_used = 1;
 					break;
 				case AG_STRIDE:
+					if (!val)
+						do_abort(
+		_("-o ag_stride requires a parameter\n"));
 					ag_stride = (int)strtol(val, NULL, 0);
 					break;
 				case FORCE_GEO:
@@ -247,6 +253,9 @@ process_args(int argc, char **argv)
 					force_geo = 1;
 					break;
 				case PHASE2_THREADS:
+					if (!val)
+						do_abort(
+		_("-o phase2_threads requires a parameter\n"));
 					phase2_threads = (int)strtol(val, NULL, 0);
 					break;
 				default:
@@ -262,6 +271,9 @@ process_args(int argc, char **argv)
 
 				switch (getsubopt(&p, c_opts, &val)) {
 				case CONVERT_LAZY_COUNT:
+					if (!val)
+						do_abort(
+		_("-c lazycount requires a parameter\n"));
 					lazy_count = (int)strtol(val, NULL, 0);
 					convert_lazy_count = 1;
 					break;
