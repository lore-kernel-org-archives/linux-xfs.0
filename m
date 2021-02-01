Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DD0EC433DB
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 19:02:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9FBF64DDF
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 19:02:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbhBATBt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Feb 2021 14:01:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:37566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229599AbhBATBs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Feb 2021 14:01:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B625B64DA8;
        Mon,  1 Feb 2021 19:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612206067;
        bh=vaMPxnGg9LkVFlaXKt+zy14l+4Lr8ob8gImEMA2eJng=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ttDAu2voHaORazTprgdtU7/YLVBocv0I2d3O/sasrZdpjGSHqPZTy6QJBgFWtCElj
         gVOXBdr7oK5mwMzMQcddTMwDGOMdWuGgEIa2SV4a+KiGf/8yXbuvYqfSMlZeUXxIFT
         vWefy92+/sHb0lSmEs4biT03PJuFeG7hiGQOigrb2bRqDZqBCDMz8iwshM/IO2vk0g
         q6bmHKsuDVycODxEVBg9X8QjiJMP38Vy/DmaCLp+eVzsHayhN7h3FhVK26Z7PDILhf
         MCgT7dkVluwEK32OxojPhp2zMQWLpuwYTJ0W7Tm9rNDjEXCNiF21JUncHn0nhsjKCJ
         6ItyYOa/lGcWg==
Date:   Mon, 1 Feb 2021 11:01:07 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com
Subject: Re: [PATCH 07/12] xfs: flush eof/cowblocks if we can't reserve quota
 for file blocks
Message-ID: <20210201190107.GF7193@magnolia>
References: <161214512641.140945.11651856181122264773.stgit@magnolia>
 <161214516600.140945.4401509001858536727.stgit@magnolia>
 <20210201123245.GA3279223@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210201123245.GA3279223@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 01, 2021 at 12:32:45PM +0000, Christoph Hellwig wrote:
> On Sun, Jan 31, 2021 at 06:06:06PM -0800, Darrick J. Wong wrote:
> > @@ -1046,8 +1047,10 @@ xfs_trans_alloc_inode(
> >  {
> >  	struct xfs_trans	*tp;
> >  	struct xfs_mount	*mp = ip->i_mount;
> > +	bool			retried = false;
> >  	int			error;
> >  
> > +retry:
> >  	error = xfs_trans_alloc(mp, resv, dblocks,
> >  			rblocks / mp->m_sb.sb_rextsize,
> >  			force ? XFS_TRANS_RESERVE : 0, &tp);
> > @@ -1065,6 +1068,13 @@ xfs_trans_alloc_inode(
> >  	}
> >  
> >  	error = xfs_trans_reserve_quota_nblks(tp, ip, dblocks, rblocks, force);
> > +	if (!retried && (error == -EDQUOT || error == -ENOSPC)) {
> 
> Nit: writing this as
> 
> 	if ((error == -EDQUOT || error == -ENOSPC) && !retried) {
> 
> would make reading the line a little bit easier at least to me because
> it checks the variable assigned in the line above first.

Will fix in all three.

--D

> Otherwise this looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
