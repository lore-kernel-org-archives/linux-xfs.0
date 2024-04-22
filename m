Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8BBC15381B
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713804037; cv=none; b=R8yPPh1TahpHf/G+KV1mfEdyqFCEqNiSz6jWeaSBQ35T4OzSJ95T5j0FzICfGBfNRyTGgZXIw2XvS03Rdrl5hUNNu92EphhVMcWfNDUURegkwjQlCSYV50Krp/ctD6eJLU8Fh3mG/rjMvUgyAaOik4w9hMlUYX4yVMb/WZZBvs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713804037; c=relaxed/simple;
	bh=oF03DLwISG1prDAiIQXsFBh/32NfQqJDWtv8zvjnMj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uI0sOKbwFCu0ljMPAr6dMqw1KOUzO38KN1X8XMaVJg8qJjTCejqls5e+ASR6mSksNyiXZG2wHUj/vvSPzNwY/qtgAwPaC704Ey4NPHFcXm1CwbxxGrYV9SxuxH5MzERl/ODRQYNGPUfC0s5R6IO0j2njYt+67d7KqaSQMqL+Zbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vCFBZPA7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vCFBZPA7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F881C113CC;
	Mon, 22 Apr 2024 16:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713804037;
	bh=oF03DLwISG1prDAiIQXsFBh/32NfQqJDWtv8zvjnMj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vCFBZPA7w9hHt+a4Pes2TYjqfsqlK7r3wn+dxAUZTZzsOZQv5oR2qEskxDejhLXiN
	 AD4rDGIWjfaHY5c/DQud4COvs9CNM9PxZGiIc+yx6OJyrLq2zrLugL4ftR5TY4rXGS
	 7clBxw331Gs++zsCVz5uZ/0hwM1o/uRLuKnm+hf2t0IBJuZxPW1iiST7d9cKFkGX0t
	 +ByEFHgvFVg1vBnnAzvrB0FZo88fiQQcLba20RjdIMcJYXsTGrzE5kZCcOfum2z7ED
	 MUlALE5sD77mk8FQdo5YNMyT2HYIVLLKZUw9zS5YO9kHVAyvuJsVrLu4cMdcoQ4rEi
	 8b3rUqwzU2sCQ==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 59/67] xfs: use xfs_attr_sf_findname in xfs_attr_shortform_getvalue
Date: Mon, 22 Apr 2024 18:26:21 +0200
Message-ID: <20240422163832.858420-61-cem@kernel.org>
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

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 1fb4b0def7b5a5bf91ad62a112d8d3f6dc76585f

xfs_attr_shortform_getvalue duplicates the logic in xfs_attr_sf_findname.
Use the helper instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_attr_leaf.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 8f1678d29..9b6dcff34 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -845,23 +845,17 @@ int
 xfs_attr_shortform_getvalue(
 	struct xfs_da_args		*args)
 {
-	struct xfs_attr_shortform	*sf = args->dp->i_af.if_data;
 	struct xfs_attr_sf_entry	*sfe;
-	int				i;
 
 	ASSERT(args->dp->i_af.if_format == XFS_DINODE_FMT_LOCAL);
 
 	trace_xfs_attr_sf_lookup(args);
 
-	sfe = &sf->list[0];
-	for (i = 0; i < sf->hdr.count;
-				sfe = xfs_attr_sf_nextentry(sfe), i++) {
-		if (xfs_attr_match(args, sfe->namelen, sfe->nameval,
-				sfe->flags))
-			return xfs_attr_copy_value(args,
-				&sfe->nameval[args->namelen], sfe->valuelen);
-	}
-	return -ENOATTR;
+	sfe = xfs_attr_sf_findname(args);
+	if (!sfe)
+		return -ENOATTR;
+	return xfs_attr_copy_value(args, &sfe->nameval[args->namelen],
+			sfe->valuelen);
 }
 
 /* Convert from using the shortform to the leaf format. */
-- 
2.44.0

