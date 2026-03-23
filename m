Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1951A3264FB
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 18:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774291858; cv=none; b=sKp5XZ7o6S/iQcoeE+uleCIhBFsJjlQzBGMP+P5XK80hC/R9spUfR9SnyBTENrOcqTqYIuomxo+q1d377gIK1+yPsUSsGZIoquKS169e3p6zGIJrLOoGGm7l/wzZrSkC3HqhQ3gwTPCbmx7djD8oFBVP58gwasmXAzT4XOLPwPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774291858; c=relaxed/simple;
	bh=g8higwjbdPPoy5qm1qLX+cwWLqRjqkp68sR8Ljf97R8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G8TTyXyli+VQHk/cD3DTDuTWsMzBEewfxLPWnoQ9DZzw/o1Sas8Rl+Y+l6aT20EN66Bsl7Lk9vXp22CrRaPNdRYSNNC58YqEMPMu1qyJVEHECUvG7+HuQudgBDBmJTQ6H+EGNQKTSQV9qwIYLhFYWq/wLLqkAMO8XkJwpr37xHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=moQkVHJB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="moQkVHJB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2301C4CEF7;
	Mon, 23 Mar 2026 18:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774291857;
	bh=g8higwjbdPPoy5qm1qLX+cwWLqRjqkp68sR8Ljf97R8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=moQkVHJBWFnsqlCBs9CYQURmhAh2NtIltZozBPu+kXWsREdy5LEaCK6RgWZMvY00h
	 0zFaq91cHZ6SrspTlcT0bUByhkmXmEar4NgVOnDUCT7N/g5csqQhkCWl5UwW6JbIb6
	 p7zoY2e3+2EMCMSQVJWFka+yk1RvjQvABtpDK0sUbUsfjXGy2/oq433unk15Ah3K6g
	 mMfaPIjl3G0KT3r4oXLpifCXm0eSmsmS3H7B6w/5tKqBK62d+g2bFWq1ZzBtqupLJm
	 3cLoDWIXcppxXzfaTWhXdpOR9kWvIIJCHvYhV7HXmOW/sdULugfXj+igE7TOXhyb50
	 I3rrgp68dO+Ag==
Date: Mon, 23 Mar 2026 11:50:57 -0700
Subject: [PATCH 37/40] xfs: remove duplicate static size checks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: cem@kernel.org, hch@lst.de, wilfred.mallawa@wdc.com,
 linux-xfs@vger.kernel.org
Message-ID: <177429121421.2266274.13632343296854137900.stgit@frogsfrogsfrogs>
In-Reply-To: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
References: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Wilfred Mallawa <wilfred.mallawa@wdc.com>

Source kernel commit: e97cbf863d8918452c9f81bebdade8d04e2e7b60

In libxfs/xfs_ondisk.h, remove some duplicate entries of
XFS_CHECK_STRUCT_SIZE().

Signed-off-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_ondisk.h |    9 ---------
 1 file changed, 9 deletions(-)


diff --git a/libxfs/xfs_ondisk.h b/libxfs/xfs_ondisk.h
index 70605019383c32..7bccfa7b695c95 100644
--- a/libxfs/xfs_ondisk.h
+++ b/libxfs/xfs_ondisk.h
@@ -136,16 +136,7 @@ xfs_check_ondisk_structs(void)
 	/* ondisk dir/attr structures from xfs/122 */
 	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_sf_entry,		3);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_data_free,	4);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_data_hdr,		16);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_data_unused,	6);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_free,		16);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_free_hdr,		16);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_leaf,		16);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_leaf_entry,	8);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_leaf_hdr,		16);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_leaf_tail,	4);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_sf_entry,		3);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_sf_hdr,		10);
 
 	/* log structures */
 	XFS_CHECK_STRUCT_SIZE(struct xfs_buf_log_format,	88);

