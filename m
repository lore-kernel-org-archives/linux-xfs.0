Return-Path: <SRS0=KqY6=Y6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 816B6C5DF63
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Nov 2019 14:44:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4AC472084D
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Nov 2019 14:44:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbfKFOos (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 09:44:48 -0500
Received: from verein.lst.de ([213.95.11.211]:51690 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727028AbfKFOos (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 6 Nov 2019 09:44:48 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5841D68AFE; Wed,  6 Nov 2019 15:44:46 +0100 (CET)
Date:   Wed, 6 Nov 2019 15:44:46 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
        hch@lst.de
Subject: Re: [PATCH 2/2] xfs: periodically yield scrub threads to the
 scheduler
Message-ID: <20191106144446.GB17196@lst.de>
References: <157301537390.678524.16085197974806955970.stgit@magnolia> <157301538629.678524.5328247190031479757.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157301538629.678524.5328247190031479757.stgit@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 05, 2019 at 08:43:06PM -0800, Darrick J. Wong wrote:
> +++ b/fs/xfs/scrub/common.h
> @@ -14,8 +14,20 @@
>  static inline bool
>  xchk_should_terminate(
>  	struct xfs_scrub	*sc,
> -	int				*error)
> +	int			*error)
>  {
> +#if !IS_ENABLED(CONFIG_PREEMPT)
> +	/*
> +	 * If preemption is disabled, we need to yield to the scheduler every
> +	 * few seconds so that we don't run afoul of the soft lockup watchdog
> +	 * or RCU stall detector.
> +	 */
> +	if (sc->next_yield != 0 && time_after(jiffies, sc->next_yield))
> +		return false;
> +	schedule();
> +	sc->next_yield = jiffies + msecs_to_jiffies(5000);
> +#endif

This looks weird.  Can't we just do a cond_resched() here?
