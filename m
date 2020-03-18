Return-Path: <SRS0=sZmN=5D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 561D8C10DCE
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Mar 2020 09:43:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 269C920674
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Mar 2020 09:43:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727476AbgCRJnw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Mar 2020 05:43:52 -0400
Received: from verein.lst.de ([213.95.11.211]:35897 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726586AbgCRJnw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Mar 2020 05:43:52 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7615668C65; Wed, 18 Mar 2020 10:43:50 +0100 (CET)
Date:   Wed, 18 Mar 2020 10:43:50 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 14/14] xfs: remove XLOG_STATE_IOERROR
Message-ID: <20200318094350.GD6538@lst.de>
References: <20200316144233.900390-1-hch@lst.de> <20200316144233.900390-15-hch@lst.de> <20200316212539.GS256767@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316212539.GS256767@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 16, 2020 at 02:25:39PM -0700, Darrick J. Wong wrote:
> >  	 * At this point, we're umounting anyway, so there's no point in
> > -	 * transitioning log state to IOERROR. Just continue...
> > +	 * transitioning log state to IO_ERROR. Just continue...
> 
> "...so there's no point in marking the log as shut down."?
> 
> There's no IOERROR state anymore, right?

There is on the log itself:

        log->l_flags |= XLOG_IO_ERROR;

but I think your version is nicer anyway.
