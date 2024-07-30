Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54CB16FB0
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300874; cv=none; b=ivfAKj7Wh9M6EPILKBAX1VJzhKyfbxs/EEhf4dllytNC9na+Wq17kZDNOjbmtxfQS1qsYOiP/glgQgbNbQSIJDjCUlLnmeIF+obXh10IIzYa8GIrU6zoIq4PfT0D1N8BY2qpVFmytSOD0jIu/m6pIHuINChz3eNtYrDj0m/Facs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300874; c=relaxed/simple;
	bh=HdF2u0jo98SS9YlYMpi1F4BNQoVpD/NM861VFK3fo7M=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eBIaTLt1dJmbmBrdhYvbqBBLiGw4UB9So2kVogBr6wlcZraaz0V6vEpn1iRPSlwxe0BCeJeWaQ3zV2Bq4kmw2Ug9WZypm4Ldtl8KNmWxOw7Q0FlKazRR2mcmPwxEea3yYzJRfLrhoTp/twqlVa+bUpq+9bNyzdqMBYR36PxwG7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h4M23bG9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h4M23bG9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2F14C32786;
	Tue, 30 Jul 2024 00:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300874;
	bh=HdF2u0jo98SS9YlYMpi1F4BNQoVpD/NM861VFK3fo7M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=h4M23bG9tflTmPTwmNF+2KntcVSoIEi5C65GKwiAeocGEoTXbhtdjncfCV3RkIU7u
	 UEMJ5yTtPCZ04/3K5MFxF+D22gzxV/5RCHWBq0aM6ipzIh3lz8+GUvlUgNRVNlLBIZ
	 0TN0EbkZGNSgkQBttUfT43hJHr82EzenD5dlPedMS0n1uhwOylcKirMfYyQgLmMLnX
	 eGP7c/9FepMaSAQeKpvJ39uqQMDIBpqSHCX2ViWTTy917QytXzzejJw5Rm/itiGWCP
	 bSBliGijPXnq265PjtTyz69W5qE3USuyX4AEBhQjt/4L/YVCFj7NlvN9sV4UMf9mKW
	 Es1GXJvisgsDA==
Date: Mon, 29 Jul 2024 17:54:33 -0700
Subject: [PATCH 03/12] libhandle: add support for bulkstat v5
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229844444.1344699.4193753436678329494.stgit@frogsfrogsfrogs>
In-Reply-To: <172229844398.1344699.10032784599013622964.stgit@frogsfrogsfrogs>
References: <172229844398.1344699.10032784599013622964.stgit@frogsfrogsfrogs>
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

Add support to libhandle for generating file handles with bulkstat v5
structures.  xfs_fsr will need this to be able to interface with the new
vfs range swap ioctl, and other client programs will probably want this
over time.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/jdm.h   |   23 +++++++++++
 libhandle/jdm.c |  117 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 140 insertions(+)


diff --git a/include/jdm.h b/include/jdm.h
index c57fcae7f..50c2296b4 100644
--- a/include/jdm.h
+++ b/include/jdm.h
@@ -11,6 +11,7 @@ typedef void	jdm_fshandle_t;		/* filesystem handle */
 typedef void	jdm_filehandle_t;	/* filehandle */
 
 struct xfs_bstat;
+struct xfs_bulkstat;
 struct attrlist_cursor;
 struct parent;
 
@@ -23,6 +24,9 @@ jdm_new_filehandle( jdm_filehandle_t **handlep,	/* new filehandle */
 		    jdm_fshandle_t *fshandlep,	/* filesystem filehandle */
 		    struct xfs_bstat *sp);	/* bulkstat info */
 
+void jdm_new_filehandle_v5(jdm_filehandle_t **handlep, size_t *hlen,
+		jdm_fshandle_t *fshandlep, struct xfs_bulkstat *sp);
+
 extern void
 jdm_delete_filehandle( jdm_filehandle_t *handlep,/* filehandle to delete */
 		       size_t hlen);		/* filehandle size */
@@ -32,35 +36,54 @@ jdm_open( jdm_fshandle_t *fshandlep,
 	  struct xfs_bstat *sp,
 	  intgen_t oflags);
 
