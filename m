Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A05233954;
	Wed,  2 Sep 2026 05:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788327956; cv=none; b=j8EXbvg0Pf/T+L63cTf6BhVlG9cbv0FK0ziK/3J8i8AvG+wv88e3cwCmMdAxaYE0bz/nB6p+Mk8sTcdsqERtsIdyQ+wJxTyJ0rVA0lKn9QY3albhkwqT8+3wkXPezvZTVGaIE1dEQiHmNlIZ9N7y/wHxWIBSWKJ2UH4SOxIYTjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788327956; c=relaxed/simple;
	bh=gbT5f3yJ8IW7gkoA4iBWhmbvWCr5aMj1OAB0kbZksD4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MXD38X+/LzVS6rRf2X1Y66/iMl/giQtSzzv5UW/Dj619/hywx92nwcp9rDvqfuL5MPUedydXugvZWFNQgl+mG4jWLr3m4aI9vV1mUEQHE9G3cDBw6F+P+gngtBiCmz1HKii+1eGi5GFw1uC0ZB2/vjkoUsPOmg7hqKLxW9H/hFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HL1Hqx+y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HL1Hqx+y"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E9BE51F000E9;
	Wed,  2 Sep 2026 05:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788327955;
	bh=0cb6qrC234NhP7I6aNY49uDD1BdV2YbOpIXaXub4VAU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=HL1Hqx+yTjgbV5VzgOrfQVoH8lxt/C31bBN6CyFDT9siu4Y7HG9Bu6NpRHB6EHHqX
	 mVT+cBz8mplusaWy0k1gR1WIWHp7WP3AhEhnarAvsFT/r/3T6M47DgZ4Py3Kh90ZO5
	 eCK0DdAMcq0eQ/ZRjwl6YlcWyAHhho/TbDmdFDfoIYalFhLLYI82We5yu6bNdv0HR9
	 PoY04G7vFo9omBysZLKB6hMcvWq8q+LhBJavBdOQb8MbD2rEqrhkcyMLvqls7JpfH6
	 bzZw6RSAwmBvGn20tHtC6W8yTg2Zqr+hMDyF9KfDGuycmWAn9ETc0ye2F2Trosi7BN
	 wUf5S0vsWQzqg==
Date: Tue, 01 Sep 2026 22:45:54 -0700
Subject: [PATCH 4/6] xfs: fix parent rec lookup initialization in
 xrep_metapath_unlink
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, hch@lst.de, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178832749919.3507493.3754361272073071859.stgit@frogsfrogsfrogs>
In-Reply-To: <178832749800.3507493.12247008945704358106.stgit@frogsfrogsfrogs>
References: <178832749800.3507493.12247008945704358106.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM notices that xrep_metapath_unlink looks for a parent pointer in
the child metafile that it's removing, but initializes the parent handle
using the child.  This is obviously incorrect, so fix that.

Cc: <stable@vger.kernel.org> # v6.13
Fixes: 0d2c636e489c11 ("xfs: repair metadata directory file path connectivity")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/metapath.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/metapath.c b/fs/xfs/scrub/metapath.c
index ff1ff762b3003c..9f44c82910eaef 100644
--- a/fs/xfs/scrub/metapath.c
+++ b/fs/xfs/scrub/metapath.c
@@ -397,7 +397,7 @@ xrep_metapath_unlink(
 
 	/* Figure out if we're removing a parent pointer too. */
 	if (xfs_has_parent(mp)) {
-		xfs_inode_to_parent_rec(&rec, ip);
+		xfs_inode_to_parent_rec(&rec, mpath->dp);
 		error = xfs_parent_lookup(sc->tp, ip, &mpath->xname, &rec,
 				&mpath->pptr_args);
 		switch (error) {

