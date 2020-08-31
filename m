Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E520BC433E2
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 19:06:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C048C2064B
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 19:06:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C4MMSdAs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728444AbgHaTGs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 15:06:48 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:45592 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727993AbgHaTGr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 15:06:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598900805;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HsXfji+Yr8+v4bTdSEXeQPGAsb/qX9QeNoWU77362oo=;
        b=C4MMSdAs2WnsBOR9KEslS+MaNRqcipMtedC+9l6LjsdlYLlmUPkIheasbVzHsS68SzR5xH
        Q4tsWpEfu2GJuXkLIMERVtsTEDCp0sd2ZWdx4gTWyBa75GPbNCvZ/KHnte2aEBs86Zotec
        Y4E2m7vd9mb1qIjrBzuTRBctPlQqFcs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-QdBJJIrVOui8O1b69mcX-g-1; Mon, 31 Aug 2020 15:06:41 -0400
X-MC-Unique: QdBJJIrVOui8O1b69mcX-g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2260E1888A16;
        Mon, 31 Aug 2020 19:06:40 +0000 (UTC)
Received: from bfoster (ovpn-113-130.rdu2.redhat.com [10.10.113.130])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B58FC5C1BB;
        Mon, 31 Aug 2020 19:06:39 +0000 (UTC)
Date:   Mon, 31 Aug 2020 15:06:37 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: store inode btree block counts in AGI header
Message-ID: <20200831190637.GC12035@bfoster>
References: <159858219107.3058056.6897728273666872031.stgit@magnolia>
 <159858219730.3058056.14835592680951054838.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159858219730.3058056.14835592680951054838.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 27, 2020 at 07:36:37PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a btree block usage counters for both inode btrees to the AGI header
> so that we don't have to walk the entire finobt at mount time to create
> the per-AG reservations.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_ag.c           |    4 ++++
>  fs/xfs/libxfs/xfs_format.h       |   18 +++++++++++++++++-
>  fs/xfs/libxfs/xfs_ialloc.c       |    1 +
>  fs/xfs/libxfs/xfs_ialloc_btree.c |   21 +++++++++++++++++++++
>  fs/xfs/xfs_ondisk.h              |    2 +-
>  fs/xfs/xfs_super.c               |    4 ++++
>  6 files changed, 48 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index 8cf73fe4338e..65d443c787d0 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -333,6 +333,10 @@ xfs_agiblock_init(
>  	}
>  	for (bucket = 0; bucket < XFS_AGI_UNLINKED_BUCKETS; bucket++)
>  		agi->agi_unlinked[bucket] = cpu_to_be32(NULLAGINO);
> +	if (xfs_sb_version_hasinobtcounts(&mp->m_sb)) {
> +		agi->agi_iblocks = cpu_to_be32(1);
> +		agi->agi_fblocks = cpu_to_be32(1);
> +	}

With independent tree counters, shouldn't we be checking for hasfinobt()
for such finobt changes?

>  }
>  
>  typedef void (*aghdr_init_work_f)(struct xfs_mount *mp, struct xfs_buf *bp,
...
> diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> index 3c8aebc36e64..ee9d407ab9da 100644
> --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> @@ -67,6 +67,25 @@ xfs_finobt_set_root(
>  			   XFS_AGI_FREE_ROOT | XFS_AGI_FREE_LEVEL);
>  }
>  
> +/* Update the inode btree block counter for this btree. */
> +static inline void
> +xfs_inobt_mod_blockcount(
> +	struct xfs_btree_cur	*cur,
> +	int			howmuch)
> +{
> +	struct xfs_buf		*agbp = cur->bc_ag.agbp;
> +	struct xfs_agi		*agi = agbp->b_addr;
> +
> +	if (!xfs_sb_version_hasinobtcounts(&cur->bc_mp->m_sb))
> +		return;
> +
> +	if (cur->bc_btnum == XFS_BTNUM_FINO)
> +		be32_add_cpu(&agi->agi_fblocks, howmuch);
> +	else
> +		be32_add_cpu(&agi->agi_iblocks, howmuch);
> +	xfs_ialloc_log_agi(cur->bc_tp, agbp, XFS_AGI_IBLOCKS);

Similarly, I thought we were going to be logging them separately as
well..? It seems odd to log an unused field in the finobt=0 case. Hm?

Brian

> +}
> +
>  STATIC int
>  __xfs_inobt_alloc_block(
>  	struct xfs_btree_cur	*cur,
> @@ -102,6 +121,7 @@ __xfs_inobt_alloc_block(
>  
>  	new->s = cpu_to_be32(XFS_FSB_TO_AGBNO(args.mp, args.fsbno));
>  	*stat = 1;
> +	xfs_inobt_mod_blockcount(cur, 1);
>  	return 0;
>  }
>  
> @@ -134,6 +154,7 @@ __xfs_inobt_free_block(
>  	struct xfs_buf		*bp,
>  	enum xfs_ag_resv_type	resv)
>  {
> +	xfs_inobt_mod_blockcount(cur, -1);
>  	return xfs_free_extent(cur->bc_tp,
>  			XFS_DADDR_TO_FSB(cur->bc_mp, XFS_BUF_ADDR(bp)), 1,
>  			&XFS_RMAP_OINFO_INOBT, resv);
> diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> index 5f04d8a5ab2a..acb9b737fe6b 100644
> --- a/fs/xfs/xfs_ondisk.h
> +++ b/fs/xfs/xfs_ondisk.h
> @@ -23,7 +23,7 @@ xfs_check_ondisk_structs(void)
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_acl_entry,		12);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_agf,			224);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_agfl,			36);
> -	XFS_CHECK_STRUCT_SIZE(struct xfs_agi,			336);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_agi,			344);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_bmbt_key,		8);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_bmbt_rec,		16);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_bmdr_block,		4);
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 71ac6c1cdc36..c7ffcb57b586 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1549,6 +1549,10 @@ xfs_fc_fill_super(
>  		goto out_filestream_unmount;
>  	}
>  
> +	if (xfs_sb_version_hasinobtcounts(&mp->m_sb))
> +		xfs_warn(mp,
> + "EXPERIMENTAL inode btree counters feature in use. Use at your own risk!");
> +
>  	error = xfs_mountfs(mp);
>  	if (error)
>  		goto out_filestream_unmount;
> 

