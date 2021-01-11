Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A819AC433E6
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 17:18:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 779C122ADF
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 17:18:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388263AbhAKRSY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 12:18:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:54720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728844AbhAKRSX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 11 Jan 2021 12:18:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43730221F9;
        Mon, 11 Jan 2021 17:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610385462;
        bh=gSvoVCwtO+qWBoAHQgLqtcSt+6qzHKCjYsRPBsxmUhI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ShLdD4h73LUQQUOGMFfajZmhwPfUOCDaGVi6n/KxqDvfPvQrBpLVrM0nY6jtGlR7/
         nQ7sJkrtUnunGY1TvGfWTdmx0NbJ/4kXGGCi3MbEeVghgM+He9WNd3lphzzTf4ZK9y
         Ra9oODkLKov+W8HpUZCQGFKoG8WPlu2wDHaQTt8GuIspnEGI+UbnLzfqma6iojtPjJ
         qGkuVxRUbfqB3IGVn7OkefeRA2CyxV8/Zcngzjq5JaJY3C/a2XAVgiHBLF3i8vcNw9
         DOZiKK9XEX2OcFiRF1BAMNtjUsdCsD4ofNce7PLjE2xWJALHpaJWw+D3Dir6lKnBOn
         MJzOlDYy/UqIg==
Date:   Mon, 11 Jan 2021 09:17:42 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        wenli xie <wlxie7296@gmail.com>,
        xfs <linux-xfs@vger.kernel.org>, chiluk@ubuntu.com,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: fix an ABBA deadlock in xfs_rename
Message-ID: <20210111171742.GA1164246@magnolia>
References: <20210108015648.GP6918@magnolia>
 <20210108151858.GB893097@bfoster>
 <20210109013948.GT6918@magnolia>
 <20210111140541.GA1091932@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111140541.GA1091932@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 11, 2021 at 09:05:41AM -0500, Brian Foster wrote:
