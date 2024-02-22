Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CAAE7175E
	for <linux-xfs@vger.kernel.org>; Thu, 22 Feb 2024 22:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708639472; cv=none; b=PgeZWPrSvuqDLp7Y1hH0gg+Uz3PSsmwUqkF/s7OQYGJyHskYjSXPiolEWT6eRPsAlBUhQs+NL9hwvDDlYvH/rO5D+ZcACSJlU/9w5VeBm5eLUnZOwkkmqvM+P7SJmd+hj+x9JWKExhyRwDzJCBqlv/5/jrAXKCkEeJkIuVZlh8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708639472; c=relaxed/simple;
	bh=wMWZS8srfgXvUwowkm/jjQ67qHfMh9NIfjCDmqeOA0s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NVIbE9E9Va/jIPGuT3arMfkfR+tLLhplAvITe93d4TKCQ3G19+ponQVFKNureZn5OkIn+Q4rR4omSmgro787ghVc3ZmDw4LwUIeARLD50KgOR6MdB4B8iEvhigU3RjLEpMFFVeeDMcSTzB1Ly3igGxKfqqWRzSBtasa6AE13z8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UTQisqDy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UTQisqDy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6C3FC433C7;
	Thu, 22 Feb 2024 22:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708639471;
	bh=wMWZS8srfgXvUwowkm/jjQ67qHfMh9NIfjCDmqeOA0s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UTQisqDyR6KFbSLdcCTQo9n0mH/ZgMksJgZ9UC5vuOErqmmuDxpNE67DUCapDd3o9
	 KZUfW2rOQOfSty1KSJ++qGLnENb3izVuhN5+d4evNzyci7D/1gmZZKpR7e5XyGpCRG
	 +5gQSanHqIrn7pGCVAJDiBia9LrXd4bt/WBMA80+MM/QISv/SYaMGfiZL1riDUPl5s
	 hv+q8PMk/SuRN1PndCzMW4HpM2F5qO8lvCSNxw/18mPCPnN3DY7hg5q5r92OxTRSbe
	 Vk1rz4wHkTYpPOho7A2/BdKxDoKIDM4Tk5FVWbnYPeebtVXxbZ/ElaJcRVenAavQdn
	 DOg0w3Mwptplw==
Date: Thu, 22 Feb 2024 14:04:31 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH v2] xfs_db: don't hardcode 'type data' size at 512b
Message-ID: <20240222220431.GJ616564@frogsfrogsfrogs>
References: <20240123041044.GD6226@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240123041044.GD6226@frogsfrogsfrogs>

From: Darrick J. Wong <djwong@kernel.org>

On a disk with 4096-byte LBAs, the xfs_db 'type data' subcommand doesn't
work:

# xfs_io -c 'sb' -c 'type data' /dev/sda
xfs_db: read failed: Invalid argument
no current object

The cause of this is the hardcoded initialization of bb_count when we're
setting type data -- it should be the filesystem sector size, not just 1.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
v2: rebase to for-next
---
 db/block.c |    3 ++-
 db/io.c    |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/db/block.c b/db/block.c
index d730c7796710..22930e5a287e 100644
--- a/db/block.c
+++ b/db/block.c
@@ -124,6 +124,7 @@ daddr_f(
 {
 	int64_t		d;
 	char		*p;
+	int		bb_count = BTOBB(mp->m_sb.sb_sectsize);
 
 	if (argc == 1) {
 		xfs_daddr_t	daddr = iocur_top->off >> BBSHIFT;
@@ -144,7 +145,7 @@ daddr_f(
 		return 0;
 	}
 	ASSERT(typtab[TYP_DATA].typnm == TYP_DATA);
-	set_cur(&typtab[TYP_DATA], d, 1, DB_RING_ADD, NULL);
+	set_cur(&typtab[TYP_DATA], d, bb_count, DB_RING_ADD, NULL);
 	return 0;
 }
 
diff --git a/db/io.c b/db/io.c
index 590dd1f82f7b..9b2c6b4cf7e9 100644
--- a/db/io.c
+++ b/db/io.c
@@ -652,7 +652,8 @@ void
 set_iocur_type(
 	const typ_t	*type)
 {
-	int		bb_count = 1;	/* type's size in basic blocks */
+	/* type's size in basic blocks */
+	int		bb_count = BTOBB(mp->m_sb.sb_sectsize);
 	int		boff = iocur_top->boff;
 
 	/*
