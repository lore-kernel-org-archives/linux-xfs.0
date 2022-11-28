Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAFF6C433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Nov 2022 22:09:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232957AbiK1WJp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Nov 2022 17:09:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232370AbiK1WJo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Nov 2022 17:09:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7130813D73
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2022 14:09:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F566B80F79
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2022 22:09:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB187C433D7;
        Mon, 28 Nov 2022 22:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669673381;
        bh=bjKmuTG+pwJpEw1JCLUomwELerw6zwSoELriUd+VWU8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P+bO27FRdueSukNyWLu0BBYwgbDUEmTxozER/cJg15wnDfIFDa1e/3n0+UFLfCrP5
         0f55gW2SWVMsagiPbBm/TfOSz2XN5qia81XsKgxhk32UdJE0Y+jQLme1c2yZhMDgwi
         sUPIYztpvUow8BoZ148eFNa7kmtMdR+0in6KKBkxD/liLmehXPRmdSv+Sj4Gj9D1tI
         FSYLTwvR/jgrVjG+kKC5bq1sL/PbVYjaTPN2N/oyB6q9UCw3lMk8B+JMnyCIFaErWI
         buCq1OEyBCcWiN82s4XZ0qjNVeBofYCI5+/U4yyS7TDPAfbA8M3BmuMQc9kRMW7I7N
         m/20Lh5zVwAuw==
Date:   Mon, 28 Nov 2022 14:09:40 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs_repair: Fix check_refcount() error path
Message-ID: <Y4UxpPgxbmOi/T9/@magnolia>
References: <20221128131434.21496-1-cem@kernel.org>
 <20221128131434.21496-2-cem@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221128131434.21496-2-cem@kernel.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 28, 2022 at 02:14:33PM +0100, cem@kernel.org wrote:
> From: Carlos Maiolino <cmaiolino@redhat.com>
> 
> Add proper exit error paths to avoid checking all pointers at the current path
> 
> Fixes-coverity-id: 1512651
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
> V2:
> 	- Rename error label from err_agf to err_pag
> 	- pass error directly to libxfs_btree_del_cursor() without
> 	  using ternary operator
> 
>  repair/rmap.c | 22 ++++++++++------------
>  1 file changed, 10 insertions(+), 12 deletions(-)
> 
> diff --git a/repair/rmap.c b/repair/rmap.c
> index 2c809fd4f..e76a8f611 100644
> --- a/repair/rmap.c
> +++ b/repair/rmap.c
> @@ -1379,7 +1379,7 @@ check_refcounts(
>  	if (error) {
>  		do_warn(_("Could not read AGF %u to check refcount btree.\n"),
>  				agno);
> -		goto err;
> +		goto err_pag;
>  	}
>  
>  	/* Leave the per-ag data "uninitialized" since we rewrite it later */
> @@ -1388,7 +1388,7 @@ check_refcounts(
>  	bt_cur = libxfs_refcountbt_init_cursor(mp, NULL, agbp, pag);
>  	if (!bt_cur) {
>  		do_warn(_("Not enough memory to check refcount data.\n"));
> -		goto err;
> +		goto err_bt_cur;
>  	}
>  
>  	rl_rec = pop_slab_cursor(rl_cur);
> @@ -1401,7 +1401,7 @@ check_refcounts(
>  			do_warn(
>  _("Could not read reference count record for (%u/%u).\n"),
>  					agno, rl_rec->rc_startblock);
> -			goto err;
> +			goto err_loop;
>  		}
>  		if (!have) {
>  			do_warn(
> @@ -1416,7 +1416,7 @@ _("Missing reference count record for (%u/%u) len %u count %u\n"),
>  			do_warn(
>  _("Could not read reference count record for (%u/%u).\n"),
>  					agno, rl_rec->rc_startblock);
> -			goto err;
> +			goto err_loop;
>  		}
>  		if (!i) {
>  			do_warn(
> @@ -1446,14 +1446,12 @@ next_loop:
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
> +	libxfs_btree_del_cursor(bt_cur, error);
> +err_bt_cur:
> +	libxfs_buf_relse(agbp);
> +err_pag:
> +	libxfs_perag_put(pag);

So I see that you fixed one of the labels so that err_pag jumps to
releasing the perag pointer, but it's still the case that err_bt_cur
frees the AGF buffer, not the btree cursor; and that err_loop actually
frees the btree cursor.

--D

>  	free_slab_cursor(&rl_cur);
>  }
>  
> -- 
> 2.30.2
> 
