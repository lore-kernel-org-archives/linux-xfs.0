Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A0122C6CF
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733529708; cv=none; b=lEhQp4JCv75NhBcafL1A5KA2cAMXaoDWMXRMcTQoOCq+E2f/krgaJ2EqiCj39RjsNl+WQcxGItypWKovOKOH8r8DNJDnJDu/urQTbYqxXRJOm2MaH3VYlQQmhyaLvnWihRqh8F2uj38GuFiMLnZnojRwsYZ81PMQ96ea5efPZu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733529708; c=relaxed/simple;
	bh=pxcvcAxSyQRu7r68aaoSqorK2wouR8o4lDgPJeFvT5w=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bv+07gdAJeBsU5HMP4Tudcrq0MbsL8pQ0bVE4wq8wS2ejP8YNP+Nd/sR+kHfk+4SbetY7jg2aMySdlDmv/SigZ0SHJu/SHUdgxiDDLzMqszgPwMC7A3His85Dg5/zXBiZ7oHlKWFLP1+B1mjUavwpM/+O6GdFdihH0bKTGetcao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l+ZcubCE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l+ZcubCE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50FE2C4CED1;
	Sat,  7 Dec 2024 00:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733529708;
	bh=pxcvcAxSyQRu7r68aaoSqorK2wouR8o4lDgPJeFvT5w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=l+ZcubCEDhDJVF0X7S3ANidtqIpT7RB1nVfvP7c+96ONQIisHsGTrUL1P8fEuODad
	 Ubz7NMntWrYsi8GsBfodQsy+Hwsm+Le4tGd+q3kSsLMUQR7Yl8aRQQx8jbfz9VVh8j
	 cJ6aOjAyzz33dpu38pvLE2VBrREzM9PzX6IATna6AvXAHx+BLhkxI7xezPvEUCNccb
	 t3W66LwH7sWVbIJP0O3iak+nbZaG5jryJqpbA/Cw1eflqjEBRdwh2Xzd2BePVTEilA
	 OB/tEhsUUWAbMRt+8VcDLfckbZbG6W0tgTgedbEGKvnIUT97rUQjnafwHl6JN1b5ZH
	 +5e2VAmyTmSdg==
Date: Fri, 06 Dec 2024 16:01:47 -0800
Subject: [PATCH 40/46] xfs: enable metadata directory feature
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352750607.124560.13879600104802166067.stgit@frogsfrogsfrogs>
In-Reply-To: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
References: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: ea079efd365e60aa26efea24b57ced4c64640e75

Enable the metadata directory feature.  With this feature, all metadata
inodes are placed in the metadata directory, and the only inumbers in
the superblock are the roots of the two directory trees.

The RT device is now sharded into a number of rtgroups, where 0 rtgroups
mean that no RT extents are supported, and the traditional XFS stub RT
bitmap and summary inodes don't exist.  A single rtgroup gives roughly
identical behavior to the traditional RT setup, but now with checksummed
and self identifying free space metadata.

For quota, the quota options are read from the superblock unless
explicitly overridden via mount options.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_format.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index d6c10855ab023b..4d47a3e723aa13 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -403,7 +403,8 @@ xfs_sb_has_ro_compat_feature(
 		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR | \
 		 XFS_SB_FEAT_INCOMPAT_NREXT64 | \
 		 XFS_SB_FEAT_INCOMPAT_EXCHRANGE | \
-		 XFS_SB_FEAT_INCOMPAT_PARENT)
+		 XFS_SB_FEAT_INCOMPAT_PARENT | \
+		 XFS_SB_FEAT_INCOMPAT_METADIR)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool

