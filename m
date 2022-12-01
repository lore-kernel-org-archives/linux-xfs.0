Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8A5EC43217
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Dec 2022 15:34:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231890AbiLAPep (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Dec 2022 10:34:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231978AbiLAPeQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Dec 2022 10:34:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0A4EAA8CB
        for <linux-xfs@vger.kernel.org>; Thu,  1 Dec 2022 07:33:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A2B1B81F6D
        for <linux-xfs@vger.kernel.org>; Thu,  1 Dec 2022 15:33:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED43C433D7;
        Thu,  1 Dec 2022 15:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669908820;
        bh=GkowGkjfsz3u+H7+0d+qnXQS75+XLT0As8fjc21ueyk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C9CpSBMNhMzVnqnwsR+Z9VJpOrV0VX7vP7BEqhU14anIyHfCC1EaTJjvvs4ZhoQVq
         b+rwQ/Hne9D5LWZwclje58WW5lVaRdz7Rb8US3t500U5HHR7T/CWTHmJoSnE5364vY
         vynHsT1EbPfCpFl5BnCa6kskBQVC4NOLEvD9bl6J2xByQnxjBbQOar9k/7p5fvMUxo
         za/mf2MFrWaS+ANSeer0m9kkxtJXAit0jDK7Jrod23yh7KJQ9BCv5i7+OCYu4/Zz+e
         oZk4QaZnLD3OWDF85ugsTUuflBASZkxnQDL6Rna13PZ6P63dvvsH1e3OKOgtdzQGpD
         jvMCi551+Ug7w==
Date:   Thu, 1 Dec 2022 07:33:40 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_repair: Fix rmaps_verify_btree() error path
Message-ID: <Y4jJVFRxhHmgby/0@magnolia>
References: <20221201093408.87820-1-cem@kernel.org>
 <20221201093408.87820-3-cem@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221201093408.87820-3-cem@kernel.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 01, 2022 at 10:34:08AM +0100, cem@kernel.org wrote:
> From: Carlos Maiolino <cmaiolino@redhat.com>
> 
> Add proper exit error paths to avoid checking all pointers at the current path
> 
> Fixes-coverity-id: 1512654
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Looks good to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
> V2:
> 	- Rename error label from err_agf to err_pag
> V3:
> 	- Rename the remaining 2 err labels to match what they are freeing
> 
>  repair/rmap.c | 21 ++++++++++-----------
>  1 file changed, 10 insertions(+), 11 deletions(-)
> 
> diff --git a/repair/rmap.c b/repair/rmap.c
> index 9ec5e9e13..52106fd42 100644
> --- a/repair/rmap.c
> +++ b/repair/rmap.c
> @@ -1004,7 +1004,7 @@ rmaps_verify_btree(
>  	if (error) {
>  		do_warn(_("Could not read AGF %u to check rmap btree.\n"),
>  				agno);
> -		goto err;
> +		goto err_pag;
>  	}
>  
>  	/* Leave the per-ag data "uninitialized" since we rewrite it later */
> @@ -1013,7 +1013,7 @@ rmaps_verify_btree(
>  	bt_cur = libxfs_rmapbt_init_cursor(mp, NULL, agbp, pag);
>  	if (!bt_cur) {
>  		do_warn(_("Not enough memory to check reverse mappings.\n"));
> -		goto err;
> +		goto err_agf;
>  	}
>  
>  	rm_rec = pop_slab_cursor(rm_cur);
> @@ -1023,7 +1023,7 @@ rmaps_verify_btree(
>  			do_warn(
>  _("Could not read reverse-mapping record for (%u/%u).\n"),
>  					agno, rm_rec->rm_startblock);
> -			goto err;
> +			goto err_cur;
>  		}
>  
>  		/*
> @@ -1039,7 +1039,7 @@ _("Could not read reverse-mapping record for (%u/%u).\n"),
>  				do_warn(
>  _("Could not read reverse-mapping record for (%u/%u).\n"),
>  						agno, rm_rec->rm_startblock);
> -				goto err;
> +				goto err_cur;
>  			}
>  		}
>  		if (!have) {
> @@ -1090,13 +1090,12 @@ next_loop:
>  		rm_rec = pop_slab_cursor(rm_cur);
>  	}
>  
> -err:
> -	if (bt_cur)
> -		libxfs_btree_del_cursor(bt_cur, XFS_BTREE_NOERROR);
> -	if (pag)
> -		libxfs_perag_put(pag);
> -	if (agbp)
> -		libxfs_buf_relse(agbp);
> +err_cur:
> +	libxfs_btree_del_cursor(bt_cur, XFS_BTREE_NOERROR);
> +err_agf:
> +	libxfs_buf_relse(agbp);
> +err_pag:
> +	libxfs_perag_put(pag);
>  	free_slab_cursor(&rm_cur);
>  }
>  
> -- 
> 2.30.2
> 
