Return-Path: <SRS0=ELsP=5W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EA9EC2BA17
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 16:45:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFAFE2336E
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 16:45:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CTsXa/Mr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729720AbgDFQpX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Apr 2020 12:45:23 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:45252 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729722AbgDFQpX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Apr 2020 12:45:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586191520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J6fjkpKU64uIcKfZNpLJXGv7HCqgqKLwFPc9gUsdF9g=;
        b=CTsXa/Mr1iBo+PmTrMTDr2gCN7l9tfdOkUXc0yxLAXm5khaxk4k8+0Co0xa76XsUVq/Gg4
        7Bt3QpgVcrb8qmnE0mpUZrSnmCJVLb4s5N8wLz9UOwAe9/+MfPhCMbbZ1MPCk1pL5sgvzF
        j8OHsoZFOs5/ExHbVl/JSN2CJBDHOhc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-S667SBFhMYWt0OqraL96Eg-1; Mon, 06 Apr 2020 12:45:19 -0400
X-MC-Unique: S667SBFhMYWt0OqraL96Eg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B953F107ACC7;
        Mon,  6 Apr 2020 16:45:17 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 27AA01001F43;
        Mon,  6 Apr 2020 16:45:17 +0000 (UTC)
Date:   Mon, 6 Apr 2020 12:45:15 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Chandan Rajendra <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        chandan@linux.ibm.com, darrick.wong@oracle.com
Subject: Re: [PATCH 2/2] xfs: Extend xattr extent counter to 32-bits
Message-ID: <20200406164515.GG20708@bfoster>
References: <20200404085203.1908-1-chandanrlinux@gmail.com>
 <20200404085203.1908-3-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200404085203.1908-3-chandanrlinux@gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Apr 04, 2020 at 02:22:03PM +0530, Chandan Rajendra wrote:
> XFS has a per-inode xattr extent counter which is 16 bits wide. A workload
> which
> 1. Creates 1,000,000 255-byte sized xattrs,
> 2. Deletes 50% of these xattrs in an alternating manner,
> 3. Tries to create 400,000 new 255-byte sized xattrs
> causes the following message to be printed on the console,
> 
> XFS (loop0): xfs_iflush_int: detected corrupt incore inode 131, total extents = -19916, nblocks = 102937, ptr ffff9ce33b098c00
> XFS (loop0): xfs_do_force_shutdown(0x8) called from line 3739 of file fs/xfs/xfs_inode.c. Return address = ffffffffa4a94173
> 
> This indicates that we overflowed the 16-bits wide xattr extent counter.
> 
> I have been informed that there are instances where a single file has
>  > 100 million hardlinks. With parent pointers being stored in xattr,
> we will overflow the 16-bits wide xattr extent counter when large
> number of hardlinks are created.
> 
> Hence this commit extends xattr extent counter to 32-bits. It also introduces
> an incompat flag to prevent older kernels from mounting newer filesystems with
> 32-bit wide xattr extent counter.
> 

Just a couple high level comments on the first pass...

It looks like the feature bit is only set by mkfs. That raises a couple
questions. First, what about a fix for older/existing filesystems? Even
if we can't exceed the 16bit extent count, I would think we should be
able to fail more gracefully than allowing a write verifier to fail and
shutdown the fs. What happens when/if we run into a data fork extent
count limit, for example?

Second, I also wonder if enabling an incompat feature bit by default in
mkfs is a bit extreme. Perhaps this should be tied to a mkfs flag for a
period of time? Maybe others have thoughts on that, but I'd at minimum
request to introduce and enable said bit by default in separate patches
to make it a bit easier for distro releases to identify and manage the
incompatibility.

Brian

