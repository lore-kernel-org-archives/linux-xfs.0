Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4CD3BF679;
	Thu, 13 Aug 2026 05:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786598782; cv=none; b=tGpFwDpnuOzw3pQV2mOjXIYafrYNynVZpbJIZ3EHgVdlP4kaKNqz5Uu96rBJose8jsD5uY0mkBBm3wTxKBlNi78Osuv+VMYL6bOCzxHnalQ3cmDMYdtPYkQEsMjn5ZBKCYOZnO+qAHdRlCdBV2pJ/rFyNP5M3yXNaUV3b6Js1KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786598782; c=relaxed/simple;
	bh=ciW2fDzWVlVWQruUlCqr2qEz18ZHF4E2d91a5EIxYV0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GOHH5W1aCtazD88KbpPXKE7puEA2whO0a9PgVAoqF3VdsHpFPduq5AwRH9q3YJNVKU2DHGZXQo1timEN09wsdAjTHDs1zCOQB3lzDQO3NbOZQt4zi4N83tt1xrX5eQLvHXvD4LSRXp63bOxSnOvr6+ZpM3dSUAsOPPNT4391NuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eSJ4LoVb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eSJ4LoVb"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5920B1F000E9;
	Thu, 13 Aug 2026 05:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786598772;
	bh=/ZebFf/BOehBxDthNkHM096TmaGpmYwbdE61E9vwXTQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=eSJ4LoVbySPLkn/dKJv9jaKGLXucecrD52S4ClCrC7sL9nUlx6m5oaolBL1a9FeDU
	 lFK13GYKcvLmdSJ3zBf5sX67SfI92XkMHusvu9pohnm0s9xhB4wavp6KqmbNhAMXNx
	 7+6je5/zPqGU25+BOxR1S3PEb2JsXyOj5lUiEHuQvH3t2FKAnZsGim5svitbQTwsJk
	 TtZYfAPhtKwuflET3A2G92VrzTiOsTYVfZqudjjEmruiI82+XIeUxk549OCRhfgJ//
	 3uBC8VkCljXR3oSt4+a/uveF/dn5fRN44v9DMtr1/bHoOYQYhN3cMkUPCkZO93ZTRF
	 AlaLR/NaBOJDQ==
Date: Wed, 12 Aug 2026 22:26:12 -0700
Subject: [PATCH 3/6] xfs: don't leak new_bp if xfs_btree_bload_drop_buf fails
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178659861940.833922.4172164469168951361.stgit@frogsfrogsfrogs>
In-Reply-To: <178659861838.833922.2269351780488724470.stgit@frogsfrogsfrogs>
References: <178659861838.833922.2269351780488724470.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/libxfs/xfs_btree_staging.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
index c3c7ea54895a60..c5b7613e5216ab 100644
--- a/fs/xfs/libxfs/xfs_btree_staging.c
+++ b/fs/xfs/libxfs/xfs_btree_staging.c
@@ -337,8 +337,10 @@ xfs_btree_bload_prep_block(
 		xfs_btree_set_sibling(cur, *blockp, &new_ptr, XFS_BB_RIGHTSIB);
 
 	ret = xfs_btree_bload_drop_buf(bbl, buffers_list, bpp);
-	if (ret)
+	if (ret) {
+		xfs_buf_relse(new_bp);
 		return ret;
+	}
 
 	/* Initialize the new btree block. */
 	xfs_btree_init_block_cur(cur, new_bp, level, nr_this_block);

