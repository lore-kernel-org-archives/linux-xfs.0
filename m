Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17075 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750933AbcKDUb7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 16:31:59 -0400
Date: Fri, 4 Nov 2016 13:31:51 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/6] libxfs: convert ushort to unsigned short
Message-ID: <20161104203151.GF32036@birch.djwong.org>
References: <147828429514.31793.3070284385118900515.stgit@birch.djwong.org>
 <147828430373.31793.8618236112840458716.stgit@birch.djwong.org>
 <62b9f952-b40e-3bce-9919-85fec64d8f6e@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62b9f952-b40e-3bce-9919-85fec64d8f6e@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Fri, Nov 04, 2016 at 02:09:29PM -0500, Eric Sandeen wrote:
> On 11/4/16 1:31 PM, Darrick J. Wong wrote:
> > Since xfsprogs dropped ushort in favor of unsigned short, do that
> > here too.
> 
> This pushes 4 lines over 80 chars; can those be fixed up?
> 
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_ialloc.c      |    4 ++--
> >  fs/xfs/libxfs/xfs_inode_buf.h   |    4 ++--
> >  fs/xfs/libxfs/xfs_log_format.h  |    4 ++--
> >  fs/xfs/libxfs/xfs_log_recover.h |    2 +-
> >  fs/xfs/xfs_log_recover.c        |    4 ++--
> >  5 files changed, 9 insertions(+), 9 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> > index 51b4e0d..60e1a67 100644
> > --- a/fs/xfs/libxfs/xfs_ialloc.c
> > +++ b/fs/xfs/libxfs/xfs_ialloc.c
> > @@ -2344,7 +2344,7 @@ xfs_imap(
> >  
> >  		imap->im_blkno = XFS_AGB_TO_DADDR(mp, agno, agbno);
> >  		imap->im_len = XFS_FSB_TO_BB(mp, 1);
> > -		imap->im_boffset = (ushort)(offset << mp->m_sb.sb_inodelog);
> > +		imap->im_boffset = (unsigned short)(offset << mp->m_sb.sb_inodelog);

Well xfsprogs is like this too, but I guess I can append another patch...

> here
> 
> >  		return 0;
> >  	}
> >  
> > @@ -2372,7 +2372,7 @@ xfs_imap(
> >  
> >  	imap->im_blkno = XFS_AGB_TO_DADDR(mp, agno, cluster_agbno);
> >  	imap->im_len = XFS_FSB_TO_BB(mp, blks_per_cluster);
> > -	imap->im_boffset = (ushort)(offset << mp->m_sb.sb_inodelog);
> > +	imap->im_boffset = (unsigned short)(offset << mp->m_sb.sb_inodelog);
> >  
> >  	/*
> >  	 * If the inode number maps to a block outside the bounds
> > diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> > index 3cfe12a..a395d0c 100644
> > --- a/fs/xfs/libxfs/xfs_inode_buf.h
> > +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> > @@ -58,8 +58,8 @@ struct xfs_icdinode {
> >   */
> >  struct xfs_imap {
> >  	xfs_daddr_t	im_blkno;	/* starting BB of inode chunk */
> > -	ushort		im_len;		/* length in BBs of inode chunk */
> > -	ushort		im_boffset;	/* inode offset in block in bytes */
> > +	unsigned short		im_len;		/* length in BBs of inode chunk */
> > +	unsigned short		im_boffset;	/* inode offset in block in bytes */
> 
> these 2

Fixed.

> >  };
> >  
> >  int	xfs_imap_to_bp(struct xfs_mount *, struct xfs_trans *,
> > diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> > index 083cdd6..3fcea8c 100644
> > --- a/fs/xfs/libxfs/xfs_log_format.h
> > +++ b/fs/xfs/libxfs/xfs_log_format.h
> > @@ -481,8 +481,8 @@ static inline uint xfs_log_dinode_size(int version)
> >  typedef struct xfs_buf_log_format {
> >  	unsigned short	blf_type;	/* buf log item type indicator */
> >  	unsigned short	blf_size;	/* size of this item */
> > -	ushort		blf_flags;	/* misc state */
> > -	ushort		blf_len;	/* number of blocks in this buf */
> > +	unsigned short		blf_flags;	/* misc state */
> > +	unsigned short		blf_len;	/* number of blocks in this buf */
> 
> and here

Fixed.

--D

> 
> -Eric
> 
> >  	__int64_t	blf_blkno;	/* starting blkno of this buf */
> >  	unsigned int	blf_map_size;	/* used size of data bitmap in words */
> >  	unsigned int	blf_data_map[XFS_BLF_DATAMAP_SIZE]; /* dirty bitmap */
> > diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
> > index 8e385f9..d9f65e2 100644
> > --- a/fs/xfs/libxfs/xfs_log_recover.h
> > +++ b/fs/xfs/libxfs/xfs_log_recover.h
> > @@ -52,7 +52,7 @@ typedef struct xlog_recover {
> >  	struct list_head	r_itemq;	/* q for items */
> >  } xlog_recover_t;
> >  
> > -#define ITEM_TYPE(i)	(*(ushort *)(i)->ri_buf[0].i_addr)
> > +#define ITEM_TYPE(i)	(*(unsigned short *)(i)->ri_buf[0].i_addr)
> >  
> >  /*
> >   * This is the number of entries in the l_buf_cancel_table used during
> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index 9b3d7c7..cf754bc 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -2025,7 +2025,7 @@ xlog_peek_buffer_cancelled(
> >  	struct xlog		*log,
> >  	xfs_daddr_t		blkno,
> >  	uint			len,
> > -	ushort			flags)
> > +	unsigned short			flags)
> >  {
> >  	struct list_head	*bucket;
> >  	struct xfs_buf_cancel	*bcp;
> > @@ -2065,7 +2065,7 @@ xlog_check_buffer_cancelled(
> >  	struct xlog		*log,
> >  	xfs_daddr_t		blkno,
> >  	uint			len,
> > -	ushort			flags)
> > +	unsigned short			flags)
> >  {
> >  	struct xfs_buf_cancel	*bcp;
> >  
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
