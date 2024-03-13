Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E55D54BCF
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 21:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710367137; cv=none; b=MJ4UF59AwyqGyVXXPWPryurfWFAPM7CKF6sh6YNpzFr+R4a/+CExqSh+ohQhePZYDkOFBLPJknNPUnsb/diTf25v1VsGgOEJsOKmXlfTSuckJTeGs7ERB+LJVdXmFhXPvfivfd8GXJUyppJCBiceldokZJUNETFXa3H2dXRidK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710367137; c=relaxed/simple;
	bh=u1uN+TyUrb+yPyNjBOnXzENwhUgdorDGjJLcWVyWtzo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YKPOEO7HYrLZ1iLFrfqx2oVltPjerKm00Mdy3Y5QhNCtXL9szXsLN6ERM9bJQRo1wxGDFd7UyE51+W8gK0VsqstMZLfg4UjzKThbWE6GrZVh87bnHMPXNJ9TVcFwAs6PFqNUhJO9FNR9b0y0uKocd85nfX44py04kwbQ1y4CaYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ua6hC3hG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ua6hC3hG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710367134;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lFhdcPd3hLJ9SCe6u6e2UgqhODQIN/PZDi91m9YN90Y=;
	b=Ua6hC3hGE7j/WoQX/Kj10UbqufeM63zzI6ONemq2ZGHiMH4VLmdaMeir6Tc1b8u4BrErmG
	0uTqo0r2J3/wWqMVa//5tQqKWC+QyN7GPDD32NtQRQ5HwamVRpyqUcRJlWBTxatTdbYhPo
	dzgC96HA9DwNJDPhfn+LnyS1H3D1/K0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-386-ZeCD-QCcPIKfQ9zQQWMWTQ-1; Wed, 13 Mar 2024 17:58:49 -0400
X-MC-Unique: ZeCD-QCcPIKfQ9zQQWMWTQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C0CC08007AF;
	Wed, 13 Mar 2024 21:58:48 +0000 (UTC)
Received: from redhat.com (unknown [10.22.16.77])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9F6032166B4F;
	Wed, 13 Mar 2024 21:58:47 +0000 (UTC)
Date: Wed, 13 Mar 2024 16:58:46 -0500
From: Bill O'Donnell <bodonnel@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs_repair: push inode buf and dinode pointers all
 the way to inode fork processing
Message-ID: <ZfIhlo3VrvnAfHc6@redhat.com>
References: <171029434322.2065697.15834513610979167624.stgit@frogsfrogsfrogs>
 <171029434340.2065697.11904740279941887091.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171029434340.2065697.11904740279941887091.stgit@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

On Tue, Mar 12, 2024 at 07:14:09PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Currently, the process_dinode* family of functions assume that they have
> the buffer backing the inodes locked, and therefore the dinode pointer
> won't ever change.  However, the bmbt rebuilding code in the next patch
> will violate that assumption, so we must pass pointers to the inobp and
> the dinode pointer (that is to say, double pointers) all the way through
> to process_inode_{data,attr}_fork so that we can regrab the buffer after
> the rebuilding step finishes.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>