+intgen_t jdm_open_v5(jdm_fshandle_t *fshandlep, struct xfs_bulkstat *sp,
+		intgen_t oflags);
+
 extern intgen_t
 jdm_readlink( jdm_fshandle_t *fshandlep,
 	      struct xfs_bstat *sp,
 	      char *bufp,
 	      size_t bufsz);
 
+intgen_t jdm_readlink_v5(jdm_fshandle_t *fshandlep, struct xfs_bulkstat *sp,
+		char *bufp, size_t bufsz);
+
 extern intgen_t
 jdm_attr_multi(	jdm_fshandle_t *fshp,
 		struct xfs_bstat *statp,
 		char *bufp, int rtrvcnt, int flags);
 
+intgen_t jdm_attr_multi_v5(jdm_fshandle_t *fshp, struct xfs_bulkstat *statp,
+		char *bufp, int rtrvcnt, int flags);
+
 extern intgen_t
 jdm_attr_list(	jdm_fshandle_t *fshp,
 		struct xfs_bstat *statp,
 		char *bufp, size_t bufsz, int flags,
 		struct attrlist_cursor *cursor);
 
+intgen_t jdm_attr_list_v5(jdm_fshandle_t *fshp, struct xfs_bulkstat *statp,
+		char *bufp, size_t bufsz, int flags,
+		struct attrlist_cursor *cursor);
+
 extern int
 jdm_parents( jdm_fshandle_t *fshp,
 		struct xfs_bstat *statp,
 		struct parent *bufp, size_t bufsz,
 		unsigned int *count);
 
+int jdm_parents_v5(jdm_fshandle_t *fshp, struct xfs_bulkstat *statp,
+		struct parent *bufp, size_t bufsz, unsigned int *count);
+
 extern int
 jdm_parentpaths( jdm_fshandle_t *fshp,
 		struct xfs_bstat *statp,
 		struct parent *bufp, size_t bufsz,
 		unsigned int *count);
 
+int jdm_parentpaths_v5(jdm_fshandle_t *fshp, struct xfs_bulkstat *statp,
+		struct parent *bufp, size_t bufsz, unsigned int *count);
+
 /* macro for determining the size of a structure member */
 #define sizeofmember( t, m )	sizeof( ( ( t * )0 )->m )
 
diff --git a/libhandle/jdm.c b/libhandle/jdm.c
index 07b0c6098..e21aff2b2 100644
--- a/libhandle/jdm.c
+++ b/libhandle/jdm.c
@@ -41,6 +41,19 @@ jdm_fill_filehandle( filehandle_t *handlep,
 	handlep->fh_ino = statp->bs_ino;
 }
 
+static void
+jdm_fill_filehandle_v5(
+	struct filehandle	*handlep,
+	struct fshandle		*fshandlep,
+	struct xfs_bulkstat	*statp)
+{
+	handlep->fh_fshandle = *fshandlep;
+	handlep->fh_sz_following = FILEHANDLE_SZ_FOLLOWING;
+	memset(handlep->fh_pad, 0, FILEHANDLE_SZ_PAD);
+	handlep->fh_gen = statp->bs_gen;
+	handlep->fh_ino = statp->bs_ino;
+}
+
 jdm_fshandle_t *
 jdm_getfshandle( char *mntpnt )
 {
@@ -90,6 +103,22 @@ jdm_new_filehandle( jdm_filehandle_t **handlep,
 		jdm_fill_filehandle(*handlep, (fshandle_t *) fshandlep, statp);
 }
 
+void
+jdm_new_filehandle_v5(
+	jdm_filehandle_t	**handlep,
+	size_t			*hlen,
+	jdm_fshandle_t		*fshandlep,
+	struct xfs_bulkstat	*statp)
+{
+	/* allocate and fill filehandle */
+	*hlen = sizeof(filehandle_t);
+	*handlep = (filehandle_t *) malloc(*hlen);
+	if (!*handlep)
+		return;
+
+	jdm_fill_filehandle_v5(*handlep, (struct fshandle *)fshandlep, statp);
+}
+
 /* ARGSUSED */
 void
 jdm_delete_filehandle( jdm_filehandle_t *handlep, size_t hlen )
@@ -111,6 +140,19 @@ jdm_open( jdm_fshandle_t *fshp, struct xfs_bstat *statp, intgen_t oflags )
 	return fd;
 }
 
