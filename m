Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59099 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751532AbcJJKYI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Oct 2016 06:24:08 -0400
Date: Mon, 10 Oct 2016 03:23:53 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/7] xfs: fix error initialization
Message-ID: <20161010102353.GF18359@infradead.org>
References: <147588163396.12127.8356851783027062457.stgit@birch.djwong.org>
 <147588167673.12127.8923121358064293920.stgit@birch.djwong.org>
 <05debeab-15ec-2b6b-1704-e6d396242cfe@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05debeab-15ec-2b6b-1704-e6d396242cfe@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, david@fromorbit.com, linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>

On Sat, Oct 08, 2016 at 10:55:58AM -0500, Eric Sandeen wrote:
> On 10/7/16 6:07 PM, Darrick J. Wong wrote:
> > Eric Sandeen reported a gcc complaint about uninitialized error
> > variables, so fix that.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Reported-by: Eric Sandeen <sandeen@redhat.com>
> > ---
> >  fs/xfs/xfs_reflink.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> > index 220d263..5965e94 100644
> > --- a/fs/xfs/xfs_reflink.c
> > +++ b/fs/xfs/xfs_reflink.c
> > @@ -1437,7 +1437,7 @@ xfs_reflink_dirty_extents(
> >  	xfs_off_t		flen;
> >  	struct xfs_bmbt_irec	map[2];
> >  	int			nmaps;
> > -	int			error;
> > +	int			error = 0;
> >  
> >  	while (end - fbno > 0) {
> 
> If we should never get here w/ end <= fbno, then maybe an ASSERT is
> in order.
> 
> And if we ever do get here w/ that case, perhaps default error to a relevant
> error so we don't return success and carry on in that case?

Initializing it to -EINVAL plus an assert for debug builds sounds fine.
