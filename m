Return-Path: <SRS0=ttQi=5Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CFD6C2D0EA
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Apr 2020 12:42:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0026E20747
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Apr 2020 12:42:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbgDHMm0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Apr 2020 08:42:26 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52600 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726977AbgDHMm0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Apr 2020 08:42:26 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 038CYFib051607
        for <linux-xfs@vger.kernel.org>; Wed, 8 Apr 2020 08:42:24 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3091ya29kj-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Apr 2020 08:42:23 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Wed, 8 Apr 2020 13:42:08 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 8 Apr 2020 13:42:05 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 038CgHJg50004012
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Apr 2020 12:42:17 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E39D5204F;
        Wed,  8 Apr 2020 12:42:17 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.71.18])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 0F1415204E;
        Wed,  8 Apr 2020 12:42:15 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Chandan Rajendra <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        bfoster@redhat.com
Subject: Re: [PATCH 2/2] xfs: Extend xattr extent counter to 32-bits
Date:   Wed, 08 Apr 2020 18:15:05 +0530
Organization: IBM
In-Reply-To: <20200407012000.GF21885@dread.disaster.area>
References: <20200404085203.1908-1-chandanrlinux@gmail.com> <20200404085203.1908-3-chandanrlinux@gmail.com> <20200407012000.GF21885@dread.disaster.area>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20040812-0012-0000-0000-000003A0ACEA
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20040812-0013-0000-0000-000021DDD203
Message-Id: <2455556.kQrJWLXWoD@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-07_10:2020-04-07,2020-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 mlxscore=0 malwarescore=0 priorityscore=1501 clxscore=1015 adultscore=0
 mlxlogscore=999 suspectscore=5 spamscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004080102
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday, April 7, 2020 6:50 AM Dave Chinner wrote: 
> On Sat, Apr 04, 2020 at 02:22:03PM +0530, Chandan Rajendra wrote:
> > XFS has a per-inode xattr extent counter which is 16 bits wide. A workload
> > which
> > 1. Creates 1,000,000 255-byte sized xattrs,
> > 2. Deletes 50% of these xattrs in an alternating manner,
> > 3. Tries to create 400,000 new 255-byte sized xattrs
> > causes the following message to be printed on the console,
> > 
> > XFS (loop0): xfs_iflush_int: detected corrupt incore inode 131, total extents = -19916, nblocks = 102937, ptr ffff9ce33b098c00
> > XFS (loop0): xfs_do_force_shutdown(0x8) called from line 3739 of file fs/xfs/xfs_inode.c. Return address = ffffffffa4a94173
> > 
> > This indicates that we overflowed the 16-bits wide xattr extent counter.
> > 
> > I have been informed that there are instances where a single file has
> >  > 100 million hardlinks. With parent pointers being stored in xattr,
> > we will overflow the 16-bits wide xattr extent counter when large
> > number of hardlinks are created.
> > 
> > Hence this commit extends xattr extent counter to 32-bits. It also introduces
> > an incompat flag to prevent older kernels from mounting newer filesystems with
> > 32-bit wide xattr extent counter.
> > 
> > Signed-off-by: Chandan Rajendra <chandanrlinux@gmail.com>
> > ---
> >  fs/xfs/libxfs/xfs_format.h     | 28 +++++++++++++++++++++-------
> >  fs/xfs/libxfs/xfs_inode_buf.c  | 27 +++++++++++++++++++--------
> >  fs/xfs/libxfs/xfs_inode_fork.c |  3 ++-
> >  fs/xfs/libxfs/xfs_log_format.h |  5 +++--
> >  fs/xfs/libxfs/xfs_types.h      |  4 ++--
> >  fs/xfs/scrub/inode.c           |  7 ++++---
> >  fs/xfs/xfs_inode_item.c        |  3 ++-
> >  fs/xfs/xfs_log_recover.c       | 13 ++++++++++---
> >  8 files changed, 63 insertions(+), 27 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> > index 045556e78ee2c..0a4266b0d46e1 100644
> > --- a/fs/xfs/libxfs/xfs_format.h
> > +++ b/fs/xfs/libxfs/xfs_format.h
> > @@ -465,10 +465,12 @@ xfs_sb_has_ro_compat_feature(
> >  #define XFS_SB_FEAT_INCOMPAT_FTYPE	(1 << 0)	/* filetype in dirent */
> >  #define XFS_SB_FEAT_INCOMPAT_SPINODES	(1 << 1)	/* sparse inode chunks */
> >  #define XFS_SB_FEAT_INCOMPAT_META_UUID	(1 << 2)	/* metadata UUID */
> > +#define XFS_SB_FEAT_INCOMPAT_32BIT_AEXT_CNTR (1 << 3)
> >  #define XFS_SB_FEAT_INCOMPAT_ALL \
> >  		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
> >  		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
> > -		 XFS_SB_FEAT_INCOMPAT_META_UUID)
> > +		 XFS_SB_FEAT_INCOMPAT_META_UUID| \
> > +		 XFS_SB_FEAT_INCOMPAT_32BIT_AEXT_CNTR)
> >  
> >  #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
> >  static inline bool
> > @@ -874,7 +876,7 @@ typedef struct xfs_dinode {
> >  	__be64		di_nblocks;	/* # of direct & btree blocks used */
> >  	__be32		di_extsize;	/* basic/minimum extent size for file */
> >  	__be32		di_nextents;	/* number of extents in data fork */
> > -	__be16		di_anextents;	/* number of extents in attribute fork*/
> > +	__be16		di_anextents_lo;/* lower part of xattr extent count */
> >  	__u8		di_forkoff;	/* attr fork offs, <<3 for 64b align */
> >  	__s8		di_aformat;	/* format of attr fork's data */
> >  	__be32		di_dmevmask;	/* DMIG event mask */
> > @@ -891,7 +893,8 @@ typedef struct xfs_dinode {
> >  	__be64		di_lsn;		/* flush sequence */
> >  	__be64		di_flags2;	/* more random flags */
> >  	__be32		di_cowextsize;	/* basic cow extent size for file */
> > -	__u8		di_pad2[12];	/* more padding for future expansion */
> > +	__be16		di_anextents_hi;/* higher part of xattr extent count */
> > +	__u8		di_pad2[10];	/* more padding for future expansion */
> 
> Ok, I think you've limited what we can do here by using this "fill
> holes" variable split. I've never liked doing this, and we've only
> done it in the past when we haven't had space in the inode to create
> a new 32 bit variable.
> 
> IOWs, this is a v5 format feature only, so we should just create a
> new variable:
> 
> 	__be32		di_attr_nextents;
> 
> With that in place, we can now do what we did extending the v1 inode
> link count (16 bits) to the v2 inode link count (32 bits).
> 
> That is, when the attribute count is going to overflow, we set a
> inode flag on disk to indicate that it now has a 32 bit extent count
> and uses that field in the inode, and we set a RO-compat feature
> flag in the superblock to indicate that there are 32 bit attr fork
> extent counts in use.
> 
> Old kernels can still read the filesystem, but see the extent count
> as "max" (65535) but can't modify the attr fork and hence corrupt
> the 32 bit count it knows nothing about.
> 
> If the kernel sees the RO feature bit set, it can set the inode flag
> on inodes it is modifying and update both the old and new counters
> appropriately when flushing the inode to disk (i.e. transparent
> conversion).
> 
> In future, mkfs can then set the RO feature flag by default so all
> new filesystems use the 32 bit counter.

Sure. I will make the changes suggested above.

> 
> >  	/* fields only written to during inode creation */
> >  	xfs_timestamp_t	di_crtime;	/* time created */
> > @@ -993,10 +996,21 @@ enum xfs_dinode_fmt {
> >  	((w) == XFS_DATA_FORK ? \
> >  		(dip)->di_format : \
> >  		(dip)->di_aformat)
> > -#define XFS_DFORK_NEXTENTS(dip,w) \
> > -	((w) == XFS_DATA_FORK ? \
> > -		be32_to_cpu((dip)->di_nextents) : \
> > -		be16_to_cpu((dip)->di_anextents))
> > +
> > +static inline int32_t XFS_DFORK_NEXTENTS(struct xfs_sb *sbp,
> 
> If you are converting a macro to static inline, then all the caller
> sites should be converted to lower case at the same time.

Ok.

> 
> > +					struct xfs_dinode *dip, int whichfork)
> > +{
> > +	int32_t anextents;
> 
> Extent counts should be unsigned, as they are on disk.

Ok.

> 
> > +
> > +	if (whichfork == XFS_DATA_FORK)
> > +		return be32_to_cpu((dip)->di_nextents);
> > +
> > +	anextents = be16_to_cpu((dip)->di_anextents_lo);
> > +	if (xfs_sb_version_has_v3inode(sbp))
> > +		anextents |= ((u32)(be16_to_cpu((dip)->di_anextents_hi)) << 16);
> > +
> > +	return anextents;
> > +}
> 
> No feature bit to indicate that 32 bit attribute extent counts are
> valid?

The incompat feature flag (i.e. XFS_SB_FEAT_INCOMPAT_32BIT_AEXT_CNTR) that I
had introduced prevented older kernels from mounting filesystems having
di_anextents_hi field in the inodes.  As you have explained above, this method
is incorrect. I will add appropriate checks once I implement the new "RO
feature bit" method.

> 
> >  
> >  /*
> >   * For block and character special files the 32bit dev_t is stored at the
> > diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> > index 39c5a6e24915c..ced8195bd8c22 100644
> > --- a/fs/xfs/libxfs/xfs_inode_buf.c
> > +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> > @@ -232,7 +232,8 @@ xfs_inode_from_disk(
> >  	to->di_nblocks = be64_to_cpu(from->di_nblocks);
> >  	to->di_extsize = be32_to_cpu(from->di_extsize);
> >  	to->di_nextents = be32_to_cpu(from->di_nextents);
> > -	to->di_anextents = be16_to_cpu(from->di_anextents);
> > +	to->di_anextents = XFS_DFORK_NEXTENTS(&ip->i_mount->m_sb, from,
> > +				XFS_ATTR_FORK);
> 
> This should open code, but I'd prefer a compeltely separate
> variable...

Ok. I will change that.

> 
> >  	to->di_forkoff = from->di_forkoff;
> >  	to->di_aformat	= from->di_aformat;
> >  	to->di_dmevmask	= be32_to_cpu(from->di_dmevmask);
> > @@ -282,7 +283,7 @@ xfs_inode_to_disk(
> >  	to->di_nblocks = cpu_to_be64(from->di_nblocks);
> >  	to->di_extsize = cpu_to_be32(from->di_extsize);
> >  	to->di_nextents = cpu_to_be32(from->di_nextents);
> > -	to->di_anextents = cpu_to_be16(from->di_anextents);
> > +	to->di_anextents_lo = cpu_to_be16((u32)(from->di_anextents) & 0xffff);
> >  	to->di_forkoff = from->di_forkoff;
> >  	to->di_aformat = from->di_aformat;
> >  	to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
> > @@ -296,6 +297,8 @@ xfs_inode_to_disk(
> >  		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.tv_nsec);
> >  		to->di_flags2 = cpu_to_be64(from->di_flags2);
> >  		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
> > +		to->di_anextents_hi
> > +			= cpu_to_be16((u32)(from->di_anextents) >> 16);
> 
> Again, feature bit for on-disk format modifications needed...

Sure. I will change this.

> 
> >  		to->di_ino = cpu_to_be64(ip->i_ino);
> >  		to->di_lsn = cpu_to_be64(lsn);
> >  		memset(to->di_pad2, 0, sizeof(to->di_pad2));
> > @@ -335,7 +338,7 @@ xfs_log_dinode_to_disk(
> >  	to->di_nblocks = cpu_to_be64(from->di_nblocks);
> >  	to->di_extsize = cpu_to_be32(from->di_extsize);
> >  	to->di_nextents = cpu_to_be32(from->di_nextents);
> > -	to->di_anextents = cpu_to_be16(from->di_anextents);
> > +	to->di_anextents_lo = cpu_to_be16(from->di_anextents_lo);
> >  	to->di_forkoff = from->di_forkoff;
> >  	to->di_aformat = from->di_aformat;
> >  	to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
> > @@ -349,6 +352,7 @@ xfs_log_dinode_to_disk(
> >  		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.t_nsec);
> >  		to->di_flags2 = cpu_to_be64(from->di_flags2);
> >  		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
> > +		to->di_anextents_hi = cpu_to_be16(from->di_anextents_hi);
> >  		to->di_ino = cpu_to_be64(from->di_ino);
> >  		to->di_lsn = cpu_to_be64(from->di_lsn);
> >  		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
> > @@ -365,7 +369,9 @@ xfs_dinode_verify_fork(
> >  	struct xfs_mount	*mp,
> >  	int			whichfork)
> >  {
> > -	uint32_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
> > +	uint32_t		di_nextents;
> > +
> > +	di_nextents = XFS_DFORK_NEXTENTS(&mp->m_sb, dip, whichfork);
> >  
> >  	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
> >  	case XFS_DINODE_FMT_LOCAL:
> > @@ -436,6 +442,9 @@ xfs_dinode_verify(
> >  	uint16_t		flags;
> >  	uint64_t		flags2;
> >  	uint64_t		di_size;
> > +	int32_t			nextents;
> > +	int32_t			anextents;
> > +	int64_t			nblocks;
> 
> Extent counts need to be converted to unsigned in memory - they are
> unsigned on disk....

Ok.

> 
> >  
> >  	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))
> >  		return __this_address;
> > @@ -466,10 +475,12 @@ xfs_dinode_verify(
> >  	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0)
> >  		return __this_address;
> >  
> > +	nextents = XFS_DFORK_NEXTENTS(&mp->m_sb, dip, XFS_DATA_FORK);
> > +	anextents = XFS_DFORK_NEXTENTS(&mp->m_sb, dip, XFS_ATTR_FORK);
> > +	nblocks = be64_to_cpu(dip->di_nblocks);
> > +
> >  	/* Fork checks carried over from xfs_iformat_fork */
> > -	if (mode &&
> > -	    be32_to_cpu(dip->di_nextents) + be16_to_cpu(dip->di_anextents) >
> > -			be64_to_cpu(dip->di_nblocks))
> > +	if (mode && nextents + anextents > nblocks)
> >  		return __this_address;
> >  
> >  	if (mode && XFS_DFORK_BOFF(dip) > mp->m_sb.sb_inodesize)
> > @@ -526,7 +537,7 @@ xfs_dinode_verify(
> >  		default:
> >  			return __this_address;
> >  		}
> > -		if (dip->di_anextents)
> > +		if (XFS_DFORK_NEXTENTS(&mp->m_sb, dip, XFS_ATTR_FORK))
> >  			return __this_address;
> >  	}
> >  
> > diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> > index 518c6f0ec3a61..080fd0c156a1e 100644
> > --- a/fs/xfs/libxfs/xfs_inode_fork.c
> > +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> > @@ -207,9 +207,10 @@ xfs_iformat_extents(
> >  	int			whichfork)
> >  {
> >  	struct xfs_mount	*mp = ip->i_mount;
> > +	struct xfs_sb		*sb = &mp->m_sb;
> >  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
> >  	int			state = xfs_bmap_fork_to_state(whichfork);
> > -	int			nex = XFS_DFORK_NEXTENTS(dip, whichfork);
> > +	int			nex = XFS_DFORK_NEXTENTS(sb, dip, whichfork);
> >  	int			size = nex * sizeof(xfs_bmbt_rec_t);
> >  	struct xfs_iext_cursor	icur;
> >  	struct xfs_bmbt_rec	*dp;
> > diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> > index e3400c9c71cdb..5db92aa508bc5 100644
> > --- a/fs/xfs/libxfs/xfs_log_format.h
> > +++ b/fs/xfs/libxfs/xfs_log_format.h
> > @@ -397,7 +397,7 @@ struct xfs_log_dinode {
> >  	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
> >  	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
> >  	xfs_extnum_t	di_nextents;	/* number of extents in data fork */
> > -	xfs_aextnum_t	di_anextents;	/* number of extents in attribute fork*/
> > +	uint16_t	di_anextents_lo;/* lower part of xattr extent count */
> >  	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
> >  	int8_t		di_aformat;	/* format of attr fork's data */
> >  	uint32_t	di_dmevmask;	/* DMIG event mask */
> > @@ -414,7 +414,8 @@ struct xfs_log_dinode {
> >  	xfs_lsn_t	di_lsn;		/* flush sequence */
> >  	uint64_t	di_flags2;	/* more random flags */
> >  	uint32_t	di_cowextsize;	/* basic cow extent size for file */
> > -	uint8_t		di_pad2[12];	/* more padding for future expansion */
> > +	uint16_t	di_anextents_hi;/* higher part of xattr extent count */
> 
> So, unsigned in the log, as on disk...
> 
> > +	uint8_t		di_pad2[10];	/* more padding for future expansion */
> >  
> >  	/* fields only written to during inode creation */
> >  	xfs_ictimestamp_t di_crtime;	/* time created */
> > diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> > index 397d94775440d..01669aa65745a 100644
> > --- a/fs/xfs/libxfs/xfs_types.h
> > +++ b/fs/xfs/libxfs/xfs_types.h
> > @@ -13,7 +13,7 @@ typedef uint32_t	xfs_agino_t;	/* inode # within allocation grp */
> >  typedef uint32_t	xfs_extlen_t;	/* extent length in blocks */
> >  typedef uint32_t	xfs_agnumber_t;	/* allocation group number */
> >  typedef int32_t		xfs_extnum_t;	/* # of extents in a file */
> > -typedef int16_t		xfs_aextnum_t;	/* # extents in an attribute fork */
> > +typedef int32_t		xfs_aextnum_t;	/* # extents in an attribute fork */
> 
> .... but not in memory?

I will change this. I actually did notice 'data type' inconsistency in the
existing code,

typedef int16_t         xfs_aextnum_t;  /* # extents in an attribute fork */

... and I thought there could be some purpose behind this. I was wrong. I will
fix the data type inconsistencies.

> 
> >  typedef int64_t		xfs_fsize_t;	/* bytes in a file */
> >  typedef uint64_t	xfs_ufsize_t;	/* unsigned bytes in a file */
> >  
> > @@ -60,7 +60,7 @@ typedef void *		xfs_failaddr_t;
> >   */
> >  #define	MAXEXTLEN	((xfs_extlen_t)0x001fffff)	/* 21 bits */
> >  #define	MAXEXTNUM	((xfs_extnum_t)0x7fffffff)	/* signed int */
> > -#define	MAXAEXTNUM	((xfs_aextnum_t)0x7fff)		/* signed short */
> > +#define	MAXAEXTNUM	((xfs_aextnum_t)0x7fffffff)	/* signed int */
> 
> What about for older filesystems where MAXAEXTNUM is unchanged?

I had again depended on XFS_SB_FEAT_INCOMPAT_32BIT_AEXT_CNTR incompat feature
flag to not allow older kernels to access a filesystem with 32-bit xattr
extent counter. I will fix this as well.

> 
> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index 11c3502b07b13..ba3fae95b2260 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -2922,6 +2922,7 @@ xlog_recover_inode_pass2(
> >  	struct xfs_log_dinode	*ldip;
> >  	uint			isize;
> >  	int			need_free = 0;
> > +	uint32_t		nextents;
> >  
> >  	if (item->ri_buf[0].i_len == sizeof(struct xfs_inode_log_format)) {
> >  		in_f = item->ri_buf[0].i_addr;
> > @@ -3044,7 +3045,14 @@ xlog_recover_inode_pass2(
> >  			goto out_release;
> >  		}
> >  	}
> > -	if (unlikely(ldip->di_nextents + ldip->di_anextents > ldip->di_nblocks)){
> > +
> > +	nextents = ldip->di_anextents_lo;
> > +	if (xfs_sb_version_has_v3inode(&mp->m_sb))
> > +		nextents |= ((u32)(ldip->di_anextents_hi) << 16);
> 
> What happens if we are recovering from a filesysetm that doesn't
> know anything about di_anextents_hi and never wrote anything to
> the log for this field?

I had again depended on XFS_SB_FEAT_INCOMPAT_32BIT_AEXT_CNTR incompat feature
flag to not allow older kernels to access a filesystem with 32-bit xattr
extent counter. I will fix this as well.

Thanks for the review comments. I will post the next version which will
address them.

-- 
chandan



