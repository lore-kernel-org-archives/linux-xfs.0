Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C3D175AB;
	Fri, 11 Oct 2024 01:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610812; cv=none; b=h/kJW3UbmnXwA3Obj+9G49APkmcmhopMt+QOmnMCBapLFkPjuUE72xclgXuyIbtbtP6wDZtXnFeh7X3a9ejHqsc51ZpR4fIKvFd0fPUj7XR3RQuHdsWxvebuYgkOl8aKxj1p3WSJa1EtE+RPe5Q9e1NZW+4YEkdQs80JULLN2yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610812; c=relaxed/simple;
	bh=D2otW8uklWCXr7nnUWyWYvSTNCb8GUReQR8dK4iyXW8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mJ2YZtaWevNJVa21zRvluvu9ysFqV2MRh+Vc2ra2ppbSsRxWPPloPe2aQUJz63mJQ8xJx81oPcKXpwuMbhHGqdjSQ1LSm2AwZMzRX2TF54qWmTwFRfUqeHRfRf9XMQoV5yeFjxmJFs+OpMe7D13gRgBstkxqHPkJ4snztMcxTFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D9rmJ4x0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D9rmJ4x0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D905C4CECE;
	Fri, 11 Oct 2024 01:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610812;
	bh=D2otW8uklWCXr7nnUWyWYvSTNCb8GUReQR8dK4iyXW8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=D9rmJ4x0qD97YYWmrr3QgQlF5icN817Wx2H7lsIN9tocXfbYT66SJ3xMw0Gm3183P
	 6MxuzpkLvnAu95d+XaMDEh67CtoeWHbd6ydTIrZJlLiAD1jXxZD0WAl+FE4BnzUE1f
	 DOI/cCtwRd5G3q2nWp7n28mEs19sCYB05eGNTKc2Xl7iC4xrHYcpejtJywDEMHszwN
	 B2jsMlIu6WfDnU7AqIE9YlzFsYcqV3Nqie+TM6WPpD9omi6L6fbmZ80PyzmWLKhHfy
	 7iRNPz6Dm+iU0OuGg8ZgfiWaPOOUbr/OwPVCg0QZcfUIaI4BIrNaIg0PbJD6NjWURB
	 TPyibG4sFMlzg==
Date: Thu, 10 Oct 2024 18:40:12 -0700
Subject: [PATCH 08/11] xfs/122: adjust for metadata directories
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, fstests@vger.kernel.org
Message-ID: <172860658119.4187056.17816529487224170367.stgit@frogsfrogsfrogs>
In-Reply-To: <172860657983.4187056.5472629319415849070.stgit@frogsfrogsfrogs>
References: <172860657983.4187056.5472629319415849070.stgit@frogsfrogsfrogs>
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

Adjust this test for the metadir feature.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/122.out |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index 64109489896fd5..f47904bc75e6de 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -36,6 +36,7 @@ offsetof(xfs_sb_t, sb_lsn) = 240
 offsetof(xfs_sb_t, sb_magicnum) = 0
 offsetof(xfs_sb_t, sb_meta_uuid) = 248
 offsetof(xfs_sb_t, sb_metadirino) = 264
+offsetof(xfs_sb_t, sb_metadirpad) = 204
 offsetof(xfs_sb_t, sb_pquotino) = 232
 offsetof(xfs_sb_t, sb_qflags) = 176
 offsetof(xfs_sb_t, sb_rblocks) = 16
@@ -92,7 +93,7 @@ sizeof(struct xfs_dir3_leaf) = 64
 sizeof(struct xfs_dir3_leaf_hdr) = 64
 sizeof(struct xfs_disk_dquot) = 104
 sizeof(struct xfs_dqblk) = 136
-sizeof(struct xfs_dsb) = 264
+sizeof(struct xfs_dsb) = 272
 sizeof(struct xfs_dsymlink_hdr) = 56
 sizeof(struct xfs_exchange_range) = 40
 sizeof(struct xfs_extent_data) = 24

