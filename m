Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:59831 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbfDOCqq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 14 Apr 2019 22:46:46 -0400
Subject: Re: [PATCH 6/9] xfs: Add xfs_has_attr and subroutines
References: <20190412225036.22939-1-allison.henderson@oracle.com>
 <20190412225036.22939-7-allison.henderson@oracle.com>
From: Su Yue <Damenly_Su@gmx.com>
Message-ID: <b245cb89-f801-03eb-f3bb-0d8177651f65@gmx.com>
Date: Mon, 15 Apr 2019 10:46:35 +0800
MIME-Version: 1.0
In-Reply-To: <20190412225036.22939-7-allison.henderson@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>, linux-xfs@vger.kernel.org



On 2019/4/13 6:50 AM, Allison Henderson wrote:
> This patch adds a new functions to check for the existence of
> an attribute.  Subroutines are also added to handle the cases
> of leaf blocks, nodes or shortform.  We will need this later
> for delayed attributes since delayed operations cannot return
> error codes.
>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>   fs/xfs/libxfs/xfs_attr.c      | 78 +++++++++++++++++++++++++++++++++++=
++++++++
>   fs/xfs/libxfs/xfs_attr.h      |  1 +
>   fs/xfs/libxfs/xfs_attr_leaf.c | 33 ++++++++++++++++++
>   fs/xfs/libxfs/xfs_attr_leaf.h |  1 +
>   4 files changed, 113 insertions(+)
>
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index c3477fa7..0042708 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -53,6 +53,7 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *a=
rgs);
>   STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
>   STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args, bool roll_trans)=
;
>   STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args, bool roll_tra=
ns);
> +STATIC int xfs_leaf_has_attr(xfs_da_args_t *args);
>
>   /*
>    * Internal routines when attribute list is more than one block.
> @@ -60,6 +61,7 @@ STATIC int xfs_attr_leaf_removename(xfs_da_args_t *arg=
s, bool roll_trans);
>   STATIC int xfs_attr_node_get(xfs_da_args_t *args);
>   STATIC int xfs_attr_node_addname(xfs_da_args_t *args, bool roll_trans)=
;
>   STATIC int xfs_attr_node_removename(xfs_da_args_t *args, bool roll_tra=
ns);
> +STATIC int xfs_attr_node_hasname(xfs_da_args_t *args);
>   STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>   STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
>
> @@ -301,6 +303,29 @@ xfs_attr_set_args(
>   }
>
>   /*
> + * Return successful if attr is found, or ENOATTR if not
> + */
> +int
> +xfs_has_attr(
> +	struct xfs_da_args      *args)
> +{
> +	struct xfs_inode        *dp =3D args->dp;
> +	int                     error;
> +
> +	if (!xfs_inode_hasattr(dp))
> +		error =3D -ENOATTR;
> +	else if (dp->i_d.di_aformat =3D=3D XFS_DINODE_FMT_LOCAL) {
> +		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
> +		error =3D xfs_shortform_has_attr(args);
> +	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
> +		error =3D xfs_leaf_has_attr(args);
> +	else
> +		error =3D xfs_attr_node_hasname(args);
> +
> +	return error;
> +}
> +
> +/*
>    * Remove the attribute specified in @args.
>    */
>   int
> @@ -836,6 +861,29 @@ xfs_attr_leaf_addname(
>   }
>
>   /*
> + * Return successful if attr is found, or ENOATTR if not
> + */
> +STATIC int
> +xfs_leaf_has_attr(
> +	struct xfs_da_args      *args)
> +{
> +	struct xfs_buf          *bp;
> +	int                     error =3D 0;
> +
> +	args->blkno =3D 0;
> +	error =3D xfs_attr3_leaf_read(args->trans, args->dp,
> +			args->blkno, -1, &bp);
> +	if (error)
> +		return error;
> +
> +	error =3D xfs_attr3_leaf_lookup_int(bp, args);
> +	error =3D (error =3D=3D -ENOATTR) ? -ENOATTR : 0;
> +	xfs_trans_brelse(args->trans, bp);
> +
> +	return error;
> +}
> +
> +/*
>    * Remove a name from the leaf attribute list structure
>    *
>    * This leaf block cannot have a "remote" value, we only call this rou=
tine
> @@ -1166,6 +1214,36 @@ xfs_attr_node_addname(
>   }
>
>   /*
> + * Return successful if attr is found, or ENOATTR if not
> + */
> +STATIC int
> +xfs_attr_node_hasname(
> +	struct xfs_da_args	*args)
> +{
> +	struct xfs_da_state	*state;
> +	struct xfs_inode	*dp;
> +	int			retval, error;
> +
> +	/*
> +	 * Tie a string around our finger to remind us where we are.
> +	 */
> +	dp =3D args->dp;
> +	state =3D xfs_da_state_alloc();

The corresponding xfs_da_state_free(state) seems lost...

=2D--
Su
> +	state->args =3D args;
> +	state->mp =3D dp->i_mount;
> +
> +	/*
> +	 * Search to see if name exists, and get back a pointer to it.
> +	 */
> +	error =3D xfs_da3_node_lookup_int(state, &retval);
> +	if (error || (retval !=3D -EEXIST)) {
> +		if (error =3D=3D 0)
> +			error =3D retval;
> +	}
> +	return error;
> +}
> +
> +/*
>    * Remove a name from a B-tree attribute list.
>    *
>    * This will involve walking down the Btree, and may involve joining
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 83b3621..974c963 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -168,6 +168,7 @@ int xfs_attr_set_args(struct xfs_da_args *args, stru=
ct xfs_buf **leaf_bp,
>   		 bool roll_trans);
>   int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name,
>   		    size_t namelen, int flags);
> +int xfs_has_attr(struct xfs_da_args *args);
>   int xfs_attr_remove_args(struct xfs_da_args *args, bool roll_trans);
>   int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
>   		  int flags, struct attrlist_cursor_kern *cursor);
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf=
.c
> index 128bfe9..e9f2f53 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -622,6 +622,39 @@ xfs_attr_fork_remove(
>   }
>
>   /*
> + * Return successful if attr is found, or ENOATTR if not
> + */
> +int
> +xfs_shortform_has_attr(
> +	struct xfs_da_args	 *args)
> +{
> +	struct xfs_attr_shortform *sf;
> +	struct xfs_attr_sf_entry *sfe;
> +	int			base =3D sizeof(struct xfs_attr_sf_hdr);
> +	int			size =3D 0;
> +	int			end;
> +	int			i;
> +
> +	sf =3D (struct xfs_attr_shortform *)args->dp->i_afp->if_u1.if_data;
> +	sfe =3D &sf->list[0];
> +	end =3D sf->hdr.count;
> +	for (i =3D 0; i < end; sfe =3D XFS_ATTR_SF_NEXTENTRY(sfe),
> +			base +=3D size, i++) {
> +		size =3D XFS_ATTR_SF_ENTSIZE(sfe);
> +		if (sfe->namelen !=3D args->namelen)
> +			continue;
> +		if (memcmp(sfe->nameval, args->name, args->namelen) !=3D 0)
> +			continue;
> +		if (!xfs_attr_namesp_match(args->flags, sfe->flags))
> +			continue;
> +		break;
> +	}
> +	if (i =3D=3D end)
> +		return -ENOATTR;
> +	return 0;
> +}
> +
> +/*
>    * Remove an attribute from the shortform attribute list structure.
>    */
>   int
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf=
.h
> index 9d830ec..98dd169 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.h
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.h
> @@ -39,6 +39,7 @@ int	xfs_attr_shortform_getvalue(struct xfs_da_args *ar=
gs);
>   int	xfs_attr_shortform_to_leaf(struct xfs_da_args *args,
>   			struct xfs_buf **leaf_bp);
>   int	xfs_attr_shortform_remove(struct xfs_da_args *args);
> +int	xfs_shortform_has_attr(struct xfs_da_args *args);
>   int	xfs_attr_shortform_allfit(struct xfs_buf *bp, struct xfs_inode *dp=
);
>   int	xfs_attr_shortform_bytesfit(struct xfs_inode *dp, int bytes);
>   xfs_failaddr_t xfs_attr_shortform_verify(struct xfs_inode *ip);
>
