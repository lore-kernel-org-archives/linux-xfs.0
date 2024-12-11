Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4329A2594B3;
	Wed, 11 Dec 2024 20:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733947726; cv=none; b=LUkYcW0w7oyu9O/5zFE2hfFj5l+M4Aabfk88SP+GsYON8aNMhu9KEhdJBbQdGwy40ZhJwFu+H+TDg8j9XBySxpDfreut2D2jRmFKexg30f5Mcf7ZDo/1VlxqSa+gWfhB7IH1fFWRE2QQnD1+DjvJ0rhd9DtS4uGN2QEq289BoR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733947726; c=relaxed/simple;
	bh=V4djZAqloTW/JtfS6BayRTkU4mK+EkNDZzNG2jMMdQw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A8RvctKnDzSQKwx0MaX5aZEDuHrTgYjGLgO1FXsO7kuF8EUReFmUVqOThV7HI5ja4JFs8N8KKXTaPHIrElQSn+M7Dwly+SiLp35ScJfrL+ssyOaFjmxOBaMluYBY7w0YoofGDe9lLSwYfH8pmyNErJ1YAhx1B5/n73sgncf3dqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QKDpOYEk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QKDpOYEk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19708C4CED2;
	Wed, 11 Dec 2024 20:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733947726;
	bh=V4djZAqloTW/JtfS6BayRTkU4mK+EkNDZzNG2jMMdQw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QKDpOYEkOvh0xD/9D3KKTUMw3Q3NvZw2hrOGTkqQRqpFQIqGQkp4i2Ci+/4ntiKRR
	 oCJNWoys0n8I/kycl7IhqYNimqB7LsCArC/PKCdPxFH1IYzEVD0ry7oplNminiJOhi
	 r+ktlUhLfbE9qmPo+GJ774odRTYNdGjDPZwH7QeKrC4Ozutni+1njXzZG5lgsk7cqF
	 NOx04gVj4oEg4V68wXKZxt/gjCSrZgHUvw0AZoEFncDAQQKFc9giKTJ+t7czyaQjzY
	 oDt2fDhi4KwgVoXCur2aQaPiatCwkk1AaZUSV3Leddrm1FeawOInGR7CFrH8zzbzD6
	 VZo0Tx0B8qjaQ==
Date: Wed, 11 Dec 2024 12:08:45 -0800
Subject: [PATCH 5/6] xfs: return from xfs_symlink_verify early on V4
 filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173394758153.171676.9419928146112357260.stgit@frogsfrogsfrogs>
In-Reply-To: <173394758055.171676.7276594331259256376.stgit@frogsfrogsfrogs>
References: <173394758055.171676.7276594331259256376.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

V4 symlink blocks didn't have headers, so return early if this is a V4
filesystem.

Cc: <stable@vger.kernel.org> # v5.1
Fixes: 39708c20ab5133 ("xfs: miscellaneous verifier magic value fixups")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_symlink_remote.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
index f228127a88ff26..fb47a76ead18c2 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -92,8 +92,10 @@ xfs_symlink_verify(
 	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_dsymlink_hdr	*dsl = bp->b_addr;
 
+	/* no verification of non-crc buffers */
 	if (!xfs_has_crc(mp))
-		return __this_address;
+		return NULL;
+
 	if (!xfs_verify_magic(bp, dsl->sl_magic))
 		return __this_address;
 	if (!uuid_equal(&dsl->sl_uuid, &mp->m_sb.sb_meta_uuid))

