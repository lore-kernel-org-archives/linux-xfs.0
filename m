Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B24D3BA2B
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 02:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710295877; cv=none; b=ss2RuaIEpAQwCktIXLuwEp/7HwtuNvYu5VjKi1XGAurq4L2r0kvi5o2nyOIQCcj6iHymARgep6HN1qz9xuk7n4z0VkIMGe0RuRzw8YAEurkgCcZcNJyWjzBp5Cu68nCvqfpfW8FOeKd4GZ47q1IeP6KRFsx+LkKWeZKwCQr/G18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710295877; c=relaxed/simple;
	bh=rueMaKh+/92NCEmH2p+zhBdDwkwoe+93c96fGXS5qdA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pKQiSE8+HcwjYRiANArMGSKfxvZQdAz0iQZf2jBvRhfCqKtBwvdiZdX1bH3Mgt7JeZCkOsytalUrQRCjWwNGVjNQtlSbpEmmOp+ynN/SqewOFgAaV9HGE1LFTYFW3WfWMyn5fP9dhBWkwwlTFDk+abP+bVTvK8pzzMfyGuAvFsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uHzVTjrp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uHzVTjrp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F12CC433F1;
	Wed, 13 Mar 2024 02:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710295877;
	bh=rueMaKh+/92NCEmH2p+zhBdDwkwoe+93c96fGXS5qdA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uHzVTjrpFe+Un8uvgFxNQSsDBSE4sSDa/QSXTLV7Rcq+adFTnOEEAEvPqxT6Uhgrg
	 dypdCFT3hsUaRxV8JA9/opOZ4CwCPxPialLxm/+8Orn9C5GgvIxmy7vbWIEMVFtI1G
	 4K/+x0toLhcqqkTRGSstD321KzZYjhfVKAZvNRtf5Wdxqp0bq6vuumt1e864spHFmz
	 q+gxeJ02xlDSSadkOYtByHVNvKwdLBlptwVz3RkwdpgfIARfDR7L64ycFS1GBK1td8
	 oLsPT+TjGSUnJGUKTTeflR7LVtdWGFxC5VQvgqDDvMtWgE3hn1UBW1Rp8WHRQfcM4w
	 pS4cJ2zUUOAJQ==
Date: Tue, 12 Mar 2024 19:11:17 -0700
Subject: [PATCH 1/1] xfs_repair: double-check with shortform attr verifiers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171029432882.2063555.14424210570382825212.stgit@frogsfrogsfrogs>
In-Reply-To: <171029432867.2063555.10851813376051369769.stgit@frogsfrogsfrogs>
References: <171029432867.2063555.10851813376051369769.stgit@frogsfrogsfrogs>
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

Call the shortform attr structure verifier as the last thing we do in
process_shortform_attr to make sure that we don't leave any latent
errors for the kernel to stumble over.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/attr_repair.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)


diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 01e4afb90d5c..f117f9aef9ce 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -212,6 +212,7 @@ process_shortform_attr(
 {
 	struct xfs_attr_sf_hdr		*hdr = XFS_DFORK_APTR(dip);
 	struct xfs_attr_sf_entry	*currententry, *nextentry, *tempentry;
+	xfs_failaddr_t			fa;
 	int				i, junkit;
 	int				currentsize, remainingspace;
 
@@ -373,6 +374,22 @@ process_shortform_attr(
 		}
 	}
 
+	fa = libxfs_attr_shortform_verify(hdr, be16_to_cpu(hdr->totsize));
+	if (fa) {
+		if (no_modify) {
+			do_warn(
+	_("inode %" PRIu64 " shortform attr verifier failure, would have cleared attrs\n"),
+				ino);
+		} else {
+			do_warn(
+	_("inode %" PRIu64 " shortform attr verifier failure, cleared attrs\n"),
+				ino);
+			hdr->count = 0;
+			hdr->totsize = cpu_to_be16(sizeof(struct xfs_attr_sf_hdr));
+			*repair = 1;
+		}
+	}
+
 	return(*repair);
 }
 

