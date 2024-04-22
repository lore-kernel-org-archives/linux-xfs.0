Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2202F153BF7
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713803962; cv=none; b=aJ4W8IM/nR88gy/P8//uIdO9R2tjeD13FO+QJsLsF0FKE9+3clDGAjsvCRkHkiIuU5zisbeDCWfcVHoKezthBkepjXD1Bv6Ve2D9KDzVH6Wis4GNlSGiy2v5ydupGyCnpqq4SjQt8BLTdJC/D8DvBX4Te9AM0wf89AEaeKnIKYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713803962; c=relaxed/simple;
	bh=upFCa2zekQJMDxaf5T3z9kreVl94PuC7kL4jmDWNqVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fecfWwMsGtaiN7nFhpuzk6qd2IjPZICp+ODiSP1VtwnyR3Vh77vhBHEvoFhSRJcAJ0ipesNrfnPo+u8v5nIdzX1y37klo5QtYtq6JBP6Xfxbtt3WFf+8+oStMS1yakXxo4rKj3ElDxuzUry9Wa6kP/hBwq5Wn0o8hguNWjN6xM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xe+Mjd7x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xe+Mjd7x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD31FC116B1;
	Mon, 22 Apr 2024 16:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713803961;
	bh=upFCa2zekQJMDxaf5T3z9kreVl94PuC7kL4jmDWNqVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xe+Mjd7xs39m9SUUZYF1K/2zg/6MZDbnOQ7l/v5Pp33BMXpKQJ56iAqvCrufNN8na
	 6uwg3U/usUD7+Y9QmGZ5u4mgOItoRuXqLLEVrp3QQS/j3uwl6yH4oCr8SoZGy/b7sF
	 tChgg5xSFSAexmzZGvFafVPqH6iBlPMi/Dg94CuM39n7iKDDWtOlR2S3KufSHvXVvP
	 22cfAPSb7ff12uKvPQtqAYVoytFHCCu+egzjeD3a2glMv6Y0QRzKp6WEBLQhraBqGr
	 3cDNOpb1onn56ugEhbmepyiLxM4ZnTJXpWL0dp/8DSO8251NwWEFKA2kAo41uKWH9t
	 bhw7UE6+lGjXw==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 09/67] xfs: hoist xfs_trans_add_item calls to defer ops functions
Date: Mon, 22 Apr 2024 18:25:31 +0200
Message-ID: <20240422163832.858420-11-cem@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240422163832.858420-2-cem@kernel.org>
References: <20240422163832.858420-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Source kernel commit: b28852a5bd08654634e4e32eb072fba14c5fae26

Remove even more repeated boilerplate.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_defer.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 42e1c9c0c..27f9938a0 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -208,6 +208,7 @@ xfs_defer_create_done(
 		return;
 
 	tp->t_flags |= XFS_TRANS_HAS_INTENT_DONE;
+	xfs_trans_add_item(tp, lip);
 	set_bit(XFS_LI_DIRTY, &lip->li_flags);
 	dfp->dfp_done = lip;
 }
@@ -236,6 +237,7 @@ xfs_defer_create_intent(
 		return PTR_ERR(lip);
 
 	tp->t_flags |= XFS_TRANS_DIRTY;
+	xfs_trans_add_item(tp, lip);
 	set_bit(XFS_LI_DIRTY, &lip->li_flags);
 	dfp->dfp_intent = lip;
 	return 1;
@@ -501,8 +503,10 @@ xfs_defer_relog(
 		xfs_defer_create_done(*tpp, dfp);
 		lip = xfs_trans_item_relog(dfp->dfp_intent, dfp->dfp_done,
 				*tpp);
-		if (lip)
+		if (lip) {
+			xfs_trans_add_item(*tpp, lip);
 			set_bit(XFS_LI_DIRTY, &lip->li_flags);
+		}
 		dfp->dfp_done = NULL;
 		dfp->dfp_intent = lip;
 	}
-- 
2.44.0

