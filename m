Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737054AEE0;
	Wed,  4 Dec 2024 03:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733281413; cv=none; b=C440fAbx79VsYG0NVoGYlzWl2MYGtOBc4s/rqmgrpQEoY2dz370TSzD3dP3eTqEzYoSywHO1p6USUOBVbXaE0q+TN8JcfRFTA/13EHTOi5ZcijNa+2iIJDPhC0SMHSuVA/EHy+ZKSxklW+2KFX/zW3zzh6CsVQfYKev7Wxl91mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733281413; c=relaxed/simple;
	bh=V7+JaeiFYvZqcYmfwV1i+rnP6fIdiZn/TJxuQ2qNsbo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UcPO52dj/J4MtIoqIU8c38e5UXJj9fN3RN5OnhJT3uKKtlzpG+6PUb+dxnmUVfz/WwS8qVFMdazSpR+aREjZx/lhWtPNTFSYiA7FmeW08bmtlU7GoTTJgMyen5Yrqyg9eaRbKiQhb07TNjUDFg5DWuYOfA5F4ZCWGu6skNO09CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bn32eHC+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bn32eHC+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D19C4CEDC;
	Wed,  4 Dec 2024 03:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733281412;
	bh=V7+JaeiFYvZqcYmfwV1i+rnP6fIdiZn/TJxuQ2qNsbo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Bn32eHC+7fZdlAEmWGBtvDgv7g8gRvoLrB/yZoiCt1Yrl94pXVlS9r2mOHNzzlzzk
	 aQglaTZY0v5Lbd1LaKNUUaEi4Ey3ykdkBdMOV0Mo0DW/QsQ9OY20JK5VVQ7pJwnOkE
	 z1LhbDdE7NMmES3hj8tPKNd3JZGIRsJ9kV74iRDj9cOoM3tgjfXwH3ePo4+gsOWX1W
	 FudG1RW8WQITz148AQ/g+JR3m0iIihG74USGYLU48kTAsw6rjFIAvIoLG0yQXqaw8J
	 TpScgjxV3x9u1LBPjzP+8zUIzt/h+0emFoIDWvwbD3pkJMWHZtwl69eKVVb5KRFeOr
	 oCKv1c12/Rnlg==
Date: Tue, 03 Dec 2024 19:03:32 -0800
Subject: [PATCH 5/6] xfs: return from xfs_symlink_verify early on V4
 filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173328106668.1145623.12239868718203963494.stgit@frogsfrogsfrogs>
In-Reply-To: <173328106571.1145623.3212405760436181793.stgit@frogsfrogsfrogs>
References: <173328106571.1145623.3212405760436181793.stgit@frogsfrogsfrogs>
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

