Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6098F5B
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302910; cv=none; b=WIK6YhPU6kiqj2Fia7xXVyl+y6hmxPkMi0qa5/hYr5ckmAR8n+B510TeHybEzaYe9OtbRHO9v/MytG0Q+IcoUKzKCHB2SU8hJRBZf5oeeQqGj1itZtww7m3jVGvhGqbfaYGx8NojlKZGo+lGXWmcbSgjkViA+tZ/27kT4k3vJAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302910; c=relaxed/simple;
	bh=2fUNGrKK54NkVJ9cChuMo5LInMUbjjaT1OY1yxSRxfw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dg5I8IWg7ywXwfURFXfQub4uvZW/+To169yS1BM2eo6lBG+w1+1Kp5xdl9nZq4UcHjfECPn2CdxWYbTE17ZcZkF1iVP0bS+YER4nFO7ymKxD39Hy1EjmuYtjFOV7UqkWqCy1zp5QUb18DJjIh0n+SMZnJIemi71AQ06OBAKrnQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nCwuee40; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nCwuee40"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76FD4C4AF0A;
	Tue, 30 Jul 2024 01:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722302910;
	bh=2fUNGrKK54NkVJ9cChuMo5LInMUbjjaT1OY1yxSRxfw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nCwuee40OjkZOUOTqJLFkQG81NKh14f13mIztL94oxljYCXs9y9EbiGU4XAvaG8/3
	 dIa31x7orA5YLGV3QVUPGX06Vdu+F4HR9NR6X0F2WFJfigPdWcU4TqsnVdVw+Cb+Uy
	 xw29wPGOj0KGUCZ5tjD4nP9XqznRHGgQx0VrZcmNhZQ6/eWO1Zt0gYR5IRzXLyanw9
	 wyNpkXsblzh4WXp7M5PKcRb1yHr95f40icbAz1U2oyHwrJvp34dfn8ZWPL9GilLpcK
	 ijb3ZlOIT7vUW6vRG1S8dTLfyHoloykjhA52K+tKSJohBXXR40HG3o94Hs6Tdlpfbr
	 xNN1uFCjF2AbQ==
Date: Mon, 29 Jul 2024 18:28:30 -0700
Subject: [PATCH 11/12] xfs_repair: update ondisk parent pointer records
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
 catherine.hoang@oracle.com, allison.henderson@oracle.com
Message-ID: <172229851628.1352527.106880217821874506.stgit@frogsfrogsfrogs>
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

Update the ondisk parent pointer records as necessary.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/libxfs_api_defs.h |    2 +
 repair/pptr.c            |   88 ++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 87 insertions(+), 3 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index e12f0a40b..df316727b 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -209,8 +209,10 @@
 #define xfs_parent_hashval		libxfs_parent_hashval
 #define xfs_parent_lookup		libxfs_parent_lookup
 #define xfs_parent_removename		libxfs_parent_removename
+#define xfs_parent_set			libxfs_parent_set
 #define xfs_parent_start		libxfs_parent_start
 #define xfs_parent_from_attr		libxfs_parent_from_attr
+#define xfs_parent_unset		libxfs_parent_unset
 #define xfs_perag_get			libxfs_perag_get
 #define xfs_perag_hold			libxfs_perag_hold
 #define xfs_perag_put			libxfs_perag_put
diff --git a/repair/pptr.c b/repair/pptr.c
index 61466009d..94d6d8346 100644
--- a/repair/pptr.c
+++ b/repair/pptr.c
@@ -673,6 +673,44 @@ load_file_pptr_name(
 			name, file_pptr->namelen);
 }
 
+/* Add an on disk parent pointer to a file. */
+static int
+add_file_pptr(
+	struct xfs_inode		*ip,
+	const struct ag_pptr		*ag_pptr,
+	const unsigned char		*name)
+{
+	struct xfs_name			xname = {
+		.name			= name,
+		.len			= ag_pptr->namelen,
+	};
+	struct xfs_parent_rec		pptr_rec = { };
+	struct xfs_da_args		scratch;
+
+	xfs_parent_rec_init(&pptr_rec, ag_pptr->parent_ino,
+			ag_pptr->parent_gen);
+	return -libxfs_parent_set(ip, ip->i_ino, &xname, &pptr_rec, &scratch);
+}
+
+/* Remove an on disk parent pointer from a file. */
+static int
+remove_file_pptr(
+	struct xfs_inode		*ip,
+	const struct file_pptr		*file_pptr,
+	const unsigned char		*name)
+{
+	struct xfs_name			xname = {
+		.name			= name,
+		.len			= file_pptr->namelen,
+	};
+	struct xfs_parent_rec		pptr_rec = { };
+	struct xfs_da_args		scratch;
+
+	xfs_parent_rec_init(&pptr_rec, file_pptr->parent_ino,
+			file_pptr->parent_gen);
+	return -libxfs_parent_unset(ip, ip->i_ino, &xname, &pptr_rec, &scratch);
+}
+
 /* Remove all pptrs from @ip. */
 static void
 clear_all_pptrs(
@@ -729,7 +767,16 @@ add_missing_parent_ptr(
 				name);
 	}
 
-	/* XXX actually do the work */
+	error = add_file_pptr(ip, ag_pptr, name);
+	if (error)
+		do_error(
+ _("adding ino %llu pptr (ino %llu gen 0x%x name '%.*s') failed: %s\n"),
+			(unsigned long long)ip->i_ino,
+			(unsigned long long)ag_pptr->parent_ino,
+			ag_pptr->parent_gen,
+			ag_pptr->namelen,
+			name,
+			strerror(error));
 }
 
 /* Remove @file_pptr from @ip. */
@@ -771,7 +818,16 @@ remove_incorrect_parent_ptr(
 			file_pptr->namelen,
 			name);
 
-	/* XXX actually do the work */
+	error = remove_file_pptr(ip, file_pptr, name);
+	if (error)
+		do_error(
+ _("removing ino %llu pptr (ino %llu gen 0x%x name '%.*s') failed: %s\n"),
+			(unsigned long long)ip->i_ino,
+			(unsigned long long)file_pptr->parent_ino,
+			file_pptr->parent_gen,
+			file_pptr->namelen,
+			name,
+			strerror(error));
 }
 
 /*
@@ -851,7 +907,33 @@ compare_parent_ptrs(
 			ag_pptr->namelen,
 			name1);
 
-	/* XXX do the work */
+	/* Remove the parent pointer that we don't want. */
+	error = remove_file_pptr(ip, file_pptr, name2);
+	if (error)
+		do_error(
+_("erasing ino %llu pptr (ino %llu gen 0x%x name '%.*s') failed: %s\n"),
+			(unsigned long long)ip->i_ino,
+			(unsigned long long)file_pptr->parent_ino,
+			file_pptr->parent_gen,
+			file_pptr->namelen,
+			name2,
+			strerror(error));
+
+	/*
+	 * Add the parent pointer that we do want.  It's possible that this
+	 * parent pointer already exists but we haven't gotten that far in the
+	 * scan, so we'll keep going on EEXIST.
+	 */
+	error = add_file_pptr(ip, ag_pptr, name1);
+	if (error && error != EEXIST)
+		do_error(
+ _("updating ino %llu pptr (ino %llu gen 0x%x name '%.*s') failed: %s\n"),
+			(unsigned long long)ip->i_ino,
+			(unsigned long long)ag_pptr->parent_ino,
+			ag_pptr->parent_gen,
+			ag_pptr->namelen,
+			name1,
+			strerror(error));
 }
 
 static int

