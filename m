Return-Path: <SRS0=UAxe=YQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A022CA9EA0
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Oct 2019 01:28:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F55F20679
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Oct 2019 01:28:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731761AbfJWB2V (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 21:28:21 -0400
Received: from verein.lst.de ([213.95.11.211]:38003 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727140AbfJWB2V (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 22 Oct 2019 21:28:21 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2CC3A68BE1; Wed, 23 Oct 2019 03:28:19 +0200 (CEST)
Date:   Wed, 23 Oct 2019 03:28:18 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: remove struct xfs_icdinode
Message-ID: <20191023012818.GA15489@lst.de>
References: <20191020082145.32515-1-hch@lst.de> <20191020082145.32515-5-hch@lst.de> <20191020232958.GB8015@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191020232958.GB8015@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 21, 2019 at 10:29:58AM +1100, Dave Chinner wrote:
> This is, IMO, a step backards. We're going to end up failing to
> initialise new fields correctly with this...

How is that different from the plain xfs_inode fields?  In fact I suspect
most of the initializers cn just be removed entirely, so I'll look into
preloading that at the front of the series.

> This is a bug and should make all the 32-bit project ID tests fail.
> If it doesn't them we've got a problem with our test coverage. If it
> does fail, then I'm not sure this patchset has been adequately
> tested...

I don't think we have any coverage of that, at least I didn't see any
extra failures.

> > +	xfs_fsize_t		i_disk_size;	/* number of bytes in file */
> > +	xfs_rfsblock_t		i_nblocks;	/* direct & btree blocks used */
> > +	xfs_extlen_t		i_extsize;	/* extent size hint  */
> > +	xfs_extnum_t		i_nextents;	/* # of extents in data fork */
> > +	xfs_aextnum_t		i_anextents;	/* # of extents in attr fork */
> > +	uint8_t			i_forkoff;	/* attr fork offset */
> > +	int8_t			i_aformat;	/* attr fork format */
> > +	uint32_t		i_dmevmask;	/* DMIG event mask */
> > +	uint16_t		i_dmstate;	/* DMIG state info */
> 
> If we are cleaning up the icdinode, why do these still exist in
> memory?

Because we need them so that we put the right value in the log when
logging the inode core.  Otherwise a log recovery might clear these
values.  The only thing I could do is add a log incompat flag set
on a kernel that removes the field and then not apply changes to these
two fields when recoverying the log on a file system with that flag
set.
