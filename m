Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BDDF128823
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424911; cv=none; b=ng9mR6qnVHsVThzxLPEDR4ZtdcGG6EhgQd8UVErnAI2QqTCkPSDBnQXqezLqT+uuvcEbMtqN9qUJ5uDT3KXaACB5jwdsDkzGWbYnjiD4kisKJbvIrMlS9M0oaBhM5h6mcctoESjdZ2tUGyUC7O/PeHDQ8riLoiJ4SFJYGWklPZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424911; c=relaxed/simple;
	bh=xM2yZ1ijeyyylXTYF126JXVTOOiLp1ReL4DkjyWIJ1k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FyUEMdTAImZ3CcG743iUCjNM7cxlGEQ4i24DH3PD99DgNZoQdy44crwUin3PUD8kM53bIWmoR0rRv9xT+OEHsh15csFvlXuFa5HoYo97HFjACZDmTum+CPTGAj2wq1XCtx3mEog1Y2f/P1EX2C8cZSkXHmACvpC0IbZaVw/+He4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qm6I85/t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qm6I85/t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4514FC433C7;
	Tue, 26 Mar 2024 03:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424911;
	bh=xM2yZ1ijeyyylXTYF126JXVTOOiLp1ReL4DkjyWIJ1k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qm6I85/tEg/1rH2zsiREeUTFEbTMPDuBciKlwiTHVxU5IMk+/Zm9ZbWUUVbiJ6s6d
	 RE7vY5lYSSMv7SVs1GM+9AsLh9JBfjAwv0xGFB+OY5sW/wqZiUnQ5wZvOG/7A1G2jS
	 gSD2jYJllWHDZHTq+BZFCjb/HJNBpPhY9SLqR3v0lWPIDuJocl6xAhHOvTeKbDkCpw
	 6NHZY2/+IzW6PWPjkwtwD7SlLw/3X4uPbfqGQK6ak4qpuvbcgx14yE9jEHhXcgicY7
	 9UnUrPbcwn5WzauFq87IkK8m/KDPyW7MEyw8Ckn6YS5HqzojLIdSXdI4twANrpdEXo
	 y0HBrbTubDbeQ==
Date: Mon, 25 Mar 2024 20:48:30 -0700
Subject: [PATCH 077/110] xfs: open code xfs_btree_check_lptr in
 xfs_bmap_btree_to_extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142132489.2215168.9178422225353226691.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: fb0793f206701a68f8588a09bf32f7cf44878ea3

xfs_bmap_btree_to_extents always passes a level of 1 to
xfs_btree_check_lptr, thus making the level check redundant.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_bmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 2d332989be36..86643f4c3fde 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -562,7 +562,7 @@ xfs_bmap_btree_to_extents(
 	pp = XFS_BMAP_BROOT_PTR_ADDR(mp, rblock, 1, ifp->if_broot_bytes);
 	cbno = be64_to_cpu(*pp);
 #ifdef DEBUG
-	if (XFS_IS_CORRUPT(cur->bc_mp, !xfs_btree_check_lptr(cur, cbno, 1))) {
+	if (XFS_IS_CORRUPT(cur->bc_mp, !xfs_verify_fsbno(mp, cbno))) {
 		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
 	}

