Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2AB3637
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300326; cv=none; b=HomNnMhgKYPjiKawgzPqhOG4+MQBEqrnzg0ci13pmlVViE7zHF/+c58RTM/C52rS99AarhJZmBXmkULhTvoaKwGUIgQ/+DmCE+oAEl9XelM9GXrbTDXKgDeKfa86XCiQp2maxtfUY1/WKTgsR36ExMolTHOxvf7OxEEFtXfU1tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300326; c=relaxed/simple;
	bh=ANNX6y9GsyIBMAVJva7ThZTkbGnteSoVwsdMaTa87Iw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Cru0zt3TiatVe0DO2sQJcnfQyWLGG5r0bu4Y2AyZt6eEWPcRqWzYnTJ3EbkUXw9rFEan+7faUlkNjpoHvpFA9LyDouVeTOU3xKolSggJS+OYcv+2ofCXx9s+Gx8DLUSfAlgqZ9EcSVdP66Lks7MjPBAGck1tDceyfUmZOF1CS5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hkk7qCLH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hkk7qCLH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A736C32786;
	Tue, 30 Jul 2024 00:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300326;
	bh=ANNX6y9GsyIBMAVJva7ThZTkbGnteSoVwsdMaTa87Iw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hkk7qCLHRinRMWI5Obvm1kxMddH78sgDhIcTERd9csZeNCSRaUh2SNX43AtqtCYoP
	 4vNClY0rtlYQtq/N/1lE1fKUrbNThx2zUwQM+O42IBX1NedZam0v+Rd8fmK4uW/YTK
	 VUY7bYeguNUeyHQVG6so5rPhQATOXXwW5+vKXZfUdey6TxZCG4hWA2oESH/J48QHU6
	 UIA4j669+CnkshEWqd19uEP7o03JZA146VT/MrVJ2XbFaf/Ajohs2Vt9ThFmYfRPPs
	 luNEYzYC+FstBpcIQfh3jSOpMfG5N0cxgM9EJqtJf+SU/Jn2Llz445bltzKeFi6vb6
	 DkolUP01qtJwg==
Date: Mon, 29 Jul 2024 17:45:25 -0700
Subject: [PATCH 083/115] xfs: actually rebuild the parent pointer xattrs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229843622.1338752.17056521462803904852.stgit@frogsfrogsfrogs>
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

Source kernel commit: a26dc21309af68623b82b4e366cbbeb5a85ce65b

Once we've assembled all the parent pointers for a file, we need to
are embedded in the xattr structure, which means that we must write a
new extended attribute structure, again, atomically.  Therefore, we must
copy the non-parent-pointer attributes from the file being repaired into
the temporary file's extended attributes and then call the atomic extent
swap mechanism to exchange the blocks.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_attr.c |    2 +-
 libxfs/xfs_attr.h |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index f94e74879..52fcb1c4c 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -947,7 +947,7 @@ xfs_attr_lookup(
 	return error;
 }
 
-STATIC int
+int
 xfs_attr_add_fork(
 	struct xfs_inode	*ip,		/* incore inode pointer */
 	int			size,		/* space new attribute needs */
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 43dee4cba..088cb7b30 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -648,5 +648,6 @@ int __init xfs_attr_intent_init_cache(void);
 void xfs_attr_intent_destroy_cache(void);
 
 int xfs_attr_sf_totsize(struct xfs_inode *dp);
+int xfs_attr_add_fork(struct xfs_inode *ip, int size, int rsvd);
 
 #endif	/* __XFS_ATTR_H__ */

