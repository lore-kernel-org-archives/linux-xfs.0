Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C973C4320A
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 03:19:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8795860240
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 03:19:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbhHSDUJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Aug 2021 23:20:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:38264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230424AbhHSDUI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Aug 2021 23:20:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03A5C60240;
        Thu, 19 Aug 2021 03:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629343173;
        bh=GESgG3OypFpowghiP/OM7YjmR4B8MiY7xODGeibboq0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sBj17In6s18vYn1Rmq1WfKPVDIO9+kx9A8Cd1/H1BzSIDfMzcB6a6JKH/oHW31T4V
         P6WywgeyBYvtgXI3FbG7YJHtQzHXENSTWwmyWp6nLcF1Y4tPPVYaodkEAyhMeZMxpg
         F7njnXVhU2eT6mb2KzSGFUbW3/vF+FfqyLwxmtjJWgDWtIypxoSpQYDmsv741crf51
         YUY9tROF2y2d2VOy2GEmoAANDPeaScZuA7Pj6ZBO0yfWLZbZiORQ5ISh6EcGEOfEe+
         iMCn1X80IihSEUCaWmilFvGDc2OwkFJ0AyfFG5VUPgRP7ZD7QGbrx6dCNyLg2xjQxF
         foO7ksnH8qGLw==
Date:   Wed, 18 Aug 2021 20:19:32 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/15] xfs: disambiguate units for ftrace fields tagged
 "count"
Message-ID: <20210819031932.GO12640@magnolia>
References: <162924373176.761813.10896002154570305865.stgit@magnolia>
 <162924378705.761813.11309968953103960937.stgit@magnolia>
 <20210819031159.GA3657114@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210819031159.GA3657114@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 19, 2021 at 01:11:59PM +1000, Dave Chinner wrote:
> On Tue, Aug 17, 2021 at 04:43:07PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Some of our tracepoints have a field known as "count".  That name
> > doesn't describe any units, which makes the fields not very useful.
> > Rename the fields to capture units and ensure the format is hexadecimal
> > when we're referring to blocks, extents, or IO operations.
> > 
> > "blockcount" are in units of fs blocks
> > "bytecount" are in units of bytes
> > "icount" are in units of inode records
> 
> This is where fsbcount and bbcount really look like a reasonable way
> of encoding the unit into the description... :)
> 
> Also, having noted in the previous patch that the icreate record
> trace point has a count of inodes as "count", perhaps this icount
> would be better as "ireccount" so that icount can be used as a count
> of inodes...

Ok, patch 9 updated.

> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_trace.h |   14 +++++++-------
> >  1 file changed, 7 insertions(+), 7 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > index 7ae654f7ae82..07da753588d5 100644
> > --- a/fs/xfs/xfs_trace.h
> > +++ b/fs/xfs/xfs_trace.h
> > @@ -346,7 +346,7 @@ DECLARE_EVENT_CLASS(xfs_bmap_class,
> >  		__entry->caller_ip = caller_ip;
> >  	),
> >  	TP_printk("dev %d:%d ino 0x%llx state %s cur %p/%d "
> > -		  "fileoff 0x%llx startblock 0x%llx count %lld flag %d caller %pS",
> > +		  "fileoff 0x%llx startblock 0x%llx blockcount 0x%llx flag %d caller %pS",
> >  		  MAJOR(__entry->dev), MINOR(__entry->dev),
> >  		  __entry->ino,
> >  		  __print_flags(__entry->bmap_state, "|", XFS_BMAP_EXT_FLAGS),
> > @@ -806,7 +806,7 @@ DECLARE_EVENT_CLASS(xfs_iref_class,
> >  		__entry->pincount = atomic_read(&ip->i_pincount);
> >  		__entry->caller_ip = caller_ip;
> >  	),
> > -	TP_printk("dev %d:%d ino 0x%llx count %d pincount %d caller %pS",
> > +	TP_printk("dev %d:%d ino 0x%llx icount %d pincount %d caller %pS",
> >  		  MAJOR(__entry->dev), MINOR(__entry->dev),
> >  		  __entry->ino,
> >  		  __entry->count,
> 
> I don't think this is correct. This count is the current active
> reference count of the inode, not a count of inode records...

Oops.  I guess I got carried away.  Fixed.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
