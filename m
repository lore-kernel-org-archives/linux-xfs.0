Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE0EB79CC
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302754; cv=none; b=tnSR6izKtn7KfRy22LQxFcSE/WreNG1enB80UZ+g/Cmg893s5kExQZ/OlLELmh5TeX5qrG+Koc7s8uDDDcstcVrqnnI9W5B6/4APC9Q6WrVeuUHekLQf6Q5B6KiwmYsW8D3yXKIL61ELv4vEeRIJmJxZWYp7KuQWDNV2xvoTNzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302754; c=relaxed/simple;
	bh=pRU4qNmG0lZqrnE1uUv46DIJr8UAHdMaRmv0k4RMKso=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iKg16uppXV/Jl5JBLDUh0cSZHfsUDooQPUrg+wEq0v0i0FDK8d0e4y0Zx88nQeNcwtE0VoA04wNuR0ZokrbupkQHx+A0rZxavvhYS4RlQfGmxZnVNX7zyCkWOq/Foo0yN/4gPfiLxzThSGYtIQGuDqaA85RugTo7O04i0kUp+Jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=flPcCIDb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="flPcCIDb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E50FC4AF0A;
	Tue, 30 Jul 2024 01:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722302754;
	bh=pRU4qNmG0lZqrnE1uUv46DIJr8UAHdMaRmv0k4RMKso=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=flPcCIDbJyEcozDvmQk0+lSNKgJbSCvnTL00V527mIWWS4RuOJYkfjiSzcLU6u5AI
	 RoXEVp1qj7HV2p5mxRBONs3SNXVyBBqh719Azq6Ujj+993Wy69iP4SQLkXzbNGSOO/
	 WrYGK3l6n3jEBBCuNWzB/DYrHyyB4Z6K/GvIMGEoqQOCjqLbmLzp9Ua2ufUjS0tJja
	 nQF67ykmnWaHAYWoIgLOYdUwEfyEvOSWFlKAiAiX0EQAXYIEvN15LXSN3HOnC6K7ON
	 Djlxl2Poaj7xpj/uqM4uSRZzETUr6B9rgUhAdSGaQfL+XUw5myRtzmjSjgeEtxW9fF
	 cvFEOKF3y3Y3A==
Date: Mon, 29 Jul 2024 18:25:53 -0700
Subject: [PATCH 01/12] xfs_db: remove some boilerplate from xfs_attr_set
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
 catherine.hoang@oracle.com, allison.henderson@oracle.com
Message-ID: <172229851502.1352527.1905635215078738882.stgit@frogsfrogsfrogs>
In-Reply-To: <172229851481.1352527.11812121319440135994.stgit@frogsfrogsfrogs>
References: <172229851481.1352527.11812121319440135994.stgit@frogsfrogsfrogs>
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

In preparation for online/offline repair wanting to use xfs_attr_set,
move some of the boilerplate out of this function into the callers.
Repair can initialize the da_args completely, and the userspace flag
handling/twisting goes away once we move it to xfs_attr_change.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/attrset.c             |   18 ++++++++++++++++--
 libxfs/libxfs_api_defs.h |    1 +
 2 files changed, 17 insertions(+), 2 deletions(-)


diff --git a/db/attrset.c b/db/attrset.c
index d9ab79fa7..008662571 100644
--- a/db/attrset.c
+++ b/db/attrset.c
@@ -111,7 +111,11 @@ attr_set_f(
 	int			argc,
 	char			**argv)
 {
-	struct xfs_da_args	args = { };
+	struct xfs_da_args	args = {
+		.geo		= mp->m_attr_geo,
+		.whichfork	= XFS_ATTR_FORK,
+		.op_flags	= XFS_DA_OP_OKNOENT,
+	};
 	char			*sp;
 	char			*name_from_file = NULL;
 	char			*value_from_file = NULL;
@@ -253,6 +257,9 @@ attr_set_f(
 		goto out;
 	}
 
+	args.owner = iocur_top->ino;
+	libxfs_attr_sethash(&args);
+
 	if (libxfs_attr_set(&args, op, false)) {
 		dbprintf(_("failed to set attr %s on inode %llu\n"),
 			args.name, (unsigned long long)iocur_top->ino);
@@ -277,7 +284,11 @@ attr_remove_f(
 	int			argc,
 	char			**argv)
 {
-	struct xfs_da_args	args = { };
+	struct xfs_da_args	args = {
+		.geo		= mp->m_attr_geo,
+		.whichfork	= XFS_ATTR_FORK,
+		.op_flags	= XFS_DA_OP_OKNOENT,
+	};
 	char			*name_from_file = NULL;
 	int			c;
 
@@ -365,6 +376,9 @@ attr_remove_f(
 		goto out;
 	}
 
+	args.owner = iocur_top->ino;
+	libxfs_attr_sethash(&args);
+
 	if (libxfs_attr_set(&args, XFS_ATTRUPDATE_REMOVE, false)) {
 		dbprintf(_("failed to remove attr %s from inode %llu\n"),
 			(unsigned char *)args.name,
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index df83aabdc..bf1d3c9d3 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -47,6 +47,7 @@
 #define xfs_attr_leaf_newentsize	libxfs_attr_leaf_newentsize
 #define xfs_attr_namecheck		libxfs_attr_namecheck
 #define xfs_attr_set			libxfs_attr_set
+#define xfs_attr_sethash		libxfs_attr_sethash
 #define xfs_attr_sf_firstentry		libxfs_attr_sf_firstentry
 #define xfs_attr_shortform_verify	libxfs_attr_shortform_verify
 