> On Fri, Jan 08, 2021 at 05:39:48PM -0800, Darrick J. Wong wrote:
> > On Fri, Jan 08, 2021 at 10:18:58AM -0500, Brian Foster wrote:
> > > On Thu, Jan 07, 2021 at 05:56:48PM -0800, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > When overlayfs is running on top of xfs and the user unlinks a file in
> > > > the overlay, overlayfs will create a whiteout inode and ask xfs to
> > > > "rename" the whiteout file atop the one being unlinked.  If the file
> > > > being unlinked loses its one nlink, we then have to put the inode on the
> > > > unlinked list.
> > > > 
> > > > This requires us to grab the AGI buffer of the whiteout inode to take it
> > > > off the unlinked list (which is where whiteouts are created) and to grab
> > > > the AGI buffer of the file being deleted.  If the whiteout was created
> > > > in a higher numbered AG than the file being deleted, we'll lock the AGIs
> > > > in the wrong order and deadlock.
> > > > 
> > > > Therefore, grab all the AGI locks we think we'll need ahead of time, and
> > > > in order of increasing AG number per the locking rules.  Set
> > > > t_firstblock so that a subsequent directory block allocation never tries
> > > > to grab a lower-numbered AGF than the AGIs we grabbed.
> > > > 
> > > 
> > > I don't see this patch do anything with t_firstblock... Even so, is that
> > > necessary? I thought we had to lock AGIs before AGFs and always in agno
> > > order, but not necessarily lock an AGF >= previously locked AGIs. Hm?
> > 
> > Oops, heh.  Yeah, I'd added chunks to prevent block allocation, but on
> > further analysis I don't think that was necessary.
> > 
> > > > Reduce the likelihood that a directory expansion will ENOSPC by starting
> > > > with AG 0 when allocating whiteout files.
> > > > 
> > > > Reported-by: wenli xie <wlxie7296@gmail.com>
> > > > Fixes: 93597ae8dac0 ("xfs: Fix deadlock between AGI and AGF when target_ip exists in xfs_rename()")
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > > v2: Make it more obvious that we're grabbing all the AGI locks ahead of
> > > > the AGFs, and hide functions that we don't need to export anymore.
> > > > ---
> > > >  fs/xfs/libxfs/xfs_dir2.h    |    2 --
> > > >  fs/xfs/libxfs/xfs_dir2_sf.c |    2 +-
> > > >  fs/xfs/xfs_inode.c          |   57 ++++++++++++++++++++++++++++++-------------
> > > >  3 files changed, 41 insertions(+), 20 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> > > > index e55378640b05..d03e6098ded9 100644
> > > > --- a/fs/xfs/libxfs/xfs_dir2.h
> > > > +++ b/fs/xfs/libxfs/xfs_dir2.h
> > > > @@ -47,8 +47,6 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
> > > >  extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
> > > >  				struct xfs_name *name, xfs_ino_t ino,
> > > >  				xfs_extlen_t tot);
> > > > -extern bool xfs_dir2_sf_replace_needblock(struct xfs_inode *dp,
> > > > -				xfs_ino_t inum);
> > > >  extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
> > > >  				struct xfs_name *name, xfs_ino_t inum,
> > > >  				xfs_extlen_t tot);
> > > > diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> > > > index 2463b5d73447..8c4f76bba88b 100644
> > > > --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> > > > +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> > > > @@ -1018,7 +1018,7 @@ xfs_dir2_sf_removename(
> > > >  /*
> > > >   * Check whether the sf dir replace operation need more blocks.
> > > >   */
> > > > -bool
> > > > +static bool
> > > >  xfs_dir2_sf_replace_needblock(
> > > >  	struct xfs_inode	*dp,
> > > >  	xfs_ino_t		inum)
> > > > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > > > index b7352bc4c815..528152770dc9 100644
> > > > --- a/fs/xfs/xfs_inode.c
> > > > +++ b/fs/xfs/xfs_inode.c
> > > > @@ -3000,6 +3000,24 @@ xfs_rename_alloc_whiteout(
> > > >  	return 0;
> > > >  }
> > > >  
> > > > +/* Decide if we need to lock the target IP's AGI as part of a rename. */
> > > > +static inline bool
> > > > +xfs_rename_lock_target_ip(
> > > > +	struct xfs_inode	*src_ip,
> > > > +	struct xfs_inode	*target_ip)
> > > > +{
> > > > +	unsigned int		tgt_nlink = VFS_I(target_ip)->i_nlink;
> > > > +	bool			src_is_dir = S_ISDIR(VFS_I(src_ip)->i_mode);
> > > > +
> > > > +	/*
> > > > +	 * We only need to lock the AGI if the target ip will end up on the
> > > > +	 * unlinked list.
> > > > +	 */
> > > > +	if (src_is_dir)
> > > > +		return tgt_nlink == 2;
> > > 
> > > IIUC, we can't rename dirs over nondirs and vice versa. I.e.:
> > > 
> > > # mv dir file
> > > mv: overwrite 'file'? y
> > > mv: cannot overwrite non-directory 'file' with directory 'dir'
> > > # mv -T file dir
> > > mv: overwrite 'dir'? y
> > > mv: cannot overwrite directory 'dir' with non-directory
> > > 
> > > That means that if src_is_dir is true, target must either be NULL or an
> > > empty directory for the rename to succeed, right? If so, have we already
> > > enforced that by this point? I'm wondering if we need to check the link
> > > count == 2 in this case or could possibly just reduce the logic to
> > > (tgt_nlink == 1 || src_is_dir) And if so, whether that still warrants an
> > > inline helper (where I suppose we could still assert that nlink == 2).

Yes, I /think/ we could get away with that conditional.

It leaves a (probably negligible) logic bomb in that we're assuming
that the vfs has checked that target_ip is an empty dir if src is a
directory.  That said, I think the existing rename code also makes that
assumption, so I think I can just simplify the patch and not leave more
ASSERTs.

> > Hm.  I /think/ it's true that we can't ever rename atop an existing
> > directory, so I think this cna go away:
> > 
> > $ mkdir /tmp/xx
> > $ touch /tmp/yy
> > $ strace -s99 -e renameat ./src/renameat2 /tmp/yy /tmp/xx
> > renameat(AT_FDCWD, "/tmp/yy", AT_FDCWD, "/tmp/xx") = -1 EISDIR (Is a directory)
> > 
> 
> Not sure if you mean to qualify that as "with another nondir" or not,
> but fwiw we can rename over an empty dir if the source is a dir:
> 
> # mkdir d1
> # mkdir d2
> # ~/xfstests-dev/src/renameat2 d1 d2

Oops, yes, that is correct.

--D

> 
> Brian
> 
> > --D
> > 
> > > Brian
> > > 
> > > > +	return tgt_nlink == 1;
> > > > +}
> > > > +
> > > >  /*
> > > >   * xfs_rename
> > > >   */
> > > > @@ -3017,7 +3035,7 @@ xfs_rename(
> > > >  	struct xfs_trans	*tp;
> > > >  	struct xfs_inode	*wip = NULL;		/* whiteout inode */
> > > >  	struct xfs_inode	*inodes[__XFS_SORT_INODES];
> > > > -	struct xfs_buf		*agibp;
> > > > +	int			i;
> > > >  	int			num_inodes = __XFS_SORT_INODES;
> > > >  	bool			new_parent = (src_dp != target_dp);
> > > >  	bool			src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
> > > > @@ -3130,6 +3148,27 @@ xfs_rename(
> > > >  		}
> > > >  	}
> > > >  
> > > > +	/*
> > > > +	 * Lock the AGI buffers we need to handle bumping the nlink of the
> > > > +	 * whiteout inode off the unlinked list and to handle dropping the
> > > > +	 * nlink of the target inode.  We have to do this in increasing AG
> > > > +	 * order to avoid deadlocks, and before directory block allocation
> > > > +	 * tries to grab AGFs.
> > > > +	 */
> > > > +	for (i = 0; i < num_inodes && inodes[i] != NULL; i++) {
> > > > +		if (inodes[i] == wip ||
> > > > +		    (inodes[i] == target_ip &&
> > > > +		     xfs_rename_lock_target_ip(src_ip, target_ip))) {
> > > > +			struct xfs_buf	*bp;
> > > > +			xfs_agnumber_t	agno;
> > > > +
> > > > +			agno = XFS_INO_TO_AGNO(mp, inodes[i]->i_ino);
> > > > +			error = xfs_read_agi(mp, tp, agno, &bp);
> > > > +			if (error)
> > > > +				goto out_trans_cancel;
> > > > +		}
> > > > +	}
> > > > +
> > > >  	/*
> > > >  	 * Directory entry creation below may acquire the AGF. Remove
> > > >  	 * the whiteout from the unlinked list first to preserve correct
> > > > @@ -3182,22 +3221,6 @@ xfs_rename(
> > > >  		 * In case there is already an entry with the same
> > > >  		 * name at the destination directory, remove it first.
> > > >  		 */
> > > > -
> > > > -		/*
> > > > -		 * Check whether the replace operation will need to allocate
> > > > -		 * blocks.  This happens when the shortform directory lacks
> > > > -		 * space and we have to convert it to a block format directory.
> > > > -		 * When more blocks are necessary, we must lock the AGI first
> > > > -		 * to preserve locking order (AGI -> AGF).
> > > > -		 */
> > > > -		if (xfs_dir2_sf_replace_needblock(target_dp, src_ip->i_ino)) {
> > > > -			error = xfs_read_agi(mp, tp,
> > > > -					XFS_INO_TO_AGNO(mp, target_ip->i_ino),
> > > > -					&agibp);
> > > > -			if (error)
> > > > -				goto out_trans_cancel;
> > > > -		}
> > > > -
> > > >  		error = xfs_dir_replace(tp, target_dp, target_name,
> > > >  					src_ip->i_ino, spaceres);
> > > >  		if (error)
> > > > 
> > > 
> > 
> 
