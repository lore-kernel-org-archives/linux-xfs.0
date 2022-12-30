Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CFF8C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:21:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236210AbiLaCVB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:21:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236211AbiLaCU7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:20:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68CEA12D34
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:20:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 050D561C19
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:20:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63EABC433EF;
        Sat, 31 Dec 2022 02:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453258;
        bh=ji1rUXHAQzMqjM9Z4Aeq1CAjew27vcZ5lh3OtyeOF9E=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bLXvgnVp4KlYcQUxFU2nDacm1g15JuSazOdbdxkt2A++2mTffueRx/93n1kaAu0vS
         Vhoao2zhdyu3Z3eejw/IPSeqbrjW0MryrSpdeT+4JWwHV/uAoVM0C++RbMoHRlTsat
         YUY+tU/EDCE8Bg3EiY9NMsex+nl6/t59+JjR4af7eLL1GvE7AbaOhHaJHBwTj0Arxi
         ndEWtndaAvcQjeKxRfuYIe++Zn2yv1/C+yKF+2djP2t9VmnYA1ygPuoZFvQ4lCAa1p
         PZtWhA7evgGZzXer8x1O3Ee/ElJbJY5h2SSdqc+GnOv94xtg0PiW/Zjl31iqNVWCyx
         WjOGeavptgpQw==
Subject: [PATCH 43/46] xfs_repair: truncate and unmark orphaned metadata
 inodes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:24 -0800
Message-ID: <167243876494.725900.10741628794064487652.stgit@magnolia>
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

If an inode claims to be a metadata inode but wasn't linked in either
directory tree, remove the attr fork and reset the data fork if the
contents weren't regular extent mappings before moving the inode to the
lost+found.

We don't ifree the inode, because it's possible that the inode was not
actually a metadata inode but simply got corrupted due to bitflips or
something, and we'd rather let the sysadmin examine what's left of the
file instead of photorec'ing it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/phase6.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)


diff --git a/repair/phase6.c b/repair/phase6.c
index 964342c31d6..13094730407 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1220,6 +1220,53 @@ mk_orphanage(
 	return(ino);
 }
 
+/* Don't let metadata inode contents leak to lost+found. */
+static void
+trunc_metadata_inode(
+	struct xfs_inode	*ip)
+{
+	struct xfs_trans	*tp;
+	struct xfs_mount	*mp = ip->i_mount;
+	int			err;
+
+	err = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 0, 0, 0, &tp);
+	if (err)
+		do_error(
+	_("space reservation failed (%d), filesystem may be out of space\n"),
+					err);
+
+	libxfs_trans_ijoin(tp, ip, 0);
+	ip->i_diflags2 &= ~XFS_DIFLAG2_METADATA;
+
+	switch (VFS_I(ip)->i_mode & S_IFMT) {
+	case S_IFIFO:
+	case S_IFCHR:
+	case S_IFBLK:
+	case S_IFSOCK:
+		ip->i_df.if_format = XFS_DINODE_FMT_DEV;
+		break;
+	case S_IFREG:
+		switch (ip->i_df.if_format) {
+		case XFS_DINODE_FMT_EXTENTS:
+		case XFS_DINODE_FMT_BTREE:
+			break;
+		default:
+			ip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;
+			ip->i_df.if_nextents = 0;
+			break;
+		}
+		break;
+	}
+
+	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
+	err = -libxfs_trans_commit(tp);
+	if (err)
+		do_error(
+	_("truncation of metadata inode 0x%llx failed, err=%d\n"),
+				(unsigned long long)ip->i_ino, err);
+}
+
 /*
  * move a file to the orphange.
  */
@@ -1262,6 +1309,9 @@ mv_orphanage(
 	if (err)
 		do_error(_("%d - couldn't iget disconnected inode\n"), err);
 
+	if (xfs_is_metadata_inode(ino_p))
+		trunc_metadata_inode(ino_p);
+
 	xname.type = libxfs_mode_to_ftype(VFS_I(ino_p)->i_mode);
 
 	if (isa_dir)  {