> ---
>  repair/dino_chunks.c |    5 ++-
>  repair/dinode.c      |   88 ++++++++++++++++++++++++++++----------------------
>  repair/dinode.h      |    7 ++--
>  3 files changed, 57 insertions(+), 43 deletions(-)
> 
> 
> diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
> index 171756818a6a..195361334519 100644
> --- a/repair/dino_chunks.c
> +++ b/repair/dino_chunks.c
> @@ -851,10 +851,11 @@ process_inode_chunk(
>  		ino_dirty = 0;
>  		parent = 0;
>  
> -		status = process_dinode(mp, dino, agno, agino,
> +		status = process_dinode(mp, &dino, agno, agino,
>  				is_inode_free(ino_rec, irec_offset),
>  				&ino_dirty, &is_used,ino_discovery, check_dups,
> -				extra_attr_check, &isa_dir, &parent);
> +				extra_attr_check, &isa_dir, &parent,
> +				&bplist[bp_index]);
>  
>  		ASSERT(is_used != 3);
>  		if (ino_dirty) {
> diff --git a/repair/dinode.c b/repair/dinode.c
> index 164f51d4c4fc..a18af3ff7772 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -1893,17 +1893,19 @@ _("nblocks (%" PRIu64 ") smaller than nextents for inode %" PRIu64 "\n"), nblock
>   */
>  static int
>  process_inode_data_fork(
> -	xfs_mount_t		*mp,
> +	struct xfs_mount	*mp,
>  	xfs_agnumber_t		agno,
>  	xfs_agino_t		ino,
> -	struct xfs_dinode	*dino,
> +	struct xfs_dinode	**dinop,
>  	int			type,
>  	int			*dirty,
>  	xfs_rfsblock_t		*totblocks,
>  	xfs_extnum_t		*nextents,
>  	blkmap_t		**dblkmap,
> -	int			check_dups)
> +	int			check_dups,
> +	struct xfs_buf		**ino_bpp)
>  {
> +	struct xfs_dinode	*dino = *dinop;
>  	xfs_ino_t		lino = XFS_AGINO_TO_INO(mp, agno, ino);
>  	int			err = 0;
>  	xfs_extnum_t		nex, max_nex;
> @@ -2005,20 +2007,22 @@ process_inode_data_fork(
>   */
>  static int
>  process_inode_attr_fork(
> -	xfs_mount_t		*mp,
> +	struct xfs_mount	*mp,
>  	xfs_agnumber_t		agno,
>  	xfs_agino_t		ino,
> -	struct xfs_dinode	*dino,
> +	struct xfs_dinode	**dinop,
>  	int			type,
>  	int			*dirty,
>  	xfs_rfsblock_t		*atotblocks,
>  	xfs_extnum_t		*anextents,
>  	int			check_dups,
>  	int			extra_attr_check,
> -	int			*retval)
> +	int			*retval,
> +	struct xfs_buf		**ino_bpp)
>  {
>  	xfs_ino_t		lino = XFS_AGINO_TO_INO(mp, agno, ino);
> -	blkmap_t		*ablkmap = NULL;
> +	struct xfs_dinode	*dino = *dinop;
> +	struct blkmap		*ablkmap = NULL;
>  	int			repair = 0;
>  	int			err;
>  
> @@ -2077,7 +2081,7 @@ process_inode_attr_fork(
>  		 * XXX - put the inode onto the "move it" list and
>  		 *	log the the attribute scrubbing
>  		 */
> -		do_warn(_("bad attribute fork in inode %" PRIu64), lino);
> +		do_warn(_("bad attribute fork in inode %" PRIu64 "\n"), lino);
>  
>  		if (!no_modify)  {
>  			do_warn(_(", clearing attr fork\n"));
> @@ -2274,21 +2278,22 @@ _("Bad extent size hint %u on inode %" PRIu64 ", "),
>   * for detailed, info, look at process_dinode() comments.
>   */
>  static int
> -process_dinode_int(xfs_mount_t *mp,
> -		struct xfs_dinode *dino,
> -		xfs_agnumber_t agno,
> -		xfs_agino_t ino,
> -		int was_free,		/* 1 if inode is currently free */
> -		int *dirty,		/* out == > 0 if inode is now dirty */
> -		int *used,		/* out == 1 if inode is in use */
> -		int verify_mode,	/* 1 == verify but don't modify inode */
> -		int uncertain,		/* 1 == inode is uncertain */
> -		int ino_discovery,	/* 1 == check dirs for unknown inodes */
> -		int check_dups,		/* 1 == check if inode claims
> -					 * duplicate blocks		*/
> -		int extra_attr_check, /* 1 == do attribute format and value checks */
> -		int *isa_dir,		/* out == 1 if inode is a directory */
> -		xfs_ino_t *parent)	/* out -- parent if ino is a dir */
> +process_dinode_int(
> +	struct xfs_mount	*mp,
> +	struct xfs_dinode	**dinop,
> +	xfs_agnumber_t		agno,
> +	xfs_agino_t		ino,
> +	int			was_free,	/* 1 if inode is currently free */
> +	int			*dirty,		/* out == > 0 if inode is now dirty */
> +	int			*used,		/* out == 1 if inode is in use */
> +	int			verify_mode,	/* 1 == verify but don't modify inode */
> +	int			uncertain,	/* 1 == inode is uncertain */
> +	int			ino_discovery,	/* 1 == check dirs for unknown inodes */
> +	int			check_dups,	/* 1 == check if inode claims duplicate blocks */
> +	int			extra_attr_check, /* 1 == do attribute format and value checks */
> +	int			*isa_dir,	/* out == 1 if inode is a directory */
> +	xfs_ino_t		*parent,	/* out -- parent if ino is a dir */
> +	struct xfs_buf		**ino_bpp)
>  {
>  	xfs_rfsblock_t		totblocks = 0;
>  	xfs_rfsblock_t		atotblocks = 0;
> @@ -2301,6 +2306,7 @@ process_dinode_int(xfs_mount_t *mp,
>  	const int		is_free = 0;
>  	const int		is_used = 1;
>  	blkmap_t		*dblkmap = NULL;
> +	struct xfs_dinode	*dino = *dinop;
>  	xfs_agino_t		unlinked_ino;
>  	struct xfs_perag	*pag;
>  
> @@ -2324,6 +2330,7 @@ process_dinode_int(xfs_mount_t *mp,
>  	 * If uncertain is set, verify_mode MUST be set.
>  	 */
>  	ASSERT(uncertain == 0 || verify_mode != 0);
> +	ASSERT(ino_bpp != NULL || verify_mode != 0);
>  
>  	/*
>  	 * This is the only valid point to check the CRC; after this we may have
> @@ -2863,18 +2870,21 @@ _("Bad CoW extent size %u on inode %" PRIu64 ", "),
>  	/*
>  	 * check data fork -- if it's bad, clear the inode
>  	 */
> -	if (process_inode_data_fork(mp, agno, ino, dino, type, dirty,
> -			&totblocks, &nextents, &dblkmap, check_dups) != 0)
> +	if (process_inode_data_fork(mp, agno, ino, dinop, type, dirty,
> +			&totblocks, &nextents, &dblkmap, check_dups,
> +			ino_bpp) != 0)
>  		goto bad_out;
> +	dino = *dinop;
>  
>  	/*
>  	 * check attribute fork if necessary.  attributes are
>  	 * always stored in the regular filesystem.
>  	 */
> -	if (process_inode_attr_fork(mp, agno, ino, dino, type, dirty,
> +	if (process_inode_attr_fork(mp, agno, ino, dinop, type, dirty,
>  			&atotblocks, &anextents, check_dups, extra_attr_check,
> -			&retval))
> +			&retval, ino_bpp))
>  		goto bad_out;
> +	dino = *dinop;
>  
>  	/*
>  	 * enforce totblocks is 0 for misc types
> @@ -2992,8 +3002,8 @@ _("Bad CoW extent size %u on inode %" PRIu64 ", "),
>  
>  int
>  process_dinode(
> -	xfs_mount_t		*mp,
> -	struct xfs_dinode	*dino,
> +	struct xfs_mount	*mp,
> +	struct xfs_dinode	**dinop,
>  	xfs_agnumber_t		agno,
>  	xfs_agino_t		ino,
>  	int			was_free,
> @@ -3003,7 +3013,8 @@ process_dinode(
>  	int			check_dups,
>  	int			extra_attr_check,
>  	int			*isa_dir,
> -	xfs_ino_t		*parent)
> +	xfs_ino_t		*parent,
> +	struct xfs_buf		**ino_bpp)
>  {
>  	const int		verify_mode = 0;
>  	const int		uncertain = 0;
> @@ -3011,9 +3022,10 @@ process_dinode(
>  #ifdef XR_INODE_TRACE
>  	fprintf(stderr, _("processing inode %d/%d\n"), agno, ino);
>  #endif
> -	return process_dinode_int(mp, dino, agno, ino, was_free, dirty, used,
> -				verify_mode, uncertain, ino_discovery,
> -				check_dups, extra_attr_check, isa_dir, parent);
> +	return process_dinode_int(mp, dinop, agno, ino, was_free, dirty, used,
> +			verify_mode, uncertain, ino_discovery,
> +			check_dups, extra_attr_check, isa_dir, parent,
> +			ino_bpp);
>  }
>  
>  /*
> @@ -3038,9 +3050,9 @@ verify_dinode(
>  	const int		ino_discovery = 0;
>  	const int		uncertain = 0;
>  
> -	return process_dinode_int(mp, dino, agno, ino, 0, &dirty, &used,
> -				verify_mode, uncertain, ino_discovery,
> -				check_dups, 0, &isa_dir, &parent);
> +	return process_dinode_int(mp, &dino, agno, ino, 0, &dirty, &used,
> +			verify_mode, uncertain, ino_discovery,
> +			check_dups, 0, &isa_dir, &parent, NULL);
>  }
>  
>  /*
> @@ -3064,7 +3076,7 @@ verify_uncertain_dinode(
>  	const int		ino_discovery = 0;
>  	const int		uncertain = 1;
>  
> -	return process_dinode_int(mp, dino, agno, ino, 0, &dirty, &used,
> +	return process_dinode_int(mp, &dino, agno, ino, 0, &dirty, &used,
>  				verify_mode, uncertain, ino_discovery,
> -				check_dups, 0, &isa_dir, &parent);
> +				check_dups, 0, &isa_dir, &parent, NULL);
>  }
> diff --git a/repair/dinode.h b/repair/dinode.h
> index 333d96d26a2f..92df83da6210 100644
> --- a/repair/dinode.h
> +++ b/repair/dinode.h
> @@ -43,8 +43,8 @@ void
>  update_rootino(xfs_mount_t *mp);
>  
>  int
> -process_dinode(xfs_mount_t *mp,
> -		struct xfs_dinode *dino,
> +process_dinode(struct xfs_mount *mp,
> +		struct xfs_dinode **dinop,
>  		xfs_agnumber_t agno,
>  		xfs_agino_t ino,
>  		int was_free,
> @@ -54,7 +54,8 @@ process_dinode(xfs_mount_t *mp,
>  		int check_dups,
>  		int extra_attr_check,
>  		int *isa_dir,
> -		xfs_ino_t *parent);
> +		xfs_ino_t *parent,
> +		struct xfs_buf **ino_bpp);
>  
>  int
>  verify_dinode(xfs_mount_t *mp,
> 
> 

