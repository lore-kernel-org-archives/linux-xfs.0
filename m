Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B59CC10DCE
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 10:42:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 162102072F
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 10:42:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rs774Fc7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbgCLKmV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Mar 2020 06:42:21 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:55027 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725268AbgCLKmV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Mar 2020 06:42:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584009740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eJr+JsaAtZTmMeAdDMHfeLexZrGDrNg+POLP6Y5sG/E=;
        b=Rs774Fc7pc3nPgwpQ2lvCj403lOFKUBh+VCRrQ9XkRKxfqXQfBhgfw4MwK7COCd637LWjD
        cLEnMrqkcnF6SkeKwbOPVVEWVon0zOXAh5p58SJTh+XiiyvWF4nu+QYYL8WGdPGhJ0n7jB
        kyWzXtbcq+FVpOkkiMLhBLRHpf8+Ykk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-479-_eSwOq8zM0GKTmwcZlwhaw-1; Thu, 12 Mar 2020 06:42:19 -0400
X-MC-Unique: _eSwOq8zM0GKTmwcZlwhaw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DA2521005514;
        Thu, 12 Mar 2020 10:42:17 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6F37460BF1;
        Thu, 12 Mar 2020 10:42:17 +0000 (UTC)
Date:   Thu, 12 Mar 2020 06:42:15 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 4/7] xfs: rename btree cursor private btree member flags
Message-ID: <20200312104215.GD60753@bfoster>
References: <158398468107.1307855.8287106235853942996.stgit@magnolia>
 <158398470751.1307855.8464463416155765479.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158398470751.1307855.8464463416155765479.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 11, 2020 at 08:45:07PM -0700, Darrick J. Wong wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> BPRV is not longer appropriate because bc_private is going away.
> Script:
> 
> $ sed -i 's/BTCUR_BPRV/BTCUR_BMBT/g' fs/xfs/*[ch] fs/xfs/*/*[ch]
> 
> With manual cleanup to the definitions in fs/xfs/libxfs/xfs_btree.h
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> [darrick: change "BC_BT" to "BTCUR_BMBT", fix subject line typo]
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_bmap.c       |    8 ++++----
>  fs/xfs/libxfs/xfs_bmap_btree.c |    4 ++--
>  fs/xfs/libxfs/xfs_btree.c      |    2 +-
>  fs/xfs/libxfs/xfs_btree.h      |    4 ++--
>  4 files changed, 9 insertions(+), 9 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index fc8f6d65576c..8057486c02b5 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -690,7 +690,7 @@ xfs_bmap_extents_to_btree(
>  	 * Need a cursor.  Can't allocate until bb_level is filled in.
>  	 */
>  	cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
> -	cur->bc_ino.flags = wasdel ? XFS_BTCUR_BPRV_WASDEL : 0;
> +	cur->bc_ino.flags = wasdel ? XFS_BTCUR_BMBT_WASDEL : 0;
>  	/*
>  	 * Convert to a btree with two levels, one record in root.
>  	 */
> @@ -1528,7 +1528,7 @@ xfs_bmap_add_extent_delay_real(
>  
>  	ASSERT(!isnullstartblock(new->br_startblock));
>  	ASSERT(!bma->cur ||
> -	       (bma->cur->bc_ino.flags & XFS_BTCUR_BPRV_WASDEL));
> +	       (bma->cur->bc_ino.flags & XFS_BTCUR_BMBT_WASDEL));
>  
>  	XFS_STATS_INC(mp, xs_add_exlist);
>  
> @@ -2752,7 +2752,7 @@ xfs_bmap_add_extent_hole_real(
>  	struct xfs_bmbt_irec	old;
>  
>  	ASSERT(!isnullstartblock(new->br_startblock));
> -	ASSERT(!cur || !(cur->bc_ino.flags & XFS_BTCUR_BPRV_WASDEL));
> +	ASSERT(!cur || !(cur->bc_ino.flags & XFS_BTCUR_BMBT_WASDEL));
>  
>  	XFS_STATS_INC(mp, xs_add_exlist);
>  
> @@ -4188,7 +4188,7 @@ xfs_bmapi_allocate(
>  
>  	if (bma->cur)
>  		bma->cur->bc_ino.flags =
> -			bma->wasdel ? XFS_BTCUR_BPRV_WASDEL : 0;
> +			bma->wasdel ? XFS_BTCUR_BMBT_WASDEL : 0;
>  
>  	bma->got.br_startoff = bma->offset;
>  	bma->got.br_startblock = bma->blkno;
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> index 71b60f2a9979..295a59cf8840 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> @@ -230,7 +230,7 @@ xfs_bmbt_alloc_block(
>  	}
>  
>  	args.minlen = args.maxlen = args.prod = 1;
> -	args.wasdel = cur->bc_ino.flags & XFS_BTCUR_BPRV_WASDEL;
> +	args.wasdel = cur->bc_ino.flags & XFS_BTCUR_BMBT_WASDEL;
>  	if (!args.wasdel && args.tp->t_blk_res == 0) {
>  		error = -ENOSPC;
>  		goto error0;
> @@ -644,7 +644,7 @@ xfs_bmbt_change_owner(
>  	cur = xfs_bmbt_init_cursor(ip->i_mount, tp, ip, whichfork);
>  	if (!cur)
>  		return -ENOMEM;
> -	cur->bc_ino.flags |= XFS_BTCUR_BPRV_INVALID_OWNER;
> +	cur->bc_ino.flags |= XFS_BTCUR_BMBT_INVALID_OWNER;
>  
>  	error = xfs_btree_change_owner(cur, new_owner, buffer_list);
>  	xfs_btree_del_cursor(cur, error);
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 8c6e128c8ae8..4ef9f0b42c7f 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -1743,7 +1743,7 @@ xfs_btree_lookup_get_block(
>  
>  	/* Check the inode owner since the verifiers don't. */
>  	if (xfs_sb_version_hascrc(&cur->bc_mp->m_sb) &&
> -	    !(cur->bc_ino.flags & XFS_BTCUR_BPRV_INVALID_OWNER) &&
> +	    !(cur->bc_ino.flags & XFS_BTCUR_BMBT_INVALID_OWNER) &&
>  	    (cur->bc_flags & XFS_BTREE_LONG_PTRS) &&
>  	    be64_to_cpu((*blkp)->bb_u.l.bb_owner) !=
>  			cur->bc_ino.ip->i_ino)
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index 4a1c98bdfaad..00a58ac8b696 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -220,8 +220,8 @@ typedef struct xfs_btree_cur
>  			short		forksize;	/* fork's inode space */
>  			char		whichfork;	/* data or attr fork */
>  			char		flags;		/* flags */
> -#define	XFS_BTCUR_BPRV_WASDEL		(1<<0)		/* was delayed */
> -#define	XFS_BTCUR_BPRV_INVALID_OWNER	(1<<1)		/* for ext swap */
> +#define	XFS_BTCUR_BMBT_WASDEL	(1 << 0)		/* was delayed */
> +#define	XFS_BTCUR_BMBT_INVALID_OWNER	(1 << 1)		/* for ext swap */
>  		} b;
>  	}		bc_private;	/* per-btree type data */
>  #define bc_ag	bc_private.a
> 

