Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E9243AC7
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706817428; cv=none; b=YkA7Fp2kBPYOBN/Q2H4KsrRUZ0vP3CR0EY4fE3XfvwzIT95LYncPzGHiUAmBC2BUxdtd+w3Ue6yDptZ0kxkqgHSgDkVOC9VrvRyTfy3r8t4hYub+1gDbEhiIro5ikMupUKEhRlnvFoK1Ra3lSp5j168WknvvOh8YTnn5Te0bpls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706817428; c=relaxed/simple;
	bh=ovwyFg4u24nQhwGTq523TWlP1uhs6c2HSH1FTG6vpzE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sm1YfcC1EqPEYufvth2OjZ55OylSKCCv46QqImNAwXBS6H1ilVN8TEEnmyrLc+aJ6pbs4x2gwWdOtjmcaIQI7mkDmRrCw4mFrAnWFthIWwb4NUaUUyT4hOft8hfdjRBqf0qOsLDJAfnTiqh2ZbrYgcKyEwNW43Pqx/9nVshAdzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PoI5JIfn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PoI5JIfn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E23C433F1;
	Thu,  1 Feb 2024 19:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706817428;
	bh=ovwyFg4u24nQhwGTq523TWlP1uhs6c2HSH1FTG6vpzE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PoI5JIfniFmJGaWPEyMDATdTQIuAV4syOjQxxOZYocjcUB2CBGsvysqZASJs5GYfZ
	 n7disJaHu5aqD1ekiy1rLtyxZ7GSvjzwKSgyJ9Jf6t6BNQt4UIxpy7uwo+oxCfpifN
	 PIB8oyEIfdrbOhcNUhCrlCzVBjnNWyG+iIEisL+SDvMQOeXe/FsCtkIu+hDfJUyshs
	 a3XLH2L/Oqa+z+SY2uB3vR0JB8Z6kqpyKxLz4fJyoKVZNQmV3OfERloHO6yDe6ghRC
	 0e8odOragqfcD5VcpcpC2K8ysW+9iQbiHILlJKFibhLOPIvqJ5BsVv8N2+0BFW4Isd
	 y23CMwURO/OjA==
Date: Thu, 01 Feb 2024 11:57:07 -0800
Subject: [PATCH 3/4] xfs: remove xfs_setsize_buftarg_early
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681336582.1608248.9353116974964067286.stgit@frogsfrogsfrogs>
In-Reply-To: <170681336524.1608248.13038535665701540297.stgit@frogsfrogsfrogs>
References: <170681336524.1608248.13038535665701540297.stgit@frogsfrogsfrogs>
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

Open code the logic in the only caller, and improve the comment
explaining what is being done here.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c |   22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)


diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 57dd2c2471b18..4c8a2c739eca2 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1995,18 +1995,6 @@ xfs_setsize_buftarg(
 	return 0;
 }
 
-/*
- * When allocating the initial buffer target we have not yet
- * read in the superblock, so don't know what sized sectors
- * are being used at this early stage.  Play safe.
- */
-STATIC int
-xfs_setsize_buftarg_early(
-	struct xfs_buftarg	*btp)
-{
-	return xfs_setsize_buftarg(btp, bdev_logical_block_size(btp->bt_bdev));
-}
-
 struct xfs_buftarg *
 xfs_alloc_buftarg(
 	struct xfs_mount	*mp,
@@ -2028,6 +2016,13 @@ xfs_alloc_buftarg(
 	btp->bt_daxdev = fs_dax_get_by_bdev(btp->bt_bdev, &btp->bt_dax_part_off,
 					    mp, ops);
 
+	/*
+	 * When allocating the buftargs we have not yet read the super block and
+	 * thus don't know the file system sector size yet.
+	 */
+	if (xfs_setsize_buftarg(btp, bdev_logical_block_size(btp->bt_bdev)))
+		goto error_free;
+
 	/*
 	 * Buffer IO error rate limiting. Limit it to no more than 10 messages
 	 * per 30 seconds so as to not spam logs too much on repeated errors.
@@ -2035,9 +2030,6 @@ xfs_alloc_buftarg(
 	ratelimit_state_init(&btp->bt_ioerror_rl, 30 * HZ,
 			     DEFAULT_RATELIMIT_BURST);
 
-	if (xfs_setsize_buftarg_early(btp))
-		goto error_free;
-
 	if (list_lru_init(&btp->bt_lru))
 		goto error_free;
 

