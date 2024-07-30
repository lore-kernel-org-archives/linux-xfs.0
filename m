Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580B71361
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300295; cv=none; b=IBHsQKgWZkYbrR8BkkixoSxJnS+XtZzlVNhvjjjzha+e++dIfzoe9SAbbPZjXDj/IlYWRr3Oags6/57NmPHMhh+olkE989WkXDXb+gqK3TgvdKOfDZLEAZ9L/L8C7lNZuhXrzP52GpV+/Z0NktZA2TbPbR/lTxr2Yqta1MsouG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300295; c=relaxed/simple;
	bh=YRQ/ooQPn6Ti2xooAL13FIioxNTNDR4cn/iC+p7eXzI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wq+zrr28KOJNBYWC6WTHPrG3IA9pTKgf7z4ks/ZB+sRH9V8dvnOwwWxye527Pt4+Fr3lSGyg6kNtu5TaM47IHH1bAiAmtHre9GYebZnFIQ7OHadZWuDJzYox9gA74I3ovQECrL7eqe7oQf9helTXZjHzBfWeapHjU1GNLvItMjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vLumEZda; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vLumEZda"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E41B6C32786;
	Tue, 30 Jul 2024 00:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300294;
	bh=YRQ/ooQPn6Ti2xooAL13FIioxNTNDR4cn/iC+p7eXzI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=vLumEZdaSDHB6lS3tEupcxcmVOr74MLIUqYyDJBoK0HmgJOVdPxPynmGe/9PFQQsH
	 4KLO7e1ditaLi1zn0grlbznI9jql9oJzLnG3SFn27mXjbSGXrEgs8Qw4ARA4eu+Z/L
	 w02N0GiGDQUKyRl1EqkXWMpUbiDHiHbaUbBZdHBS202Hf5FCTPnT+mZ9/EuDnG5nnL
	 C0Vjj013JFUfOZJcZezL6ejdHT663S0yodZoGm4JdU+8hMTIdEftylx3tYUoCnWnc3
	 POX7QA8SVomxyxU61FN6hTVU9fU7pZF+yF0xwRpFOcq/QHfDt8d09Di8TOsCcUAx+r
	 rQPaHGBEJpJFA==
Date: Mon, 29 Jul 2024 17:44:54 -0700
Subject: [PATCH 081/115] xfs: remove pointless unlocked assertion
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229843591.1338752.17976717560948537004.stgit@frogsfrogsfrogs>
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

Source kernel commit: 13db7007892694c891fc37feccbd2ac8f227af78

Remove this assertion about the inode not having an attr fork from
xfs_bmap_add_attrfork because the function handles that case just fine.
Weirder still, the function actually /requires/ the caller not to hold
the ILOCK, which means that its accesses are not stabilized.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_bmap.c |    2 --
 1 file changed, 2 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 81dccf275..4cd0ffa42 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -1035,8 +1035,6 @@ xfs_bmap_add_attrfork(
 	int			logflags;	/* logging flags */
 	int			error;		/* error return value */
 
-	ASSERT(xfs_inode_has_attr_fork(ip) == 0);
-
 	mp = ip->i_mount;
 	ASSERT(!XFS_NOT_DQATTACHED(mp, ip));
 

