Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1C6E17F3F
	for <xfs@oss.sgi.com>; Sun, 25 May 2014 23:48:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DED41304039
	for <xfs@oss.sgi.com>; Sun, 25 May 2014 21:48:48 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	D8lZXGTqKMZWAxE3 for <xfs@oss.sgi.com>;
	Sun, 25 May 2014 21:48:43 -0700 (PDT)
Date: Mon, 26 May 2014 14:48:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/16] xfs: convert directory dablk conversion to
	xfs_da_geometry
Message-ID: <20140526044840.GX8554@dastard>
References: <1400803432-20048-1-git-send-email-david@fromorbit.com>
	<1400803432-20048-6-git-send-email-david@fromorbit.com>
	<20140523190622.GF8343@laptop.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140523190622.GF8343@laptop.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, May 23, 2014 at 03:06:22PM -0400, Brian Foster wrote:
> On Fri, May 23, 2014 at 10:03:41AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_da_btree.h     | 15 +++++++--------
> >  fs/xfs/xfs_dir2.c         |  4 ++--
> >  fs/xfs/xfs_dir2_data.c    |  4 ++--
> >  fs/xfs/xfs_dir2_leaf.c    | 21 +++++++++++----------
> >  fs/xfs/xfs_dir2_node.c    | 41 +++++++++++++++++++++++------------------
> >  fs/xfs/xfs_dir2_readdir.c |  6 +++---
> >  6 files changed, 48 insertions(+), 43 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_da_btree.h b/fs/xfs/xfs_da_btree.h
> > index e9496a9..8db83fc 100644
> > --- a/fs/xfs/xfs_da_btree.h
> > +++ b/fs/xfs/xfs_da_btree.h
> > @@ -232,9 +232,9 @@ xfs_dir2_db_off_to_byte(struct xfs_da_geometry *geo, xfs_dir2_db_t db,
> >   * Convert block (DB) to block (dablk)
> >   */
> >  static inline xfs_dablk_t
> > -xfs_dir2_db_to_da(struct xfs_mount *mp, xfs_dir2_db_t db)
> > +xfs_dir2_db_to_da(struct xfs_da_geometry *geo, xfs_dir2_db_t db)
> >  {
> > -	return (xfs_dablk_t)(db << mp->m_sb.sb_dirblklog);
> > +	return (xfs_dablk_t)(db << (geo->blklog - geo->fsblog));
> >  }
> >  
> >  /*
> > @@ -243,7 +243,7 @@ xfs_dir2_db_to_da(struct xfs_mount *mp, xfs_dir2_db_t db)
> >  static inline xfs_dablk_t
> >  xfs_dir2_byte_to_da(struct xfs_mount *mp, xfs_dir2_off_t by)
> >  {
> > -	return xfs_dir2_db_to_da(mp, xfs_dir2_byte_to_db(mp, by));
> > +	return xfs_dir2_db_to_da(mp->m_dir_geo, xfs_dir2_byte_to_db(mp, by));
> >  }
> >  
> >  /*
> > @@ -261,19 +261,18 @@ xfs_dir2_db_off_to_dataptr(struct xfs_mount *mp, xfs_dir2_db_t db,
> >   * Convert block (dablk) to block (DB)
> >   */
> >  static inline xfs_dir2_db_t
> > -xfs_dir2_da_to_db(struct xfs_mount *mp, xfs_dablk_t da)
> > +xfs_dir2_da_to_db(struct xfs_da_geometry *geo, xfs_dablk_t da)
> >  {
> > -	return (xfs_dir2_db_t)(da >> mp->m_sb.sb_dirblklog);
> > +	return (xfs_dir2_db_t)(da >> (geo->blklog - geo->fsblog));
> >  }
> >  
> >  /*
> >   * Convert block (dablk) to byte offset in space
> >   */
> >  static inline xfs_dir2_off_t
> > -xfs_dir2_da_to_byte(struct xfs_mount *mp, xfs_dablk_t da)
> > +xfs_dir2_da_to_byte(struct xfs_da_geometry *geo, xfs_dablk_t da)
> >  {
> > -	return xfs_dir2_db_off_to_byte(mp->m_dir_geo,
> > -				       xfs_dir2_da_to_db(mp, da), 0);
> > +	return xfs_dir2_db_off_to_byte(geo, xfs_dir2_da_to_db(geo, da), 0);
> >  }
> 
> Is it a problem that we convert a dablk to a db block on the way to a
> byte conversion? i.e., that seems like a lossy conversion, assuming I am
> correctly understanding that a dablk is equivalent to a filesystem block
> and a db block is a directory block (1 or more dablks).

It's not lossy, because the only way that directory blocks are
physically indexed is by the start address of the block. That is:

sb_dirblklog = 2

db blockk index	   0               1               2
dir block map	   +---------------+---------------+
bmbt map	   +---+---+---+---+---+---+---+---+
dablk index	   0   1   2   3   4   5   6   7   8


The only time non-sb_dirblklog aligned dablk values are used are
during discontiguous buffer operations The mapping code in
xfs_dabuf_map() is the only code that needs to know about the
intermediate dablk indexes to be able to map and build the
discontiguous buffers. otherwise dablk increases by 4 counts for
every directory block and the other indexes are never directly used.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
