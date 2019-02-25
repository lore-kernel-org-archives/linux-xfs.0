Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:50722 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbfBYRno (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Feb 2019 12:43:44 -0500
Date: Mon, 25 Feb 2019 09:43:38 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/2] xfs: don't pass iomap flags to
 xfs_reflink_allocate_cow
Message-ID: <20190225174338.GE21626@magnolia>
References: <155104025871.24373.7462613353398620970.stgit@magnolia>
 <20190225125501.GA2916@bfoster>
 <20190225165936.GX6503@magnolia>
 <20190225171854.GA4690@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190225171854.GA4690@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Feb 25, 2019 at 12:18:54PM -0500, Brian Foster wrote:
> On Mon, Feb 25, 2019 at 08:59:36AM -0800, Darrick J. Wong wrote:
> > On Mon, Feb 25, 2019 at 07:55:02AM -0500, Brian Foster wrote:
> > > On Sun, Feb 24, 2019 at 12:30:58PM -0800, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Don't pass raw iomap flags to xfs_reflink_allocate_cow; signal our
> > > > intention with a boolean argument.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > >  fs/xfs/xfs_iomap.c   |    6 +++---
> > > >  fs/xfs/xfs_reflink.c |    4 ++--
> > > >  fs/xfs/xfs_reflink.h |    2 +-
> > > >  3 files changed, 6 insertions(+), 6 deletions(-)
> > > > 
> > > > 
> > > > diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> > > > index 01210eae8bf3..a376fb2d4b94 100644
> > > > --- a/fs/xfs/xfs_iomap.c
> > > > +++ b/fs/xfs/xfs_iomap.c
> > > > @@ -983,6 +983,7 @@ xfs_file_iomap_begin(
> > > >  	 */
> > > >  	if (xfs_is_cow_inode(ip)) {
> > > >  		struct xfs_bmbt_irec	orig = imap;
> > > > +		bool			convert_now = (flags & IOMAP_DIRECT);
> > > >  
> > > >  		/* if zeroing doesn't need COW allocation, then we are done. */
> > > >  		if ((flags & IOMAP_ZERO) &&
> > > > @@ -991,7 +992,7 @@ xfs_file_iomap_begin(
> > > >  
> > > >  		/* may drop and re-acquire the ilock */
> > > >  		error = xfs_reflink_allocate_cow(ip, &imap, &shared, &lockmode,
> > > > -						 flags);
> > > > +				convert_now);
> > > >  		if (error)
> > > >  			goto out_unlock;
> > > >  
> > > > @@ -1002,8 +1003,7 @@ xfs_file_iomap_begin(
> > > >  		 * direct I/O code, which must be block aligned we need to
> > > >  		 * report the newly allocated address.
> > > >  		 */
> > > > -		if (!(flags & IOMAP_DIRECT) &&
> > > > -		    orig.br_startblock != HOLESTARTBLOCK)
> > > > +		if (!convert_now && orig.br_startblock != HOLESTARTBLOCK)
> > > 
> > > FWIW, I thought the original dio check made sense here (in the iomap
> > > callback), whereas the flags parameter to the external function seemed
> > > more of a layering hack. Looks fine, anyways:
> > 
> > Yeah, I went back and forth about this 'convert_now'.  The flag is
> > trying to convey that we need to return the disk location of where we
> > want the write to land.
> > 
> > bool		need_real_write_location = (flags & IOMAP_DIRECT);
> > 
> > But that's a long name.  "need_write_map", perhaps?
> > 
> 
> What I mean to say is that (IMO) the existing IOMAP_DIRECT checks seemed
> fine as long as we changed the param name. FWIW, if we wanted to factor
> it out to a bool I'd personally just call it 'direct_io' or 'dio' or
> something in xfs_file_iomap_begin() (and leave it as 'convert' or
> whatever in the reflink func), but I'm fine with it as is too.

<nod> I'll change 'convert_now' -> 'directio' in this function.  The
reflink function will retain the 'convert_now' name.

--D

> Brian
> 
> > --D
> > 
> > > Reviewed-by: Brian Foster <bfoster@redhat.com>
> > > 
> > > >  			imap = orig;
> > > >  
> > > >  		end_fsb = imap.br_startoff + imap.br_blockcount;
> > > > diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> > > > index e2d9179bd50d..d42e3ef9050e 100644
> > > > --- a/fs/xfs/xfs_reflink.c
> > > > +++ b/fs/xfs/xfs_reflink.c
> > > > @@ -361,7 +361,7 @@ xfs_reflink_allocate_cow(
> > > >  	struct xfs_bmbt_irec	*imap,
> > > >  	bool			*shared,
> > > >  	uint			*lockmode,
> > > > -	unsigned		iomap_flags)
> > > > +	bool			convert_now)
> > > >  {
> > > >  	struct xfs_mount	*mp = ip->i_mount;
> > > >  	xfs_fileoff_t		offset_fsb = imap->br_startoff;
> > > > @@ -444,7 +444,7 @@ xfs_reflink_allocate_cow(
> > > >  	 * to initiate a disk write.  For direct I/O we are going to write the
> > > >  	 * data and need the conversion, but for buffered writes we're done.
> > > >  	 */
> > > > -	if (!(iomap_flags & IOMAP_DIRECT) || imap->br_state == XFS_EXT_NORM)
> > > > +	if (!convert_now || imap->br_state == XFS_EXT_NORM)
> > > >  		return 0;
> > > >  	trace_xfs_reflink_convert_cow(ip, imap);
> > > >  	return xfs_reflink_convert_cow_locked(ip, offset_fsb, count_fsb);
> > > > diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
> > > > index 2a3052fbe23e..28a43b7f581d 100644
> > > > --- a/fs/xfs/xfs_reflink.h
> > > > +++ b/fs/xfs/xfs_reflink.h
> > > > @@ -27,7 +27,7 @@ bool xfs_inode_need_cow(struct xfs_inode *ip, struct xfs_bmbt_irec *imap,
> > > >  
> > > >  extern int xfs_reflink_allocate_cow(struct xfs_inode *ip,
> > > >  		struct xfs_bmbt_irec *imap, bool *shared, uint *lockmode,
> > > > -		unsigned iomap_flags);
> > > > +		bool convert_now);
> > > >  extern int xfs_reflink_convert_cow(struct xfs_inode *ip, xfs_off_t offset,
> > > >  		xfs_off_t count);
> > > >  
> > > > 
