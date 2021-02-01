Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D32E5C433DB
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 12:15:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80C7064E8F
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 12:15:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbhBAMPV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Feb 2021 07:15:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231400AbhBAMPP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Feb 2021 07:15:15 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86ED9C061573
        for <linux-xfs@vger.kernel.org>; Mon,  1 Feb 2021 04:14:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=GTPyj30VfnvxT90FB1YgRlRbDPy9hjjp5Mm5kwf4al8=; b=sDvumyRwqnDSHdozMAJW07suGZ
        8+FnGbyjpCgyem88KHsY2cdAGDADJfpsBv0TwMZnHNKttaVLkTeexttY25xTcaKE+VzQk5ZmG2yPd
        3Zmpg/D3mlJeNOYnR3B8/l4BageeFa4npMRAyeG6rpJ4PvcFpLoQhhqD61AkzNoTzqJx6+Be2A2oO
        Tz0lZvKTsTUzjq5L1A723peEcBlTGHO3gxfyQuVGdRrHPgtYDpGBdYy/gVZlmvDp2YzNfjIX+XUkt
        PfHy4TWxS5mu/r30v3el51gSrPJyBt+ZrvZBV63Bzv0qNXUjCFU+09DtsvJ4FrvzIQ/5tFdPAngmH
        QdHTT9tA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l6Y65-00DkAk-9Y; Mon, 01 Feb 2021 12:14:25 +0000
Date:   Mon, 1 Feb 2021 12:14:25 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Subject: Re: [PATCH 01/17] xfs: fix xquota chown transactionality wrt
 delalloc blocks
Message-ID: <20210201121425.GA3271714@infradead.org>
References: <161214502818.139387.7678025647736002500.stgit@magnolia>
 <161214503452.139387.3026688558992670901.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161214503452.139387.3026688558992670901.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jan 31, 2021 at 06:03:54PM -0800, Darrick J. Wong wrote:
> @@ -1785,6 +1785,28 @@ xfs_qm_vop_chown(
>  	xfs_trans_mod_dquot(tp, newdq, bfield, ip->i_d.di_nblocks);
>  	xfs_trans_mod_dquot(tp, newdq, XFS_TRANS_DQ_ICOUNT, 1);
>  
> +	/*
> +	 * Back when we made quota reservations for the chown, we reserved the
> +	 * ondisk blocks + delalloc blocks with the new dquot.  Now that we've
> +	 * switched the dquots, decrease the new dquot's block reservation
> +	 * (having already bumped up the real counter) so that we don't have
> +	 * any reservation to give back when we commit.
> +	 */
> +	xfs_trans_mod_dquot(tp, newdq, XFS_TRANS_DQ_RES_BLKS,
> +			-ip->i_delayed_blks);
> +
> +	/*
> +	 * Give the incore reservation for delalloc blocks back to the old
> +	 * dquot.  We don't normally handle delalloc quota reservations
> +	 * transactionally, so just lock the dquot and subtract from the
> +	 * reservation.  We've dirtied the transaction, so it's too late to
> +	 * turn back now.
> +	 */
> +	tp->t_flags |= XFS_TRANS_DIRTY;
> +	xfs_dqlock(prevdq);
> +	prevdq->q_blk.reserved -= ip->i_delayed_blks;
> +	xfs_dqunlock(prevdq);

Any particular reason for this order of operations vs grouping it with
the existing prevdq and newdq sections?

Otherwise loooks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
