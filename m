Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ADC31E1A12
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730417060; cv=none; b=WX8Y/Wb5dmZbOKOeJylPvbodo99mocOGw1uUeAkl+vc7TsFCDIHZ11mrUrDwLKi+O2zsaaU7Ts3cyS9qLMffF8vo7m+uXj9m91+JXLY14UrTqgVgnCqH4xHFhTstrEzDSQ87O8nMKcuTxIn6u1mgaal+QuPR9mPoj4r/CdpoBVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730417060; c=relaxed/simple;
	bh=UjNpHV+k9RorUDh45wvtXOvZiBxlhSv06rMjJTZC6RA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h9ie5vuSRUnJyEKa47qi38T2pBgBZCfVEJwDaIJhWqQ2qlGp4UpfZ5KbJn5kVS8XtJYW/DET+ey3FrJ42YAGDWAwjNbc0QW62dyM40fg+nuSHhzQ0wuWPxG+ZwJdiwTxzRo6pVuDs2zBSbf+FbLHz8Y4osNKV5XbAQA6QrohK7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UUJiuNz3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UUJiuNz3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04EBAC4CECF;
	Thu, 31 Oct 2024 23:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730417060;
	bh=UjNpHV+k9RorUDh45wvtXOvZiBxlhSv06rMjJTZC6RA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UUJiuNz3pHiVTFB3hCurmBzyZy+FCvRx66omIJv91GgQUjrGD9DY8iH9yeshEE28b
	 vc1trsyW4QmCuhfx4v1QVfcMN/BPap3XivYTuLcOdtCRXdFJhp6VlpCN4a+gPLZQsG
	 TMjTIvTRPbEGp865fkYnNyjXf4+ekFbPIpPER9KY/J+S3w+Jfhs5Ue3E/2L4uwqJni
	 fnmxuMgeeR9shKcQ+QYUIZHxUphXFVYfU+FQzYkuK47Bo8xgCbKcWVWGZqKlVbCJAe
	 vU8LGCmkJ6E8apZMZ2ibI7IHBkKCEEk2bDJK3tHJ8t95D1/2kHtd7pQRgeybVBBdAU
	 BlPBTDqtmzo9A==
Date: Thu, 31 Oct 2024 16:24:19 -0700
Subject: [PATCH 3/6] mkfs: remove a pointless rtfreesp_init forward
 declaration
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173041568148.964620.2012589547616082953.stgit@frogsfrogsfrogs>
In-Reply-To: <173041568097.964620.17809679042644398581.stgit@frogsfrogsfrogs>
References: <173041568097.964620.17809679042644398581.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/proto.c |    1 -
 1 file changed, 1 deletion(-)


diff --git a/mkfs/proto.c b/mkfs/proto.c
index 06010980c5b313..9d21f027c0b174 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -18,7 +18,6 @@ static struct xfs_trans * getres(struct xfs_mount *mp, uint blocks);
 static void rsvfile(xfs_mount_t *mp, xfs_inode_t *ip, long long len);
 static char *newregfile(char **pp, int *len);
 static void rtinit(xfs_mount_t *mp);
-static void rtfreesp_init(struct xfs_mount *mp);
 static long filesize(int fd);
 static int slashes_are_spaces;
 

