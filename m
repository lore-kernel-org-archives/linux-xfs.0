Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C57360EF3;
	Wed,  2 Sep 2026 05:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788327847; cv=none; b=YHFC2DQvHPAVZCQ1+A6cOMYs9JqSRCKHPJJ6HibFBBjCoMzYzoA95rfbwOX0+U8eT5f/3+OKMtSXBw+ao3d4oAWVZkzQeqTo4yHq5qMvwln+0rqQAB1RMJ+brFsXrUN4362155XPm84fJKE9Nwq6a7wkxcK/SEjEuMdq6LHpPfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788327847; c=relaxed/simple;
	bh=FSRiZMcHgCGblyOZPd3sgIXkXBYkBzJYlg3LBJZtw9M=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O2+XELs9yux8m14HhhW0cnyp5Zne2V8vUGl2YXu0fQARisk7RWsO8m0tC6skRnFHwUJraME0czVUk1vO2pJ/Z29apMojZRZJYRnn8u4yUm8HBAlsIStjkvEdgs3/IWU7/7YeDtwdKmUphbgNMM0N9SdC8VznKwf8a1dedetWfWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dWZrFzSn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dWZrFzSn"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4FACE1F000E9;
	Wed,  2 Sep 2026 05:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788327846;
	bh=36BrRVSEkQiWuS52MDQeYoQn2smGEYBe6uiOQmmMv3E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=dWZrFzSnsgekd35BYyr6raoTHodj4rCiZKH9yalazgr+2fJvbhkYteBwYbzDPboJP
	 DEjJlWf8L2AXU8DN9FwjL3GR8Eh95fYbffu2XXkPuJHz30HmflKIHdwhLHcIk50PdM
	 FiyXuX/Y10QIzn4pOfB1VDVMiCNr1tUUMvHmSoTSWGe9UkPfoyJoJbrf+AY0drEQYZ
	 SQWk8rSojetY1iqvo0SKVwFcRtTBcbzzKvBBQqmYPttMBN8RjaQEQgIznkEV4IE5J2
	 1PvJvWBLyc6SzOLSF7CNuB+WWkg2eF0PHHvb02XOsK8GjNtHZhkEJLspYbOPJDo5GP
	 9TM1pxHaCQf9g==
Date: Tue, 01 Sep 2026 22:44:05 -0700
Subject: [PATCH 3/6] xfs: don't leak new_bp if xfs_btree_bload_drop_buf fails
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, hch@lst.de, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178832749486.3507209.2422403420847362239.stgit@frogsfrogsfrogs>
In-Reply-To: <178832749387.3507209.8650516312948237987.stgit@frogsfrogsfrogs>
References: <178832749387.3507209.8650516312948237987.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM observes that in xfs_btree_bload_prep_block,
xfs_btree_bload_drop_buf can hit an IO error if writing the delwri
buffer list to disk fails.  In this case, we fail to release new_bp,
which means we lose a locked buffer.  Fix that.

Cc: <stable@vger.kernel.org> # v6.8
Fixes: e069d549705e49 ("xfs: constrain dirty buffers while formatting a staged btree")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_btree_staging.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
index 7314dab4bcfbc6..561fd2c2e95055 100644
--- a/fs/xfs/libxfs/xfs_btree_staging.c
+++ b/fs/xfs/libxfs/xfs_btree_staging.c
@@ -336,8 +336,10 @@ xfs_btree_bload_prep_block(
 		xfs_btree_set_sibling(cur, *blockp, &new_ptr, XFS_BB_RIGHTSIB);
 
 	ret = xfs_btree_bload_drop_buf(bbl, buffers_list, bpp);
-	if (ret)
+	if (ret) {
+		xfs_buf_relse(new_bp);
 		return ret;
+	}
 
 	/* Initialize the new btree block. */
 	xfs_btree_init_block_cur(cur, new_bp, level, nr_this_block);

