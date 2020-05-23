Return-Path: <SRS0=aNSJ=7F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FE37C433DF
	for <linux-xfs@archiver.kernel.org>; Sat, 23 May 2020 09:34:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAB5220727
	for <linux-xfs@archiver.kernel.org>; Sat, 23 May 2020 09:34:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sIlcA5bm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725270AbgEWJew (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 May 2020 05:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbgEWJew (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 23 May 2020 05:34:52 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE88C061A0E
        for <linux-xfs@vger.kernel.org>; Sat, 23 May 2020 02:34:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=I1s8AX426uN5SI4AjkFSKBJeR2hP3N4SuJjWeHkfhGE=; b=sIlcA5bmgv71Ug2eeNAwZHKHUI
        sLJ/0F+pL1LWYS8y0IaLwZutNsnRaccz6L3GERtlAU5w8Q6sh5jpSxW7WShB4EHoi746AwxQxJyB0
        Lmxe1V1qKXTIPHBBnl8AKnPVEUTw2DAa3tJiyuceuR+pg5fA48gAYCWrqxoDUIkKciittWrNxrb4g
        Gi4eNbsOxq1N0bpIrK11doDr6qXLh9IYWEQ9/C0Vpi0ssvoTVLKFlvJh/BJYb6ZFn2Ab2KpVVeeYo
        pG2Wkces6SDqE68JtqXdhElH7e//xcI9SugOHK9BoeH4O8pfGBU2zsr9H2cChprPMMDBeimYnzn3C
        TfbxR39Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jcQYN-0001tf-SB; Sat, 23 May 2020 09:34:51 +0000
Date:   Sat, 23 May 2020 02:34:51 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/24] xfs: pin inode backing buffer to the inode log item
Message-ID: <20200523093451.GA7083@infradead.org>
References: <20200522035029.3022405-1-david@fromorbit.com>
 <20200522035029.3022405-13-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522035029.3022405-13-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> --- a/fs/xfs/xfs_trans_priv.h
> +++ b/fs/xfs/xfs_trans_priv.h
> @@ -143,15 +143,10 @@ static inline void
>  xfs_clear_li_failed(
>  	struct xfs_log_item	*lip)
>  {
> -	struct xfs_buf	*bp = lip->li_buf;
> -
>  	ASSERT(test_bit(XFS_LI_IN_AIL, &lip->li_flags));
>  	lockdep_assert_held(&lip->li_ailp->ail_lock);
>  
> -	if (test_and_clear_bit(XFS_LI_FAILED, &lip->li_flags)) {
> -		lip->li_buf = NULL;
> -		xfs_buf_rele(bp);
> -	}
> +	clear_bit(XFS_LI_FAILED, &lip->li_flags);
>  }
>  
>  static inline void
> @@ -161,10 +156,7 @@ xfs_set_li_failed(
>  {
>  	lockdep_assert_held(&lip->li_ailp->ail_lock);
>  
> -	if (!test_and_set_bit(XFS_LI_FAILED, &lip->li_flags)) {
> -		xfs_buf_hold(bp);
> -		lip->li_buf = bp;
> -	}
> +	set_bit(XFS_LI_FAILED, &lip->li_flags);
>  }

Isn't this going to break quotas, which don't always have li_buf set?