+intgen_t
+jdm_open_v5(
+	jdm_fshandle_t		*fshp,
+	struct xfs_bulkstat	*statp,
+	intgen_t		oflags)
+{
+	struct fshandle		*fshandlep = (struct fshandle *)fshp;
+	struct filehandle	filehandle;
+
+	jdm_fill_filehandle_v5(&filehandle, fshandlep, statp);
+	return open_by_fshandle(&filehandle, sizeof(filehandle), oflags);
+}
+
 intgen_t
 jdm_readlink( jdm_fshandle_t *fshp,
 	      struct xfs_bstat *statp,
@@ -128,6 +170,20 @@ jdm_readlink( jdm_fshandle_t *fshp,
 	return rval;
 }
 
+intgen_t
+jdm_readlink_v5(
+	jdm_fshandle_t		*fshp,
+	struct xfs_bulkstat	*statp,
+	char			*bufp,
+	size_t			bufsz)
+{
+	struct fshandle		*fshandlep = (struct fshandle *)fshp;
+	struct filehandle	filehandle;
+
+	jdm_fill_filehandle_v5(&filehandle, fshandlep, statp);
+	return readlink_by_handle(&filehandle, sizeof(filehandle), bufp, bufsz);
+}
+
 int
 jdm_attr_multi(	jdm_fshandle_t *fshp,
 		struct xfs_bstat *statp,
@@ -145,6 +201,22 @@ jdm_attr_multi(	jdm_fshandle_t *fshp,
 	return rval;
 }
 
+int
+jdm_attr_multi_v5(
+	jdm_fshandle_t		*fshp,
+	struct xfs_bulkstat	*statp,
+	char			*bufp,
+	int			rtrvcnt,
+	int			flags)
+{
+	struct fshandle		*fshandlep = (struct fshandle *)fshp;
+	struct filehandle	filehandle;
+
+	jdm_fill_filehandle_v5(&filehandle, fshandlep, statp);
+	return attr_multi_by_handle(&filehandle, sizeof(filehandle), bufp,
+			rtrvcnt, flags);
+}
+
 int
 jdm_attr_list(	jdm_fshandle_t *fshp,
 		struct xfs_bstat *statp,
@@ -166,6 +238,27 @@ jdm_attr_list(	jdm_fshandle_t *fshp,
 	return rval;
 }
 
+int
+jdm_attr_list_v5(
+	jdm_fshandle_t		*fshp,
+	struct xfs_bulkstat	*statp,
+	char			*bufp,
+	size_t			bufsz,
+	int			flags,
+	struct attrlist_cursor	*cursor)
+{
+	struct fshandle		*fshandlep = (struct fshandle *)fshp;
+	struct filehandle	filehandle;
+
+	/* prevent needless EINVAL from the kernel */
+	if (bufsz > XFS_XATTR_LIST_MAX)
+		bufsz = XFS_XATTR_LIST_MAX;
+
+	jdm_fill_filehandle_v5(&filehandle, fshandlep, statp);
+	return attr_list_by_handle(&filehandle, sizeof(filehandle), bufp,
+			bufsz, flags, cursor);
+}
+
 int
 jdm_parents( jdm_fshandle_t *fshp,
 		struct xfs_bstat *statp,
@@ -176,6 +269,18 @@ jdm_parents( jdm_fshandle_t *fshp,
 	return -1;
 }
 
+int
+jdm_parents_v5(
+	jdm_fshandle_t		*fshp,
+	struct xfs_bulkstat	*statp,
+	struct parent		*bufp,
+	size_t			bufsz,
+	unsigned int		*count)
+{
+	errno = EOPNOTSUPP;
+	return -1;
+}
+
 int
 jdm_parentpaths( jdm_fshandle_t *fshp,
 		struct xfs_bstat *statp,
@@ -185,3 +290,15 @@ jdm_parentpaths( jdm_fshandle_t *fshp,
 	errno = EOPNOTSUPP;
 	return -1;
 }
+
+int
+jdm_parentpaths_v5(
+	jdm_fshandle_t		*fshp,
+	struct xfs_bulkstat	*statp,
+	struct parent		*bufp,
+	size_t			bufsz,
+	unsigned int		*count)
+{
+	errno = EOPNOTSUPP;
+	return -1;
+}

