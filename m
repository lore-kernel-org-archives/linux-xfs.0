Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25E49C5DF60
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 05:28:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3A7F214DB
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 05:28:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725730AbfKHF2F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 00:28:05 -0500
Received: from verein.lst.de ([213.95.11.211]:32929 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbfKHF2F (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 8 Nov 2019 00:28:05 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9253268BE1; Fri,  8 Nov 2019 06:28:03 +0100 (CET)
Date:   Fri, 8 Nov 2019 06:28:03 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/46] xfs: refactor btree node scrubbing
Message-ID: <20191108052803.GB29783@lst.de>
References: <20191107182410.12660-1-hch@lst.de> <20191107182410.12660-4-hch@lst.de> <20191107224350.GM6219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107224350.GM6219@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> >  /* Scrub a da btree hash (key). */
> > @@ -136,7 +113,7 @@ xchk_da_btree_hash(
> >  
> >  	/* Is this hash no larger than the parent hash? */
> >  	blks = ds->state->path.blk;
> > -	entry = xchk_da_btree_entry(ds, level - 1, blks[level - 1].index);
> 
> This eliminates the only user of blks, which means the variable can be
> removed.  The rest looks fine though.

Fixed.
