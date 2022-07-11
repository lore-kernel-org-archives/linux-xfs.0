Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCEC7C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jul 2022 06:02:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiGKGC0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jul 2022 02:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiGKGC0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jul 2022 02:02:26 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3884B17A96
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jul 2022 23:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=eKQOg1DKaXtSbY7InCEowUSPECWnmYNfBEA9W0Ah0GE=; b=ybnI/OVuJeHf73Yg1LAOZgFblS
        Iq0TNxmMXAipRJP1dmrJes42bHS1lJHlMqg8mRQYlCCFX0HmLaSmUVQHd1ZV+rpc5oA0XIIikv3tI
        sw+meNa85CB+ZwbDych12aFH3jPfC9R0sllWeFv1JyeIfXXBapi3HjI/6eNZ7l7QUAU85/oGXcG8r
        zzqLvNrCvGHQoU/W/mxZqBiWcxqTWmy0Zs+oNUeth0BEulcmZJ9jeEvbjGLh0ZtBZzNiJOnMDQyNF
        PhXlYwkUTtp4VTbehoczqwD7MxtAFP4RH53ywLfgtgDDeb9lCjNtCzoqc7ucarti8yVmdbi8aPlZi
        vNFr/NgQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oAmUy-00GICf-TL; Mon, 11 Jul 2022 06:02:24 +0000
Date:   Sun, 10 Jul 2022 23:02:24 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/8] xfs: AIL doesn't need manual pushing
Message-ID: <Ysu88PpxIRs0An3W@infradead.org>
References: <20220708015558.1134330-1-david@fromorbit.com>
 <20220708015558.1134330-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220708015558.1134330-2-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This looks very nice, but a bunch of minor comments:

> This is silly and expensive. The AIL is perfectly capable of
> calculating the push target itself, and it will always be running
> when the AIL contains objects.
> 
> Modify the AIL to calculate it's 25% push target before it starts a
> push using the same reserve grant head based calculation as is
> currently used, and remove all the places where we ask the AIL to
> push to a new 25% free target.
> 

I suspect some of these "the AIL" to xfsaild or te AIL pusher for
the sentences to make sense.

> +#include "xfs_trans_priv.h"

> +#include "xfs_log_priv.h"

> -			threshold_lsn = xlog_grant_push_threshold(log, 0);
> +			threshold_lsn = xfs_ail_push_target(log->l_ailp);

Should xfs_ail_push_target go into xfs_log.h instead of xfs_log_priv.h?


> +int xlog_space_left(struct xlog	 *log, atomic64_t *head);

Nit: odd formatting with the tab before the *log.

> +xfs_lsn_t
> +__xfs_ail_push_target(
> +	struct xfs_ail		*ailp)
> +{
> +	struct xlog	*log = ailp->ail_log;
> +	xfs_lsn_t	threshold_lsn = 0;
> +	xfs_lsn_t	last_sync_lsn;
> +	int		free_blocks;
> +	int		free_bytes;
> +	int		threshold_block;
> +	int		threshold_cycle;
> +	int		free_threshold;

This culd use a:

	lockdep_assert_held(&ailp->ail_lock);

to document the locking assumptions.

> +	free_bytes = xlog_space_left(log, &log->l_reserve_head.grant);
> +	free_blocks = BTOBBT(free_bytes);
> +
> +	/*
> +	 * Set the threshold for the minimum number of free blocks in the
> +	 * log to the maximum of what the caller needs, one quarter of the
> +	 * log, and 256 blocks.
> +	 */
> +	free_threshold = log->l_logBBsize >> 2;
> +	if (free_blocks >= free_threshold)

Nit: free_block is only used once, so there might not be much in a point
in keeping it as a logcal variable.

> +static inline void xfs_ail_push(struct xfs_ail *ailp)
> +{
> +	wake_up_process(ailp->ail_task);
> +}
> +
> +static inline void xfs_ail_push_all(struct xfs_ail *ailp)
> +{
> +	if (!test_and_set_bit(XFS_AIL_OPSTATE_PUSH_ALL, &ailp->ail_opstate))
> +		xfs_ail_push(ailp);
> +}
> +
> +xfs_lsn_t		__xfs_ail_push_target(struct xfs_ail *ailp);
> +static inline xfs_lsn_t xfs_ail_push_target(struct xfs_ail *ailp)
> +{
> +	xfs_lsn_t	lsn;
> +
> +	spin_lock(&ailp->ail_lock);
> +	lsn = __xfs_ail_push_target(ailp);
> +	spin_unlock(&ailp->ail_lock);
> +	return lsn;
> +}

Is there really any point in micro-optimizing these as inlines in
a header?
