Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16701 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933120AbdKBQwa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Nov 2017 12:52:30 -0400
Date: Thu, 2 Nov 2017 09:52:23 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2] xfs: fix unused variable warnings
Message-ID: <20171102165223.GX4911@magnolia>
References: <20171102111137.3062126-1-arnd@arndb.de>
 <20171102111137.3062126-2-arnd@arndb.de>
 <20171102124403.GC16645@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171102124403.GC16645@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>, Eric Sandeen <sandeen@redhat.com>, linux-kernel@vger.kernel.org

On Thu, Nov 02, 2017 at 08:44:03AM -0400, Brian Foster wrote:
> On Thu, Nov 02, 2017 at 12:11:13PM +0100, Arnd Bergmann wrote:
> > fs/xfs/libxfs/xfs_bmap.c: In function 'xfs_bmap_del_extent_delay':
> > fs/xfs/libxfs/xfs_bmap.c:4648:20: error: unused variable 'ifp' [-Werror=unused-variable]
> >   struct xfs_ifork *ifp = XFS_IFORK_PTR(ip, whichfork);
> >                     ^~~
> > fs/xfs/libxfs/xfs_bmap.c: In function 'xfs_bmap_del_extent_cow':
> > fs/xfs/libxfs/xfs_bmap.c:4776:20: error: unused variable 'ifp' [-Werror=unused-variable]
> > 

Christoph's subsequent patch series to reimplement the incore extent map
starts using ifp for more than just the ASSERT, so I'll take this patch
if that rework doesn't land in time for 4.15.

--D

> > Fixes: ca5d8e5b7b90 ("xfs: move pre/post-bmap tracing into xfs_iext_update_extent")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> 
> Thanks for sending this:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> >  fs/xfs/libxfs/xfs_bmap.c | 6 ++----
> >  1 file changed, 2 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index f45f05c45e15..fa85b08b8fe2 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -4645,7 +4645,6 @@ xfs_bmap_del_extent_delay(
> >  	struct xfs_bmbt_irec	*del)
> >  {
> >  	struct xfs_mount	*mp = ip->i_mount;
> > -	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
> >  	struct xfs_bmbt_irec	new;
> >  	int64_t			da_old, da_new, da_diff = 0;
> >  	xfs_fileoff_t		del_endoff, got_endoff;
> > @@ -4663,7 +4662,7 @@ xfs_bmap_del_extent_delay(
> >  	da_new = 0;
> >  
> >  	ASSERT(*idx >= 0);
> > -	ASSERT(*idx <= xfs_iext_count(ifp));
> > +	ASSERT(*idx <= xfs_iext_count(XFS_IFORK_PTR(ip, whichfork)));
> >  	ASSERT(del->br_blockcount > 0);
> >  	ASSERT(got->br_startoff <= del->br_startoff);
> >  	ASSERT(got_endoff >= del_endoff);
> > @@ -4773,7 +4772,6 @@ xfs_bmap_del_extent_cow(
> >  	struct xfs_bmbt_irec	*del)
> >  {
> >  	struct xfs_mount	*mp = ip->i_mount;
> > -	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
> >  	struct xfs_bmbt_irec	new;
> >  	xfs_fileoff_t		del_endoff, got_endoff;
> >  	int			state = BMAP_COWFORK;
> > @@ -4784,7 +4782,7 @@ xfs_bmap_del_extent_cow(
> >  	got_endoff = got->br_startoff + got->br_blockcount;
> >  
> >  	ASSERT(*idx >= 0);
> > -	ASSERT(*idx <= xfs_iext_count(ifp));
> > +	ASSERT(*idx <= xfs_iext_count(XFS_IFORK_PTR(ip, XFS_COW_FORK)));
> >  	ASSERT(del->br_blockcount > 0);
> >  	ASSERT(got->br_startoff <= del->br_startoff);
> >  	ASSERT(got_endoff >= del_endoff);
> > -- 
> > 2.9.0
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
