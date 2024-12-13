Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9EEC5103F
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734052762; cv=none; b=ecKf438bEahL24Saky2lvkASV/bsspArdTwvtRnNF53P+jSpo3mgz9P+21oVzQiOS4G/YZ1Si+Z7b5GZ2YSYNi15w1TrTQA5xN/1MaDwEsImIlDeD2/IVKywHRbGtGQqfgz8HE1YtdItYPqfkgMN2QD84ynFCaaOeJVKFjrFqm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734052762; c=relaxed/simple;
	bh=ofXSkHqxmG8G8SvH5z8AWcPb1I0sp2LZZHGIcL+480E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CGIhSZN+tzC6qV/3y/P7DeEnzNwSsKEtFbm54cfAkUOZHdxSKcsesS2xAoJ44nuN0GegxAacXeT87yfZBa2nnOScvNjL0ZEcCEc09Y2ZxlYfg1769MoL1j3Spuy6HXrDhGZyXLsVGFRp4RfoiRmJoVDN0+olDLUZehRSkGS8Ngs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=glXojSKN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="glXojSKN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A94A0C4CEDF;
	Fri, 13 Dec 2024 01:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734052762;
	bh=ofXSkHqxmG8G8SvH5z8AWcPb1I0sp2LZZHGIcL+480E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=glXojSKNUAlhqdvMP6Pv/+XAxMCs/YNMSqOnWkNvAC3KRzA+IVUZPlVP91xj5Q0+Z
	 1zeFhW0aGVhzGevX4MwyBhV1rDp6unqYjuMDHQr8BFyKt3uQwSY+QTaSslgljZPHWH
	 ZjJY5SJ7mbZdOCGkfFgbfLI/DfmeFQOoMfGHOD1y5DdzkS4U1N32AndsFwXjdW0u4w
	 gQyAL+FB7CaZ4F+Sp6PPuL7MM0aWD8bRFHWokvl393/hiqj+QHDoxfyCEs68sFspRm
	 wv+R8G4MKTNzHoViVcbHNGMt3IrCvgjHa/zUQfWpA4SdqYWI9xXkN1Chb3oXI2rhtM
	 BrMCl5iOWSeUg==
Date: Thu, 12 Dec 2024 17:19:21 -0800
Subject: [PATCH 35/43] xfs: don't flag quota rt block usage on rtreflink
 filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405125167.1182620.9849878961217482999.stgit@frogsfrogsfrogs>
In-Reply-To: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Quota space usage is allowed to exceed the size of the physical storage
when reflink is enabled.  Now that we have reflink for the realtime
volume, apply this same logic to the rtb repair logic.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/quota_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/quota_repair.c b/fs/xfs/scrub/quota_repair.c
index cd51f10f29209e..8f4c8d41f3083a 100644
--- a/fs/xfs/scrub/quota_repair.c
+++ b/fs/xfs/scrub/quota_repair.c
@@ -233,7 +233,7 @@ xrep_quota_item(
 		rqi->need_quotacheck = true;
 		dirty = true;
 	}
-	if (dq->q_rtb.count > mp->m_sb.sb_rblocks) {
+	if (!xfs_has_reflink(mp) && dq->q_rtb.count > mp->m_sb.sb_rblocks) {
 		dq->q_rtb.reserved -= dq->q_rtb.count;
 		dq->q_rtb.reserved += mp->m_sb.sb_rblocks;
 		dq->q_rtb.count = mp->m_sb.sb_rblocks;

