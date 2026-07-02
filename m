Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CEF7306776
	for <linux-xfs@vger.kernel.org>; Thu,  2 Jul 2026 20:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783022640; cv=none; b=Jas+IiqgPzQOE07agV0dIh3/XY7g47FXoRsUANZypZbi9FSQwx4rMX8RZYBY1+1BrF4NqiwXT7YxwiQjGTxnt7KQM2vDOwBoom0plkCMn27goT+gNHM2Zbho1lOc2g+CD1i2kZsAhYrISybfukXijnnQSW6l88QKuzYztMHdzsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783022640; c=relaxed/simple;
	bh=f+6VFjKjQHE7evgMiDzfJuvEk1InBCb2upDJwqXujnM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BRf8QDjT2pk0/e8vgdEuqWZ+Z5fysfF+mpayzo9kT8k2jaVGmTNn8fxlINnZfqeqjiYNx0ve0HyK/DzV0XPD/LlHDYW9FkBJZBKfFFeMWeSMEm+acvVRkziwwGc34LtR7Fuc/g5msyOe6mF7cOarYu7ImFKUlfhwEcODSm7QJ6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PSdK5yhE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PSdK5yhE"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 265361F000E9;
	Thu,  2 Jul 2026 20:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783022639;
	bh=eUNduDmQ9xpPKdxCHC2yTc9hujjLWtcH1IV1o9OmG6k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=PSdK5yhEkuDaPu4J3XO80XDgtFlY9hwKp7uWLojQCfpS77R0uMSelK2wzm5gHPDT6
	 1d6Da/BgvnMhSYjv9mUOBrE1IZAdGSOXJNUjz72Ovqr9G+f4597dROMb+6c5VN7Pf5
	 wz8+0YrZfuW2obPVOsZ9qTPIzMAx+tY6fIe2Tmex01XmN2IXRYQZe6aXFVWQ6A1ZEJ
	 sD/mhzuRq6VD1r/GJ/m9D0i+EhRhcKOLTlpE9TEevVJ3Vbsp1eoeSCeJFw7U5XvaWu
	 xNBahbKU8gUFkYbFiuVquLGt/WsPkXNSU0O8o62XWGnElOOUi4OG7bOt58RX+2t7rz
	 rYAZCgfjAFhvw==
Date: Thu, 02 Jul 2026 13:03:58 -0700
Subject: [PATCH 14/18] xfs: mark struct xfs_imap as __packed
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, cmaiolino@redhat.com, hch@lst.de,
 linux-xfs@vger.kernel.org
Message-ID: <178302226564.845537.7107122948483737861.stgit@frogsfrogsfrogs>
In-Reply-To: <178302226213.845537.4378925114415707650.stgit@frogsfrogsfrogs>
References: <178302226213.845537.4378925114415707650.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 4f16139d8e296ec5403c3ebbe874dcd5c57648ca

This returns 2 bytes of padding at the to struct xfs_inode into which
this structure is embedded.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_inode_buf.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/xfs_inode_buf.h b/libxfs/xfs_inode_buf.h
index 57192adc774491..f3624532b0238a 100644
--- a/libxfs/xfs_inode_buf.h
+++ b/libxfs/xfs_inode_buf.h
@@ -16,7 +16,7 @@ struct xfs_dinode;
 struct xfs_imap {
 	xfs_agblock_t	im_agbno;	/* starting agbno of inode cluster */
 	unsigned short	im_boffset;	/* offset in inode cluster in bytes */
-};
+} __packed;
 
 int	xfs_read_icluster(struct xfs_perag *pag, struct xfs_trans *tp,
 		xfs_agblock_t agbno, struct xfs_buf **bpp);

