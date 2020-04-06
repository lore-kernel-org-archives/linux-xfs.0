Return-Path: <SRS0=ELsP=5W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA4F0C2BA17
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 17:10:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F2B7248BD
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 17:10:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y+a8eAk5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbgDFRKN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Apr 2020 13:10:13 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60300 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726512AbgDFRKN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Apr 2020 13:10:13 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 036H9uaO068477;
        Mon, 6 Apr 2020 17:10:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=bn4g95y7fXOipmVUerZOJeLvvQDnViFh4yxqutepTmk=;
 b=Y+a8eAk5ft0svD8ZVmmQjOfD3683QgliJdSGhmN8VI3iG2tS5QcSV3I/4l1/kyw0IMvW
 n+CC5qHfMN2kv4nbhSb7tXWfkxY8RYwLqQypIoPgLZdvAJyCgHAktMksgWZ8QLFURS+v
 MeOLj8V03WkSVyrFpcP6139FlgJzSASDQTOiYCcT/2+xL/oP1IIeazSxHD6AV3wQmm8w
 L/wm0Q9tkSDSqhWhX8knnhZTGnfNoir/QcdX6a1QacLM+9ibhvIA/TqrEea/VLtlbsAU
 b6/grv1xzTa2pbAPIU4xZnBbryPLAuex37g3RQvlumeXl089FMcTrMKEkI80oc0E9uF8 oQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 306j6m86mr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Apr 2020 17:10:02 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 036H2c72156012;
        Mon, 6 Apr 2020 17:08:01 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 3073sqac79-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Apr 2020 17:08:01 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 036H81ga027993;
        Mon, 6 Apr 2020 17:08:01 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 06 Apr 2020 10:08:00 -0700
Date:   Mon, 6 Apr 2020 10:07:59 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Rajendra <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        chandan@linux.ibm.com, bfoster@redhat.com
Subject: Re: [PATCH 2/2] xfsprogs: Extend attr extent counter to 32-bits
Message-ID: <20200406170759.GE6742@magnolia>
References: <20200404085229.2034-1-chandanrlinux@gmail.com>
 <20200404085229.2034-3-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200404085229.2034-3-chandanrlinux@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9583 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 spamscore=0
 malwarescore=0 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004060136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9583 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 spamscore=0
 priorityscore=1501 suspectscore=0 lowpriorityscore=0 malwarescore=0
 impostorscore=0 mlxscore=0 phishscore=0 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004060136
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Apr 04, 2020 at 02:22:29PM +0530, Chandan Rajendra wrote:
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
> Hence this commit extends xattr extent counter to 32-bits. It also
> introduces an incompat flag to prevent older kernels from mounting
> newer filesystems with 32-bit wide xattr extent counter.
> 
> Signed-off-by: Chandan Rajendra <chandanrlinux@gmail.com>
> ---
>  db/bmap.c                |  4 ++--
>  db/btdump.c              |  2 +-
>  db/check.c               |  3 ++-
>  db/field.c               |  2 --
>  db/field.h               |  1 -
>  db/frag.c                |  6 ++++--
>  db/inode.c               | 10 ++++++----
>  db/metadump.c            |  4 ++--

Ooh, xfsprogs patches, thank yoU! :)


