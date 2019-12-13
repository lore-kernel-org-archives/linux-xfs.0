Return-Path: <SRS0=jVwY=2D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D1C9C34360
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Dec 2019 20:37:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0E1B24743
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Dec 2019 20:37:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e28jnt4W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727270AbfLMNI3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Dec 2019 08:08:29 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27620 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727261AbfLMNI3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Dec 2019 08:08:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576242507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gBzLRsu5EwKJ8CZJgBTBgrjsZBk4JuOyR2SmuNVfDso=;
        b=e28jnt4WllAoMttlUQszYMDr3IQ0o0zFI+RqaEPjU8djGopN6nHWQfkos2VAcGLw3iD/I1
        GTYNvDJPr9LiLY0G/G4nQNPc1T6+87ExSabU6QU0DVpsnEsFE+cwRVS4WIqSi8neHGy6sQ
        hk55F43XSLlz/By6+yPFSxfcZvMmTbA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-9_6n0nmMNM2k7qHGQjQ3eg-1; Fri, 13 Dec 2019 08:08:25 -0500
X-MC-Unique: 9_6n0nmMNM2k7qHGQjQ3eg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A46BDB22;
        Fri, 13 Dec 2019 13:08:24 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2D3365D9C9;
        Fri, 13 Dec 2019 13:08:24 +0000 (UTC)
Date:   Fri, 13 Dec 2019 08:08:23 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5 04/14] xfs: Add xfs_has_attr and subroutines
Message-ID: <20191213130823.GC43376@bfoster>
References: <20191212041513.13855-1-allison.henderson@oracle.com>
 <20191212041513.13855-5-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212041513.13855-5-allison.henderson@oracle.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 11, 2019 at 09:15:03PM -0700, Allison Collins wrote:
> From: Allison Henderson <allison.henderson@oracle.com>
> 
> This patch adds a new functions to check for the existence of
> an attribute.  Subroutines are also added to handle the cases
> of leaf blocks, nodes or shortform.  Common code that appears
> in existing attr add and remove functions have been factored
> out to help reduce the appearance of duplicated code.  We will
> need these routines later for delayed attributes since delayed
> operations cannot return error codes.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c      | 166 +++++++++++++++++++++++++++---------------
>  fs/xfs/libxfs/xfs_attr.h      |   1 +
>  fs/xfs/libxfs/xfs_attr_leaf.c | 110 +++++++++++++++++-----------
>  fs/xfs/libxfs/xfs_attr_leaf.h |   3 +
>  4 files changed, 182 insertions(+), 98 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 9628ed8..88de43c 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
...
> @@ -310,6 +313,36 @@ xfs_attr_set_args(
>  }
>  
>  /*
> + * Return EEXIST if attr is found, or ENOATTR if not
> + */
> +int
> +xfs_has_attr(
> +	struct xfs_da_args      *args)
> +{
> +	struct xfs_inode	*dp = args->dp;
> +
> +	if (!xfs_inode_hasattr(dp))
> +		return -ENOATTR;
> +
> +	if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
> +		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
> +		return xfs_attr_sf_findname(args, NULL, NULL);
> +	}
> +
> +	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> +		struct xfs_buf	*bp = NULL;
> +		int		error = xfs_attr_leaf_hasname(args, &bp);
> +

I'd prefer to not obfuscate function calls in variable declarations like
this. I'd say just declare bp and error at the top and let this be:

		error = xfs_attr_leaf_hasname(...)

> +		if (bp)
> +			xfs_trans_brelse(args->trans, bp);
> +
> +		return error;
> +	}
> +
> +	return xfs_attr_node_hasname(args, NULL);
> +}
> +
> +/*
>   * Remove the attribute specified in @args.
>   */
>  int
> @@ -583,26 +616,20 @@ STATIC int
>  xfs_attr_leaf_addname(
>  	struct xfs_da_args	*args)
>  {
> -	struct xfs_inode	*dp;
>  	struct xfs_buf		*bp;
>  	int			retval, error, forkoff;
> +	struct xfs_inode	*dp = args->dp;
>  
>  	trace_xfs_attr_leaf_addname(args);
>  
>  	/*
> -	 * Read the (only) block in the attribute list in.
> -	 */
> -	dp = args->dp;
> -	args->blkno = 0;
> -	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, &bp);
> -	if (error)
> -		return error;
> -
> -	/*
>  	 * Look up the given attribute in the leaf block.  Figure out if
>  	 * the given flags produce an error or call for an atomic rename.
>  	 */
> -	retval = xfs_attr3_leaf_lookup_int(bp, args);
> +	retval = xfs_attr_leaf_hasname(args, &bp);
> +	if (retval != -ENOATTR && retval != -EEXIST)
> +		return retval;
> +