> Signed-off-by: Chandan Rajendra <chandanrlinux@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_format.h     | 28 +++++++++++++++++++++-------
>  fs/xfs/libxfs/xfs_inode_buf.c  | 27 +++++++++++++++++++--------
>  fs/xfs/libxfs/xfs_inode_fork.c |  3 ++-
>  fs/xfs/libxfs/xfs_log_format.h |  5 +++--
>  fs/xfs/libxfs/xfs_types.h      |  4 ++--
>  fs/xfs/scrub/inode.c           |  7 ++++---
>  fs/xfs/xfs_inode_item.c        |  3 ++-
>  fs/xfs/xfs_log_recover.c       | 13 ++++++++++---
>  8 files changed, 63 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 045556e78ee2c..0a4266b0d46e1 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -465,10 +465,12 @@ xfs_sb_has_ro_compat_feature(
>  #define XFS_SB_FEAT_INCOMPAT_FTYPE	(1 << 0)	/* filetype in dirent */
>  #define XFS_SB_FEAT_INCOMPAT_SPINODES	(1 << 1)	/* sparse inode chunks */
>  #define XFS_SB_FEAT_INCOMPAT_META_UUID	(1 << 2)	/* metadata UUID */
> +#define XFS_SB_FEAT_INCOMPAT_32BIT_AEXT_CNTR (1 << 3)
>  #define XFS_SB_FEAT_INCOMPAT_ALL \
>  		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
>  		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
> -		 XFS_SB_FEAT_INCOMPAT_META_UUID)
> +		 XFS_SB_FEAT_INCOMPAT_META_UUID| \
> +		 XFS_SB_FEAT_INCOMPAT_32BIT_AEXT_CNTR)
>  
>  #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
>  static inline bool
> @@ -874,7 +876,7 @@ typedef struct xfs_dinode {
>  	__be64		di_nblocks;	/* # of direct & btree blocks used */
>  	__be32		di_extsize;	/* basic/minimum extent size for file */
>  	__be32		di_nextents;	/* number of extents in data fork */
> -	__be16		di_anextents;	/* number of extents in attribute fork*/
> +	__be16		di_anextents_lo;/* lower part of xattr extent count */
>  	__u8		di_forkoff;	/* attr fork offs, <<3 for 64b align */
>  	__s8		di_aformat;	/* format of attr fork's data */
>  	__be32		di_dmevmask;	/* DMIG event mask */
> @@ -891,7 +893,8 @@ typedef struct xfs_dinode {
>  	__be64		di_lsn;		/* flush sequence */
>  	__be64		di_flags2;	/* more random flags */
>  	__be32		di_cowextsize;	/* basic cow extent size for file */
> -	__u8		di_pad2[12];	/* more padding for future expansion */
> +	__be16		di_anextents_hi;/* higher part of xattr extent count */
> +	__u8		di_pad2[10];	/* more padding for future expansion */
>  
>  	/* fields only written to during inode creation */
>  	xfs_timestamp_t	di_crtime;	/* time created */
> @@ -993,10 +996,21 @@ enum xfs_dinode_fmt {
>  	((w) == XFS_DATA_FORK ? \
>  		(dip)->di_format : \
>  		(dip)->di_aformat)
> -#define XFS_DFORK_NEXTENTS(dip,w) \
> -	((w) == XFS_DATA_FORK ? \
> -		be32_to_cpu((dip)->di_nextents) : \
> -		be16_to_cpu((dip)->di_anextents))
> +
> +static inline int32_t XFS_DFORK_NEXTENTS(struct xfs_sb *sbp,
> +					struct xfs_dinode *dip, int whichfork)
> +{
> +	int32_t anextents;
> +
> +	if (whichfork == XFS_DATA_FORK)
> +		return be32_to_cpu((dip)->di_nextents);
> +
> +	anextents = be16_to_cpu((dip)->di_anextents_lo);
> +	if (xfs_sb_version_has_v3inode(sbp))
> +		anextents |= ((u32)(be16_to_cpu((dip)->di_anextents_hi)) << 16);
> +
> +	return anextents;
> +}
>  
>  /*
>   * For block and character special files the 32bit dev_t is stored at the
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 39c5a6e24915c..ced8195bd8c22 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -232,7 +232,8 @@ xfs_inode_from_disk(
>  	to->di_nblocks = be64_to_cpu(from->di_nblocks);
>  	to->di_extsize = be32_to_cpu(from->di_extsize);
>  	to->di_nextents = be32_to_cpu(from->di_nextents);
> -	to->di_anextents = be16_to_cpu(from->di_anextents);
> +	to->di_anextents = XFS_DFORK_NEXTENTS(&ip->i_mount->m_sb, from,
> +				XFS_ATTR_FORK);
>  	to->di_forkoff = from->di_forkoff;
>  	to->di_aformat	= from->di_aformat;
>  	to->di_dmevmask	= be32_to_cpu(from->di_dmevmask);
> @@ -282,7 +283,7 @@ xfs_inode_to_disk(
>  	to->di_nblocks = cpu_to_be64(from->di_nblocks);
>  	to->di_extsize = cpu_to_be32(from->di_extsize);
>  	to->di_nextents = cpu_to_be32(from->di_nextents);
> -	to->di_anextents = cpu_to_be16(from->di_anextents);
> +	to->di_anextents_lo = cpu_to_be16((u32)(from->di_anextents) & 0xffff);
>  	to->di_forkoff = from->di_forkoff;
>  	to->di_aformat = from->di_aformat;
>  	to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
> @@ -296,6 +297,8 @@ xfs_inode_to_disk(
>  		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.tv_nsec);
>  		to->di_flags2 = cpu_to_be64(from->di_flags2);
>  		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
> +		to->di_anextents_hi
> +			= cpu_to_be16((u32)(from->di_anextents) >> 16);
>  		to->di_ino = cpu_to_be64(ip->i_ino);
>  		to->di_lsn = cpu_to_be64(lsn);
>  		memset(to->di_pad2, 0, sizeof(to->di_pad2));
> @@ -335,7 +338,7 @@ xfs_log_dinode_to_disk(
>  	to->di_nblocks = cpu_to_be64(from->di_nblocks);
>  	to->di_extsize = cpu_to_be32(from->di_extsize);
>  	to->di_nextents = cpu_to_be32(from->di_nextents);
> -	to->di_anextents = cpu_to_be16(from->di_anextents);
> +	to->di_anextents_lo = cpu_to_be16(from->di_anextents_lo);
>  	to->di_forkoff = from->di_forkoff;
>  	to->di_aformat = from->di_aformat;
>  	to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
> @@ -349,6 +352,7 @@ xfs_log_dinode_to_disk(
>  		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.t_nsec);
>  		to->di_flags2 = cpu_to_be64(from->di_flags2);
>  		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
> +		to->di_anextents_hi = cpu_to_be16(from->di_anextents_hi);
>  		to->di_ino = cpu_to_be64(from->di_ino);
>  		to->di_lsn = cpu_to_be64(from->di_lsn);
>  		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
> @@ -365,7 +369,9 @@ xfs_dinode_verify_fork(
>  	struct xfs_mount	*mp,
>  	int			whichfork)
>  {
> -	uint32_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
> +	uint32_t		di_nextents;
> +
> +	di_nextents = XFS_DFORK_NEXTENTS(&mp->m_sb, dip, whichfork);
>  
>  	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
>  	case XFS_DINODE_FMT_LOCAL:
> @@ -436,6 +442,9 @@ xfs_dinode_verify(
>  	uint16_t		flags;
>  	uint64_t		flags2;
>  	uint64_t		di_size;
> +	int32_t			nextents;
> +	int32_t			anextents;
> +	int64_t			nblocks;
>  
>  	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))
>  		return __this_address;
> @@ -466,10 +475,12 @@ xfs_dinode_verify(
>  	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0)
>  		return __this_address;
>  
> +	nextents = XFS_DFORK_NEXTENTS(&mp->m_sb, dip, XFS_DATA_FORK);
> +	anextents = XFS_DFORK_NEXTENTS(&mp->m_sb, dip, XFS_ATTR_FORK);
> +	nblocks = be64_to_cpu(dip->di_nblocks);
> +
>  	/* Fork checks carried over from xfs_iformat_fork */
> -	if (mode &&
> -	    be32_to_cpu(dip->di_nextents) + be16_to_cpu(dip->di_anextents) >
> -			be64_to_cpu(dip->di_nblocks))
> +	if (mode && nextents + anextents > nblocks)
>  		return __this_address;
>  
>  	if (mode && XFS_DFORK_BOFF(dip) > mp->m_sb.sb_inodesize)
> @@ -526,7 +537,7 @@ xfs_dinode_verify(
>  		default:
>  			return __this_address;
>  		}
> -		if (dip->di_anextents)
> +		if (XFS_DFORK_NEXTENTS(&mp->m_sb, dip, XFS_ATTR_FORK))
>  			return __this_address;
>  	}
>  
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 518c6f0ec3a61..080fd0c156a1e 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -207,9 +207,10 @@ xfs_iformat_extents(
>  	int			whichfork)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_sb		*sb = &mp->m_sb;
>  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
>  	int			state = xfs_bmap_fork_to_state(whichfork);
> -	int			nex = XFS_DFORK_NEXTENTS(dip, whichfork);
> +	int			nex = XFS_DFORK_NEXTENTS(sb, dip, whichfork);
>  	int			size = nex * sizeof(xfs_bmbt_rec_t);
>  	struct xfs_iext_cursor	icur;
>  	struct xfs_bmbt_rec	*dp;
> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> index e3400c9c71cdb..5db92aa508bc5 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -397,7 +397,7 @@ struct xfs_log_dinode {
>  	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
>  	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
>  	xfs_extnum_t	di_nextents;	/* number of extents in data fork */
> -	xfs_aextnum_t	di_anextents;	/* number of extents in attribute fork*/
> +	uint16_t	di_anextents_lo;/* lower part of xattr extent count */
>  	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
>  	int8_t		di_aformat;	/* format of attr fork's data */
>  	uint32_t	di_dmevmask;	/* DMIG event mask */
> @@ -414,7 +414,8 @@ struct xfs_log_dinode {
>  	xfs_lsn_t	di_lsn;		/* flush sequence */
>  	uint64_t	di_flags2;	/* more random flags */
>  	uint32_t	di_cowextsize;	/* basic cow extent size for file */
> -	uint8_t		di_pad2[12];	/* more padding for future expansion */
> +	uint16_t	di_anextents_hi;/* higher part of xattr extent count */
> +	uint8_t		di_pad2[10];	/* more padding for future expansion */
>  
>  	/* fields only written to during inode creation */
>  	xfs_ictimestamp_t di_crtime;	/* time created */
> diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> index 397d94775440d..01669aa65745a 100644
> --- a/fs/xfs/libxfs/xfs_types.h
> +++ b/fs/xfs/libxfs/xfs_types.h
> @@ -13,7 +13,7 @@ typedef uint32_t	xfs_agino_t;	/* inode # within allocation grp */
>  typedef uint32_t	xfs_extlen_t;	/* extent length in blocks */
>  typedef uint32_t	xfs_agnumber_t;	/* allocation group number */
>  typedef int32_t		xfs_extnum_t;	/* # of extents in a file */
> -typedef int16_t		xfs_aextnum_t;	/* # extents in an attribute fork */
> +typedef int32_t		xfs_aextnum_t;	/* # extents in an attribute fork */
>  typedef int64_t		xfs_fsize_t;	/* bytes in a file */
>  typedef uint64_t	xfs_ufsize_t;	/* unsigned bytes in a file */
>  
> @@ -60,7 +60,7 @@ typedef void *		xfs_failaddr_t;
>   */
>  #define	MAXEXTLEN	((xfs_extlen_t)0x001fffff)	/* 21 bits */
>  #define	MAXEXTNUM	((xfs_extnum_t)0x7fffffff)	/* signed int */
> -#define	MAXAEXTNUM	((xfs_aextnum_t)0x7fff)		/* signed short */
> +#define	MAXAEXTNUM	((xfs_aextnum_t)0x7fffffff)	/* signed int */
>  
>  /*
>   * Minimum and maximum blocksize and sectorsize.
> diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
> index 6d483ab29e639..3b624e24ae868 100644
> --- a/fs/xfs/scrub/inode.c
> +++ b/fs/xfs/scrub/inode.c
> @@ -371,10 +371,12 @@ xchk_dinode(
>  		break;
>  	}
>  
> +	nextents = XFS_DFORK_NEXTENTS(&mp->m_sb, dip, XFS_ATTR_FORK);
> +
>  	/* di_forkoff */
>  	if (XFS_DFORK_APTR(dip) >= (char *)dip + mp->m_sb.sb_inodesize)
>  		xchk_ino_set_corrupt(sc, ino);
> -	if (dip->di_anextents != 0 && dip->di_forkoff == 0)
> +	if (nextents != 0 && dip->di_forkoff == 0)
>  		xchk_ino_set_corrupt(sc, ino);
>  	if (dip->di_forkoff == 0 && dip->di_aformat != XFS_DINODE_FMT_EXTENTS)
>  		xchk_ino_set_corrupt(sc, ino);
> @@ -386,7 +388,6 @@ xchk_dinode(
>  		xchk_ino_set_corrupt(sc, ino);
>  
>  	/* di_anextents */
> -	nextents = be16_to_cpu(dip->di_anextents);
>  	fork_recs =  XFS_DFORK_ASIZE(dip, mp) / sizeof(struct xfs_bmbt_rec);
>  	switch (dip->di_aformat) {
>  	case XFS_DINODE_FMT_EXTENTS:
> @@ -484,7 +485,7 @@ xchk_inode_xref_bmap(
>  			&nextents, &acount);
>  	if (!xchk_should_check_xref(sc, &error, NULL))
>  		return;
> -	if (nextents != be16_to_cpu(dip->di_anextents))
> +	if (nextents != XFS_DFORK_NEXTENTS(&sc->mp->m_sb, dip, XFS_ATTR_FORK))
>  		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
>  
>  	/* Check nblocks against the inode. */
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 4a3d13d4a0228..dff20f2b368ea 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -327,7 +327,7 @@ xfs_inode_to_log_dinode(
>  	to->di_nblocks = from->di_nblocks;
>  	to->di_extsize = from->di_extsize;
>  	to->di_nextents = from->di_nextents;
> -	to->di_anextents = from->di_anextents;
> +	to->di_anextents_lo = ((u32)(from->di_anextents)) & 0xffff;
>  	to->di_forkoff = from->di_forkoff;
>  	to->di_aformat = from->di_aformat;
>  	to->di_dmevmask = from->di_dmevmask;
> @@ -344,6 +344,7 @@ xfs_inode_to_log_dinode(
>  		to->di_crtime.t_nsec = from->di_crtime.tv_nsec;
>  		to->di_flags2 = from->di_flags2;
>  		to->di_cowextsize = from->di_cowextsize;
> +		to->di_anextents_hi = ((u32)(from->di_anextents)) >> 16;
>  		to->di_ino = ip->i_ino;
>  		to->di_lsn = lsn;
>  		memset(to->di_pad2, 0, sizeof(to->di_pad2));
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 11c3502b07b13..ba3fae95b2260 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2922,6 +2922,7 @@ xlog_recover_inode_pass2(
>  	struct xfs_log_dinode	*ldip;
>  	uint			isize;
>  	int			need_free = 0;
> +	uint32_t		nextents;
>  
>  	if (item->ri_buf[0].i_len == sizeof(struct xfs_inode_log_format)) {
>  		in_f = item->ri_buf[0].i_addr;
> @@ -3044,7 +3045,14 @@ xlog_recover_inode_pass2(
>  			goto out_release;
>  		}
>  	}
> -	if (unlikely(ldip->di_nextents + ldip->di_anextents > ldip->di_nblocks)){
> +
> +	nextents = ldip->di_anextents_lo;
> +	if (xfs_sb_version_has_v3inode(&mp->m_sb))
> +		nextents |= ((u32)(ldip->di_anextents_hi) << 16);
> +
> +	nextents += ldip->di_nextents;
> +
> +	if (unlikely(nextents > ldip->di_nblocks)) {
>  		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(5)",
>  				     XFS_ERRLEVEL_LOW, mp, ldip,
>  				     sizeof(*ldip));
> @@ -3052,8 +3060,7 @@ xlog_recover_inode_pass2(
>  	"%s: Bad inode log record, rec ptr "PTR_FMT", dino ptr "PTR_FMT", "
>  	"dino bp "PTR_FMT", ino %Ld, total extents = %d, nblocks = %Ld",
>  			__func__, item, dip, bp, in_f->ilf_ino,
> -			ldip->di_nextents + ldip->di_anextents,
> -			ldip->di_nblocks);
> +			nextents, ldip->di_nblocks);
>  		error = -EFSCORRUPTED;
>  		goto out_release;
>  	}
> -- 
> 2.19.1
> 

