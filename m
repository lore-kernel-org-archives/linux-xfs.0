Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5695CC6FA82
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Sep 2022 20:48:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbiIBUsZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Sep 2022 16:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiIBUsX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Sep 2022 16:48:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B3BFDAB8A
        for <linux-xfs@vger.kernel.org>; Fri,  2 Sep 2022 13:48:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 366856142A
        for <linux-xfs@vger.kernel.org>; Fri,  2 Sep 2022 20:48:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 907D8C433D6;
        Fri,  2 Sep 2022 20:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662151701;
        bh=unvAbw32sNAy1x0f5haUeav4CxclY469Vy/e9WOxYsU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=twJVGLf1FvRfsSQsv6wWZCpNNUWgDuquBkWPsQLKULwEXeOU7HQWsK/yjcgtTBcDJ
         SyV9WsdObKsUhOO4zj9HKMKrc6AtJMxpNEGFCZEzemBoVHbZ63HOnMV/uOR0YiuxCP
         HaAv8b+WLWtfFRjprJy/u3IEeA4UgND+rgi7/PXQrofK7Y/p65g76eDQSDeMp0+Cc1
         Po3brelisYHzEIhq+LImNxXer5enJf33j57vplNbrRzC7jkOuFucBNN9XqLyNNaTQO
         Em60FoscGYSDTEfuESrc1VMJb0kVnoKbO6afAChNhQgJBBohPWFaghmeOEN0Iw3z+9
         VBvs+fEUMibNQ==
Date:   Fri, 2 Sep 2022 13:48:21 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Carlos Maiolino <cem@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs_repair: Fix check_refcount() error path
Message-ID: <YxJsFQb+MdmeRmak@magnolia>
References: <166212614879.31305.11337231919093625864.stgit@andromeda>
 <166212621918.31305.17388002689404843538.stgit@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166212621918.31305.17388002689404843538.stgit@andromeda>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 02, 2022 at 03:43:39PM +0200, Carlos Maiolino wrote:
> From: Carlos Maiolino <cmaiolino@redhat.com>
> 
> Add proper exit error paths to avoid checking all pointers at the current path
> 
> Fixes-coverity-id: 1512651
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  repair/rmap.c |   23 +++++++++++------------
>  1 file changed, 11 insertions(+), 12 deletions(-)
> 
> diff --git a/repair/rmap.c b/repair/rmap.c
> index a7c4b25b1..0253c0c36 100644
> --- a/repair/rmap.c
> +++ b/repair/rmap.c
> @@ -1377,7 +1377,7 @@ check_refcounts(
>  	if (error) {
>  		do_warn(_("Could not read AGF %u to check refcount btree.\n"),
>  				agno);
> -		goto err;
> +		goto err_agf;

Shouldn't this       ^^^^^^^ be err_pag, since we're erroring out and
releasing the perag group reference?

Also ... don't the "if (XXX) free(XXX)" bits take care of all this?

(I can't access Coverity any more, so I don't know what's in the
report.)

--D

>  	}
>  
>  	/* Leave the per-ag data "uninitialized" since we rewrite it later */
> @@ -1386,7 +1386,7 @@ check_refcounts(
>  	bt_cur = libxfs_refcountbt_init_cursor(mp, NULL, agbp, pag);
>  	if (!bt_cur) {
>  		do_warn(_("Not enough memory to check refcount data.\n"));
> -		goto err;
> +		goto err_bt_cur;
>  	}
>  
>  	rl_rec = pop_slab_cursor(rl_cur);
> @@ -1398,7 +1398,7 @@ check_refcounts(
>  			do_warn(
>  _("Could not read reference count record for (%u/%u).\n"),
>  					agno, rl_rec->rc_startblock);
> -			goto err;
> +			goto err_loop;
>  		}
>  		if (!have) {
>  			do_warn(
> @@ -1413,7 +1413,7 @@ _("Missing reference count record for (%u/%u) len %u count %u\n"),
>  			do_warn(
>  _("Could not read reference count record for (%u/%u).\n"),
>  					agno, rl_rec->rc_startblock);
> -			goto err;
> +			goto err_loop;
>  		}
>  		if (!i) {
>  			do_warn(
> @@ -1436,14 +1436,13 @@ next_loop:
>  		rl_rec = pop_slab_cursor(rl_cur);
>  	}
>  
> -err:
> -	if (bt_cur)
> -		libxfs_btree_del_cursor(bt_cur, error ? XFS_BTREE_ERROR :
> -							XFS_BTREE_NOERROR);
> -	if (pag)
> -		libxfs_perag_put(pag);
> -	if (agbp)
> -		libxfs_buf_relse(agbp);
> +err_loop:
> +	libxfs_btree_del_cursor(bt_cur, error ?
> +				XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
> +err_bt_cur:
> +	libxfs_buf_relse(agbp);
> +err_agf:
> +	libxfs_perag_put(pag);
>  	free_slab_cursor(&rl_cur);
>  }
>  
> 
