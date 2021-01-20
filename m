Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A025DC433E6
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jan 2021 16:56:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D5DE233EB
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jan 2021 16:56:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731332AbhATQ4B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Jan 2021 11:56:01 -0500
Received: from verein.lst.de ([213.95.11.211]:56647 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391250AbhATQhY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 Jan 2021 11:37:24 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 91B8868B02; Wed, 20 Jan 2021 17:36:33 +0100 (CET)
Date:   Wed, 20 Jan 2021 17:36:33 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, avi@scylladb.com,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 11/11] xfs: reduce exclusive locking on unaligned dio
Message-ID: <20210120163633.GB20331@lst.de>
References: <20210118193516.2915706-1-hch@lst.de> <20210118193516.2915706-12-hch@lst.de> <20210118205521.GF78941@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210118205521.GF78941@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 19, 2021 at 07:55:21AM +1100, Dave Chinner wrote:
> > +			   &xfs_dio_write_ops, flags);
> > +	/*
> > +	 * Retry unaligned IO with exclusive blocking semantics if the DIO
> > +	 * layer rejected it for mapping or locking reasons. If we are doing
> > +	 * nonblocking user IO, propagate the error.
> > +	 */
> > +	if (ret == -EAGAIN && !(iocb->ki_flags & IOCB_NOWAIT)) {
> > +		ASSERT(flags & IOMAP_DIO_UNALIGNED);
> > +		xfs_iunlock(ip, iolock);
> > +		goto retry_exclusive;
> > +	}
> > +
> >  out_unlock:
> >  	if (iolock)
> >  		xfs_iunlock(ip, iolock);
> 
> Do we ever get here without holding the iolock anymore?

Yes, if xfs_ilock_iocb as called from xfs_file_write_checks fails.
