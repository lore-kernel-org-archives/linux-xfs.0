Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1E41F3D3D
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528958; cv=none; b=Vubp5LeLg086aDT3b/7f+kjc3qa7YC3dPzckyKFkmEisGorTEEDBeENVmsafr9enO0LAXYh/1j6E/Y8pBYENYG6vf8+Oe8QzeddJ5HFy0C84LEzb5yVv7DcMVhmXJ3z4kClnT4fe4pWVGw5jXwnbHneFalOyW1Irb4NIRdKcVRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528958; c=relaxed/simple;
	bh=8QY+JTBSB9saV+kpIq/QzAG7kQFXZihWpQrc4TgYADg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jPix6f9EMNSQdnbEve76rxpYZ32K+xRTpcByoKcHpCwMHWQOWrd0SOJpwVT+ZFDuM4SrLLvCfmT3oR1WFob0FpKDtr9OYHYHRLmRN5M4Tqrwydr1vWYWDMLeqFWaxgBx/gQJKsGXpfEMOkheMyWEr3ik0F2WKuhfld6wMfS3alY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bCk9VIbl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bCk9VIbl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C52D4C4CED1;
	Fri,  6 Dec 2024 23:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733528957;
	bh=8QY+JTBSB9saV+kpIq/QzAG7kQFXZihWpQrc4TgYADg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bCk9VIblEJBFtbihHZNG0mU1c8pVKhb4zyhu9RjF2JMbWxuHS0brykISDwmp51O1t
	 f7XoFFOV58kdTUNoD1jyGL2p1GbL7Ye0HQHERIz9UuMwbdvwn5KS+sSd0rQy1GjNr5
	 5FklrBt5NsCbDTaIh+qiHdSqq1z7hXsha5aJxelveKUHMm8GfAcenQbXjvUIjdecau
	 JWheIyY4uLarartQuhdJCGwSvsJyKADETPr0lv66KecPI+IWebsyOmPQB8P6vtc5nZ
	 684cPX7Ve/RcNptB6sHj7x6yFMb1D4Bxubgf3Hjf4XzMW+Sz0/jX94OXZ+SyOkNBHi
	 xC8cO3/SKL3UA==
Date: Fri, 06 Dec 2024 15:49:17 -0800
Subject: [PATCH 37/41] xfs_repair: truncate and unmark orphaned metadata
 inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352748801.122992.9829661249755090260.stgit@frogsfrogsfrogs>
In-Reply-To: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

If an inode claims to be a metadata inode but wasn't linked in either
directory tree, remove the attr fork and reset the data fork if the
contents weren't regular extent mappings before moving the inode to the
lost+found.

We don't ifree the inode, because it's possible that the inode was not
actually a metadata inode but simply got corrupted due to bitflips or
something, and we'd rather let the sysadmin examine what's left of the
file instead of photorec'ing it.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 repair/phase6.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)


diff --git a/repair/phase6.c b/repair/phase6.c
index dd17e8a60d05a3..cc81f5c8b013f4 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -855,6 +855,53 @@ mk_orphanage(
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
  * Add a parent pointer back to the orphanage for any file we're moving into
  * the orphanage, being careful not to trip over any existing parent pointer.
@@ -945,6 +992,9 @@ mv_orphanage(
 	if (err)
 		do_error(_("%d - couldn't iget disconnected inode\n"), err);
 
+	if (xfs_is_metadir_inode(ino_p))
+		trunc_metadata_inode(ino_p);
+
 	xname.type = libxfs_mode_to_ftype(VFS_I(ino_p)->i_mode);
 
 	if (isa_dir)  {

