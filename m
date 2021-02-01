Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C40EC433DB
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 19:04:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C3D464DA8
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 19:04:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231191AbhBATEX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Feb 2021 14:04:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:37988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229680AbhBATET (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Feb 2021 14:04:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B634160231;
        Mon,  1 Feb 2021 19:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612206215;
        bh=rIs6dRZqF+Vu263owkv+hntWq1rUwnoinb1Stu0u0qI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IUO/SAXt6pMm+v1Z4K8Rq92dtJyRb619sa97zfnwoWbS2FwQomyUIn38LwqrsG+0g
         mygq0/2N9u5fnLU/bXWVs6lfqnINw564si3cdmm7xJ2abv0YrlirJ/bNGXank/IGGf
         gtgv0X2Z8YJ5jOncRQSEJ2UQBzna3rln9Qr4vxTvc6qxrKvnhu5yERfQp4Fto3G6nu
         0drcofQctbNQiX5X4HzuQ+ZIDNxRiF+O2IsCtaJicfwU8M2FvFakjibiihm4T3ULGj
         szY3AKXdST8/6eV2ZRKH5i4Gq+C3Y3DS36RRVbQLFz970Oq/c6oS35sovIJ8Vob1tO
         TExUz3EzkpnaQ==
Date:   Mon, 1 Feb 2021 11:03:35 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com
Subject: Re: [PATCH 08/12] xfs: flush eof/cowblocks if we can't reserve quota
 for inode creation
Message-ID: <20210201190335.GG7193@magnolia>
References: <161214512641.140945.11651856181122264773.stgit@magnolia>
 <161214517156.140945.6151197680730753044.stgit@magnolia>
 <20210201123540.GB3279223@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210201123540.GB3279223@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 01, 2021 at 12:35:40PM +0000, Christoph Hellwig wrote:
> > +xfs_blockgc_free_dquots(
> > +	struct xfs_dquot	*udqp,
> > +	struct xfs_dquot	*gdqp,
> > +	struct xfs_dquot	*pdqp,
> >  	unsigned int		eof_flags)
> >  {
> >  	struct xfs_eofblocks	eofb = {0};
> > -	struct xfs_dquot	*dq;
> > +	struct xfs_mount	*mp = NULL;
> >  	bool			do_work = false;
> >  	int			error;
> >  
> > +	if (!udqp && !gdqp && !pdqp)
> > +		return 0;
> > +	if (udqp)
> > +		mp = udqp->q_mount;
> > +	if (!mp && gdqp)
> > +		mp = gdqp->q_mount;
> > +	if (!mp && pdqp)
> > +		mp = pdqp->q_mount;
> 
> I think just passing the xfs_mount as the first argument would be a
> little simpler and produce better code.

Changed.

> >  	error = xfs_trans_reserve_quota_icreate(tp, udqp, gdqp, pdqp, dblocks);
> > +	if (!retried && (error == -EDQUOT || error == -ENOSPC)) {
> 
> Same minor nit as for the last patch.

This too.

--D

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
