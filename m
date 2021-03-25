Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B279DC433C1
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 08:39:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 588B161A1A
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 08:39:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbhCYIjX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 04:39:23 -0400
Received: from verein.lst.de ([213.95.11.211]:40178 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229576AbhCYIjP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Mar 2021 04:39:15 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6F9F968B05; Thu, 25 Mar 2021 09:39:13 +0100 (CET)
Date:   Thu, 25 Mar 2021 09:39:13 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/18] xfs: move the di_projid field to struct xfs_inode
Message-ID: <20210325083913.GA28146@lst.de>
References: <20210324142129.1011766-1-hch@lst.de> <20210324142129.1011766-8-hch@lst.de> <20210324182017.GE22100@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324182017.GE22100@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 24, 2021 at 11:20:17AM -0700, Darrick J. Wong wrote:
> > --- a/fs/xfs/xfs_inode.h
> > +++ b/fs/xfs/xfs_inode.h
> > @@ -54,6 +54,7 @@ typedef struct xfs_inode {
> >  	/* Miscellaneous state. */
> >  	unsigned long		i_flags;	/* see defined flags below */
> >  	uint64_t		i_delayed_blks;	/* count of delay alloc blks */
> > +	uint32_t		i_projid;	/* owner's project id */
> 
> Shouldn't this be prid_t to match the field removed from icdinode?

Sure.
