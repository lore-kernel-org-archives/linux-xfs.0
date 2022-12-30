Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B9C8C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:19:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236201AbiLaCTN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:19:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236196AbiLaCTM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:19:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECC5C13F62
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:19:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ACA2DB81E00
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:19:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57383C433D2;
        Sat, 31 Dec 2022 02:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453149;
        bh=NsJJW2B3tT+o9selrXNCllkGy9H1VKMAtk3LFsQfro4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ZMUujddMv2HT/QsQhx7Pn9bHz8ekSfvPiRiEEW3wIlElrcdcvrOmnTweJ2JTsIv1Z
         tNaq2WBeS1vHmREwiTwwdQKUktujK1XHm2KGvTcvNCurEWr7H4Q18nCRL35RkqpccS
         rBS7r49lzxDhGNsQF2K6PSmNm/sMt5f58jjfAvmgOcrtkYME9XBnt+cHdGbBVhWiw7
         trK4DhztePkhmhDxg49NLkfwVUOFxgKRJbVl4Tq1Q67KnLQarlL54g5zaAWDcH2Ljd
         XDau5RLtGWXbc1B2QrH1ofogbp6LWza5nQmlCyiSTjNityvRhdpcXnTJRTPVbH8qvU
         Lk/xlIt6kfDWQ==
Subject: [PATCH 36/46] xfs_repair: update incore metadata state whenever we
 create new files
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:24 -0800
Message-ID: <167243876403.725900.4669059502287609449.stgit@magnolia>
In-Reply-To: <167243875924.725900.7061782826830118387.stgit@magnolia>
References: <167243875924.725900.7061782826830118387.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make sure that we update our incore metadata inode bookkeepping whenever
we create new metadata files.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/phase6.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)


diff --git a/repair/phase6.c b/repair/phase6.c
index 3e740079235..b3ad4074ff8 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -514,6 +514,24 @@ mark_ino_inuse(
 		set_inode_isadir(irec, ino_offset);
 }
 
+/*
+ * Mark a newly allocated inode as metadata in the incore bitmap.  Callers
+ * must have already called mark_ino_inuse to ensure there is an incore record.
+ */
+static void
+mark_ino_metadata(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino)
+{
+	struct ino_tree_node	*irec;
+	int			ino_offset;
+
+	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, ino),
+			XFS_INO_TO_AGINO(mp, ino));
+	ino_offset = get_inode_offset(mp, ino, irec);
+	set_inode_is_meta(irec, ino_offset);
+}
+
 /* Make sure this metadata directory path exists. */
 static int
 ensure_imeta_dirpath(
@@ -547,6 +565,7 @@ ensure_imeta_dirpath(
 		if (ino == NULLFSINO)
 			return ENOENT;
 		mark_ino_inuse(mp, ino, S_IFDIR, parent);
+		mark_ino_metadata(mp, ino);
 		parent = ino;
 	}
 
@@ -663,6 +682,7 @@ _("couldn't create new metadata inode, error %d\n"), error);
 
 	mark_ino_inuse(mp, (*ipp)->i_ino, S_IFREG,
 			lookup_imeta_path_dirname(mp, path));
+	mark_ino_metadata(mp, (*ipp)->i_ino);
 	return 0;
 }
 
@@ -1065,6 +1085,7 @@ mk_metadir(
 
 	libxfs_trans_ijoin(tp, mp->m_metadirip, 0);
 	libxfs_imeta_set_metaflag(tp, mp->m_metadirip);
+	mark_ino_metadata(mp, mp->m_metadirip->i_ino);
 
 	error = -libxfs_trans_commit(tp);
 	if (error)

