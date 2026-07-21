Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F54578F26;
	Tue, 21 Jul 2026 03:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784604228; cv=none; b=f7lHYmflQcFDIUmBd3EBCVn428Iw7UUY9zmOjpXp/p8azSudGBffP5P1YuRT0hmWgB4h62qbRpW4vjdg7tDuAGhmYNAtAtLUGmMlDQ1DXaksYKc1uuKYIXANyJlJ3qBtatB5OT8bl/qRHn+hDzHjsd+DoqG1wZOfsK39mQpu7Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784604228; c=relaxed/simple;
	bh=ROwtz8YiO0ocuTUNzu8Elmw5do6nzrGrWBGoAwGVubE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FJN/J9ejS5tfXhAirKAqXT2aLWd4buz32vrjGn6dTqLEq72QBCJX51sBeqc7ADBtN7gqkRM2b1BneezP0xNdZtOqnpstrl9mVPvCocrif8PdBOuYOKPpOJVcEcKDMGsymHHJBIS4Bm3m49AzhDk2/wk/2DxQiOOOd+Ij+92cAyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iaYSvsPP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iaYSvsPP"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id ED95F1F000E9;
	Tue, 21 Jul 2026 03:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784604227;
	bh=cuIJZNVzkTutfPdoVp3/v/IMmeLS7gAFmIzFABjwCLw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=iaYSvsPPA/mv+d+QUtELwW3ry7fqEgIXRrr98/jqlBs722r/FNkeFk5XGXfX0ql/z
	 U0l9AZtSkkegdqpgu3O5S81pjRnloFPaodaYyW9A/scG0UigUhy/2odqJx64W8UDeb
	 B9Ls8q+TBq+S/EIBLjyxsu5sGe2km97RlL4UwGNK5PxBkCbYQ60MyJILTd++SZTWQ3
	 bvowL2ApsVzbg14nSghDgfcon7LPCtV+UpG4GCaScF8sHncdEn8OEkc/p2nH4VQ9g8
	 Jl6BdJVJV0+ozF0kEtqqFyGEDpV9gmrVy/C3jBIVK8AeP7nCf5p4fRaCbdTGYcEBKv
	 Wl9uYMz4Ppc+Q==
Date: Mon, 20 Jul 2026 20:23:46 -0700
Subject: [PATCH 1/5] xfs: check cowextsize in xrep_inode_cowextsize
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, hch@lst.de, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178460419108.830618.3867372075527873217.stgit@frogsfrogsfrogs>
In-Reply-To: <178460419060.830618.6327864598367400225.stgit@frogsfrogsfrogs>
References: <178460419060.830618.6327864598367400225.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM points out that the function that corrects cowextsize should check
i_cowextsize, not i_extsize.

Cc: <stable@vger.kernel.org> # v6.14
Fixes: a9600db96f74af ("xfs: detect and repair misaligned rtinherit directory cowextsize hints")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/inode_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 3ec41c19835116..b88427a4460cba 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1960,7 +1960,7 @@ xrep_inode_cowextsize(
 	/* Fix misaligned CoW extent size hints on a directory. */
 	if ((sc->ip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
 	    (sc->ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE) &&
-	    sc->ip->i_extsize % sc->mp->m_sb.sb_rextsize > 0) {
+	    xfs_extlen_to_rtxmod(sc->mp, sc->ip->i_cowextsize) > 0) {
 		sc->ip->i_cowextsize = 0;
 		sc->ip->i_diflags2 &= ~XFS_DIFLAG2_COWEXTSIZE;
 	}

