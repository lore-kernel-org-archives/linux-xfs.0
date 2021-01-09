Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5B12C433E6
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Jan 2021 06:29:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9929D23A75
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Jan 2021 06:29:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbhAIG3c (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 Jan 2021 01:29:32 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:34818 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbhAIG3b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Jan 2021 01:29:31 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1096NJqB072920;
        Sat, 9 Jan 2021 06:28:49 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 35y3wqr9es-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 09 Jan 2021 06:28:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1096B13x030981;
        Sat, 9 Jan 2021 06:28:48 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 35y49yukgt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 Jan 2021 06:28:48 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 1096SmAZ026385;
        Sat, 9 Jan 2021 06:28:48 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 09 Jan 2021 06:28:48 +0000
Subject: [PATCH 2/3] xfs_scrub: load and unload libicu properly
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 08 Jan 2021 22:28:47 -0800
Message-ID: <161017372698.1142776.3985444129678928114.stgit@magnolia>
In-Reply-To: <161017371478.1142776.6610535704942901172.stgit@magnolia>
References: <161017371478.1142776.6610535704942901172.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9858 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 phishscore=0 malwarescore=0 suspectscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101090040
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9858 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxlogscore=999
 mlxscore=0 phishscore=0 impostorscore=0 spamscore=0 priorityscore=1501
 adultscore=0 bulkscore=0 malwarescore=0 suspectscore=0 clxscore=1034
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101090040
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make sure we actually load and unload libicu properly.  This isn't
strictly required since the library can bootstrap itself, but unloading
means fewer things for valgrind to complain about.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/unicrash.c  |   17 +++++++++++++++++
 scrub/unicrash.h  |    4 ++++
 scrub/xfs_scrub.c |    6 ++++++
 3 files changed, 27 insertions(+)


diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index d5d2cf20..de3217c2 100644
--- a/scrub/unicrash.c
+++ b/scrub/unicrash.c
@@ -722,3 +722,20 @@ unicrash_check_fs_label(
 	return __unicrash_check_name(uc, dsc, _("filesystem label"),
 			label, 0);
 }
+
+/* Load libicu and initialize it. */
+bool
+unicrash_load(void)
+{
+	UErrorCode		uerr = U_ZERO_ERROR;
+
+	u_init(&uerr);
+	return U_FAILURE(uerr);
+}
+
+/* Unload libicu once we're done with it. */
+void
+unicrash_unload(void)
+{
+	u_cleanup();
+}
diff --git a/scrub/unicrash.h b/scrub/unicrash.h
index c3a7f385..32cae3d4 100644
--- a/scrub/unicrash.h
+++ b/scrub/unicrash.h
@@ -25,6 +25,8 @@ int unicrash_check_xattr_name(struct unicrash *uc, struct descr *dsc,
 		const char *attrname);
 int unicrash_check_fs_label(struct unicrash *uc, struct descr *dsc,
 		const char *label);
+bool unicrash_load(void);
+void unicrash_unload(void);
 #else
 # define unicrash_dir_init(u, c, b)		(0)
 # define unicrash_xattr_init(u, c, b)		(0)
@@ -33,6 +35,8 @@ int unicrash_check_fs_label(struct unicrash *uc, struct descr *dsc,
 # define unicrash_check_dir_name(u, d, n)	(0)
 # define unicrash_check_xattr_name(u, d, n)	(0)
 # define unicrash_check_fs_label(u, d, n)	(0)
+# define unicrash_init()			(0)
+# define unicrash_unload()			do { } while (0)
 #endif /* HAVE_LIBICU */
 
 #endif /* XFS_SCRUB_UNICRASH_H_ */
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 1edeb150..6b202912 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -603,6 +603,11 @@ main(
 	setlocale(LC_ALL, "");
 	bindtextdomain(PACKAGE, LOCALEDIR);
 	textdomain(PACKAGE);
+	if (unicrash_load()) {
+		fprintf(stderr,
+			_("%s: could initialize Unicode library.\n"), progname);
+		goto out;
+	}
 
 	pthread_mutex_init(&ctx.lock, NULL);
 	ctx.mode = SCRUB_MODE_REPAIR;
@@ -788,6 +793,7 @@ main(
 	phase_end(&all_pi, 0);
 	if (progress_fp)
 		fclose(progress_fp);
+	unicrash_unload();
 
 	/*
 	 * If we're being run as a service, the return code must fit the LSB

