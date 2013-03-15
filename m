Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EEF3A7FB1
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 20:11:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7A118AC007
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 18:11:39 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Bn9jieEttBIhhCop for <xfs@oss.sgi.com>;
	Thu, 14 Mar 2013 18:11:37 -0700 (PDT)
Date: Fri, 15 Mar 2013 12:11:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/21] xfs: add version 3 inode format with CRCs
Message-ID: <20130315011104.GD21651@dastard>
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
To: Ben Myers <bpm@sgi.com>
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
....
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
> ino into the inode.

If it was stamping incorrect numbers into the inodes, the verifiers
would pick that up straight away. That's how I found that my initial
code was wrong.

> Something like this would be better:
> ino = XFS_AGINO_TO_INO(mp, agno,
> 		XFS_OFFBNO_TO_AGINO(mp, agbno + (j * blks_per_cluster), i));
> free->di_ino = cpu_to_be64(ino);

And that's exactly what my initial code did, and the verifiers
pointed out that every second filesystem block in an inode cluster
had incorrect inode numbers in it.  Hence I changed the code to what
I have now and added the comment about XFS_OFFBNO_TO_AGINO only
working within a filesystem block, not across multiple filesystem
blocks....

(Finding this sort of problem is one of the reasons the verifiers
came first ;)

FWIW, 4k block size filesystem exercise the j > 0 path as the
minimum chunk size is 16k, and the cluster size is 8k. Hence we have
nbufs = 2, and we initialise 32 inodes per cluster buffer. For 512
byte inodes, we have nbufs = 4 and we initialise 16 inodes per
cluster buffer.

So this code is most definitely being exercised and the output is
correct as far as I can validate...

$ for i in `seq 64 1 127`; do
> sudo xfs_db -c "inode $i" -c "p v3.inumber" /dev/vdc
> done
v3.inumber = 64
v3.inumber = 65
v3.inumber = 66
v3.inumber = 67
v3.inumber = 68
v3.inumber = 69
v3.inumber = 70
v3.inumber = 71
v3.inumber = 72
v3.inumber = 73
v3.inumber = 74
v3.inumber = 75
v3.inumber = 76
v3.inumber = 77
v3.inumber = 78
v3.inumber = 79
v3.inumber = 80
v3.inumber = 81
v3.inumber = 82
v3.inumber = 83
v3.inumber = 84
v3.inumber = 85
v3.inumber = 86
v3.inumber = 87
v3.inumber = 88
v3.inumber = 89
v3.inumber = 90
v3.inumber = 91
v3.inumber = 92
v3.inumber = 93
v3.inumber = 94
v3.inumber = 95
v3.inumber = 96
v3.inumber = 97
v3.inumber = 98
v3.inumber = 99
v3.inumber = 100
v3.inumber = 101
v3.inumber = 102
v3.inumber = 103
v3.inumber = 104
v3.inumber = 105
v3.inumber = 106
v3.inumber = 107
v3.inumber = 108
v3.inumber = 109
v3.inumber = 110
v3.inumber = 111
v3.inumber = 112
v3.inumber = 113
v3.inumber = 114
v3.inumber = 115
v3.inumber = 116
v3.inumber = 117
v3.inumber = 118
v3.inumber = 119
v3.inumber = 120
v3.inumber = 121
v3.inumber = 122
v3.inumber = 123
v3.inumber = 124
v3.inumber = 125
v3.inumber = 126
v3.inumber = 127

> >  		xfs_buf_zero(fbuf, 0, ninodes << mp->m_sb.sb_inodelog);
> >  		for (i = 0; i < ninodes; i++) {
> >  			int	ioffset = i << mp->m_sb.sb_inodelog;
> > -			uint	isize = sizeof(struct xfs_dinode);
> > +			uint	isize = xfs_dinode_size(version);
> >  
> >  			free = xfs_make_iptr(mp, fbuf, i);
> >  			free->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
> >  			free->di_version = version;
> >  			free->di_gen = cpu_to_be32(gen);
> >  			free->di_next_unlinked = cpu_to_be32(NULLAGINO);
> > +
> > +			if (version == 3) {
> > +				free->di_ino = cpu_to_be64(ino);
> > +				ino++;
> > +				uuid_copy(&free->di_uuid, &mp->m_sb.sb_uuid);
> > +				xfs_dinode_calc_crc(mp, free);
> > +			}
> > +
> >  			xfs_trans_log_buf(tp, fbuf, ioffset, ioffset + isize - 1);
> 
> If I have it right, it's ok not to log the literal are here (even though the
> crc was calculated including the literal area) because the log is protected by
> its own crcs and recovery will recalculate the crc.

Prior to CRCs it's OK not to log the literal areas because the
contents really don't matter. The entire buffer is zeroed because
it's faster than zeroing individual inode cores one by one and it
ensures that we can always tell a freshly allocated inode block with
xfs_db because the literal areas are all zero (i.e. good for
debugging). But these are conveniences, not a necessity, and hence
the advantage of not logging the literal areas reduces the overhead
of logging inode allocations *significantly*.

> What do we have in the
> literal area after log replay in that case?

For non-CRC inode buffers, it doesn't matter.

But you are right that it does matter for CRC enabled inode buffers
as it will result in the CRC in the inode core being incorrect. I'l
havea think about this - there are a couple of potential ways of
solving the problem, and I need to think about them a bit first.

/me is now wondering if he should add his old "allocation create
transaction" patch in here to completely avoid the need for logging
inode buffers here for CRC enabled filesystems....

> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index d750c34..6d08eaa 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -1786,6 +1786,7 @@ xlog_recover_do_inode_buffer(
> >  	xfs_agino_t		*buffer_nextp;
> >  
> >  	trace_xfs_log_recover_buf_inode_buf(mp->m_log, buf_f);
> > +	bp->b_ops = &xfs_inode_buf_ops;
> >  
> >  	inodes_per_buf = BBTOB(bp->b_io_length) >> mp->m_sb.sb_inodelog;
> >  	for (i = 0; i < inodes_per_buf; i++) {
> > @@ -1930,6 +1931,9 @@ xlog_recover_do_reg_buffer(
> >  	/* Shouldn't be any more regions */
> >  	ASSERT(i == item->ri_total);
> >  
> > +	/* Shouldn't be any more regions */
> > +	ASSERT(i == item->ri_total);
> > +
> 
> That appears to be duplicate of the assert above it.

Argh. Stupid tool problem - that hunk should have given a merge
failure, not applied with fuzz. I'll fix it up - a later patch
probably removes it....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
