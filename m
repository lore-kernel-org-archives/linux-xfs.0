Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61FA1C433E9
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 04:20:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34A7664EB4
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 04:20:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbhBIETj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Feb 2021 23:19:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:48742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230088AbhBIEQR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Feb 2021 23:16:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81CFB64ECE;
        Tue,  9 Feb 2021 04:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612843893;
        bh=7gTwqibLFyk45k9HtBOPPnfeZjkEv7vyLWCVVnXOcIc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=D+IdcTPJd/myeKzbmaTPMB6Q7bzr0FWtLqkhQ0qCYCj0sIdC+6dO0GOn5Po5/5SMG
         AlV3MKLA3UOuorpLkdaTluO3sGA/MJyKTX383H7aYZmh1KFUB9eM9QBOK77qpxoo8P
         r+NqpOwWMdaCZ29r5B9KaLjvvp70yafGsW6rBJf8Yb2PXhUTXwrmj7n2IKSWNUH49k
         5sGS1Sd5raA01gWSBsznqaxVQ/areDhge1j1CZ8WypJMbVSIzp+cm2R0TelbJMjyUa
         UUSPHcWVCf6jRStLSFdMWzJnsrd5a/Iw6sYPT5TnCb/fS/tWA72NUSYvAsVVY4J0/4
         SsxybzlHSjS7w==
Subject: [PATCH 3/6] xfs_scrub: load and unload libicu properly
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, chandanrlinux@gmail.com,
        Chaitanya.Kulkarni@wdc.com
Date:   Mon, 08 Feb 2021 20:11:33 -0800
Message-ID: <161284389311.3058224.3454694766420244067.stgit@magnolia>
In-Reply-To: <161284387610.3058224.6236053293202575597.stgit@magnolia>
References: <161284387610.3058224.6236053293202575597.stgit@magnolia>
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
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
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

