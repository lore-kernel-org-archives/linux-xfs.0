Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:41180 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751255AbcJJFg4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Oct 2016 01:36:56 -0400
Date: Mon, 10 Oct 2016 16:36:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/7] xfs: fix error initialization
Message-ID: <20161010053653.GU9806@dastard>
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
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>

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

That should be the case - the fallocate infrastructure should be
ensuring len > 0 and we don't overflow. Followup patch, if you think
it necessary, Darrick?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
