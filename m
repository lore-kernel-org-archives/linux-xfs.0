Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32820C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:28:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236387AbiLaD2g (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:28:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236399AbiLaD22 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:28:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2731B1659F
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:28:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3BF5B81E65
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:28:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85FA4C433EF;
        Sat, 31 Dec 2022 03:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672457304;
        bh=yw3fExKVuyY0pVMmSABlQi6DGZsso9cr3W4+fxK90lE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PT8KApzRaxA8y+2vGkWhTakOxRDMNSaXR+atI56fGEw12K8TpQOdmJJ4vP5/08GDE
         SMHuT6j6UnTs5gic7KgWKeIbwomwtNS9MMceUqWLxIpKoEoPEy9gfrvG0vQiq8SE/S
         edYEhO+e76wxtHXaYGQtprGVNCGW3DTCUyk4HER8iOz00aeFUFdKl5CTaVlbC03hWy
         E8Zy/9/6Vhm15+mhMMi2I43o2v/pjsYQZJ0bLmTpGnZyoSSzvnEIko2tetyhkPf6r/
         20IzMpV49uraAdO9d3T0Il6KteW6GRkS0eHC2FsxZqrJooYm5lsCsNB+d2QMaqNxLT
         Par1YqqkWlRkQ==
Subject: [PATCH 2/5] xfs_io: support using fallocate to map free space
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:47 -0800
Message-ID: <167243884791.740087.5840342975132569721.stgit@magnolia>
In-Reply-To: <167243884763.740087.13414287212519500865.stgit@magnolia>
References: <167243884763.740087.13414287212519500865.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Support FALLOC_FL_MAP_FREE_SPACE as a fallocate mode.  This is
experimental code to see if we can build a free space defragmenter out
of this.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/prealloc.c     |   37 +++++++++++++++++++++++++++++++++++++
 man/man8/xfs_io.8 |    8 +++++++-
 2 files changed, 44 insertions(+), 1 deletion(-)


diff --git a/io/prealloc.c b/io/prealloc.c
index 5805897a4a0..02de16651c1 100644
--- a/io/prealloc.c
+++ b/io/prealloc.c
@@ -32,6 +32,10 @@
 #define FALLOC_FL_UNSHARE_RANGE 0x40
 #endif
 
+#ifndef FALLOC_FL_MAP_FREE_SPACE
+#define FALLOC_FL_MAP_FREE_SPACE	(1U << 30)
+#endif
+
 static cmdinfo_t allocsp_cmd;
 static cmdinfo_t freesp_cmd;
 static cmdinfo_t resvsp_cmd;
@@ -44,6 +48,7 @@ static cmdinfo_t fcollapse_cmd;
 static cmdinfo_t finsert_cmd;
 static cmdinfo_t fzero_cmd;
 static cmdinfo_t funshare_cmd;
+static cmdinfo_t fmapfree_cmd;
 #endif
 
 static int
@@ -381,6 +386,28 @@ funshare_f(
 	}
 	return 0;
 }
+
+static int
+fmapfree_f(
+	int		argc,
+	char		**argv)
+{
+	xfs_flock64_t	segment;
+	int		mode = FALLOC_FL_MAP_FREE_SPACE;
+	int		index = 1;
+
+	if (!offset_length(argv[index], argv[index + 1], &segment)) {
+		exitcode = 1;
+		return 0;
+	}
+
+	if (fallocate(file->fd, mode, segment.l_start, segment.l_len)) {
+		perror("fallocate");
+		exitcode = 1;
+		return 0;
+	}
+	return 0;
+}
 #endif	/* HAVE_FALLOCATE */
 
 void
@@ -496,5 +523,15 @@ prealloc_init(void)
 	funshare_cmd.oneline =
 	_("unshares shared blocks within the range");
 	add_command(&funshare_cmd);
+
+	fmapfree_cmd.name = "fmapfree";
+	fmapfree_cmd.cfunc = fmapfree_f;
+	fmapfree_cmd.argmin = 2;
+	fmapfree_cmd.argmax = 2;
+	fmapfree_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
+	fmapfree_cmd.args = _("off len");
+	fmapfree_cmd.oneline =
+	_("maps free space into a file");
+	add_command(&fmapfree_cmd);
 #endif	/* HAVE_FALLOCATE */
 }
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index ece778fc76c..b10523325ee 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -513,8 +513,14 @@ Call fallocate with FALLOC_FL_INSERT_RANGE flag as described in the
 .BR fallocate (2)
 manual page to create the hole by shifting data blocks.
 .TP
+.BI fmapfree " offset length"
+Maps free physical space into the file by calling fallocate with
+the FALLOC_FL_MAP_FREE_SPACE flag as described in the
+.BR fallocate (2)
+manual page.
+.TP
 .BI fpunch " offset length"
-Punches (de-allocates) blocks in the file by calling fallocate with 
+Punches (de-allocates) blocks in the file by calling fallocate with
 the FALLOC_FL_PUNCH_HOLE flag as described in the
 .BR fallocate (2)
 manual page.

