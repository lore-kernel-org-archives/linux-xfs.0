Return-Path: <SRS0=SLm5=XN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A464C4CEC9
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 16:44:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4FC1621907
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 16:44:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730253AbfIRQoM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Sep 2019 12:44:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39340 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728817AbfIRQoL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Sep 2019 12:44:11 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CF9D48A1C8E;
        Wed, 18 Sep 2019 16:44:10 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 615AF5D9E1;
        Wed, 18 Sep 2019 16:44:10 +0000 (UTC)
Date:   Wed, 18 Sep 2019 12:44:08 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 02/19] xfs: Embed struct xfs_name in xfs_da_args
Message-ID: <20190918164408.GF29377@bfoster>
References: <20190905221837.17388-1-allison.henderson@oracle.com>
 <20190905221837.17388-3-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190905221837.17388-3-allison.henderson@oracle.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.69]); Wed, 18 Sep 2019 16:44:11 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 05, 2019 at 03:18:20PM -0700, Allison Collins wrote:
> This patch embeds an xfs_name in xfs_da_args, replacing the name,
> namelen, and flags members.  This helps to clean up the xfs_da_args
> structure and make it more uniform with the new xfs_name parameter
> being passed around.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c        |  34 ++++++-------
>  fs/xfs/libxfs/xfs_attr_leaf.c   | 106 +++++++++++++++++++++-------------------
>  fs/xfs/libxfs/xfs_attr_remote.c |   2 +-
>  fs/xfs/libxfs/xfs_da_btree.c    |   5 +-
>  fs/xfs/libxfs/xfs_da_btree.h    |   4 +-
>  fs/xfs/libxfs/xfs_dir2.c        |  22 ++++-----
>  fs/xfs/libxfs/xfs_dir2_block.c  |   6 +--
>  fs/xfs/libxfs/xfs_dir2_leaf.c   |   6 +--
>  fs/xfs/libxfs/xfs_dir2_node.c   |   8 +--
>  fs/xfs/libxfs/xfs_dir2_sf.c     |  30 ++++++------
>  fs/xfs/scrub/attr.c             |  12 ++---
>  fs/xfs/xfs_trace.h              |  20 ++++----
>  12 files changed, 130 insertions(+), 125 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index d0308d6..50e099f 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -71,13 +71,13 @@ xfs_attr_args_init(
>  	args->geo = dp->i_mount->m_attr_geo;
>  	args->whichfork = XFS_ATTR_FORK;
>  	args->dp = dp;
> -	args->flags = name->type;
> -	args->name = name->name;
> -	args->namelen = name->len;
> -	if (args->namelen >= MAXNAMELEN)
> +	args->name.type = name->type;
> +	args->name.name = name->name;
> +	args->name.len = name->len;

Looks like this could be a struct copy:

	args->name = *name;

> +	if (args->name.len >= MAXNAMELEN)
>  		return -EFAULT;		/* match IRIX behaviour */
>  
> -	args->hashval = xfs_da_hashname(args->name, args->namelen);
> +	args->hashval = xfs_da_hashname(args->name.name, args->name.len);
>  	return 0;
>  }
>  
...
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index 867c5de..e8d6721 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
...
> @@ -259,8 +259,8 @@ xfs_dir_createname(
>  		return -ENOMEM;
>  
>  	args->geo = dp->i_mount->m_dir_geo;
> -	args->name = name->name;
> -	args->namelen = name->len;
> +	args->name.name = name->name;
> +	args->name.len = name->len;
>  	args->filetype = name->type;
>  	args->hashval = dp->i_mount->m_dirnameops->hashname(name);
>  	args->inumber = inum;
> @@ -355,8 +355,8 @@ xfs_dir_lookup(
>  	 */
>  	args = kmem_zalloc(sizeof(*args), KM_NOFS);
>  	args->geo = dp->i_mount->m_dir_geo;
> -	args->name = name->name;
> -	args->namelen = name->len;
> +	args->name.name = name->name;
> +	args->name.len = name->len;
>  	args->filetype = name->type;
>  	args->hashval = dp->i_mount->m_dirnameops->hashname(name);
>  	args->dp = dp;
> @@ -427,8 +427,8 @@ xfs_dir_removename(
>  		return -ENOMEM;
>  
>  	args->geo = dp->i_mount->m_dir_geo;
> -	args->name = name->name;
> -	args->namelen = name->len;
> +	args->name.name = name->name;
> +	args->name.len = name->len;
>  	args->filetype = name->type;
>  	args->hashval = dp->i_mount->m_dirnameops->hashname(name);
>  	args->inumber = ino;
> @@ -488,8 +488,8 @@ xfs_dir_replace(
>  		return -ENOMEM;
>  
>  	args->geo = dp->i_mount->m_dir_geo;
> -	args->name = name->name;
> -	args->namelen = name->len;
> +	args->name.name = name->name;
> +	args->name.len = name->len;
>  	args->filetype = name->type;
>  	args->hashval = dp->i_mount->m_dirnameops->hashname(name);
>  	args->inumber = inum;

More struct copy candidates above. Modulo that and the comments on the
previous patch, the rest LGTM:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
> index 9595ced..94269b9 100644
> --- a/fs/xfs/libxfs/xfs_dir2_block.c
> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
> @@ -355,7 +355,7 @@ xfs_dir2_block_addname(
>  	if (error)
>  		return error;
>  
> -	len = dp->d_ops->data_entsize(args->namelen);
> +	len = dp->d_ops->data_entsize(args->name.len);
>  
>  	/*
>  	 * Set up pointers to parts of the block.
> @@ -539,8 +539,8 @@ xfs_dir2_block_addname(
>  	 * Create the new data entry.
>  	 */
>  	dep->inumber = cpu_to_be64(args->inumber);
> -	dep->namelen = args->namelen;
> -	memcpy(dep->name, args->name, args->namelen);
> +	dep->namelen = args->name.len;
> +	memcpy(dep->name, args->name.name, args->name.len);
>  	dp->d_ops->data_put_ftype(dep, args->filetype);
>  	tagp = dp->d_ops->data_entry_tag_p(dep);
>  	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
> index a53e458..b7046e2 100644
> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
> @@ -610,7 +610,7 @@ xfs_dir2_leaf_addname(
>  	ents = dp->d_ops->leaf_ents_p(leaf);
>  	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
>  	bestsp = xfs_dir2_leaf_bests_p(ltp);
> -	length = dp->d_ops->data_entsize(args->namelen);
> +	length = dp->d_ops->data_entsize(args->name.len);
>  
>  	/*
>  	 * See if there are any entries with the same hash value
> @@ -813,8 +813,8 @@ xfs_dir2_leaf_addname(
>  	 */
>  	dep = (xfs_dir2_data_entry_t *)dup;
>  	dep->inumber = cpu_to_be64(args->inumber);
> -	dep->namelen = args->namelen;
> -	memcpy(dep->name, args->name, dep->namelen);
> +	dep->namelen = args->name.len;
> +	memcpy(dep->name, args->name.name, dep->namelen);
>  	dp->d_ops->data_put_ftype(dep, args->filetype);
>  	tagp = dp->d_ops->data_entry_tag_p(dep);
>  	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index 705c4f5..8bbd742 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -604,7 +604,7 @@ xfs_dir2_leafn_lookup_for_addname(
>  		ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC) ||
>  		       free->hdr.magic == cpu_to_be32(XFS_DIR3_FREE_MAGIC));
>  	}
> -	length = dp->d_ops->data_entsize(args->namelen);
> +	length = dp->d_ops->data_entsize(args->name.len);
>  	/*
>  	 * Loop over leaf entries with the right hash value.
>  	 */
> @@ -1869,7 +1869,7 @@ xfs_dir2_node_addname_int(
>  	__be16			*tagp;		/* data entry tag pointer */
>  	__be16			*bests;
>  
> -	length = dp->d_ops->data_entsize(args->namelen);
> +	length = dp->d_ops->data_entsize(args->name.len);
>  	error = xfs_dir2_node_find_freeblk(args, fblk, &dbno, &fbp, &findex,
>  					   length);
>  	if (error)
> @@ -1924,8 +1924,8 @@ xfs_dir2_node_addname_int(
>  	/* Fill in the new entry and log it. */
>  	dep = (xfs_dir2_data_entry_t *)dup;
>  	dep->inumber = cpu_to_be64(args->inumber);
> -	dep->namelen = args->namelen;
> -	memcpy(dep->name, args->name, dep->namelen);
> +	dep->namelen = args->name.len;
> +	memcpy(dep->name, args->name.name, dep->namelen);
>  	dp->d_ops->data_put_ftype(dep, args->filetype);
>  	tagp = dp->d_ops->data_entry_tag_p(dep);
>  	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> index 85f14fc..fdc1431 100644
> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> @@ -291,7 +291,7 @@ xfs_dir2_sf_addname(
>  	/*
>  	 * Compute entry (and change in) size.
>  	 */
> -	incr_isize = dp->d_ops->sf_entsize(sfp, args->namelen);
> +	incr_isize = dp->d_ops->sf_entsize(sfp, args->name.len);
>  	objchange = 0;
>  
>  	/*
> @@ -375,7 +375,7 @@ xfs_dir2_sf_addname_easy(
>  	/*
>  	 * Grow the in-inode space.
>  	 */
> -	xfs_idata_realloc(dp, dp->d_ops->sf_entsize(sfp, args->namelen),
> +	xfs_idata_realloc(dp, dp->d_ops->sf_entsize(sfp, args->name.len),
>  			  XFS_DATA_FORK);
>  	/*
>  	 * Need to set up again due to realloc of the inode data.
> @@ -385,9 +385,9 @@ xfs_dir2_sf_addname_easy(
>  	/*
>  	 * Fill in the new entry.
>  	 */
> -	sfep->namelen = args->namelen;
> +	sfep->namelen = args->name.len;
>  	xfs_dir2_sf_put_offset(sfep, offset);
> -	memcpy(sfep->name, args->name, sfep->namelen);
> +	memcpy(sfep->name, args->name.name, sfep->namelen);
>  	dp->d_ops->sf_put_ino(sfp, sfep, args->inumber);
>  	dp->d_ops->sf_put_ftype(sfep, args->filetype);
>  
> @@ -446,7 +446,7 @@ xfs_dir2_sf_addname_hard(
>  	 */
>  	for (offset = dp->d_ops->data_first_offset,
>  	      oldsfep = xfs_dir2_sf_firstentry(oldsfp),
> -	      add_datasize = dp->d_ops->data_entsize(args->namelen),
> +	      add_datasize = dp->d_ops->data_entsize(args->name.len),
>  	      eof = (char *)oldsfep == &buf[old_isize];
>  	     !eof;
>  	     offset = new_offset + dp->d_ops->data_entsize(oldsfep->namelen),
> @@ -476,9 +476,9 @@ xfs_dir2_sf_addname_hard(
>  	/*
>  	 * Fill in the new entry, and update the header counts.
>  	 */
> -	sfep->namelen = args->namelen;
> +	sfep->namelen = args->name.len;
>  	xfs_dir2_sf_put_offset(sfep, offset);
> -	memcpy(sfep->name, args->name, sfep->namelen);
> +	memcpy(sfep->name, args->name.name, sfep->namelen);
>  	dp->d_ops->sf_put_ino(sfp, sfep, args->inumber);
>  	dp->d_ops->sf_put_ftype(sfep, args->filetype);
>  	sfp->count++;
> @@ -522,7 +522,7 @@ xfs_dir2_sf_addname_pick(
>  	dp = args->dp;
>  
>  	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
> -	size = dp->d_ops->data_entsize(args->namelen);
> +	size = dp->d_ops->data_entsize(args->name.len);
>  	offset = dp->d_ops->data_first_offset;
>  	sfep = xfs_dir2_sf_firstentry(sfp);
>  	holefit = 0;
> @@ -807,7 +807,7 @@ xfs_dir2_sf_lookup(
>  	/*
>  	 * Special case for .
>  	 */
> -	if (args->namelen == 1 && args->name[0] == '.') {
> +	if (args->name.len == 1 && args->name.name[0] == '.') {
>  		args->inumber = dp->i_ino;
>  		args->cmpresult = XFS_CMP_EXACT;
>  		args->filetype = XFS_DIR3_FT_DIR;
> @@ -816,8 +816,8 @@ xfs_dir2_sf_lookup(
>  	/*
>  	 * Special case for ..
>  	 */
> -	if (args->namelen == 2 &&
> -	    args->name[0] == '.' && args->name[1] == '.') {
> +	if (args->name.len == 2 &&
> +	    args->name.name[0] == '.' && args->name.name[1] == '.') {
>  		args->inumber = dp->d_ops->sf_get_parent_ino(sfp);
>  		args->cmpresult = XFS_CMP_EXACT;
>  		args->filetype = XFS_DIR3_FT_DIR;
> @@ -912,7 +912,7 @@ xfs_dir2_sf_removename(
>  	 * Calculate sizes.
>  	 */
>  	byteoff = (int)((char *)sfep - (char *)sfp);
> -	entsize = dp->d_ops->sf_entsize(sfp, args->namelen);
> +	entsize = dp->d_ops->sf_entsize(sfp, args->name.len);
>  	newsize = oldsize - entsize;
>  	/*
>  	 * Copy the part if any after the removed entry, sliding it down.
> @@ -1002,12 +1002,12 @@ xfs_dir2_sf_replace(
>  	} else
>  		i8elevated = 0;
>  
> -	ASSERT(args->namelen != 1 || args->name[0] != '.');
> +	ASSERT(args->name.len != 1 || args->name.name[0] != '.');
>  	/*
>  	 * Replace ..'s entry.
>  	 */
> -	if (args->namelen == 2 &&
> -	    args->name[0] == '.' && args->name[1] == '.') {
> +	if (args->name.len == 2 &&
> +	    args->name.name[0] == '.' && args->name.name[1] == '.') {
>  		ino = dp->d_ops->sf_get_parent_ino(sfp);
>  		ASSERT(args->inumber != ino);
>  		dp->d_ops->sf_put_parent_ino(sfp, args->inumber);
> diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
> index 0edc7f8..42f7c07 100644
> --- a/fs/xfs/scrub/attr.c
> +++ b/fs/xfs/scrub/attr.c
> @@ -147,17 +147,17 @@ xchk_xattr_listent(
>  		return;
>  	}
>  
> -	args.flags = ATTR_KERNOTIME;
> +	args.name.type = ATTR_KERNOTIME;
>  	if (flags & XFS_ATTR_ROOT)
> -		args.flags |= ATTR_ROOT;
> +		args.name.type |= ATTR_ROOT;
>  	else if (flags & XFS_ATTR_SECURE)
> -		args.flags |= ATTR_SECURE;
> +		args.name.type |= ATTR_SECURE;
>  	args.geo = context->dp->i_mount->m_attr_geo;
>  	args.whichfork = XFS_ATTR_FORK;
>  	args.dp = context->dp;
> -	args.name = name;
> -	args.namelen = namelen;
> -	args.hashval = xfs_da_hashname(args.name, args.namelen);
> +	args.name.name = name;
> +	args.name.len = namelen;
> +	args.hashval = xfs_da_hashname(args.name.name, args.name.len);
>  	args.trans = context->tp;
>  	args.value = xchk_xattr_valuebuf(sx->sc);
>  	args.valuelen = valuelen;
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index eaae275..e0f524d 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1669,7 +1669,7 @@ DECLARE_EVENT_CLASS(xfs_da_class,
>  	TP_STRUCT__entry(
>  		__field(dev_t, dev)
>  		__field(xfs_ino_t, ino)
> -		__dynamic_array(char, name, args->namelen)
> +		__dynamic_array(char, name, args->name.len)
>  		__field(int, namelen)
>  		__field(xfs_dahash_t, hashval)
>  		__field(xfs_ino_t, inumber)
> @@ -1678,9 +1678,10 @@ DECLARE_EVENT_CLASS(xfs_da_class,
>  	TP_fast_assign(
>  		__entry->dev = VFS_I(args->dp)->i_sb->s_dev;
>  		__entry->ino = args->dp->i_ino;
> -		if (args->namelen)
> -			memcpy(__get_str(name), args->name, args->namelen);
> -		__entry->namelen = args->namelen;
> +		if (args->name.len)
> +			memcpy(__get_str(name), args->name.name,
> +			       args->name.len);
> +		__entry->namelen = args->name.len;
>  		__entry->hashval = args->hashval;
>  		__entry->inumber = args->inumber;
>  		__entry->op_flags = args->op_flags;
> @@ -1733,7 +1734,7 @@ DECLARE_EVENT_CLASS(xfs_attr_class,
>  	TP_STRUCT__entry(
>  		__field(dev_t, dev)
>  		__field(xfs_ino_t, ino)
> -		__dynamic_array(char, name, args->namelen)
> +		__dynamic_array(char, name, args->name.len)
>  		__field(int, namelen)
>  		__field(int, valuelen)
>  		__field(xfs_dahash_t, hashval)
> @@ -1743,12 +1744,13 @@ DECLARE_EVENT_CLASS(xfs_attr_class,
>  	TP_fast_assign(
>  		__entry->dev = VFS_I(args->dp)->i_sb->s_dev;
>  		__entry->ino = args->dp->i_ino;
> -		if (args->namelen)
> -			memcpy(__get_str(name), args->name, args->namelen);
> -		__entry->namelen = args->namelen;
> +		if (args->name.len)
> +			memcpy(__get_str(name), args->name.name,
> +			       args->name.len);
> +		__entry->namelen = args->name.len;
>  		__entry->valuelen = args->valuelen;
>  		__entry->hashval = args->hashval;
> -		__entry->flags = args->flags;
> +		__entry->flags = args->name.type;
>  		__entry->op_flags = args->op_flags;
>  	),
>  	TP_printk("dev %d:%d ino 0x%llx name %.*s namelen %d valuelen %d "
> -- 
> 2.7.4
> 
