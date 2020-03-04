Return-Path: <SRS0=37eZ=4V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3799C3F2D1
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 18:21:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7465E20828
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 18:21:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NNSQZAcI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727528AbgCDSVJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Mar 2020 13:21:09 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:55686 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727137AbgCDSVJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Mar 2020 13:21:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583346068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BN57978Q234LlfxCQn4O32PBwkUUhlm2lHqVeVE290w=;
        b=NNSQZAcIS2iNIkZVArCRFzzDc6ti7hhSWX9DfvatUKBmqBp9pLiDfZwnkLjVWdiXWjHFWw
        sdsBbq5zv8boJLPZQsMMVk9jLcSTOAlnxch6qZQ1vVuzU1a7JIpWlUTLrI5Bb+mFN807pG
        p7tY0GESnashkuvoO0nwQ47bZqS4wN4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-116-e5zav9iLMHGQjL0xdgnN7g-1; Wed, 04 Mar 2020 13:21:06 -0500
X-MC-Unique: e5zav9iLMHGQjL0xdgnN7g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7853A801F74;
        Wed,  4 Mar 2020 18:21:05 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0F93E10013A1;
        Wed,  4 Mar 2020 18:21:04 +0000 (UTC)
Date:   Wed, 4 Mar 2020 13:21:03 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: introduce fake roots for ag-rooted btrees
Message-ID: <20200304182103.GB22037@bfoster>
References: <158329250190.2423432.16958662769192587982.stgit@magnolia>
 <158329250827.2423432.18007812133503266256.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158329250827.2423432.18007812133503266256.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 03, 2020 at 07:28:28PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create an in-core fake root for AG-rooted btree types so that callers
> can generate a whole new btree using the upcoming btree bulk load
> function without making the new tree accessible from the rest of the
> filesystem.  It is up to the individual btree type to provide a function
> to create a staged cursor (presumably with the appropriate callouts to
> update the fakeroot) and then commit the staged root back into the
> filesystem.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

The code all seems reasonable, mostly infrastructure. Just a few high
level comments..

It would be helpful if the commit log (or code comments) explained more
about the callouts that are replaced for a staging tree (and why).

>  fs/xfs/libxfs/xfs_btree.c |  117 +++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_btree.h |   42 ++++++++++++++--
>  fs/xfs/xfs_trace.h        |   28 +++++++++++
>  3 files changed, 182 insertions(+), 5 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index e6f898bf3174..9a7c1a4d0423 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -382,6 +382,8 @@ xfs_btree_del_cursor(
>  	/*
>  	 * Free the cursor.
>  	 */
> +	if (unlikely(cur->bc_flags & XFS_BTREE_STAGING))
> +		kmem_free((void *)cur->bc_ops);
>  	kmem_cache_free(xfs_btree_cur_zone, cur);
>  }
>  
> @@ -4908,3 +4910,118 @@ xfs_btree_has_more_records(
>  	else
>  		return block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK);
>  }
> +
> +/* We don't allow staging cursors to be duplicated. */
> +STATIC struct xfs_btree_cur *
> +xfs_btree_fakeroot_dup_cursor(
> +	struct xfs_btree_cur	*cur)
> +{
> +	ASSERT(0);
> +	return NULL;
> +}
> +
> +/* Refuse to allow regular block allocation for a staging cursor. */
> +STATIC int
> +xfs_btree_fakeroot_alloc_block(
> +	struct xfs_btree_cur	*cur,
> +	union xfs_btree_ptr	*start_bno,
> +	union xfs_btree_ptr	*new_bno,
> +	int			*stat)
> +{
> +	ASSERT(0);
> +	return -EFSCORRUPTED;

Calling these is a runtime bug as opposed to corruption, right?

> +}
> +
> +/* Refuse to allow block freeing for a staging cursor. */
> +STATIC int
> +xfs_btree_fakeroot_free_block(
> +	struct xfs_btree_cur	*cur,
> +	struct xfs_buf		*bp)
> +{
> +	ASSERT(0);
> +	return -EFSCORRUPTED;
> +}
> +

For example, why do we not allow alloc/frees of blocks into a staging
tree? Is this something related to how staging trees will be constructed
vs. normal trees, or is this just stubbed in and to be implemented
later?

