Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E6985636
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706817256; cv=none; b=ufKEkg9Xag1u7miUye0bzHHBQ3QC0IMXtvXLpg5PJzfkLTtJOTLegNriJ8zNDPNDwMOL5cFBr9JNjDFN02Kryv4fOCEAtamhhQYwBHKqaTMu3g0rAzbg32yqZsWQ3ZSXknZKLwZ3BETmj8u6jEdgll1E4NO20xSuRLSSjhnfnh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706817256; c=relaxed/simple;
	bh=hlSKsq/qx1g8GiMjNPZHNr/XPicFG1mvFz/UxFj0ohQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ry7E+GqJr6gh4387872Bfxdu4KqAYciPgXOSH/ah/zmzWyEw3uvDSnoQPKjwcfap+m/OJ8VHuoDfrZTEeneHFt8DK38U+lsTD+8pu6C4btAiADOvhRcdYdQHOVNIDP5uhRM2EAGZJXTpz+aL3f0UAdhWSaKRKEWMt8Cl/3jCL9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IIDzSFq6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IIDzSFq6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B368C433C7;
	Thu,  1 Feb 2024 19:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706817256;
	bh=hlSKsq/qx1g8GiMjNPZHNr/XPicFG1mvFz/UxFj0ohQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IIDzSFq6sJONSggB8Rd1XTmRJ5+/pC2Ci2YEySzLugCx3rafzBpr8YedeZewDh3Hy
	 Sph5kPGmnPsYt7XLWxiSQoy16R7lhGY4H8K85qMp3V3pCcNP3Cn+931CBuMvpin4hy
	 mV3SIt21dgVhSUtmKcwUYpxEvSGw9XxHaP+ywCd7vD12Zdbvds/ORNvfsIFtnknxqe
	 9IobzPXPWS+bzZ0znSICez0mrnvjk0LgeF++P1kcQvD7oMtkAWJnQYeaIVyZWa9IAZ
	 o+ovjRNb+840r0eM70ECI8TrLykI+AIglnU9Gfa11pnPq7fBgQgCmQURGUCX0/6zHN
	 TT+xJBjnV8pFA==
Date: Thu, 01 Feb 2024 11:54:15 -0800
Subject: [PATCH 06/10] xfs: remove the crc variable in
 __xfs_btree_check_lblock
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681335710.1606142.5803626560547869424.stgit@frogsfrogsfrogs>
In-Reply-To: <170681335588.1606142.6111968277910779056.stgit@frogsfrogsfrogs>
References: <170681335588.1606142.6111968277910779056.stgit@frogsfrogsfrogs>
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

crc is only used once, just use the xfs_has_crc check directly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 255d5437b6e2a..4a6bc66c14d0d 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -106,11 +106,10 @@ __xfs_btree_check_lblock(
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = cur->bc_mp;
-	bool			crc = xfs_has_crc(mp);
 	xfs_failaddr_t		fa;
 	xfs_fsblock_t		fsb = NULLFSBLOCK;
 
-	if (crc) {
+	if (xfs_has_crc(mp)) {
 		if (!uuid_equal(&block->bb_u.l.bb_uuid, &mp->m_sb.sb_meta_uuid))
 			return __this_address;
 		if (block->bb_u.l.bb_blkno !=

