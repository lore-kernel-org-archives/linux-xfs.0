Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:49752 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728310AbeKJK2z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 10 Nov 2018 05:28:55 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAA0jcpE089407
        for <linux-xfs@vger.kernel.org>; Sat, 10 Nov 2018 00:45:48 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2nh3mq9tr6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 10 Nov 2018 00:45:48 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wAA0jlsg017835
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 10 Nov 2018 00:45:47 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wAA0jl6L031644
        for <linux-xfs@vger.kernel.org>; Sat, 10 Nov 2018 00:45:47 GMT
Subject: [PATCH 5/6] xfs_scrub: fix fractional reporting of single inodes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 09 Nov 2018 16:45:46 -0800
Message-ID: <154181074665.3727.1071882240761223896.stgit@magnolia>
In-Reply-To: <154181071499.3727.3910572718199592407.stgit@magnolia>
References: <154181071499.3727.3910572718199592407.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When there are fewer than 1024 inodes in the filesystem, scrub reports
fractional inodes in its final report:

35.2MiB data used;  5.0 inodes used.
34.2MiB data found; 5.0 inodes found.
5.0 inodes counted; 5.0 inodes checked.

Inodes are indivisible, so only report the fractional part when we have
a large enough number of inodes to perform a unit conversion:

35.2MiB data used;  5 inodes used.
34.2MiB data found; 5 inodes found.
5 inodes counted; 5 inodes checked.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/common.c |    5 ++++-
 scrub/common.h |    2 +-
 scrub/phase7.c |   34 ++++++++++++++++++----------------
 3 files changed, 23 insertions(+), 18 deletions(-)


diff --git a/scrub/common.c b/scrub/common.c
index 96b86a26..78afc4bf 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -200,10 +200,12 @@ auto_space_units(
 double
 auto_units(
 	unsigned long long	number,
-	char			**units)
+	char			**units,
+	int			*precision)
 {
 	if (debug > 1)
 		goto no_prefix;
+	*precision = 1;
 	if (number > 1000000000000ULL) {
 		*units = "T";
 		return number / 1000000000000.0;
@@ -220,6 +222,7 @@ auto_units(
 
 no_prefix:
 	*units = "";
+	*precision = 0;
 	return number;
 }
 
diff --git a/scrub/common.h b/scrub/common.h
index 5a43ac0c..e85a0333 100644
--- a/scrub/common.h
+++ b/scrub/common.h
@@ -62,7 +62,7 @@ debug_tweak_on(
 
 double timeval_subtract(struct timeval *tv1, struct timeval *tv2);
 double auto_space_units(unsigned long long kilobytes, char **units);
-double auto_units(unsigned long long number, char **units);
+double auto_units(unsigned long long number, char **units, int *precision);
 unsigned int scrub_nproc(struct scrub_ctx *ctx);
 unsigned int scrub_nproc_workqueue(struct scrub_ctx *ctx);
 
diff --git a/scrub/phase7.c b/scrub/phase7.c
index cac0c75a..504a6927 100644
--- a/scrub/phase7.c
+++ b/scrub/phase7.c
@@ -107,6 +107,7 @@ xfs_scan_summary(
 	unsigned long long		f_free;
 	bool				moveon;
 	bool				complain;
+	int				ip;
 	int				error;
 
 	/* Flush everything out to disk before we start counting. */
@@ -176,27 +177,27 @@ xfs_scan_summary(
 		if (used_rt || stat_rt) {
 			d = auto_space_units(used_data, &du);
 			r = auto_space_units(used_rt, &ru);
-			i = auto_units(used_files, &iu);
+			i = auto_units(used_files, &iu, &ip);
 			fprintf(stdout,
-_("%.1f%s data used;  %.1f%s realtime data used;  %.2f%s inodes used.\n"),
-					d, du, r, ru, i, iu);
+_("%.1f%s data used;  %.1f%s realtime data used;  %.*f%s inodes used.\n"),
+					d, du, r, ru, ip, i, iu);
 			d = auto_space_units(stat_data, &du);
 			r = auto_space_units(stat_rt, &ru);
-			i = auto_units(counted_inodes, &iu);
+			i = auto_units(counted_inodes, &iu, &ip);
 			fprintf(stdout,
-_("%.1f%s data found; %.1f%s realtime data found; %.2f%s inodes found.\n"),
-					d, du, r, ru, i, iu);
+_("%.1f%s data found; %.1f%s realtime data found; %.*f%s inodes found.\n"),
+					d, du, r, ru, ip, i, iu);
 		} else {
 			d = auto_space_units(used_data, &du);
-			i = auto_units(used_files, &iu);
+			i = auto_units(used_files, &iu, &ip);
 			fprintf(stdout,
-_("%.1f%s data used;  %.1f%s inodes used.\n"),
-					d, du, i, iu);
+_("%.1f%s data used;  %.*f%s inodes used.\n"),
+					d, du, ip, i, iu);
 			d = auto_space_units(stat_data, &du);
-			i = auto_units(counted_inodes, &iu);
+			i = auto_units(counted_inodes, &iu, &ip);
 			fprintf(stdout,
-_("%.1f%s data found; %.1f%s inodes found.\n"),
-					d, du, i, iu);
+_("%.1f%s data found; %.*f%s inodes found.\n"),
+					d, du, ip, i, iu);
 		}
 		fflush(stdout);
 	}
@@ -210,12 +211,13 @@ _("%.1f%s data found; %.1f%s inodes found.\n"),
 			_("checked inodes"))) {
 		double		i1, i2;
 		char		*i1u, *i2u;
+		int		i1p, i2p;
 
-		i1 = auto_units(counted_inodes, &i1u);
-		i2 = auto_units(ctx->inodes_checked, &i2u);
+		i1 = auto_units(counted_inodes, &i1u, &i1p);
+		i2 = auto_units(ctx->inodes_checked, &i2u, &i2p);
 		fprintf(stdout,
-_("%.1f%s inodes counted; %.1f%s inodes checked.\n"),
-				i1, i1u, i2, i2u);
+_("%.*f%s inodes counted; %.*f%s inodes checked.\n"),
+				i1p, i1, i1u, i2p, i2, i2u);
 		fflush(stdout);
 	}
 
