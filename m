Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38D54C433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 06:01:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E23C164F1C
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 06:01:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233756AbhCSGBP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Mar 2021 02:01:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:51086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230337AbhCSGBO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 19 Mar 2021 02:01:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C57664F1C;
        Fri, 19 Mar 2021 06:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616133674;
        bh=sHFRn1Ik5BCPmIX9IAkkZG6DXKYD0TUm0nDcjWGg2Rg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r4iRX6HhE4sO/ZG47o5CV0UYaf1OCJQ1oqY4HJmXRLpEjcxWD6DaoGU9Q2Jn6N8o7
         f5PCifEfT7dBvWBgvjNTt7mqdRCe5xe9hRdZfmuqw6giKXG74wJq5/6Ok421IOSDHY
         q8nX/sgjhjoamf9CKtmOKxLzoNrtrqlaYYnCywgNtCIHfXGlo/J/lnYBM4Of9MynM9
         d5lm/patNP4A4OC1o/R5x8I0CPrhLg/fMah4H+HM8bdk+5+M3EXoJpvDFLHIPdox8v
         JLxdaIy/1dg30wgmLXw6VRAowos+0cogxFmzGyuSCDmy25x2y8zCymYThl+PWrYbvf
         bYBVH9YUJzzdA==
Date:   Thu, 18 Mar 2021 23:01:10 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: move the xfs_can_free_eofblocks call under the
 IOLOCK
Message-ID: <20210319060110.GE1670408@magnolia>
References: <161610680641.1887542.10509468263256161712.stgit@magnolia>
 <161610681213.1887542.5172499515393116902.stgit@magnolia>
 <20210319055340.GA955126@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319055340.GA955126@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 19, 2021 at 05:53:40AM +0000, Christoph Hellwig wrote:
> On Thu, Mar 18, 2021 at 03:33:32PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > In xfs_inode_free_eofblocks, move the xfs_can_free_eofblocks call
> > further down in the function to the point where we have taken the
> > IOLOCK.  This is preparation for the next patch, where we will need that
> > lock (or equivalent) so that we can check if there are any post-eof
> > blocks to clean out.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_icache.c |   12 ++++--------
> >  1 file changed, 4 insertions(+), 8 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > index e6a62f765422..7353c9fe05db 100644
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> > @@ -1294,13 +1294,6 @@ xfs_inode_free_eofblocks(
> >  	if (!xfs_iflags_test(ip, XFS_IEOFBLOCKS))
> >  		return 0;
> >  
> > -	if (!xfs_can_free_eofblocks(ip, false)) {
> > -		/* inode could be preallocated or append-only */
> > -		trace_xfs_inode_free_eofblocks_invalid(ip);
> > -		xfs_inode_clear_eofblocks_tag(ip);
> > -		return 0;
> > -	}
> > -
> >  	/*
> >  	 * If the mapping is dirty the operation can block and wait for some
> >  	 * time. Unless we are waiting, skip it.
> > @@ -1322,7 +1315,10 @@ xfs_inode_free_eofblocks(
> >  	}
> >  	*lockflags |= XFS_IOLOCK_EXCL;
> >  
> > -	return xfs_free_eofblocks(ip);
> > +	if (xfs_can_free_eofblocks(ip, false))
> > +		return xfs_free_eofblocks(ip);
> 
> Don't we still need to clear the radix tree tag here?

I don't think so, because xfs_free_eofblocks will call
xfs_inode_clear_eofblocks_tag if it succeeds in freeing anything.

Though perhaps you're correct that we need to clear the tag if
!xfs_can_free_eofblocks, since we could have been called if
XFS_ICI_BLOCKGC_TAG was set in the radix tree because we once had a
posteof block but now we really only have cow blocks.

Yeah, ok, I'll add that back...

> Also the fs_inode_free_eofblocks_inval tracepoint is unused now.

...along with the tracepoint.

--D
