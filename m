Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D922374D4
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 05:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706591135; cv=none; b=uuvsLx6t2bAHX+FWfS782V/YTNq0NDRoQL4BC8P7TSmsk4mhnNu4tzzCAazTmjX03tZjPitpYO2sSu65CtLG9t1Y5EDyRy/xkJTLcx2q7YB68B136kXzLFT7fonkFtLzjGLcNjzmyyZf4A/nHwgJAZk9x4sGXdmSSwzTMNzKqnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706591135; c=relaxed/simple;
	bh=rO8Lf1e4fySR9iDT0mv7oGIRyKcb/+rbjsq5DB/F3rQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZMhkd8qjlzcaxHvJ3LfyeEZCh6H2mpTszWF/J/gSK/WPWAfY2xBnmdD3CJ9XXRgdfn2tDhwtAH+/9cRxt6jyWB1BOMgAD37AVtfEEDGkyX0S/n/l7IZ1O5rh442VAcudYR5ks30W8g2s8Wrnro7s7aWD6as4PL32e7NYvC5ETO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nxBRc1Dn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nxBRc1Dn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F03A3C433C7;
	Tue, 30 Jan 2024 05:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706591135;
	bh=rO8Lf1e4fySR9iDT0mv7oGIRyKcb/+rbjsq5DB/F3rQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nxBRc1DnY4fOYG95Nkb2dIcjyV0EzOWPDRzh0k72c1E19AGEtWwM8NRsWLRxE0MOy
	 KwW7z/C+5XJiznbKk1gvN0DiGAtNubaGvo1MKTVGy67nADS/EPfWVQIL+Kt0/jk/f0
	 j5dDEMSnLZJ6obm74rOdGOJo/r3EkY6h/VCbe/fyVezaVP0HzmNshwHCLaGmdOxyxO
	 dLQCZl6Smiv84uGqd1vcLNauqQtF6KWMPNwk6r0gd6hfKITEb3VmXy3hz+QrEZ8XTq
	 tuowJoAjP9gsQem8q6APGtUOWOLcGTlvy1WQxzELEEbkbGO62+v6noFVQLfQyJbrVq
	 EaNIWT5t4j30Q==
Date: Mon, 29 Jan 2024 21:05:34 -0800
Subject: [PATCH 2/4] xfs: create a predicate to determine if two xfs_names are
 the same
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170659062333.3353217.14544117022346192234.stgit@frogsfrogsfrogs>
In-Reply-To: <170659062291.3353217.5863545637238096219.stgit@frogsfrogsfrogs>
References: <170659062291.3353217.5863545637238096219.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create a simple predicate to determine if two xfs_names are the same
objects or have the exact same name.  The comparison is always case
sensitive.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_dir2.h |   12 ++++++++++++
 fs/xfs/scrub/dir.c       |    4 ++--
 2 files changed, 14 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 7d7cd8d808e4d..8497d041f3163 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -24,6 +24,18 @@ struct xfs_dir3_icleaf_hdr;
 extern const struct xfs_name	xfs_name_dotdot;
 extern const struct xfs_name	xfs_name_dot;
 
+static inline bool
+xfs_dir2_samename(
+	const struct xfs_name	*n1,
+	const struct xfs_name	*n2)
+{
+	if (n1 == n2)
+		return true;
+	if (n1->len != n2->len)
+		return false;
+	return !memcmp(n1->name, n2->name, n1->len);
+}
+
 /*
  * Convert inode mode to directory entry filetype
  */
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index d86ab51af9282..076a310b8eb00 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -93,11 +93,11 @@ xchk_dir_actor(
 		return -ECANCELED;
 	}
 
-	if (!strncmp(".", name->name, name->len)) {
+	if (xfs_dir2_samename(name, &xfs_name_dot)) {
 		/* If this is "." then check that the inum matches the dir. */
 		if (ino != dp->i_ino)
 			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
-	} else if (!strncmp("..", name->name, name->len)) {
+	} else if (xfs_dir2_samename(name, &xfs_name_dotdot)) {
 		/*
 		 * If this is ".." in the root inode, check that the inum
 		 * matches this dir.

