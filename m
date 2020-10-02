Return-Path: <SRS0=RTOF=DJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 124C1C4363D
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 07:22:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C92BB20719
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 07:22:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726051AbgJBHWc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Oct 2020 03:22:32 -0400
Received: from verein.lst.de ([213.95.11.211]:51329 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725961AbgJBHWc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Oct 2020 03:22:32 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6878267357; Fri,  2 Oct 2020 09:22:29 +0200 (CEST)
Date:   Fri, 2 Oct 2020 09:22:29 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
        linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com
Subject: Re: [PATCH v4.2 4/5] xfs: xfs_defer_capture should absorb
 remaining block reservation
Message-ID: <20201002072229.GC9900@lst.de>
References: <160140139198.830233.3093053332257853111.stgit@magnolia> <160140141814.830233.6669476190490393801.stgit@magnolia> <20201002042015.GT49547@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201002042015.GT49547@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 01, 2020 at 09:20:15PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When xfs_defer_capture extracts the deferred ops and transaction state
> from a transaction, it should record the remaining block reservations so
> that when we continue the dfops chain, we can reserve the same number of
> blocks to use.  We capture the reservations for both data and realtime
> volumes.
> 
> This adds the requirement that every log intent item recovery function
> must be careful to reserve enough blocks to handle both itself and all
> defer ops that it can queue.  On the other hand, this enables us to do
> away with the handwaving block estimation nonsense that was going on in
> xlog_finish_defer_ops.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

I like this version better as well:

Reviewed-by: Christoph Hellwig <hch@lst.de>
