Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16791 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750919AbdFZQFV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jun 2017 12:05:21 -0400
Date: Mon, 26 Jun 2017 09:04:34 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: don't crash on unexpected holes in dir/attr btrees
Message-ID: <20170626160434.GH4733@birch.djwong.org>
References: <20170616175337.GE5421@birch.djwong.org>
 <351d0c66-4969-7ce9-da9c-6d2901e1bdef@sandeen.net>
 <20170620090607.GD15374@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170620090607.GD15374@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, list@jonas-server.de, David Shaw <dshaw@jabberwocky.com>, Emmanuel Florac <eflorac@intellique.com>, Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Tue, Jun 20, 2017 at 02:06:07AM -0700, Christoph Hellwig wrote:
> On Fri, Jun 16, 2017 at 01:12:41PM -0500, Eric Sandeen wrote:
> > On 6/16/17 12:53 PM, Darrick J. Wong wrote:
> > > Hi all,
> > > 
> > > So I /think/ the xfs_attr_inactive crashes that both of you have been
> > > seeing are a result of XFS assuming that there aren't ever any mapping
> > > holes in the extended attribute fork and crashing when it tries to
> > > grab a buffer for the hole and fails to notice that holes don't have
> > > buffers.  This lightly tested patch gets rid of /that/ problem.
> > > 
> > > So, if you're willing, can you try this out and see if the crashes go
> > > away?  Granted, this might only enable us to lurch on whatever's next...
> > 
> > If it's unexpected, does that mean something else is wrong?  If so,
> > should there be a warning or a corrupted state, or anything like that?
> 
> xfs_attr_rmtval_remove certainly removes blocks from the attr mapping,
> but those should be expected..

Yes, I think pretty much any attribute removal can result in blocks
being removed from the attribute mapping, but here we have the case that
the da btree points to some offset... but the offset isn't mapped and so
the attr_inactive call blows up.

That said, this patch also fixes the remaining cases where someone
deliberately feeds us a corrupt filesystem and we blow up trying to
xfs_trans_buf_set_type on a null buffer, so can I please get a review of
this patch so I can push it upstream? :)

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