> +/* Initialize a pointer to the root block from the fakeroot. */
> +STATIC void
> +xfs_btree_fakeroot_init_ptr_from_cur(
> +	struct xfs_btree_cur	*cur,
> +	union xfs_btree_ptr	*ptr)
> +{
> +	struct xbtree_afakeroot	*afake;
> +
> +	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
> +
> +	afake = cur->bc_private.a.afake;
> +	ptr->s = cpu_to_be32(afake->af_root);
> +}
> +
> +/* Set the root block when our tree has a fakeroot. */
> +STATIC void
> +xfs_btree_afakeroot_set_root(
> +	struct xfs_btree_cur	*cur,
> +	union xfs_btree_ptr	*ptr,
> +	int			inc)
> +{
> +	struct xbtree_afakeroot	*afake = cur->bc_private.a.afake;
> +
> +	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
> +	afake->af_root = be32_to_cpu(ptr->s);
> +	afake->af_levels += inc;
> +}
> +
> +/*
> + * Initialize a AG-rooted btree cursor with the given AG btree fake root.  The
> + * btree cursor's @bc_ops will be overridden as needed to make the staging
> + * functionality work.  If @new_ops is not NULL, these new ops will be passed
> + * out to the caller for further overriding.
> + */
> +void
> +xfs_btree_stage_afakeroot(
> +	struct xfs_btree_cur		*cur,
> +	struct xbtree_afakeroot		*afake,
> +	struct xfs_btree_ops		**new_ops)
> +{
> +	struct xfs_btree_ops		*nops;
> +
> +	ASSERT(!(cur->bc_flags & XFS_BTREE_STAGING));
> +	ASSERT(!(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE));
> +
> +	nops = kmem_alloc(sizeof(struct xfs_btree_ops), KM_NOFS);
> +	memcpy(nops, cur->bc_ops, sizeof(struct xfs_btree_ops));
> +	nops->alloc_block = xfs_btree_fakeroot_alloc_block;
> +	nops->free_block = xfs_btree_fakeroot_free_block;
> +	nops->init_ptr_from_cur = xfs_btree_fakeroot_init_ptr_from_cur;
> +	nops->set_root = xfs_btree_afakeroot_set_root;
> +	nops->dup_cursor = xfs_btree_fakeroot_dup_cursor;
> +
> +	cur->bc_private.a.afake = afake;
> +	cur->bc_nlevels = afake->af_levels;
> +	cur->bc_ops = nops;
> +	cur->bc_flags |= XFS_BTREE_STAGING;
> +
> +	if (new_ops)
> +		*new_ops = nops;
> +}
> +
> +/*
> + * Transform an AG-rooted staging btree cursor back into a regular cursor by
> + * substituting a real btree root for the fake one and restoring normal btree
> + * cursor ops.  The caller must log the btree root change prior to calling
> + * this.
> + */
> +void
> +xfs_btree_commit_afakeroot(
> +	struct xfs_btree_cur		*cur,
> +	struct xfs_buf			*agbp,
> +	const struct xfs_btree_ops	*ops)
> +{
> +	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
> +
> +	trace_xfs_btree_commit_afakeroot(cur);
> +
> +	kmem_free((void *)cur->bc_ops);
> +	cur->bc_private.a.agbp = agbp;
> +	cur->bc_ops = ops;
> +	cur->bc_flags &= ~XFS_BTREE_STAGING;
> +}

Any reason this new code isn't off in a new xfs_staging_btree.c or some
such instead of xfs_btree.c?

> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index 3eff7c321d43..3ada085609a8 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -188,6 +188,16 @@ union xfs_btree_cur_private {
>  	} abt;
>  };
>  
> +/* Private information for a AG-rooted btree. */
> +struct xfs_btree_priv_ag {			/* needed for BNO, CNT, INO */
> +	union {
> +		struct xfs_buf		*agbp;	/* agf/agi buffer pointer */
> +		struct xbtree_afakeroot	*afake;	/* fake ag header root */
> +	};
> +	xfs_agnumber_t			agno;	/* ag number */
> +	union xfs_btree_cur_private	priv;
> +};
> +

