Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64BB14C89
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716347363; cv=none; b=Ia90vOrm0duttO09yyPV0j2zEQ0YlGuuJ2BvJ5nM/oUCjrq2tOe6ZL7dmaT5yfhlkIjQgJEParx6nQU8y4Y0tBVk/ljIMzcBuRqCJaQopEMr84+gDjDev3A7ufS2+nFhu7k8NaYjJMV0jfPJK0cagXT8H5cjDHAvaa0Qk1ZFhhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716347363; c=relaxed/simple;
	bh=5viZkT2FAvKmGr6SFVV6kp7nThmdH1lWl7zfcarinjY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pXySK85uWeDI+0gwmvjAT7LLHFYVGtgf0ebO95zDXL7KC6m5p97HPEx0uc7KqVE6qoQ3tKRBlf6LGqU9x4Jw+Pzcrgw8ycJFIrDYfpy0fafFNcfnyOyxcqqdRvWnPRc08eco/Fe2CdjV67FwAwyEgyEB8ELaEyWDHEags4YxBrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NhEBuwbq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NhEBuwbq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4259BC2BD11;
	Wed, 22 May 2024 03:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716347363;
	bh=5viZkT2FAvKmGr6SFVV6kp7nThmdH1lWl7zfcarinjY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NhEBuwbq9D/X2WDIyerp0PmLVd77slW2frOUl3RGer571zZOdCuHI8GDvx1P0cWTz
	 tYrd8ewlzoNmxMEaUqz0cgJ/cosicmrq7+BGK64NankWOQIlhEehvCCVrp3fyJisCg
	 pVDLwKZT2qvxHlPh/HKwFXyKW5EOD5HG37hBCtnoXxJooIYmzokkJvXrReAqQ/Y2v2
	 mVMN2X13QSTXEZ5vfnA5aD8ejl10NwRD2TiLzUStN3BCi2Qahwozuat14aKlolsNyz
	 9JAtJwVXF26r19DIuTbRb89HLi/2FNdvGz3ErJ8P8zhzfh0Oa5xfKreW3v43f8iBN6
	 Cvqg4IJ/cGKMg==
Date: Tue, 21 May 2024 20:09:22 -0700
Subject: [PATCH 079/111] xfs: misc cleanups for __xfs_btree_check_sblock
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634532883.2478931.1172538844379373184.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
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

Source kernel commit: 43be09192ce1f3cf9c3d2073e822a1d0a42fe5b2

Remove the local crc variable that is only used once and remove the bp
NULL checking as it can't ever be NULL for short form blocks.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_btree.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 4fb167f57..359125a21 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -170,15 +170,13 @@ __xfs_btree_check_sblock(
 {
 	struct xfs_mount	*mp = cur->bc_mp;
 	struct xfs_perag	*pag = cur->bc_ag.pag;
-	bool			crc = xfs_has_crc(mp);
 	xfs_failaddr_t		fa;
-	xfs_agblock_t		agbno = NULLAGBLOCK;
+	xfs_agblock_t		agbno;
 
-	if (crc) {
+	if (xfs_has_crc(mp)) {
 		if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_meta_uuid))
 			return __this_address;
-		if (block->bb_u.s.bb_blkno !=
-		    cpu_to_be64(bp ? xfs_buf_daddr(bp) : XFS_BUF_DADDR_NULL))
+		if (block->bb_u.s.bb_blkno != cpu_to_be64(xfs_buf_daddr(bp)))
 			return __this_address;
 	}
 
@@ -190,9 +188,7 @@ __xfs_btree_check_sblock(
 	    cur->bc_ops->get_maxrecs(cur, level))
 		return __this_address;
 
-	if (bp)
-		agbno = xfs_daddr_to_agbno(mp, xfs_buf_daddr(bp));
-
+	agbno = xfs_daddr_to_agbno(mp, xfs_buf_daddr(bp));
 	fa = xfs_btree_check_sblock_siblings(pag, agbno,
 			block->bb_u.s.bb_leftsib);
 	if (!fa)

