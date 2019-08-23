Return-Path: <SRS0=lWMA=WT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D10BC3A5A2
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Aug 2019 15:02:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4984820870
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Aug 2019 15:02:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbfHWPCY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Aug 2019 11:02:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4184 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725934AbfHWPCY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 23 Aug 2019 11:02:24 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F316730833BE;
        Fri, 23 Aug 2019 15:02:23 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9A5CC1902F;
        Fri, 23 Aug 2019 15:02:23 +0000 (UTC)
Date:   Fri, 23 Aug 2019 11:02:21 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: bmap scrub should only scrub records once
Message-ID: <20190823150221.GB54025@bfoster>
References: <20190817020651.GH752159@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190817020651.GH752159@magnolia>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Fri, 23 Aug 2019 15:02:24 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 16, 2019 at 07:06:51PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The inode block mapping scrub function does more work for btree format
> extent maps than is absolutely necessary -- first it will walk the bmbt
> and check all the entries, and then it will load the incore tree and
> check every entry in that tree.
> 
> Reduce the run time of the ondisk bmbt walk if the incore tree is loaded
> by checking that the incore tree has an exact match for the bmbt extent.
> Similarly, skip the incore tree walk if we have to load it from the
> bmbt, since we just checked that.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/bmap.c |   40 +++++++++++++++++++++++++++++++++++++---
>  1 file changed, 37 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> index 1bd29fdc2ab5..6170736fa94f 100644
> --- a/fs/xfs/scrub/bmap.c
> +++ b/fs/xfs/scrub/bmap.c
> @@ -384,6 +384,7 @@ xchk_bmapbt_rec(
>  	struct xfs_inode	*ip = bs->cur->bc_private.b.ip;
>  	struct xfs_buf		*bp = NULL;
>  	struct xfs_btree_block	*block;
> +	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, info->whichfork);
>  	uint64_t		owner;
>  	int			i;
>  
> @@ -402,8 +403,30 @@ xchk_bmapbt_rec(
>  		}
>  	}
>  
> -	/* Set up the in-core record and scrub it. */
> +	/*
> +	 * If the incore bmap cache is already loaded, check that it contains
> +	 * an extent that matches this one exactly.  We validate those cached
> +	 * bmaps later, so we don't need to check here.
> +	 *
> +	 * If the cache is /not/ loaded, we need to validate the bmbt records
> +	 * now.
> +	 */
>  	xfs_bmbt_disk_get_all(&rec->bmbt, &irec);
> +        if (ifp->if_flags & XFS_IFEXTENTS) {

^ looks like whitespace damage right here.

> +		struct xfs_bmbt_irec	iext_irec;
> +		struct xfs_iext_cursor	icur;
> +
> +		if (!xfs_iext_lookup_extent(ip, ifp, irec.br_startoff, &icur,
> +					&iext_irec) ||
> +		    irec.br_startoff != iext_irec.br_startoff ||
> +		    irec.br_startblock != iext_irec.br_startblock ||
> +		    irec.br_blockcount != iext_irec.br_blockcount ||
> +		    irec.br_state != iext_irec.br_state)
> +			xchk_fblock_set_corrupt(bs->sc, info->whichfork,
> +					irec.br_startoff);
> +		return 0;
> +	}
> +

Ok, so right now the bmbt walk makes no consideration of in-core state.
With this change, we correlate every on-disk record with an in-core
counterpart (if cached) and skip the additional extent checks...

>  	return xchk_bmap_extent(ip, bs->cur, info, &irec);
>  }
>  
> @@ -671,11 +694,22 @@ xchk_bmap(
>  	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
>  		goto out;
>  
> -	/* Now try to scrub the in-memory extent list. */
> +	/*
> +	 * If the incore bmap cache isn't loaded, then this inode has a bmap
> +	 * btree and we already walked it to check all of the mappings.  Load
> +	 * the cache now and skip ahead to rmap checking (which requires the
> +	 * bmap cache to be loaded).  We don't need to check twice.
> +	 *
> +	 * If the cache /is/ loaded, then we haven't checked any mappings, so
> +	 * iterate the incore cache and check the mappings now, because the
> +	 * bmbt iteration code skipped the checks, assuming that we'd do them
> +	 * here.
> +	 */
>          if (!(ifp->if_flags & XFS_IFEXTENTS)) {
>  		error = xfs_iread_extents(sc->tp, ip, whichfork);
>  		if (!xchk_fblock_process_error(sc, whichfork, 0, &error))
>  			goto out;
> +		goto out_check_rmap;

... because we end up doing that here. Otherwise, the bmbt walk did the
extent checks, so we can skip it here.

I think I follow, but I'm a little confused by the need for such split
logic when we follow up with an unconditional read of the extent tree
anyways. Maybe I'm missing something, but couldn't we just read the
extent tree a little earlier and always do the extent checks in one
place?

Brian

>  	}
>  
>  	/* Find the offset of the last extent in the mapping. */
> @@ -689,7 +723,7 @@ xchk_bmap(
>  	for_each_xfs_iext(ifp, &icur, &irec) {
>  		if (xchk_should_terminate(sc, &error) ||
>  		    (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
> -			break;
> +			goto out;
>  		if (isnullstartblock(irec.br_startblock))
>  			continue;
>  		if (irec.br_startoff >= endoff) {
