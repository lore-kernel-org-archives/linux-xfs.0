Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C488B63D
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300670; cv=none; b=BD1hV4XJNmLdTa/kxymusgN1ZqsCSTS8ca0hsPkhJGiooGTdYV7luhaMDCKRsI8kJs4wkFO/J/ewyN1gjp6CqLZM545hufMsP95XwjDCMAByoqiEsWOKnYSn0bz8hcMwMrZefBOMRT0CxkfHgUFHd5PNFQeUnvjFT8EHPGyarlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300670; c=relaxed/simple;
	bh=x372SjV2Ff6e8UCPVHDwa/1zzwMKM+GeyG7UmeBzCH8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DaEotFizkfYcxKnnWXWWi+y0KGww/ZfqLIgIzU08I+RH6z7rjhKnEdB67crBvOtnD1LBFy5J7v2iDyrTwqq7pKBaeKOyYG//gde/K+t3AixJPgGMLbFK+/TmpXDVm15dIIqYQqkfiSM16dYRIzqqoL8EOuzGBAB3KC9rBV7fzQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hG3hk6Kc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hG3hk6Kc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F222C32786;
	Tue, 30 Jul 2024 00:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300670;
	bh=x372SjV2Ff6e8UCPVHDwa/1zzwMKM+GeyG7UmeBzCH8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hG3hk6Kc6DGnQexzBxTYqpwSimWe/lQLw24yfyT6LOjF8dHGZcJ2To4vu+aKL8XM/
	 EuLgoYuoZmrGNH/1sNH5GqPfm27tYblVDaTX9fhL4Z4NmFoFH2FVLa7G6GCHVNAmb1
	 mcXXgTeeYo5tSk7TmCSWx//3APzRnQmN6QsWtQsC2B0KD+LkEVl+gXurc1S93+ljNm
	 gE/hi70ecm40THcWCz6gYJzsmVtIhjelC+x2awiNJS63TCCSo0BJQBsyY7PYO5pVKK
	 PeMC/TjxBZgSvrbuqT6q2aaNgVVTng9J8UuuJKz272kSf7p+pAIxrduG7WEoChyDu4
	 lXioDTZgCZPGw==
Date: Mon, 29 Jul 2024 17:51:09 -0700
Subject: [PATCH 105/115] xfs: minor cleanups of xfs_attr3_rmt_blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>, Christoph Hellwig <hch@lst.de>,
 linux-xfs@vger.kernel.org
Message-ID: <172229843929.1338752.4061483218370317133.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: 3791a053294b037a6bf62df03480f5c5ddfd4d1b

Clean up the type signature of this function since we don't have
negative attr lengths or block counts.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_attr_remote.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)


diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index 58078465b..a048aa5f2 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -55,19 +55,19 @@ xfs_attr3_rmt_buf_space(
 	return blocksize;
 }
 
-/*
- * Each contiguous block has a header, so it is not just a simple attribute
- * length to FSB conversion.
- */
+/* Compute number of fsblocks needed to store a remote attr value */
 unsigned int
 xfs_attr3_rmt_blocks(
 	struct xfs_mount	*mp,
 	unsigned int		attrlen)
 {
-	if (xfs_has_crc(mp)) {
-		unsigned int buflen = xfs_attr3_rmt_buf_space(mp);
-		return (attrlen + buflen - 1) / buflen;
-	}
+	/*
+	 * Each contiguous block has a header, so it is not just a simple
+	 * attribute length to FSB conversion.
+	 */
+	if (xfs_has_crc(mp))
+		return howmany(attrlen, xfs_attr3_rmt_buf_space(mp));
+
 	return XFS_B_TO_FSB(mp, attrlen);
 }
 

