Return-Path: <SRS0=DGLX=WX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDACDC41514
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Aug 2019 13:14:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F038206BF
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Aug 2019 13:14:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729602AbfH0NOH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Aug 2019 09:14:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47756 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725920AbfH0NOG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Aug 2019 09:14:06 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9DA3A3084244;
        Tue, 27 Aug 2019 13:14:05 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 482A35D6B0;
        Tue, 27 Aug 2019 13:14:05 +0000 (UTC)
Date:   Tue, 27 Aug 2019 09:14:03 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: bmap scrub should only scrub records once
Message-ID: <20190827131403.GG10636@bfoster>
References: <156685612356.2853532.10960947509015722027.stgit@magnolia>
 <156685612978.2853532.15764464511279169366.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156685612978.2853532.15764464511279169366.stgit@magnolia>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Tue, 27 Aug 2019 13:14:05 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 26, 2019 at 02:48:49PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The inode block mapping scrub function does more work for btree format
> extent maps than is absolutely necessary -- first it will walk the bmbt
> and check all the entries, and then it will load the incore tree and
> check every entry in that tree, possibly for a second time.
> 
> Simplify the code and decrease check runtime by separating the two
> responsibilities.  The bmbt walk will make sure the incore extent
> mappings are loaded, check the shape of the bmap btree (via xchk_btree)
> and check that every bmbt record has a corresponding incore extent map;
> and the incore extent map walk takes all the responsibility for checking
> the mapping records and cross referencing them with other AG metadata.
> 
> This enables us to clean up some messy parameter handling and reduce
> redundant code.  Rename a few functions to make the split of
> responsibilities clearer.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/bmap.c |   76 ++++++++++++++++++++++++++++++---------------------
>  1 file changed, 45 insertions(+), 31 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> index 1bd29fdc2ab5..f6ed6eb133a6 100644
> --- a/fs/xfs/scrub/bmap.c
> +++ b/fs/xfs/scrub/bmap.c
...
> @@ -402,9 +396,25 @@ xchk_bmapbt_rec(
>  		}
>  	}
>  
> -	/* Set up the in-core record and scrub it. */
> +	/*
> +	 * Check that the incore extent tree contains an extent that matches
> +	 * this one exactly.  We validate those cached bmaps later, so we don't
> +	 * need to check them here.  If the extent tree was freshly loaded by
> +	 * the scrubber then we skip the check entirely.
> +	 */
> +	if (info->was_loaded)
> +		return 0;
> +

This all looks fine to me except that I don't follow the reasoning for
skipping the lookup from the comment. Are we just saying that if we
loaded the extent tree, then we can assume it reflects what is on disk?
If so, can we fix up the last sentence in the comment to explain?

Brian

>  	xfs_bmbt_disk_get_all(&rec->bmbt, &irec);
> -	return xchk_bmap_extent(ip, bs->cur, info, &irec);
> +	if (!xfs_iext_lookup_extent(ip, ifp, irec.br_startoff, &icur,
> +				&iext_irec) ||
> +	    irec.br_startoff != iext_irec.br_startoff ||
> +	    irec.br_startblock != iext_irec.br_startblock ||
> +	    irec.br_blockcount != iext_irec.br_blockcount ||
> +	    irec.br_state != iext_irec.br_state)
> +		xchk_fblock_set_corrupt(bs->sc, info->whichfork,
> +				irec.br_startoff);
> +	return 0;
>  }
>  
>  /* Scan the btree records. */
> @@ -415,15 +425,26 @@ xchk_bmap_btree(
>  	struct xchk_bmap_info	*info)
>  {
>  	struct xfs_owner_info	oinfo;
> +	struct xfs_ifork	*ifp = XFS_IFORK_PTR(sc->ip, whichfork);
>  	struct xfs_mount	*mp = sc->mp;
>  	struct xfs_inode	*ip = sc->ip;
>  	struct xfs_btree_cur	*cur;
>  	int			error;
>  
> +	/* Load the incore bmap cache if it's not loaded. */
> +	info->was_loaded = ifp->if_flags & XFS_IFEXTENTS;
> +	if (!info->was_loaded) {
> +		error = xfs_iread_extents(sc->tp, ip, whichfork);
> +		if (!xchk_fblock_process_error(sc, whichfork, 0, &error))
> +			goto out;
> +	}
> +
> +	/* Check the btree structure. */
>  	cur = xfs_bmbt_init_cursor(mp, sc->tp, ip, whichfork);
>  	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, whichfork);
>  	error = xchk_btree(sc, cur, xchk_bmapbt_rec, &oinfo, info);
>  	xfs_btree_del_cursor(cur, error);
> +out:
>  	return error;
>  }
>  
> @@ -671,13 +692,6 @@ xchk_bmap(
>  	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
>  		goto out;
>  
> -	/* Now try to scrub the in-memory extent list. */
> -        if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> -		error = xfs_iread_extents(sc->tp, ip, whichfork);
> -		if (!xchk_fblock_process_error(sc, whichfork, 0, &error))
> -			goto out;
> -	}
> -
>  	/* Find the offset of the last extent in the mapping. */
>  	error = xfs_bmap_last_offset(ip, &endoff, whichfork);
>  	if (!xchk_fblock_process_error(sc, whichfork, 0, &error))
> @@ -689,7 +703,7 @@ xchk_bmap(
>  	for_each_xfs_iext(ifp, &icur, &irec) {
>  		if (xchk_should_terminate(sc, &error) ||
>  		    (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
> -			break;
> +			goto out;
>  		if (isnullstartblock(irec.br_startblock))
>  			continue;
>  		if (irec.br_startoff >= endoff) {
> @@ -697,7 +711,7 @@ xchk_bmap(
>  					irec.br_startoff);
>  			goto out;
>  		}
> -		error = xchk_bmap_extent(ip, NULL, &info, &irec);
> +		error = xchk_bmap_iextent(ip, &info, &irec);
>  		if (error)
>  			goto out;
>  	}
> 
