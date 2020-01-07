Return-Path: <SRS0=eQYP=24=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F834C33C8C
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jan 2020 14:18:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28CC5208C4
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jan 2020 14:18:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jSz2mhu/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728260AbgAGOSv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Jan 2020 09:18:51 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:35716 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727658AbgAGOSv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Jan 2020 09:18:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=jdrZDRx75IyydKDLJJoNCSl92PDKutC0z/q11Poqz2E=; b=jSz2mhu/4KhDd1NG7QXaHpRW7
        MdMh64MIXmMWZgq5it3173ITYojTicWAw3UU01jK4z0zWp77eEXqcIMcgEfocP3NIF4F0WCfDDgJT
        YNADj3I/TBHQc+/70bpZbR/xFTUhQW93Ny5K52tJeXbTNFcsvpyjQM1PQUdK9z3TiMCdNLdOz0Y8B
        sip5LetCNPjdophdsAR8pi+12KYRHIara8QQgLcilItGBjttIj+2wdGHD5623sW8TuXtt5neEiA18
        y60e1ENz4lFh+CpK11WD30O/ChIrEA3NItO1k24RhiX++85SUD/f9qdeZxCAwi7ZzjgVA7VQ+P48p
        JJ4qG+lpg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ioph3-0004Xe-91; Tue, 07 Jan 2020 14:18:49 +0000
Date:   Tue, 7 Jan 2020 06:18:49 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Eric Sandeen <sandeen@redhat.com>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] libxfs: make resync with the userspace libxfs easier
Message-ID: <20200107141849.GD10628@infradead.org>
References: <20191217023535.GA12765@magnolia>
 <20191224082954.GA20650@infradead.org>
 <20191224212724.GF7476@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191224212724.GF7476@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 24, 2019 at 01:27:24PM -0800, Darrick J. Wong wrote:
> > Instead of exporting random low-level helpers can you please look
> > into refactoring repair to not require such low level access.  E.g.
> > the put_ino helper seems to be mostly used for convert short form
> > directories from and to the 8 byte inode format, for which we already
> > have kernel helpers in a slighty different form.
> 
> We do?  I didn't find /any/ helpers to fix shortform inums and ftype.
> xfs_repair directly manipulates a lot of directory structures directly
> with libxfs functions.

We have helpers to convert between the 4 and 7 byte ino sf format,
which sounds like something that should be reused.

> So anyway, I am sorry for ruffling your feathers.  I am particularly bad
> at handling small cleanups to smooth over xfsprogs when reviewers are
> short.

What really annoys me is not that patch - it is worth a discussion.
The problem is that you rushed it into -rc against the merge window
rules before we could even have a discussion.
