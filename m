Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6091333DEE3;
	Fri, 23 Jan 2026 07:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769151740; cv=none; b=WWPDGYBCQpebZemFE4RpZMJ7nvx/QNQJn4WQP6kr9/oZRmeBYgRYo5/ov1rd2fw9nijpX0imBE4k8hPkb4R/l2JwyPACCbdMKW+QpvbHP1l/dNFI1OCPvAomEO7J9WiQVLaGxKRAlgzaFHIBD/jeNXDbsKWryDi9nE6R4o6E93U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769151740; c=relaxed/simple;
	bh=aAfj7Gh4yctA4Ve8KuEltxzXkSItzNn4HNZmVLAMvDk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CyQ3I7nz2d2F8U9iHYIq8qV5GdCNoGt5u5nuKqAkfxoK5+whqEHyGI71pNUC6RTY2PHOxpcvaGUsd48kf057hIBUZvd76Qw0c+SGmR9bsG5e1dELSIcx3DrwKoiSILHFddIrhaBEURS5BZnkU+FL+3leEs7wDQ/aU42bW5M5omo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kEjpN/4r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kEjpN/4r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDE79C4CEF1;
	Fri, 23 Jan 2026 07:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769151740;
	bh=aAfj7Gh4yctA4Ve8KuEltxzXkSItzNn4HNZmVLAMvDk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kEjpN/4rO7AdfDtmtOQKn9lZRFTfTnGxvvAlTKcvLefGACXDv/cEDsT3CAA3cRcm3
	 m8MpNf4w8Io3dWAL7h+pXEXP/jXMyMR5HpdgcA0/8dZetMITIGX9YNuUp40pDW1kgY
	 bDHCID0SWTbM47fc8k67BBZarGCCIscsRpop5GdxwZJQXb8Jy5DFkbby1cy95dO2BE
	 kc5Vo7T3j0/99r2UpcJLZiegK1gCTpNDapKX/i+/R0xw0MEdhjLLrMRy0Gq/9wdEOc
	 n/7840ze2w9BUb9TxvHxUUZ+P8wujIFjbaWZeRi9y1lMzcMvNBMzMYDOZv8V2E6I5j
	 fYTIC33xIqqHg==
Date: Thu, 22 Jan 2026 23:02:19 -0800
Subject: [PATCH 6/6] xfs: fix remote xattr valuelblk check
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <176915153138.1677392.17817306563793792661.stgit@frogsfrogsfrogs>
In-Reply-To: <176915152981.1677392.17448598289298023614.stgit@frogsfrogsfrogs>
References: <176915152981.1677392.17448598289298023614.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

In debugging other problems with generic/753, it turns out that it's
possible for the system go to down in the middle of a remote xattr set
operation such that the leaf block entry is marked incomplete and
valueblk is set to zero.  Make this no longer a failure.

Cc: <stable@vger.kernel.org> # v4.15
Fixes: 13791d3b833428 ("xfs: scrub extended attribute leaf space")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/attr.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index ef299be01de5ea..a0878fdbcf3866 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -338,7 +338,10 @@ xchk_xattr_entry(
 		rentry = xfs_attr3_leaf_name_remote(leaf, idx);
 		namesize = xfs_attr_leaf_entsize_remote(rentry->namelen);
 		name_end = (char *)rentry + namesize;
-		if (rentry->namelen == 0 || rentry->valueblk == 0)
+		if (rentry->namelen == 0)
+			xchk_da_set_corrupt(ds, level);
+		if (rentry->valueblk == 0 &&
+		    !(ent->flags & XFS_ATTR_INCOMPLETE))
 			xchk_da_set_corrupt(ds, level);
 	}
 	if (name_end > buf_end)

