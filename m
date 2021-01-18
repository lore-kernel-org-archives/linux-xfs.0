Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 846CEC433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 19:20:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CB9822573
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 19:20:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437104AbhARTUQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jan 2021 14:20:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:44816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437210AbhARTTo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Jan 2021 14:19:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8261227C3;
        Mon, 18 Jan 2021 19:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610997544;
        bh=Vy+2GW2hq9PU2Wral57uYu+e+IxxkBhfER1dYKlcmNY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TodGmCPMS8OSXRKdxt1ORlbHCqQIZOMz0fcwe24X9rHh7CLNd9/c0aHGPk7lS/i17
         9/xY3oFVOo8S7+7NBTAWbIGCe+msEODuSUAQXWiCRqafH8aCE3drh+8uHxx6OuVMdN
         Mfh7ptqcVCrZZwzBThqfJuLObxZhs4x+ziR57d/yyhQL+flANCZSWxJOEuDwLDqDXI
         dIs3ldc+yPcBhob/23LI7RqGtQpOrhl7XWsrsH/5mBeLuCox7P+onrVASGMUtO7RFG
         u/ygu6cgq672ReoOh5RKGh5gnJ23WQm8zHKDEePMXY7grCgOVUGW/4tWTaKYAyFTZv
         djLsx0W6a8dPA==
Date:   Mon, 18 Jan 2021 11:19:03 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, chandanrlinux@gmail.com
Subject: [PATCH v2.1 3/4] xfs_scrub: load and unload libicu properly
Message-ID: <20210118191903.GH3134581@magnolia>
References: <161076031261.3386689.3320804567045193864.stgit@magnolia>
 <161076033047.3386689.5046709914905631064.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161076033047.3386689.5046709914905631064.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make sure we actually load and unload libicu properly.  This isn't
strictly required since the library can bootstrap itself, but unloading
means fewer things for valgrind to complain about.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
v2.1: fix error message
---
 scrub/unicrash.c  |   17 +++++++++++++++++
 scrub/unicrash.h  |    4 ++++
 scrub/xfs_scrub.c |    7 +++++++
 3 files changed, 28 insertions(+)

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
index c3a7f385..755afaef 100644
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
+# define unicrash_load()			(0)
+# define unicrash_unload()			do { } while (0)
 #endif /* HAVE_LIBICU */
 
 #endif /* XFS_SCRUB_UNICRASH_H_ */
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 1edeb150..bc2e84a7 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -603,6 +603,12 @@ main(
 	setlocale(LC_ALL, "");
 	bindtextdomain(PACKAGE, LOCALEDIR);
 	textdomain(PACKAGE);
+	if (unicrash_load()) {
+		fprintf(stderr,
+	_("%s: couldn't initialize Unicode library.\n"),
+				progname);
+		goto out;
+	}
 
 	pthread_mutex_init(&ctx.lock, NULL);
 	ctx.mode = SCRUB_MODE_REPAIR;
@@ -788,6 +794,7 @@ main(
 	phase_end(&all_pi, 0);
 	if (progress_fp)
 		fclose(progress_fp);
+	unicrash_unload();
 
 	/*
 	 * If we're being run as a service, the return code must fit the LSB
