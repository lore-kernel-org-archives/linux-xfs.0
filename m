Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:39211 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753027AbdCFR7c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Mar 2017 12:59:32 -0500
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v26HNApd027192
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 6 Mar 2017 17:23:11 GMT
Date: Mon, 6 Mar 2017 09:22:05 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: allow zero-length symlinks (and directories), sort
 of
Message-ID: <20170306172205.GA5280@birch.djwong.org>
References: <20170304000529.GB5073@birch.djwong.org>
 <20170306135143.GC3223@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170306135143.GC3223@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Mon, Mar 06, 2017 at 08:51:44AM -0500, Brian Foster wrote:
> On Fri, Mar 03, 2017 at 04:05:29PM -0800, Darrick J. Wong wrote:
> > In commit ef388e2054 ("don't allow di_size with high bit set") and
> > commit 3c6f46eacd87 ("sanity check directory inode di_size") we
> > erroneously fail the inode verification checks for symlinks or
> > directories with di_size == 0.
> > 
> > This is proven incorrect by generic/388 because the unlink process uses
> > multiple unconnected transactions to truncate the remote symlink /
> > directory and to unlink and free the inode.  If the fs goes down after
> > the truncate commit but before the unlink happens, we are left with a
> > zero-length inode.  Worse yet, if the unlink /does/ commit, log recovery
> > will now break after the first transaction because we've zeroed di_size.

Ugh, I misspoke slightly.  Truncate and *ifree* are separate
transactions that can lose each other in the mist after a crash.

So that separates this discussion into two classes of problem -- the
first is the case of "truncate, crash, forget to ifree", which at least
isn't a user-visible problem because the inode has been unlinked from
the directory tree at that point.  Log recovery breaks if iget ->
dinode_verify stumbles over the zero-length inode.

The second case (which is what the original dinode_verify patches were
focused on) is the case where someone intentionally corrupts a
filesystem to have zero-byte metafiles.  For that case we need to return
appropriate error codes without crashing.

> > In order to prevent the crashes and ASSERTs that the old patches
> > covered, re-allow the zero-length inodes and change the functions that
> > interface with the vfs to return the appropriate error codes to
> > userspace.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> 
> Interesting, thanks. I suppose this means we should drop the repair side
> fix..? I'm a bit leery on repair modifying a filesystem that is
> technically in a "valid" state, unless there's no other option to
> recover from that state.

I'm not sure if zero byte directories & symlinks are valid states.  They
cannot be created via the regular means (symlink("", "/sym/link")
returns -EINVAL), but such things can be encountered internally because
of the truncate-crash-forgettoifree sequence.  At a bare minimum the
rest of this patch needs to fix the parts of XFS that blow up on
zero-byte special files if the verifier cannot reject them outright.

In the longer run, this situation ought to be fixed by some sort of
ifree log redo item to chain the two transactions together, thereby
avoiding this mess.

(OTOH I think the defer_ops piece could use more battle testing before
we start hooking it up to existing functionality that mostly doesn't
blow up.)

