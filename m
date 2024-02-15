Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BBD612BF0A
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707998958; cv=none; b=jZ1Sq9aY1IS+RzQmKpKN97I65JhqwLKof4fiEExjsWnI0gduF0+J+6cyHNvTq7VAxYc8logj/upGhy0Q4mHj9uqvZ9Yww7jHTz4sPXG6N3V36AP6AhyNoBhcyuN30wWL3IvshyK/WJ1ebz8mpg42+MQnwD3XbCKReQcwC/HnP+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707998958; c=relaxed/simple;
	bh=0kGi0ZBqv4YPq+st3TjI96DpFb7s4oMCZSz7ydWjXQQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MtPG/SzDeKXbqgYOVZ1tT+hlbt4dRyB5y2JZQZlZCtTzLTz99nnRO3ImNbLIANqIpYQHCJmuzLyH+wDjzpGvpYqGaNsO0TeKksomuQBvr2+x6rXgwSm5futqfDR23EjAVfnvmPJdafP81FdQoOeWqW9W78FK8/3A37LgTEvRNzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BRBhyK7Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BRBhyK7Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38B9CC433A6
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707998957;
	bh=0kGi0ZBqv4YPq+st3TjI96DpFb7s4oMCZSz7ydWjXQQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=BRBhyK7QIjSSF78WWVtoIt9i3FBp/037HMbgBupCUkK1FIOMSmTJSOO0wFXVd/c54
	 qBgBkOwPX4YfIDWeiHkMhe7zGTnOtO/F9k7szXJXbrB6Z99Iev54zPeEymHtV+dSso
	 /ADiflceIv43jIY4xOy66gcaPiGrIMnL/+tbd092180zXcZOI5bZgbhZnnj7Xu1sWH
	 j4q2vipfPIWxOADD+Nwfl8TtsQS9AhaMw/Dn/G3a/W9l4yGRYRsWJ+G36ZspILBloP
	 clWBhDju11u8Bmne9igHf3X6PJGftnjQmqqGqljA70Gvhin7Px477oy6IvCZEuhrfd
	 +Ep1Pg11OrZZQ==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [PATCH 03/35] xfs: fix units conversion error in xfs_bmap_del_extent_delay
Date: Thu, 15 Feb 2024 13:08:15 +0100
Message-ID: <20240215120907.1542854-4-cem@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240215120907.1542854-1-cem@kernel.org>
References: <20240215120907.1542854-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Source kernel commit: ddd98076d5c075c8a6c49d9e6e8ee12844137f23

The unit conversions in this function do not make sense.  First we
convert a block count to bytes, then divide that bytes value by
rextsize, which is in blocks, to get an rt extent count.  You can't
divide bytes by blocks to get a (possibly multiblock) extent value.

Fortunately nobody uses delalloc on the rt volume so this hasn't
mattered.

Fixes: fa5c836ca8eb5 ("xfs: refactor xfs_bunmapi_cow")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_bmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 5744b882b..6fbfcb25a 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -4820,7 +4820,7 @@ xfs_bmap_del_extent_delay(
 	ASSERT(got_endoff >= del_endoff);
 
 	if (isrt) {
-		uint64_t rtexts = XFS_FSB_TO_B(mp, del->br_blockcount);
+		uint64_t	rtexts = del->br_blockcount;
 
 		do_div(rtexts, mp->m_sb.sb_rextsize);
 		xfs_mod_frextents(mp, rtexts);
-- 
2.43.0

