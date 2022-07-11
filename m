Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 811B6C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jul 2022 06:42:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiGKGmz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jul 2022 02:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiGKGmz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jul 2022 02:42:55 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF4C17594
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jul 2022 23:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=iqwS3jNz1+5NddYPkdqr2AFUN4NHGjq7SZY1UZVfj24=; b=v6uqseVOrwol8MV7An2Gvqrm5f
        QmMxL+uuwfsMUDqP+wYHwZM9G/hWf86Yfu69hb4KoAXfbIINS2k48s3cQO0/e/O6EQTnGzxSr55pE
        H4hLPt8E3jFd2waw8m5dB0LOx1gVVzsAzS2FaAB8dageo930ZFPgK07aeKkaD2Ek3P3Xrmxybiphq
        mtPjmvgl3h7GhTDTzHp9fgLSQrDOqGstssk3YinIBeAfTtZ6l1eWdQng2q0B0P6EEqU9GWKylQ+j/
        M1SH1GbBvr2ybOnLknfO0vi3sVCwNhKzr6ynQYVRQA1O1kUl8woE/THF2jKUdrvW7YxXsig5HVJGi
        bsVnldHg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oAn88-00GUMo-T1; Mon, 11 Jul 2022 06:42:52 +0000
Date:   Sun, 10 Jul 2022 23:42:52 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/8] xfs: l_last_sync_lsn is really tracking AIL state
Message-ID: <YsvGbJBvk2QB0168@infradead.org>
References: <20220708015558.1134330-1-david@fromorbit.com>
 <20220708015558.1134330-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220708015558.1134330-5-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 08, 2022 at 11:55:54AM +1000, Dave Chinner wrote:
> +		/*
> +		 * If there are no callbacks on this iclog, we can mark it clean
> +		 * immediately and return. Otherwise we need to run the
> +		 * callbacks.
> +		 */
> +		if (list_empty(&iclog->ic_callbacks)) {
> +			xlog_state_clean_iclog(log, iclog);
> +			return false;
> +		}
> +		trace_xlog_iclog_callback(iclog, _RET_IP_);
> +		iclog->ic_state = XLOG_STATE_CALLBACK;

Can you split the optimization of skipping the XLOG_STATE_CALLBACK
state out?  It seems unrelated to the rest and really confused me
when trying to understand this patch. 

> +static inline void
> +xfs_ail_assign_tail_lsn(
> +	struct xfs_ail		*ailp)
> +{
> +
> +	spin_lock(&ailp->ail_lock);
> +	xfs_ail_update_tail_lsn(ailp);
> +	spin_unlock(&ailp->ail_lock);
> +}

This naming scheme seems a lot more confusing than the old _locked
suffix or the __ prefix.
