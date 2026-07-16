Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4B7389110;
	Thu, 16 Jul 2026 06:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784182047; cv=none; b=phPvRD+VnmCaSJLgTbnrE5WgaU0daxhoUVsf83f/7W1DNaYWHMo2rhogwi+3el8pq68Ga7SwUkqkGnYNS1oc7me/c61XF38+gO0cxGWdQqFactL3J7eQicQLi+hH+71f4V/kObC0f7RGD+oZhWi+SfsWxuLzoXjQT4AiPFGjnFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784182047; c=relaxed/simple;
	bh=XvIGuYG29GqZircj7pW2/VIoHsXK3Uw3ALvrnNkqv2A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TY3iepF87/FI8vSCMIA2JW9D0Rcr8yuUbFuw4Im+qRTikVpGpNf0IQtrUM4tIrP3q9uJ1b9hkNo82TiB2zW/AMoBcojrBEu4ZrJbtpjWPyTCIK5rY43mxEks+nBVwouDAi/lFpSAmaDw7LIIVZbSwUjgGw7JptsmGwAH5qkHuO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iBn/hqQj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iBn/hqQj"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 470EE1F000E9;
	Thu, 16 Jul 2026 06:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784182045;
	bh=csv+FjVOYbj88g97n6frkTzoT4+MLwnSUZqS0NbQJJ4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=iBn/hqQj1c24IkDzPtb0zOQb5le3jB7kfCw2w6PBZ0JTXWutS0QHecqS1yjMlOYMd
	 t+62IGO6s4aTE+p5kyz8XboIUvI6Fv+bJuO3BXJsp1BJ93i7h962opsDZ+gT6SbghO
	 Ob6AqPJVYmTfMT7/7ViXztYzt08Pum4jzbk6MCvR+XRe+JH/OE98Ihjy1BaaBKIzMC
	 /AU7wedSjpjZlzROl4s89FVXHKNYWT62ay0TEG9z1vrwIpY84Tt3XjqK47F19Djyyf
	 H6x+gsayhRez0HtymyyAhrPdOhtRcEe3XJn1IUQmrQEbNdcn+gQFyWOh3YGvpRlogW
	 1p1NkYuDQVSbQ==
Date: Wed, 15 Jul 2026 23:07:25 -0700
Subject: [PATCH 5/6] xfs: mark nonzero sb_gquotino as corrupt on metadir
 filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178416797465.2008054.5748103424434594657.stgit@frogsfrogsfrogs>
In-Reply-To: <178416797326.2008054.12517273271060887961.stgit@frogsfrogsfrogs>
References: <178416797326.2008054.12517273271060887961.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

On a metadir filesystem, the superblock gquotino field is always zero
because we find the quota inodes through the metadata directory tree.
A nonzero value is therefore a corruption (as pointed out by LOLLM) so
mark the failure as such.

Cc: <stable@vger.kernel.org> # v6.13
Fixes: 06b20ef09ba163 ("xfs: check pre-metadir fields correctly")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/agheader.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 9ed053b5f06125..62ed5eaf08fbc1 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -266,7 +266,7 @@ xchk_superblock(
 			xchk_block_set_corrupt(sc, bp);
 
 		if (sb->sb_gquotino != cpu_to_be64(0))
-			xchk_block_set_preen(sc, bp);
+			xchk_block_set_corrupt(sc, bp);
 	} else {
 		if (sb->sb_uquotino != cpu_to_be64(mp->m_sb.sb_uquotino))
 			xchk_block_set_preen(sc, bp);

