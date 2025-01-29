Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B68C1802B
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jan 2025 00:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738111707; cv=none; b=tlid2F15vUH/fqopTRp13OBj2hQnrtrYBx36woJXrmdhQlyD6y8KHC8tb2fyS0wnJlsStz8Mva0+D5G4KFftV6nllXarLZFZWxpLAjI83GW1kZcFRYl9YG9HQzSsjIF7lQUcaaShPTrqLOnhIxeZWqxq1RwmbEJh1gwv8v3NIEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738111707; c=relaxed/simple;
	bh=5VTjb0fcl4docsrHic7onz2t385hHokZ1o4H1CSB5oY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Uk6kYnGB5xCRmNBdDtrNToQ7YUqlKILQ5BzVxpbcQq3mJTjydLA+VcFe4aa1/YuR+s3YWl15A+kTVcZqaVopiowQT0TOfEgnfy+SMCWQPwh/y4rdyaZEkoiRBpFLEZa5CBeFB14YIhzEGCBeVm1ak243XTDcNPApxcIv3AJQ6Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AeRJ49hI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AeRJ49hI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBEA0C4CED3;
	Wed, 29 Jan 2025 00:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738111706;
	bh=5VTjb0fcl4docsrHic7onz2t385hHokZ1o4H1CSB5oY=;
	h=Date:From:To:Cc:Subject:From;
	b=AeRJ49hIJQZpVI1ds695BqkiTnQU49um9+q5JvuJ7Cv3agGmqFEmatjKmFZVQrv9I
	 eOTEOraoYhA1dXCX9tQxMe8SCbQx6AYTVa9kExvsHB0B0Szgg5LBQL3SM4C0VeLgPJ
	 Xrh0N5TLyspkw2F48CwJVSknnTZPy6upgQrpl2+pGJW+IvOI0CkrW4xQ+qkJL5p0XS
	 xzaYz9JGit6m3i/2Y9nkbHIwdQwMrSUmAXsIQwOGoN7qqxz7VExJiZILjtFn60HH+c
	 WyByfa0qR3IzWyjD5OQ0fsiF5zBBYSAG7dZDW+pLXBI0O6uH6+6wwOIlvE9tdMT1ZZ
	 w4DqeW0OpFhlA==
Date: Tue, 28 Jan 2025 16:48:26 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, hch@lst.de
Subject: [PATCH] xfs_repair: require zeroed quota/rt inodes in metadir
 superblocks
Message-ID: <20250129004826.GS1611770@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

If metadata directory trees are enabled, the superblock inode pointers
to quota and rt free space metadata must all be zero.  The only inode
pointers in the superblock are sb_rootino and sb_metadirino.

Found by running xfs/418.

Fixes: b790ab2a303d58 ("xfs_repair: support quota inodes in the metadata directory")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
Note: I found this omission while reading the fuzz tests results, and
it's a fix for new code in 6.13.  Could we please get this in before
the release of xfsprogs 6.13?
---
 repair/agheader.c |   49 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 48 insertions(+), 1 deletion(-)

diff --git a/repair/agheader.c b/repair/agheader.c
index 89a23a869a02e4..327ba041671f9f 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -319,6 +319,51 @@ check_v5_feature_mismatch(
 	return XR_AG_SB_SEC;
 }
 
+static inline int
+require_zeroed_ino(
+	struct xfs_mount	*mp,
+	__be64			*inop,
+	const char		*tag,
+	xfs_agnumber_t		agno,
+	int			do_bzero)
+{
+	if (*inop == 0)
+		return 0;
+	if (!no_modify)
+		*inop = 0;
+	if (do_bzero)
+		return XR_AG_SB_SEC;
+
+	do_warn(_("non-zero %s inode field in superblock %d\n"),
+			tag, agno);
+	return XR_AG_SB;
+}
+
+/* With metadir, quota and rt metadata inums in the sb must all be zero. */
+static int
+check_pre_metadir_sb_inodes(
+	struct xfs_mount	*mp,
+	struct xfs_buf		*sbuf,
+	xfs_agnumber_t		agno,
+	int			do_bzero)
+{
+	struct xfs_dsb		*dsb = sbuf->b_addr;
+	int			rval = 0;
+
+	rval |= require_zeroed_ino(mp, &dsb->sb_uquotino,
+			_("user quota"), agno, do_bzero);
+	rval |= require_zeroed_ino(mp, &dsb->sb_gquotino,
+			_("group quota"), agno, do_bzero);
+	rval |= require_zeroed_ino(mp, &dsb->sb_pquotino,
+			_("project quota"), agno, do_bzero);
+
+	rval |= require_zeroed_ino(mp, &dsb->sb_rbmino,
+			_("realtime bitmap"), agno, do_bzero);
+	rval |= require_zeroed_ino(mp, &dsb->sb_rsumino,
+			_("realtime summary"), agno, do_bzero);
+	return rval;
+}
+
 /*
  * quota inodes and flags in secondary superblocks are never set by mkfs.
  * However, they could be set in a secondary if a fs with quotas was growfs'ed
@@ -509,7 +554,9 @@ secondary_sb_whack(
 			rval |= XR_AG_SB_SEC;
 	}
 
-	if (!xfs_has_metadir(mp))
+	if (xfs_has_metadir(mp))
+		rval |= check_pre_metadir_sb_inodes(mp, sbuf, i, do_bzero);
+	else
 		rval |= secondary_sb_quota(mp, sbuf, sb, i, do_bzero);
 
 	/*
