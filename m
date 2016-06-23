Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9A3F97CA1
	for <xfs@oss.sgi.com>; Thu, 23 Jun 2016 09:17:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 67B528F8035
	for <xfs@oss.sgi.com>; Thu, 23 Jun 2016 07:17:54 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id XRx1s5hqTAqKHVWN (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 23 Jun 2016 07:17:53 -0700 (PDT)
Date: Thu, 23 Jun 2016 09:17:49 -0500
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: Re: Bug (?) : cumulative xfsrestore does not restore files and
	folders in a directory which was renamed
Message-ID: <20160623141749.GA25075@redhat.com>
References: <a08ae222-7654-4a6f-d9ba-f70017784f74@recia.fr>
	<20160622220959.GV12670@dastard> <20160622222328.GW12670@dastard>
	<20160623014217.GZ12670@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160623014217.GZ12670@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Damien Gombault <damien.gombault@recia.fr>, xfs@oss.sgi.com

On Thu, Jun 23, 2016 at 11:42:17AM +1000, Dave Chinner wrote:
> On Thu, Jun 23, 2016 at 08:23:28AM +1000, Dave Chinner wrote:
> > On Thu, Jun 23, 2016 at 08:09:59AM +1000, Dave Chinner wrote:
> > > But it seems that dirb hasn't been created before the file in it
> > > is being restored. THis can happen because the inventory is not
> > > correct, whichmay in fact be a problem with dump rather than
> > > restore...
> > > 
> > > I'll have a bit of a play around here, see if I can reproduce it.
> > 
> > Yes, i can reproduce it, so I'll have a deeper look.
> 
> Can you try this patch?

FWIW, I tried it on a RHEL7 box and it works fine with Damien's test case.

Thanks-
Bill

> 
> -Dave
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> restore: make new directories after renames
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> Damien Gombault reported that restores of cumulative dumps with
> renamed directories were throwing an error and were incomplete:
> 
> xfsrestore: file 0 in stream, file 0 in dump 0 on object
> xfsrestore: restoring dirA/dirb/fileb (526337 1283006502)
> xfsrestore: restoring regular file ino 526337 dirA/dirb/fileb
> xfsrestore: WARNING: open of dirA/dirb/fileb failed: Aucun fichier ou dossier de
> ce type: discarding ino 526337
> 
> This was triggered by a level 1 dump containing a directory rename
> and a new directory being created inside the renamed directory. i.e:
> 
> $ mv dira dirA
> $ mkdir dirA/dirb
> $ echo foo > dirA/dirb/fileb
> 
> xfs_restore handles directory renames by first moving the old
> directory to the orphanage, then renaming it from the orphanage to
> it's new location. This, in itself is fine.
> 
> The problem is that restore creates the new directories between
> these two steps. Hence any new directory created in a renamed
> directory cannot be restored from a cumulative dump because when
> restore tries to create the new directory neither the old directory
> path nor the new directory path exists.  Hence it silently drops the
> new directory, resulting in subsequent errors tryin gto restore
> files within that new directory.
> 
> The simple fix - just change the order of operations
> in tree_post() so that new directories are created after all the
> renames are processed - is not useful. All that does is break the
> case of renames into newly created directories.
> 
> However, because the making of directories that already exist or
> can't be made silently fails, and the create process does not modify
> the internal directory tree, we can run the directory creation
> function multiple times. Hence we can run directory creation both
> before and after the directory rename step, hence ensuring both
> new parents and new child directories are created appropriately.
> 
> This still may not be sufficient for complex directory
> reorganisations, but it does address the reported problem in a
> manner that is unlikely to cause regresssions. This is important,
> because this code has not changed at all since it was first publicly
> released in early 2001. Hence the minimum change we can make to fix
> the reported problem is the least risky approach we can take.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  restore/tree.c | 61 +++++++++++++++++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 51 insertions(+), 10 deletions(-)
> 
> diff --git a/restore/tree.c b/restore/tree.c
> index 0336e77..8e6fab1 100644
> --- a/restore/tree.c
> +++ b/restore/tree.c
> @@ -1163,15 +1163,35 @@ tree_subtree_parse( bool_t sensepr, char *path )
>  	return BOOL_TRUE;
>  }
>  
> -/* tree_post - called after the dirdump has been applied.
> - * first phase is to eliminate all unreferenced dirents.
> - * done by recursive depth-wise descent of the tree. on the way
> - * up, unlink or orphan unreferenced nondirs, unlink unreferenced
> - * dirs, orphan dirs to be renamed. if a dir is unreferenced, but
> +/* tree_post - called after the dirdump has been applied.  first phase is to
> + * eliminate all unreferenced dirents.  done by recursive depth-wise descent of
> + * the tree. on the way up, unlink or orphan unreferenced nondirs, unlink
> + * unreferenced dirs, orphan dirs to be renamed. if a dir is unreferenced, but
>   * contains referenced dirents, orphan those dirents. orphan unreferenced
>   * nondirs if they are the last link to an inode referenced but not real
>   * somewhere else in the tree. next, make new directories. then rename
>   * directories. finally, create hardlinks from orphanage.
> + *
> + * Note: the way renamed directories are handled by first orphaning them leads
> + * to a chicken and egg problem - the directory does not exist when we try to
> + * make a new directory inside the renamed directory destination. This fails
> + * silently, leaving us with ENOENT errors when trying to restore files within
> + * that new directory.
> + *
> + * To prevent this from happening, we need to create new subdirectories *after*
> + * we have processed all the renamed directories. However, so that the renames
> + * succeed, we also have to create any new parent directories that the renames
> + * depend on.
> + *
> + * Hence we have to do two mkdir passes: one before the renames to create new
> + * ancestors for rename destinations and one after the rename to create new
> + * children in rename destinations.
> + *
> + * NOTE: a simple before/after creation as done below may be too simple for
> + * complex directory structure manipulations. e.g. rename into a new child in
> + * the destination of another rename. This may have to become an iterative loop
> + * that runs until all renames and mkdirs are resolved. We'll cross that bridge
> + * when we need to, not now.
>   */
>  static bool_t noref_elim_recurse( nh_t parh,
>  				  nh_t cldh,
> @@ -1216,7 +1236,14 @@ tree_post( char *path1, char *path2 )
>  		}
>  	}
>  
> -	/* make new directories
> +#ifdef TREE_CHK
> +	assert( tree_chk( ));
> +#endif /* TREE_CHK */
> +
> +	/*
> +	 * make new directories to ensure rename destination ancestors are
> +	 * present before attempting the renames. This will silently skip all
> +	 * the creations that are in rename destinations.
>  	 */
>  	mlog( MLOG_DEBUG | MLOG_TREE,
>  	      "making new directories\n" );
> @@ -1228,10 +1255,6 @@ tree_post( char *path1, char *path2 )
>  		return BOOL_FALSE;
>  	}
>  
> -#ifdef TREE_CHK
> -	assert( tree_chk( ));
> -#endif /* TREE_CHK */
> -
>  	/* rename directories
>  	 */
>  	if ( ! persp->p_fullpr ) {
> @@ -1250,6 +1273,24 @@ tree_post( char *path1, char *path2 )
>  	assert( tree_chk( ));
>  #endif /* TREE_CHK */
>  
> +	/*
> +	 * Repeat making new directories to create directories in rename
> +	 * destinations that were skipped in the first pass.
> +	 */
> +	mlog( MLOG_DEBUG | MLOG_TREE,
> +	      "making new directories in renamed ancestors\n" );
> +	rootp = Node_map( persp->p_rooth );
> +	cldh = rootp->n_cldh;
> +	Node_unmap( persp->p_rooth, &rootp );
> +	ok = mkdirs_recurse( persp->p_rooth, cldh, path1 );
> +	if ( ! ok ) {
> +		return BOOL_FALSE;
> +	}
> +
> +#ifdef TREE_CHK
> +	assert( tree_chk( ));
> +#endif /* TREE_CHK */
> +
>  	/* process hard links
>  	 */
>  	if ( ! persp->p_fullpr ) {
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
