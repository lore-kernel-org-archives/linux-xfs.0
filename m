Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0B11494AC
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 14:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769673; cv=none; b=tePKQDukfahJNIbHEd2FElfZ+PDj5vNSTXHETHe6/yZAGwFdp3ZLEDZV9cFzCPCmFY7LAsNKenzQxXQWuJ4ad9MVYbczSrvWcogVTxuCophpiOqFtD0+Z5NAD1WvRD/Y+BTbACRDWJ1ev2wTzg1RQkh/Sy6YUlR8CNbreQ+m/ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769673; c=relaxed/simple;
	bh=a657NQ2JS3eEuzSeXrKFOBFHwH5MCmtSvFUmfc5QvYE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=grM7W25tLK6H+06MFWwxc9B97H2Op0ICPbmuvwuhoi40RtcJB4co92Nww1wqqCyo/VJyYBf9uSiyKrF1iuCS/Ne+8nA59nmUuR6iuM06SEIkZtyhooXYDbSZhfoWTEOyWtzpJ0rKrF3C35bA8gKkAbAtRdzQiMXAFuZ0euNklNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tSIT6ut8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tSIT6ut8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE5CC6107B;
	Tue, 27 Aug 2024 14:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724769673;
	bh=a657NQ2JS3eEuzSeXrKFOBFHwH5MCmtSvFUmfc5QvYE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tSIT6ut8p/6avRhtqfTK/VXL39eNHbeP+w1xl2f88RhAzVUH7/IcUwUjNK5XBJGXB
	 PCuJdTJNiWL9bhsd+HulSHuxuVrb0zGTQT9pIvakr+8B+7zFxZiny3gjvDvjbojELF
	 VN4B2UvHh0Ty/7UlkNtsCIbzAW/+3k4q3dFtF+uqQIn7ZWc5HgS1mULCWbJUCg+FDn
	 AnUU6vdJc+WXVEW7IzLxaEMryo//4IvErxYw62IB5Nl6o6m9aeosgbLmB5mYakTUj0
	 0jAb7lgBkbC8/NEdJ4/3lh4ckEcZg25pGTpe29NA8lGizqxwIsZKsusYWYCxmCSjOG
	 qiP6tPlKatVPg==
Date: Tue, 27 Aug 2024 07:41:12 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, hch@infradead.org
Subject: Re: [PATCH 1/3] libhandle: Remove libattr dependency
Message-ID: <20240827144112.GN865349@frogsfrogsfrogs>
References: <20240827115032.406321-1-cem@kernel.org>
 <20240827115032.406321-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240827115032.406321-2-cem@kernel.org>

On Tue, Aug 27, 2024 at 01:50:22PM +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> Aiming torwards removing xfsprogs libattr dependency, getting rid of
> libattr_cursor is the first step.
> 
> libxfs already has our own definition of xfs_libattr_cursor, so we can
> simply use it.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  include/handle.h   |  3 +--
>  include/jdm.h      |  5 ++---
>  libfrog/fsprops.c  |  8 ++++----
>  libhandle/handle.c |  2 +-
>  libhandle/jdm.c    | 14 +++++++-------
>  scrub/phase5.c     |  2 +-
>  6 files changed, 16 insertions(+), 18 deletions(-)
> 
> diff --git a/include/handle.h b/include/handle.h
> index ba0650051..991bd5d01 100644
> --- a/include/handle.h
> +++ b/include/handle.h
> @@ -11,7 +11,6 @@ extern "C" {
>  #endif
>  
>  struct fsdmidata;
> -struct attrlist_cursor;
>  struct parent;
>  
>  extern int  path_to_handle (char *__path, void **__hanp, size_t *__hlen);
> @@ -29,7 +28,7 @@ extern int  attr_multi_by_handle (void *__hanp, size_t __hlen, void *__buf,
>  				  int __rtrvcnt, int __flags);
>  extern int  attr_list_by_handle (void *__hanp, size_t __hlen, void *__buf,
>  				 size_t __bufsize, int __flags,
> -				 struct attrlist_cursor *__cursor);
> +				 struct xfs_attrlist_cursor *__cursor);
>  extern int  parents_by_handle(void *__hanp, size_t __hlen,
>  			      struct parent *__buf, size_t __bufsize,
>  			      unsigned int *__count);
> diff --git a/include/jdm.h b/include/jdm.h
> index 50c2296b4..669ee75ce 100644
> --- a/include/jdm.h
> +++ b/include/jdm.h
> @@ -12,7 +12,6 @@ typedef void	jdm_filehandle_t;	/* filehandle */
>  
>  struct xfs_bstat;
>  struct xfs_bulkstat;
> -struct attrlist_cursor;
>  struct parent;
>  
>  extern jdm_fshandle_t *
> @@ -60,11 +59,11 @@ extern intgen_t
>  jdm_attr_list(	jdm_fshandle_t *fshp,
>  		struct xfs_bstat *statp,
>  		char *bufp, size_t bufsz, int flags,
> -		struct attrlist_cursor *cursor);
> +		struct xfs_attrlist_cursor *cursor);
>  
>  intgen_t jdm_attr_list_v5(jdm_fshandle_t *fshp, struct xfs_bulkstat *statp,
>  		char *bufp, size_t bufsz, int flags,
> -		struct attrlist_cursor *cursor);
> +		struct xfs_attrlist_cursor *cursor);

