Return-Path: <SRS0=uPG+=3K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E5A7C2D0CE
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 22:48:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D3E024125
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 22:48:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SPS8sL2U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgAUWsp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jan 2020 17:48:45 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:38146 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbgAUWso (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jan 2020 17:48:44 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LMmBbD190033
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2020 22:48:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=3P9Dq07lsN8+mgeLRdsZVQu/Vz034zfj8V3G3J3urdg=;
 b=SPS8sL2UAHyLmEo6CMt52kxjW4VcPekOzflzNnMx9L8NFHEjaB4yUrltefDq67nYy4D7
 N25cNoYPPkpFJ1Xk6SiAWuRbjBbFJ0vJbTRZy+rvZcdbJtGVUXQIvwZqGAbHsrns0ob+
 XiDglabwHq9NWsyXvdTbkis2YrUAkhYrE3ouHCgVcAclToYoy1CzJ5GE25YRxeXZqPUu
 yZYTo2xw+tzxwx7IohB8CNCrxbUaiCFHEzfdvOOZMf8WFRAhD77BEc6Nme4aCaArpptN
 30l7LZXDnpnKvT2mcyvZT+519Li0ZjEDGncYaXZVzjd6zF3SYCQXaaIbuBrYkG6RuJST JQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2xksyq880g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2020 22:48:42 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LMmd7d143878
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2020 22:48:41 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2xnpegm2k3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2020 22:48:39 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00LMmENe021379
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2020 22:48:14 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jan 2020 14:48:13 -0800
Date:   Tue, 21 Jan 2020 14:48:12 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v6 03/16] xfs: Add xfs_has_attr and subroutines
Message-ID: <20200121224812.GH8247@magnolia>
References: <20200118225035.19503-1-allison.henderson@oracle.com>
 <20200118225035.19503-4-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200118225035.19503-4-allison.henderson@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001210169
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001210169
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jan 18, 2020 at 03:50:22PM -0700, Allison Collins wrote:
> From: Allison Henderson <allison.henderson@oracle.com>
> 
> This patch adds a new functions to check for the existence of an
> attribute.  Subroutines are also added to handle the cases of leaf
> blocks, nodes or shortform.  Common code that appears in existing attr
> add and remove functions have been factored out to help reduce the
> appearance of duplicated code.  We will need these routines later for
> delayed attributes since delayed operations cannot return error codes.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c      | 171 ++++++++++++++++++++++++++++--------------
>  fs/xfs/libxfs/xfs_attr.h      |   1 +
>  fs/xfs/libxfs/xfs_attr_leaf.c | 111 +++++++++++++++++----------
>  fs/xfs/libxfs/xfs_attr_leaf.h |   3 +
>  4 files changed, 188 insertions(+), 98 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 9acdb23..a2507b9 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -46,6 +46,7 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
>  STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
>  STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args);
>  STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
> +STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
>  
>  /*
>   * Internal routines when attribute list is more than one block.
> @@ -53,6 +54,8 @@ STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
>  STATIC int xfs_attr_node_get(xfs_da_args_t *args);
>  STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
>  STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
> +STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
> +				 struct xfs_da_state **state);
>  STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>  STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
>  
> @@ -310,6 +313,37 @@ xfs_attr_set_args(
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
> +	struct xfs_buf		*bp = NULL;
> +	int			error;
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
> +		error = xfs_attr_leaf_hasname(args, &bp);
> +
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
> @@ -583,26 +617,20 @@ STATIC int
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

Don't we need this initialization?

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
>  	if ((args->name.type & ATTR_REPLACE) && (retval == -ENOATTR)) {
>  		xfs_trans_brelse(args->trans, bp);
>  		return retval;
> @@ -754,6 +782,27 @@ xfs_attr_leaf_addname(
>  }
>  
>  /*
> + * Return EEXIST if attr is found, or ENOATTR if not
> + */
> +STATIC int
> +xfs_attr_leaf_hasname(
> +	struct xfs_da_args      *args,
> +	struct xfs_buf		**bp)
> +{
> +	int                     error = 0;
> +
> +	error = xfs_attr3_leaf_read(args->trans, args->dp, 0, bp);
> +	if (error)
> +		return error;
> +
> +	error = xfs_attr3_leaf_lookup_int(*bp, args);
> +	if (error != -ENOATTR && error != -EEXIST)
> +		xfs_trans_brelse(args->trans, *bp);
> +
> +	return error;
> +}
> +
> +/*
>   * Remove a name from the leaf attribute list structure
>   *
>   * This leaf block cannot have a "remote" value, we only call this routine
> @@ -773,12 +822,11 @@ xfs_attr_leaf_removename(
>  	 * Remove the attribute.
>  	 */
>  	dp = args->dp;
> -	args->blkno = 0;
> -	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, &bp);
> -	if (error)
> +
> +	error = xfs_attr_leaf_hasname(args, &bp);
> +	if (error != -ENOATTR && error != -EEXIST)
>  		return error;
>  
> -	error = xfs_attr3_leaf_lookup_int(bp, args);
>  	if (error == -ENOATTR) {
>  		xfs_trans_brelse(args->trans, bp);
>  		return error;
> @@ -817,12 +865,10 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
>  
>  	trace_xfs_attr_leaf_get(args);
>  
> -	args->blkno = 0;
> -	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, &bp);
> -	if (error)
> +	error = xfs_attr_leaf_hasname(args, &bp);
> +	if (error != -ENOATTR && error != -EEXIST)
>  		return error;
>  
> -	error = xfs_attr3_leaf_lookup_int(bp, args);
>  	if (error != -EEXIST)  {
>  		xfs_trans_brelse(args->trans, bp);
>  		return error;
> @@ -832,6 +878,41 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
>  	return error;
>  }
>  
> +/*
> + * Return EEXIST if attr is found, or ENOATTR if not
> + * statep: If not null is set to point at the found state.  Caller will
> + *         be responsible for freeing the state in this case.

Uh... a predicate returns an xfs_da_state object?

/me starts to wonder if these hasname functions ought to be some sort of
lookup function that returns the appropriate context for inserting a new
xattr entry if ENOATTR; a NULL context if EEXIST; or some other error if
something actually went wrong...?

Granted I have this funny feeling that most of the attr code works on
the principle that we're supposed to pass ENOATTR/EEXIST from lower
layers to higher layers, which makes me unsure if it makes more sense to
stop abusing those magic error codes (and therefore having to switch()
on every error return) or not.

I dunno, I also had questions that I attached to the previous version of
this patch, so... <shrug>

--D

> + */
> +STATIC int
> +xfs_attr_node_hasname(
> +	struct xfs_da_args	*args,
> +	struct xfs_da_state	**statep)
> +{
> +	struct xfs_da_state	*state;
> +	int			retval, error;
> +
> +	state = xfs_da_state_alloc();
> +	state->args = args;
> +	state->mp = args->dp->i_mount;
> +
> +	if (statep != NULL)
> +		*statep = NULL;
> +
> +	/*
> +	 * Search to see if name exists, and get back a pointer to it.
> +	 */
> +	error = xfs_da3_node_lookup_int(state, &retval);
> +	if (error == 0) {
> +		if (statep != NULL)
> +			*statep = state;
> +		return retval;
> +	}
> +
> +	xfs_da_state_free(state);
> +
> +	return error;
> +}
> +
>  /*========================================================================
>   * External routines when attribute list size > geo->blksize
>   *========================================================================*/
> @@ -864,20 +945,17 @@ xfs_attr_node_addname(
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
> +
>  	blk = &state->path.blk[ state->path.active-1 ];
>  	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
> -	if ((args->name.type & ATTR_REPLACE) && (retval == -ENOATTR)) {
> +	if (args->name.type & ATTR_REPLACE) {
>  		goto out;
>  	} else if (retval == -EEXIST) {
>  		if (args->name.type & ATTR_CREATE)
> @@ -1079,29 +1157,15 @@ xfs_attr_node_removename(
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
> @@ -1196,7 +1260,8 @@ xfs_attr_node_removename(
>  	error = 0;
>  
>  out:
> -	xfs_da_state_free(state);
> +	if (state)
> +		xfs_da_state_free(state);
>  	return error;
>  }
>  
> @@ -1316,31 +1381,23 @@ xfs_attr_node_get(xfs_da_args_t *args)
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
> @@ -1352,7 +1409,7 @@ xfs_attr_node_get(xfs_da_args_t *args)
>  	}
>  
>  	xfs_da_state_free(state);
> -	return retval;
> +	return error;
>  }
>  
>  /* Returns true if the attribute entry name is valid. */
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 35043db..ce7b039 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -153,6 +153,7 @@ int xfs_attr_set(struct xfs_inode *dp, struct xfs_name *name,
>  		 unsigned char *value, int valuelen, int flags);
>  int xfs_attr_set_args(struct xfs_da_args *args);
>  int xfs_attr_remove(struct xfs_inode *dp, struct xfs_name *name, int flags);
> +int xfs_has_attr(struct xfs_da_args *args);
>  int xfs_attr_remove_args(struct xfs_da_args *args);
>  int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
>  		  int flags, struct attrlist_cursor_kern *cursor);
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index cb5ef66..9d6b68c 100644
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
> @@ -730,35 +768,26 @@ xfs_attr_fork_remove(
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
> +	int				size = 0, end, totsize;
> +	unsigned int			base;
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
