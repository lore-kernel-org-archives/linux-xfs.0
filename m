Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 798E6C47082
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Jun 2021 10:46:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DD0860FEA
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Jun 2021 10:46:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbhFGKsV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Jun 2021 06:48:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56368 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230322AbhFGKsV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Jun 2021 06:48:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623062789;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DG4tCEAd8ZdElKwOy4nYarTMpnYGcV9N7cDR0MUibw8=;
        b=h2abmbbKekmpvO9W3dd18NQa4ip/8DQQEBkE9CdNLdKLj8xgHcaMQ+qcd0LHe51BXMSppG
        1GKODYUMvMIOcW7jq4Yk8tgRYv4SsYqA6Hnq6XFNZpEUqOiENk1T2iq29d3imKimhT4Qix
        XeJMznQmoun6Hodvu2OWGtfVGLkVFdw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-404-3E_ThEWmMhSkkj1gZlz2qA-1; Mon, 07 Jun 2021 06:46:28 -0400
X-MC-Unique: 3E_ThEWmMhSkkj1gZlz2qA-1
Received: by mail-wr1-f69.google.com with SMTP id u5-20020adf9e050000b029010df603f280so7675724wre.18
        for <linux-xfs@vger.kernel.org>; Mon, 07 Jun 2021 03:46:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=DG4tCEAd8ZdElKwOy4nYarTMpnYGcV9N7cDR0MUibw8=;
        b=rKEHH4qUvxyWbalvc4MeqeVddSDiuKX6yiGUwGehm28y11y3F545Tgon3E4DQOvVr3
         QothoObyEjdYhnOSFI7t5+NuXZDz0625IDcqYk+P24GO0gH8+eElzjkUD2rSS6TV7Zxm
         s+Y38QVXp0WHTspRIQG88xuUidZuzxcMqUMwTv7rzeYzxr18eF/g0WUdnyhJuxd+LP8Z
         5cw3E/ekBJ/ql1KgSzrbLo/BhUQlVH11InZ+FlWSKV+XVgot1skup+eo/d7F1+Tc6/ou
         2GzLUCJcuqhOyU3TzQ2VBvmUNzDJXJ8VmzDuye1U94I19/+TjoXzGSPcjArMSQHpXVGw
         hdCw==
X-Gm-Message-State: AOAM532r3/uawuSNSsdXamUiHJwtVVvNJGKPVrVqw0dbgn7w2ME2hHIf
        2NHi85KMcZf9c7RVQImWsz1amm38VhvRFWXfxVamVfswf11ecpAB+kODRpxr/fKtQ/ixDCimdU+
        ztp7vabWy/15SoOVZBbHv
X-Received: by 2002:a05:600c:b50:: with SMTP id k16mr16208153wmr.137.1623062786438;
        Mon, 07 Jun 2021 03:46:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwckQPyueSRN8gbRqGVLz1+ykrTaNwWG51y55APGLkLPOSHwbK5DJ14qCzXbVJS7wOZIA7oNg==
X-Received: by 2002:a05:600c:b50:: with SMTP id k16mr16208135wmr.137.1623062786098;
        Mon, 07 Jun 2021 03:46:26 -0700 (PDT)
Received: from omega.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id z10sm14481043wmb.26.2021.06.07.03.46.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 03:46:25 -0700 (PDT)
Date:   Mon, 7 Jun 2021 12:46:23 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: drop the AGI being passed to xfs_check_agi_freecount
Message-ID: <20210607104623.empfngu3y7e74bz3@omega.lan>
Mail-Followup-To: Dave Chinner <david@fromorbit.com>,
        linux-xfs@vger.kernel.org
