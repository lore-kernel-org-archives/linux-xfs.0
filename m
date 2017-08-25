Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32962 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756135AbdHYSLb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 25 Aug 2017 14:11:31 -0400
Date: Fri, 25 Aug 2017 14:11:29 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 6/9] xfs: skip bmbt block ino validation during owner
 change
Message-ID: <20170825181129.GB40964@bfoster.bfoster>
References: <20170825150557.43010-1-bfoster@redhat.com>
 <20170825150557.43010-7-bfoster@redhat.com>
 <20170825153553.GM4796@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170825153553.GM4796@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Aug 25, 2017 at 08:35:53AM -0700, Darrick J. Wong wrote:
> On Fri, Aug 25, 2017 at 11:05:54AM -0400, Brian Foster wrote:
> > Extent swap uses xfs_btree_visit_blocks() to fix up bmbt block
> > owners on v5 (!rmapbt) filesystems. The bmbt scan uses
> > xfs_btree_lookup_get_block() to read bmbt blocks which verifies the
> > current owner of the block against the parent inode of the bmbt.
> > This works during extent swap because the bmbt owners are updated to
> > the opposite inode number before the inode extent forks are swapped.
> > 
> > The modified bmbt blocks are marked as ordered buffers which allows
> > everything to commit in a single transaction. If the transaction
> > commits to the log and the system crashes such that recovery of the
> > extent swap is required, log recovery restarts the bmbt scan to fix
> > up any bmbt blocks that may have not been written back before the
> > crash. The log recovery bmbt scan occurs after the inode forks have
> > been swapped, however. This causes the bmbt block owner verification
> > to fail, leads to log recovery failure and requires xfs_repair to
> > zap the log to recover.
> > 
> > Define a new invalid inode owner flag to inform the btree block
> > lookup mechanism that the current inode may be invalid with respect
> > to the current owner of the bmbt block. Set this flag on the cursor
> > used for change owner scans to allow this operation to work at
> > runtime and during log recovery.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_bmap_btree.c | 1 +
> >  fs/xfs/libxfs/xfs_btree.c      | 1 +
> >  fs/xfs/libxfs/xfs_btree.h      | 3 ++-
> >  3 files changed, 4 insertions(+), 1 deletion(-)
> > 
...
> > diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> > index 9c95e96..c803ddc 100644
> > --- a/fs/xfs/libxfs/xfs_btree.h
> > +++ b/fs/xfs/libxfs/xfs_btree.h
> > @@ -233,7 +233,8 @@ typedef struct xfs_btree_cur
> >  			short		forksize;	/* fork's inode space */
> >  			char		whichfork;	/* data or attr fork */
> >  			char		flags;		/* flags */
> > -#define	XFS_BTCUR_BPRV_WASDEL	1			/* was delayed */
> > +#define	XFS_BTCUR_BPRV_WASDEL		(1<<0)		/* was delayed */
> > +#define	XFS_BTCUR_BPRV_INVALIDINO	(1<<1)		/* for ext swap */
> 
> I think I'd call this invalid owner since that's the name of the field
> that we're (not) validating.
> 

Sure, I'll change it to XFS_BTCUR_BPRV_INVALID_OWNER unless I hear
otherwise and incorporate the other cleanups for v2. Thanks for the
reviews.

Brian

> Otherwise looks fine,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> --D
> 
> >  		} b;
> >  	}		bc_private;	/* per-btree type data */
> >  } xfs_btree_cur_t;
> > -- 
> > 2.9.5
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
