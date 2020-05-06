Return-Path: <SRS0=Htpe=6U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC2BDC28CBC
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 15:18:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 904EC20836
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 15:18:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ftyhPVP3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729289AbgEFPSN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 11:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729003AbgEFPSM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 11:18:12 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5DE6C061A0F
        for <linux-xfs@vger.kernel.org>; Wed,  6 May 2020 08:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=GHynaRpGoBzBqzH60qhiTe91YoCiOBqbw05Iaw3bTmU=; b=ftyhPVP3VRlWnNxplFs0Cw1CLZ
        tgM9CLugCgupbqRs9S7gsuc5lvjCTbMPwJCq2BnKMCaGq4CLwa2QfbKyLsBY7LOKGt1sMN7KrUfeQ
        HTt9S2V6ab8CT0wR37XOSIpqg5bQ+YMYMEzao9pq4G3IRYet9aH9NqnH4HGAAAfTC3hNXrD92d54H
        kllJ93JPfmWE3zHiUpJAzoNbiP/JiHAtS5The7EOAG0EDP4Ur0wEu44M/Iz6hhrR75c5r3wRic6OB
        OgP7wdvVRIKUvkUxoso09PtPOqzXrp/vOtBSbdjmVjk1qEed6G3zojX2ky8KOK2lreiezHtaXu/Zk
        WMjIHI0w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWLoK-0006yZ-HX; Wed, 06 May 2020 15:18:12 +0000
Date:   Wed, 6 May 2020 08:18:12 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/28] xfs: refactor recovered EFI log item playback
Message-ID: <20200506151812.GR7864@infradead.org>
References: <158864103195.182683.2056162574447133617.stgit@magnolia>
 <158864112169.182683.14030031632354525711.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158864112169.182683.14030031632354525711.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +static const struct xfs_item_ops xfs_efi_item_ops = {
> +	.iop_size	= xfs_efi_item_size,
> +	.iop_format	= xfs_efi_item_format,
> +	.iop_unpin	= xfs_efi_item_unpin,
> +	.iop_release	= xfs_efi_item_release,
> +	.iop_recover	= xfs_efi_item_recover,
> +};
> +
> +

I guess we can drop the second empty line here.

>  		switch (lip->li_type) {
>  		case XFS_LI_EFI:
> -			error = xlog_recover_process_efi(log->l_mp, ailp, lip);
> +			error = lip->li_ops->iop_recover(lip, parent_tp);
>  			break;
>  		case XFS_LI_RUI:
>  			error = xlog_recover_process_rui(log->l_mp, ailp, lip);
> @@ -2893,7 +2853,9 @@ xlog_recover_cancel_intents(
>  
>  		switch (lip->li_type) {
>  		case XFS_LI_EFI:
> -			xlog_recover_cancel_efi(log->l_mp, ailp, lip);
> +			spin_unlock(&ailp->ail_lock);
> +			lip->li_ops->iop_release(lip);
> +			spin_lock(&ailp->ail_lock);

This looks a little weird, as I'd expect the default statement
to handle the "generic" case.  But then again this is all transitional,
so except for minor nitpick above:

Reviewed-by: Christoph Hellwig <hch@lst.de>
