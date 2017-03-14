Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52668 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751087AbdCNLd3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 14 Mar 2017 07:33:29 -0400
Date: Tue, 14 Mar 2017 07:33:18 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC PATCH] xfs: don't run off the end of the buffer reading
 inline dirents
Message-ID: <20170314113315.GA18042@bfoster.bfoster>
References: <20170308210112.GR5280@birch.djwong.org>
 <20170313123940.GB4153@bfoster.bfoster>
 <20170313205534.GU5280@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170313205534.GU5280@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Mon, Mar 13, 2017 at 01:55:34PM -0700, Darrick J. Wong wrote:
> On Mon, Mar 13, 2017 at 08:39:40AM -0400, Brian Foster wrote:
> > On Wed, Mar 08, 2017 at 01:01:12PM -0800, Darrick J. Wong wrote:
> > > Check that we don't run off the end of the inline data buffer when we're
> > > trying to read directory entries.  xfs/348 triggered kernel memory being
> > > exposed to userspace and a related complaint from the usercopy code.
> > > 
> > > Evidently once we call dir_emit, the VFS ignores error return values
> > > since it's already begun copying data back to userspace.
> > > 
> > 
> > How do we get into this situation in the first place?
> 
> xfs/348 changes the filetype of an (inline) symlink) to an (inline) dir;
> the contents of the symlink look just enough like a dir that we don't
> hit any of the checks that bounce us out of xfs_dir2_sf_getdents, and
> the loop doesn't prevent *sfp from running off the end of the data fork
> buffer...
> 
> ...at which point the code that protects the kernel from copying
> uninitialized kernel memory into userspace kicks in, terminating the
> process with the iolock held, which causes us to blow an ASSERT when the
> inode gets reaped with the iolock still held.
> 

Got it, thanks.

> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  fs/xfs/xfs_dir2_readdir.c |    8 ++++++++
> > >  1 file changed, 8 insertions(+)
> > > 
> > > diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
> > > index 003a99b..70bdd21 100644
> > > --- a/fs/xfs/xfs_dir2_readdir.c
> > > +++ b/fs/xfs/xfs_dir2_readdir.c
> > > @@ -69,6 +69,7 @@ xfs_dir2_sf_getdents(
> > >  	xfs_dir2_dataptr_t	dotdot_offset;
> > >  	xfs_ino_t		ino;
> > >  	struct xfs_da_geometry	*geo = args->geo;
> > > +	char *endp;
> > >  
> > >  	ASSERT(dp->i_df.if_flags & XFS_IFINLINE);
> > >  	/*
> > > @@ -83,6 +84,7 @@ xfs_dir2_sf_getdents(
> > >  	ASSERT(dp->i_df.if_u1.if_data != NULL);
> > >  
> > >  	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
> > > +	endp = dp->i_df.if_u1.if_data + dp->i_df.if_bytes;
> > >  
> > >  	if (dp->i_d.di_size < xfs_dir2_sf_hdr_size(sfp->i8count))
> > >  		return -EFSCORRUPTED;
> > > @@ -130,6 +132,12 @@ xfs_dir2_sf_getdents(
> > >  	for (i = 0; i < sfp->count; i++) {
> > >  		__uint8_t filetype;
> > >  
> > > +		/* If we pass the end of the buffer, we're done. */
> > > +		if (((char *)sfep + sizeof(*sfep)) >= endp ||
> > > +		    (char *)dp->d_ops->sf_nextentry(sfp, sfep) > endp) {
> > > +			break;
> > > +		}
> > > +
> > 
> > What's the reason for checking ->sf_nextentry()?
> 
> struct xfs_dir2_sf_entry (*sfep's type) has a zero-length array for the
> entry name at the end of the structure definition.  In other words, the
> structure effectively has a variable length.  Therefore we must first
> check that the non-variable parts of the structure don't go off the end
> of the array, and then we must check that the name also does not go off
> the end of the array, which we do by computing the nextentry pointer.
> 
> (Should I add that as a comment?)
> 

Ok. Yeah, that would be useful. A bit more clear IMO would be to use
->sf_entsize(), if possible, to just verify through the end of the
current entry based on the namelen.

I'm also wondering if it's useful to return an error even if the caller
might not use it. What about if ctx->pos starts at the entry that
crosses the data fork boundary, for example?

Brian

> --D
> 
> > 
> > Brian
> > 
> > >  		off = xfs_dir2_db_off_to_dataptr(geo, geo->datablk,
> > >  				xfs_dir2_sf_get_offset(sfep));
> > >  
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
