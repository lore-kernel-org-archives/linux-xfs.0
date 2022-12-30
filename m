Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD110C3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:35:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236247AbiLaCfH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:35:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236284AbiLaCe7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:34:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44F1A1CB26
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:34:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D661C61D07
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:34:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B4FC433D2;
        Sat, 31 Dec 2022 02:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454098;
        bh=iQnAKE2TExEqtcf8s79a2JK9sgknTSWJvcKivkWyFmk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=djGywbHIxCvQ65qGLRmLWvYr2WQYbe0iPS5ZQyNWfJJSmpOKgCAnhfbyTYoBj1oOD
         4N9ETwyFAvT5gYBhqBb4iVthNl8LCh1mns0AYvlVEB4/Mk3ovF8PGzxmblfpKKgQHU
         HVS5Djbhu6zKnWGZ3AO5i8QGLuuZpoZbUt1wAX01edIj3Wz2RLa4R+z6Xh0N1mKcGR
         6aLVsUy7xdWQsTlu59suQfCdXx76zBZDuQR4+s/q/19QKu/FU1NTV+z/z9SovbuxR+
         e5MsdbRF8E7GuuMvs4gbX+vGtvYtQA+APhITDg6GM2vKaGDGL0cz0br4TXpOP7ZNgU
         D6mmb6Auab8ew==
Subject: [PATCH 19/45] xfs: scrub the rtbitmap by group
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:46 -0800
Message-ID: <167243878615.731133.13852321164499144680.stgit@magnolia>
In-Reply-To: <167243878346.731133.14642166452774753637.stgit@magnolia>
References: <167243878346.731133.14642166452774753637.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Reduce the amount of time that the kernel spends with the rtbitmap
locked for a scrub by splitting the work by rtgroup.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/scrub.c |    5 +++++
 libxfs/xfs_fs.h |    3 ++-
 2 files changed, 7 insertions(+), 1 deletion(-)


diff --git a/libfrog/scrub.c b/libfrog/scrub.c
index 7d6c9c69e4a..7efb7ecfbd0 100644
--- a/libfrog/scrub.c
+++ b/libfrog/scrub.c
@@ -154,6 +154,11 @@ const struct xfrog_scrub_descr xfrog_scrubbers[XFS_SCRUB_TYPE_NR] = {
 		.descr	= "realtime group superblock",
 		.group	= XFROG_SCRUB_GROUP_RTGROUP,
 	},
+	[XFS_SCRUB_TYPE_RGBITMAP] = {
+		.name	= "rgbitmap",
+		.descr	= "realtime group bitmap",
+		.group	= XFROG_SCRUB_GROUP_RTGROUP,
+	},
 };
 #undef DEP
 
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index c12be9dbb59..7e9d7d7bb40 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -742,9 +742,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_NLINKS	26	/* inode link counts */
 #define XFS_SCRUB_TYPE_HEALTHY	27	/* everything checked out ok */
 #define XFS_SCRUB_TYPE_RGSUPER	28	/* realtime superblock */
+#define XFS_SCRUB_TYPE_RGBITMAP	29	/* realtime group bitmap */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	29
+#define XFS_SCRUB_TYPE_NR	30
 
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1u << 0)