Ideally refactoring this would be a separate patch from adding a new
field.

Brian

>  /*
>   * Btree cursor structure.
>   * This collects all information needed by the btree code in one place.
> @@ -209,11 +219,7 @@ typedef struct xfs_btree_cur
>  	xfs_btnum_t	bc_btnum;	/* identifies which btree type */
>  	int		bc_statoff;	/* offset of btre stats array */
>  	union {
> -		struct {			/* needed for BNO, CNT, INO */
> -			struct xfs_buf	*agbp;	/* agf/agi buffer pointer */
> -			xfs_agnumber_t	agno;	/* ag number */
> -			union xfs_btree_cur_private	priv;
> -		} a;
> +		struct xfs_btree_priv_ag a;
>  		struct {			/* needed for BMAP */
>  			struct xfs_inode *ip;	/* pointer to our inode */
>  			int		allocated;	/* count of alloced */
> @@ -232,6 +238,12 @@ typedef struct xfs_btree_cur
>  #define XFS_BTREE_LASTREC_UPDATE	(1<<2)	/* track last rec externally */
>  #define XFS_BTREE_CRC_BLOCKS		(1<<3)	/* uses extended btree blocks */
>  #define XFS_BTREE_OVERLAPPING		(1<<4)	/* overlapping intervals */
> +/*
> + * The root of this btree is a fakeroot structure so that we can stage a btree
> + * rebuild without leaving it accessible via primary metadata.  The ops struct
> + * is dynamically allocated and must be freed when the cursor is deleted.
> + */
> +#define XFS_BTREE_STAGING		(1<<5)
>  
>  
>  #define	XFS_BTREE_NOERROR	0
> @@ -512,4 +524,24 @@ xfs_btree_islastblock(
>  	return block->bb_u.s.bb_rightsib == cpu_to_be32(NULLAGBLOCK);
>  }
>  
> +/* Fake root for an AG-rooted btree. */
> +struct xbtree_afakeroot {
> +	/* AG block number of the new btree root. */
> +	xfs_agblock_t		af_root;
> +
> +	/* Height of the new btree. */
> +	unsigned int		af_levels;
> +
> +	/* Number of blocks used by the btree. */
> +	unsigned int		af_blocks;
> +};
> +
> +/* Cursor interactions with with fake roots for AG-rooted btrees. */
> +void xfs_btree_stage_afakeroot(struct xfs_btree_cur *cur,
> +		struct xbtree_afakeroot *afake,
> +		struct xfs_btree_ops **new_ops);
> +void xfs_btree_commit_afakeroot(struct xfs_btree_cur *cur,
> +		struct xfs_buf *agbp,
> +		const struct xfs_btree_ops *ops);
> +
>  #endif	/* __XFS_BTREE_H__ */
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index e242988f57fb..57ff9f583b5f 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -3594,6 +3594,34 @@ TRACE_EVENT(xfs_check_new_dalign,
>  		  __entry->calc_rootino)
>  )
>  
> +TRACE_EVENT(xfs_btree_commit_afakeroot,
> +	TP_PROTO(struct xfs_btree_cur *cur),
> +	TP_ARGS(cur),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(xfs_btnum_t, btnum)
> +		__field(xfs_agnumber_t, agno)
> +		__field(xfs_agblock_t, agbno)
> +		__field(unsigned int, levels)
> +		__field(unsigned int, blocks)
> +	),
> +	TP_fast_assign(
> +		__entry->dev = cur->bc_mp->m_super->s_dev;
> +		__entry->btnum = cur->bc_btnum;
> +		__entry->agno = cur->bc_private.a.agno;
> +		__entry->agbno = cur->bc_private.a.afake->af_root;
> +		__entry->levels = cur->bc_private.a.afake->af_levels;
> +		__entry->blocks = cur->bc_private.a.afake->af_blocks;
> +	),
> +	TP_printk("dev %d:%d btree %s ag %u levels %u blocks %u root %u",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
> +		  __entry->agno,
> +		  __entry->levels,
> +		  __entry->blocks,
> +		  __entry->agbno)
> +)
> +
>  #endif /* _TRACE_XFS_H */
>  
>  #undef TRACE_INCLUDE_PATH
> 

