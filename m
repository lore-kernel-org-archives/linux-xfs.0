Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6PE6PGT004659 for <xfs@oss.sgi.com>; Mon, 25 Jul 2011 09:06:25 -0500
Date: Mon, 25 Jul 2011 16:06:09 +0200 (CEST)
From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH v3] xfs_repair: Check if agno is inside the filesystem
In-Reply-To: <1310742423.2921.17.camel@doink>
Message-ID: <alpine.LFD.2.00.1107251604580.9742@dhcp-27-109.brq.redhat.com>
References: <1309271164-29794-1-git-send-email-lczerner@redhat.com>
	<1310742423.2921.17.camel@doink>
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alex Elder <aelder@sgi.com>
Cc: Lukas Czerner <lczerner@redhat.com>, xfs@oss.sgi.com

On Fri, 15 Jul 2011, Alex Elder wrote:

> On Tue, 2011-06-28 at 16:26 +0200, Lukas Czerner wrote:
> > When getting an inode tree pointer from an array inode_tree_ptrs, we
> > should check if agno, which is used as a pointer to the array, lives
> > within the file system, because if it is not, we can end up touching
> > uninitialized memory. This may happen if we have corrupted directory
> > entry.
> > 
> > This commit fixes it by passing xfs_mount to affected functions and
> > checking if agno really is inside the file system.
> > 
> > This solves Red Hat bug #694706
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> 
> OK, it looks like there are basically four changes
> here--adding the mount point argument to four functions
> and using it to verify (or assert the validity of) the
> an AG number.  The rest of the changes are simply the
> rippling-back effect of adding the mount point.
> 
> The change looks good to me.  If nobody else objects to
> the change I will commit this for you.
> 
> Reviewed-by: Alex Elder <aelder@sgi.com>

Thanks Alex!

I still can not see it in the git though, so what is the status of this
patch ?

Thanks!
-Lukas

> 
> . . .
> 
> > diff --git a/repair/incore.h b/repair/incore.h
> > index 99853fb..5e3d95d 100644
> > --- a/repair/incore.h
> > +++ b/repair/incore.h
> 
> . . .
> 
> > @@ -316,12 +317,17 @@ findfirst_inode_rec(xfs_agnumber_t agno)
> >  	return((ino_tree_node_t *) inode_tree_ptrs[agno]->avl_firstino);
> >  }
> >  static inline ino_tree_node_t *
> > -find_inode_rec(xfs_agnumber_t agno, xfs_agino_t ino)
> > +find_inode_rec(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agino_t ino)
> >  {
> > +	/*
> > +	 * Is the AG inside the file system
> > +	 */
> > +	if (agno >= mp->m_sb.sb_agcount)
> > +		return NULL;
> 
> Here is one--validate the agno using the new mp argument.
> 
> >  	return((ino_tree_node_t *)
> >  		avl_findrange(inode_tree_ptrs[agno], ino));
> >  }
> > -void		find_inode_rec_range(xfs_agnumber_t agno,
> > +void		find_inode_rec_range(struct xfs_mount *mp, xfs_agnumber_t agno,
> >  			xfs_agino_t start_ino, xfs_agino_t end_ino,
> >  			ino_tree_node_t **first, ino_tree_node_t **last);
> >  
> 
> . . .
> 
> > diff --git a/repair/incore_ino.c b/repair/incore_ino.c
> > index febe0c9..7827ff5 100644
> > --- a/repair/incore_ino.c
> > +++ b/repair/incore_ino.c
> > @@ -418,9 +418,11 @@ add_inode_uncertain(xfs_mount_t *mp, xfs_ino_t ino, int free)
> >   * pull the indicated inode record out of the uncertain inode tree
> >   */
> >  void
> > -get_uncertain_inode_rec(xfs_agnumber_t agno, ino_tree_node_t *ino_rec)
> > +get_uncertain_inode_rec(struct xfs_mount *mp, xfs_agnumber_t agno,
> > +			ino_tree_node_t *ino_rec)
> >  {
> >  	ASSERT(inode_tree_ptrs != NULL);
> > +	ASSERT(agno < mp->m_sb.sb_agcount);
> 
> Here is the second.
> 
> >  	ASSERT(inode_tree_ptrs[agno] != NULL);
> >  
> >  	avl_delete(inode_uncertain_tree_ptrs[agno], &ino_rec->avl_node);
> 
> . . .
> 
> > @@ -495,9 +497,10 @@ add_inode(xfs_agnumber_t agno, xfs_agino_t ino)
> >   * pull the indicated inode record out of the inode tree
> >   */
> >  void
> > -get_inode_rec(xfs_agnumber_t agno, ino_tree_node_t *ino_rec)
> > +get_inode_rec(struct xfs_mount *mp, xfs_agnumber_t agno, ino_tree_node_t *ino_rec)
> >  {
> >  	ASSERT(inode_tree_ptrs != NULL);
> > +	ASSERT(agno < mp->m_sb.sb_agcount);
> 
> Here is the third.
> 
> >  	ASSERT(inode_tree_ptrs[agno] != NULL);
> >  
> >  	avl_delete(inode_tree_ptrs[agno], &ino_rec->avl_node);
> 
> . . .
> 
> > @@ -518,14 +521,18 @@ free_inode_rec(xfs_agnumber_t agno, ino_tree_node_t *ino_rec)
> >  }
> >  
> >  void
> > -find_inode_rec_range(xfs_agnumber_t agno, xfs_agino_t start_ino,
> > -			xfs_agino_t end_ino, ino_tree_node_t **first,
> > -			ino_tree_node_t **last)
> > +find_inode_rec_range(struct xfs_mount *mp, xfs_agnumber_t agno,
> > +			xfs_agino_t start_ino, xfs_agino_t end_ino,
> > +			ino_tree_node_t **first, ino_tree_node_t **last)
> >  {
> >  	*first = *last = NULL;
> >  
> > -	avl_findranges(inode_tree_ptrs[agno], start_ino,
> > -		end_ino, (avlnode_t **) first, (avlnode_t **) last);
> > +	/*
> > +	 * Is the AG inside the file system ?
> > +	 */
> > +	if (agno < mp->m_sb.sb_agcount)
> > +		avl_findranges(inode_tree_ptrs[agno], start_ino,
> > +			end_ino, (avlnode_t **) first, (avlnode_t **) last);
> 
> And here is the fourth.
> 
> >  }
> >  
> >  /*
> 
> . . .
> 
> 
> 
> 

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
