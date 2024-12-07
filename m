Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDED7323D;
	Sat,  7 Dec 2024 00:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733531530; cv=none; b=WJSAFQ+GgGMnPUmwCy/tFLxRB+zpXykmt1kKsZ5aCR+tBrBm6GgT2WHuTMjcynL4ByJl8vFvxBrb6kbKVr29cLDFQ3MuBCr/SCDE9IBxDMyQByySIugJKwrigotfFBE5N5E9ab4oyWBxxafMWuW78g+i9ccJtDOaNsxCjAaAPKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733531530; c=relaxed/simple;
	bh=V4djZAqloTW/JtfS6BayRTkU4mK+EkNDZzNG2jMMdQw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iByZYjEjkgXhHsGepCVxGerfPx2HH/CL0p1RtCHCJpEN8iLpt+/fYN6tfV8bsMz3GD5Qwf5okBdn6dC1A31yil8/u0dKljJELajcoHi9Q37Gvg0VgD7q+ePYNUNC3Y9x8MWFUwp2tu4gzDFpsvCwzRXUk0EcABsYWN2r6dfTjjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=snB548vE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="snB548vE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 289B9C4CED1;
	Sat,  7 Dec 2024 00:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733531530;
	bh=V4djZAqloTW/JtfS6BayRTkU4mK+EkNDZzNG2jMMdQw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=snB548vEXgkC8woN0KcgqTRbygMPYI10UDw2NEfpo9fnNbJgot9k5I4HZ8GLKWaqo
	 eeku+dnxZbk1SZf1KYYXmMDG6BqSexOBYWP6gfMQ/jKt07/y1qBrdjr4uMDsJLy3XX
	 rbttgIL+SmEwtIUXyM/sKtmgBTsDtXg/ezRHmteXGCWoK8wvXl8IYtjGC14MMjLTql
	 nsur/k8/XmL4ODnuRef2XLo7NNPfe6YWh8c8XqkcqRdMuYZSO59VVfg9vnq0p+KFQD
	 h90t24yP+1suOfahBXipZsWaq1uAGLl7ib9P2eLoCMFGbly/JKPBGqVXgGGDT24ar2
	 RyereaEqrt7ug==
Date: Fri, 06 Dec 2024 16:32:09 -0800
Subject: [PATCH 5/6] xfs: return from xfs_symlink_verify early on V4
 filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173353139385.192136.1552414924467294012.stgit@frogsfrogsfrogs>
In-Reply-To: <173353139288.192136.15243674953215007178.stgit@frogsfrogsfrogs>
References: <173353139288.192136.15243674953215007178.stgit@frogsfrogsfrogs>
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