References: <20210607041529.392451-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210607041529.392451-1-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 07, 2021 at 02:15:29PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Stephen Rothwell reported this compiler warning from linux-next:
> 
> fs/xfs/libxfs/xfs_ialloc.c: In function 'xfs_difree_finobt':
> fs/xfs/libxfs/xfs_ialloc.c:2032:20: warning: unused variable 'agi' [-Wunused-variable]
>  2032 |  struct xfs_agi   *agi = agbp->b_addr;
> 
> Which is fallout from agno -> perag conversions that were done in
> this function. xfs_check_agi_freecount() is the only user of "agi"
> in xfs_difree_finobt() now, and it only uses the agi to get the
> current free inode count. We hold that in the perag structure, so
> there's not need to directly reference the raw AGI to get this
> information.
> 
> The btree cursor being passed to xfs_check_agi_freecount() has a
> reference to the perag being operated on, so use that directly in
> xfs_check_agi_freecount() rather than passing an AGI.
> 
> Fixes: 7b13c5155182 ("xfs: use perag for ialloc btree cursors")
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good:
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_ialloc.c | 28 +++++++++++++---------------
>  1 file changed, 13 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 2ed6de6faf8a..654a8d9681e1 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -214,10 +214,9 @@ xfs_inobt_insert(
>   * Verify that the number of free inodes in the AGI is correct.
>   */
>  #ifdef DEBUG
> -STATIC int
> +static int
>  xfs_check_agi_freecount(
> -	struct xfs_btree_cur	*cur,
> -	struct xfs_agi		*agi)
> +	struct xfs_btree_cur	*cur)
>  {
>  	if (cur->bc_nlevels == 1) {
>  		xfs_inobt_rec_incore_t rec;
> @@ -243,12 +242,12 @@ xfs_check_agi_freecount(
>  		} while (i == 1);
>  
>  		if (!XFS_FORCED_SHUTDOWN(cur->bc_mp))
> -			ASSERT(freecount == be32_to_cpu(agi->agi_freecount));
> +			ASSERT(freecount == cur->bc_ag.pag->pagi_freecount);
>  	}
>  	return 0;
>  }
>  #else
> -#define xfs_check_agi_freecount(cur, agi)	0
> +#define xfs_check_agi_freecount(cur)	0
>  #endif
>  
>  /*
> @@ -1014,7 +1013,7 @@ xfs_dialloc_ag_inobt(
>  	if (!pagino)
>  		pagino = be32_to_cpu(agi->agi_newino);
>  
> -	error = xfs_check_agi_freecount(cur, agi);
> +	error = xfs_check_agi_freecount(cur);
>  	if (error)
>  		goto error0;
>  
> @@ -1234,7 +1233,7 @@ xfs_dialloc_ag_inobt(
>  	xfs_ialloc_log_agi(tp, agbp, XFS_AGI_FREECOUNT);
>  	pag->pagi_freecount--;
>  
> -	error = xfs_check_agi_freecount(cur, agi);
> +	error = xfs_check_agi_freecount(cur);
>  	if (error)
>  		goto error0;
>  
> @@ -1461,7 +1460,7 @@ xfs_dialloc_ag(
>  
>  	cur = xfs_inobt_init_cursor(mp, tp, agbp, pag, XFS_BTNUM_FINO);
>  
> -	error = xfs_check_agi_freecount(cur, agi);
> +	error = xfs_check_agi_freecount(cur);
>  	if (error)
>  		goto error_cur;
>  
> @@ -1504,7 +1503,7 @@ xfs_dialloc_ag(
>  	 */
>  	icur = xfs_inobt_init_cursor(mp, tp, agbp, pag, XFS_BTNUM_INO);
>  
> -	error = xfs_check_agi_freecount(icur, agi);
> +	error = xfs_check_agi_freecount(icur);
>  	if (error)
>  		goto error_icur;
>  
> @@ -1522,10 +1521,10 @@ xfs_dialloc_ag(
>  
>  	xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, -1);
>  
> -	error = xfs_check_agi_freecount(icur, agi);
> +	error = xfs_check_agi_freecount(icur);
>  	if (error)
>  		goto error_icur;
> -	error = xfs_check_agi_freecount(cur, agi);
> +	error = xfs_check_agi_freecount(cur);
>  	if (error)
>  		goto error_icur;
>  
> @@ -1911,7 +1910,7 @@ xfs_difree_inobt(
>  	 */
>  	cur = xfs_inobt_init_cursor(mp, tp, agbp, pag, XFS_BTNUM_INO);
>  
> -	error = xfs_check_agi_freecount(cur, agi);
> +	error = xfs_check_agi_freecount(cur);
>  	if (error)
>  		goto error0;
>  
> @@ -2004,7 +2003,7 @@ xfs_difree_inobt(
>  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, 1);
>  	}
>  
> -	error = xfs_check_agi_freecount(cur, agi);
> +	error = xfs_check_agi_freecount(cur);
>  	if (error)
>  		goto error0;
>  
> @@ -2029,7 +2028,6 @@ xfs_difree_finobt(
>  	xfs_agino_t			agino,
>  	struct xfs_inobt_rec_incore	*ibtrec) /* inobt record */
>  {
> -	struct xfs_agi			*agi = agbp->b_addr;
>  	struct xfs_btree_cur		*cur;
>  	struct xfs_inobt_rec_incore	rec;
>  	int				offset = agino - ibtrec->ir_startino;
> @@ -2114,7 +2112,7 @@ xfs_difree_finobt(
>  	}
>  
>  out:
> -	error = xfs_check_agi_freecount(cur, agi);
> +	error = xfs_check_agi_freecount(cur);
>  	if (error)
>  		goto error;
>  
> -- 
> 2.31.1
> 

-- 
Carlos

