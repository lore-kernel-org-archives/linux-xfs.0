Return-Path: <SRS0=HAJZ=4O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39073C4BA14
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 15:18:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 166022467D
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 15:18:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727744AbgBZPS6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Feb 2020 10:18:58 -0500
Received: from verein.lst.de ([213.95.11.211]:49338 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727023AbgBZPS6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Feb 2020 10:18:58 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id C922268CEE; Wed, 26 Feb 2020 16:18:55 +0100 (CET)
Date:   Wed, 26 Feb 2020 16:18:55 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Chandan Rajendra <chandanrlinux@gmail.com>
Subject: Re: [PATCH 27/30] xfs: clean up the attr flag confusion
Message-ID: <20200226151855.GA19970@lst.de>
References: <20200225231012.735245-1-hch@lst.de> <20200225231012.735245-28-hch@lst.de> <20200226010311.GV10776@dread.disaster.area> <20200226151429.GC19599@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200226151429.GC19599@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 26, 2020 at 04:14:29PM +0100, Christoph Hellwig wrote:
> On Wed, Feb 26, 2020 at 12:03:11PM +1100, Dave Chinner wrote:
> > > @@ -59,7 +59,8 @@ typedef struct xfs_da_args {
> > >  	uint8_t		filetype;	/* filetype of inode for directories */
> > >  	void		*value;		/* set of bytes (maybe contain NULLs) */
> > >  	int		valuelen;	/* length of value */
> > > -	int		flags;		/* argument flags (eg: ATTR_NOCREATE) */
> > > +	unsigned int	attr_filter;	/* XFS_ATTR_{ROOT,SECURE} */
> > > +	unsigned int	attr_flags;	/* XATTR_{CREATE,REPLACE} */
> > 
> > At this point, these are really operation flags. I would have named
> > the variable attr_opflags but I don't think it's worth redoing the
> > entire patch and others over this.
> 
> I've renamed it for the next spin together with the other suggstion.
> I'll also add tracing for the opflags.

Actually.  We already have a op_flags in da_args which is different,
so this might and up being rather confusing.
