Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E10B1C433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Jan 2021 01:26:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB32B229F0
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Jan 2021 01:26:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbhAPB0M (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Jan 2021 20:26:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:33422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726065AbhAPB0L (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 15 Jan 2021 20:26:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1EDDF23A3C;
        Sat, 16 Jan 2021 01:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610760331;
        bh=ahcbQYVzrBCXh2QVwbX83c7omNsekVJ6MhHg83FQFoI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=L9EEdaGK9kPU6IPbYVURsokLOsv7QbRpOVHciIx9B8lv0FFUoiHKFumrPZfW0Eo2z
         Y2yRubeinl12bn+MgyohJPPKTMAjtLUEnzFU0eUMrqBoPEtVffp0zIJouNNIFXJhuV
         hbx/HmWi3ajr7oFi/nqVeq9m9/uVS6y3la4Qa/NvfCo9eQBHBxLYNHBBPAV/PVoNZc
         T08EX878642Cdc+yBRlNRIkO0iSBaRmLpuEf5auAuWIUQxAQAW+i6SJmi07df5vfIh
         fWcbJmvhgBLrzYdv4aKrqAFhn2SVVdCSa0x0lK/I4piUEPoE3S9m5IDyKZfMt+ch0e
         yO52Ullx0lrFQ==
Subject: [PATCH 3/4] xfs_scrub: load and unload libicu properly
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 15 Jan 2021 17:25:30 -0800
Message-ID: <161076033047.3386689.5046709914905631064.stgit@magnolia>
In-Reply-To: <161076031261.3386689.3320804567045193864.stgit@magnolia>
References: <161076031261.3386689.3320804567045193864.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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

