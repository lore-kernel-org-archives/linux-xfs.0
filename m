Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3CE046AA68;
	Tue, 13 Oct 2026 06:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871529; cv=none; b=dxtvxvqnWAuKrOndIbiB13qBp+2eg6tNSH8iWVJFwcm+bLzOGPiL4UvI4nXya1WYEqi5N6ZQ1mNQ7eCYJbcI28vs5fGVtcbCRJKQMlTmlVJxmSxiBIERxuvy6bZxfG6XVXFELiHf7vYRgaPF/LQYZAhfi+RfEeJw8ISZnQrIzOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871529; c=relaxed/simple;
	bh=GM5fxw1I1Nhysd3oE4f7bwWxq90mKsjkuWRgpVp/C/4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gA2gkvwex2FounYNo6n7+my0Be3BrjjSZCCoy+6n8th7KehEnHntMU8xPhOFJhzXEwkHfJjMmapaterHUNIqOCMCOlADWk/q7ddfPvbWfeWAx+Y+SfcuIKkYXCd/zmecnNgdt3RGB+gu+NSElF5uSF5HJAG1C7NxO7Z2ZZpczwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NY7d3UvE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NY7d3UvE"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 79B1D1F000FF;
	Tue, 13 Oct 2026 06:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871528;
	bh=ua71D8H7fSVInUo91rjftammrfzPkPAsdfDDSFxWnV0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=NY7d3UvEzKM6lamCHrR/UuWwY+pQZQQy7B3HNSLxAW/MOlto54h+7uL75dYDB/znM
	 UknGuQD9Pe3fJvZwg/v9MOAZpdKtzQV6XdUmQXuRP/dpHvImAOBvT05LnQNDvmNlRM
	 eCP1WVb4+ISnS9beTEFk0ASKsC1BmpdweMStr13nlHMnBi2qVOPa8CPsZjMbxV/Fk3
	 OnnTZUEGXkc9TBJ+1FIvwQJLvx5lkZvfbkILGb8WAkeWG9uhnKhBg+8xUCmrR+RSdX
	 GiOxAj+s67KAz6pBuDnOCTX2buvQa/eftAukFIOR39JdTtoEoLwLzN0YU/3rXG3FYC
	 BRKCEAHcuG5Kg==
Date: Mon, 12 Oct 2026 23:05:28 -0700
Subject: [PATCH 01/12] xfs: don't overrun incore inode when cleaning attr
 forks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179186107160.1898400.3002885766416895980.stgit@frogsfrogsfrogs>
In-Reply-To: <179186107061.1898400.3978552773417541744.stgit@frogsfrogsfrogs>
References: <179186107061.1898400.3978552773417541744.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that xrep_dinode_check_afork doesn't check for a
di_forkoff value that is so large that the attr fork would begin after
the end of the inode space.  This causes afork_{ptr,size} to be
nonsense.  What we really ought to do here is zap the attr fork.

Cc: <stable@vger.kernel.org> # v6.8
Fixes: e744cef2060559 ("xfs: zap broken inode forks")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/inode_repair.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 5b5116adcbf5e4..de3c915984290b 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1243,6 +1243,8 @@ xrep_dinode_check_afork(
 	if (XFS_DFORK_BOFF(dip) == 0)
 		return dip->di_aformat != XFS_DINODE_FMT_EXTENTS ||
 		       xfs_dfork_attr_extents(dip) != 0;
+	if (XFS_DFORK_BOFF(dip) >= XFS_LITINO(sc->mp))
+		return true;
 
 	afork_size = XFS_DFORK_SIZE(dip, sc->mp, XFS_ATTR_FORK);
 	afork_ptr = XFS_DFORK_PTR(dip, XFS_ATTR_FORK);

