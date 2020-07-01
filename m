Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 835F4C433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:42:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56F582078A
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:42:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="d9xfFlvh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728929AbgGAImL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 04:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728842AbgGAImK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 04:42:10 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E8B4C03E979
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 01:42:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=EQA6TKmv/+S9HqPTYydQfiFrd8UIoYxUB6Yh0dWA9S0=; b=d9xfFlvhdZ875tfaT0/BGx3nzk
        sCH8z5l5hM2at3htYEgDf2N5YcLCoHJHPjFfPcfDj0klS44NH74NDpGap3DMvKS4ThK8wGrdkSuci
        Eu04XANaoECcroLIcFh2vWavBatH74SJKWRH2WcnBBbMLuyLRFRxsdtA0mWB9S8ORxvaPxswFkA6n
        2KLVIB5SMv7d7QJQsCUZP0G7UlZP7FDcbW+JaD637A6MigxvmFuzErtYFEosfHnTSPRjRK/K68ohl
        wKWqOua8y5MJORQt+LWoiHcV++SEVXPG0/xGqQsA/YV5QQkbY+oDRjQwvBMtJvao+h6w9er0RA0Ka
        Es8C2Ayg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jqYJk-00076I-ON; Wed, 01 Jul 2020 08:42:08 +0000
Date:   Wed, 1 Jul 2020 09:42:08 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/18] xfs: validate ondisk/incore dquot flags
Message-ID: <20200701084208.GC25171@infradead.org>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
 <159353172899.2864738.6438709598863248951.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159353172899.2864738.6438709598863248951.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 30, 2020 at 08:42:09AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> While loading dquot records off disk, make sure that the quota type
> flags are the same between the incore dquot and the ondisk dquot.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_dquot.c |   23 ++++++++++++++++++++---
>  1 file changed, 20 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index d5b7f03e93c8..46c8ca83c04d 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -524,13 +524,27 @@ xfs_dquot_alloc(
>  }
>  
>  /* Copy the in-core quota fields in from the on-disk buffer. */
> -STATIC void
> +STATIC int
>  xfs_dquot_from_disk(
>  	struct xfs_dquot	*dqp,
>  	struct xfs_buf		*bp)
>  {
>  	struct xfs_disk_dquot	*ddqp = bp->b_addr + dqp->q_bufoffset;
>  
> +	/*
> +	 * The only field the verifier didn't check was the quota type flag, so
> +	 * do that here.
> +	 */
> +	if ((dqp->dq_flags & XFS_DQ_ALLTYPES) !=
> +	    (ddqp->d_flags & XFS_DQ_ALLTYPES) ||
> +	    dqp->q_core.d_id != ddqp->d_id) {

The comment looks a little weird, as this also checks d_id.  Also
xfs_dquot_verify verifies d_flags against generally bogus value, it
just doesn't check that it matches the type we are looking for.
Last but not least dqp->dq_flags only contains the type at this
point.

So what about something like:

	/*
	 * Ensure we got the type and ID we were looking for.  Everything else
	 * we checked by the verifier.
	 */
	if ((ddqp->d_flags & XFS_DQ_ALLTYPES) != dqp->dq_flags ||
	    ddqp->d_id != dqp->q_core.d_id)