Hmm.  Here you're changing function signatures for a public library.
attrlist_cursor and xfs_attrlist_cursor are the same object, but I
wonder if this is going to cause downstream compilation errors for
programs that include libattr but not xfs_fs.h?

I simply made a shim libfrog/fakelibattr.h that wraps the libhandle
stuff (albeit in a fragile manner, but I don't expect any further
libattr updates) so that we don't have to change libhandle itself.

>  extern int
>  jdm_parents( jdm_fshandle_t *fshp,
> diff --git a/libfrog/fsprops.c b/libfrog/fsprops.c
> index 88046b7a0..05a584a56 100644
> --- a/libfrog/fsprops.c
> +++ b/libfrog/fsprops.c
> @@ -68,10 +68,10 @@ fsprops_walk_names(
>  	fsprops_name_walk_fn	walk_fn,
>  	void			*priv)
>  {
> -	struct attrlist_cursor	cur = { };
> -	char			attrbuf[XFS_XATTR_LIST_MAX];
> -	struct attrlist		*attrlist = (struct attrlist *)attrbuf;
> -	int			ret;
> +	struct xfs_attrlist_cursor	cur = { };
> +	char				attrbuf[XFS_XATTR_LIST_MAX];
> +	struct attrlist			*attrlist = (struct attrlist *)attrbuf;
> +	int				ret;
>  
>  	memset(attrbuf, 0, XFS_XATTR_LIST_MAX);
>  
> diff --git a/libhandle/handle.c b/libhandle/handle.c
> index 1e8fe9ac5..a9a9f9534 100644
> --- a/libhandle/handle.c
> +++ b/libhandle/handle.c
> @@ -381,7 +381,7 @@ attr_list_by_handle(
>  	void		*buf,
>  	size_t		bufsize,
>  	int		flags,
> -	struct attrlist_cursor *cursor)
> +	struct		xfs_attrlist_cursor *cursor)

Odd indenting here.

--D

>  {
>  	int		error, fd;
>  	char		*path;
> diff --git a/libhandle/jdm.c b/libhandle/jdm.c
> index e21aff2b2..9ce605ad3 100644
> --- a/libhandle/jdm.c
> +++ b/libhandle/jdm.c
> @@ -221,7 +221,7 @@ int
>  jdm_attr_list(	jdm_fshandle_t *fshp,
>  		struct xfs_bstat *statp,
>  		char *bufp, size_t bufsz, int flags,
> -		struct attrlist_cursor *cursor)
> +		struct xfs_attrlist_cursor *cursor)
>  {
>  	fshandle_t *fshandlep = ( fshandle_t * )fshp;
>  	filehandle_t filehandle;
> @@ -240,12 +240,12 @@ jdm_attr_list(	jdm_fshandle_t *fshp,
>  
>  int
>  jdm_attr_list_v5(
> -	jdm_fshandle_t		*fshp,
> -	struct xfs_bulkstat	*statp,
> -	char			*bufp,
> -	size_t			bufsz,
> -	int			flags,
> -	struct attrlist_cursor	*cursor)
> +	jdm_fshandle_t			*fshp,
> +	struct xfs_bulkstat		*statp,
> +	char				*bufp,
> +	size_t				bufsz,
> +	int				flags,
> +	struct xfs_attrlist_cursor	*cursor)
>  {
>  	struct fshandle		*fshandlep = (struct fshandle *)fshp;
>  	struct filehandle	filehandle;
> diff --git a/scrub/phase5.c b/scrub/phase5.c
> index f6c295c64..27fa29be6 100644
> --- a/scrub/phase5.c
> +++ b/scrub/phase5.c
> @@ -190,7 +190,7 @@ check_xattr_ns_names(
>  	struct xfs_bulkstat		*bstat,
>  	const struct attrns_decode	*attr_ns)
>  {
> -	struct attrlist_cursor		cur;
> +	struct xfs_attrlist_cursor	cur;
>  	char				attrbuf[XFS_XATTR_LIST_MAX];
>  	char				keybuf[XATTR_NAME_MAX + 1];
>  	struct attrlist			*attrlist = (struct attrlist *)attrbuf;
> -- 
> 2.46.0
> 
> 
