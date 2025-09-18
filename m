Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7172F83DC
	for <linux-xfs@vger.kernel.org>; Thu, 18 Sep 2025 13:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758200653; cv=none; b=H56OjjTb5JQIddCmhDoTrMbtyvIx04hqp9LgRi0IQNGokVRiW4qdHZ5XHmJW21xaS7hDEBaGcTdTz99cVee1OJj7YU0sSsMghEdCjxxC8lXuPBoyAd/N4I3ovMdMK6yLqUB0IVuwb5k/5XRVfn97TCUemgwobEsfuTl5kg7gW9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758200653; c=relaxed/simple;
	bh=PsQdFFTRfTfU0UWzgkb+LGlvXfQmEuNUOyP9Yrcw2t0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uDQbeH3LQLZu7ROlbeH+x3UmFKEsHz7W7DU+rIs8zW057CacBTw7QAHX6K/Sg4NFL3EjLy8nAMBer3HptdAIS2vL43eS6pi5g1+3ErqD1/0RkPbqD9jgbs23Vg2gTad2+961X1f3ndfIEPExxLJblVusio/uwF5BCzc4qGFnzqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qecrD09w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qecrD09w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC471C4CEFA;
	Thu, 18 Sep 2025 13:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758200653;
	bh=PsQdFFTRfTfU0UWzgkb+LGlvXfQmEuNUOyP9Yrcw2t0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qecrD09wiELExZL9v+8VkaDbmcZ83SPYn79FrpuPBlOZupcy9GfnOt7vgZCvmND57
	 359POKN6tNp2Fc/E7NPx2mRh//lzpxLyr/iUBYGuLB5Q+MnL7F6WLf+ah2pWvFXfH3
	 QTRA3DUhYp7QPhj6+A17AEgZ2AdG2nurf4VmnG3gIIuGQc6fXAxdrkqojCjv5aob6p
	 pgSWk9/pVrbpqiLoeN1i1u0gA9qBZpg28BvpZAfvIS/wXHxHLLwTSe4wIOYsovh9ZG
	 zgmBK0PPT9G85X0jk8eksTg+vrit0nKBqjtafux5hpwYWbpFVi86M/YDzEi5N0G6CC
	 4u5AXutB/7XYQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2 1/2] xfs: improve zone statistics message
Date: Thu, 18 Sep 2025 22:01:10 +0900
Message-ID: <20250918130111.324323-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250918130111.324323-1-dlemoal@kernel.org>
References: <20250918130111.324323-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reword the information message displayed in xfs_mount_zones()
indicating the total zone count and maximum number of open zones.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_zone_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 23a027387933..f152b2182004 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -1244,7 +1244,7 @@ xfs_mount_zones(
 	if (!mp->m_zone_info)
 		return -ENOMEM;
 
-	xfs_info(mp, "%u zones of %u blocks size (%u max open)",
+	xfs_info(mp, "%u zones of %u blocks (%u max open zones)",
 		 mp->m_sb.sb_rgcount, mp->m_groups[XG_TYPE_RTG].blocks,
 		 mp->m_max_open_zones);
 	trace_xfs_zones_mount(mp);
-- 
2.51.0

