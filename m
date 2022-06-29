Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD42AC43334
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 07:04:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232830AbiF2HEE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 03:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232842AbiF2HDs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 03:03:48 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76F583DA51
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 00:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=b5bvM417l54C76O2h7wEsb/ZI4DCIl7x6Uw3hCGogvw=; b=ypGfaDU1JTI3cTuOZSaNzyDK0S
        o13E5wAM8nRbndURbyQZvD9lbAx64XEoPgGmRER0YDR4E94rtH4s5UzMYlt752dty45n3lakGqN5h
        Mgb3GfYgZb8pCTGUH6s1Ro+3fT1ZsVuEkkFneDb/AyxDfwsJOtf/Kn6GLkKrHSYdvxh+s3+6q8wzB
        Zgc/UFcAV5Wfb9PZX2iO/wk50R3aNoPTa97aQaRkOsgL4U8fKhyXpQZooA0RDpMTqw+TLGvTFL57L
        Z+/jy1Yvlgm8/uno1cTM6rwpcURfA+35NS9O5qs7si0f/oz+YbECubQddO9IJm8q9txjw02x7fbjE
        NtrazJ+g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o6Ri6-009yuY-4D; Wed, 29 Jun 2022 07:02:02 +0000
Date:   Wed, 29 Jun 2022 00:02:02 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/14] xfs: Pre-calculate per-AG agino geometry
Message-ID: <Yrv46mVM/IAS9Nop@infradead.org>
References: <20220627001832.215779-1-david@fromorbit.com>
 <20220627001832.215779-13-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627001832.215779-13-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +	     /*
> +		printk("pag blocks %d agblocks %d min_ino %d max_ino %d\n",
> +			bp->b_pag->block_count,
> +			xfs_ag_block_count(mp, bp->b_pag->pag_agno),
> +			bp->b_pag->agino_min, bp->b_pag->agino_max);
> +		*/
> +		printk("sb dblocks %lld fdblocks %lld icount %lld, ifree %lld\n",
> +			sbp->sb_dblocks, sbp->sb_fdblocks, sbp->sb_icount,
> +			sbp->sb_ifree);
>  		xfs_warn(mp, "SB summary counter sanity check failed");

This looks like a lefterover debugging aid.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
