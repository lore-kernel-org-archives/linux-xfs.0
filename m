Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E578B1AAD7
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 01:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711504371; cv=none; b=QlO1jbVihY3unzquaKN3I15ecvoIAbjiClgtzKX0kjlNLK/kOWcNEsALA314l98EMOvHhghwqAFB7QloTafGU8Gm13456MxPtz7uf+IJDlJBPTUBAzps9aOMwzX1btlsdodnnaBqRQUgk7gsoKlG9dlTTgWAufVI2FrNkkJFJT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711504371; c=relaxed/simple;
	bh=asAVb7j3JmeTxy2+02GkeUqLdIOPTTSBmVKAUFf0P1I=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MFyuKQAYXJR4EdyVbyVC4euT/nuVp7kzvvttBizjVzLKq9Cf3fk4ZbZ6VYsgo0yDaaq96fcDJ8Bc12hpSOE0AjcPWgiTR7CZTWtV6yxD5llgKPVUdVo9Ib4fhgc8ptKOkQt5yCGoxsIhAm4Sn/a1Zflgqkzc7PKMOHsjStO+D5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ue/GUpcA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ue/GUpcA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AE25C433B1;
	Wed, 27 Mar 2024 01:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711504370;
	bh=asAVb7j3JmeTxy2+02GkeUqLdIOPTTSBmVKAUFf0P1I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ue/GUpcA1m6vNxd9mufrKgJvAZSjO/gtUbfPhsSPAuoeYx4ZETO9CijeXgi8zj+cN
	 1i1DqZbSCCMzqIwXi5+sE7+b8gFDepllAfWf+6F8nTQ7WVeA8rwOeORC3OQllX+lzk
	 PvgBXNitNJsxPWqemNawF81uFafsWin7PJwJxxTeWEan3KqqvV5HvI+zb97KDWpC84
	 6LLWT9UGe0rrjctXVgRIxP88IJJkeLVBa1gPVFi8FEweSH4axaUE2I9jPIW32SQ6Xt
	 OKhT8dtPT3vBls1dGgsYI2UF5whFIYUJF8Ub6UwVq7OaFIokx0za1UIe2FqMYOyf7x
	 xszYMLdba5/kw==
Date: Tue, 26 Mar 2024 18:52:49 -0700
Subject: [PATCH 7/7] xfs: constify xfs_bmap_is_written_extent
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171150380248.3216450.7091928042805546982.stgit@frogsfrogsfrogs>
In-Reply-To: <171150380117.3216450.660937377362010507.stgit@frogsfrogsfrogs>
References: <171150380117.3216450.660937377362010507.stgit@frogsfrogsfrogs>
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

This predicate doesn't modify the structure that's being passed in, so
we can mark it const.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index f7662595309d8..b8bdbf1560e65 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -158,7 +158,7 @@ static inline bool xfs_bmap_is_real_extent(const struct xfs_bmbt_irec *irec)
  * Return true if the extent is a real, allocated extent, or false if it is  a
  * delayed allocation, and unwritten extent or a hole.
  */
-static inline bool xfs_bmap_is_written_extent(struct xfs_bmbt_irec *irec)
+static inline bool xfs_bmap_is_written_extent(const struct xfs_bmbt_irec *irec)
 {
 	return xfs_bmap_is_real_extent(irec) &&
 	       irec->br_state != XFS_EXT_UNWRITTEN;

