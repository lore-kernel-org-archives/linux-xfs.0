Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 961257F8E
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 14:01:15 -0500 (CDT)
Date: Thu, 14 Mar 2013 14:01:12 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 09/21] xfs: add version 3 inode format with CRCs
Message-ID: <20130314190111.GW22182@sgi.com>
References: <1363091454-8852-1-git-send-email-david@fromorbit.com>
	<1363091454-8852-10-git-send-email-david@fromorbit.com>
	<20130314160321.GV22182@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130314160321.GV22182@sgi.com>
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
Cc: xfs@oss.sgi.com

On Thu, Mar 14, 2013 at 11:03:21AM -0500, Ben Myers wrote:
> Dave,
> 
> On Tue, Mar 12, 2013 at 11:30:42PM +1100, Dave Chinner wrote:
> > From: Christoph Hellwig <hch@lst.de>
> > 
> > Add a new inode version with a larger core.  The primary objective is
> > to allow for a crc of the inode, and location information (uuid and ino)
> > to verify it was written in the right place.  We also extend it by:
> > 
> > 	a creation time (for Samba);
> > 	a changecount (for NFSv4);
> > 	a flush sequence (in LSN format for recovery);
> > 	an additional inode flags field; and
> > 	some additional padding.
> > 
> > These additional fields are not implemented yet, but already laid
> > out in the structure.
> > 
> > [dchinner@redhat.com] Added LSN and flags field, some factoring and rework to
> > capture all the necessary information in the crc calculation.
> 
> Comments and questions below.

...

> > @@ -190,8 +191,18 @@ xfs_ialloc_inode_init(
> >  	 * the new inode format, then use the new inode version.  Otherwise
> >  	 * use the old version so that old kernels will continue to be
> >  	 * able to use the file system.
> > +	 *
> > +	 * For v3 inodes, we also need to write the inode number into the inode,
> > +	 * so calculate the first inode number of the chunk here as
> > +	 * XFS_OFFBNO_TO_AGINO() only works on filesystem block boundaries, not
> > +	 * cluster boundaries and so cannot be used in the cluster buffer loop
> > +	 * below.
> 
> I'm having some trouble understanding your comment.  Maybe you can help me:
> 
> >  	 */
> > -	if (xfs_sb_version_hasnlink(&mp->m_sb))
> > +	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> > +		version = 3;
> > +		ino = XFS_AGINO_TO_INO(mp, agno,
> > +				       XFS_OFFBNO_TO_AGINO(mp, agbno, 0));
> > +	} else if (xfs_sb_version_hasnlink(&mp->m_sb))
> >  		version = 2;
> >  	else
> >  		version = 1;
> > @@ -217,13 +228,21 @@ xfs_ialloc_inode_init(
> 
> My reading of the loop here is ...
> 
> 210         for (j = 0; j < nbufs; j++) {
> 
> for each inode cluster, j
> 
> 211                 /*
> 212                  * Get the block.
> 213                  */
> 214                 d = XFS_AGB_TO_DADDR(mp, agno, agbno + (j * blks_per_cluster));
> 
> convert to disk address ( this AG, the AGBLOCK of the initial inode cluster plus
> 	(current cluster j * blocks per cluster))
> 
> 215                 fbuf = xfs_trans_get_buf(tp, mp->m_ddev_targp, d,
> 216                                          mp->m_bsize * blks_per_cluster,
> 217                                          XBF_UNMAPPED);
> 
> get a buffer at that disk address of length (filesystem block size times the number of blocks per cluster)
> 
> which is the full length of the inode cluster
> 
> 218                 if (!fbuf)
> 219                         return ENOMEM;
> 220                 /*
> 221                  * Initialize all inodes in this buffer and then log them.
> 222                  *
> 223                  * XXX: It would be much better if we had just one transaction
> 224                  *      to log a whole cluster of inodes instead of all the
> 225                  *      individual transactions causing a lot of log traffic.
> 226                  */
> 227                 fbuf->b_ops = &xfs_inode_buf_ops;
> 228                 xfs_buf_zero(fbuf, 0, ninodes << mp->m_sb.sb_inodelog);
> 
> Zero the whole cluster, including literal areas
> 
> 229                 for (i = 0; i < ninodes; i++) {
> 
> for each inode, i
> 
> 230                         int     ioffset = i << mp->m_sb.sb_inodelog;
> 231                         uint    isize = xfs_dinode_size(version);
> 232
> 233                         free = xfs_make_iptr(mp, fbuf, i);
> 
> get a pointer into the buf to the beginning of i's inode core
> 
> 234                         free->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
> 235                         free->di_version = version;
> 236                         free->di_gen = cpu_to_be32(gen);
> 237                         free->di_next_unlinked = cpu_to_be32(NULLAGINO);
> 
> initialize some important stuff
> 
> 238
> 239                         if (version == 3) {
> 240                                 free->di_ino = cpu_to_be64(ino);
> 241                                 ino++;
> 
> initialize ino on verion 3 inodes.  and add one to ino for the next run of this loop.
> 
> It appears that for subsequent clusters where j > 1 this would stamp the wrong
						j > 0
D'oh.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
