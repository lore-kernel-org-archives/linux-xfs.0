Return-Path: <SRS0=BjFQ=46=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2346C4CECE
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Mar 2020 14:47:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8ECFF206FA
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Mar 2020 14:47:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ui9G3tPB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbgCMOrY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Mar 2020 10:47:24 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:34194 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726866AbgCMOrS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Mar 2020 10:47:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584110837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Yplta0JM6NXgDWsRcUDeFLldnRHzRhQcBot5AqQBLVg=;
        b=Ui9G3tPB93WQY/egSlWdsPLXiVDDHWOST64AjX7ENDICfe3tihWY1XAd99mcU8x+MctLUY
        QQaxnDEP1c7KI7/1fcZM1/sDub2zjK1/BtGBbaR81KP3iu5yIF4ChLYR+AH0h0EpbmBQKu
        OyYoottx9rPxzORhQck86IKId5+8quw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-256-5qHkPNeiPg2aEivCMIofRQ-1; Fri, 13 Mar 2020 10:47:15 -0400
X-MC-Unique: 5qHkPNeiPg2aEivCMIofRQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 59A718C7177;
        Fri, 13 Mar 2020 14:47:14 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F156D5DF2B;
        Fri, 13 Mar 2020 14:47:13 +0000 (UTC)
Date:   Fri, 13 Mar 2020 10:47:12 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: introduce fake roots for ag-rooted btrees
Message-ID: <20200313144712.GA11929@bfoster>
References: <158398473036.1308059.18353233923283406961.stgit@magnolia>
 <158398473702.1308059.5932849079464881055.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158398473702.1308059.5932849079464881055.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 11, 2020 at 08:45:37PM -0700, Darrick J. Wong wrote:
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
>  fs/xfs/libxfs/xfs_btree.c |  168 +++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_btree.h |   30 ++++++++
>  fs/xfs/xfs_trace.h        |   28 ++++++++
>  3 files changed, 225 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 4ef9f0b42c7f..085bc070e804 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
...
> @@ -4908,3 +4910,169 @@ xfs_btree_has_more_records(
>  	else
>  		return block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK);
>  }
> +
...
> +/*
> + * Initialize a AG-rooted btree cursor with the given AG btree fake root.  The
> + * btree cursor's bc_ops will be overridden as needed to make the staging
> + * functionality work.  If new_ops is not NULL, these new ops will be passed
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
> +	ASSERT(cur->bc_tp == NULL);
> +
> +	nops = kmem_alloc(sizeof(struct xfs_btree_ops), KM_NOFS);
> +	memcpy(nops, cur->bc_ops, sizeof(struct xfs_btree_ops));
> +	nops->alloc_block = xfs_btree_fakeroot_alloc_block;
> +	nops->free_block = xfs_btree_fakeroot_free_block;
> +	nops->init_ptr_from_cur = xfs_btree_fakeroot_init_ptr_from_cur;
> +	nops->set_root = xfs_btree_afakeroot_set_root;
> +	nops->dup_cursor = xfs_btree_fakeroot_dup_cursor;
> +
> +	cur->bc_ag.afake = afake;
> +	cur->bc_nlevels = afake->af_levels;
> +	cur->bc_ops = nops;
> +	cur->bc_flags |= XFS_BTREE_STAGING;
> +
> +	if (new_ops)
> +		*new_ops = nops;

Curious why we have new_ops if the caller unconditionally assigns
->bc_ops to the same value..? That aside:

Reviewed-by: Brian Foster <bfoster@redhat.com> 

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
> +	struct xfs_trans		*tp,
> +	struct xfs_buf			*agbp,
> +	const struct xfs_btree_ops	*ops)
> +{
> +	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
> +	ASSERT(cur->bc_tp == NULL);
> +
> +	trace_xfs_btree_commit_afakeroot(cur);
> +
> +	kmem_free((void *)cur->bc_ops);
> +	cur->bc_ag.agbp = agbp;
> +	cur->bc_ops = ops;
> +	cur->bc_flags &= ~XFS_BTREE_STAGING;
> +	cur->bc_tp = tp;
> +}
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index 0d10bbd5223a..aa4a7bd40023 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -179,7 +179,10 @@ union xfs_btree_irec {
>  
>  /* Per-AG btree information. */
>  struct xfs_btree_cur_ag {
> -	struct xfs_buf		*agbp;
> +	union {
> +		struct xfs_buf		*agbp;
> +		struct xbtree_afakeroot	*afake;	/* fake ag header root */
> +	};
>  	xfs_agnumber_t		agno;
>  	union {
>  		struct {
> @@ -235,6 +238,12 @@ typedef struct xfs_btree_cur
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
> @@ -515,4 +524,23 @@ xfs_btree_islastblock(
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
> +void xfs_btree_commit_afakeroot(struct xfs_btree_cur *cur, struct xfs_trans *tp,
> +		struct xfs_buf *agbp, const struct xfs_btree_ops *ops);
> +
>  #endif	/* __XFS_BTREE_H__ */
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 059c3098a4a0..d8c229492973 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -3605,6 +3605,34 @@ TRACE_EVENT(xfs_check_new_dalign,
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
> +		__entry->agno = cur->bc_ag.agno;
> +		__entry->agbno = cur->bc_ag.afake->af_root;
> +		__entry->levels = cur->bc_ag.afake->af_levels;
> +		__entry->blocks = cur->bc_ag.afake->af_blocks;
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