Do we need to call xfs_trans_brelse() in certain cases before we return?
For example, consider if the read succeeds but the lookup returns
something other than -ENOATTR or -EEXIST. Perhaps the _hasname() func
should just call brelse() itself if it's returning an unexpected error
after reading in the buf so the caller doesn't need to care about it..

>  	if ((args->name.type & ATTR_REPLACE) && (retval == -ENOATTR)) {
>  		xfs_trans_brelse(args->trans, bp);
>  		return retval;
...
> @@ -864,20 +940,17 @@ xfs_attr_node_addname(
>  	dp = args->dp;
>  	mp = dp->i_mount;
>  restart:
> -	state = xfs_da_state_alloc();
> -	state->args = args;
> -	state->mp = mp;
> -
>  	/*
>  	 * Search to see if name already exists, and get back a pointer
>  	 * to where it should go.
>  	 */
> -	error = xfs_da3_node_lookup_int(state, &retval);
> -	if (error)
> +	retval = xfs_attr_node_hasname(args, &state);
> +	if (retval != -ENOATTR)
>  		goto out;

The else case below checks for -EEXIST, but it looks like we'd return
here..

Brian

> +
>  	blk = &state->path.blk[ state->path.active-1 ];
>  	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
> -	if ((args->name.type & ATTR_REPLACE) && (retval == -ENOATTR)) {
> +	if (args->name.type & ATTR_REPLACE) {
>  		goto out;
>  	} else if (retval == -EEXIST) {
>  		if (args->name.type & ATTR_CREATE)
> @@ -1079,29 +1152,15 @@ xfs_attr_node_removename(
>  {
>  	struct xfs_da_state	*state;
>  	struct xfs_da_state_blk	*blk;
> -	struct xfs_inode	*dp;
>  	struct xfs_buf		*bp;
>  	int			retval, error, forkoff;
> +	struct xfs_inode	*dp = args->dp;
>  
>  	trace_xfs_attr_node_removename(args);
>  
> -	/*
> -	 * Tie a string around our finger to remind us where we are.
> -	 */
> -	dp = args->dp;
> -	state = xfs_da_state_alloc();
> -	state->args = args;
> -	state->mp = dp->i_mount;
> -
> -	/*
> -	 * Search to see if name exists, and get back a pointer to it.
> -	 */
> -	error = xfs_da3_node_lookup_int(state, &retval);
> -	if (error || (retval != -EEXIST)) {
> -		if (error == 0)
> -			error = retval;
> +	error = xfs_attr_node_hasname(args, &state);
> +	if (error != -EEXIST)
>  		goto out;
> -	}
>  
>  	/*
>  	 * If there is an out-of-line value, de-allocate the blocks.
> @@ -1196,7 +1255,8 @@ xfs_attr_node_removename(
>  	error = 0;
>  
>  out:
> -	xfs_da_state_free(state);
> +	if (state)
> +		xfs_da_state_free(state);
>  	return error;
>  }
>  
> @@ -1316,31 +1376,23 @@ xfs_attr_node_get(xfs_da_args_t *args)
>  {
>  	xfs_da_state_t *state;
>  	xfs_da_state_blk_t *blk;
> -	int error, retval;
> +	int error;
>  	int i;
>  
>  	trace_xfs_attr_node_get(args);
>  
> -	state = xfs_da_state_alloc();
> -	state->args = args;
> -	state->mp = args->dp->i_mount;
> -
>  	/*
>  	 * Search to see if name exists, and get back a pointer to it.
>  	 */
> -	error = xfs_da3_node_lookup_int(state, &retval);
> -	if (error) {
> -		retval = error;
> -		goto out_release;
> -	}
> -	if (retval != -EEXIST)
> +	error = xfs_attr_node_hasname(args, &state);
> +	if (error != -EEXIST)
>  		goto out_release;
>  
>  	/*
>  	 * Get the value, local or "remote"
>  	 */
>  	blk = &state->path.blk[state->path.active - 1];
> -	retval = xfs_attr3_leaf_getvalue(blk->bp, args);
> +	error = xfs_attr3_leaf_getvalue(blk->bp, args);
>  
>  	/*
>  	 * If not in a transaction, we have to release all the buffers.
> @@ -1352,7 +1404,7 @@ xfs_attr_node_get(xfs_da_args_t *args)
>  	}
>  
>  	xfs_da_state_free(state);
> -	return retval;
> +	return error;
>  }
>  
>  /* Returns true if the attribute entry name is valid. */
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 44dd07a..3b5dad4 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -150,6 +150,7 @@ int xfs_attr_set(struct xfs_inode *dp, struct xfs_name *name,
>  		 unsigned char *value, int valuelen, int flags);
>  int xfs_attr_set_args(struct xfs_da_args *args);
>  int xfs_attr_remove(struct xfs_inode *dp, struct xfs_name *name, int flags);
> +int xfs_has_attr(struct xfs_da_args *args);
>  int xfs_attr_remove_args(struct xfs_da_args *args);
>  int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
>  		  int flags, struct attrlist_cursor_kern *cursor);
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 5465446..ef96971 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -654,18 +654,66 @@ xfs_attr_shortform_create(xfs_da_args_t *args)
>  }
>  
>  /*
> + * Return -EEXIST if attr is found, or -ENOATTR if not
> + * args:  args containing attribute name and namelen
> + * sfep:  If not null, pointer will be set to the last attr entry found on
> +	  -EEXIST.  On -ENOATTR pointer is left at the last entry in the list
> + * basep: If not null, pointer is set to the byte offset of the entry in the
> + *	  list on -EEXIST.  On -ENOATTR, pointer is left at the byte offset of
> + *	  the last entry in the list
> + */
> +int
> +xfs_attr_sf_findname(
> +	struct xfs_da_args	 *args,
> +	struct xfs_attr_sf_entry **sfep,
> +	unsigned int		 *basep)
> +{
> +	struct xfs_attr_shortform *sf;
> +	struct xfs_attr_sf_entry *sfe;
> +	unsigned int		base = sizeof(struct xfs_attr_sf_hdr);
> +	int			size = 0;
> +	int			end;
> +	int			i;
> +
> +	sf = (struct xfs_attr_shortform *)args->dp->i_afp->if_u1.if_data;
> +	sfe = &sf->list[0];
> +	end = sf->hdr.count;
> +	for (i = 0; i < end; sfe = XFS_ATTR_SF_NEXTENTRY(sfe),
> +			base += size, i++) {
> +		size = XFS_ATTR_SF_ENTSIZE(sfe);
> +		if (sfe->namelen != args->name.len)
> +			continue;
> +		if (memcmp(sfe->nameval, args->name.name, args->name.len) != 0)
> +			continue;
> +		if (!xfs_attr_namesp_match(args->name.type, sfe->flags))
> +			continue;
> +		break;
> +	}
> +
> +	if (sfep != NULL)
> +		*sfep = sfe;
> +
> +	if (basep != NULL)
> +		*basep = base;
> +
> +	if (i == end)
> +		return -ENOATTR;
> +	return -EEXIST;
> +}
> +
> +/*
>   * Add a name/value pair to the shortform attribute list.
>   * Overflow from the inode has already been checked for.
>   */
>  void
> -xfs_attr_shortform_add(xfs_da_args_t *args, int forkoff)
> +xfs_attr_shortform_add(struct xfs_da_args *args, int forkoff)
>  {
> -	xfs_attr_shortform_t *sf;
> -	xfs_attr_sf_entry_t *sfe;
> -	int i, offset, size;
> -	xfs_mount_t *mp;
> -	xfs_inode_t *dp;
> -	struct xfs_ifork *ifp;
> +	struct xfs_attr_shortform	*sf;
> +	struct xfs_attr_sf_entry	*sfe;
> +	int				offset, size, error;
> +	struct xfs_mount		*mp;
> +	struct xfs_inode		*dp;
> +	struct xfs_ifork		*ifp;
>  
>  	trace_xfs_attr_sf_add(args);
>  
> @@ -676,18 +724,8 @@ xfs_attr_shortform_add(xfs_da_args_t *args, int forkoff)
>  	ifp = dp->i_afp;
>  	ASSERT(ifp->if_flags & XFS_IFINLINE);
>  	sf = (xfs_attr_shortform_t *)ifp->if_u1.if_data;
> -	sfe = &sf->list[0];
> -	for (i = 0; i < sf->hdr.count; sfe = XFS_ATTR_SF_NEXTENTRY(sfe), i++) {
> -#ifdef DEBUG
> -		if (sfe->namelen != args->name.len)
> -			continue;
> -		if (memcmp(args->name.name, sfe->nameval, args->name.len) != 0)
> -			continue;
> -		if (!xfs_attr_namesp_match(args->name.type, sfe->flags))
> -			continue;
> -		ASSERT(0);
> -#endif
> -	}
> +	error = xfs_attr_sf_findname(args, &sfe, NULL);
> +	ASSERT(error != -EEXIST);
>  
>  	offset = (char *)sfe - (char *)sf;
>  	size = XFS_ATTR_SF_ENTSIZE_BYNAME(args->name.len, args->valuelen);
> @@ -730,35 +768,25 @@ xfs_attr_fork_remove(
>   * Remove an attribute from the shortform attribute list structure.
>   */
>  int
> -xfs_attr_shortform_remove(xfs_da_args_t *args)
> +xfs_attr_shortform_remove(struct xfs_da_args *args)
>  {
> -	xfs_attr_shortform_t *sf;
> -	xfs_attr_sf_entry_t *sfe;
> -	int base, size=0, end, totsize, i;
> -	xfs_mount_t *mp;
> -	xfs_inode_t *dp;
> +	struct xfs_attr_shortform	*sf;
> +	struct xfs_attr_sf_entry	*sfe;
> +	int				base, size = 0, end, totsize;
> +	struct xfs_mount		*mp;
> +	struct xfs_inode		*dp;
> +	int				error;
>  
>  	trace_xfs_attr_sf_remove(args);
>  
>  	dp = args->dp;
>  	mp = dp->i_mount;
> -	base = sizeof(xfs_attr_sf_hdr_t);
>  	sf = (xfs_attr_shortform_t *)dp->i_afp->if_u1.if_data;
> -	sfe = &sf->list[0];
> -	end = sf->hdr.count;
> -	for (i = 0; i < end; sfe = XFS_ATTR_SF_NEXTENTRY(sfe),
> -					base += size, i++) {
> -		size = XFS_ATTR_SF_ENTSIZE(sfe);
> -		if (sfe->namelen != args->name.len)
> -			continue;
> -		if (memcmp(sfe->nameval, args->name.name, args->name.len) != 0)
> -			continue;
> -		if (!xfs_attr_namesp_match(args->name.type, sfe->flags))
> -			continue;
> -		break;
> -	}
> -	if (i == end)
> -		return -ENOATTR;
> +
> +	error = xfs_attr_sf_findname(args, &sfe, &base);
> +	if (error != -EEXIST)
> +		return error;
> +	size = XFS_ATTR_SF_ENTSIZE(sfe);
>  
>  	/*
>  	 * Fix up the attribute fork data, covering the hole
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
> index f4a188e..f6165ff 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.h
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.h
> @@ -62,6 +62,9 @@ int	xfs_attr_shortform_getvalue(struct xfs_da_args *args);
>  int	xfs_attr_shortform_to_leaf(struct xfs_da_args *args,
>  			struct xfs_buf **leaf_bp);
>  int	xfs_attr_shortform_remove(struct xfs_da_args *args);
> +int	xfs_attr_sf_findname(struct xfs_da_args *args,
> +			     struct xfs_attr_sf_entry **sfep,
> +			     unsigned int *basep);
>  int	xfs_attr_shortform_allfit(struct xfs_buf *bp, struct xfs_inode *dp);
>  int	xfs_attr_shortform_bytesfit(struct xfs_inode *dp, int bytes);
>  xfs_failaddr_t xfs_attr_shortform_verify(struct xfs_inode *ip);
> -- 
> 2.7.4
> 

