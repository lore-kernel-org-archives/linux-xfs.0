Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766E410E3
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299950; cv=none; b=QxMYWnhN2rAsdSHRBcg8mVPVFDoj+Nh5Xi/89G4cB4Q20It7icOTc6WRFYxMUN3shO/C+cUDL686UEcFp791p7vm2QeSsH3DBzCYtOfx1sMf2yr8TgkEYfEqBaQtQ0Xq2vitEcSyi7a9V6r6YSiFFy22I1C7mhQVM6ZZwe2Iuso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299950; c=relaxed/simple;
	bh=3+pKoZQjLt/xLVUBXLyXVTAhNOikciOmHkfLJQ/NvCk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SmYEWmNWDgdxtzI2yWcE4wgHRpb2E7RntxxhgMZxpPpYGIFIMaMXgirqtt4lDBh7XY+JRApziB9SOjrivonAQXyEtT72eFrVw/dUUl8Zw2AEjMm+rjuqk9JYFV4dLk9kfZftD5lBU3a41giNE1sffzmGWm3W6emVyDX+4r0i3cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MVn7SK9P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MVn7SK9P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F0DCC32786;
	Tue, 30 Jul 2024 00:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299950;
	bh=3+pKoZQjLt/xLVUBXLyXVTAhNOikciOmHkfLJQ/NvCk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MVn7SK9Pn3v40+FZYbz1qMjVoSG7tcDWQ+Zgwv2oaRSzrUl/IQUVjdcEyB5h6zPL0
	 qmb1nyk2uuwI2FdbhEuZ9Y/5f4cQ6jCDRvV1siyWmIIO0sTaWQ0Bprv5oe02PZxoDA
	 rxebE6paDS6a5skXBamPuJ1YP7ZMIUnTss5PS0bMtHoa3W8JZgAyk9ZH8qtUyPiBtm
	 g0njVSBZp1P8/nrRlagIbHbcErgdCfgwLISAkhPrUIV/mdV4XrK2cJC8qJACWEMGN7
	 b4WyJxdgaTx9PS5IPY6gDii4rlpr1klUARRpL0DSmOkvHUg7+GgezDtT6UVmMH/Zc+
	 M/5SUqtA0FFwg==
Date: Mon, 29 Jul 2024 17:39:09 -0700
Subject: [PATCH 059/115] xfs: record inode generation in xattr update log
 intent items
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229843274.1338752.7824640779877837531.stgit@frogsfrogsfrogs>
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

Source kernel commit: ae673f534a30976ce5e709c4535a59c12b786ef3

For parent pointer updates, record the i_generation of the file that is
being updated so that we don't accidentally jump generations.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_log_format.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 632dd9732..3e6682ed6 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -1049,7 +1049,7 @@ struct xfs_icreate_log {
 struct xfs_attri_log_format {
 	uint16_t	alfi_type;	/* attri log item type */
 	uint16_t	alfi_size;	/* size of this item */
-	uint32_t	__pad;		/* pad to 64 bit aligned */
+	uint32_t	alfi_igen;	/* generation of alfi_ino for pptr ops */
 	uint64_t	alfi_id;	/* attri identifier */
 	uint64_t	alfi_ino;	/* the inode for this attr operation */
 	uint32_t	alfi_op_flags;	/* marks the op as a set or remove */

