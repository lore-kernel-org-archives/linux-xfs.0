Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2758D390991
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 00:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772497279; cv=none; b=c2MLZt4XugLcsYPIe8ElSWwz/n63J7NEDy94mWnZVHHUfJ022jBKx+ze3xAWixldnzCHY26r/Icztz5fZS9k///3y0jPF6mLzTsVVNjOvrWRM1d7lhTr85kGJR/4pqN9k/Ipmz3erfKWFTRblrybtg2ZVV8K8EV1COWwSnUG+rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772497279; c=relaxed/simple;
	bh=g8higwjbdPPoy5qm1qLX+cwWLqRjqkp68sR8Ljf97R8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PgKkjAlDHggoVHrV2jHX9Rfw4PNmuYXYqOELuCcEcDVSqzE6ENHz1u1vK8QnbzJfOQjA1Nv3YsiUfl4ug03jf8xAZQSb/5Hg+61ABDHMWr3QyFG0x+drepxqh1XYGAvhp7SqTCeZu7pjUbTfgX4UD44JtXIj/MYUieofTWCfVcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MoX/R/CC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MoX/R/CC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C893AC19423;
	Tue,  3 Mar 2026 00:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772497278;
	bh=g8higwjbdPPoy5qm1qLX+cwWLqRjqkp68sR8Ljf97R8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MoX/R/CC2Ay9Q2kx609V3Upl2BQhXfgz3rCW2Wti0aIShKaXZtKAXovXEeDmGYtTc
	 vhqX6phFqYVIFB/sbf4AfymVTJ76Rrq6SaZA7T6ZpgUvRxZCP5f4w7HcW+IFoRJaRv
	 9krFgkooZkXUIxmML00n8z/eij/VudTUhTum3JvztU0qP5ssS9DdouFjHfMyvhxhtK
	 xat3uHz8DNHhDUFAff3kqw1EHL52K1jvu9UXoRwrpJaT6IFwb+WLz4Qp2z9DC8KOhF
	 4F8crQjcxgxNBdM3kpwuwU3QS6zc/wGt5G3QVqBUD4KahrB1UwYeBTV8Pgcn2rhNMx
	 IvTY8gpaNw55A==
Date: Mon, 02 Mar 2026 16:21:18 -0800
Subject: [PATCH 35/36] xfs: remove duplicate static size checks
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, hch@lst.de, wilfred.mallawa@wdc.com,
 linux-xfs@vger.kernel.org
Message-ID: <177249638421.457970.1713202280529505966.stgit@frogsfrogsfrogs>
In-Reply-To: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
References: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
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

