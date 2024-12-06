Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA74204597
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528428; cv=none; b=JPSOm9cOu7EPEloYrDiS0RA/qQyTIFDtMgv/CpiotFo80Y3aUnyMgiB2Q0vGwXLyg7qqFtUppdBFdlXuShNQLgereQFgGgCL5TZMu9j7A3lKjWaRDxk0pHNSuxqKK5OsmBCNGiHTQMIBBZigeCvpI6ZoxP2j2x25PoSyMt2V4aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528428; c=relaxed/simple;
	bh=kWE442pT3RSOyEdCIrLuZKELUQVa+ZtuM6POBwDpYms=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PHTVIKZ/ilFJv88+ZwtrHUGpMohYDEWlWaRlCWJ4lEaVsu218Df342cf6sCEXOOxFX0quKurEl1ioFVKJsBK7rtv5iPaUb5sMcGCNQew+nYmRropkM/KrK7iXH+BpNvuN4MchcKu/VXFDry8g9T0wBy77PnTTT1vRIc4gkQRKbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SKANkoMg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SKANkoMg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AB9AC4CED1;
	Fri,  6 Dec 2024 23:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733528426;
	bh=kWE442pT3RSOyEdCIrLuZKELUQVa+ZtuM6POBwDpYms=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SKANkoMgUPC71z1Ty+QmSpYlwX53m+PaFRfUEzMUi2jX0SaspXl2C268lIj7HsFfV
	 oxxmUeMk+aHajCajB5C5GwWB8+ELBZRsm4KzhfV97qBgGQTX3Ut+zdRwkb3o9589Op
	 Oy7A5rNylfodd7e4xDHvaS2GI+P2Vi2EIfCyDeG148TdqUxT55RDsq+IZWUcRZDr5B
	 +xwliyqOPQVmIs3owchVLSspNFiNjlpkjJk7aeI7bDyFjDFIVXWmO5jz9LPFuauosw
	 CiZVQmdqrHROkYX8zS8HNhMX5rtuqZWHt4aP4xRTPrDkeL+zOOBhJk4p8LPdnjlhMK
	 X9fMSLKBncEwQ==
Date: Fri, 06 Dec 2024 15:40:25 -0800
Subject: [PATCH 03/41] libxfs: enforce metadata inode flag
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352748285.122992.13009433643018497044.stgit@frogsfrogsfrogs>
In-Reply-To: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add checks for the metadata inode flag so that we don't ever leak
metadata inodes out to userspace, and we don't ever try to read a
regular inode as metadata.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/inode.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)


diff --git a/libxfs/inode.c b/libxfs/inode.c
index 1eb0bccae48906..0598a70ff504a4 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -208,7 +208,8 @@ libxfs_iget(
 /*
  * Get a metadata inode.
  *
- * The metafile type must match the file mode exactly.
+ * The metafile type must match the file mode exactly, and for files in the
+ * metadata directory tree, it must match the inode's metatype exactly.
  */
 int
 libxfs_trans_metafile_iget(
@@ -232,6 +233,12 @@ libxfs_trans_metafile_iget(
 		mode = S_IFREG;
 	if (inode_wrong_type(VFS_I(ip), mode))
 		goto bad_rele;
+	if (xfs_has_metadir(mp)) {
+		if (!xfs_is_metadir_inode(ip))
+			goto bad_rele;
+		if (metafile_type != ip->i_metatype)
+			goto bad_rele;
+	}
 
 	*ipp = ip;
 	return 0;

