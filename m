Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33EACC1B087
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 13:44:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0775B236F9
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 13:44:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbgLGNoe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Dec 2020 08:44:34 -0500
Received: from verein.lst.de ([213.95.11.211]:41913 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726187AbgLGNoe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 Dec 2020 08:44:34 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5DAB468AFE; Mon,  7 Dec 2020 14:43:50 +0100 (CET)
Date:   Mon, 7 Dec 2020 14:43:50 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v3 2/6] xfs: introduce xfs_dialloc_roll()
Message-ID: <20201207134350.GC29249@lst.de>
References: <20201207001533.2702719-1-hsiangkao@redhat.com> <20201207001533.2702719-3-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201207001533.2702719-3-hsiangkao@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +	/*
> +	 * We want the quota changes to be associated with the next transaction,
> +	 * NOT this one. So, detach the dqinfo from this and attach it to the
> +	 * next transaction.
> +	 */
> +	if (tp->t_dqinfo) {
> +		dqinfo = tp->t_dqinfo;
> +		tp->t_dqinfo = NULL;
> +		tflags = tp->t_flags & XFS_TRANS_DQ_DIRTY;
> +		tp->t_flags &= ~(XFS_TRANS_DQ_DIRTY);

No need for the braces here.

> +	if (error) {
> +		xfs_buf_relse(agibp);
> +		return error;
> +	}

I haven't looked over the other patches if there is a good reason for
it, but to me keeping the xfs_buf_relse in the caller would seem more
natural.

>  
> +/* XXX: will be removed in the following patch */
> +int

I don't think the comment is very helpful.  As of this patch the
declaration is obviously needed, and that is all that matters.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