> >  fs/xfs/libxfs/xfs_inode_buf.c |    4 ----
> >  fs/xfs/xfs_dir2_readdir.c     |    6 ++----
> >  fs/xfs/xfs_iops.c             |    9 ++++++++-
> >  3 files changed, 10 insertions(+), 9 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> > index 3752bac..6e62999 100644
> > --- a/fs/xfs/libxfs/xfs_inode_buf.c
> > +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> > @@ -402,10 +402,6 @@ xfs_dinode_verify(
> >  	if (mode && xfs_mode_to_ftype(mode) == XFS_DIR3_FT_UNKNOWN)
> >  		return false;
> >  
> > -	/* No zero-length symlinks/dirs. */
> > -	if ((S_ISLNK(mode) || S_ISDIR(mode)) && dip->di_size == 0)
> > -		return false;
> > -
> 
> What's the reasoning for dropping the S_ISDIR() logic here? Is the same
> scenario possible on a directory?

Yes.

> >  	/* only version 3 or greater inodes are extensively verified here */
> >  	if (dip->di_version < 3)
> >  		return true;
> > diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
> > index 0b3b636..be1367a 100644
> > --- a/fs/xfs/xfs_dir2_readdir.c
> > +++ b/fs/xfs/xfs_dir2_readdir.c
> > @@ -74,10 +74,8 @@ xfs_dir2_sf_getdents(
> >  	/*
> >  	 * Give up if the directory is way too short.
> >  	 */
> > -	if (dp->i_d.di_size < offsetof(xfs_dir2_sf_hdr_t, parent)) {
> > -		ASSERT(XFS_FORCED_SHUTDOWN(dp->i_mount));
> > -		return -EIO;
> > -	}
> > +	if (dp->i_d.di_size < offsetof(xfs_dir2_sf_hdr_t, parent))
> > +		return -EFSCORRUPTED;
> 
> This seems reasonable if it is truly an unexpected state...

I think the error code change is reasonable.  In any case the ASSERT
needs to go because we cant't crash the kernel on account of bad
disk metadata.

> >  
> >  	ASSERT(dp->i_df.if_bytes == dp->i_d.di_size);
> >  	ASSERT(dp->i_df.if_u1.if_data != NULL);
> > diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> > index 22c1615..b7b6807 100644
> > --- a/fs/xfs/xfs_iops.c
> > +++ b/fs/xfs/xfs_iops.c
> > @@ -457,6 +457,9 @@ xfs_vn_get_link(
> >  	char			*link;
> >  	int			error = -ENOMEM;
> >  
> > +	if (i_size_read(inode) == 0)
> > +		return ERR_PTR(-EFSCORRUPTED);
> > +
> 
> ... but this one to me seems to qualify as an expected state, based on
> what you've described in the commit log description. Can we actually now
> "recover" from this situation at runtime (i.e., can we unlink the
> inode)? If so, it seems a little ominous to return a corruption errror
> as opposed to EINVAL or EIO or something (though I suppose either one
> may confuse a user enough into running xfs_repair anyways). Thoughts?

Right now _vn_get_link() on a zero-length rmt symlink just returns "".
Zero-length metadata is (clearly) not totally invalid, since it can be
reproduced (temporarily) via regular log interactions... but from this
user's perspective, the fs shouldn't ever present a metadata object that
can't be created by userspace.

An empty buffer (apparently) gets interpreted as a symlink to the
containing dir, so at least the mechanism doesn't go totally haywire.
That might not be harmful, but I still opine that we should nudge the
user in the direction of xfs_repair with -EFSCORRUPTED.

I don't consider it a good idea to have ifree be a potential
side-effect of readlink, though.  Scraping broken things off the
filesystem (I think) should remain the domain of the scrub/repair tools.

In the longer run I think it would be useful (certainly for xfs_scrub)
to be able to unlink bad files, though I've not implemented that.  In
order to totally tear down a file one would have to make sure that there
are zero dirents pointing to the inode, which requires either parent
pointers or a full directory scan.  Or xfs_repair. :)

--D

> 
> Brian
> 
> >  	if (!dentry)
> >  		return ERR_PTR(-ECHILD);
> >  
> > @@ -483,8 +486,12 @@ xfs_vn_get_link_inline(
> >  	struct inode		*inode,
> >  	struct delayed_call	*done)
> >  {
> > +	char			*p;
> >  	ASSERT(XFS_I(inode)->i_df.if_flags & XFS_IFINLINE);
> > -	return XFS_I(inode)->i_df.if_u1.if_data;
> > +	p = XFS_I(inode)->i_df.if_u1.if_data;
> > +	if (p)
> > +		return p;
> > +	return ERR_PTR(-EFSCORRUPTED);
> >  }
> >  
> >  STATIC int
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