>  libxfs/xfs_format.h      | 32 ++++++++++++++++++++++++--------
>  libxfs/xfs_inode_buf.c   | 28 ++++++++++++++++++++--------
>  libxfs/xfs_inode_fork.c  |  3 ++-
>  libxfs/xfs_log_format.h  |  5 +++--
>  libxfs/xfs_types.h       |  4 ++--
>  logprint/log_misc.c      |  9 ++++++++-
>  logprint/log_print_all.c |  9 ++++++++-
>  mkfs/xfs_mkfs.c          |  1 +
>  repair/attr_repair.c     |  2 +-
>  repair/dinode.c          | 29 ++++++++++++++++++-----------
>  18 files changed, 104 insertions(+), 50 deletions(-)
> 
> diff --git a/db/bmap.c b/db/bmap.c
> index fdc70e95..2407a597 100644
> --- a/db/bmap.c
> +++ b/db/bmap.c
> @@ -68,7 +68,7 @@ bmap(
>  	ASSERT(fmt == XFS_DINODE_FMT_LOCAL || fmt == XFS_DINODE_FMT_EXTENTS ||
>  		fmt == XFS_DINODE_FMT_BTREE);
>  	if (fmt == XFS_DINODE_FMT_EXTENTS) {
> -		nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
> +		nextents = XFS_DFORK_NEXTENTS(&mp->m_sb, dip, whichfork);
>  		xp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
>  		for (ep = xp; ep < &xp[nextents] && n < nex; ep++) {
>  			if (!bmap_one_extent(ep, &curoffset, eoffset, &n, bep))
> @@ -160,7 +160,7 @@ bmap_f(
>  		dip = iocur_top->data;
>  		if (be32_to_cpu(dip->di_nextents))
>  			dfork = 1;
> -		if (be16_to_cpu(dip->di_anextents))
> +		if (XFS_DFORK_NEXTENTS(&mp->m_sb, dip, XFS_ATTR_FORK))
>  			afork = 1;
>  		pop_cur();
>  	}
> diff --git a/db/btdump.c b/db/btdump.c
> index 920f595b..549fe5b3 100644
> --- a/db/btdump.c
> +++ b/db/btdump.c
> @@ -166,7 +166,7 @@ dump_inode(
>  
>  	dip = iocur_top->data;
>  	if (attrfork) {
> -		if (!dip->di_anextents ||
> +		if (!XFS_DFORK_NEXTENTS(&mp->m_sb, dip, XFS_ATTR_FORK) ||
>  		    dip->di_aformat != XFS_DINODE_FMT_BTREE) {
>  			dbprintf(_("attr fork not in btree format\n"));
>  			return 0;
> diff --git a/db/check.c b/db/check.c
> index 3b713bdc..678557fa 100644
> --- a/db/check.c
> +++ b/db/check.c
> @@ -2643,7 +2643,7 @@ process_exinode(
>  	xfs_bmbt_rec_t		*rp;
>  
>  	rp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
> -	*nex = XFS_DFORK_NEXTENTS(dip, whichfork);
> +	*nex = XFS_DFORK_NEXTENTS(&mp->m_sb, dip, whichfork);
>  	if (*nex < 0 || *nex > XFS_DFORK_SIZE(dip, mp, whichfork) /
>  						sizeof(xfs_bmbt_rec_t)) {
>  		if (!sflag || id->ilist)
> @@ -2707,6 +2707,7 @@ process_inode(
>  		"dev", "local", "extents", "btree", "uuid"
>  	};
>  
> +	xino.i_mount = mp;
>  	libxfs_inode_from_disk(&xino, dip);
>  
>  	ino = XFS_AGINO_TO_INO(mp, be32_to_cpu(agf->agf_seqno), agino);
> diff --git a/db/field.c b/db/field.c
> index aa0154d8..bbec8356 100644
> --- a/db/field.c
> +++ b/db/field.c
> @@ -25,8 +25,6 @@
>  #include "symlink.h"
>  
>  const ftattr_t	ftattrtab[] = {
> -	{ FLDT_AEXTNUM, "aextnum", fp_num, "%d", SI(bitsz(xfs_aextnum_t)),
> -	  FTARG_SIGNED, NULL, NULL },
>  	{ FLDT_AGBLOCK, "agblock", fp_num, "%u", SI(bitsz(xfs_agblock_t)),
>  	  FTARG_DONULL, fa_agblock, NULL },
>  	{ FLDT_AGBLOCKNZ, "agblocknz", fp_num, "%u", SI(bitsz(xfs_agblock_t)),
> diff --git a/db/field.h b/db/field.h
> index 15065373..9e181d7a 100644
> --- a/db/field.h
> +++ b/db/field.h
> @@ -5,7 +5,6 @@
>   */
>  
>  typedef enum fldt	{
> -	FLDT_AEXTNUM,
>  	FLDT_AGBLOCK,
>  	FLDT_AGBLOCKNZ,
>  	FLDT_AGF,
> diff --git a/db/frag.c b/db/frag.c
> index 1cfc6c2c..16556a63 100644
> --- a/db/frag.c
> +++ b/db/frag.c
> @@ -262,9 +262,11 @@ process_exinode(
>  	int			whichfork)
>  {
>  	xfs_bmbt_rec_t		*rp;
> +	int			nextents;
>  
>  	rp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
> -	process_bmbt_reclist(rp, XFS_DFORK_NEXTENTS(dip, whichfork), extmapp);
> +	nextents = XFS_DFORK_NEXTENTS(&mp->m_sb, dip, whichfork);
> +	process_bmbt_reclist(rp, nextents, extmapp);
>  }
>  
>  static void
> @@ -275,7 +277,7 @@ process_fork(
>  	extmap_t	*extmap;
>  	int		nex;
>  
> -	nex = XFS_DFORK_NEXTENTS(dip, whichfork);
> +	nex = XFS_DFORK_NEXTENTS(&mp->m_sb, dip, whichfork);
>  	if (!nex)
>  		return;
>  	extmap = extmap_alloc(nex);
> diff --git a/db/inode.c b/db/inode.c
> index 0cff9d63..802231c2 100644
> --- a/db/inode.c
> +++ b/db/inode.c
> @@ -101,7 +101,7 @@ const field_t	inode_core_flds[] = {
>  	{ "nblocks", FLDT_DRFSBNO, OI(COFF(nblocks)), C1, 0, TYP_NONE },
>  	{ "extsize", FLDT_EXTLEN, OI(COFF(extsize)), C1, 0, TYP_NONE },
>  	{ "nextents", FLDT_EXTNUM, OI(COFF(nextents)), C1, 0, TYP_NONE },
> -	{ "naextents", FLDT_AEXTNUM, OI(COFF(anextents)), C1, 0, TYP_NONE },
> +	{ "naextents_lo", FLDT_UINT16D, OI(COFF(anextents_lo)), C1, 0, TYP_NONE },
>  	{ "forkoff", FLDT_UINT8D, OI(COFF(forkoff)), C1, 0, TYP_NONE },
>  	{ "aformat", FLDT_DINODE_FMT, OI(COFF(aformat)), C1, 0, TYP_NONE },
>  	{ "dmevmask", FLDT_UINT32X, OI(COFF(dmevmask)), C1, 0, TYP_NONE },
> @@ -162,6 +162,7 @@ const field_t	inode_v3_flds[] = {
>  	{ "lsn", FLDT_UINT64X, OI(COFF(lsn)), C1, 0, TYP_NONE },
>  	{ "flags2", FLDT_UINT64X, OI(COFF(flags2)), C1, 0, TYP_NONE },
>  	{ "cowextsize", FLDT_EXTLEN, OI(COFF(cowextsize)), C1, 0, TYP_NONE },
> +	{ "naextents_hi", FLDT_UINT16D, OI(COFF(anextents_hi)), C1, 0, TYP_NONE },
>  	{ "pad2", FLDT_UINT8X, OI(OFF(pad2)), CI(12), FLD_ARRAY|FLD_SKIPALL, TYP_NONE },
>  	{ "crtime", FLDT_TIMESTAMP, OI(COFF(crtime)), C1, 0, TYP_NONE },
>  	{ "inumber", FLDT_INO, OI(COFF(ino)), C1, 0, TYP_NONE },
> @@ -271,7 +272,7 @@ inode_a_bmx_count(
>  		return 0;
>  	ASSERT((char *)XFS_DFORK_APTR(dip) - (char *)dip == byteize(startoff));
>  	return dip->di_aformat == XFS_DINODE_FMT_EXTENTS ?
> -		be16_to_cpu(dip->di_anextents) : 0;
> +		XFS_DFORK_NEXTENTS(&mp->m_sb, dip, XFS_ATTR_FORK) : 0;
>  }
>  
>  static int
> @@ -325,6 +326,7 @@ inode_a_size(
>  {
>  	xfs_attr_shortform_t	*asf;
>  	xfs_dinode_t		*dip;
> +	int 			nextents;
>  
>  	ASSERT(startoff == 0);
>  	ASSERT(idx == 0);
> @@ -334,8 +336,8 @@ inode_a_size(
>  		asf = (xfs_attr_shortform_t *)XFS_DFORK_APTR(dip);
>  		return bitize(be16_to_cpu(asf->hdr.totsize));
>  	case XFS_DINODE_FMT_EXTENTS:
> -		return (int)be16_to_cpu(dip->di_anextents) *
> -							bitsz(xfs_bmbt_rec_t);
> +		nextents = XFS_DFORK_NEXTENTS(&mp->m_sb, dip, XFS_ATTR_FORK);
> +		return nextents * bitsz(xfs_bmbt_rec_t);
>  	case XFS_DINODE_FMT_BTREE:
>  		return bitize((int)XFS_DFORK_ASIZE(dip, mp));
>  	default:
> diff --git a/db/metadump.c b/db/metadump.c
> index d542762e..182198eb 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -2282,7 +2282,7 @@ process_exinode(
>  
>  	whichfork = (itype == TYP_ATTR) ? XFS_ATTR_FORK : XFS_DATA_FORK;
>  
> -	nex = XFS_DFORK_NEXTENTS(dip, whichfork);
> +	nex = XFS_DFORK_NEXTENTS(&mp->m_sb, dip, whichfork);
>  	used = nex * sizeof(xfs_bmbt_rec_t);
>  	if (nex < 0 || used > XFS_DFORK_SIZE(dip, mp, whichfork)) {
>  		if (show_warnings)
> @@ -2335,7 +2335,7 @@ static int
>  process_dev_inode(
>  	xfs_dinode_t		*dip)
>  {
> -	if (XFS_DFORK_NEXTENTS(dip, XFS_DATA_FORK)) {
> +	if (XFS_DFORK_NEXTENTS(&mp->m_sb, dip, XFS_DATA_FORK)) {
>  		if (show_warnings)
>  			print_warning("inode %llu has unexpected extents",
>  				      (unsigned long long)cur_ino);
> diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
> index e856e54c..61c3df6a 100644
> --- a/libxfs/xfs_format.h
> +++ b/libxfs/xfs_format.h
> @@ -465,10 +465,13 @@ xfs_sb_has_ro_compat_feature(
>  #define XFS_SB_FEAT_INCOMPAT_FTYPE	(1 << 0)	/* filetype in dirent */
>  #define XFS_SB_FEAT_INCOMPAT_SPINODES	(1 << 1)	/* sparse inode chunks */
>  #define XFS_SB_FEAT_INCOMPAT_META_UUID	(1 << 2)	/* metadata UUID */
> -#define XFS_SB_FEAT_INCOMPAT_ALL \
> +#define XFS_SB_FEAT_INCOMPAT_32BIT_AEXT_CNTR (1 << 3)
> +#define XFS_SB_FEAT_INCOMPAT_ALL		\
>  		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
>  		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
> -		 XFS_SB_FEAT_INCOMPAT_META_UUID)
> +		 XFS_SB_FEAT_INCOMPAT_META_UUID | \
> +		 XFS_SB_FEAT_INCOMPAT_32BIT_AEXT_CNTR)
> +
>  
>  #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
>  static inline bool
> @@ -866,7 +869,7 @@ typedef struct xfs_dinode {
>  	__be64		di_nblocks;	/* # of direct & btree blocks used */
>  	__be32		di_extsize;	/* basic/minimum extent size for file */
>  	__be32		di_nextents;	/* number of extents in data fork */
> -	__be16		di_anextents;	/* number of extents in attribute fork*/
> +	__be16		di_anextents_lo;	/* number of extents in attribute fork*/
>  	__u8		di_forkoff;	/* attr fork offs, <<3 for 64b align */
>  	__s8		di_aformat;	/* format of attr fork's data */
>  	__be32		di_dmevmask;	/* DMIG event mask */
> @@ -883,7 +886,8 @@ typedef struct xfs_dinode {
>  	__be64		di_lsn;		/* flush sequence */
>  	__be64		di_flags2;	/* more random flags */
>  	__be32		di_cowextsize;	/* basic cow extent size for file */
> -	__u8		di_pad2[12];	/* more padding for future expansion */
> +	__be16		di_anextents_hi;
> +	__u8		di_pad2[10];	/* more padding for future expansion */
>  
>  	/* fields only written to during inode creation */
>  	xfs_timestamp_t	di_crtime;	/* time created */
> @@ -985,10 +989,22 @@ enum xfs_dinode_fmt {
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
> +        int32_t anextents;
> +
> +        if (whichfork == XFS_DATA_FORK)
> +                return be32_to_cpu((dip)->di_nextents);
> +
> +        anextents = be16_to_cpu((dip)->di_anextents_lo);
> +        if (xfs_sb_version_hascrc(sbp))
> +                anextents |=
> +			((uint32_t)(be16_to_cpu((dip)->di_anextents_hi)) << 16);
> +
> +        return anextents;
> +}
>  
>  /*
>   * For block and character special files the 32bit dev_t is stored at the
> diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
> index 4c90e198..815cc944 100644
> --- a/libxfs/xfs_inode_buf.c
> +++ b/libxfs/xfs_inode_buf.c
> @@ -241,7 +241,8 @@ xfs_inode_from_disk(
>  	to->di_nblocks = be64_to_cpu(from->di_nblocks);
>  	to->di_extsize = be32_to_cpu(from->di_extsize);
>  	to->di_nextents = be32_to_cpu(from->di_nextents);
> -	to->di_anextents = be16_to_cpu(from->di_anextents);
> +	to->di_anextents = XFS_DFORK_NEXTENTS(&ip->i_mount->m_sb, from,
> +				XFS_ATTR_FORK);
>  	to->di_forkoff = from->di_forkoff;
>  	to->di_aformat	= from->di_aformat;
>  	to->di_dmevmask	= be32_to_cpu(from->di_dmevmask);
> @@ -292,7 +293,8 @@ xfs_inode_to_disk(
>  	to->di_nblocks = cpu_to_be64(from->di_nblocks);
>  	to->di_extsize = cpu_to_be32(from->di_extsize);
>  	to->di_nextents = cpu_to_be32(from->di_nextents);
> -	to->di_anextents = cpu_to_be16(from->di_anextents);
> +	to->di_anextents_lo =
> +		cpu_to_be16((uint32_t)(from->di_anextents) & 0xffff);
>  	to->di_forkoff = from->di_forkoff;
>  	to->di_aformat = from->di_aformat;
>  	to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
> @@ -305,6 +307,8 @@ xfs_inode_to_disk(
>  		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.tv_nsec);
>  		to->di_flags2 = cpu_to_be64(from->di_flags2);
>  		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
> +		to->di_anextents_hi =
> +			cpu_to_be16((uint32_t)(from->di_anextents) >> 16);
>  		to->di_ino = cpu_to_be64(ip->i_ino);
>  		to->di_lsn = cpu_to_be64(lsn);
>  		memset(to->di_pad2, 0, sizeof(to->di_pad2));
> @@ -343,7 +347,7 @@ xfs_log_dinode_to_disk(
>  	to->di_nblocks = cpu_to_be64(from->di_nblocks);
>  	to->di_extsize = cpu_to_be32(from->di_extsize);
>  	to->di_nextents = cpu_to_be32(from->di_nextents);
> -	to->di_anextents = cpu_to_be16(from->di_anextents);
> +	to->di_anextents_lo = cpu_to_be16(from->di_anextents_lo);
>  	to->di_forkoff = from->di_forkoff;
>  	to->di_aformat = from->di_aformat;
>  	to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
> @@ -357,6 +361,7 @@ xfs_log_dinode_to_disk(
>  		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.t_nsec);
>  		to->di_flags2 = cpu_to_be64(from->di_flags2);
>  		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
> +		to->di_anextents_hi = cpu_to_be16(from->di_anextents_hi);
>  		to->di_ino = cpu_to_be64(from->di_ino);
>  		to->di_lsn = cpu_to_be64(from->di_lsn);
>  		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
> @@ -373,7 +378,9 @@ xfs_dinode_verify_fork(
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
> @@ -444,6 +451,9 @@ xfs_dinode_verify(
>  	uint16_t		flags;
>  	uint64_t		flags2;
>  	uint64_t		di_size;
> +	int32_t			nextents;
> +	int32_t			anextents;
> +	int64_t			nblocks;
>  
>  	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))
>  		return __this_address;
> @@ -474,10 +484,12 @@ xfs_dinode_verify(
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
> @@ -534,7 +546,7 @@ xfs_dinode_verify(
>  		default:
>  			return __this_address;
>  		}
> -		if (dip->di_anextents)
> +		if (XFS_DFORK_NEXTENTS(&mp->m_sb, dip, XFS_ATTR_FORK))
>  			return __this_address;
>  	}
>  
> diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
> index a4b5686e..deb04b35 100644
> --- a/libxfs/xfs_inode_fork.c
> +++ b/libxfs/xfs_inode_fork.c
> @@ -205,9 +205,10 @@ xfs_iformat_extents(
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
> diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
> index 8ef31d71..0e18989d 100644
> --- a/libxfs/xfs_log_format.h
> +++ b/libxfs/xfs_log_format.h
> @@ -397,7 +397,7 @@ struct xfs_log_dinode {
>  	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
>  	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
>  	xfs_extnum_t	di_nextents;	/* number of extents in data fork */
> -	xfs_aextnum_t	di_anextents;	/* number of extents in attribute fork*/
> +	uint16_t	di_anextents_lo;	/* number of extents in attribute fork*/
>  	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
>  	int8_t		di_aformat;	/* format of attr fork's data */
>  	uint32_t	di_dmevmask;	/* DMIG event mask */
> @@ -414,7 +414,8 @@ struct xfs_log_dinode {
>  	xfs_lsn_t	di_lsn;		/* flush sequence */
>  	uint64_t	di_flags2;	/* more random flags */
>  	uint32_t	di_cowextsize;	/* basic cow extent size for file */
> -	uint8_t		di_pad2[12];	/* more padding for future expansion */
> +	uint16_t	di_anextents_hi;
> +	uint8_t		di_pad2[10];	/* more padding for future expansion */
>  
>  	/* fields only written to during inode creation */
>  	xfs_ictimestamp_t di_crtime;	/* time created */
> diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
> index a2005e2d..f5e73c20 100644
> --- a/libxfs/xfs_types.h
> +++ b/libxfs/xfs_types.h
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
> diff --git a/logprint/log_misc.c b/logprint/log_misc.c
> index 45f697fc..080941a0 100644
> --- a/logprint/log_misc.c
> +++ b/logprint/log_misc.c
> @@ -440,6 +440,8 @@ static void
>  xlog_print_trans_inode_core(
>  	struct xfs_log_dinode	*ip)
>  {
> +    uint32_t naextents;
> +
>      printf(_("INODE CORE\n"));
>      printf(_("magic 0x%hx mode 0%ho version %d format %d\n"),
>  	   ip->di_magic, ip->di_mode, (int)ip->di_version,
> @@ -451,8 +453,13 @@ xlog_print_trans_inode_core(
>      printf(_("size 0x%llx nblocks 0x%llx extsize 0x%x nextents 0x%x\n"),
>  	   (unsigned long long)ip->di_size, (unsigned long long)ip->di_nblocks,
>  	   ip->di_extsize, ip->di_nextents);
> +
> +    naextents = ip->di_anextents_lo;
> +    if (ip->di_version == 3)
> +	    naextents |= ((uint32_t)(ip->di_anextents_hi) << 16);
> +
>      printf(_("naextents 0x%x forkoff %d dmevmask 0x%x dmstate 0x%hx\n"),
> -	   ip->di_anextents, (int)ip->di_forkoff, ip->di_dmevmask,
> +	   naextents, (int)ip->di_forkoff, ip->di_dmevmask,
>  	   ip->di_dmstate);
>      printf(_("flags 0x%x gen 0x%x\n"),
>  	   ip->di_flags, ip->di_gen);
> diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
> index d3d4c07b..8f4ffe2a 100644
> --- a/logprint/log_print_all.c
> +++ b/logprint/log_print_all.c
> @@ -240,6 +240,8 @@ STATIC void
>  xlog_recover_print_inode_core(
>  	struct xfs_log_dinode	*di)
>  {
> +	uint32_t anextents;
> +
>  	printf(_("	CORE inode:\n"));
>  	if (!print_inode)
>  		return;
> @@ -252,10 +254,15 @@ xlog_recover_print_inode_core(
>  	printf(_("		atime:%d  mtime:%d  ctime:%d\n"),
>  	       di->di_atime.t_sec, di->di_mtime.t_sec, di->di_ctime.t_sec);
>  	printf(_("		flushiter:%d\n"), di->di_flushiter);
> +
> +	anextents = di->di_anextents_lo;
> +	if (di->di_version == 3)
> +		anextents |= ((uint32_t)(di->di_anextents_hi) << 16);
> +
>  	printf(_("		size:0x%llx  nblks:0x%llx  exsize:%d  "
>  	     "nextents:%d  anextents:%d\n"), (unsigned long long)
>  	       di->di_size, (unsigned long long)di->di_nblocks,
> -	       di->di_extsize, di->di_nextents, (int)di->di_anextents);
> +		di->di_extsize, di->di_nextents, (int)anextents);
>  	printf(_("		forkoff:%d  dmevmask:0x%x  dmstate:%d  flags:0x%x  "
>  	     "gen:%u\n"),
>  	       (int)di->di_forkoff, di->di_dmevmask, (int)di->di_dmstate,
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 606f79da..9be87ef8 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3018,6 +3018,7 @@ sb_set_features(
>  		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_SPINODES;
>  	}
>  
> +	sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_32BIT_AEXT_CNTR;

Please don't enable incompat features unconditionally and silently.

--D

>  }
>  
>  /*
> diff --git a/repair/attr_repair.c b/repair/attr_repair.c
> index 9a44f610..2e4bcc68 100644
> --- a/repair/attr_repair.c
> +++ b/repair/attr_repair.c
> @@ -983,7 +983,7 @@ process_longform_attr(
>  
>  	if ( bno == NULLFSBLOCK ) {
>  		if (dip->di_aformat == XFS_DINODE_FMT_EXTENTS &&
> -				be16_to_cpu(dip->di_anextents) == 0)
> +			XFS_DFORK_NEXTENTS(&mp->m_sb, dip, XFS_ATTR_FORK) == 0)
>  			return(0); /* the kernel can handle this state */
>  		do_warn(
>  	_("block 0 of inode %" PRIu64 " attribute fork is missing\n"),
> diff --git a/repair/dinode.c b/repair/dinode.c
> index 8af2cb25..7247e10a 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -68,10 +68,12 @@ _("clearing inode %" PRIu64 " attributes\n"), ino_num);
>  		fprintf(stderr,
>  _("would have cleared inode %" PRIu64 " attributes\n"), ino_num);
>  
> -	if (be16_to_cpu(dino->di_anextents) != 0)  {
> +	if (XFS_DFORK_NEXTENTS(&mp->m_sb, dino, XFS_ATTR_FORK) != 0)  {
>  		if (no_modify)
>  			return(1);
> -		dino->di_anextents = cpu_to_be16(0);
> +		dino->di_anextents_lo = cpu_to_be16(0);
> +		if (dino->di_version == 3)
> +			dino->di_anextents_hi = cpu_to_be16(0);
>  	}
>  
>  	if (dino->di_aformat != XFS_DINODE_FMT_EXTENTS)  {
> @@ -999,7 +1001,7 @@ process_exinode(
>  	lino = XFS_AGINO_TO_INO(mp, agno, ino);
>  	rp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
>  	*tot = 0;
> -	numrecs = XFS_DFORK_NEXTENTS(dip, whichfork);
> +	numrecs = XFS_DFORK_NEXTENTS(&mp->m_sb, dip, whichfork);
>  
>  	/*
>  	 * We've already decided on the maximum number of extents on the inode,
> @@ -1836,6 +1838,7 @@ _("bad attr fork offset %d in inode %" PRIu64 ", max=%d\n"),
>   */
>  static int
>  process_inode_blocks_and_extents(
> +	xfs_mount_t	*mp,
>  	xfs_dinode_t	*dino,
>  	xfs_rfsblock_t	nblocks,
>  	uint64_t	nextents,
> @@ -1843,6 +1846,8 @@ process_inode_blocks_and_extents(
>  	xfs_ino_t	lino,
>  	int		*dirty)
>  {
> +	int32_t		anextents_disk;
> +
>  	if (nblocks != be64_to_cpu(dino->di_nblocks))  {
>  		if (!no_modify)  {
>  			do_warn(
> @@ -1888,19 +1893,21 @@ _("too many attr fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
>  			anextents, lino);
>  		return 1;
>  	}
> -	if (anextents != be16_to_cpu(dino->di_anextents))  {
> +
> +	anextents_disk = XFS_DFORK_NEXTENTS(&mp->m_sb, dino, XFS_ATTR_FORK);
> +	if (anextents != anextents_disk)  {
>  		if (!no_modify)  {
>  			do_warn(
>  _("correcting anextents for inode %" PRIu64 ", was %d - counted %" PRIu64 "\n"),
> -				lino,
> -				be16_to_cpu(dino->di_anextents), anextents);
> -			dino->di_anextents = cpu_to_be16(anextents);
> +				lino, anextents_disk, anextents);
> +			dino->di_anextents_lo = cpu_to_be16(anextents & 0xffff);
> +			if (dino->di_version == 3)
> +				dino->di_anextents_hi = cpu_to_be16(anextents >> 16);
>  			*dirty = 1;
>  		} else  {
>  			do_warn(
>  _("bad anextents %d for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
> -				be16_to_cpu(dino->di_anextents),
> -				lino, anextents);
> +				anextents_disk, lino, anextents);
>  		}
>  	}
>  
> @@ -2063,7 +2070,7 @@ process_inode_attr_fork(
>  		return 0;
>  	}
>  
> -	*anextents = be16_to_cpu(dino->di_anextents);
> +	*anextents = XFS_DFORK_NEXTENTS(&mp->m_sb, dino, XFS_ATTR_FORK);
>  	if (*anextents > be64_to_cpu(dino->di_nblocks))
>  		*anextents = 1;
>  
> @@ -2803,7 +2810,7 @@ _("Bad CoW extent size %u on inode %" PRIu64 ", "),
>  	/*
>  	 * correct space counters if required
>  	 */
> -	if (process_inode_blocks_and_extents(dino, totblocks + atotblocks,
> +	if (process_inode_blocks_and_extents(mp, dino, totblocks + atotblocks,
>  			nextents, anextents, lino, dirty) != 0)
>  		goto clear_bad_out;
>  
> -- 
> 2.19.1
> 
