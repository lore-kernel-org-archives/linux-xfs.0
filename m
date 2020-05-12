Return-Path: <SRS0=k9vQ=62=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEF8DCA90AF
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 17:22:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D442205ED
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 17:22:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LZxwk4Bc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgELRWq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 May 2020 13:22:46 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53404 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726287AbgELRWp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 May 2020 13:22:45 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04CHD4IY161349;
        Tue, 12 May 2020 17:22:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=bv/BG+KnIHut8Uml8nxNGvi5Cl+IiXmkKLiA9vP8Fyo=;
 b=LZxwk4BcaHOnZyCD4tf8Ogflinihjf8GxKMmtJQkhpeIiCIRVYsEixKhTKaaQVU5IAqI
 GFtDabIiD1KEjNCaIf0jq47HMxz1wutpZPY4xz5s/3JVWOw73IEJIT3miAzNnsFM1tl0
 EuQxHbKagF1V3X8L4a5oD9NTib9e5M7+JrJm3Nap18F88bMx+FEqp2kpzIE61USPsBjR
 LLYdJ5i1hKjGBVoj/vpExNFrpbFg29MaqCg5aoXbj7TV1Grkb5/yfSJqwsBSEww3racD
 67H1a+45hUGRDAagCrM4E+Nn7AxaY1VljKS8neYg2/FeeFAO5GD1Rp3DcgTvi/D+O9HZ aQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 30x3gsmc2m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 May 2020 17:22:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04CHEPJ7187086;
        Tue, 12 May 2020 17:20:12 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 30x69tnsxv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 May 2020 17:20:10 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04CHK9sQ001368;
        Tue, 12 May 2020 17:20:10 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 May 2020 10:20:08 -0700
Date:   Tue, 12 May 2020 10:20:07 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfsprogs: remove the libxfs_* API redirections
Message-ID: <20200512172007.GI6714@magnolia>
References: <20200512170303.1949761-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512170303.1949761-1-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 adultscore=0
 spamscore=0 suspectscore=7 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005120132
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 clxscore=1015 bulkscore=0 phishscore=0
 suspectscore=7 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005120132
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 12, 2020 at 07:03:03PM +0200, Christoph Hellwig wrote:
> For historical reasons xfsprogs tries to renamed xfs_* symbols used
> by tools (but not those used inside libxfs) to libxfs_.  Remove this
> indirection to make it clear what function is being called, and to
> avoid having to keep the renaming header uptodate.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  copy/xfs_copy.c              |  10 +-
>  db/agfl.c                    |   2 +-
>  db/attrset.c                 |  28 +--
>  db/bmap.c                    |   4 +-
>  db/bmroot.c                  |   4 +-
>  db/btdump.c                  |  18 +-
>  db/btheight.c                |  14 +-
>  db/check.c                   |  40 ++--
>  db/dir2.c                    |  10 +-
>  db/dir2sf.c                  |   8 +-
>  db/frag.c                    |   2 +-
>  db/freesp.c                  |   6 +-
>  db/fsmap.c                   |  16 +-
>  db/hash.c                    |   2 +-
>  db/info.c                    |  12 +-
>  db/init.c                    |   8 +-
>  db/inode.c                   |   4 +-
>  db/io.c                      |  12 +-
>  db/logformat.c               |   2 +-
>  db/metadump.c                |  34 ++--
>  db/sb.c                      |  10 +-
>  include/cache.h              |   2 +-
>  include/libxfs.h             |   7 +-
>  include/xfs_inode.h          |   8 +-
>  include/xfs_trans.h          |  48 ++---
>  io/open.c                    |   2 +-
>  libxfs/Makefile              |   1 -
>  libxfs/cache.c               |   2 +-
>  libxfs/init.c                |  16 +-
>  libxfs/libxfs_api_defs.h     | 191 ------------------
>  libxfs/libxfs_io.h           |  30 +--
>  libxfs/libxfs_priv.h         |   7 +-
>  libxfs/rdwr.c                |  66 +++----
>  libxfs/trans.c               |  78 ++++----
>  libxfs/util.c                |   8 +-
>  libxlog/xfs_log_recover.c    |  28 +--
>  logprint/log_misc.c          |   4 +-
>  logprint/log_print_all.c     |   2 +-
>  logprint/logprint.c          |   2 +-
>  mdrestore/xfs_mdrestore.c    |   4 +-
>  mkfs/proto.c                 | 112 +++++------
>  mkfs/xfs_mkfs.c              |  86 ++++----
>  repair/agheader.c            |  10 +-
>  repair/attr_repair.c         |  46 +++--
>  repair/da_util.c             |  36 ++--
>  repair/dino_chunks.c         |  20 +-
>  repair/dinode.c              |  40 ++--
>  repair/dir2.c                |  88 ++++-----
>  repair/phase3.c              |   6 +-
>  repair/phase4.c              |  12 +-
>  repair/phase5.c              | 128 ++++++------
>  repair/phase6.c              | 366 +++++++++++++++++------------------
>  repair/phase7.c              |  10 +-
>  repair/prefetch.c            |  18 +-
>  repair/rmap.c                |  72 +++----
>  repair/rt.c                  |  10 +-
>  repair/sb.c                  |  10 +-
>  repair/scan.c                |  46 ++---
>  repair/xfs_repair.c          |  18 +-
>  tools/find-api-violations.sh |  45 -----
>  60 files changed, 844 insertions(+), 1087 deletions(-)
>  delete mode 100644 libxfs/libxfs_api_defs.h
>  delete mode 100755 tools/find-api-violations.sh

This tool also checks for error sign inversion mistakes, so please don't
remove it unless you're also planning to convert all the programs to use
negative error codes like libxfs does.

--D

> diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
> index 2d087f71..1dacb35a 100644
> --- a/copy/xfs_copy.c
> +++ b/copy/xfs_copy.c
> @@ -711,7 +711,7 @@ main(int argc, char **argv)
>  
>  	/* We don't yet know the sector size, so read maximal size */
>  	libxfs_buftarg_init(&mbuf, xargs.ddev, xargs.logdev, xargs.rtdev);
> -	error = -libxfs_buf_read_uncached(mbuf.m_ddev_targp, XFS_SB_DADDR,
> +	error = -xfs_buf_read_uncached(mbuf.m_ddev_targp, XFS_SB_DADDR,
>  			1 << (XFS_MAX_SECTORSIZE_LOG - BBSHIFT), 0, &sbp, NULL);
>  	if (error) {
>  		do_log(_("%s: couldn't read superblock, error=%d\n"),
> @@ -720,12 +720,12 @@ main(int argc, char **argv)
>  	}
>  
>  	sb = &mbuf.m_sb;
> -	libxfs_sb_from_disk(sb, sbp->b_addr);
> +	xfs_sb_from_disk(sb, sbp->b_addr);
>  
>  	/* Do it again, now with proper length and verifier */
> -	libxfs_buf_relse(sbp);
> +	xfs_buf_relse(sbp);
>  
> -	error = -libxfs_buf_read(mbuf.m_ddev_targp, XFS_SB_DADDR,
> +	error = -xfs_buf_read(mbuf.m_ddev_targp, XFS_SB_DADDR,
>  			1 << (sb->sb_sectlog - BBSHIFT), 0, &sbp,
>  			&xfs_sb_buf_ops);
>  	if (error) {
> @@ -733,7 +733,7 @@ main(int argc, char **argv)
>  				progname, error);
>  		exit(1);
>  	}
> -	libxfs_buf_relse(sbp);
> +	xfs_buf_relse(sbp);
>  
>  	mp = libxfs_mount(&mbuf, sb, xargs.ddev, xargs.logdev, xargs.rtdev, 0);
>  	if (mp == NULL) {
> diff --git a/db/agfl.c b/db/agfl.c
> index f0f3f21a..2b9bff2a 100644
> --- a/db/agfl.c
> +++ b/db/agfl.c
> @@ -58,7 +58,7 @@ agfl_bno_size(
>  	void	*obj,
>  	int	startoff)
>  {
> -	return libxfs_agfl_size(mp);
> +	return xfs_agfl_size(mp);
>  }
>  
>  static void
> diff --git a/db/attrset.c b/db/attrset.c
> index b86ecec7..f7e50720 100644
> --- a/db/attrset.c
> +++ b/db/attrset.c
> @@ -84,16 +84,16 @@ attr_set_f(
>  		switch (c) {
>  		/* namespaces */
>  		case 'r':
> -			args.attr_filter |= LIBXFS_ATTR_ROOT;
> -			args.attr_filter &= ~LIBXFS_ATTR_SECURE;
> +			args.attr_filter |= XFS_ATTR_ROOT;
> +			args.attr_filter &= ~XFS_ATTR_SECURE;
>  			break;
>  		case 'u':
> -			args.attr_filter &= ~(LIBXFS_ATTR_ROOT |
> -					      LIBXFS_ATTR_SECURE);
> +			args.attr_filter &= ~(XFS_ATTR_ROOT |
> +					      XFS_ATTR_SECURE);
>  			break;
>  		case 's':
> -			args.attr_filter |= LIBXFS_ATTR_SECURE;
> -			args.attr_filter &= ~LIBXFS_ATTR_ROOT;
> +			args.attr_filter |= XFS_ATTR_SECURE;
> +			args.attr_filter &= ~XFS_ATTR_ROOT;
>  			break;
>  
>  		/* modifiers */
> @@ -160,7 +160,7 @@ attr_set_f(
>  		goto out;
>  	}
>  
> -	if (libxfs_attr_set(&args)) {
> +	if (xfs_attr_set(&args)) {
>  		dbprintf(_("failed to set attr %s on inode %llu\n"),
>  			args.name, (unsigned long long)iocur_top->ino);
>  		goto out;
> @@ -199,16 +199,16 @@ attr_remove_f(
>  		switch (c) {
>  		/* namespaces */
>  		case 'r':
> -			args.attr_filter |= LIBXFS_ATTR_ROOT;
> -			args.attr_filter &= ~LIBXFS_ATTR_SECURE;
> +			args.attr_filter |= XFS_ATTR_ROOT;
> +			args.attr_filter &= ~XFS_ATTR_SECURE;
>  			break;
>  		case 'u':
> -			args.attr_filter &= ~(LIBXFS_ATTR_ROOT |
> -					      LIBXFS_ATTR_SECURE);
> +			args.attr_filter &= ~(XFS_ATTR_ROOT |
> +					      XFS_ATTR_SECURE);
>  			break;
>  		case 's':
> -			args.attr_filter |= LIBXFS_ATTR_SECURE;
> -			args.attr_filter &= ~LIBXFS_ATTR_ROOT;
> +			args.attr_filter |= XFS_ATTR_SECURE;
> +			args.attr_filter &= ~XFS_ATTR_ROOT;
>  			break;
>  
>  		case 'n':
> @@ -245,7 +245,7 @@ attr_remove_f(
>  		goto out;
>  	}
>  
> -	if (libxfs_attr_set(&args)) {
> +	if (xfs_attr_set(&args)) {
>  		dbprintf(_("failed to remove attr %s from inode %llu\n"),
>  			(unsigned char *)args.name,
>  			(unsigned long long)iocur_top->ino);
> diff --git a/db/bmap.c b/db/bmap.c
> index fdc70e95..d028a786 100644
> --- a/db/bmap.c
> +++ b/db/bmap.c
> @@ -78,7 +78,7 @@ bmap(
>  		push_cur();
>  		rblock = (xfs_bmdr_block_t *)XFS_DFORK_PTR(dip, whichfork);
>  		fsize = XFS_DFORK_SIZE(dip, mp, whichfork);
> -		pp = XFS_BMDR_PTR_ADDR(rblock, 1, libxfs_bmdr_maxrecs(fsize, 0));
> +		pp = XFS_BMDR_PTR_ADDR(rblock, 1, xfs_bmdr_maxrecs(fsize, 0));
>  		kp = XFS_BMDR_KEY_ADDR(rblock, 1);
>  		bno = select_child(curoffset, kp, pp,
>  					be16_to_cpu(rblock->bb_numrecs));
> @@ -89,7 +89,7 @@ bmap(
>  			if (be16_to_cpu(block->bb_level) == 0)
>  				break;
>  			pp = XFS_BMBT_PTR_ADDR(mp, block, 1,
> -				libxfs_bmbt_maxrecs(mp, mp->m_sb.sb_blocksize, 0));
> +				xfs_bmbt_maxrecs(mp, mp->m_sb.sb_blocksize, 0));
>  			kp = XFS_BMBT_KEY_ADDR(mp, block, 1);
>  			bno = select_child(curoffset, kp, pp,
>  					be16_to_cpu(block->bb_numrecs));
> diff --git a/db/bmroot.c b/db/bmroot.c
> index 0db526c6..6bf87a43 100644
> --- a/db/bmroot.c
> +++ b/db/bmroot.c
> @@ -128,7 +128,7 @@ bmroota_ptr_offset(
>  	ASSERT(XFS_DFORK_Q(dip) && (char *)block == XFS_DFORK_APTR(dip));
>  	ASSERT(be16_to_cpu(block->bb_level) > 0);
>  	pp = XFS_BMDR_PTR_ADDR(block, idx,
> -		libxfs_bmdr_maxrecs(XFS_DFORK_ASIZE(dip, mp), 0));
> +		xfs_bmdr_maxrecs(XFS_DFORK_ASIZE(dip, mp), 0));
>  	return bitize((int)((char *)pp - (char *)block));
>  }
>  
> @@ -223,7 +223,7 @@ bmrootd_ptr_offset(
>  	block = (xfs_bmdr_block_t *)((char *)obj + byteize(startoff));
>  	ASSERT(be16_to_cpu(block->bb_level) > 0);
>  	pp = XFS_BMDR_PTR_ADDR(block, idx,
> -		libxfs_bmdr_maxrecs(XFS_DFORK_DSIZE(dip, mp), 0));
> +		xfs_bmdr_maxrecs(XFS_DFORK_DSIZE(dip, mp), 0));
>  	return bitize((int)((char *)pp - (char *)block));
>  }
>  
> diff --git a/db/btdump.c b/db/btdump.c
> index 920f595b..b9947c18 100644
> --- a/db/btdump.c
> +++ b/db/btdump.c
> @@ -212,10 +212,10 @@ dir_has_rightsib(
>  	struct xfs_da3_icnode_hdr	nhdr;
>  
>  	if (level > 0) {
> -		libxfs_da3_node_hdr_from_disk(mp, &nhdr, block);
> +		xfs_da3_node_hdr_from_disk(mp, &nhdr, block);
>  		return nhdr.forw != 0;
>  	}
> -	libxfs_dir2_leaf_hdr_from_disk(mp, &lhdr, block);
> +	xfs_dir2_leaf_hdr_from_disk(mp, &lhdr, block);
>  	return lhdr.forw != 0;
>  }
>  
> @@ -229,10 +229,10 @@ dir_level(
>  	switch (((struct xfs_da_intnode *)block)->hdr.info.magic) {
>  	case cpu_to_be16(XFS_DIR2_LEAF1_MAGIC):
>  	case cpu_to_be16(XFS_DIR2_LEAFN_MAGIC):
> -		libxfs_dir2_leaf_hdr_from_disk(mp, &lhdr, block);
> +		xfs_dir2_leaf_hdr_from_disk(mp, &lhdr, block);
>  		return 0;
>  	case cpu_to_be16(XFS_DA_NODE_MAGIC):
> -		libxfs_da3_node_hdr_from_disk(mp, &nhdr, block);
> +		xfs_da3_node_hdr_from_disk(mp, &nhdr, block);
>  		return nhdr.level;
>  	default:
>  		return -1;
> @@ -249,10 +249,10 @@ dir3_level(
>  	switch (((struct xfs_da_intnode *)block)->hdr.info.magic) {
>  	case cpu_to_be16(XFS_DIR3_LEAF1_MAGIC):
>  	case cpu_to_be16(XFS_DIR3_LEAFN_MAGIC):
> -		libxfs_dir2_leaf_hdr_from_disk(mp, &lhdr, block);
> +		xfs_dir2_leaf_hdr_from_disk(mp, &lhdr, block);
>  		return 0;
>  	case cpu_to_be16(XFS_DA3_NODE_MAGIC):
> -		libxfs_da3_node_hdr_from_disk(mp, &nhdr, block);
> +		xfs_da3_node_hdr_from_disk(mp, &nhdr, block);
>  		return nhdr.level;
>  	default:
>  		return -1;
> @@ -268,7 +268,7 @@ attr_has_rightsib(
>  	struct xfs_da3_icnode_hdr	nhdr;
>  
>  	if (level > 0) {
> -		libxfs_da3_node_hdr_from_disk(mp, &nhdr, block);
> +		xfs_da3_node_hdr_from_disk(mp, &nhdr, block);
>  		return nhdr.forw != 0;
>  	}
>  	xfs_attr3_leaf_hdr_to_disk(mp->m_attr_geo, &lhdr, block);
> @@ -287,7 +287,7 @@ attr_level(
>  		xfs_attr3_leaf_hdr_to_disk(mp->m_attr_geo, &lhdr, block);
>  		return 0;
>  	case cpu_to_be16(XFS_DA_NODE_MAGIC):
> -		libxfs_da3_node_hdr_from_disk(mp, &nhdr, block);
> +		xfs_da3_node_hdr_from_disk(mp, &nhdr, block);
>  		return nhdr.level;
>  	default:
>  		return -1;
> @@ -306,7 +306,7 @@ attr3_level(
>  		xfs_attr3_leaf_hdr_to_disk(mp->m_attr_geo, &lhdr, block);
>  		return 0;
>  	case cpu_to_be16(XFS_DA3_NODE_MAGIC):
> -		libxfs_da3_node_hdr_from_disk(mp, &nhdr, block);
> +		xfs_da3_node_hdr_from_disk(mp, &nhdr, block);
>  		return nhdr.level;
>  	default:
>  		return -1;
> diff --git a/db/btheight.c b/db/btheight.c
> index 8aa17c89..5d4aa685 100644
> --- a/db/btheight.c
> +++ b/db/btheight.c
> @@ -14,12 +14,12 @@
>  
>  static int refc_maxrecs(struct xfs_mount *mp, int blocklen, int leaf)
>  {
> -	return libxfs_refcountbt_maxrecs(blocklen, leaf != 0);
> +	return xfs_refcountbt_maxrecs(blocklen, leaf != 0);
>  }
>  
>  static int rmap_maxrecs(struct xfs_mount *mp, int blocklen, int leaf)
>  {
> -	return libxfs_rmapbt_maxrecs(blocklen, leaf);
> +	return xfs_rmapbt_maxrecs(blocklen, leaf);
>  }
>  
>  struct btmap {
> @@ -27,11 +27,11 @@ struct btmap {
>  	int		(*maxrecs)(struct xfs_mount *mp, int blocklen,
>  				   int leaf);
>  } maps[] = {
> -	{"bnobt", libxfs_allocbt_maxrecs},
> -	{"cntbt", libxfs_allocbt_maxrecs},
> -	{"inobt", libxfs_inobt_maxrecs},
> -	{"finobt", libxfs_inobt_maxrecs},
> -	{"bmapbt", libxfs_bmbt_maxrecs},
> +	{"bnobt", xfs_allocbt_maxrecs},
> +	{"cntbt", xfs_allocbt_maxrecs},
> +	{"inobt", xfs_inobt_maxrecs},
> +	{"finobt", xfs_inobt_maxrecs},
> +	{"bmapbt", xfs_bmbt_maxrecs},
>  	{"refcountbt", refc_maxrecs},
>  	{"rmapbt", rmap_maxrecs},
>  };
> diff --git a/db/check.c b/db/check.c
> index c6fce605..9ae10b30 100644
> --- a/db/check.c
> +++ b/db/check.c
> @@ -2269,7 +2269,7 @@ process_btinode(
>  		return;
>  	}
>  	if (be16_to_cpu(dib->bb_numrecs) >
> -			libxfs_bmdr_maxrecs(XFS_DFORK_SIZE(dip, mp, whichfork),
> +			xfs_bmdr_maxrecs(XFS_DFORK_SIZE(dip, mp, whichfork),
>  			be16_to_cpu(dib->bb_level) == 0)) {
>  		if (!sflag || id->ilist)
>  			dbprintf(_("numrecs for ino %lld %s fork bmap root too "
> @@ -2287,7 +2287,7 @@ process_btinode(
>  		*nex += be16_to_cpu(dib->bb_numrecs);
>  		return;
>  	} else {
> -		pp = XFS_BMDR_PTR_ADDR(dib, 1, libxfs_bmdr_maxrecs(
> +		pp = XFS_BMDR_PTR_ADDR(dib, 1, xfs_bmdr_maxrecs(
>  				XFS_DFORK_SIZE(dip, mp, whichfork), 0));
>  		for (i = 0; i < be16_to_cpu(dib->bb_numrecs); i++)
>  			scan_lbtree(get_unaligned_be64(&pp[i]),
> @@ -2358,7 +2358,7 @@ process_data_dir_v2(
>  		return NULLFSINO;
>  	}
>  	db = xfs_dir2_da_to_db(mp->m_dir_geo, dabno);
> -	bf = libxfs_dir2_data_bestfree_p(mp, data);
> +	bf = xfs_dir2_data_bestfree_p(mp, data);
>  	ptr = (char *)data + mp->m_dir_geo->data_entry_offset;
>  	if (be32_to_cpu(block->magic) == XFS_DIR2_BLOCK_MAGIC ||
>  	    be32_to_cpu(block->magic) == XFS_DIR3_BLOCK_MAGIC) {
> @@ -2444,7 +2444,7 @@ process_data_dir_v2(
>  					(int)((char *)dep - (char *)data));
>  			error++;
>  		}
> -		tagp = libxfs_dir2_data_entry_tag_p(mp, dep);
> +		tagp = xfs_dir2_data_entry_tag_p(mp, dep);
>  		if ((char *)tagp >= endptr) {
>  			if (!sflag || v)
>  				dbprintf(_("dir %lld block %d bad entry at %d\n"),
> @@ -2458,8 +2458,8 @@ process_data_dir_v2(
>  			(char *)dep - (char *)data);
>  		xname.name = dep->name;
>  		xname.len = dep->namelen;
> -		dir_hash_add(libxfs_dir2_hashname(mp, &xname), addr);
> -		ptr += libxfs_dir2_data_entsize(mp, dep->namelen);
> +		dir_hash_add(xfs_dir2_hashname(mp, &xname), addr);
> +		ptr += xfs_dir2_data_entsize(mp, dep->namelen);
>  		count++;
>  		lastfree = 0;
>  		lino = be64_to_cpu(dep->inumber);
> @@ -2584,7 +2584,7 @@ process_data_dir_v2_freefind(
>  	xfs_dir2_data_aoff_t	off;
>  
>  	off = (xfs_dir2_data_aoff_t)((char *)dup - (char *)data);
> -	bf = libxfs_dir2_data_bestfree_p(mp, data);
> +	bf = xfs_dir2_data_bestfree_p(mp, data);
>  	if (be16_to_cpu(dup->length) <
>  			be16_to_cpu(bf[XFS_DIR2_DATA_FD_COUNT - 1].length))
>  		return NULL;
> @@ -2752,7 +2752,7 @@ process_inode(
>  
>  	/* xfs_inode_from_disk expects to have an mp to work with */
>  	xino.i_mount = mp;
> -	libxfs_inode_from_disk(&xino, dip);
> +	xfs_inode_from_disk(&xino, dip);
>  
>  	ino = XFS_AGINO_TO_INO(mp, be32_to_cpu(agf->agf_seqno), agino);
>  	if (!isfree) {
> @@ -2768,7 +2768,7 @@ process_inode(
>  		error++;
>  		return;
>  	}
> -	if (!libxfs_dinode_good_version(&mp->m_sb, dip->di_version)) {
> +	if (!xfs_dinode_good_version(&mp->m_sb, dip->di_version)) {
>  		if (isfree || v)
>  			dbprintf(_("bad version number %#x for inode %lld\n"),
>  				dip->di_version, ino);
> @@ -3306,7 +3306,7 @@ process_leaf_node_dir_v2_int(
>  	struct xfs_dir3_icleaf_hdr leafhdr;
>  
>  	leaf = iocur_top->data;
> -	libxfs_dir2_leaf_hdr_from_disk(mp, &leafhdr, leaf);
> +	xfs_dir2_leaf_hdr_from_disk(mp, &leafhdr, leaf);
>  
>  	switch (be16_to_cpu(leaf->hdr.info.magic)) {
>  	case XFS_DIR3_LEAF1_MAGIC:
> @@ -3364,7 +3364,7 @@ process_leaf_node_dir_v2_int(
>  	case XFS_DA_NODE_MAGIC:
>  	case XFS_DA3_NODE_MAGIC:
>  		node = iocur_top->data;
> -		libxfs_da3_node_hdr_from_disk(mp, &nodehdr, node);
> +		xfs_da3_node_hdr_from_disk(mp, &nodehdr, node);
>  		if (nodehdr.level < 1 || nodehdr.level > XFS_DA_NODE_MAXDEPTH) {
>  			if (!sflag || v)
>  				dbprintf(_("bad node block level %d for dir ino "
> @@ -3671,7 +3671,7 @@ process_sf_dir_v2(
>  	offset = mp->m_dir_geo->data_first_offset;
>  	for (i = sf->count - 1, i8 = 0; i >= 0; i--) {
>  		if ((intptr_t)sfe +
> -		    libxfs_dir2_sf_entsize(mp, sf, sfe->namelen) -
> +		    xfs_dir2_sf_entsize(mp, sf, sfe->namelen) -
>  		    (intptr_t)sf > be64_to_cpu(dip->di_size)) {
>  			if (!sflag)
>  				dbprintf(_("dir %llu bad size in entry at %d\n"),
> @@ -3680,7 +3680,7 @@ process_sf_dir_v2(
>  			error++;
>  			break;
>  		}
> -		lino = libxfs_dir2_sf_get_ino(mp, sf, sfe);
> +		lino = xfs_dir2_sf_get_ino(mp, sf, sfe);
>  		if (lino > XFS_DIR2_MAX_SHORT_INUM)
>  			i8++;
>  		cid = find_inode(lino, 1);
> @@ -3710,8 +3710,8 @@ process_sf_dir_v2(
>  		}
>  		offset =
>  			xfs_dir2_sf_get_offset(sfe) +
> -			libxfs_dir2_sf_entsize(mp, sf, sfe->namelen);
> -		sfe = libxfs_dir2_sf_nextentry(mp, sf, sfe);
> +			xfs_dir2_sf_entsize(mp, sf, sfe->namelen);
> +		sfe = xfs_dir2_sf_nextentry(mp, sf, sfe);
>  	}
>  	if (i < 0 && (intptr_t)sfe - (intptr_t)sf !=
>  					be64_to_cpu(dip->di_size)) {
> @@ -3727,7 +3727,7 @@ process_sf_dir_v2(
>  			dbprintf(_("dir %llu offsets too high\n"), id->ino);
>  		error++;
>  	}
> -	lino = libxfs_dir2_sf_get_parent_ino(sf);
> +	lino = xfs_dir2_sf_get_parent_ino(sf);
>  	if (lino > XFS_DIR2_MAX_SHORT_INUM)
>  		i8++;
>  	cid = find_inode(lino, 1);
> @@ -3897,7 +3897,7 @@ scan_ag(
>  		goto pop1_out;
>  	}
>  
> -	libxfs_sb_from_disk(sb, iocur_top->data);
> +	xfs_sb_from_disk(sb, iocur_top->data);
>  
>  	if (sb->sb_magicnum != XFS_SB_MAGIC) {
>  		if (!sflag)
> @@ -4110,8 +4110,8 @@ scan_freelist(
>  	}
>  
>  	/* verify agf values before proceeding */
> -	if (be32_to_cpu(agf->agf_flfirst) >= libxfs_agfl_size(mp) ||
> -	    be32_to_cpu(agf->agf_fllast) >= libxfs_agfl_size(mp)) {
> +	if (be32_to_cpu(agf->agf_flfirst) >= xfs_agfl_size(mp) ||
> +	    be32_to_cpu(agf->agf_fllast) >= xfs_agfl_size(mp)) {
>  		dbprintf(_("agf %d freelist blocks bad, skipping "
>  			  "freelist scan\n"), seqno);
>  		pop_cur();
> @@ -4121,7 +4121,7 @@ scan_freelist(
>  	/* open coded xfs_buf_to_agfl_bno */
>  	state.count = 0;
>  	state.agno = seqno;
> -	libxfs_agfl_walk(mp, agf, iocur_top->bp, scan_agfl, &state);
> +	xfs_agfl_walk(mp, agf, iocur_top->bp, scan_agfl, &state);
>  	if (state.count != be32_to_cpu(agf->agf_flcount)) {
>  		if (!sflag)
>  			dbprintf(_("freeblk count %u != flcount %u in ag %u\n"),
> diff --git a/db/dir2.c b/db/dir2.c
> index 503dcdfe..beb104a0 100644
> --- a/db/dir2.c
> +++ b/db/dir2.c
> @@ -211,7 +211,7 @@ __dir2_data_entries_count(
>  			ptr += be16_to_cpu(dup->length);
>  		else {
>  			dep = (xfs_dir2_data_entry_t *)ptr;
> -			ptr += libxfs_dir2_data_entsize(mp, dep->namelen);
> +			ptr += xfs_dir2_data_entsize(mp, dep->namelen);
>  		}
>  	}
>  	return i;
> @@ -235,7 +235,7 @@ __dir2_data_entry_offset(
>  			ptr += be16_to_cpu(dup->length);
>  		else {
>  			dep = (xfs_dir2_data_entry_t *)ptr;
> -			ptr += libxfs_dir2_data_entsize(mp, dep->namelen);
> +			ptr += xfs_dir2_data_entsize(mp, dep->namelen);
>  		}
>  	}
>  	return ptr;
> @@ -486,7 +486,7 @@ dir2_data_union_tag_count(
>  		end = (char *)&dep->namelen + sizeof(dep->namelen);
>  		if (end > (char *)obj + mp->m_dir_geo->blksize)
>  			return 0;
> -		tagp = libxfs_dir2_data_entry_tag_p(mp, dep);
> +		tagp = xfs_dir2_data_entry_tag_p(mp, dep);
>  	}
>  	end = (char *)tagp + sizeof(*tagp);
>  	return end <= (char *)obj + mp->m_dir_geo->blksize;
> @@ -508,7 +508,7 @@ dir2_data_union_tag_offset(
>  		return bitize((int)((char *)xfs_dir2_data_unused_tag_p(dup) -
>  				    (char *)dup));
>  	dep = (xfs_dir2_data_entry_t *)dup;
> -	return bitize((int)((char *)libxfs_dir2_data_entry_tag_p(mp, dep) -
> +	return bitize((int)((char *)xfs_dir2_data_entry_tag_p(mp, dep) -
>  			    (char *)dep));
>  }
>  
> @@ -585,7 +585,7 @@ dir2_data_union_size(
>  		return bitize(be16_to_cpu(dup->length));
>  	else {
>  		dep = (xfs_dir2_data_entry_t *)dup;
> -		return bitize(libxfs_dir2_data_entsize(mp, dep->namelen));
> +		return bitize(xfs_dir2_data_entsize(mp, dep->namelen));
>  	}
>  }
>  
> diff --git a/db/dir2sf.c b/db/dir2sf.c
> index 8165b79b..e2b5354c 100644
> --- a/db/dir2sf.c
> +++ b/db/dir2sf.c
> @@ -167,8 +167,8 @@ dir2_sf_entry_size(
>  	sf = (struct xfs_dir2_sf_hdr *)((char *)obj + byteize(startoff));
>  	e = xfs_dir2_sf_firstentry(sf);
>  	for (i = 0; i < idx; i++)
> -		e = libxfs_dir2_sf_nextentry(mp, sf, e);
> -	return bitize((int)libxfs_dir2_sf_entsize(mp, sf, e->namelen));
> +		e = xfs_dir2_sf_nextentry(mp, sf, e);
> +	return bitize((int)xfs_dir2_sf_entsize(mp, sf, e->namelen));
>  }
>  
>  /*ARGSUSED*/
> @@ -212,7 +212,7 @@ dir2_sf_list_offset(
>  	sf = (struct xfs_dir2_sf_hdr *)((char *)obj + byteize(startoff));
>  	e = xfs_dir2_sf_firstentry(sf);
>  	for (i = 0; i < idx; i++)
> -		e = libxfs_dir2_sf_nextentry(mp, sf, e);
> +		e = xfs_dir2_sf_nextentry(mp, sf, e);
>  	return bitize((int)((char *)e - (char *)sf));
>  }
>  
> @@ -232,7 +232,7 @@ dir2sf_size(
>  	sf = (struct xfs_dir2_sf_hdr *)((char *)obj + byteize(startoff));
>  	e = xfs_dir2_sf_firstentry(sf);
>  	for (i = 0; i < sf->count; i++)
> -		e = libxfs_dir2_sf_nextentry(mp, sf, e);
> +		e = xfs_dir2_sf_nextentry(mp, sf, e);
>  	return bitize((int)((char *)e - (char *)sf));
>  }
>  
> diff --git a/db/frag.c b/db/frag.c
> index 1cfc6c2c..ead1bc94 100644
> --- a/db/frag.c
> +++ b/db/frag.c
> @@ -248,7 +248,7 @@ process_btinode(
>  		return;
>  	}
>  	pp = XFS_BMDR_PTR_ADDR(dib, 1,
> -		libxfs_bmdr_maxrecs(XFS_DFORK_SIZE(dip, mp, whichfork), 0));
> +		xfs_bmdr_maxrecs(XFS_DFORK_SIZE(dip, mp, whichfork), 0));
>  	for (i = 0; i < be16_to_cpu(dib->bb_numrecs); i++)
>  		scan_lbtree(get_unaligned_be64(&pp[i]),
>  			 be16_to_cpu(dib->bb_level), scanfunc_bmap, extmapp,
> diff --git a/db/freesp.c b/db/freesp.c
> index 6f234666..ef22fd6f 100644
> --- a/db/freesp.c
> +++ b/db/freesp.c
> @@ -242,15 +242,15 @@ scan_freelist(
>  				XFS_FSS_TO_BB(mp, 1), DB_RING_IGN, NULL);
>  
>  	/* verify agf values before proceeding */
> -	if (be32_to_cpu(agf->agf_flfirst) >= libxfs_agfl_size(mp) ||
> -	    be32_to_cpu(agf->agf_fllast) >= libxfs_agfl_size(mp)) {
> +	if (be32_to_cpu(agf->agf_flfirst) >= xfs_agfl_size(mp) ||
> +	    be32_to_cpu(agf->agf_fllast) >= xfs_agfl_size(mp)) {
>  		dbprintf(_("agf %d freelist blocks bad, skipping "
>  			  "freelist scan\n"), seqno);
>  		pop_cur();
>  		return;
>  	}
>  
> -	libxfs_agfl_walk(mp, agf, iocur_top->bp, scan_agfl, &seqno);
> +	xfs_agfl_walk(mp, agf, iocur_top->bp, scan_agfl, &seqno);
>  	pop_cur();
>  }
>  
> diff --git a/db/fsmap.c b/db/fsmap.c
> index a6e61962..e1e206ce 100644
> --- a/db/fsmap.c
> +++ b/db/fsmap.c
> @@ -67,32 +67,32 @@ fsmap(
>  		if (agno == end_ag)
>  			high.rm_startblock = XFS_FSB_TO_AGBNO(mp, end_fsb);
>  
> -		error = -libxfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
> +		error = -xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
>  		if (error) {
>  			dbprintf(_("Error %d while reading AGF.\n"), error);
>  			return;
>  		}
>  
> -		bt_cur = libxfs_rmapbt_init_cursor(mp, NULL, agbp, agno);
> +		bt_cur = xfs_rmapbt_init_cursor(mp, NULL, agbp, agno);
>  		if (!bt_cur) {
> -			libxfs_buf_relse(agbp);
> +			xfs_buf_relse(agbp);
>  			dbprintf(_("Not enough memory.\n"));
>  			return;
>  		}
>  
>  		info.agno = agno;
> -		error = -libxfs_rmap_query_range(bt_cur, &low, &high,
> +		error = -xfs_rmap_query_range(bt_cur, &low, &high,
>  				fsmap_fn, &info);
>  		if (error) {
> -			libxfs_btree_del_cursor(bt_cur, XFS_BTREE_ERROR);
> -			libxfs_buf_relse(agbp);
> +			xfs_btree_del_cursor(bt_cur, XFS_BTREE_ERROR);
> +			xfs_buf_relse(agbp);
>  			dbprintf(_("Error %d while querying fsmap btree.\n"),
>  				error);
>  			return;
>  		}
>  
> -		libxfs_btree_del_cursor(bt_cur, XFS_BTREE_NOERROR);
> -		libxfs_buf_relse(agbp);
> +		xfs_btree_del_cursor(bt_cur, XFS_BTREE_NOERROR);
> +		xfs_buf_relse(agbp);
>  
>  		if (agno == start_ag)
>  			low.rm_startblock = 0;
> diff --git a/db/hash.c b/db/hash.c
> index 68c53e7f..2a5d71f8 100644
> --- a/db/hash.c
> +++ b/db/hash.c
> @@ -41,7 +41,7 @@ hash_f(
>  {
>  	xfs_dahash_t	hashval;
>  
> -	hashval = libxfs_da_hashname((unsigned char *)argv[1], (int)strlen(argv[1]));
> +	hashval = xfs_da_hashname((unsigned char *)argv[1], (int)strlen(argv[1]));
>  	dbprintf("0x%x\n", hashval);
>  	return 0;
>  }
> diff --git a/db/info.c b/db/info.c
> index 2731446d..6f50f6f6 100644
> --- a/db/info.c
> +++ b/db/info.c
> @@ -29,7 +29,7 @@ info_f(
>  {
>  	struct xfs_fsop_geom	geo;
>  
> -	libxfs_fs_geometry(&mp->m_sb, &geo, XFS_FS_GEOM_MAX_STRUCT_VER);
> +	xfs_fs_geometry(&mp->m_sb, &geo, XFS_FS_GEOM_MAX_STRUCT_VER);
>  	xfs_report_geom(&geo, fsdevice, x.logname, x.rtname);
>  	return 0;
>  }
> @@ -72,24 +72,24 @@ print_agresv_info(
>  	xfs_extlen_t	length = 0;
>  	int		error;
>  
> -	error = -libxfs_refcountbt_calc_reserves(mp, NULL, agno, &ask, &used);
> +	error = -xfs_refcountbt_calc_reserves(mp, NULL, agno, &ask, &used);
>  	if (error)
>  		xfrog_perror(error, "refcountbt");
> -	error = -libxfs_finobt_calc_reserves(mp, NULL, agno, &ask, &used);
> +	error = -xfs_finobt_calc_reserves(mp, NULL, agno, &ask, &used);
>  	if (error)
>  		xfrog_perror(error, "finobt");
> -	error = -libxfs_rmapbt_calc_reserves(mp, NULL, agno, &ask, &used);
> +	error = -xfs_rmapbt_calc_reserves(mp, NULL, agno, &ask, &used);
>  	if (error)
>  		xfrog_perror(error, "rmapbt");
>  
> -	error = -libxfs_read_agf(mp, NULL, agno, 0, &bp);
> +	error = -xfs_read_agf(mp, NULL, agno, 0, &bp);
>  	if (error)
>  		xfrog_perror(error, "AGF");
>  	agf = bp->b_addr;
>  	length = be32_to_cpu(agf->agf_length);
>  	free = be32_to_cpu(agf->agf_freeblks) +
>  	       be32_to_cpu(agf->agf_flcount);
> -	libxfs_buf_relse(bp);
> +	xfs_buf_relse(bp);
>  
>  	printf("AG %d: length: %u free: %u reserved: %u used: %u",
>  			agno, length, free, ask, used);
> diff --git a/db/init.c b/db/init.c
> index 19f0900a..927669d6 100644
> --- a/db/init.c
> +++ b/db/init.c
> @@ -110,7 +110,7 @@ init(
>  	 */
>  	memset(&xmount, 0, sizeof(struct xfs_mount));
>  	libxfs_buftarg_init(&xmount, x.ddev, x.logdev, x.rtdev);
> -	error = -libxfs_buf_read_uncached(xmount.m_ddev_targp, XFS_SB_DADDR,
> +	error = -xfs_buf_read_uncached(xmount.m_ddev_targp, XFS_SB_DADDR,
>  			1 << (XFS_MAX_SECTORSIZE_LOG - BBSHIFT), 0, &bp, NULL);
>  	if (error) {
>  		fprintf(stderr, _("%s: %s is invalid (cannot read first 512 "
> @@ -119,8 +119,8 @@ init(
>  	}
>  
>  	/* copy SB from buffer to in-core, converting architecture as we go */
> -	libxfs_sb_from_disk(&xmount.m_sb, bp->b_addr);
> -	libxfs_buf_relse(bp);
> +	xfs_sb_from_disk(&xmount.m_sb, bp->b_addr);
> +	xfs_buf_relse(bp);
>  
>  	sbp = &xmount.m_sb;
>  	if (sbp->sb_magicnum != XFS_SB_MAGIC) {
> @@ -153,7 +153,7 @@ init(
>  	 */
>  	if (sbp->sb_rootino != NULLFSINO &&
>  	    xfs_sb_version_haslazysbcount(&mp->m_sb)) {
> -		int error = -libxfs_initialize_perag_data(mp, sbp->sb_agcount);
> +		int error = -xfs_initialize_perag_data(mp, sbp->sb_agcount);
>  		if (error) {
>  			fprintf(stderr,
>  	_("%s: cannot init perag data (%d). Continuing anyway.\n"),
> diff --git a/db/inode.c b/db/inode.c
> index 0cff9d63..804be77e 100644
> --- a/db/inode.c
> +++ b/db/inode.c
> @@ -688,7 +688,7 @@ set_cur_inode(
>  		iocur_top->dirino = ino;
>  
>  	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> -		iocur_top->ino_crc_ok = libxfs_verify_cksum((char *)dip,
> +		iocur_top->ino_crc_ok = xfs_verify_cksum((char *)dip,
>  						    mp->m_sb.sb_inodesize,
>  						    XFS_DINODE_CRC_OFF);
>  		if (!iocur_top->ino_crc_ok)
> @@ -708,6 +708,6 @@ xfs_inode_set_crc(
>  	ASSERT(iocur_top->ino_buf);
>  	ASSERT(iocur_top->bp == bp);
>  
> -	libxfs_dinode_calc_crc(mp, iocur_top->data);
> +	xfs_dinode_calc_crc(mp, iocur_top->data);
>  	iocur_top->ino_crc_ok = 1;
>  }
> diff --git a/db/io.c b/db/io.c
> index 6628d061..d5eecdb4 100644
> --- a/db/io.c
> +++ b/db/io.c
> @@ -96,7 +96,7 @@ pop_cur(void)
>  		return;
>  	}
>  	if (iocur_top->bp) {
> -		libxfs_buf_relse(iocur_top->bp);
> +		xfs_buf_relse(iocur_top->bp);
>  		iocur_top->bp = NULL;
>  	}
>  	if (iocur_top->bbmap) {
> @@ -426,7 +426,7 @@ write_cur_buf(void)
>  {
>  	int ret;
>  
> -	ret = -libxfs_bwrite(iocur_top->bp);
> +	ret = -xfs_bwrite(iocur_top->bp);
>  	if (ret != 0)
>  		dbprintf(_("write error: %s\n"), strerror(ret));
>  
> @@ -442,7 +442,7 @@ write_cur_bbs(void)
>  {
>  	int ret;
>  
> -	ret = -libxfs_bwrite(iocur_top->bp);
> +	ret = -xfs_bwrite(iocur_top->bp);
>  	if (ret != 0)
>  		dbprintf(_("write error: %s\n"), strerror(ret));
>  
> @@ -496,7 +496,7 @@ write_cur(void)
>  	/* If we didn't write the crc automatically, re-check inode validity */
>  	if (xfs_sb_version_hascrc(&mp->m_sb) &&
>  	    skip_crc && iocur_top->ino_buf) {
> -		iocur_top->ino_crc_ok = libxfs_verify_cksum(iocur_top->data,
> +		iocur_top->ino_crc_ok = xfs_verify_cksum(iocur_top->data,
>  						mp->m_sb.sb_inodesize,
>  						XFS_DINODE_CRC_OFF);
>  	}
> @@ -543,11 +543,11 @@ set_cur(
>  		if (!iocur_top->bbmap)
>  			return;
>  		memcpy(iocur_top->bbmap, bbmap, sizeof(struct bbmap));
> -		error = -libxfs_buf_read_map(mp->m_ddev_targp, bbmap->b,
> +		error = -xfs_buf_read_map(mp->m_ddev_targp, bbmap->b,
>  				bbmap->nmaps, LIBXFS_READBUF_SALVAGE, &bp,
>  				ops);
>  	} else {
> -		error = -libxfs_buf_read(mp->m_ddev_targp, blknum, len,
> +		error = -xfs_buf_read(mp->m_ddev_targp, blknum, len,
>  				LIBXFS_READBUF_SALVAGE, &bp, ops);
>  		iocur_top->bbmap = NULL;
>  	}
> diff --git a/db/logformat.c b/db/logformat.c
> index 3374c29b..53629f65 100644
> --- a/db/logformat.c
> +++ b/db/logformat.c
> @@ -160,7 +160,7 @@ logres_f(
>  	end_res = (struct xfs_trans_res *)(M_RES(mp) + 1);
>  	for (i = 0; res < end_res; i++, res++)
>  		print_logres(i, res);
> -	libxfs_log_get_max_trans_res(mp, &resv);
> +	xfs_log_get_max_trans_res(mp, &resv);
>  	print_logres(-1, &resv);
>  
>  	return 0;
> diff --git a/db/metadump.c b/db/metadump.c
> index e5cb3aa5..28d4841e 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -882,7 +882,7 @@ obfuscate_name(
>  		*first ^= 0x10;
>  		ASSERT(!is_invalid_char(*first));
>  	}
> -	ASSERT(libxfs_da_hashname(name, name_len) == hash);
> +	ASSERT(xfs_da_hashname(name, name_len) == hash);
>  }
>  
>  /*
> @@ -1206,7 +1206,7 @@ generate_obfuscated_name(
>  
>  	/* Obfuscate the name (if possible) */
>  
> -	hash = libxfs_da_hashname(name, namelen);
> +	hash = xfs_da_hashname(name, namelen);
>  	obfuscate_name(hash, namelen, name);
>  
>  	/*
> @@ -1269,7 +1269,7 @@ process_sf_dir(
>  			namelen = ino_dir_size - ((char *)&sfep->name[0] -
>  					 (char *)sfp);
>  		} else if ((char *)sfep - (char *)sfp +
> -				libxfs_dir2_sf_entsize(mp, sfp, sfep->namelen) >
> +				xfs_dir2_sf_entsize(mp, sfp, sfep->namelen) >
>  				ino_dir_size) {
>  			if (show_warnings)
>  				print_warning("entry length in dir inode %llu "
> @@ -1282,11 +1282,11 @@ process_sf_dir(
>  
>  		if (obfuscate)
>  			generate_obfuscated_name(
> -					 libxfs_dir2_sf_get_ino(mp, sfp, sfep),
> +					 xfs_dir2_sf_get_ino(mp, sfp, sfep),
>  					 namelen, &sfep->name[0]);
>  
>  		sfep = (xfs_dir2_sf_entry_t *)((char *)sfep +
> -				libxfs_dir2_sf_entsize(mp, sfp, namelen));
> +				xfs_dir2_sf_entsize(mp, sfp, namelen));
>  	}
>  
>  	/* zero stale data in rest of space in data fork, if any */
> @@ -1319,7 +1319,7 @@ obfuscate_path_components(
>  		if (!slash) {
>  			/* last (or single) component */
>  			namelen = strnlen((char *)comp, len);
> -			hash = libxfs_da_hashname(comp, namelen);
> +			hash = xfs_da_hashname(comp, namelen);
>  			obfuscate_name(hash, namelen, comp);
>  			break;
>  		}
> @@ -1330,7 +1330,7 @@ obfuscate_path_components(
>  			len--;
>  			continue;
>  		}
> -		hash = libxfs_da_hashname(comp, namelen);
> +		hash = xfs_da_hashname(comp, namelen);
>  		obfuscate_name(hash, namelen, comp);
>  		comp += namelen + 1;
>  		len -= namelen + 1;
> @@ -1433,7 +1433,7 @@ process_dir_free_block(
>  		return;
>  
>  	free = (struct xfs_dir2_free *)block;
> -	libxfs_dir2_free_hdr_from_disk(mp, &freehdr, free);
> +	xfs_dir2_free_hdr_from_disk(mp, &freehdr, free);
>  
>  	switch (freehdr.magic) {
>  	case XFS_DIR2_FREE_MAGIC:
> @@ -1471,7 +1471,7 @@ process_dir_leaf_block(
>  
>  	/* Yes, this works for dir2 & dir3.  Difference is padding. */
>  	leaf = (struct xfs_dir2_leaf *)block;
> -	libxfs_dir2_leaf_hdr_from_disk(mp, &leafhdr, leaf);
> +	xfs_dir2_leaf_hdr_from_disk(mp, &leafhdr, leaf);
>  
>  	switch (leafhdr.magic) {
>  	case XFS_DIR2_LEAF1_MAGIC:
> @@ -1602,7 +1602,7 @@ process_dir_data_block(
>  		}
>  
>  		dep = (xfs_dir2_data_entry_t *)ptr;
> -		length = libxfs_dir2_data_entsize(mp, dep->namelen);
> +		length = xfs_dir2_data_entsize(mp, dep->namelen);
>  
>  		if (dir_offset + length > end_of_data ||
>  		    ptr + length > endptr) {
> @@ -1612,7 +1612,7 @@ process_dir_data_block(
>  					(long long)cur_ino);
>  			return;
>  		}
> -		if (be16_to_cpu(*libxfs_dir2_data_entry_tag_p(mp, dep)) !=
> +		if (be16_to_cpu(*xfs_dir2_data_entry_tag_p(mp, dep)) !=
>  				dir_offset)
>  			return;
>  
> @@ -1625,7 +1625,7 @@ process_dir_data_block(
>  		if (zero_stale_data) {
>  			/* 1 byte for ftype; don't bother with conditional */
>  			int zlen =
> -				(char *)libxfs_dir2_data_entry_tag_p(mp, dep) -
> +				(char *)xfs_dir2_data_entry_tag_p(mp, dep) -
>  				(char *)&dep->name[dep->namelen] - 1;
>  			if (zlen > 0) {
>  				memset(&dep->name[dep->namelen] + 1, 0, zlen);
> @@ -1877,7 +1877,7 @@ process_single_fsb_objects(
>  				struct xfs_da3_icnode_hdr hdr;
>  				int used;
>  
> -				libxfs_da3_node_hdr_from_disk(mp, &hdr, node);
> +				xfs_da3_node_hdr_from_disk(mp, &hdr, node);
>  				switch (btype) {
>  				case TYP_DIR2:
>  					used = mp->m_dir_geo->node_hdr_size;
> @@ -2225,7 +2225,7 @@ process_btinode(
>  					    nrecs, itype);
>  	}
>  
> -	maxrecs = libxfs_bmdr_maxrecs(XFS_DFORK_SIZE(dip, mp, whichfork), 0);
> +	maxrecs = xfs_bmdr_maxrecs(XFS_DFORK_SIZE(dip, mp, whichfork), 0);
>  	if (nrecs > maxrecs) {
>  		if (show_warnings)
>  			print_warning("invalid numrecs (%u) in inode %lld %s "
> @@ -2374,7 +2374,7 @@ process_inode(
>  
>  	/* we only care about crc recalculation if we will modify the inode. */
>  	if (obfuscate || zero_stale_data) {
> -		crc_was_ok = libxfs_verify_cksum((char *)dip,
> +		crc_was_ok = xfs_verify_cksum((char *)dip,
>  					mp->m_sb.sb_inodesize,
>  					offsetof(struct xfs_dinode, di_crc));
>  	}
> @@ -2441,7 +2441,7 @@ done:
>  		need_new_crc = 1;
>  
>  	if (crc_was_ok && need_new_crc)
> -		libxfs_dinode_calc_crc(mp, dip);
> +		xfs_dinode_calc_crc(mp, dip);
>  	return success;
>  }
>  
> @@ -2752,7 +2752,7 @@ scan_ag(
>  			i = be32_to_cpu(agf->agf_fllast);
>  
>  			for (;;) {
> -				if (++i == libxfs_agfl_size(mp))
> +				if (++i == xfs_agfl_size(mp))
>  					i = 0;
>  				if (i == be32_to_cpu(agf->agf_flfirst))
>  					break;
> diff --git a/db/sb.c b/db/sb.c
> index 8a303422..9651a3b3 100644
> --- a/db/sb.c
> +++ b/db/sb.c
> @@ -189,7 +189,7 @@ get_sb(xfs_agnumber_t agno, xfs_sb_t *sb)
>  		return 0;
>  	}
>  
> -	libxfs_sb_from_disk(sb, iocur_top->data);
> +	xfs_sb_from_disk(sb, iocur_top->data);
>  
>  	if (sb->sb_magicnum != XFS_SB_MAGIC) {
>  		dbprintf(_("bad sb magic # %#x in AG %u\n"),
> @@ -344,7 +344,7 @@ do_uuid(xfs_agnumber_t agno, uuid_t *uuid)
>  		   uuid_equal(uuid, &mp->m_sb.sb_meta_uuid)) {
>  		memset(&tsb.sb_meta_uuid, 0, sizeof(uuid_t));
>  		/* Write those zeros now; it's ignored once we clear the flag */
> -		libxfs_sb_to_disk(iocur_top->data, &tsb);
> +		xfs_sb_to_disk(iocur_top->data, &tsb);
>  		mp->m_sb.sb_features_incompat &=
>  						~XFS_SB_FEAT_INCOMPAT_META_UUID;
>  		tsb.sb_features_incompat &= ~XFS_SB_FEAT_INCOMPAT_META_UUID;
> @@ -352,7 +352,7 @@ do_uuid(xfs_agnumber_t agno, uuid_t *uuid)
>  
>  write:
>  	memcpy(&tsb.sb_uuid, uuid, sizeof(uuid_t));
> -	libxfs_sb_to_disk(iocur_top->data, &tsb);
> +	xfs_sb_to_disk(iocur_top->data, &tsb);
>  	write_cur();
>  	return uuid;
>  }
> @@ -516,7 +516,7 @@ do_label(xfs_agnumber_t agno, char *label)
>  	memset(&tsb.sb_fname, 0, sizeof(tsb.sb_fname));
>  	memcpy(&tsb.sb_fname, label, len);
>  	memcpy(&lbl[0], &tsb.sb_fname, sizeof(tsb.sb_fname));
> -	libxfs_sb_to_disk(iocur_top->data, &tsb);
> +	xfs_sb_to_disk(iocur_top->data, &tsb);
>  	write_cur();
>  	return &lbl[0];
>  }
> @@ -615,7 +615,7 @@ do_version(xfs_agnumber_t agno, uint16_t version, uint32_t features)
>  	tsb.sb_versionnum = version;
>  	tsb.sb_features2 = features;
>  	tsb.sb_bad_features2 = features;
> -	libxfs_sb_to_disk(iocur_top->data, &tsb);
> +	xfs_sb_to_disk(iocur_top->data, &tsb);
>  	write_cur();
>  	return 1;
>  }
> diff --git a/include/cache.h b/include/cache.h
> index 334ad263..bca9f6bb 100644
> --- a/include/cache.h
> +++ b/include/cache.h
> @@ -33,7 +33,7 @@ enum {
>   * For prefetch support, the top half of the range starts at
>   * CACHE_PREFETCH_PRIORITY and everytime the buffer is fetched and is at or
>   * above this priority level, it is reduced to below this level (refer to
> - * libxfs_buf_get).
> + * xfs_buf_get).
>   *
>   * If we have dirty nodes, we can't recycle them until they've been cleaned. To
>   * keep these out of the reclaimable lists (as there can be lots of them) give
> diff --git a/include/libxfs.h b/include/libxfs.h
> index 12447835..cfc5260d 100644
> --- a/include/libxfs.h
> +++ b/include/libxfs.h
> @@ -7,7 +7,6 @@
>  #ifndef __LIBXFS_H__
>  #define __LIBXFS_H__
>  
> -#include "libxfs_api_defs.h"
>  #include "platform_defs.h"
>  #include "xfs.h"
>  
> @@ -157,7 +156,7 @@ extern int	libxfs_log_header(char *, uuid_t *, int, int, int, xfs_lsn_t,
>  
>  /* Shared utility routines */
>  
> -extern int	libxfs_alloc_file_space (struct xfs_inode *, xfs_off_t,
> +extern int	xfs_alloc_file_space (struct xfs_inode *, xfs_off_t,
>  				xfs_off_t, int, int);
>  
>  /* XXX: this is messy and needs fixing */
> @@ -210,8 +209,8 @@ libxfs_bmbt_disk_get_all(
>  
>  /* XXX: this is clearly a bug - a shared header needs to export this */
>  /* xfs_rtalloc.c */
> -int libxfs_rtfree_extent(struct xfs_trans *, xfs_rtblock_t, xfs_extlen_t);
> -bool libxfs_verify_rtbno(struct xfs_mount *mp, xfs_rtblock_t rtbno);
> +int xfs_rtfree_extent(struct xfs_trans *, xfs_rtblock_t, xfs_extlen_t);
> +bool xfs_verify_rtbno(struct xfs_mount *mp, xfs_rtblock_t rtbno);
>  
>  #include "xfs_attr.h"
>  
> diff --git a/include/xfs_inode.h b/include/xfs_inode.h
> index 3caeeb39..5a34c681 100644
> --- a/include/xfs_inode.h
> +++ b/include/xfs_inode.h
> @@ -146,20 +146,20 @@ typedef struct cred {
>  	gid_t	cr_gid;
>  } cred_t;
>  
> -extern int	libxfs_inode_alloc (struct xfs_trans **, struct xfs_inode *,
> +extern int	xfs_inode_alloc (struct xfs_trans **, struct xfs_inode *,
>  				mode_t, nlink_t, xfs_dev_t, struct cred *,
>  				struct fsxattr *, struct xfs_inode **);
> -extern void	libxfs_trans_inode_alloc_buf (struct xfs_trans *,
> +extern void	xfs_trans_inode_alloc_buf (struct xfs_trans *,
>  				struct xfs_buf *);
>  
> -extern void	libxfs_trans_ichgtime(struct xfs_trans *,
> +extern void	xfs_trans_ichgtime(struct xfs_trans *,
>  				struct xfs_inode *, int);
>  extern int	libxfs_iflush_int (struct xfs_inode *, struct xfs_buf *);
>  
>  extern struct timespec64 current_time(struct inode *inode);
>  
>  /* Inode Cache Interfaces */
> -extern bool	libxfs_inode_verify_forks(struct xfs_inode *ip);
> +extern bool	xfs_inode_verify_forks(struct xfs_inode *ip);
>  extern int	libxfs_iget(struct xfs_mount *, struct xfs_trans *, xfs_ino_t,
>  				uint, struct xfs_inode **,
>  				struct xfs_ifork_ops *);
> diff --git a/include/xfs_trans.h b/include/xfs_trans.h
> index 16e2a468..8d5a9e2f 100644
> --- a/include/xfs_trans.h
> +++ b/include/xfs_trans.h
> @@ -76,46 +76,46 @@ typedef struct xfs_trans {
>  void	xfs_trans_init(struct xfs_mount *);
>  int	xfs_trans_roll(struct xfs_trans **);
>  
> -int	libxfs_trans_alloc(struct xfs_mount *mp, struct xfs_trans_res *resp,
> +int	xfs_trans_alloc(struct xfs_mount *mp, struct xfs_trans_res *resp,
>  			   uint blocks, uint rtextents, uint flags,
>  			   struct xfs_trans **tpp);
> -int	libxfs_trans_alloc_rollable(struct xfs_mount *mp, uint blocks,
> +int	xfs_trans_alloc_rollable(struct xfs_mount *mp, uint blocks,
>  				    struct xfs_trans **tpp);
> -int	libxfs_trans_alloc_empty(struct xfs_mount *mp, struct xfs_trans **tpp);
> -int	libxfs_trans_commit(struct xfs_trans *);
> -void	libxfs_trans_cancel(struct xfs_trans *);
> +int	xfs_trans_alloc_empty(struct xfs_mount *mp, struct xfs_trans **tpp);
> +int	xfs_trans_commit(struct xfs_trans *);
> +void	xfs_trans_cancel(struct xfs_trans *);
>  
>  /* cancel dfops associated with a transaction */
>  void xfs_defer_cancel(struct xfs_trans *);
>  
> -struct xfs_buf *libxfs_trans_getsb(struct xfs_trans *, struct xfs_mount *);
> +struct xfs_buf *xfs_trans_getsb(struct xfs_trans *, struct xfs_mount *);
>  
> -void	libxfs_trans_ijoin(struct xfs_trans *, struct xfs_inode *, uint);
> -void	libxfs_trans_log_inode (struct xfs_trans *, struct xfs_inode *,
> +void	xfs_trans_ijoin(struct xfs_trans *, struct xfs_inode *, uint);
> +void	xfs_trans_log_inode (struct xfs_trans *, struct xfs_inode *,
>  				uint);
> -int	libxfs_trans_roll_inode (struct xfs_trans **, struct xfs_inode *);
> -
> -void	libxfs_trans_brelse(struct xfs_trans *, struct xfs_buf *);
> -void	libxfs_trans_binval(struct xfs_trans *, struct xfs_buf *);
> -void	libxfs_trans_bjoin(struct xfs_trans *, struct xfs_buf *);
> -void	libxfs_trans_bhold(struct xfs_trans *, struct xfs_buf *);
> -void	libxfs_trans_bhold_release(struct xfs_trans *, struct xfs_buf *);
> -void	libxfs_trans_dirty_buf(struct xfs_trans *, struct xfs_buf *);
> -void	libxfs_trans_log_buf(struct xfs_trans *, struct xfs_buf *,
> +int	xfs_trans_roll_inode (struct xfs_trans **, struct xfs_inode *);
> +
> +void	xfs_trans_brelse(struct xfs_trans *, struct xfs_buf *);
> +void	xfs_trans_binval(struct xfs_trans *, struct xfs_buf *);
> +void	xfs_trans_bjoin(struct xfs_trans *, struct xfs_buf *);
> +void	xfs_trans_bhold(struct xfs_trans *, struct xfs_buf *);
> +void	xfs_trans_bhold_release(struct xfs_trans *, struct xfs_buf *);
> +void	xfs_trans_dirty_buf(struct xfs_trans *, struct xfs_buf *);
> +void	xfs_trans_log_buf(struct xfs_trans *, struct xfs_buf *,
>  				uint, uint);
> -bool	libxfs_trans_ordered_buf(xfs_trans_t *, struct xfs_buf *);
> +bool	xfs_trans_ordered_buf(xfs_trans_t *, struct xfs_buf *);
>  
> -int	libxfs_trans_get_buf_map(struct xfs_trans *tp, struct xfs_buftarg *btp,
> +int	xfs_trans_get_buf_map(struct xfs_trans *tp, struct xfs_buftarg *btp,
>  		struct xfs_buf_map *map, int nmaps, xfs_buf_flags_t flags,
>  		struct xfs_buf **bpp);
>  
> -int	libxfs_trans_read_buf_map(struct xfs_mount *mp, struct xfs_trans *tp,
> +int	xfs_trans_read_buf_map(struct xfs_mount *mp, struct xfs_trans *tp,
>  				  struct xfs_buftarg *btp,
>  				  struct xfs_buf_map *map, int nmaps,
>  				  xfs_buf_flags_t flags, struct xfs_buf **bpp,
>  				  const struct xfs_buf_ops *ops);
>  static inline int
> -libxfs_trans_get_buf(
> +xfs_trans_get_buf(
>  	struct xfs_trans	*tp,
>  	struct xfs_buftarg	*btp,
>  	xfs_daddr_t		blkno,
> @@ -125,11 +125,11 @@ libxfs_trans_get_buf(
>  {
>  	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
>  
> -	return libxfs_trans_get_buf_map(tp, btp, &map, 1, flags, bpp);
> +	return xfs_trans_get_buf_map(tp, btp, &map, 1, flags, bpp);
>  }
>  
>  static inline int
> -libxfs_trans_read_buf(
> +xfs_trans_read_buf(
>  	struct xfs_mount	*mp,
>  	struct xfs_trans	*tp,
>  	struct xfs_buftarg	*btp,
> @@ -140,7 +140,7 @@ libxfs_trans_read_buf(
>  	const struct xfs_buf_ops *ops)
>  {
>  	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
> -	return libxfs_trans_read_buf_map(mp, tp, btp, &map, 1, flags, bpp, ops);
> +	return xfs_trans_read_buf_map(mp, tp, btp, &map, 1, flags, bpp, ops);
>  }
>  
>  #endif	/* __XFS_TRANS_H__ */
> diff --git a/io/open.c b/io/open.c
> index 9a8b5e5c..bc94ca2b 100644
> --- a/io/open.c
> +++ b/io/open.c
> @@ -754,7 +754,7 @@ get_last_inode(void)
>  
>  	/* The last inode number in use */
>  	last_ino = ireq->inumbers[lastgrp].xi_startino +
> -		  libxfs_highbit64(ireq->inumbers[lastgrp].xi_allocmask);
> +		  xfs_highbit64(ireq->inumbers[lastgrp].xi_allocmask);
>  out:
>  	free(ireq);
>  
> diff --git a/libxfs/Makefile b/libxfs/Makefile
> index 44b23816..b7b6f770 100644
> --- a/libxfs/Makefile
> +++ b/libxfs/Makefile
> @@ -49,7 +49,6 @@ HFILES = \
>  	xfs_trans_resv.h \
>  	xfs_trans_space.h \
>  	libxfs_io.h \
> -	libxfs_api_defs.h \
>  	init.h \
>  	libxfs_priv.h \
>  	xfs_dir2_priv.h
> diff --git a/libxfs/cache.c b/libxfs/cache.c
> index 139c7c1b..31a4438f 100644
> --- a/libxfs/cache.c
> +++ b/libxfs/cache.c
> @@ -53,7 +53,7 @@ cache_init(
>  	cache->c_misses = 0;
>  	cache->c_maxcount = maxcount;
>  	cache->c_hashsize = hashsize;
> -	cache->c_hashshift = libxfs_highbit32(hashsize);
> +	cache->c_hashshift = xfs_highbit32(hashsize);
>  	cache->hash = cache_operations->hash;
>  	cache->alloc = cache_operations->alloc;
>  	cache->flush = cache_operations->flush;
> diff --git a/libxfs/init.c b/libxfs/init.c
> index cb8967bc..81dc8a9e 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -456,14 +456,14 @@ rtmount_init(
>  			(unsigned long long) mp->m_sb.sb_rblocks);
>  		return -1;
>  	}
> -	error = libxfs_buf_read(mp->m_rtdev, d - XFS_FSB_TO_BB(mp, 1),
> +	error = xfs_buf_read(mp->m_rtdev, d - XFS_FSB_TO_BB(mp, 1),
>  			XFS_FSB_TO_BB(mp, 1), 0, &bp, NULL);
>  	if (error) {
>  		fprintf(stderr, _("%s: realtime size check failed\n"),
>  			progname);
>  		return -1;
>  	}
> -	libxfs_buf_relse(bp);
> +	xfs_buf_relse(bp);
>  	return 0;
>  }
>  
> @@ -736,20 +736,20 @@ libxfs_mount(
>  		return mp;
>  
>  	/* device size checks must pass unless we're a debugger. */
> -	error = libxfs_buf_read(mp->m_dev, d - XFS_FSS_TO_BB(mp, 1),
> +	error = xfs_buf_read(mp->m_dev, d - XFS_FSS_TO_BB(mp, 1),
>  			XFS_FSS_TO_BB(mp, 1), 0, &bp, NULL);
>  	if (error) {
>  		fprintf(stderr, _("%s: data size check failed\n"), progname);
>  		if (!debugger)
>  			return NULL;
>  	} else
> -		libxfs_buf_relse(bp);
> +		xfs_buf_relse(bp);
>  
>  	if (mp->m_logdev_targp->dev &&
>  	    mp->m_logdev_targp->dev != mp->m_ddev_targp->dev) {
>  		d = (xfs_daddr_t) XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
>  		if (XFS_BB_TO_FSB(mp, d) != mp->m_sb.sb_logblocks ||
> -		    libxfs_buf_read(mp->m_logdev_targp,
> +		    xfs_buf_read(mp->m_logdev_targp,
>  				d - XFS_FSB_TO_BB(mp, 1), XFS_FSB_TO_BB(mp, 1),
>  				0, &bp, NULL)) {
>  			fprintf(stderr, _("%s: log size checks failed\n"),
> @@ -758,7 +758,7 @@ libxfs_mount(
>  				return NULL;
>  		}
>  		if (bp)
> -			libxfs_buf_relse(bp);
> +			xfs_buf_relse(bp);
>  	}
>  
>  	/* Initialize realtime fields in the mount structure */
> @@ -776,7 +776,7 @@ libxfs_mount(
>  	 * read the first one and let the user know to check the geometry.
>  	 */
>  	if (sbp->sb_agcount > 1000000) {
> -		error = libxfs_buf_read(mp->m_dev,
> +		error = xfs_buf_read(mp->m_dev,
>  				XFS_AG_DADDR(mp, sbp->sb_agcount - 1, 0), 1,
>  				0, &bp, NULL);
>  		if (error) {
> @@ -788,7 +788,7 @@ libxfs_mount(
>  								progname);
>  			sbp->sb_agcount = 1;
>  		} else
> -			libxfs_buf_relse(bp);
> +			xfs_buf_relse(bp);
>  	}
>  
>  	error = libxfs_initialize_perag(mp, sbp->sb_agcount, &mp->m_maxagi);
> diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
> deleted file mode 100644
> index 4462036b..00000000
> --- a/libxfs/libxfs_api_defs.h
> +++ /dev/null
> @@ -1,191 +0,0 @@
> -// SPDX-License-Identifier: GPL-2.0
> -/*
> - * Copyright (c) 2000-2005 Silicon Graphics, Inc.
> - * All Rights Reserved.
> - */
> -
> -#ifndef __LIBXFS_API_DEFS_H__
> -#define __LIBXFS_API_DEFS_H__
> -
> -/*
> - * This file defines all the kernel based functions we expose to userspace
> - * via the libxfs_* namespace. This is kept in a separate header file so
> - * it can be included in both the internal and external libxfs header files
> - * without introducing any depenencies between the two.
> - */
> -#define LIBXFS_ATTR_ROOT		XFS_ATTR_ROOT
> -#define LIBXFS_ATTR_SECURE		XFS_ATTR_SECURE
> -
> -#define xfs_agfl_size			libxfs_agfl_size
> -#define xfs_agfl_walk			libxfs_agfl_walk
> -
> -#define xfs_ag_init_headers		libxfs_ag_init_headers
> -
> -#define xfs_alloc_ag_max_usable		libxfs_alloc_ag_max_usable
> -#define xfs_allocbt_maxrecs		libxfs_allocbt_maxrecs
> -#define xfs_alloc_fix_freelist		libxfs_alloc_fix_freelist
> -#define xfs_alloc_min_freelist		libxfs_alloc_min_freelist
> -#define xfs_alloc_read_agf		libxfs_alloc_read_agf
> -
> -#define xfs_attr_get			libxfs_attr_get
> -#define xfs_attr_leaf_newentsize	libxfs_attr_leaf_newentsize
> -#define xfs_attr_namecheck		libxfs_attr_namecheck
> -#define xfs_attr_set			libxfs_attr_set
> -
> -#define xfs_bmapi_read			libxfs_bmapi_read
> -#define xfs_bmapi_write			libxfs_bmapi_write
> -#define xfs_bmap_last_offset		libxfs_bmap_last_offset
> -#define xfs_bmbt_maxrecs		libxfs_bmbt_maxrecs
> -#define xfs_bmdr_maxrecs		libxfs_bmdr_maxrecs
> -
> -#define xfs_btree_del_cursor		libxfs_btree_del_cursor
> -#define xfs_btree_init_block		libxfs_btree_init_block
> -#define xfs_buf_delwri_submit		libxfs_buf_delwri_submit
> -#define xfs_buf_get			libxfs_buf_get
> -#define xfs_buf_get_uncached		libxfs_buf_get_uncached
> -#define xfs_buf_read			libxfs_buf_read
> -#define xfs_buf_read_uncached		libxfs_buf_read_uncached
> -#define xfs_buf_relse			libxfs_buf_relse
> -#define xfs_bunmapi			libxfs_bunmapi
> -#define xfs_bwrite			libxfs_bwrite
> -#define xfs_calc_dquots_per_chunk	libxfs_calc_dquots_per_chunk
> -#define xfs_da3_node_hdr_from_disk	libxfs_da3_node_hdr_from_disk
> -#define xfs_da_get_buf			libxfs_da_get_buf
> -#define xfs_da_hashname			libxfs_da_hashname
> -#define xfs_da_read_buf			libxfs_da_read_buf
> -#define xfs_da_shrink_inode		libxfs_da_shrink_inode
> -#define xfs_default_ifork_ops		libxfs_default_ifork_ops
> -#define xfs_defer_cancel		libxfs_defer_cancel
> -#define xfs_defer_finish		libxfs_defer_finish
> -#define xfs_dinode_calc_crc		libxfs_dinode_calc_crc
> -#define xfs_dinode_good_version		libxfs_dinode_good_version
> -#define xfs_dinode_verify		libxfs_dinode_verify
> -
> -#define xfs_dir2_data_bestfree_p	libxfs_dir2_data_bestfree_p
> -#define xfs_dir2_data_entry_tag_p	libxfs_dir2_data_entry_tag_p
> -#define xfs_dir2_data_entsize		libxfs_dir2_data_entsize
> -#define xfs_dir2_data_freescan		libxfs_dir2_data_freescan
> -#define xfs_dir2_data_get_ftype		libxfs_dir2_data_get_ftype
> -#define xfs_dir2_data_log_entry		libxfs_dir2_data_log_entry
> -#define xfs_dir2_data_log_header	libxfs_dir2_data_log_header
> -#define xfs_dir2_data_make_free		libxfs_dir2_data_make_free
> -#define xfs_dir2_data_put_ftype		libxfs_dir2_data_put_ftype
> -#define xfs_dir2_data_use_free		libxfs_dir2_data_use_free
> -#define xfs_dir2_free_hdr_from_disk	libxfs_dir2_free_hdr_from_disk
> -#define xfs_dir2_hashname		libxfs_dir2_hashname
> -#define xfs_dir2_isblock		libxfs_dir2_isblock
> -#define xfs_dir2_isleaf			libxfs_dir2_isleaf
> -#define xfs_dir2_leaf_hdr_from_disk	libxfs_dir2_leaf_hdr_from_disk
> -#define xfs_dir2_namecheck		libxfs_dir2_namecheck
> -#define xfs_dir2_sf_entsize		libxfs_dir2_sf_entsize
> -#define xfs_dir2_sf_get_ftype		libxfs_dir2_sf_get_ftype
> -#define xfs_dir2_sf_get_ino		libxfs_dir2_sf_get_ino
> -#define xfs_dir2_sf_get_parent_ino	libxfs_dir2_sf_get_parent_ino
> -#define xfs_dir2_sf_nextentry		libxfs_dir2_sf_nextentry
> -#define xfs_dir2_sf_put_ftype		libxfs_dir2_sf_put_ftype
> -#define xfs_dir2_sf_put_ino		libxfs_dir2_sf_put_ino
> -#define xfs_dir2_sf_put_parent_ino	libxfs_dir2_sf_put_parent_ino
> -#define xfs_dir2_shrink_inode		libxfs_dir2_shrink_inode
> -
> -#define xfs_dir_createname		libxfs_dir_createname
> -#define xfs_dir_init			libxfs_dir_init
> -#define xfs_dir_ino_validate		libxfs_dir_ino_validate
> -#define xfs_dir_lookup			libxfs_dir_lookup
> -#define xfs_dir_replace			libxfs_dir_replace
> -
> -#define xfs_dqblk_repair		libxfs_dqblk_repair
> -#define xfs_dquot_verify		libxfs_dquot_verify
> -
> -#define xfs_finobt_calc_reserves	libxfs_finobt_calc_reserves
> -#define xfs_free_extent			libxfs_free_extent
> -#define xfs_fs_geometry			libxfs_fs_geometry
> -#define xfs_highbit32			libxfs_highbit32
> -#define xfs_highbit64			libxfs_highbit64
> -#define xfs_ialloc_calc_rootino		libxfs_ialloc_calc_rootino
> -#define xfs_idata_realloc		libxfs_idata_realloc
> -#define xfs_idestroy_fork		libxfs_idestroy_fork
> -#define xfs_iext_lookup_extent		libxfs_iext_lookup_extent
> -#define xfs_initialize_perag_data	libxfs_initialize_perag_data
> -#define xfs_init_local_fork		libxfs_init_local_fork
> -
> -#define xfs_inobt_maxrecs		libxfs_inobt_maxrecs
> -#define xfs_inode_from_disk		libxfs_inode_from_disk
> -#define xfs_inode_to_disk		libxfs_inode_to_disk
> -#define xfs_inode_validate_cowextsize	libxfs_inode_validate_cowextsize
> -#define xfs_inode_validate_extsize	libxfs_inode_validate_extsize
> -
> -#define xfs_iread_extents		libxfs_iread_extents
> -#define xfs_log_calc_minimum_size	libxfs_log_calc_minimum_size
> -#define xfs_log_get_max_trans_res	libxfs_log_get_max_trans_res
> -#define xfs_log_sb			libxfs_log_sb
> -#define xfs_mode_to_ftype		libxfs_mode_to_ftype
> -#define xfs_perag_get			libxfs_perag_get
> -#define xfs_perag_put			libxfs_perag_put
> -#define xfs_prealloc_blocks		libxfs_prealloc_blocks
> -
> -#define xfs_read_agf			libxfs_read_agf
> -#define xfs_refc_block			libxfs_refc_block
> -#define xfs_refcountbt_calc_reserves	libxfs_refcountbt_calc_reserves
> -#define xfs_refcountbt_init_cursor	libxfs_refcountbt_init_cursor
> -#define xfs_refcountbt_maxrecs		libxfs_refcountbt_maxrecs
> -#define xfs_refcount_get_rec		libxfs_refcount_get_rec
> -#define xfs_refcount_lookup_le		libxfs_refcount_lookup_le
> -
> -#define xfs_rmap_alloc			libxfs_rmap_alloc
> -#define xfs_rmapbt_calc_reserves	libxfs_rmapbt_calc_reserves
> -#define xfs_rmapbt_init_cursor		libxfs_rmapbt_init_cursor
> -#define xfs_rmapbt_maxrecs		libxfs_rmapbt_maxrecs
> -#define xfs_rmap_compare		libxfs_rmap_compare
> -#define xfs_rmap_get_rec		libxfs_rmap_get_rec
> -#define xfs_rmap_irec_offset_pack	libxfs_rmap_irec_offset_pack
> -#define xfs_rmap_irec_offset_unpack	libxfs_rmap_irec_offset_unpack
> -#define xfs_rmap_lookup_le		libxfs_rmap_lookup_le
> -#define xfs_rmap_lookup_le_range	libxfs_rmap_lookup_le_range
> -#define xfs_rmap_query_range		libxfs_rmap_query_range
> -
> -#define xfs_rtfree_extent		libxfs_rtfree_extent
> -#define xfs_sb_from_disk		libxfs_sb_from_disk
> -#define xfs_sb_quota_from_disk		libxfs_sb_quota_from_disk
> -#define xfs_sb_read_secondary		libxfs_sb_read_secondary
> -#define xfs_sb_to_disk			libxfs_sb_to_disk
> -#define xfs_symlink_blocks		libxfs_symlink_blocks
> -#define xfs_symlink_hdr_ok		libxfs_symlink_hdr_ok
> -
> -#define xfs_trans_add_item		libxfs_trans_add_item
> -#define xfs_trans_alloc_empty		libxfs_trans_alloc_empty
> -#define xfs_trans_alloc			libxfs_trans_alloc
> -#define xfs_trans_bhold			libxfs_trans_bhold
> -#define xfs_trans_bhold_release		libxfs_trans_bhold_release
> -#define xfs_trans_binval		libxfs_trans_binval
> -#define xfs_trans_bjoin			libxfs_trans_bjoin
> -#define xfs_trans_brelse		libxfs_trans_brelse
> -#define xfs_trans_cancel		libxfs_trans_cancel
> -#define xfs_trans_commit		libxfs_trans_commit
> -#define xfs_trans_del_item		libxfs_trans_del_item
> -#define xfs_trans_dirty_buf		libxfs_trans_dirty_buf
> -#define xfs_trans_get_buf		libxfs_trans_get_buf
> -#define xfs_trans_get_buf_map		libxfs_trans_get_buf_map
> -#define xfs_trans_getsb			libxfs_trans_getsb
> -#define xfs_trans_ichgtime		libxfs_trans_ichgtime
> -#define xfs_trans_ijoin			libxfs_trans_ijoin
> -#define xfs_trans_init			libxfs_trans_init
> -#define xfs_trans_inode_alloc_buf	libxfs_trans_inode_alloc_buf
> -#define xfs_trans_log_buf		libxfs_trans_log_buf
> -#define xfs_trans_log_inode		libxfs_trans_log_inode
> -#define xfs_trans_mod_sb		libxfs_trans_mod_sb
> -#define xfs_trans_ordered_buf		libxfs_trans_ordered_buf
> -#define xfs_trans_read_buf		libxfs_trans_read_buf
> -#define xfs_trans_read_buf_map		libxfs_trans_read_buf_map
> -#define xfs_trans_resv_calc		libxfs_trans_resv_calc
> -#define xfs_trans_roll_inode		libxfs_trans_roll_inode
> -#define xfs_trans_roll			libxfs_trans_roll
> -
> -#define xfs_verify_cksum		libxfs_verify_cksum
> -#define xfs_verify_dir_ino		libxfs_verify_dir_ino
> -#define xfs_verify_ino			libxfs_verify_ino
> -#define xfs_verify_rtbno		libxfs_verify_rtbno
> -#define xfs_zero_extent			libxfs_zero_extent
> -
> -/* Please keep this list alphabetized. */
> -
> -#endif /* __LIBXFS_API_DEFS_H__ */
> diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
> index 34462f78..e6d758f9 100644
> --- a/libxfs/libxfs_io.h
> +++ b/libxfs/libxfs_io.h
> @@ -130,22 +130,22 @@ extern struct cache_operations	libxfs_bcache_operations;
>  
>  #ifdef XFS_BUF_TRACING
>  
> -#define libxfs_buf_read(dev, daddr, len, flags, bpp, ops) \
> +#define xfs_buf_read(dev, daddr, len, flags, bpp, ops) \
>  	libxfs_trace_readbuf(__FUNCTION__, __FILE__, __LINE__, \
>  			    (dev), (daddr), (len), (flags), (bpp), (ops))
> -#define libxfs_buf_read_map(dev, map, nmaps, flags, bpp, ops) \
> +#define xfs_buf_read_map(dev, map, nmaps, flags, bpp, ops) \
>  	libxfs_trace_readbuf_map(__FUNCTION__, __FILE__, __LINE__, \
>  			    (dev), (map), (nmaps), (flags), (bpp), (ops))
>  #define libxfs_buf_mark_dirty(buf) \
>  	libxfs_trace_dirtybuf(__FUNCTION__, __FILE__, __LINE__, \
>  			      (buf))
> -#define libxfs_buf_get(dev, daddr, len, bpp) \
> +#define xfs_buf_get(dev, daddr, len, bpp) \
>  	libxfs_trace_getbuf(__FUNCTION__, __FILE__, __LINE__, \
>  			    (dev), (daddr), (len), (bpp))
> -#define libxfs_buf_get_map(dev, map, nmaps, flags, bpp) \
> +#define xfs_buf_get_map(dev, map, nmaps, flags, bpp) \
>  	libxfs_trace_getbuf_map(__FUNCTION__, __FILE__, __LINE__, \
>  			    (dev), (map), (nmaps), (flags), (bpp))
> -#define libxfs_buf_relse(buf) \
> +#define xfs_buf_relse(buf) \
>  	libxfs_trace_putbuf(__FUNCTION__, __FILE__, __LINE__, (buf))
>  
>  int libxfs_trace_readbuf(const char *func, const char *file, int line,
> @@ -169,16 +169,16 @@ extern void	libxfs_trace_putbuf (const char *, const char *, int,
>  
>  #else
>  
> -int libxfs_buf_read_map(struct xfs_buftarg *btp, struct xfs_buf_map *maps,
> +int xfs_buf_read_map(struct xfs_buftarg *btp, struct xfs_buf_map *maps,
>  			int nmaps, int flags, struct xfs_buf **bpp,
>  			const struct xfs_buf_ops *ops);
>  void libxfs_buf_mark_dirty(struct xfs_buf *bp);
> -int libxfs_buf_get_map(struct xfs_buftarg *btp, struct xfs_buf_map *maps,
> +int xfs_buf_get_map(struct xfs_buftarg *btp, struct xfs_buf_map *maps,
>  			int nmaps, int flags, struct xfs_buf **bpp);
> -void	libxfs_buf_relse(struct xfs_buf *bp);
> +void	xfs_buf_relse(struct xfs_buf *bp);
>  
>  static inline int
> -libxfs_buf_get(
> +xfs_buf_get(
>  	struct xfs_buftarg	*target,
>  	xfs_daddr_t		blkno,
>  	size_t			numblks,
> @@ -186,11 +186,11 @@ libxfs_buf_get(
>  {
>  	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
>  
> -	return libxfs_buf_get_map(target, &map, 1, 0, bpp);
> +	return xfs_buf_get_map(target, &map, 1, 0, bpp);
>  }
>  
>  static inline int
> -libxfs_buf_read(
> +xfs_buf_read(
>  	struct xfs_buftarg	*target,
>  	xfs_daddr_t		blkno,
>  	size_t			numblks,
> @@ -200,7 +200,7 @@ libxfs_buf_read(
>  {
>  	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
>  
> -	return libxfs_buf_read_map(target, &map, 1, flags, bpp, ops);
> +	return xfs_buf_read_map(target, &map, 1, flags, bpp, ops);
>  }
>  
>  #endif /* XFS_BUF_TRACING */
> @@ -213,7 +213,7 @@ extern void	libxfs_bcache_flush(void);
>  extern int	libxfs_bcache_overflowed(void);
>  
>  /* Buffer (Raw) Interfaces */
> -int		libxfs_bwrite(struct xfs_buf *bp);
> +int		xfs_bwrite(struct xfs_buf *bp);
>  extern int	libxfs_readbufr(struct xfs_buftarg *, xfs_daddr_t, xfs_buf_t *, int, int);
>  extern int	libxfs_readbufr_map(struct xfs_buftarg *, struct xfs_buf *, int);
>  
> @@ -243,9 +243,9 @@ xfs_buf_associate_memory(struct xfs_buf *bp, void *mem, size_t len)
>  	return 0;
>  }
>  
> -int libxfs_buf_get_uncached(struct xfs_buftarg *targ, size_t bblen, int flags,
> +int xfs_buf_get_uncached(struct xfs_buftarg *targ, size_t bblen, int flags,
>  		struct xfs_buf **bpp);
> -int libxfs_buf_read_uncached(struct xfs_buftarg *targ, xfs_daddr_t daddr,
> +int xfs_buf_read_uncached(struct xfs_buftarg *targ, xfs_daddr_t daddr,
>  		size_t bblen, int flags, struct xfs_buf **bpp,
>  		const struct xfs_buf_ops *ops);
>  
> diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
> index 5688284d..0d05fb2f 100644
> --- a/libxfs/libxfs_priv.h
> +++ b/libxfs/libxfs_priv.h
> @@ -37,7 +37,6 @@
>  #ifndef __LIBXFS_INTERNAL_XFS_H__
>  #define __LIBXFS_INTERNAL_XFS_H__
>  
> -#include "libxfs_api_defs.h"
>  #include "platform_defs.h"
>  #include "xfs.h"
>  
> @@ -573,8 +572,8 @@ xfs_buf_corruption_error(struct xfs_buf *bp, xfs_failaddr_t fa);
>  
>  /* XXX: this is clearly a bug - a shared header needs to export this */
>  /* xfs_rtalloc.c */
> -int libxfs_rtfree_extent(struct xfs_trans *, xfs_rtblock_t, xfs_extlen_t);
> -bool libxfs_verify_rtbno(struct xfs_mount *mp, xfs_rtblock_t rtbno);
> +int xfs_rtfree_extent(struct xfs_trans *, xfs_rtblock_t, xfs_extlen_t);
> +bool xfs_verify_rtbno(struct xfs_mount *mp, xfs_rtblock_t rtbno);
>  
>  struct xfs_rtalloc_rec {
>  	xfs_rtblock_t		ar_startext;
> @@ -586,7 +585,7 @@ typedef int (*xfs_rtalloc_query_range_fn)(
>  	struct xfs_rtalloc_rec	*rec,
>  	void			*priv);
>  
> -int libxfs_zero_extent(struct xfs_inode *ip, xfs_fsblock_t start_fsb,
> +int xfs_zero_extent(struct xfs_inode *ip, xfs_fsblock_t start_fsb,
>                          xfs_off_t count_fsb);
>  
>  
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index 13a414d7..5f250278 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -32,7 +32,7 @@ static void libxfs_brelse(struct cache_node *node);
>   * outside libxfs clears bp->b_error - very little code even checks it - so the
>   * libxfs code is tripping on stale errors left by the userspace code.
>   *
> - * We can't clear errors or zero buffer contents in libxfs_buf_get-* like we do
> + * We can't clear errors or zero buffer contents in xfs_buf_get-* like we do
>   * in the kernel, because those functions are used by the libxfs_readbuf_*
>   * functions and hence need to leave the buffers unchanged on cache hits. This
>   * is actually the only way to gather a write error from a libxfs_writebuf()
> @@ -46,11 +46,11 @@ static void libxfs_brelse(struct cache_node *node);
>   *
>   * IOWs, userspace is behaving quite differently to the kernel and as a result
>   * it leaks errors from reads, invalidations and writes through
> - * libxfs_buf_get/libxfs_buf_read.
> + * xfs_buf_get/xfs_buf_read.
>   *
>   * The result of this is that until the userspace code outside libxfs is cleaned
>   * up, functions that release buffers from userspace control (i.e
> - * libxfs_writebuf/libxfs_buf_relse) need to zero bp->b_error to prevent
> + * libxfs_writebuf/xfs_buf_relse) need to zero bp->b_error to prevent
>   * propagation of stale errors into future buffer operations.
>   */
>  
> @@ -154,19 +154,19 @@ static char *next(
>  
>  #ifdef XFS_BUF_TRACING
>  
> -#undef libxfs_buf_read_map
> +#undef xfs_buf_read_map
>  #undef libxfs_writebuf
> -#undef libxfs_buf_get_map
> +#undef xfs_buf_get_map
>  
> -int		libxfs_buf_read_map(struct xfs_buftarg *btp,
> +int		bxfs_buf_read_map(struct xfs_buftarg *btp,
>  				struct xfs_buf_map *maps, int nmaps, int flags,
>  				struct xfs_buf **bpp,
>  				const struct xfs_buf_ops *ops);
>  int		libxfs_writebuf(xfs_buf_t *, int);
> -int		libxfs_buf_get_map(struct xfs_buftarg *btp,
> +int		xfs_buf_get_map(struct xfs_buftarg *btp,
>  				struct xfs_buf_map *maps, int nmaps, int flags,
>  				struct xfs_buf **bpp);
> -void		libxfs_buf_relse(struct xfs_buf *bp);
> +void		xfs_buf_relse(struct xfs_buf *bp);
>  
>  #define	__add_trace(bp, func, file, line)	\
>  do {						\
> @@ -192,7 +192,7 @@ libxfs_trace_readbuf(
>  	int			error;
>  	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
>  
> -	error = libxfs_buf_read_map(btp, &map, 1, flags, bpp, ops);
> +	error = xfs_buf_read_map(btp, &map, 1, flags, bpp, ops);
>  	__add_trace(*bpp, func, file, line);
>  	return error;
>  }
> @@ -211,7 +211,7 @@ libxfs_trace_readbuf_map(
>  {
>  	int			error;
>  
> -	error = libxfs_buf_read_map(btp, map, nmaps, flags, bpp, ops);
> +	error = xfs_buf_read_map(btp, map, nmaps, flags, bpp, ops);
>  	__add_trace(*bpp, func, file, line);
>  	return error;
>  }
> @@ -240,7 +240,7 @@ libxfs_trace_getbuf(
>  	int			error;
>  	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
>  
> -	error = libxfs_buf_get_map(target, &map, 1, 0, bpp);
> +	error = xfs_buf_get_map(target, &map, 1, 0, bpp);
>  	__add_trace(bp, func, file, line);
>  	return error;
>  }
> @@ -258,7 +258,7 @@ libxfs_trace_getbuf_map(
>  {
>  	int			error;
>  
> -	error = libxfs_buf_get_map(btp, map, nmaps, flags, bpp);
> +	error = xfs_buf_get_map(btp, map, nmaps, flags, bpp);
>  	__add_trace(*bpp, func, file, line);
>  	return error;
>  }
> @@ -267,7 +267,7 @@ void
>  libxfs_trace_putbuf(const char *func, const char *file, int line, xfs_buf_t *bp)
>  {
>  	__add_trace(bp, func, file, line);
> -	libxfs_buf_relse(bp);
> +	xfs_buf_relse(bp);
>  }
>  
>  
> @@ -280,7 +280,7 @@ libxfs_getsb(
>  {
>  	struct xfs_buf		*bp;
>  
> -	libxfs_buf_read(mp->m_ddev_targp, XFS_SB_DADDR, XFS_FSS_TO_BB(mp, 1),
> +	xfs_buf_read(mp->m_ddev_targp, XFS_SB_DADDR, XFS_FSS_TO_BB(mp, 1),
>  			0, &bp, &xfs_sb_buf_ops);
>  	return bp;
>  }
> @@ -641,7 +641,7 @@ __libxfs_buf_get_map(
>  }
>  
>  int
> -libxfs_buf_get_map(
> +xfs_buf_get_map(
>  	struct xfs_buftarg	*btp,
>  	struct xfs_buf_map	*map,
>  	int			nmaps,
> @@ -659,7 +659,7 @@ libxfs_buf_get_map(
>  }
>  
>  void
> -libxfs_buf_relse(
> +xfs_buf_relse(
>  	struct xfs_buf	*bp)
>  {
>  	/*
> @@ -688,7 +688,7 @@ libxfs_buf_relse(
>  		cache_node_put(libxfs_bcache, &bp->b_node);
>  	else if (--bp->b_node.cn_count == 0) {
>  		if (bp->b_flags & LIBXFS_B_DIRTY)
> -			libxfs_bwrite(bp);
> +			xfs_bwrite(bp);
>  		libxfs_brelse(&bp->b_node);
>  	}
>  }
> @@ -801,7 +801,7 @@ libxfs_readbufr_map(struct xfs_buftarg *btp, struct xfs_buf *bp, int flags)
>  }
>  
>  int
> -libxfs_buf_read_map(
> +xfs_buf_read_map(
>  	struct xfs_buftarg	*btp,
>  	struct xfs_buf_map	*map,
>  	int			nmaps,
> @@ -874,7 +874,7 @@ ok:
>  	*bpp = bp;
>  	return 0;
>  err:
> -	libxfs_buf_relse(bp);
> +	xfs_buf_relse(bp);
>  	return error;
>  }
>  
> @@ -901,7 +901,7 @@ libxfs_getbufr_uncached(
>   * and the cache node hash list will be empty to indicate that it's uncached.
>   */
>  int
> -libxfs_buf_get_uncached(
> +xfs_buf_get_uncached(
>  	struct xfs_buftarg	*targ,
>  	size_t			bblen,
>  	int			flags,
> @@ -916,7 +916,7 @@ libxfs_buf_get_uncached(
>   * node hash list will be empty to indicate that it's uncached.
>   */
>  int
> -libxfs_buf_read_uncached(
> +xfs_buf_read_uncached(
>  	struct xfs_buftarg	*targ,
>  	xfs_daddr_t		daddr,
>  	size_t			bblen,
> @@ -943,7 +943,7 @@ libxfs_buf_read_uncached(
>  	*bpp = bp;
>  	return 0;
>  err:
> -	libxfs_buf_relse(bp);
> +	xfs_buf_relse(bp);
>  	return error;
>  }
>  
> @@ -967,7 +967,7 @@ __write_buf(int fd, void *buf, int len, off64_t offset, int flags)
>  }
>  
>  int
> -libxfs_bwrite(
> +xfs_bwrite(
>  	struct xfs_buf	*bp)
>  {
>  	int		fd = libxfs_device_to_fd(bp->b_target->dev);
> @@ -1147,7 +1147,7 @@ libxfs_bflush(
>  						   b_node);
>  
>  	if (!bp->b_error && bp->b_flags & LIBXFS_B_DIRTY)
> -		return libxfs_bwrite(bp);
> +		return xfs_bwrite(bp);
>  	return bp->b_error;
>  }
>  
> @@ -1228,7 +1228,7 @@ extern kmem_zone_t	*xfs_ili_zone;
>   * make sure they're not corrupt.
>   */
>  bool
> -libxfs_inode_verify_forks(
> +xfs_inode_verify_forks(
>  	struct xfs_inode	*ip)
>  {
>  	struct xfs_ifork	*ifp;
> @@ -1282,7 +1282,7 @@ libxfs_iget(
>  	}
>  
>  	ip->i_fork_ops = ifork_ops;
> -	if (!libxfs_inode_verify_forks(ip)) {
> +	if (!xfs_inode_verify_forks(ip)) {
>  		libxfs_irele(ip);
>  		return -EFSCORRUPTED;
>  	}
> @@ -1298,11 +1298,11 @@ libxfs_idestroy(xfs_inode_t *ip)
>  		case S_IFREG:
>  		case S_IFDIR:
>  		case S_IFLNK:
> -			libxfs_idestroy_fork(ip, XFS_DATA_FORK);
> +			xfs_idestroy_fork(ip, XFS_DATA_FORK);
>  			break;
>  	}
>  	if (ip->i_afp)
> -		libxfs_idestroy_fork(ip, XFS_ATTR_FORK);
> +		xfs_idestroy_fork(ip, XFS_ATTR_FORK);
>  	if (ip->i_cowfp)
>  		xfs_idestroy_fork(ip, XFS_COW_FORK);
>  }
> @@ -1351,10 +1351,10 @@ xfs_buf_delwri_submit(
>  
>  	list_for_each_entry_safe(bp, n, buffer_list, b_list) {
>  		list_del_init(&bp->b_list);
> -		error2 = libxfs_bwrite(bp);
> +		error2 = xfs_bwrite(bp);
>  		if (!error)
>  			error = error2;
> -		libxfs_buf_relse(bp);
> +		xfs_buf_relse(bp);
>  	}
>  
>  	return error;
> @@ -1376,7 +1376,7 @@ xfs_buf_delwri_cancel(
>  		bp = list_first_entry(list, struct xfs_buf, b_list);
>  
>  		list_del_init(&bp->b_list);
> -		libxfs_buf_relse(bp);
> +		xfs_buf_relse(bp);
>  	}
>  }
>  
> @@ -1441,7 +1441,7 @@ libxfs_log_clear(
>  			  next, bp);
>  	if (bp) {
>  		libxfs_buf_mark_dirty(bp);
> -		libxfs_buf_relse(bp);
> +		xfs_buf_relse(bp);
>  	}
>  
>  	/*
> @@ -1493,7 +1493,7 @@ libxfs_log_clear(
>  				  tail_lsn, next, bp);
>  		if (bp) {
>  			libxfs_buf_mark_dirty(bp);
> -			libxfs_buf_relse(bp);
> +			xfs_buf_relse(bp);
>  		}
>  
>  		blk += len;
> diff --git a/libxfs/trans.c b/libxfs/trans.c
> index ddd07cff..2569b580 100644
> --- a/libxfs/trans.c
> +++ b/libxfs/trans.c
> @@ -37,7 +37,7 @@ kmem_zone_t	*xfs_trans_zone;
>   * in the mount structure.
>   */
>  void
> -libxfs_trans_init(
> +xfs_trans_init(
>  	struct xfs_mount	*mp)
>  {
>  	xfs_trans_resv_calc(mp, &mp->m_resv);
> @@ -47,7 +47,7 @@ libxfs_trans_init(
>   * Add the given log item to the transaction's list of log items.
>   */
>  void
> -libxfs_trans_add_item(
> +xfs_trans_add_item(
>  	struct xfs_trans	*tp,
>  	struct xfs_log_item	*lip)
>  {
> @@ -63,7 +63,7 @@ libxfs_trans_add_item(
>   * Unlink and free the given descriptor.
>   */
>  void
> -libxfs_trans_del_item(
> +xfs_trans_del_item(
>  	struct xfs_log_item	*lip)
>  {
>  	clear_bit(XFS_LI_DIRTY, &lip->li_flags);
> @@ -78,7 +78,7 @@ libxfs_trans_del_item(
>   * chunk we've been working on and get a new transaction to continue.
>   */
>  int
> -libxfs_trans_roll(
> +xfs_trans_roll(
>  	struct xfs_trans	**tpp)
>  {
>  	struct xfs_trans	*trans = *tpp;
> @@ -246,7 +246,7 @@ undo_blocks:
>  }
>  
>  int
> -libxfs_trans_alloc(
> +xfs_trans_alloc(
>  	struct xfs_mount	*mp,
>  	struct xfs_trans_res	*resp,
>  	unsigned int		blocks,
> @@ -289,7 +289,7 @@ libxfs_trans_alloc(
>   * without any dirty data.
>   */
>  int
> -libxfs_trans_alloc_empty(
> +xfs_trans_alloc_empty(
>  	struct xfs_mount		*mp,
>  	struct xfs_trans		**tpp)
>  {
> @@ -304,17 +304,17 @@ libxfs_trans_alloc_empty(
>   * permanent log reservation flag to avoid blowing asserts.
>   */
>  int
> -libxfs_trans_alloc_rollable(
> +xfs_trans_alloc_rollable(
>  	struct xfs_mount	*mp,
>  	unsigned int		blocks,
>  	struct xfs_trans	**tpp)
>  {
> -	return libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, blocks,
> +	return xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, blocks,
>  			0, 0, tpp);
>  }
>  
>  void
> -libxfs_trans_cancel(
> +xfs_trans_cancel(
>  	struct xfs_trans	*tp)
>  {
>  	trace_xfs_trans_cancel(tp, _RET_IP_);
> @@ -351,7 +351,7 @@ xfs_buf_item_put(
>   * then allocate one for it.  Then add the buf item to the transaction.
>   */
>  STATIC void
> -_libxfs_trans_bjoin(
> +_xfs_trans_bjoin(
>  	struct xfs_trans	*tp,
>  	struct xfs_buf		*bp,
>  	int			reset_recur)
> @@ -380,11 +380,11 @@ _libxfs_trans_bjoin(
>  }
>  
>  void
> -libxfs_trans_bjoin(
> +xfs_trans_bjoin(
>  	struct xfs_trans	*tp,
>  	struct xfs_buf		*bp)
>  {
> -	_libxfs_trans_bjoin(tp, bp, 0);
> +	_xfs_trans_bjoin(tp, bp, 0);
>  	trace_xfs_trans_bjoin(bp->b_log_item);
>  }
>  
> @@ -393,7 +393,7 @@ libxfs_trans_bjoin(
>   * for this transaction.
>   */
>  void
> -libxfs_trans_bhold_release(
> +xfs_trans_bhold_release(
>  	xfs_trans_t		*tp,
>  	xfs_buf_t		*bp)
>  {
> @@ -416,7 +416,7 @@ libxfs_trans_bhold_release(
>   * get_buf() call.
>   */
>  int
> -libxfs_trans_get_buf_map(
> +xfs_trans_get_buf_map(
>  	struct xfs_trans	*tp,
>  	struct xfs_buftarg	*target,
>  	struct xfs_buf_map	*map,
> @@ -430,7 +430,7 @@ libxfs_trans_get_buf_map(
>  
>  	*bpp = NULL;
>  	if (!tp)
> -		return libxfs_buf_get_map(target, map, nmaps, 0, bpp);
> +		return xfs_buf_get_map(target, map, nmaps, 0, bpp);
>  
>  	/*
>  	 * If we find the buffer in the cache with this transaction
> @@ -449,20 +449,20 @@ libxfs_trans_get_buf_map(
>  		return 0;
>  	}
>  
> -	error = libxfs_buf_get_map(target, map, nmaps, 0, &bp);
> +	error = xfs_buf_get_map(target, map, nmaps, 0, &bp);
>  	if (error)
>  		return error;
>  
>  	ASSERT(!bp->b_error);
>  
> -	_libxfs_trans_bjoin(tp, bp, 1);
> +	_xfs_trans_bjoin(tp, bp, 1);
>  	trace_xfs_trans_get_buf(bp->b_log_item);
>  	*bpp = bp;
>  	return 0;
>  }
>  
>  xfs_buf_t *
> -libxfs_trans_getsb(
> +xfs_trans_getsb(
>  	xfs_trans_t		*tp,
>  	struct xfs_mount	*mp)
>  {
> @@ -488,13 +488,13 @@ libxfs_trans_getsb(
>  	if (bp == NULL)
>  		return NULL;
>  
> -	_libxfs_trans_bjoin(tp, bp, 1);
> +	_xfs_trans_bjoin(tp, bp, 1);
>  	trace_xfs_trans_getsb(bp->b_log_item);
>  	return bp;
>  }
>  
>  int
> -libxfs_trans_read_buf_map(
> +xfs_trans_read_buf_map(
>  	struct xfs_mount	*mp,
>  	struct xfs_trans	*tp,
>  	struct xfs_buftarg	*target,
> @@ -511,7 +511,7 @@ libxfs_trans_read_buf_map(
>  	*bpp = NULL;
>  
>  	if (tp == NULL)
> -		return libxfs_buf_read_map(target, map, nmaps, flags, bpp, ops);
> +		return xfs_buf_read_map(target, map, nmaps, flags, bpp, ops);
>  
>  	bp = xfs_trans_buf_item_match(tp, target, map, nmaps);
>  	if (bp) {
> @@ -523,11 +523,11 @@ libxfs_trans_read_buf_map(
>  		goto done;
>  	}
>  
> -	error = libxfs_buf_read_map(target, map, nmaps, flags, &bp, ops);
> +	error = xfs_buf_read_map(target, map, nmaps, flags, &bp, ops);
>  	if (error)
>  		return error;
>  
> -	_libxfs_trans_bjoin(tp, bp, 1);
> +	_xfs_trans_bjoin(tp, bp, 1);
>  done:
>  	trace_xfs_trans_read_buf(bp->b_log_item);
>  	*bpp = bp;
> @@ -547,7 +547,7 @@ done:
>   * If the transaction pointer is NULL, this is a normal xfs_buf_relse() call.
>   */
>  void
> -libxfs_trans_brelse(
> +xfs_trans_brelse(
>  	struct xfs_trans	*tp,
>  	struct xfs_buf		*bp)
>  {
> @@ -556,7 +556,7 @@ libxfs_trans_brelse(
>  	ASSERT(bp->b_transp == tp);
>  
>  	if (!tp) {
> -		libxfs_buf_relse(bp);
> +		xfs_buf_relse(bp);
>  		return;
>  	}
>  
> @@ -592,7 +592,7 @@ libxfs_trans_brelse(
>  	xfs_buf_item_put(bip);
>  
>  	bp->b_transp = NULL;
> -	libxfs_buf_relse(bp);
> +	xfs_buf_relse(bp);
>  }
>  
>  /*
> @@ -602,7 +602,7 @@ libxfs_trans_brelse(
>   */
>  /* ARGSUSED */
>  void
> -libxfs_trans_bhold(
> +xfs_trans_bhold(
>  	xfs_trans_t		*tp,
>  	xfs_buf_t		*bp)
>  {
> @@ -619,7 +619,7 @@ libxfs_trans_bhold(
>   * Mark a buffer dirty in the transaction.
>   */
>  void
> -libxfs_trans_dirty_buf(
> +xfs_trans_dirty_buf(
>  	struct xfs_trans	*tp,
>  	struct xfs_buf		*bp)
>  {
> @@ -642,7 +642,7 @@ libxfs_trans_dirty_buf(
>   * value of b_blkno.
>   */
>  void
> -libxfs_trans_log_buf(
> +xfs_trans_log_buf(
>  	struct xfs_trans	*tp,
>  	struct xfs_buf		*bp,
>  	uint			first,
> @@ -659,7 +659,7 @@ libxfs_trans_log_buf(
>  }
>  
>  void
> -libxfs_trans_binval(
> +xfs_trans_binval(
>  	xfs_trans_t		*tp,
>  	xfs_buf_t		*bp)
>  {
> @@ -693,7 +693,7 @@ libxfs_trans_binval(
>   */
>  /* ARGSUSED */
>  void
> -libxfs_trans_inode_alloc_buf(
> +xfs_trans_inode_alloc_buf(
>  	xfs_trans_t		*tp,
>  	xfs_buf_t		*bp)
>  {
> @@ -713,7 +713,7 @@ libxfs_trans_inode_alloc_buf(
>   * If the buffer is already dirty, trigger the "already logged" return condition.
>   */
>  bool
> -libxfs_trans_ordered_buf(
> +xfs_trans_ordered_buf(
>  	struct xfs_trans	*tp,
>  	struct xfs_buf		*bp)
>  {
> @@ -721,7 +721,7 @@ libxfs_trans_ordered_buf(
>  	bool			ret;
>  
>  	ret = test_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags);
> -	libxfs_trans_log_buf(tp, bp, 0, bp->b_bcount);
> +	xfs_trans_log_buf(tp, bp, 0, bp->b_bcount);
>  	return ret;
>  }
>  
> @@ -737,7 +737,7 @@ libxfs_trans_ordered_buf(
>   * Originally derived from xfs_trans_mod_sb().
>   */
>  void
> -libxfs_trans_mod_sb(
> +xfs_trans_mod_sb(
>  	xfs_trans_t		*tp,
>  	uint			field,
>  	long			delta)
> @@ -829,12 +829,12 @@ inode_item_done(
>  	if (error) {
>  		fprintf(stderr, _("%s: warning - iflush_int failed (%d)\n"),
>  			progname, error);
> -		libxfs_buf_relse(bp);
> +		xfs_buf_relse(bp);
>  		goto free;
>  	}
>  
>  	libxfs_buf_mark_dirty(bp);
> -	libxfs_buf_relse(bp);
> +	xfs_buf_relse(bp);
>  free:
>  	xfs_inode_item_put(iip);
>  }
> @@ -859,7 +859,7 @@ buf_item_done(
>  	xfs_buf_item_put(bip);
>  	if (hold)
>  		return;
> -	libxfs_buf_relse(bp);
> +	xfs_buf_relse(bp);
>  }
>  
>  static void
> @@ -897,7 +897,7 @@ buf_item_unlock(
>  	bip->bli_flags &= ~XFS_BLI_HOLD;
>  	xfs_buf_item_put(bip);
>  	if (!hold)
> -		libxfs_buf_relse(bp);
> +		xfs_buf_relse(bp);
>  }
>  
>  static void
> @@ -985,7 +985,7 @@ out_unreserve:
>  }
>  
>  int
> -libxfs_trans_commit(
> +xfs_trans_commit(
>  	struct xfs_trans	*tp)
>  {
>  	return __xfs_trans_commit(tp, false);
> diff --git a/libxfs/util.c b/libxfs/util.c
> index 914e4ca5..523d5950 100644
> --- a/libxfs/util.c
> +++ b/libxfs/util.c
> @@ -383,7 +383,7 @@ libxfs_iflush_int(xfs_inode_t *ip, xfs_buf_t *bp)
>  		VFS_I(ip)->i_version++;
>  
>  	/* Check the inline fork data before we write out. */
> -	if (!libxfs_inode_verify_forks(ip))
> +	if (!xfs_inode_verify_forks(ip))
>  		return -EFSCORRUPTED;
>  
>  	/*
> @@ -432,7 +432,7 @@ libxfs_mod_incore_sb(
>   * Originally derived from xfs_alloc_file_space().
>   */
>  int
> -libxfs_alloc_file_space(
> +xfs_alloc_file_space(
>  	xfs_inode_t	*ip,
>  	xfs_off_t	offset,
>  	xfs_off_t	len,
> @@ -516,7 +516,7 @@ error0:	/* Cancel bmap, cancel trans */
>   * other in repair - now there is just the one.
>   */
>  int
> -libxfs_inode_alloc(
> +xfs_inode_alloc(
>  	xfs_trans_t	**tp,
>  	xfs_inode_t	*pip,
>  	mode_t		mode,
> @@ -700,7 +700,7 @@ xfs_fsb_to_db(struct xfs_inode *ip, xfs_fsblock_t fsb)
>  }
>  
>  int
> -libxfs_zero_extent(
> +xfs_zero_extent(
>  	struct xfs_inode *ip,
>  	xfs_fsblock_t	start_fsb,
>  	xfs_off_t	count_fsb)
> diff --git a/libxlog/xfs_log_recover.c b/libxlog/xfs_log_recover.c
> index 78fbafab..7db0be47 100644
> --- a/libxlog/xfs_log_recover.c
> +++ b/libxlog/xfs_log_recover.c
> @@ -69,7 +69,7 @@ xlog_get_bp(
>  		nbblks += log->l_sectBBsize;
>  	nbblks = round_up(nbblks, log->l_sectBBsize);
>  
> -	libxfs_buf_get_uncached(log->l_dev, nbblks, 0, &bp);
> +	xfs_buf_get_uncached(log->l_dev, nbblks, 0, &bp);
>  	return bp;
>  }
>  
> @@ -270,7 +270,7 @@ xlog_find_verify_cycle(
>  	*new_blk = -1;
>  
>  out:
> -	libxfs_buf_relse(bp);
> +	xfs_buf_relse(bp);
>  	return error;
>  }
>  
> @@ -379,7 +379,7 @@ xlog_find_verify_log_record(
>  		*last_blk = i;
>  
>  out:
> -	libxfs_buf_relse(bp);
> +	xfs_buf_relse(bp);
>  	return error;
>  }
>  
> @@ -630,7 +630,7 @@ validate_head:
>  			goto bp_err;
>  	}
>  
> -	libxfs_buf_relse(bp);
> +	xfs_buf_relse(bp);
>  	if (head_blk == log_bbnum)
>  		*return_head_blk = 0;
>  	else
> @@ -644,7 +644,7 @@ validate_head:
>  	return 0;
>  
>   bp_err:
> -	libxfs_buf_relse(bp);
> +	xfs_buf_relse(bp);
>  
>  	if (error)
>  		xfs_warn(log->l_mp, "failed to find log head");
> @@ -741,7 +741,7 @@ xlog_find_tail(
>  	}
>  	if (!found) {
>  		xfs_warn(log->l_mp, "%s: couldn't find sync record", __func__);
> -		libxfs_buf_relse(bp);
> +		xfs_buf_relse(bp);
>  		ASSERT(0);
>  		return XFS_ERROR(EIO);
>  	}
> @@ -854,7 +854,7 @@ xlog_find_tail(
>  		error = xlog_clear_stale_blocks(log, tail_lsn);
>  
>  done:
> -	libxfs_buf_relse(bp);
> +	xfs_buf_relse(bp);
>  
>  	if (error)
>  		xfs_warn(log->l_mp, "failed to locate log tail");
> @@ -902,7 +902,7 @@ xlog_find_zeroed(
>  	first_cycle = xlog_get_cycle(offset);
>  	if (first_cycle == 0) {		/* completely zeroed log */
>  		*blk_no = 0;
> -		libxfs_buf_relse(bp);
> +		xfs_buf_relse(bp);
>  		return -1;
>  	}
>  
> @@ -913,7 +913,7 @@ xlog_find_zeroed(
>  
>  	last_cycle = xlog_get_cycle(offset);
>  	if (last_cycle != 0) {		/* log completely written to */
> -		libxfs_buf_relse(bp);
> +		xfs_buf_relse(bp);
>  		return 0;
>  	} else if (first_cycle != 1) {
>  		/*
> @@ -970,7 +970,7 @@ xlog_find_zeroed(
>  
>  	*blk_no = last_blk;
>  bp_err:
> -	libxfs_buf_relse(bp);
> +	xfs_buf_relse(bp);
>  	if (error)
>  		return error;
>  	return -1;
> @@ -1453,7 +1453,7 @@ xlog_do_recovery_pass(
>  			hblks = h_size / XLOG_HEADER_CYCLE_SIZE;
>  			if (h_size % XLOG_HEADER_CYCLE_SIZE)
>  				hblks++;
> -			libxfs_buf_relse(hbp);
> +			xfs_buf_relse(hbp);
>  			hbp = xlog_get_bp(log, hblks);
>  		} else {
>  			hblks = 1;
> @@ -1469,7 +1469,7 @@ xlog_do_recovery_pass(
>  		return ENOMEM;
>  	dbp = xlog_get_bp(log, BTOBB(h_size));
>  	if (!dbp) {
> -		libxfs_buf_relse(hbp);
> +		xfs_buf_relse(hbp);
>  		return ENOMEM;
>  	}
>  
> @@ -1653,8 +1653,8 @@ xlog_do_recovery_pass(
>  	}
>  
>   bread_err2:
> -	libxfs_buf_relse(dbp);
> +	xfs_buf_relse(dbp);
>   bread_err1:
> -	libxfs_buf_relse(hbp);
> +	xfs_buf_relse(hbp);
>  	return error;
>  }
> diff --git a/logprint/log_misc.c b/logprint/log_misc.c
> index be889887..9cf8a3c0 100644
> --- a/logprint/log_misc.c
> +++ b/logprint/log_misc.c
> @@ -489,12 +489,12 @@ xlog_print_dir2_sf(
>  	count = sfp->count;
>  	sfep = xfs_dir2_sf_firstentry(sfp);
>  	for (i = 0; i < count; i++) {
> -		ino = libxfs_dir2_sf_get_ino(log->l_mp, sfp, sfep);
> +		ino = xfs_dir2_sf_get_ino(log->l_mp, sfp, sfep);
>  		memmove(namebuf, (sfep->name), sfep->namelen);
>  		namebuf[sfep->namelen] = '\0';
>  		printf(_("%s ino 0x%llx namelen %d\n"),
>  		       namebuf, (unsigned long long)ino, sfep->namelen);
> -		sfep = libxfs_dir2_sf_nextentry(log->l_mp, sfp, sfep);
> +		sfep = xfs_dir2_sf_nextentry(log->l_mp, sfp, sfep);
>  	}
>  }
>  
> diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
> index e2e28b9c..6ce09a51 100644
> --- a/logprint/log_print_all.c
> +++ b/logprint/log_print_all.c
> @@ -39,7 +39,7 @@ xlog_print_find_oldest(
>  		error = xlog_find_cycle_start(log, bp, first_blk,
>  					      last_blk, last_half_cycle);
>  
> -	libxfs_buf_relse(bp);
> +	xfs_buf_relse(bp);
>  	return error;
>  }
>  
> diff --git a/logprint/logprint.c b/logprint/logprint.c
> index e882c5d4..b86a2dac 100644
> --- a/logprint/logprint.c
> +++ b/logprint/logprint.c
> @@ -79,7 +79,7 @@ logstat(xfs_mount_t *mp)
>  		 * Conjure up a mount structure
>  		 */
>  		sb = &mp->m_sb;
> -		libxfs_sb_from_disk(sb, (xfs_dsb_t *)buf);
> +		xfs_sb_from_disk(sb, (xfs_dsb_t *)buf);
>  		mp->m_blkbb_log = sb->sb_blocklog - BBSHIFT;
>  
>  		x.logBBsize = XFS_FSB_TO_BB(mp, sb->sb_logblocks);
> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
> index 1cd399db..665e63fc 100644
> --- a/mdrestore/xfs_mdrestore.c
> +++ b/mdrestore/xfs_mdrestore.c
> @@ -89,7 +89,7 @@ perform_restore(
>  	if (fread(block_buffer, mb_count << mbp->mb_blocklog, 1, src_f) != 1)
>  		fatal("error reading from metadump file\n");
>  
> -	libxfs_sb_from_disk(&sb, (xfs_dsb_t *)block_buffer);
> +	xfs_sb_from_disk(&sb, (xfs_dsb_t *)block_buffer);
>  
>  	if (sb.sb_magicnum != XFS_SB_MAGIC)
>  		fatal("bad magic number for primary superblock\n");
> @@ -163,7 +163,7 @@ perform_restore(
>  
>  	memset(block_buffer, 0, sb.sb_sectsize);
>  	sb.sb_inprogress = 0;
> -	libxfs_sb_to_disk((xfs_dsb_t *)block_buffer, &sb);
> +	xfs_sb_to_disk((xfs_dsb_t *)block_buffer, &sb);
>  	if (xfs_sb_version_hascrc(&sb)) {
>  		xfs_update_cksum(block_buffer, sb.sb_sectsize,
>  				 offsetof(struct xfs_sb, sb_crc));
> diff --git a/mkfs/proto.c b/mkfs/proto.c
> index 01b30c5f..191fde07 100644
> --- a/mkfs/proto.c
> +++ b/mkfs/proto.c
> @@ -123,7 +123,7 @@ getres(
>  	uint		r;
>  
>  	for (i = 0, r = MKFS_BLOCKRES(blocks); r >= blocks; r--) {
> -		i = -libxfs_trans_alloc_rollable(mp, r, &tp);
> +		i = -xfs_trans_alloc_rollable(mp, r, &tp);
>  		if (i == 0)
>  			return tp;
>  	}
> @@ -179,7 +179,7 @@ rsvfile(
>  	int		error;
>  	xfs_trans_t	*tp;
>  
> -	error = -libxfs_alloc_file_space(ip, 0, llen, 1, 0);
> +	error = -xfs_alloc_file_space(ip, 0, llen, 1, 0);
>  
>  	if (error) {
>  		fail(_("error reserving space for a file"), error);
> @@ -189,10 +189,10 @@ rsvfile(
>  	/*
>  	 * update the inode timestamp, mode, and prealloc flag bits
>  	 */
> -	error = -libxfs_trans_alloc_rollable(mp, 0, &tp);
> +	error = -xfs_trans_alloc_rollable(mp, 0, &tp);
>  	if (error)
>  		fail(_("allocating transaction for a file"), error);
> -	libxfs_trans_ijoin(tp, ip, 0);
> +	xfs_trans_ijoin(tp, ip, 0);
>  
>  	VFS_I(ip)->i_mode &= ~S_ISUID;
>  
> @@ -206,12 +206,12 @@ rsvfile(
>  	if (VFS_I(ip)->i_mode & S_IXGRP)
>  		VFS_I(ip)->i_mode &= ~S_ISGID;
>  
> -	libxfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
> +	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
>  
>  	ip->i_d.di_flags |= XFS_DIFLAG_PREALLOC;
>  
> -	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> -	error = -libxfs_trans_commit(tp);
> +	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> +	error = -xfs_trans_commit(tp);
>  	if (error)
>  		fail(_("committing space for a file failed"), error);
>  }
> @@ -237,13 +237,13 @@ newfile(
>  	flags = 0;
>  	mp = ip->i_mount;
>  	if (symlink && len <= XFS_IFORK_DSIZE(ip)) {
> -		libxfs_init_local_fork(ip, XFS_DATA_FORK, buf, len);
> +		xfs_init_local_fork(ip, XFS_DATA_FORK, buf, len);
>  		ip->i_d.di_format = XFS_DINODE_FMT_LOCAL;
>  		flags = XFS_ILOG_DDATA;
>  	} else if (len > 0) {
>  		nb = XFS_B_TO_FSB(mp, len);
>  		nmap = 1;
> -		error = -libxfs_bmapi_write(tp, ip, 0, nb, 0, nb, &map, &nmap);
> +		error = -xfs_bmapi_write(tp, ip, 0, nb, 0, nb, &map, &nmap);
>  		if (error) {
>  			fail(_("error allocating space for a file"), error);
>  		}
> @@ -254,7 +254,7 @@ newfile(
>  			exit(1);
>  		}
>  		d = XFS_FSB_TO_DADDR(mp, map.br_startblock);
> -		error = -libxfs_trans_get_buf(logit ? tp : NULL, mp->m_dev, d,
> +		error = -xfs_trans_get_buf(logit ? tp : NULL, mp->m_dev, d,
>  				nb << mp->m_blkbb_log, 0, &bp);
>  		if (error) {
>  			fprintf(stderr,
> @@ -266,10 +266,10 @@ newfile(
>  		if (len < bp->b_bcount)
>  			memset((char *)bp->b_addr + len, 0, bp->b_bcount - len);
>  		if (logit)
> -			libxfs_trans_log_buf(tp, bp, 0, bp->b_bcount - 1);
> +			xfs_trans_log_buf(tp, bp, 0, bp->b_bcount - 1);
>  		else {
>  			libxfs_buf_mark_dirty(bp);
> -			libxfs_buf_relse(bp);
> +			xfs_buf_relse(bp);
>  		}
>  	}
>  	ip->i_d.di_size = len;
> @@ -318,7 +318,7 @@ newdirent(
>  
>  	rsv = XFS_DIRENTER_SPACE_RES(mp, name->len);
>  
> -	error = -libxfs_dir_createname(tp, pip, name, inum, rsv);
> +	error = -xfs_dir_createname(tp, pip, name, inum, rsv);
>  	if (error)
>  		fail(_("directory createname error"), error);
>  }
> @@ -332,7 +332,7 @@ newdirectory(
>  {
>  	int	error;
>  
> -	error = -libxfs_dir_init(tp, dp, pdp);
> +	error = -xfs_dir_init(tp, dp, pdp);
>  	if (error)
>  		fail(_("directory create error"), error);
>  }
> @@ -444,14 +444,14 @@ parseproto(
>  	case IF_REGULAR:
>  		buf = newregfile(pp, &len);
>  		tp = getres(mp, XFS_B_TO_FSB(mp, len));
> -		error = -libxfs_inode_alloc(&tp, pip, mode|S_IFREG, 1, 0,
> +		error = -xfs_inode_alloc(&tp, pip, mode|S_IFREG, 1, 0,
>  					   &creds, fsxp, &ip);
>  		if (error)
>  			fail(_("Inode allocation failed"), error);
>  		flags |= newfile(tp, ip, 0, 0, buf, len);
>  		if (buf)
>  			free(buf);
> -		libxfs_trans_ijoin(tp, pip, 0);
> +		xfs_trans_ijoin(tp, pip, 0);
>  		xname.type = XFS_DIR3_FT_REG_FILE;
>  		newdirent(mp, tp, pip, &xname, ip->i_ino);
>  		break;
> @@ -468,17 +468,17 @@ parseproto(
>  		}
>  		tp = getres(mp, XFS_B_TO_FSB(mp, llen));
>  
> -		error = -libxfs_inode_alloc(&tp, pip, mode|S_IFREG, 1, 0,
> +		error = -xfs_inode_alloc(&tp, pip, mode|S_IFREG, 1, 0,
>  					  &creds, fsxp, &ip);
>  		if (error)
>  			fail(_("Inode pre-allocation failed"), error);
>  
> -		libxfs_trans_ijoin(tp, pip, 0);
> +		xfs_trans_ijoin(tp, pip, 0);
>  
>  		xname.type = XFS_DIR3_FT_REG_FILE;
>  		newdirent(mp, tp, pip, &xname, ip->i_ino);
> -		libxfs_trans_log_inode(tp, ip, flags);
> -		error = -libxfs_trans_commit(tp);
> +		xfs_trans_log_inode(tp, ip, flags);
> +		error = -xfs_trans_commit(tp);
>  		if (error)
>  			fail(_("Space preallocation failed."), error);
>  		rsvfile(mp, ip, llen);
> @@ -489,12 +489,12 @@ parseproto(
>  		tp = getres(mp, 0);
>  		majdev = getnum(getstr(pp), 0, 0, false);
>  		mindev = getnum(getstr(pp), 0, 0, false);
> -		error = -libxfs_inode_alloc(&tp, pip, mode|S_IFBLK, 1,
> +		error = -xfs_inode_alloc(&tp, pip, mode|S_IFBLK, 1,
>  				IRIX_MKDEV(majdev, mindev), &creds, fsxp, &ip);
>  		if (error) {
>  			fail(_("Inode allocation failed"), error);
>  		}
> -		libxfs_trans_ijoin(tp, pip, 0);
> +		xfs_trans_ijoin(tp, pip, 0);
>  		xname.type = XFS_DIR3_FT_BLKDEV;
>  		newdirent(mp, tp, pip, &xname, ip->i_ino);
>  		flags |= XFS_ILOG_DEV;
> @@ -504,11 +504,11 @@ parseproto(
>  		tp = getres(mp, 0);
>  		majdev = getnum(getstr(pp), 0, 0, false);
>  		mindev = getnum(getstr(pp), 0, 0, false);
> -		error = -libxfs_inode_alloc(&tp, pip, mode|S_IFCHR, 1,
> +		error = -xfs_inode_alloc(&tp, pip, mode|S_IFCHR, 1,
>  				IRIX_MKDEV(majdev, mindev), &creds, fsxp, &ip);
>  		if (error)
>  			fail(_("Inode allocation failed"), error);
> -		libxfs_trans_ijoin(tp, pip, 0);
> +		xfs_trans_ijoin(tp, pip, 0);
>  		xname.type = XFS_DIR3_FT_CHRDEV;
>  		newdirent(mp, tp, pip, &xname, ip->i_ino);
>  		flags |= XFS_ILOG_DEV;
> @@ -516,11 +516,11 @@ parseproto(
>  
>  	case IF_FIFO:
>  		tp = getres(mp, 0);
> -		error = -libxfs_inode_alloc(&tp, pip, mode|S_IFIFO, 1, 0,
> +		error = -xfs_inode_alloc(&tp, pip, mode|S_IFIFO, 1, 0,
>  				&creds, fsxp, &ip);
>  		if (error)
>  			fail(_("Inode allocation failed"), error);
> -		libxfs_trans_ijoin(tp, pip, 0);
> +		xfs_trans_ijoin(tp, pip, 0);
>  		xname.type = XFS_DIR3_FT_FIFO;
>  		newdirent(mp, tp, pip, &xname, ip->i_ino);
>  		break;
> @@ -528,18 +528,18 @@ parseproto(
>  		buf = getstr(pp);
>  		len = (int)strlen(buf);
>  		tp = getres(mp, XFS_B_TO_FSB(mp, len));
> -		error = -libxfs_inode_alloc(&tp, pip, mode|S_IFLNK, 1, 0,
> +		error = -xfs_inode_alloc(&tp, pip, mode|S_IFLNK, 1, 0,
>  				&creds, fsxp, &ip);
>  		if (error)
>  			fail(_("Inode allocation failed"), error);
>  		flags |= newfile(tp, ip, 1, 1, buf, len);
> -		libxfs_trans_ijoin(tp, pip, 0);
> +		xfs_trans_ijoin(tp, pip, 0);
>  		xname.type = XFS_DIR3_FT_SYMLINK;
>  		newdirent(mp, tp, pip, &xname, ip->i_ino);
>  		break;
>  	case IF_DIRECTORY:
>  		tp = getres(mp, 0);
> -		error = -libxfs_inode_alloc(&tp, pip, mode|S_IFDIR, 1, 0,
> +		error = -xfs_inode_alloc(&tp, pip, mode|S_IFDIR, 1, 0,
>  				&creds, fsxp, &ip);
>  		if (error)
>  			fail(_("Inode allocation failed"), error);
> @@ -547,18 +547,18 @@ parseproto(
>  		if (!pip) {
>  			pip = ip;
>  			mp->m_sb.sb_rootino = ip->i_ino;
> -			libxfs_log_sb(tp);
> +			xfs_log_sb(tp);
>  			isroot = 1;
>  		} else {
> -			libxfs_trans_ijoin(tp, pip, 0);
> +			xfs_trans_ijoin(tp, pip, 0);
>  			xname.type = XFS_DIR3_FT_DIR;
>  			newdirent(mp, tp, pip, &xname, ip->i_ino);
>  			inc_nlink(VFS_I(pip));
> -			libxfs_trans_log_inode(tp, pip, XFS_ILOG_CORE);
> +			xfs_trans_log_inode(tp, pip, XFS_ILOG_CORE);
>  		}
>  		newdirectory(mp, tp, ip, pip);
> -		libxfs_trans_log_inode(tp, ip, flags);
> -		error = -libxfs_trans_commit(tp);
> +		xfs_trans_log_inode(tp, ip, flags);
> +		error = -xfs_trans_commit(tp);
>  		if (error)
>  			fail(_("Directory inode allocation failed."), error);
>  		/*
> @@ -582,8 +582,8 @@ parseproto(
>  		ASSERT(0);
>  		fail(_("Unknown format"), EINVAL);
>  	}
> -	libxfs_trans_log_inode(tp, ip, flags);
> -	error = -libxfs_trans_commit(tp);
> +	xfs_trans_log_inode(tp, ip, flags);
> +	error = -xfs_trans_commit(tp);
>  	if (error) {
>  		fail(_("Error encountered creating file from prototype file"),
>  			error);
> @@ -625,13 +625,13 @@ rtinit(
>  	/*
>  	 * First, allocate the inodes.
>  	 */
> -	i = -libxfs_trans_alloc_rollable(mp, MKFS_BLOCKRES_INODE, &tp);
> +	i = -xfs_trans_alloc_rollable(mp, MKFS_BLOCKRES_INODE, &tp);
>  	if (i)
>  		res_failed(i);
>  
>  	memset(&creds, 0, sizeof(creds));
>  	memset(&fsxattrs, 0, sizeof(fsxattrs));
> -	error = -libxfs_inode_alloc(&tp, NULL, S_IFREG, 1, 0,
> +	error = -xfs_inode_alloc(&tp, NULL, S_IFREG, 1, 0,
>  					&creds, &fsxattrs, &rbmip);
>  	if (error) {
>  		fail(_("Realtime bitmap inode allocation failed"), error);
> @@ -645,19 +645,19 @@ rtinit(
>  	rbmip->i_d.di_size = mp->m_sb.sb_rbmblocks * mp->m_sb.sb_blocksize;
>  	rbmip->i_d.di_flags = XFS_DIFLAG_NEWRTBM;
>  	*(uint64_t *)&VFS_I(rbmip)->i_atime = 0;
> -	libxfs_trans_log_inode(tp, rbmip, XFS_ILOG_CORE);
> -	libxfs_log_sb(tp);
> +	xfs_trans_log_inode(tp, rbmip, XFS_ILOG_CORE);
> +	xfs_log_sb(tp);
>  	mp->m_rbmip = rbmip;
> -	error = -libxfs_inode_alloc(&tp, NULL, S_IFREG, 1, 0,
> +	error = -xfs_inode_alloc(&tp, NULL, S_IFREG, 1, 0,
>  					&creds, &fsxattrs, &rsumip);
>  	if (error) {
>  		fail(_("Realtime summary inode allocation failed"), error);
>  	}
>  	mp->m_sb.sb_rsumino = rsumip->i_ino;
>  	rsumip->i_d.di_size = mp->m_rsumsize;
> -	libxfs_trans_log_inode(tp, rsumip, XFS_ILOG_CORE);
> -	libxfs_log_sb(tp);
> -	error = -libxfs_trans_commit(tp);
> +	xfs_trans_log_inode(tp, rsumip, XFS_ILOG_CORE);
> +	xfs_log_sb(tp);
> +	error = -xfs_trans_commit(tp);
>  	if (error)
>  		fail(_("Completion of the realtime summary inode failed"),
>  				error);
> @@ -667,15 +667,15 @@ rtinit(
>  	 */
>  	blocks = mp->m_sb.sb_rbmblocks +
>  			XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1;
> -	i = -libxfs_trans_alloc_rollable(mp, blocks, &tp);
> +	i = -xfs_trans_alloc_rollable(mp, blocks, &tp);
>  	if (i)
>  		res_failed(i);
>  
> -	libxfs_trans_ijoin(tp, rbmip, 0);
> +	xfs_trans_ijoin(tp, rbmip, 0);
>  	bno = 0;
>  	while (bno < mp->m_sb.sb_rbmblocks) {
>  		nmap = XFS_BMAP_MAX_NMAP;
> -		error = -libxfs_bmapi_write(tp, rbmip, bno,
> +		error = -xfs_bmapi_write(tp, rbmip, bno,
>  				(xfs_extlen_t)(mp->m_sb.sb_rbmblocks - bno),
>  				0, mp->m_sb.sb_rbmblocks, map, &nmap);
>  		if (error) {
> @@ -690,7 +690,7 @@ rtinit(
>  		}
>  	}
>  
> -	error = -libxfs_trans_commit(tp);
> +	error = -xfs_trans_commit(tp);
>  	if (error)
>  		fail(_("Block allocation of the realtime bitmap inode failed"),
>  				error);
> @@ -700,14 +700,14 @@ rtinit(
>  	 */
>  	nsumblocks = mp->m_rsumsize >> mp->m_sb.sb_blocklog;
>  	blocks = nsumblocks + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1;
> -	i = -libxfs_trans_alloc_rollable(mp, blocks, &tp);
> +	i = -xfs_trans_alloc_rollable(mp, blocks, &tp);
>  	if (i)
>  		res_failed(i);
> -	libxfs_trans_ijoin(tp, rsumip, 0);
> +	xfs_trans_ijoin(tp, rsumip, 0);
>  	bno = 0;
>  	while (bno < nsumblocks) {
>  		nmap = XFS_BMAP_MAX_NMAP;
> -		error = -libxfs_bmapi_write(tp, rsumip, bno,
> +		error = -xfs_bmapi_write(tp, rsumip, bno,
>  				(xfs_extlen_t)(nsumblocks - bno),
>  				0, nsumblocks, map, &nmap);
>  		if (error) {
> @@ -721,7 +721,7 @@ rtinit(
>  			bno += ep->br_blockcount;
>  		}
>  	}
> -	error = -libxfs_trans_commit(tp);
> +	error = -xfs_trans_commit(tp);
>  	if (error)
>  		fail(_("Block allocation of the realtime summary inode failed"),
>  				error);
> @@ -731,19 +731,19 @@ rtinit(
>  	 * Do one transaction per bitmap block.
>  	 */
>  	for (bno = 0; bno < mp->m_sb.sb_rextents; bno = ebno) {
> -		i = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
> +		i = -xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
>  				0, 0, 0, &tp);
>  		if (i)
>  			res_failed(i);
> -		libxfs_trans_ijoin(tp, rbmip, 0);
> +		xfs_trans_ijoin(tp, rbmip, 0);
>  		ebno = XFS_RTMIN(mp->m_sb.sb_rextents,
>  			bno + NBBY * mp->m_sb.sb_blocksize);
> -		error = -libxfs_rtfree_extent(tp, bno, (xfs_extlen_t)(ebno-bno));
> +		error = -xfs_rtfree_extent(tp, bno, (xfs_extlen_t)(ebno-bno));
>  		if (error) {
>  			fail(_("Error initializing the realtime space"),
>  				error);
>  		}
> -		error = -libxfs_trans_commit(tp);
> +		error = -xfs_trans_commit(tp);
>  		if (error)
>  			fail(_("Initialization of the realtime space failed"),
>  					error);
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 4aa7563f..9f9483f4 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -1140,7 +1140,7 @@ zero_old_xfs_structures(
>  				strerror(errno));
>  		goto done;
>  	}
> -	libxfs_sb_from_disk(&sb, buf);
> +	xfs_sb_from_disk(&sb, buf);
>  
>  	/*
>  	 * perform same basic superblock validation to make sure we
> @@ -1702,7 +1702,7 @@ validate_sectorsize(
>  	} else {
>  		cfg->sectorsize = cli->sectorsize;
>  	}
> -	cfg->sectorlog = libxfs_highbit32(cfg->sectorsize);
> +	cfg->sectorlog = xfs_highbit32(cfg->sectorsize);
>  
>  	/*
>  	 * Before anything else, verify that we are correctly operating on
> @@ -1760,7 +1760,7 @@ _("specified blocksize %d is less than device physical sector size %d\n"
>  			cfg->sectorsize = ft->lsectorsize;
>  		}
>  
> -		cfg->sectorlog = libxfs_highbit32(cfg->sectorsize);
> +		cfg->sectorlog = xfs_highbit32(cfg->sectorsize);
>  	}
>  
>  	/* validate specified/probed sector size */
> @@ -1799,7 +1799,7 @@ validate_blocksize(
>  		cfg->blocksize = dft->blocksize;
>  	else
>  		cfg->blocksize = cli->blocksize;
> -	cfg->blocklog = libxfs_highbit32(cfg->blocksize);
> +	cfg->blocklog = xfs_highbit32(cfg->blocksize);
>  
>  	/* validate block sizes are in range */
>  	if (cfg->blocksize < XFS_MIN_BLOCKSIZE ||
> @@ -1844,7 +1844,7 @@ _("Can't change sector size on internal log!\n"));
>  		cfg->lsectorsize = cfg->sectorsize;
>  	else
>  		cfg->lsectorsize = dft->sectorsize;
> -	cfg->lsectorlog = libxfs_highbit32(cfg->lsectorsize);
> +	cfg->lsectorlog = xfs_highbit32(cfg->lsectorsize);
>  
>  	if (cfg->lsectorsize < XFS_MIN_SECTORSIZE ||
>  	    cfg->lsectorsize > XFS_MAX_SECTORSIZE ||
> @@ -2026,7 +2026,7 @@ validate_dirblocksize(
>  				cfg->dirblocksize);
>  			usage();
>  		}
> -		cfg->dirblocklog = libxfs_highbit32(cfg->dirblocksize);
> +		cfg->dirblocklog = xfs_highbit32(cfg->dirblocksize);
>  		return;
>  	}
>  
> @@ -2045,9 +2045,9 @@ validate_inodesize(
>  {
>  
>  	if (cli->inopblock)
> -		cfg->inodelog = cfg->blocklog - libxfs_highbit32(cli->inopblock);
> +		cfg->inodelog = cfg->blocklog - xfs_highbit32(cli->inopblock);
>  	else if (cli->inodesize)
> -		cfg->inodelog = libxfs_highbit32(cli->inodesize);
> +		cfg->inodelog = xfs_highbit32(cli->inodesize);
>  	else if (cfg->sb_feat.crcs_enabled)
>  		cfg->inodelog = XFS_DINODE_DFL_CRC_LOG;
>  	else
> @@ -2188,7 +2188,7 @@ validate_extsize_hint(
>  	if (cli->fsx.fsx_xflags & FS_XFLAG_EXTSZINHERIT)
>  		flags |= XFS_DIFLAG_EXTSZINHERIT;
>  
> -	fa = libxfs_inode_validate_extsize(mp, cli->fsx.fsx_extsize, S_IFDIR,
> +	fa = xfs_inode_validate_extsize(mp, cli->fsx.fsx_extsize, S_IFDIR,
>  			flags);
>  	if (fa) {
>  		fprintf(stderr,
> @@ -2209,7 +2209,7 @@ _("illegal extent size hint %lld, must be less than %u.\n"),
>  	if (cli->fsx.fsx_xflags & FS_XFLAG_EXTSZINHERIT)
>  		flags |= XFS_DIFLAG_EXTSIZE;
>  
> -	fa = libxfs_inode_validate_extsize(mp, cli->fsx.fsx_extsize, S_IFREG,
> +	fa = xfs_inode_validate_extsize(mp, cli->fsx.fsx_extsize, S_IFREG,
>  			flags);
>  
>  	if (fa) {
> @@ -2239,7 +2239,7 @@ validate_cowextsize_hint(
>  	if (cli->fsx.fsx_xflags & FS_XFLAG_COWEXTSIZE)
>  		flags2 |= XFS_DIFLAG2_COWEXTSIZE;
>  
> -	fa = libxfs_inode_validate_cowextsize(mp, cli->fsx.fsx_cowextsize,
> +	fa = xfs_inode_validate_cowextsize(mp, cli->fsx.fsx_cowextsize,
>  			S_IFDIR, 0, flags2);
>  	if (fa) {
>  		fprintf(stderr,
> @@ -3069,7 +3069,7 @@ calculate_log_size(
>  	memset(&mount, 0, sizeof(mount));
>  	mount.m_sb = *sbp;
>  	libxfs_mount(&mount, &mp->m_sb, 0, 0, 0, 0);
> -	min_logblocks = libxfs_log_calc_minimum_size(&mount);
> +	min_logblocks = xfs_log_calc_minimum_size(&mount);
>  	libxfs_umount(&mount);
>  
>  	ASSERT(min_logblocks);
> @@ -3141,7 +3141,7 @@ _("external log device %lld too small, must be at least %lld blocks\n"),
>  		 * an AG.
>  		 */
>  		cfg->logblocks = min(cfg->logblocks,
> -				     libxfs_alloc_ag_max_usable(mp) - 1);
> +				     xfs_alloc_ag_max_usable(mp) - 1);
>  
>  		/* and now clamp the size to the maximum supported size */
>  		cfg->logblocks = min(cfg->logblocks, XFS_MAX_LOG_BLOCKS);
> @@ -3151,7 +3151,7 @@ _("external log device %lld too small, must be at least %lld blocks\n"),
>  		validate_log_size(cfg->logblocks, cfg->blocklog, min_logblocks);
>  	}
>  
> -	if (cfg->logblocks > sbp->sb_agblocks - libxfs_prealloc_blocks(mp)) {
> +	if (cfg->logblocks > sbp->sb_agblocks - xfs_prealloc_blocks(mp)) {
>  		fprintf(stderr,
>  _("internal log size %lld too large, must fit in allocation group\n"),
>  			(long long)cfg->logblocks);
> @@ -3171,7 +3171,7 @@ _("log ag number %lld too large, must be less than %lld\n"),
>  		cfg->logagno = (xfs_agnumber_t)(sbp->sb_agcount / 2);
>  
>  	cfg->logstart = XFS_AGB_TO_FSB(mp, cfg->logagno,
> -				       libxfs_prealloc_blocks(mp));
> +				       xfs_prealloc_blocks(mp));
>  
>  	/*
>  	 * Align the logstart at stripe unit boundary.
> @@ -3236,7 +3236,7 @@ initialise_mount(
>  	struct xfs_mount	*mp,
>  	struct xfs_sb		*sbp)
>  {
> -	/* Minimum needed for libxfs_prealloc_blocks() */
> +	/* Minimum needed for xfs_prealloc_blocks() */
>  	mp->m_blkbb_log = sbp->sb_blocklog - BBSHIFT;
>  	mp->m_sectbb_log = sbp->sb_sectlog - BBSHIFT;
>  }
> @@ -3277,13 +3277,13 @@ finish_superblock_setup(
>  	sbp->sb_rbmblocks = cfg->rtbmblocks;
>  	sbp->sb_logblocks = (xfs_extlen_t)cfg->logblocks;
>  	sbp->sb_rextslog = (uint8_t)(cfg->rtextents ?
> -			libxfs_highbit32((unsigned int)cfg->rtextents) : 0);
> +			xfs_highbit32((unsigned int)cfg->rtextents) : 0);
>  	sbp->sb_inprogress = 1;	/* mkfs is in progress */
>  	sbp->sb_imax_pct = cfg->imaxpct;
>  	sbp->sb_icount = 0;
>  	sbp->sb_ifree = 0;
>  	sbp->sb_fdblocks = cfg->dblocks -
> -			   cfg->agcount * libxfs_prealloc_blocks(mp) -
> +			   cfg->agcount * xfs_prealloc_blocks(mp) -
>  			   (cfg->loginternal ? cfg->logblocks : 0);
>  	sbp->sb_frextents = 0;	/* will do a free later */
>  	sbp->sb_uquotino = sbp->sb_gquotino = sbp->sb_pquotino = 0;
> @@ -3303,7 +3303,7 @@ alloc_write_buf(
>  	struct xfs_buf		*bp;
>  	int			error;
>  
> -	error = -libxfs_buf_get_uncached(btp, bblen, 0, &bp);
> +	error = -xfs_buf_get_uncached(btp, bblen, 0, &bp);
>  	if (error) {
>  		fprintf(stderr, _("Could not get memory for buffer, err=%d\n"),
>  				error);
> @@ -3366,7 +3366,7 @@ prepare_devices(
>  			whack_blks);
>  	memset(buf->b_addr, 0, WHACK_SIZE);
>  	libxfs_buf_mark_dirty(buf);
> -	libxfs_buf_relse(buf);
> +	xfs_buf_relse(buf);
>  
>  	/*
>  	 * Now zero out the beginning of the device, to obliterate any old
> @@ -3377,16 +3377,16 @@ prepare_devices(
>  	buf = alloc_write_buf(mp->m_ddev_targp, 0, whack_blks);
>  	memset(buf->b_addr, 0, WHACK_SIZE);
>  	libxfs_buf_mark_dirty(buf);
> -	libxfs_buf_relse(buf);
> +	xfs_buf_relse(buf);
>  
>  	/* OK, now write the superblock... */
>  	buf = alloc_write_buf(mp->m_ddev_targp, XFS_SB_DADDR,
>  			XFS_FSS_TO_BB(mp, 1));
>  	buf->b_ops = &xfs_sb_buf_ops;
>  	memset(buf->b_addr, 0, cfg->sectorsize);
> -	libxfs_sb_to_disk(buf->b_addr, sbp);
> +	xfs_sb_to_disk(buf->b_addr, sbp);
>  	libxfs_buf_mark_dirty(buf);
> -	libxfs_buf_relse(buf);
> +	xfs_buf_relse(buf);
>  
>  	/* ...and zero the log.... */
>  	lsunit = sbp->sb_logsunit;
> @@ -3406,7 +3406,7 @@ prepare_devices(
>  				BTOBB(cfg->blocksize));
>  		memset(buf->b_addr, 0, cfg->blocksize);
>  		libxfs_buf_mark_dirty(buf);
> -		libxfs_buf_relse(buf);
> +		xfs_buf_relse(buf);
>  	}
>  
>  }
> @@ -3429,14 +3429,14 @@ initialise_ag_headers(
>  		.agno		= agno,
>  		.agsize		= cfg->agsize,
>  	};
> -	struct xfs_perag	*pag = libxfs_perag_get(mp, agno);
> +	struct xfs_perag	*pag = xfs_perag_get(mp, agno);
>  	int			error;
>  
>  	if (agno == cfg->agcount - 1)
>  		id.agsize = cfg->dblocks - (xfs_rfsblock_t)(agno * cfg->agsize);
>  
>  	INIT_LIST_HEAD(&id.buffer_list);
> -	error = -libxfs_ag_init_headers(mp, &id);
> +	error = -xfs_ag_init_headers(mp, &id);
>  	if (error) {
>  		fprintf(stderr, _("AG header init failed, error %d\n"), error);
>  		exit(1);
> @@ -3444,9 +3444,9 @@ initialise_ag_headers(
>  
>  	list_splice_tail_init(&id.buffer_list, buffer_list);
>  
> -	if (libxfs_alloc_min_freelist(mp, pag) > *worst_freelist)
> -		*worst_freelist = libxfs_alloc_min_freelist(mp, pag);
> -	libxfs_perag_put(pag);
> +	if (xfs_alloc_min_freelist(mp, pag) > *worst_freelist)
> +		*worst_freelist = xfs_alloc_min_freelist(mp, pag);
> +	xfs_perag_put(pag);
>  }
>  
>  static void
> @@ -3459,7 +3459,7 @@ initialise_ag_freespace(
>  	struct xfs_trans	*tp;
>  	int			c;
>  
> -	c = -libxfs_trans_alloc_rollable(mp, worst_freelist, &tp);
> +	c = -xfs_trans_alloc_rollable(mp, worst_freelist, &tp);
>  	if (c)
>  		res_failed(c);
>  
> @@ -3468,11 +3468,11 @@ initialise_ag_freespace(
>  	args.mp = mp;
>  	args.agno = agno;
>  	args.alignment = 1;
> -	args.pag = libxfs_perag_get(mp, agno);
> +	args.pag = xfs_perag_get(mp, agno);
>  
> -	libxfs_alloc_fix_freelist(&args, 0);
> -	libxfs_perag_put(args.pag);
> -	c = -libxfs_trans_commit(tp);
> +	xfs_alloc_fix_freelist(&args, 0);
> +	xfs_perag_put(args.pag);
> +	c = -xfs_trans_commit(tp);
>  	if (c) {
>  		errno = c;
>  		perror(_("initializing AG free space list"));
> @@ -3494,7 +3494,7 @@ rewrite_secondary_superblocks(
>  	int			error;
>  
>  	/* rewrite the last superblock */
> -	error = -libxfs_buf_read(mp->m_dev,
> +	error = -xfs_buf_read(mp->m_dev,
>  			XFS_AGB_TO_DADDR(mp, mp->m_sb.sb_agcount - 1,
>  				XFS_SB_DADDR),
>  			XFS_FSS_TO_BB(mp, 1), 0, &buf, &xfs_sb_buf_ops);
> @@ -3506,13 +3506,13 @@ rewrite_secondary_superblocks(
>  	dsb = buf->b_addr;
>  	dsb->sb_rootino = cpu_to_be64(mp->m_sb.sb_rootino);
>  	libxfs_buf_mark_dirty(buf);
> -	libxfs_buf_relse(buf);
> +	xfs_buf_relse(buf);
>  
>  	/* and one in the middle for luck if there's enough AGs for that */
>  	if (mp->m_sb.sb_agcount <= 2)
>  		return;
>  
> -	error = -libxfs_buf_read(mp->m_dev,
> +	error = -xfs_buf_read(mp->m_dev,
>  			XFS_AGB_TO_DADDR(mp, (mp->m_sb.sb_agcount - 1) / 2,
>  				XFS_SB_DADDR),
>  			XFS_FSS_TO_BB(mp, 1), 0, &buf, &xfs_sb_buf_ops);
> @@ -3524,7 +3524,7 @@ rewrite_secondary_superblocks(
>  	dsb = buf->b_addr;
>  	dsb->sb_rootino = cpu_to_be64(mp->m_sb.sb_rootino);
>  	libxfs_buf_mark_dirty(buf);
> -	libxfs_buf_relse(buf);
> +	xfs_buf_relse(buf);
>  }
>  
>  static void
> @@ -3548,7 +3548,7 @@ check_root_ino(
>  	 * Fail the format immediately if those assumptions ever break, because
>  	 * repair will toss the root directory.
>  	 */
> -	ino = libxfs_ialloc_calc_rootino(mp, mp->m_sb.sb_unit);
> +	ino = xfs_ialloc_calc_rootino(mp, mp->m_sb.sb_unit);
>  	if (mp->m_sb.sb_rootino != ino) {
>  		fprintf(stderr,
>  	_("%s: root inode (%llu) not allocated in expected location (%llu)\n"),
> @@ -3779,7 +3779,7 @@ main(
>  	if (!quiet || dry_run) {
>  		struct xfs_fsop_geom	geo;
>  
> -		libxfs_fs_geometry(sbp, &geo, XFS_FS_GEOM_MAX_STRUCT_VER);
> +		xfs_fs_geometry(sbp, &geo, XFS_FS_GEOM_MAX_STRUCT_VER);
>  		xfs_report_geom(&geo, dfile, logfile, rtfile);
>  		if (dry_run)
>  			exit(0);
> @@ -3820,7 +3820,7 @@ main(
>  		if (agno % 16)
>  			continue;
>  
> -		error = -libxfs_buf_delwri_submit(&buffer_list);
> +		error = -xfs_buf_delwri_submit(&buffer_list);
>  		if (error) {
>  			fprintf(stderr,
>  	_("%s: writing AG headers failed, err=%d\n"),
> @@ -3829,7 +3829,7 @@ main(
>  		}
>  	}
>  
> -	error = -libxfs_buf_delwri_submit(&buffer_list);
> +	error = -xfs_buf_delwri_submit(&buffer_list);
>  	if (error) {
>  		fprintf(stderr, _("%s: writing AG headers failed, err=%d\n"),
>  				progname, error);
> @@ -3874,7 +3874,7 @@ main(
>  	dsb = buf->b_addr;
>  	dsb->sb_inprogress = 0;
>  	libxfs_buf_mark_dirty(buf);
> -	libxfs_buf_relse(buf);
> +	xfs_buf_relse(buf);
>  
>  	/* Exit w/ failure if anything failed to get written to our new fs. */
>  	error = -libxfs_umount(mp);
> diff --git a/repair/agheader.c b/repair/agheader.c
> index f28d8a7b..ab9b1bba 100644
> --- a/repair/agheader.c
> +++ b/repair/agheader.c
> @@ -79,18 +79,18 @@ verify_set_agf(xfs_mount_t *mp, xfs_agf_t *agf, xfs_agnumber_t i)
>  	 * check first/last AGF fields.  if need be, lose the free
>  	 * space in the AGFL, we'll reclaim it later.
>  	 */
> -	if (be32_to_cpu(agf->agf_flfirst) >= libxfs_agfl_size(mp)) {
> +	if (be32_to_cpu(agf->agf_flfirst) >= xfs_agfl_size(mp)) {
>  		do_warn(_("flfirst %d in agf %d too large (max = %u)\n"),
>  			be32_to_cpu(agf->agf_flfirst),
> -			i, libxfs_agfl_size(mp) - 1);
> +			i, xfs_agfl_size(mp) - 1);
>  		if (!no_modify)
>  			agf->agf_flfirst = cpu_to_be32(0);
>  	}
>  
> -	if (be32_to_cpu(agf->agf_fllast) >= libxfs_agfl_size(mp)) {
> +	if (be32_to_cpu(agf->agf_fllast) >= xfs_agfl_size(mp)) {
>  		do_warn(_("fllast %d in agf %d too large (max = %u)\n"),
>  			be32_to_cpu(agf->agf_fllast),
> -			i, libxfs_agfl_size(mp) - 1);
> +			i, xfs_agfl_size(mp) - 1);
>  		if (!no_modify)
>  			agf->agf_fllast = cpu_to_be32(0);
>  	}
> @@ -338,7 +338,7 @@ secondary_sb_whack(
>  	 * secondaries.
>  	 *
>  	 * Also, the in-core inode flags now have different meaning to the
> -	 * on-disk flags, and so libxfs_sb_to_disk cannot directly write the
> +	 * on-disk flags, and so xfs_sb_to_disk cannot directly write the
>  	 * sb_gquotino/sb_pquotino fields without specific sb_qflags being set.
>  	 * Hence we need to zero those fields directly in the sb buffer here.
>  	 */
> diff --git a/repair/attr_repair.c b/repair/attr_repair.c
> index 5f884033..32d59b8c 100644
> --- a/repair/attr_repair.c
> +++ b/repair/attr_repair.c
> @@ -293,7 +293,7 @@ process_shortform_attr(
>  		}
>  
>  		/* namecheck checks for null chars in attr names. */
> -		if (!libxfs_attr_namecheck(currententry->nameval,
> +		if (!xfs_attr_namecheck(currententry->nameval,
>  					   currententry->namelen)) {
>  			do_warn(
>  	_("entry contains illegal character in shortform attribute name\n"));
> @@ -406,7 +406,7 @@ rmtval_get(xfs_mount_t *mp, xfs_ino_t ino, blkmap_t *blkmap,
>  			clearit = 1;
>  			break;
>  		}
> -		error = -libxfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),
> +		error = -xfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),
>  				XFS_FSB_TO_BB(mp, 1), LIBXFS_READBUF_SALVAGE,
>  				&bp, &xfs_attr3_rmt_buf_ops);
>  		if (error) {
> @@ -419,7 +419,7 @@ rmtval_get(xfs_mount_t *mp, xfs_ino_t ino, blkmap_t *blkmap,
>  		if (bp->b_error == -EFSBADCRC || bp->b_error == -EFSCORRUPTED) {
>  			do_warn(
>  	_("Corrupt remote block for attributes of inode %" PRIu64 "\n"), ino);
> -			libxfs_buf_relse(bp);
> +			xfs_buf_relse(bp);
>  			clearit = 1;
>  			break;
>  		}
> @@ -431,7 +431,7 @@ rmtval_get(xfs_mount_t *mp, xfs_ino_t ino, blkmap_t *blkmap,
>  		amountdone += length;
>  		value += length;
>  		i++;
> -		libxfs_buf_relse(bp);
> +		xfs_buf_relse(bp);
>  	}
>  	return (clearit);
>  }
> @@ -458,8 +458,7 @@ process_leaf_attr_local(
>  
>  	local = xfs_attr3_leaf_name_local(leaf, i);
>  	if (local->namelen == 0 ||
> -	    !libxfs_attr_namecheck(local->nameval,
> -				   local->namelen)) {
> +	    !xfs_attr_namecheck(local->nameval, local->namelen)) {
>  		do_warn(
>  	_("attribute entry %d in attr block %u, inode %" PRIu64 " has bad name (namelen = %d)\n"),
>  			i, da_bno, ino, local->namelen);
> @@ -474,7 +473,7 @@ process_leaf_attr_local(
>  	 * ordering anyway in case both the name value and the
>  	 * hashvalue were wrong but matched. Unlikely, however.
>  	 */
> -	if (be32_to_cpu(entry->hashval) != libxfs_da_hashname(
> +	if (be32_to_cpu(entry->hashval) != xfs_da_hashname(
>  				&local->nameval[0], local->namelen) ||
>  				be32_to_cpu(entry->hashval) < last_hashval) {
>  		do_warn(
> @@ -514,10 +513,9 @@ process_leaf_attr_remote(
>  	remotep = xfs_attr3_leaf_name_remote(leaf, i);
>  
>  	if (remotep->namelen == 0 ||
> -	    !libxfs_attr_namecheck(remotep->name,
> -				   remotep->namelen) ||
> +	    !xfs_attr_namecheck(remotep->name, remotep->namelen) ||
>  	    be32_to_cpu(entry->hashval) !=
> -			libxfs_da_hashname((unsigned char *)&remotep->name[0],
> +			xfs_da_hashname((unsigned char *)&remotep->name[0],
>  					   remotep->namelen) ||
>  	    be32_to_cpu(entry->hashval) < last_hashval ||
>  	    be32_to_cpu(remotep->valueblk) == 0) {
> @@ -765,7 +763,7 @@ process_leaf_attr_level(xfs_mount_t	*mp,
>  			goto error_out;
>  		}
>  
> -		error = -libxfs_buf_read(mp->m_dev,
> +		error = -xfs_buf_read(mp->m_dev,
>  				XFS_FSB_TO_DADDR(mp, dev_bno),
>  				XFS_FSB_TO_BB(mp, 1), LIBXFS_READBUF_SALVAGE,
>  				&bp, &xfs_attr3_leaf_buf_ops);
> @@ -785,7 +783,7 @@ process_leaf_attr_level(xfs_mount_t	*mp,
>  			do_warn(
>  	_("bad attribute leaf magic %#x for inode %" PRIu64 "\n"),
>  				 leafhdr.magic, ino);
> -			libxfs_buf_relse(bp);
> +			xfs_buf_relse(bp);
>  			goto error_out;
>  		}
>  
> @@ -796,7 +794,7 @@ process_leaf_attr_level(xfs_mount_t	*mp,
>  		if (process_leaf_attr_block(mp, leaf, da_bno, ino,
>  				da_cursor->blkmap, current_hashval,
>  				&greatest_hashval, &repair))  {
> -			libxfs_buf_relse(bp);
> +			xfs_buf_relse(bp);
>  			goto error_out;
>  		}
>  
> @@ -816,7 +814,7 @@ process_leaf_attr_level(xfs_mount_t	*mp,
>  			do_warn(
>  	_("bad sibling back pointer for block %u in attribute fork for inode %" PRIu64 "\n"),
>  				da_bno, ino);
> -			libxfs_buf_relse(bp);
> +			xfs_buf_relse(bp);
>  			goto error_out;
>  		}
>  
> @@ -825,7 +823,7 @@ process_leaf_attr_level(xfs_mount_t	*mp,
>  
>  		if (da_bno != 0) {
>  			if (verify_da_path(mp, da_cursor, 0, XFS_ATTR_FORK)) {
> -				libxfs_buf_relse(bp);
> +				xfs_buf_relse(bp);
>  				goto error_out;
>  			}
>  		}
> @@ -840,10 +838,10 @@ process_leaf_attr_level(xfs_mount_t	*mp,
>  
>  		if (repair && !no_modify) {
>  			libxfs_buf_mark_dirty(bp);
> -			libxfs_buf_relse(bp);
> +			xfs_buf_relse(bp);
>  		}
>  		else
> -			libxfs_buf_relse(bp);
> +			xfs_buf_relse(bp);
>  	} while (da_bno != 0);
>  
>  	if (verify_final_da_path(mp, da_cursor, 0, XFS_ATTR_FORK))  {
> @@ -997,7 +995,7 @@ _("would clear forw/back pointers in block 0 for attributes in inode %" PRIu64 "
>  	if (badness) {
>  		*repair = 0;
>  		/* the block is bad.  lose the attribute fork. */
> -		libxfs_buf_relse(bp);
> +		xfs_buf_relse(bp);
>  		return 1;
>  	}
>  
> @@ -1005,7 +1003,7 @@ _("would clear forw/back pointers in block 0 for attributes in inode %" PRIu64 "
>  
>  	if (*repair && !no_modify)
>  		libxfs_buf_mark_dirty(bp);
> -	libxfs_buf_relse(bp);
> +	xfs_buf_relse(bp);
>  
>  	return 0;
>  }
> @@ -1023,7 +1021,7 @@ process_longform_da_root(
>  	int			repairlinks = 0;
>  	int			error;
>  
> -	libxfs_da3_node_hdr_from_disk(mp, &da3_hdr, bp->b_addr);
> +	xfs_da3_node_hdr_from_disk(mp, &da3_hdr, bp->b_addr);
>  	/*
>  	 * check sibling pointers in leaf block or root block 0 before
>  	 * we have to release the btree block
> @@ -1049,7 +1047,7 @@ _("would clear forw/back pointers in block 0 for attributes in inode %" PRIu64 "
>  		*repair = 1;
>  		libxfs_buf_mark_dirty(bp);
>  	}
> -	libxfs_buf_relse(bp);
> +	xfs_buf_relse(bp);
>  	error = process_node_attr(mp, ino, dip, blkmap); /* + repair */
>  	if (error)
>  		*repair = 0;
> @@ -1098,7 +1096,7 @@ process_longform_attr(
>  		return 1;
>  	}
>  
> -	error = -libxfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),
> +	error = -xfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),
>  			XFS_FSB_TO_BB(mp, 1), LIBXFS_READBUF_SALVAGE, &bp,
>  			&xfs_da3_node_buf_ops);
>  	if (error) {
> @@ -1113,7 +1111,7 @@ process_longform_attr(
>  	/* is this block sane? */
>  	if (__check_attr_header(mp, bp, ino)) {
>  		*repair = 0;
> -		libxfs_buf_relse(bp);
> +		xfs_buf_relse(bp);
>  		return 1;
>  	}
>  
> @@ -1136,7 +1134,7 @@ process_longform_attr(
>  		do_warn(
>  	_("bad attribute leaf magic # %#x for dir ino %" PRIu64 "\n"),
>  			be16_to_cpu(info->magic), ino);
> -		libxfs_buf_relse(bp);
> +		xfs_buf_relse(bp);
>  		*repair = 0;
>  		return 1;
>  	}
> diff --git a/repair/da_util.c b/repair/da_util.c
> index 5061880f..5e2e6f59 100644
> --- a/repair/da_util.c
> +++ b/repair/da_util.c
> @@ -64,7 +64,7 @@ da_read_buf(
>  		map[i].bm_bn = XFS_FSB_TO_DADDR(mp, bmp[i].startblock);
>  		map[i].bm_len = XFS_FSB_TO_BB(mp, bmp[i].blockcount);
>  	}
> -	libxfs_buf_read_map(mp->m_dev, map, nex, LIBXFS_READBUF_SALVAGE,
> +	xfs_buf_read_map(mp->m_dev, map, nex, LIBXFS_READBUF_SALVAGE,
>  			&bp, ops);
>  	if (map != map_array)
>  		free(map);
> @@ -135,7 +135,7 @@ _("can't read %s block %u for inode %" PRIu64 "\n"),
>  		}
>  
>  		node = bp->b_addr;
> -		libxfs_da3_node_hdr_from_disk(mp, &nodehdr, node);
> +		xfs_da3_node_hdr_from_disk(mp, &nodehdr, node);
>  
>  		if (whichfork == XFS_DATA_FORK &&
>  		    (nodehdr.magic == XFS_DIR2_LEAFN_MAGIC ||
> @@ -146,7 +146,7 @@ _("found non-root LEAFN node in inode %" PRIu64 " bno = %u\n"),
>  					da_cursor->ino, bno);
>  			}
>  			*rbno = 0;
> -			libxfs_buf_relse(bp);
> +			xfs_buf_relse(bp);
>  			return 1;
>  		}
>  
> @@ -156,13 +156,13 @@ _("found non-root LEAFN node in inode %" PRIu64 " bno = %u\n"),
>  _("bad %s magic number 0x%x in inode %" PRIu64 " bno = %u\n"),
>  					FORKNAME(whichfork), nodehdr.magic,
>  					da_cursor->ino, bno);
> -			libxfs_buf_relse(bp);
> +			xfs_buf_relse(bp);
>  			goto error_out;
>  		}
>  
>  		/* corrupt node; rebuild the dir. */
>  		if (bp->b_error == -EFSBADCRC || bp->b_error == -EFSCORRUPTED) {
> -			libxfs_buf_relse(bp);
> +			xfs_buf_relse(bp);
>  			do_warn(
>  _("corrupt %s tree block %u for inode %" PRIu64 "\n"),
>  				FORKNAME(whichfork), bno, da_cursor->ino);
> @@ -174,7 +174,7 @@ _("corrupt %s tree block %u for inode %" PRIu64 "\n"),
>  _("bad %s record count in inode %" PRIu64 ", count = %d, max = %d\n"),
>  				FORKNAME(whichfork), da_cursor->ino,
>  				nodehdr.count, geo->node_ents);
> -			libxfs_buf_relse(bp);
> +			xfs_buf_relse(bp);
>  			goto error_out;
>  		}
>  
> @@ -187,7 +187,7 @@ _("bad %s record count in inode %" PRIu64 ", count = %d, max = %d\n"),
>  				do_warn(
>  _("bad header depth for directory inode %" PRIu64 "\n"),
>  					da_cursor->ino);
> -				libxfs_buf_relse(bp);
> +				xfs_buf_relse(bp);
>  				i = -1;
>  				goto error_out;
>  			}
> @@ -198,7 +198,7 @@ _("bad header depth for directory inode %" PRIu64 "\n"),
>  				do_warn(
>  _("bad %s btree for inode %" PRIu64 "\n"),
>  					FORKNAME(whichfork), da_cursor->ino);
> -				libxfs_buf_relse(bp);
> +				xfs_buf_relse(bp);
>  				goto error_out;
>  			}
>  		}
> @@ -223,7 +223,7 @@ _("bad %s btree for inode %" PRIu64 "\n"),
>  
>  error_out:
>  	while (i > 1 && i <= da_cursor->active) {
> -		libxfs_buf_relse(da_cursor->level[i].bp);
> +		xfs_buf_relse(da_cursor->level[i].bp);
>  		i++;
>  	}
>  
> @@ -253,7 +253,7 @@ release_da_cursor_int(
>  		}
>  		ASSERT(error != 0);
>  
> -		libxfs_buf_relse(cursor->level[level].bp);
> +		xfs_buf_relse(cursor->level[level].bp);
>  		cursor->level[level].bp = NULL;
>  	}
>  
> @@ -314,7 +314,7 @@ verify_final_da_path(
>  	 */
>  	entry = cursor->level[this_level].index;
>  	node = cursor->level[this_level].bp->b_addr;
> -	libxfs_da3_node_hdr_from_disk(mp, &nodehdr, node);
> +	xfs_da3_node_hdr_from_disk(mp, &nodehdr, node);
>  
>  	/*
>  	 * check internal block consistency on this level -- ensure
> @@ -406,10 +406,10 @@ _("would correct bad hashval in non-leaf %s block\n"
>  
>  	if (cursor->level[this_level].dirty && !no_modify) {
>  		libxfs_buf_mark_dirty(cursor->level[this_level].bp);
> -		libxfs_buf_relse(cursor->level[this_level].bp);
> +		xfs_buf_relse(cursor->level[this_level].bp);
>  	}
>  	else
> -		libxfs_buf_relse(cursor->level[this_level].bp);
> +		xfs_buf_relse(cursor->level[this_level].bp);
>  
>  	cursor->level[this_level].bp = NULL;
>  
> @@ -505,7 +505,7 @@ verify_da_path(
>  	 */
>  	entry = cursor->level[this_level].index;
>  	node = cursor->level[this_level].bp->b_addr;
> -	libxfs_da3_node_hdr_from_disk(mp, &nodehdr, node);
> +	xfs_da3_node_hdr_from_disk(mp, &nodehdr, node);
>  
>  	/* No entries in this node?  Tree is corrupt. */
>  	if (nodehdr.count == 0)
> @@ -564,7 +564,7 @@ _("can't read %s block %u for inode %" PRIu64 "\n"),
>  		}
>  
>  		newnode = bp->b_addr;
> -		libxfs_da3_node_hdr_from_disk(mp, &nodehdr, newnode);
> +		xfs_da3_node_hdr_from_disk(mp, &nodehdr, newnode);
>  
>  		/*
>  		 * verify magic number and back pointer, sanity-check
> @@ -603,7 +603,7 @@ _("bad level %d in %s block %u for inode %" PRIu64 "\n"),
>  #ifdef XR_DIR_TRACE
>  			fprintf(stderr, "verify_da_path returns 1 (bad) #4\n");
>  #endif
> -			libxfs_buf_relse(bp);
> +			xfs_buf_relse(bp);
>  			return 1;
>  		}
>  
> @@ -624,10 +624,10 @@ _("bad level %d in %s block %u for inode %" PRIu64 "\n"),
>  
>  		if (cursor->level[this_level].dirty && !no_modify) {
>  			libxfs_buf_mark_dirty(cursor->level[this_level].bp);
> -			libxfs_buf_relse(cursor->level[this_level].bp);
> +			xfs_buf_relse(cursor->level[this_level].bp);
>  		}
>  		else
> -			libxfs_buf_relse(cursor->level[this_level].bp);
> +			xfs_buf_relse(cursor->level[this_level].bp);
>  
>  		/* switch cursor to point at the new buffer we just read */
>  		cursor->level[this_level].bp = bp;
> diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
> index 6685a4d2..f58b7058 100644
> --- a/repair/dino_chunks.c
> +++ b/repair/dino_chunks.c
> @@ -40,7 +40,7 @@ check_aginode_block(xfs_mount_t	*mp,
>  	 * tree and we wouldn't be here and we stale the buffers out
>  	 * so no one else will overlap them.
>  	 */
> -	error = -libxfs_buf_read(mp->m_dev, XFS_AGB_TO_DADDR(mp, agno, agbno),
> +	error = -xfs_buf_read(mp->m_dev, XFS_AGB_TO_DADDR(mp, agno, agbno),
>  			XFS_FSB_TO_BB(mp, 1), LIBXFS_READBUF_SALVAGE, &bp,
>  			NULL);
>  	if (error) {
> @@ -58,7 +58,7 @@ check_aginode_block(xfs_mount_t	*mp,
>  	if (cnt)
>  		bp->b_ops = &xfs_inode_buf_ops;
>  
> -	libxfs_buf_relse(bp);
> +	xfs_buf_relse(bp);
>  	return(cnt);
>  }
>  
> @@ -67,7 +67,7 @@ check_aginode_block(xfs_mount_t	*mp,
>   * inode chunk.  returns number of new inodes if things are good
>   * and 0 if bad.  start is the start of the discovered inode chunk.
>   * routine assumes that ino is a legal inode number
> - * (verified by libxfs_verify_ino()).  If the inode chunk turns out
> + * (verified by xfs_verify_ino()).  If the inode chunk turns out
>   * to be good, this routine will put the inode chunk into
>   * the good inode chunk tree if required.
>   *
> @@ -659,7 +659,7 @@ process_inode_chunk(
>  		pftrace("about to read off %llu in AG %d",
>  			XFS_AGB_TO_DADDR(mp, agno, agbno), agno);
>  
> -		error = -libxfs_buf_read(mp->m_dev,
> +		error = -xfs_buf_read(mp->m_dev,
>  				XFS_AGB_TO_DADDR(mp, agno, agbno),
>  				XFS_FSB_TO_BB(mp,
>  					M_IGEO(mp)->blocks_per_cluster),
> @@ -673,7 +673,7 @@ process_inode_chunk(
>  					M_IGEO(mp)->blocks_per_cluster));
>  			while (bp_index > 0) {
>  				bp_index--;
> -				libxfs_buf_relse(bplist[bp_index]);
> +				xfs_buf_relse(bplist[bp_index]);
>  			}
>  			free(bplist);
>  			return(1);
> @@ -762,7 +762,7 @@ next_readbuf:
>  			*bogus = 1;
>  			for (bp_index = 0; bp_index < cluster_count; bp_index++)
>  				if (bplist[bp_index])
> -					libxfs_buf_relse(bplist[bp_index]);
> +					xfs_buf_relse(bplist[bp_index]);
>  			free(bplist);
>  			return(0);
>  		}
> @@ -808,7 +808,7 @@ next_readbuf:
>  		ASSERT(is_used != 3);
>  		if (ino_dirty) {
>  			dirty = 1;
> -			libxfs_dinode_calc_crc(mp, dino);
> +			xfs_dinode_calc_crc(mp, dino);
>  		}
>  
>  		/*
> @@ -838,7 +838,7 @@ next_readbuf:
>  			 * phase 6.
>  			 */
>  			set_inode_ftype(ino_rec, irec_offset,
> -				libxfs_mode_to_ftype(be16_to_cpu(dino->di_mode)));
> +				xfs_mode_to_ftype(be16_to_cpu(dino->di_mode)));
>  
>  			/*
>  			 * store on-disk nlink count for comparing in phase 7
> @@ -944,10 +944,10 @@ process_next:
>  
>  				if (dirty && !no_modify) {
>  					libxfs_buf_mark_dirty(bplist[bp_index]);
> -					libxfs_buf_relse(bplist[bp_index]);
> +					xfs_buf_relse(bplist[bp_index]);
>  				}
>  				else
> -					libxfs_buf_relse(bplist[bp_index]);
> +					xfs_buf_relse(bplist[bp_index]);
>  			}
>  			free(bplist);
>  			break;
> diff --git a/repair/dinode.c b/repair/dinode.c
> index 1f1cc26b..4c05eb89 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -749,7 +749,7 @@ get_agino_buf(
>  		cluster_agino, cluster_daddr, cluster_blks);
>  #endif
>  
> -	error = -libxfs_buf_read(mp->m_dev, cluster_daddr, cluster_blks, 0,
> +	error = -xfs_buf_read(mp->m_dev, cluster_daddr, cluster_blks, 0,
>  			&bp, &xfs_inode_buf_ops);
>  	if (error) {
>  		do_warn(_("cannot read inode (%u/%u), disk block %" PRIu64 "\n"),
> @@ -844,7 +844,7 @@ _("bad numrecs 0 in inode %" PRIu64 " bmap btree root block\n"),
>  	init_bm_cursor(&cursor, level + 1);
>  
>  	pp = XFS_BMDR_PTR_ADDR(dib, 1,
> -		libxfs_bmdr_maxrecs(XFS_DFORK_SIZE(dip, mp, whichfork), 0));
> +		xfs_bmdr_maxrecs(XFS_DFORK_SIZE(dip, mp, whichfork), 0));
>  	pkey = XFS_BMDR_KEY_ADDR(dib, 1);
>  	last_key = NULLFILEOFF;
>  
> @@ -1170,7 +1170,7 @@ process_quota_inode(
>  	}
>  
>  	dqchunklen = XFS_FSB_TO_BB(mp, XFS_DQUOT_CLUSTER_SIZE_FSB);
> -	dqperchunk = libxfs_calc_dquots_per_chunk(dqchunklen);
> +	dqperchunk = xfs_calc_dquots_per_chunk(dqchunklen);
>  	dqid = 0;
>  	qbno = NULLFILEOFF;
>  
> @@ -1181,7 +1181,7 @@ process_quota_inode(
>  		fsbno = blkmap_get(blkmap, qbno);
>  		dqid = (xfs_dqid_t)qbno * dqperchunk;
>  
> -		error = -libxfs_buf_read(mp->m_dev,
> +		error = -xfs_buf_read(mp->m_dev,
>  				XFS_FSB_TO_DADDR(mp, fsbno), dqchunklen,
>  				LIBXFS_READBUF_SALVAGE, &bp,
>  				&xfs_dquot_buf_ops);
> @@ -1198,7 +1198,7 @@ _("cannot read inode %" PRIu64 ", file block %" PRIu64 ", disk block %" PRIu64 "
>  
>  			/* We only print the first problem we find */
>  			if (xfs_sb_version_hascrc(&mp->m_sb)) {
> -				if (!libxfs_verify_cksum((char *)dqb,
> +				if (!xfs_verify_cksum((char *)dqb,
>  							sizeof(*dqb),
>  							XFS_DQUOT_CRC_OFF)) {
>  					do_warn(_("%s: bad CRC for id %u. "),
> @@ -1215,7 +1215,7 @@ _("cannot read inode %" PRIu64 ", file block %" PRIu64 ", disk block %" PRIu64 "
>  					goto bad;
>  				}
>  			}
> -			if (libxfs_dquot_verify(mp, &dqb->dd_diskdq, dqid,
> +			if (xfs_dquot_verify(mp, &dqb->dd_diskdq, dqid,
>  						quota_type) != NULL) {
>  				do_warn(_("%s: Corrupt quota for id %u. "),
>  						quota_string, dqid);
> @@ -1228,7 +1228,7 @@ bad:
>  					do_warn(_("Would correct.\n"));
>  				else {
>  					do_warn(_("Corrected.\n"));
> -					libxfs_dqblk_repair(mp, dqb,
> +					xfs_dqblk_repair(mp, dqb,
>  							    dqid, quota_type);
>  					writebuf = 1;
>  				}
> @@ -1237,10 +1237,10 @@ bad:
>  
>  		if (writebuf && !no_modify) {
>  			libxfs_buf_mark_dirty(bp);
> -			libxfs_buf_relse(bp);
> +			xfs_buf_relse(bp);
>  		}
>  		else
> -			libxfs_buf_relse(bp);
> +			xfs_buf_relse(bp);
>  	}
>  	return 0;
>  }
> @@ -1291,7 +1291,7 @@ _("cannot read inode %" PRIu64 ", file block %d, NULL disk block\n"),
>  
>  		byte_cnt = XFS_FSB_TO_B(mp, blk_cnt);
>  
> -		error = -libxfs_buf_read(mp->m_dev,
> +		error = -xfs_buf_read(mp->m_dev,
>  				XFS_FSB_TO_DADDR(mp, fsbno), BTOBB(byte_cnt),
>  				LIBXFS_READBUF_SALVAGE, &bp,
>  				&xfs_symlink_buf_ops);
> @@ -1305,7 +1305,7 @@ _("cannot read inode %" PRIu64 ", file block %d, disk block %" PRIu64 "\n"),
>  			do_warn(
>  _("Corrupt symlink remote block %" PRIu64 ", inode %" PRIu64 ".\n"),
>  				fsbno, lino);
> -			libxfs_buf_relse(bp);
> +			xfs_buf_relse(bp);
>  			return 1;
>  		}
>  		if (bp->b_error == -EFSBADCRC) {
> @@ -1320,12 +1320,12 @@ _("Bad symlink buffer CRC, block %" PRIu64 ", inode %" PRIu64 ".\n"
>  
>  		src = bp->b_addr;
>  		if (xfs_sb_version_hascrc(&mp->m_sb)) {
> -			if (!libxfs_symlink_hdr_ok(lino, offset,
> +			if (!xfs_symlink_hdr_ok(lino, offset,
>  						   byte_cnt, bp)) {
>  				do_warn(
>  _("bad symlink header ino %" PRIu64 ", file block %d, disk block %" PRIu64 "\n"),
>  					lino, i, fsbno);
> -				libxfs_buf_relse(bp);
> +				xfs_buf_relse(bp);
>  				return 1;
>  			}
>  			src += sizeof(struct xfs_dsymlink_hdr);
> @@ -1339,10 +1339,10 @@ _("bad symlink header ino %" PRIu64 ", file block %d, disk block %" PRIu64 "\n")
>  
>  		if (badcrc && !no_modify) {
>  			libxfs_buf_mark_dirty(bp);
> -			libxfs_buf_relse(bp);
> +			xfs_buf_relse(bp);
>  		}
>  		else
> -			libxfs_buf_relse(bp);
> +			xfs_buf_relse(bp);
>  	}
>  	return 0;
>  }
> @@ -2284,7 +2284,7 @@ process_dinode_int(xfs_mount_t *mp,
>  	 * rewritten, and the CRC is updated automagically.
>  	 */
>  	if (xfs_sb_version_hascrc(&mp->m_sb) &&
> -	    !libxfs_verify_cksum((char *)dino, mp->m_sb.sb_inodesize,
> +	    !xfs_verify_cksum((char *)dino, mp->m_sb.sb_inodesize,
>  				XFS_DINODE_CRC_OFF)) {
>  		retval = 1;
>  		if (!uncertain)
> @@ -2315,7 +2315,7 @@ process_dinode_int(xfs_mount_t *mp,
>  		}
>  	}
>  
> -	if (!libxfs_dinode_good_version(&mp->m_sb, dino->di_version)) {
> +	if (!xfs_dinode_good_version(&mp->m_sb, dino->di_version)) {
>  		retval = 1;
>  		if (!uncertain)
>  			do_warn(_("bad version number 0x%x on inode %" PRIu64 "%c"),
> @@ -2404,7 +2404,7 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
>  			 * it just in case to ensure that format, etc. are
>  			 * set correctly
>  			 */
> -			if (libxfs_dinode_verify(mp, lino, dino) != NULL) {
> +			if (xfs_dinode_verify(mp, lino, dino) != NULL) {
>  				do_warn(
>   _("free inode %" PRIu64 " contains errors, "), lino);
>  				if (!no_modify) {
> @@ -2712,7 +2712,7 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
>  	 * only regular files with REALTIME or EXTSIZE flags set can have
>  	 * extsize set, or directories with EXTSZINHERIT.
>  	 */
> -	if (libxfs_inode_validate_extsize(mp,
> +	if (xfs_inode_validate_extsize(mp,
>  			be32_to_cpu(dino->di_extsize),
>  			be16_to_cpu(dino->di_mode),
>  			be16_to_cpu(dino->di_flags)) != NULL) {
> @@ -2734,7 +2734,7 @@ _("Bad extent size %u on inode %" PRIu64 ", "),
>  	 * set can have extsize set.
>  	 */
>  	if (dino->di_version >= 3 &&
> -	    libxfs_inode_validate_cowextsize(mp,
> +	    xfs_inode_validate_cowextsize(mp,
>  			be32_to_cpu(dino->di_cowextsize),
>  			be16_to_cpu(dino->di_mode),
>  			be16_to_cpu(dino->di_flags),
> diff --git a/repair/dir2.c b/repair/dir2.c
> index cbbce601..dec6d36d 100644
> --- a/repair/dir2.c
> +++ b/repair/dir2.c
> @@ -84,8 +84,8 @@ process_sf_dir2_fixi8(
>  	memmove(oldsfp, newsfp, oldsize);
>  	newsfp->count = oldsfp->count;
>  	newsfp->i8count = 0;
> -	ino = libxfs_dir2_sf_get_parent_ino(sfp);
> -	libxfs_dir2_sf_put_parent_ino(newsfp, ino);
> +	ino = xfs_dir2_sf_get_parent_ino(sfp);
> +	xfs_dir2_sf_put_parent_ino(newsfp, ino);
>  	oldsfep = xfs_dir2_sf_firstentry(oldsfp);
>  	newsfep = xfs_dir2_sf_firstentry(newsfp);
>  	while ((int)((char *)oldsfep - (char *)oldsfp) < oldsize) {
> @@ -93,10 +93,10 @@ process_sf_dir2_fixi8(
>  		xfs_dir2_sf_put_offset(newsfep,
>  			xfs_dir2_sf_get_offset(oldsfep));
>  		memmove(newsfep->name, oldsfep->name, newsfep->namelen);
> -		ino = libxfs_dir2_sf_get_ino(mp, oldsfp, oldsfep);
> -		libxfs_dir2_sf_put_ino(mp, newsfp, newsfep, ino);
> -		oldsfep = libxfs_dir2_sf_nextentry(mp, oldsfp, oldsfep);
> -		newsfep = libxfs_dir2_sf_nextentry(mp, newsfp, newsfep);
> +		ino = xfs_dir2_sf_get_ino(mp, oldsfp, oldsfep);
> +		xfs_dir2_sf_put_ino(mp, newsfp, newsfep, ino);
> +		oldsfep = xfs_dir2_sf_nextentry(mp, oldsfp, oldsfep);
> +		newsfep = xfs_dir2_sf_nextentry(mp, newsfp, newsfep);
>  	}
>  	*next_sfep = newsfep;
>  	free(oldsfp);
> @@ -121,8 +121,8 @@ process_sf_dir2_fixoff(
>  
>  	for (i = 0; i < sfp->count; i++) {
>  		xfs_dir2_sf_put_offset(sfep, offset);
> -		offset += libxfs_dir2_data_entsize(mp, sfep->namelen);
> -		sfep = libxfs_dir2_sf_nextentry(mp, sfp, sfep);
> +		offset += xfs_dir2_data_entsize(mp, sfep->namelen);
> +		sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep);
>  	}
>  }
>  
> @@ -179,12 +179,12 @@ process_sf_dir2(
>  	/*
>  	 * Initialize i8 based on size of parent inode number.
>  	 */
> -	i8 = (libxfs_dir2_sf_get_parent_ino(sfp) > XFS_DIR2_MAX_SHORT_INUM);
> +	i8 = (xfs_dir2_sf_get_parent_ino(sfp) > XFS_DIR2_MAX_SHORT_INUM);
>  
>  	/*
>  	 * check for bad entry count
>  	 */
> -	if (num_entries * libxfs_dir2_sf_entsize(mp, sfp, 1) +
> +	if (num_entries * xfs_dir2_sf_entsize(mp, sfp, 1) +
>  		    xfs_dir2_sf_hdr_size(0) > max_size || num_entries == 0)
>  		num_entries = 0xFF;
>  
> @@ -200,7 +200,7 @@ process_sf_dir2(
>  		sfep = next_sfep;
>  		junkit = 0;
>  		bad_sfnamelen = 0;
> -		lino = libxfs_dir2_sf_get_ino(mp, sfp, sfep);
> +		lino = xfs_dir2_sf_get_ino(mp, sfp, sfep);
>  		/*
>  		 * if entry points to self, junk it since only '.' or '..'
>  		 * should do that and shortform dirs don't contain either
> @@ -215,7 +215,7 @@ process_sf_dir2(
>  		if (lino == ino) {
>  			junkit = 1;
>  			junkreason = _("current");
> -		} else if (!libxfs_verify_dir_ino(mp, lino)) {
> +		} else if (!xfs_verify_dir_ino(mp, lino)) {
>  			junkit = 1;
>  			junkreason = _("invalid");
>  		} else if (lino == mp->m_sb.sb_rbmino)  {
> @@ -281,7 +281,7 @@ _("entry \"%*.*s\" in shortform directory %" PRIu64 " references %s inode %" PRI
>  			junkreason = _("is zero length");
>  			bad_sfnamelen = 1;
>  		} else if ((intptr_t) sfep - (intptr_t) sfp +
> -				libxfs_dir2_sf_entsize(mp, sfp, sfep->namelen)
> +				xfs_dir2_sf_entsize(mp, sfp, sfep->namelen)
>  							> ino_dir_size)  {
>  			junkreason = _("extends past end of dir");
>  			bad_sfnamelen = 1;
> @@ -310,7 +310,7 @@ _("entry #%d %s in shortform dir %" PRIu64),
>  		 * the length value is stored in a byte
>  		 * so it can't be too big, it can only wrap
>  		 */
> -		if (!libxfs_dir2_namecheck(sfep->name, namelen)) {
> +		if (!xfs_dir2_namecheck(sfep->name, namelen)) {
>  			/*
>  			 * junk entry
>  			 */
> @@ -327,7 +327,7 @@ _("entry contains offset out of order in shortform dir %" PRIu64 "\n"),
>  			bad_offset = 1;
>  		}
>  		offset = xfs_dir2_sf_get_offset(sfep) +
> -					libxfs_dir2_data_entsize(mp, namelen);
> +					xfs_dir2_data_entsize(mp, namelen);
>  
>  		/*
>  		 * junk the entry by copying up the rest of the
> @@ -344,7 +344,7 @@ _("entry contains offset out of order in shortform dir %" PRIu64 "\n"),
>  			name[namelen] = '\0';
>  
>  			if (!no_modify)  {
> -				tmp_elen = libxfs_dir2_sf_entsize(mp, sfp,
> +				tmp_elen = xfs_dir2_sf_entsize(mp, sfp,
>  								sfep->namelen);
>  				be64_add_cpu(&dip->di_size, -tmp_elen);
>  				ino_dir_size -= tmp_elen;
> @@ -398,8 +398,8 @@ _("would have junked entry \"%s\" in directory inode %" PRIu64 "\n"),
>  		next_sfep = (tmp_sfep == NULL)
>  			? (xfs_dir2_sf_entry_t *) ((intptr_t) sfep
>  							+ ((!bad_sfnamelen)
> -				? libxfs_dir2_sf_entsize(mp, sfp, sfep->namelen)
> -				: libxfs_dir2_sf_entsize(mp, sfp, namelen)))
> +				? xfs_dir2_sf_entsize(mp, sfp, sfep->namelen)
> +				: xfs_dir2_sf_entsize(mp, sfp, namelen)))
>  			: tmp_sfep;
>  	}
>  
> @@ -479,14 +479,14 @@ _("corrected entry offsets in directory %" PRIu64 "\n"),
>  	/*
>  	 * check parent (..) entry
>  	 */
> -	*parent = libxfs_dir2_sf_get_parent_ino(sfp);
> +	*parent = xfs_dir2_sf_get_parent_ino(sfp);
>  
>  	/*
>  	 * if parent entry is bogus, null it out.  we'll fix it later .
>  	 * If the validation fails for the root inode we fix it in
>  	 * the next else case.
>  	 */
> -	if (!libxfs_verify_dir_ino(mp, *parent) && ino != mp->m_sb.sb_rootino) {
> +	if (!xfs_verify_dir_ino(mp, *parent) && ino != mp->m_sb.sb_rootino) {
>  		do_warn(
>  _("bogus .. inode number (%" PRIu64 ") in directory inode %" PRIu64 ", "),
>  				*parent, ino);
> @@ -494,7 +494,7 @@ _("bogus .. inode number (%" PRIu64 ") in directory inode %" PRIu64 ", "),
>  		if (!no_modify)  {
>  			do_warn(_("clearing inode number\n"));
>  
> -			libxfs_dir2_sf_put_parent_ino(sfp, zero);
> +			xfs_dir2_sf_put_parent_ino(sfp, zero);
>  			*dino_dirty = 1;
>  			*repair = 1;
>  		} else  {
> @@ -509,7 +509,7 @@ _("bogus .. inode number (%" PRIu64 ") in directory inode %" PRIu64 ", "),
>  _("corrected root directory %" PRIu64 " .. entry, was %" PRIu64 ", now %" PRIu64 "\n"),
>  				ino, *parent, ino);
>  			*parent = ino;
> -			libxfs_dir2_sf_put_parent_ino(sfp, ino);
> +			xfs_dir2_sf_put_parent_ino(sfp, ino);
>  			*dino_dirty = 1;
>  			*repair = 1;
>  		} else  {
> @@ -529,7 +529,7 @@ _("bad .. entry in directory inode %" PRIu64 ", points to self, "),
>  		if (!no_modify)  {
>  			do_warn(_("clearing inode number\n"));
>  
> -			libxfs_dir2_sf_put_parent_ino(sfp, zero);
> +			xfs_dir2_sf_put_parent_ino(sfp, zero);
>  			*dino_dirty = 1;
>  			*repair = 1;
>  		} else  {
> @@ -578,7 +578,7 @@ process_dir2_data(
>  	xfs_ino_t		ent_ino;
>  
>  	d = bp->b_addr;
> -	bf = libxfs_dir2_data_bestfree_p(mp, d);
> +	bf = xfs_dir2_data_bestfree_p(mp, d);
>  	ptr = (char *)d + mp->m_dir_geo->data_entry_offset;
>  	badbest = lastfree = freeseen = 0;
>  	if (be16_to_cpu(bf[0].length) == 0) {
> @@ -624,12 +624,12 @@ process_dir2_data(
>  			continue;
>  		}
>  		dep = (xfs_dir2_data_entry_t *)ptr;
> -		if (ptr + libxfs_dir2_data_entsize(mp, dep->namelen) > endptr)
> +		if (ptr + xfs_dir2_data_entsize(mp, dep->namelen) > endptr)
>  			break;
> -		if (be16_to_cpu(*libxfs_dir2_data_entry_tag_p(mp, dep)) !=
> +		if (be16_to_cpu(*xfs_dir2_data_entry_tag_p(mp, dep)) !=
>  		    				(char *)dep - (char *)d)
>  			break;
> -		ptr += libxfs_dir2_data_entsize(mp, dep->namelen);
> +		ptr += xfs_dir2_data_entsize(mp, dep->namelen);
>  		lastfree = 0;
>  	}
>  	/*
> @@ -673,7 +673,7 @@ process_dir2_data(
>  			 * (or did it ourselves) during phase 3.
>  			 */
>  			clearino = 0;
> -		} else if (!libxfs_verify_dir_ino(mp, ent_ino)) {
> +		} else if (!xfs_verify_dir_ino(mp, ent_ino)) {
>  			/*
>  			 * Bad inode number.  Clear the inode number and the
>  			 * entry will get removed later.  We don't trash the
> @@ -780,7 +780,7 @@ _("\twould clear inode number in entry at offset %" PRIdPTR "...\n"),
>  		 * during phase 4.
>  		 */
>  		junkit = dep->name[0] == '/';
> -		nm_illegal = !libxfs_dir2_namecheck(dep->name, dep->namelen);
> +		nm_illegal = !xfs_dir2_namecheck(dep->name, dep->namelen);
>  		if (ino_discovery && nm_illegal) {
>  			do_warn(
>  _("entry at block %u offset %" PRIdPTR " in directory inode %" PRIu64 " has illegal name \"%*.*s\": "),
> @@ -842,7 +842,7 @@ _("bad .. entry in root directory inode %" PRIu64 ", was %" PRIu64 ": "),
>  				 */
>  				if (!junkit &&
>  				    *parent != NULLFSINO &&
> -				    !libxfs_verify_ino(mp, *parent)) {
> +				    !xfs_verify_ino(mp, *parent)) {
>  					do_warn(
>  _("bad .. entry in directory inode %" PRIu64 ", was %" PRIu64 ": "),
>  						ino, *parent);
> @@ -916,7 +916,7 @@ _("entry \"%*.*s\" in directory inode %" PRIu64 " points to self: "),
>  		/*
>  		 * Advance to the next entry.
>  		 */
> -		ptr += libxfs_dir2_data_entsize(mp, dep->namelen);
> +		ptr += xfs_dir2_data_entsize(mp, dep->namelen);
>  	}
>  	/*
>  	 * Check the bestfree table.
> @@ -927,7 +927,7 @@ _("bad bestfree table in block %u in directory inode %" PRIu64 ": "),
>  			da_bno, ino);
>  		if (!no_modify) {
>  			do_warn(_("repairing table\n"));
> -			libxfs_dir2_data_freescan(mp, d, &i);
> +			xfs_dir2_data_freescan(mp, d, &i);
>  			*dirty = 1;
>  		} else {
>  			do_warn(_("would repair table\n"));
> @@ -1011,9 +1011,9 @@ _("bad directory block magic # %#x in block %u for directory inode %" PRIu64 "\n
>  	if (dirty && !no_modify) {
>  		*repair = 1;
>  		libxfs_buf_mark_dirty(bp);
> -		libxfs_buf_relse(bp);
> +		xfs_buf_relse(bp);
>  	} else
> -		libxfs_buf_relse(bp);
> +		xfs_buf_relse(bp);
>  	return rval;
>  }
>  
> @@ -1037,7 +1037,7 @@ process_leaf_block_dir2(
>  	struct xfs_dir2_leaf_entry *ents;
>  	struct xfs_dir3_icleaf_hdr leafhdr;
>  
> -	libxfs_dir2_leaf_hdr_from_disk(mp, &leafhdr, leaf);
> +	xfs_dir2_leaf_hdr_from_disk(mp, &leafhdr, leaf);
>  	ents = leafhdr.ents;
>  
>  	for (i = stale = 0; i < leafhdr.count; i++) {
> @@ -1123,7 +1123,7 @@ _("can't read file block %u for directory inode %" PRIu64 "\n"),
>  			goto error_out;
>  		}
>  		leaf = bp->b_addr;
> -		libxfs_dir2_leaf_hdr_from_disk(mp, &leafhdr, leaf);
> +		xfs_dir2_leaf_hdr_from_disk(mp, &leafhdr, leaf);
>  		/*
>  		 * Check magic number for leaf directory btree block.
>  		 */
> @@ -1132,7 +1132,7 @@ _("can't read file block %u for directory inode %" PRIu64 "\n"),
>  			do_warn(
>  _("bad directory leaf magic # %#x for directory inode %" PRIu64 " block %u\n"),
>  				leafhdr.magic, ino, da_bno);
> -			libxfs_buf_relse(bp);
> +			xfs_buf_relse(bp);
>  			goto error_out;
>  		}
>  		buf_dirty = 0;
> @@ -1142,7 +1142,7 @@ _("bad directory leaf magic # %#x for directory inode %" PRIu64 " block %u\n"),
>  		 */
>  		if (process_leaf_block_dir2(mp, leaf, da_bno, ino,
>  				current_hashval, &greatest_hashval)) {
> -			libxfs_buf_relse(bp);
> +			xfs_buf_relse(bp);
>  			goto error_out;
>  		}
>  		/*
> @@ -1160,14 +1160,14 @@ _("bad directory leaf magic # %#x for directory inode %" PRIu64 " block %u\n"),
>  			do_warn(
>  _("bad sibling back pointer for block %u in directory inode %" PRIu64 "\n"),
>  				da_bno, ino);
> -			libxfs_buf_relse(bp);
> +			xfs_buf_relse(bp);
>  			goto error_out;
>  		}
>  		prev_bno = da_bno;
>  		da_bno = leafhdr.forw;
>  		if (da_bno != 0) {
>  			if (verify_da_path(mp, da_cursor, 0, XFS_DATA_FORK)) {
> -				libxfs_buf_relse(bp);
> +				xfs_buf_relse(bp);
>  				goto error_out;
>  			}
>  		}
> @@ -1182,9 +1182,9 @@ _("bad sibling back pointer for block %u in directory inode %" PRIu64 "\n"),
>  		if (buf_dirty && !no_modify) {
>  			*repair = 1;
>  			libxfs_buf_mark_dirty(bp);
> -			libxfs_buf_relse(bp);
> +			xfs_buf_relse(bp);
>  		} else
> -			libxfs_buf_relse(bp);
> +			xfs_buf_relse(bp);
>  	} while (da_bno != 0);
>  	if (verify_final_da_path(mp, da_cursor, 0, XFS_DATA_FORK)) {
>  		/*
> @@ -1342,9 +1342,9 @@ _("bad directory block magic # %#x in block %" PRIu64 " for directory inode %" P
>  		if (dirty && !no_modify) {
>  			*repair = 1;
>  			libxfs_buf_mark_dirty(bp);
> -			libxfs_buf_relse(bp);
> +			xfs_buf_relse(bp);
>  		} else
> -			libxfs_buf_relse(bp);
> +			xfs_buf_relse(bp);
>  	}
>  	if (good == 0)
>  		return 1;
> diff --git a/repair/phase3.c b/repair/phase3.c
> index ca4dbee4..c025b476 100644
> --- a/repair/phase3.c
> +++ b/repair/phase3.c
> @@ -29,7 +29,7 @@ process_agi_unlinked(
>  	int			agi_dirty = 0;
>  	int			error;
>  
> -	error = -libxfs_buf_read(mp->m_dev,
> +	error = -xfs_buf_read(mp->m_dev,
>  			XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
>  			mp->m_sb.sb_sectsize / BBSIZE, LIBXFS_READBUF_SALVAGE,
>  			&bp, &xfs_agi_buf_ops);
> @@ -50,10 +50,10 @@ process_agi_unlinked(
>  
>  	if (agi_dirty) {
>  		libxfs_buf_mark_dirty(bp);
> -		libxfs_buf_relse(bp);
> +		xfs_buf_relse(bp);
>  	}
>  	else
> -		libxfs_buf_relse(bp);
> +		xfs_buf_relse(bp);
>  }
>  
>  static void
> diff --git a/repair/phase4.c b/repair/phase4.c
> index 8197db06..0fad2db5 100644
> --- a/repair/phase4.c
> +++ b/repair/phase4.c
> @@ -36,7 +36,7 @@ quotino_check(xfs_mount_t *mp)
>  	ino_tree_node_t *irec;
>  
>  	if (mp->m_sb.sb_uquotino != NULLFSINO && mp->m_sb.sb_uquotino != 0)  {
> -		if (!libxfs_verify_ino(mp, mp->m_sb.sb_uquotino))
> +		if (!xfs_verify_ino(mp, mp->m_sb.sb_uquotino))
>  			irec = NULL;
>  		else
>  			irec = find_inode_rec(mp,
> @@ -52,7 +52,7 @@ quotino_check(xfs_mount_t *mp)
>  	}
>  
>  	if (mp->m_sb.sb_gquotino != NULLFSINO && mp->m_sb.sb_gquotino != 0)  {
> -		if (!libxfs_verify_ino(mp, mp->m_sb.sb_gquotino))
> +		if (!xfs_verify_ino(mp, mp->m_sb.sb_gquotino))
>  			irec = NULL;
>  		else
>  			irec = find_inode_rec(mp,
> @@ -68,7 +68,7 @@ quotino_check(xfs_mount_t *mp)
>  	}
>  
>  	if (mp->m_sb.sb_pquotino != NULLFSINO && mp->m_sb.sb_pquotino != 0)  {
> -		if (!libxfs_verify_ino(mp, mp->m_sb.sb_pquotino))
> +		if (!xfs_verify_ino(mp, mp->m_sb.sb_pquotino))
>  			irec = NULL;
>  		else
>  			irec = find_inode_rec(mp,
> @@ -112,9 +112,9 @@ quota_sb_check(xfs_mount_t *mp)
>  	    (mp->m_sb.sb_pquotino == NULLFSINO || mp->m_sb.sb_pquotino == 0))  {
>  		lost_quotas = 1;
>  		fs_quotas = 0;
> -	} else if (libxfs_verify_ino(mp, mp->m_sb.sb_uquotino) &&
> -		   libxfs_verify_ino(mp, mp->m_sb.sb_gquotino) &&
> -		   libxfs_verify_ino(mp, mp->m_sb.sb_pquotino)) {
> +	} else if (xfs_verify_ino(mp, mp->m_sb.sb_uquotino) &&
> +		   xfs_verify_ino(mp, mp->m_sb.sb_gquotino) &&
> +		   xfs_verify_ino(mp, mp->m_sb.sb_pquotino)) {
>  		fs_quotas = 1;
>  	}
>  }
> diff --git a/repair/phase5.c b/repair/phase5.c
> index 677297fe..c795679d 100644
> --- a/repair/phase5.c
> +++ b/repair/phase5.c
> @@ -322,10 +322,10 @@ write_cursor(bt_status_t *curs)
>  						curs->level[i].prev_agbno);
>  #endif
>  			libxfs_buf_mark_dirty(curs->level[i].prev_buf_p);
> -			libxfs_buf_relse(curs->level[i].prev_buf_p);
> +			xfs_buf_relse(curs->level[i].prev_buf_p);
>  		}
>  		libxfs_buf_mark_dirty(curs->level[i].buf_p);
> -		libxfs_buf_relse(curs->level[i].buf_p);
> +		xfs_buf_relse(curs->level[i].buf_p);
>  	}
>  }
>  
> @@ -352,7 +352,7 @@ finish_cursor(bt_status_t *curs)
>   * XXX(hch): any reason we don't just look at mp->m_alloc_mxr?
>   */
>  #define XR_ALLOC_BLOCK_MAXRECS(mp, level) \
> -	(libxfs_allocbt_maxrecs((mp), (mp)->m_sb.sb_blocksize, (level) == 0) - 2)
> +	(xfs_allocbt_maxrecs((mp), (mp)->m_sb.sb_blocksize, (level) == 0) - 2)
>  
>  /*
>   * this calculates a freespace cursor for an ag.
> @@ -685,7 +685,7 @@ prop_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
>  		if (lptr->prev_agbno != NULLAGBLOCK) {
>  			ASSERT(lptr->prev_buf_p != NULL);
>  			libxfs_buf_mark_dirty(lptr->prev_buf_p);
> -			libxfs_buf_relse(lptr->prev_buf_p);
> +			xfs_buf_relse(lptr->prev_buf_p);
>  		}
>  		lptr->prev_agbno = lptr->agbno;;
>  		lptr->prev_buf_p = lptr->buf_p;
> @@ -693,7 +693,7 @@ prop_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
>  
>  		bt_hdr->bb_u.s.bb_rightsib = cpu_to_be32(agbno);
>  
> -		error = -libxfs_buf_get(mp->m_dev,
> +		error = -xfs_buf_get(mp->m_dev,
>  				XFS_AGB_TO_DADDR(mp, agno, agbno),
>  				XFS_FSB_TO_BB(mp, 1), &lptr->buf_p);
>  		if (error)
> @@ -711,7 +711,7 @@ prop_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
>  		lptr->buf_p->b_ops = ops;
>  		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
>  		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
> -		libxfs_btree_init_block(mp, lptr->buf_p, btnum, level,
> +		xfs_btree_init_block(mp, lptr->buf_p, btnum, level,
>  					0, agno);
>  
>  		bt_hdr->bb_u.s.bb_leftsib = cpu_to_be32(lptr->prev_agbno);
> @@ -776,7 +776,7 @@ build_freespace_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
>  		lptr = &btree_curs->level[i];
>  
>  		agbno = get_next_blockaddr(agno, i, btree_curs);
> -		error = -libxfs_buf_get(mp->m_dev,
> +		error = -xfs_buf_get(mp->m_dev,
>  				XFS_AGB_TO_DADDR(mp, agno, agbno),
>  				XFS_FSB_TO_BB(mp, 1), &lptr->buf_p);
>  		if (error)
> @@ -796,7 +796,7 @@ build_freespace_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
>  		lptr->buf_p->b_ops = ops;
>  		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
>  		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
> -		libxfs_btree_init_block(mp, lptr->buf_p, btnum, i, 0, agno);
> +		xfs_btree_init_block(mp, lptr->buf_p, btnum, i, 0, agno);
>  	}
>  	/*
>  	 * run along leaf, setting up records.  as we have to switch
> @@ -823,7 +823,7 @@ build_freespace_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
>  		lptr->buf_p->b_ops = ops;
>  		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
>  		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
> -		libxfs_btree_init_block(mp, lptr->buf_p, btnum, 0, 0, agno);
> +		xfs_btree_init_block(mp, lptr->buf_p, btnum, 0, 0, agno);
>  
>  		bt_hdr->bb_u.s.bb_leftsib = cpu_to_be32(lptr->prev_agbno);
>  		bt_hdr->bb_numrecs = cpu_to_be16(lptr->num_recs_pb +
> @@ -884,14 +884,14 @@ build_freespace_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
>  #endif
>  				ASSERT(lptr->prev_agbno != NULLAGBLOCK);
>  				libxfs_buf_mark_dirty(lptr->prev_buf_p);
> -				libxfs_buf_relse(lptr->prev_buf_p);
> +				xfs_buf_relse(lptr->prev_buf_p);
>  			}
>  			lptr->prev_buf_p = lptr->buf_p;
>  			lptr->prev_agbno = lptr->agbno;
>  			lptr->agbno = get_next_blockaddr(agno, 0, btree_curs);
>  			bt_hdr->bb_u.s.bb_rightsib = cpu_to_be32(lptr->agbno);
>  
> -			error = -libxfs_buf_get(mp->m_dev,
> +			error = -xfs_buf_get(mp->m_dev,
>  					XFS_AGB_TO_DADDR(mp, agno, lptr->agbno),
>  					XFS_FSB_TO_BB(mp, 1),
>  					&lptr->buf_p);
> @@ -909,7 +909,7 @@ build_freespace_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
>   * XXX(hch): any reason we don't just look at mp->m_inobt_mxr?
>   */
>  #define XR_INOBT_BLOCK_MAXRECS(mp, level) \
> -			libxfs_inobt_maxrecs((mp), (mp)->m_sb.sb_blocksize, \
> +			xfs_inobt_maxrecs((mp), (mp)->m_sb.sb_blocksize, \
>  						(level) == 0)
>  
>  /*
> @@ -1067,7 +1067,7 @@ prop_ino_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
>  		if (lptr->prev_agbno != NULLAGBLOCK)  {
>  			ASSERT(lptr->prev_buf_p != NULL);
>  			libxfs_buf_mark_dirty(lptr->prev_buf_p);
> -			libxfs_buf_relse(lptr->prev_buf_p);
> +			xfs_buf_relse(lptr->prev_buf_p);
>  		}
>  		lptr->prev_agbno = lptr->agbno;;
>  		lptr->prev_buf_p = lptr->buf_p;
> @@ -1075,7 +1075,7 @@ prop_ino_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
>  
>  		bt_hdr->bb_u.s.bb_rightsib = cpu_to_be32(agbno);
>  
> -		error = -libxfs_buf_get(mp->m_dev,
> +		error = -xfs_buf_get(mp->m_dev,
>  				XFS_AGB_TO_DADDR(mp, agno, agbno),
>  				XFS_FSB_TO_BB(mp, 1), &lptr->buf_p);
>  		if (error)
> @@ -1092,7 +1092,7 @@ prop_ino_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
>  		lptr->buf_p->b_ops = ops;
>  		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
>  		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
> -		libxfs_btree_init_block(mp, lptr->buf_p, btnum,
> +		xfs_btree_init_block(mp, lptr->buf_p, btnum,
>  					level, 0, agno);
>  
>  		bt_hdr->bb_u.s.bb_leftsib = cpu_to_be32(lptr->prev_agbno);
> @@ -1129,7 +1129,7 @@ build_agi(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
>  	int		i;
>  	int		error;
>  
> -	error = -libxfs_buf_get(mp->m_dev,
> +	error = -xfs_buf_get(mp->m_dev,
>  			XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
>  			mp->m_sb.sb_sectsize / BBSIZE, &agi_buf);
>  	if (error)
> @@ -1166,7 +1166,7 @@ build_agi(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
>  	}
>  
>  	libxfs_buf_mark_dirty(agi_buf);
> -	libxfs_buf_relse(agi_buf);
> +	xfs_buf_relse(agi_buf);
>  }
>  
>  /*
> @@ -1204,7 +1204,7 @@ build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
>  		lptr = &btree_curs->level[i];
>  
>  		agbno = get_next_blockaddr(agno, i, btree_curs);
> -		error = -libxfs_buf_get(mp->m_dev,
> +		error = -xfs_buf_get(mp->m_dev,
>  				XFS_AGB_TO_DADDR(mp, agno, agbno),
>  				XFS_FSB_TO_BB(mp, 1), &lptr->buf_p);
>  		if (error)
> @@ -1224,7 +1224,7 @@ build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
>  		lptr->buf_p->b_ops = ops;
>  		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
>  		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
> -		libxfs_btree_init_block(mp, lptr->buf_p, btnum, i, 0, agno);
> +		xfs_btree_init_block(mp, lptr->buf_p, btnum, i, 0, agno);
>  	}
>  
>  	/*
> @@ -1252,7 +1252,7 @@ build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
>  		lptr->buf_p->b_ops = ops;
>  		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
>  		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
> -		libxfs_btree_init_block(mp, lptr->buf_p, btnum, 0, 0, agno);
> +		xfs_btree_init_block(mp, lptr->buf_p, btnum, 0, 0, agno);
>  
>  		bt_hdr->bb_u.s.bb_leftsib = cpu_to_be32(lptr->prev_agbno);
>  		bt_hdr->bb_numrecs = cpu_to_be16(lptr->num_recs_pb +
> @@ -1333,14 +1333,14 @@ nextrec:
>  #endif
>  				ASSERT(lptr->prev_agbno != NULLAGBLOCK);
>  				libxfs_buf_mark_dirty(lptr->prev_buf_p);
> -				libxfs_buf_relse(lptr->prev_buf_p);
> +				xfs_buf_relse(lptr->prev_buf_p);
>  			}
>  			lptr->prev_buf_p = lptr->buf_p;
>  			lptr->prev_agbno = lptr->agbno;
>  			lptr->agbno = get_next_blockaddr(agno, 0, btree_curs);
>  			bt_hdr->bb_u.s.bb_rightsib = cpu_to_be32(lptr->agbno);
>  
> -			error = -libxfs_buf_get(mp->m_dev,
> +			error = -xfs_buf_get(mp->m_dev,
>  					XFS_AGB_TO_DADDR(mp, agno, lptr->agbno),
>  					XFS_FSB_TO_BB(mp, 1),
>  					&lptr->buf_p);
> @@ -1492,7 +1492,7 @@ prop_rmap_cursor(
>  		if (lptr->prev_agbno != NULLAGBLOCK)  {
>  			ASSERT(lptr->prev_buf_p != NULL);
>  			libxfs_buf_mark_dirty(lptr->prev_buf_p);
> -			libxfs_buf_relse(lptr->prev_buf_p);
> +			xfs_buf_relse(lptr->prev_buf_p);
>  		}
>  		lptr->prev_agbno = lptr->agbno;
>  		lptr->prev_buf_p = lptr->buf_p;
> @@ -1500,7 +1500,7 @@ prop_rmap_cursor(
>  
>  		bt_hdr->bb_u.s.bb_rightsib = cpu_to_be32(agbno);
>  
> -		error = -libxfs_buf_get(mp->m_dev,
> +		error = -xfs_buf_get(mp->m_dev,
>  				XFS_AGB_TO_DADDR(mp, agno, agbno),
>  				XFS_FSB_TO_BB(mp, 1), &lptr->buf_p);
>  		if (error)
> @@ -1517,7 +1517,7 @@ prop_rmap_cursor(
>  		lptr->buf_p->b_ops = ops;
>  		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
>  		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
> -		libxfs_btree_init_block(mp, lptr->buf_p, XFS_BTNUM_RMAP,
> +		xfs_btree_init_block(mp, lptr->buf_p, XFS_BTNUM_RMAP,
>  					level, 0, agno);
>  
>  		bt_hdr->bb_u.s.bb_leftsib = cpu_to_be32(lptr->prev_agbno);
> @@ -1571,7 +1571,7 @@ prop_rmap_highkey(
>  		bt_key->rm_startblock = cpu_to_be32(high_key.rm_startblock);
>  		bt_key->rm_owner = cpu_to_be64(high_key.rm_owner);
>  		bt_key->rm_offset = cpu_to_be64(
> -				libxfs_rmap_irec_offset_pack(&high_key));
> +				xfs_rmap_irec_offset_pack(&high_key));
>  
>  		for (i = 1; i <= numrecs; i++) {
>  			bt_key = XFS_RMAP_HIGH_KEY_ADDR(bt_hdr, i);
> @@ -1613,7 +1613,7 @@ build_rmap_tree(
>  		lptr = &btree_curs->level[i];
>  
>  		agbno = get_next_blockaddr(agno, i, btree_curs);
> -		error = -libxfs_buf_get(mp->m_dev,
> +		error = -xfs_buf_get(mp->m_dev,
>  				XFS_AGB_TO_DADDR(mp, agno, agbno),
>  				XFS_FSB_TO_BB(mp, 1), &lptr->buf_p);
>  		if (error)
> @@ -1633,7 +1633,7 @@ build_rmap_tree(
>  		lptr->buf_p->b_ops = ops;
>  		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
>  		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
> -		libxfs_btree_init_block(mp, lptr->buf_p, XFS_BTNUM_RMAP,
> +		xfs_btree_init_block(mp, lptr->buf_p, XFS_BTNUM_RMAP,
>  					i, 0, agno);
>  	}
>  
> @@ -1660,7 +1660,7 @@ _("Insufficient memory to construct reverse-map cursor."));
>  		lptr->buf_p->b_ops = ops;
>  		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
>  		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
> -		libxfs_btree_init_block(mp, lptr->buf_p, XFS_BTNUM_RMAP,
> +		xfs_btree_init_block(mp, lptr->buf_p, XFS_BTNUM_RMAP,
>  					0, 0, agno);
>  
>  		bt_hdr->bb_u.s.bb_leftsib = cpu_to_be32(lptr->prev_agbno);
> @@ -1687,7 +1687,7 @@ _("Insufficient memory to construct reverse-map cursor."));
>  					cpu_to_be32(rm_rec->rm_blockcount);
>  			bt_rec[j].rm_owner = cpu_to_be64(rm_rec->rm_owner);
>  			bt_rec[j].rm_offset = cpu_to_be64(
> -					libxfs_rmap_irec_offset_pack(rm_rec));
> +					xfs_rmap_irec_offset_pack(rm_rec));
>  			rmap_high_key_from_rec(rm_rec, &hi_key);
>  			if (rmap_diffkeys(&hi_key, &highest_key) > 0)
>  				highest_key = hi_key;
> @@ -1709,14 +1709,14 @@ _("Insufficient memory to construct reverse-map cursor."));
>  #endif
>  				ASSERT(lptr->prev_agbno != NULLAGBLOCK);
>  				libxfs_buf_mark_dirty(lptr->prev_buf_p);
> -				libxfs_buf_relse(lptr->prev_buf_p);
> +				xfs_buf_relse(lptr->prev_buf_p);
>  			}
>  			lptr->prev_buf_p = lptr->buf_p;
>  			lptr->prev_agbno = lptr->agbno;
>  			lptr->agbno = get_next_blockaddr(agno, 0, btree_curs);
>  			bt_hdr->bb_u.s.bb_rightsib = cpu_to_be32(lptr->agbno);
>  
> -			error = -libxfs_buf_get(mp->m_dev,
> +			error = -xfs_buf_get(mp->m_dev,
>  					XFS_AGB_TO_DADDR(mp, agno, lptr->agbno),
>  					XFS_FSB_TO_BB(mp, 1),
>  					&lptr->buf_p);
> @@ -1856,7 +1856,7 @@ prop_refc_cursor(
>  		if (lptr->prev_agbno != NULLAGBLOCK)  {
>  			ASSERT(lptr->prev_buf_p != NULL);
>  			libxfs_buf_mark_dirty(lptr->prev_buf_p);
> -			libxfs_buf_relse(lptr->prev_buf_p);
> +			xfs_buf_relse(lptr->prev_buf_p);
>  		}
>  		lptr->prev_agbno = lptr->agbno;
>  		lptr->prev_buf_p = lptr->buf_p;
> @@ -1864,7 +1864,7 @@ prop_refc_cursor(
>  
>  		bt_hdr->bb_u.s.bb_rightsib = cpu_to_be32(agbno);
>  
> -		error = -libxfs_buf_get(mp->m_dev,
> +		error = -xfs_buf_get(mp->m_dev,
>  				XFS_AGB_TO_DADDR(mp, agno, agbno),
>  				XFS_FSB_TO_BB(mp, 1), &lptr->buf_p);
>  		if (error)
> @@ -1881,7 +1881,7 @@ prop_refc_cursor(
>  		lptr->buf_p->b_ops = ops;
>  		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
>  		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
> -		libxfs_btree_init_block(mp, lptr->buf_p, XFS_BTNUM_REFC,
> +		xfs_btree_init_block(mp, lptr->buf_p, XFS_BTNUM_REFC,
>  					level, 0, agno);
>  
>  		bt_hdr->bb_u.s.bb_leftsib = cpu_to_be32(lptr->prev_agbno);
> @@ -1932,7 +1932,7 @@ build_refcount_tree(
>  		lptr = &btree_curs->level[i];
>  
>  		agbno = get_next_blockaddr(agno, i, btree_curs);
> -		error = -libxfs_buf_get(mp->m_dev,
> +		error = -xfs_buf_get(mp->m_dev,
>  				XFS_AGB_TO_DADDR(mp, agno, agbno),
>  				XFS_FSB_TO_BB(mp, 1), &lptr->buf_p);
>  		if (error)
> @@ -1952,7 +1952,7 @@ build_refcount_tree(
>  		lptr->buf_p->b_ops = ops;
>  		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
>  		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
> -		libxfs_btree_init_block(mp, lptr->buf_p, XFS_BTNUM_REFC,
> +		xfs_btree_init_block(mp, lptr->buf_p, XFS_BTNUM_REFC,
>  					i, 0, agno);
>  	}
>  
> @@ -1979,7 +1979,7 @@ _("Insufficient memory to construct refcount cursor."));
>  		lptr->buf_p->b_ops = ops;
>  		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
>  		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
> -		libxfs_btree_init_block(mp, lptr->buf_p, XFS_BTNUM_REFC,
> +		xfs_btree_init_block(mp, lptr->buf_p, XFS_BTNUM_REFC,
>  					0, 0, agno);
>  
>  		bt_hdr->bb_u.s.bb_leftsib = cpu_to_be32(lptr->prev_agbno);
> @@ -2016,14 +2016,14 @@ _("Insufficient memory to construct refcount cursor."));
>  #endif
>  				ASSERT(lptr->prev_agbno != NULLAGBLOCK);
>  				libxfs_buf_mark_dirty(lptr->prev_buf_p);
> -				libxfs_buf_relse(lptr->prev_buf_p);
> +				xfs_buf_relse(lptr->prev_buf_p);
>  			}
>  			lptr->prev_buf_p = lptr->buf_p;
>  			lptr->prev_agbno = lptr->agbno;
>  			lptr->agbno = get_next_blockaddr(agno, 0, btree_curs);
>  			bt_hdr->bb_u.s.bb_rightsib = cpu_to_be32(lptr->agbno);
>  
> -			error = -libxfs_buf_get(mp->m_dev,
> +			error = -xfs_buf_get(mp->m_dev,
>  					XFS_AGB_TO_DADDR(mp, agno, lptr->agbno),
>  					XFS_FSB_TO_BB(mp, 1),
>  					&lptr->buf_p);
> @@ -2063,7 +2063,7 @@ build_agf_agfl(
>  	__be32			*freelist;
>  	int			error;
>  
> -	error = -libxfs_buf_get(mp->m_dev,
> +	error = -xfs_buf_get(mp->m_dev,
>  			XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
>  			mp->m_sb.sb_sectsize / BBSIZE, &agf_buf);
>  	if (error)
> @@ -2138,7 +2138,7 @@ build_agf_agfl(
>  		platform_uuid_copy(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid);
>  
>  	/* initialise the AGFL, then fill it if there are blocks left over. */
> -	error = -libxfs_buf_get(mp->m_dev,
> +	error = -xfs_buf_get(mp->m_dev,
>  			XFS_AG_DADDR(mp, agno, XFS_AGFL_DADDR(mp)),
>  			mp->m_sb.sb_sectsize / BBSIZE, &agfl_buf);
>  	if (error)
> @@ -2154,7 +2154,7 @@ build_agf_agfl(
>  		agfl->agfl_magicnum = cpu_to_be32(XFS_AGFL_MAGIC);
>  		agfl->agfl_seqno = cpu_to_be32(agno);
>  		platform_uuid_copy(&agfl->agfl_uuid, &mp->m_sb.sb_meta_uuid);
> -		for (i = 0; i < libxfs_agfl_size(mp); i++)
> +		for (i = 0; i < xfs_agfl_size(mp); i++)
>  			freelist[i] = cpu_to_be32(NULLAGBLOCK);
>  	}
>  
> @@ -2167,14 +2167,14 @@ build_agf_agfl(
>  		 * yes, now grab as many blocks as we can
>  		 */
>  		i = 0;
> -		while (bno_bt->num_free_blocks > 0 && i < libxfs_agfl_size(mp))
> +		while (bno_bt->num_free_blocks > 0 && i < xfs_agfl_size(mp))
>  		{
>  			freelist[i] = cpu_to_be32(
>  					get_next_blockaddr(agno, 0, bno_bt));
>  			i++;
>  		}
>  
> -		while (bcnt_bt->num_free_blocks > 0 && i < libxfs_agfl_size(mp))
> +		while (bcnt_bt->num_free_blocks > 0 && i < xfs_agfl_size(mp))
>  		{
>  			freelist[i] = cpu_to_be32(
>  					get_next_blockaddr(agno, 0, bcnt_bt));
> @@ -2211,12 +2211,12 @@ _("Insufficient memory saving lost blocks.\n"));
>  
>  	} else  {
>  		agf->agf_flfirst = 0;
> -		agf->agf_fllast = cpu_to_be32(libxfs_agfl_size(mp) - 1);
> +		agf->agf_fllast = cpu_to_be32(xfs_agfl_size(mp) - 1);
>  		agf->agf_flcount = 0;
>  	}
>  
>  	libxfs_buf_mark_dirty(agfl_buf);
> -	libxfs_buf_relse(agfl_buf);
> +	xfs_buf_relse(agfl_buf);
>  
>  	ext_ptr = findbiggest_bcnt_extent(agno);
>  	agf->agf_longest = cpu_to_be32((ext_ptr != NULL) ?
> @@ -2230,7 +2230,7 @@ _("Insufficient memory saving lost blocks.\n"));
>  		be32_to_cpu(agf->agf_roots[XFS_BTNUM_CNTi]));
>  
>  	libxfs_buf_mark_dirty(agf_buf);
> -	libxfs_buf_relse(agf_buf);
> +	xfs_buf_relse(agf_buf);
>  
>  	/*
>  	 * now fix up the free list appropriately
> @@ -2263,9 +2263,9 @@ sync_sb(xfs_mount_t *mp)
>  
>  	update_sb_version(mp);
>  
> -	libxfs_sb_to_disk(bp->b_addr, &mp->m_sb);
> +	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
>  	libxfs_buf_mark_dirty(bp);
> -	libxfs_buf_relse(bp);
> +	xfs_buf_relse(bp);
>  }
>  
>  /*
> @@ -2408,8 +2408,8 @@ phase5_func(
>  		/*
>  		 * see if we can fit all the extra blocks into the AGFL
>  		 */
> -		extra_blocks = (extra_blocks - libxfs_agfl_size(mp) > 0)
> -				? extra_blocks - libxfs_agfl_size(mp)
> +		extra_blocks = (extra_blocks - xfs_agfl_size(mp) > 0)
> +				? extra_blocks - xfs_agfl_size(mp)
>  				: 0;
>  
>  		if (extra_blocks > 0)
> @@ -2527,16 +2527,16 @@ inject_lost_blocks(
>  		return error;
>  
>  	while ((fsb = pop_slab_cursor(cur)) != NULL) {
> -		error = -libxfs_trans_alloc_rollable(mp, 16, &tp);
> +		error = -xfs_trans_alloc_rollable(mp, 16, &tp);
>  		if (error)
>  			goto out_cancel;
>  
> -		error = -libxfs_free_extent(tp, *fsb, 1, &XFS_RMAP_OINFO_AG,
> +		error = -xfs_free_extent(tp, *fsb, 1, &XFS_RMAP_OINFO_AG,
>  					    XFS_AG_RESV_NONE);
>  		if (error)
>  			goto out_cancel;
>  
> -		error = -libxfs_trans_commit(tp);
> +		error = -xfs_trans_commit(tp);
>  		if (error)
>  			goto out_cancel;
>  		tp = NULL;
> @@ -2544,7 +2544,7 @@ inject_lost_blocks(
>  
>  out_cancel:
>  	if (tp)
> -		libxfs_trans_cancel(tp);
> +		xfs_trans_cancel(tp);
>  	free_slab_cursor(&cur);
>  	return error;
>  }
> @@ -2561,21 +2561,21 @@ phase5(xfs_mount_t *mp)
>  
>  #ifdef XR_BLD_FREE_TRACE
>  	fprintf(stderr, "inobt level 1, maxrec = %d, minrec = %d\n",
> -		libxfs_inobt_maxrecs(mp, mp->m_sb.sb_blocksize, 0),
> -		libxfs_inobt_maxrecs(mp, mp->m_sb.sb_blocksize, 0) / 2);
> +		xfs_inobt_maxrecs(mp, mp->m_sb.sb_blocksize, 0),
> +		xfs_inobt_maxrecs(mp, mp->m_sb.sb_blocksize, 0) / 2);
>  	fprintf(stderr, "inobt level 0 (leaf), maxrec = %d, minrec = %d\n",
> -		libxfs_inobt_maxrecs(mp, mp->m_sb.sb_blocksize, 1),
> -		libxfs_inobt_maxrecs(mp, mp->m_sb.sb_blocksize, 1) / 2);
> +		xfs_inobt_maxrecs(mp, mp->m_sb.sb_blocksize, 1),
> +		xfs_inobt_maxrecs(mp, mp->m_sb.sb_blocksize, 1) / 2);
>  	fprintf(stderr, "xr inobt level 0 (leaf), maxrec = %d\n",
>  		XR_INOBT_BLOCK_MAXRECS(mp, 0));
>  	fprintf(stderr, "xr inobt level 1 (int), maxrec = %d\n",
>  		XR_INOBT_BLOCK_MAXRECS(mp, 1));
>  	fprintf(stderr, "bnobt level 1, maxrec = %d, minrec = %d\n",
> -		libxfs_allocbt_maxrecs(mp, mp->m_sb.sb_blocksize, 0),
> -		libxfs_allocbt_maxrecs(mp, mp->m_sb.sb_blocksize, 0) / 2);
> +		xfs_allocbt_maxrecs(mp, mp->m_sb.sb_blocksize, 0),
> +		xfs_allocbt_maxrecs(mp, mp->m_sb.sb_blocksize, 0) / 2);
>  	fprintf(stderr, "bnobt level 0 (leaf), maxrec = %d, minrec = %d\n",
> -		libxfs_allocbt_maxrecs(mp, mp->m_sb.sb_blocksize, 1),
> -		libxfs_allocbt_maxrecs(mp, mp->m_sb.sb_blocksize, 1) / 2);
> +		xfs_allocbt_maxrecs(mp, mp->m_sb.sb_blocksize, 1),
> +		xfs_allocbt_maxrecs(mp, mp->m_sb.sb_blocksize, 1) / 2);
>  #endif
>  	/*
>  	 * make sure the root and realtime inodes show up allocated
> diff --git a/repair/phase6.c b/repair/phase6.c
> index 5e3b394a..56424c08 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -56,18 +56,18 @@ phase6_verify_dir(
>  	 */
>  	if (size > offsetof(struct xfs_dir2_sf_hdr, parent) &&
>  	    size >= xfs_dir2_sf_hdr_size(sfp->i8count)) {
> -		old_parent = libxfs_dir2_sf_get_parent_ino(sfp);
> +		old_parent = xfs_dir2_sf_get_parent_ino(sfp);
>  		if (old_parent == 0) {
> -			libxfs_dir2_sf_put_parent_ino(sfp, mp->m_sb.sb_rootino);
> +			xfs_dir2_sf_put_parent_ino(sfp, mp->m_sb.sb_rootino);
>  			parent_bypass = true;
>  		}
>  	}
>  
> -	fa = libxfs_default_ifork_ops.verify_dir(ip);
> +	fa = xfs_default_ifork_ops.verify_dir(ip);
>  
>  	/* Put it back. */
>  	if (parent_bypass)
> -		libxfs_dir2_sf_put_parent_ino(sfp, old_parent);
> +		xfs_dir2_sf_put_parent_ino(sfp, old_parent);
>  
>  	return fa;
>  }
> @@ -186,12 +186,12 @@ dir_read_buf(
>  	int error;
>  	int error2;
>  
> -	error = -libxfs_da_read_buf(NULL, ip, bno, 0, bpp, XFS_DATA_FORK, ops);
> +	error = -xfs_da_read_buf(NULL, ip, bno, 0, bpp, XFS_DATA_FORK, ops);
>  
>  	if (error != EFSBADCRC && error != EFSCORRUPTED)
>  		return error;
>  
> -	error2 = -libxfs_da_read_buf(NULL, ip, bno, 0, bpp, XFS_DATA_FORK,
> +	error2 = -xfs_da_read_buf(NULL, ip, bno, 0, bpp, XFS_DATA_FORK,
>  			NULL);
>  	if (error2)
>  		return error2;
> @@ -233,7 +233,7 @@ dir_hash_add(
>  	dup = 0;
>  
>  	if (!junk) {
> -		hash = libxfs_dir2_hashname(mp, &xname);
> +		hash = xfs_dir2_hashname(mp, &xname);
>  		byhash = DIR_HASH_FUNC(hashtab, hash);
>  
>  		/*
> @@ -487,10 +487,10 @@ bmap_next_offset(
>  	}
>  	ifp = XFS_IFORK_PTR(ip, whichfork);
>  	if (!(ifp->if_flags & XFS_IFEXTENTS) &&
> -	    (error = -libxfs_iread_extents(tp, ip, whichfork)))
> +	    (error = -xfs_iread_extents(tp, ip, whichfork)))
>  		return error;
>  	bno = *bnop + 1;
> -	if (!libxfs_iext_lookup_extent(ip, ifp, bno, &icur, &got))
> +	if (!xfs_iext_lookup_extent(ip, ifp, bno, &icur, &got))
>  		*bnop = NULLFILEOFF;
>  	else
>  		*bnop = got.br_startoff < bno ? bno : got.br_startoff;
> @@ -525,7 +525,7 @@ mk_rbmino(xfs_mount_t *mp)
>  	/*
>  	 * first set up inode
>  	 */
> -	i = -libxfs_trans_alloc_rollable(mp, 10, &tp);
> +	i = -xfs_trans_alloc_rollable(mp, 10, &tp);
>  	if (i)
>  		res_failed(i);
>  
> @@ -551,7 +551,7 @@ mk_rbmino(xfs_mount_t *mp)
>  		ip->i_d.di_flags2 = 0;
>  		times |= XFS_ICHGTIME_CREATE;
>  	}
> -	libxfs_trans_ichgtime(tp, ip, times);
> +	xfs_trans_ichgtime(tp, ip, times);
>  
>  	/*
>  	 * now the ifork
> @@ -565,9 +565,9 @@ mk_rbmino(xfs_mount_t *mp)
>  	/*
>  	 * commit changes
>  	 */
> -	libxfs_trans_ijoin(tp, ip, 0);
> -	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> -	error = -libxfs_trans_commit(tp);
> +	xfs_trans_ijoin(tp, ip, 0);
> +	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> +	error = -xfs_trans_commit(tp);
>  	if (error)
>  		do_error(_("%s: commit failed, error %d\n"), __func__, error);
>  
> @@ -577,15 +577,15 @@ mk_rbmino(xfs_mount_t *mp)
>  	 */
>  	blocks = mp->m_sb.sb_rbmblocks +
>  			XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1;
> -	error = -libxfs_trans_alloc_rollable(mp, blocks, &tp);
> +	error = -xfs_trans_alloc_rollable(mp, blocks, &tp);
>  	if (error)
>  		res_failed(error);
>  
> -	libxfs_trans_ijoin(tp, ip, 0);
> +	xfs_trans_ijoin(tp, ip, 0);
>  	bno = 0;
>  	while (bno < mp->m_sb.sb_rbmblocks) {
>  		nmap = XFS_BMAP_MAX_NMAP;
> -		error = -libxfs_bmapi_write(tp, ip, bno,
> +		error = -xfs_bmapi_write(tp, ip, bno,
>  			  (xfs_extlen_t)(mp->m_sb.sb_rbmblocks - bno),
>  			  0, mp->m_sb.sb_rbmblocks, map, &nmap);
>  		if (error) {
> @@ -600,7 +600,7 @@ mk_rbmino(xfs_mount_t *mp)
>  			bno += ep->br_blockcount;
>  		}
>  	}
> -	error = -libxfs_trans_commit(tp);
> +	error = -xfs_trans_commit(tp);
>  	if (error) {
>  		do_error(
>  		_("allocation of the realtime bitmap failed, error = %d\n"),
> @@ -624,7 +624,7 @@ fill_rbmino(xfs_mount_t *mp)
>  	bmp = btmcompute;
>  	bno = 0;
>  
> -	error = -libxfs_trans_alloc_rollable(mp, 10, &tp);
> +	error = -xfs_trans_alloc_rollable(mp, 10, &tp);
>  	if (error)
>  		res_failed(error);
>  
> @@ -641,7 +641,7 @@ fill_rbmino(xfs_mount_t *mp)
>  		 * fill the file one block at a time
>  		 */
>  		nmap = 1;
> -		error = -libxfs_bmapi_write(tp, ip, bno, 1, 0, 1, &map, &nmap);
> +		error = -xfs_bmapi_write(tp, ip, bno, 1, 0, 1, &map, &nmap);
>  		if (error || nmap != 1) {
>  			do_error(
>  	_("couldn't map realtime bitmap block %" PRIu64 ", error = %d\n"),
> @@ -650,7 +650,7 @@ fill_rbmino(xfs_mount_t *mp)
>  
>  		ASSERT(map.br_startblock != HOLESTARTBLOCK);
>  
> -		error = -libxfs_trans_read_buf(
> +		error = -xfs_trans_read_buf(
>  				mp, tp, mp->m_dev,
>  				XFS_FSB_TO_DADDR(mp, map.br_startblock),
>  				XFS_FSB_TO_BB(mp, 1), 1, &bp, NULL);
> @@ -664,14 +664,14 @@ _("can't access block %" PRIu64 " (fsbno %" PRIu64 ") of realtime bitmap inode %
>  
>  		memmove(bp->b_addr, bmp, mp->m_sb.sb_blocksize);
>  
> -		libxfs_trans_log_buf(tp, bp, 0, mp->m_sb.sb_blocksize - 1);
> +		xfs_trans_log_buf(tp, bp, 0, mp->m_sb.sb_blocksize - 1);
>  
>  		bmp = (xfs_rtword_t *)((intptr_t) bmp + mp->m_sb.sb_blocksize);
>  		bno++;
>  	}
>  
> -	libxfs_trans_ijoin(tp, ip, 0);
> -	error = -libxfs_trans_commit(tp);
> +	xfs_trans_ijoin(tp, ip, 0);
> +	error = -xfs_trans_commit(tp);
>  	if (error)
>  		do_error(_("%s: commit failed, error %d\n"), __func__, error);
>  	libxfs_irele(ip);
> @@ -695,7 +695,7 @@ fill_rsumino(xfs_mount_t *mp)
>  	bno = 0;
>  	end_bno = mp->m_rsumsize >> mp->m_sb.sb_blocklog;
>  
> -	error = -libxfs_trans_alloc_rollable(mp, 10, &tp);
> +	error = -xfs_trans_alloc_rollable(mp, 10, &tp);
>  	if (error)
>  		res_failed(error);
>  
> @@ -712,7 +712,7 @@ fill_rsumino(xfs_mount_t *mp)
>  		 * fill the file one block at a time
>  		 */
>  		nmap = 1;
> -		error = -libxfs_bmapi_write(tp, ip, bno, 1, 0, 1, &map, &nmap);
> +		error = -xfs_bmapi_write(tp, ip, bno, 1, 0, 1, &map, &nmap);
>  		if (error || nmap != 1) {
>  			do_error(
>  	_("couldn't map realtime summary inode block %" PRIu64 ", error = %d\n"),
> @@ -721,7 +721,7 @@ fill_rsumino(xfs_mount_t *mp)
>  
>  		ASSERT(map.br_startblock != HOLESTARTBLOCK);
>  
> -		error = -libxfs_trans_read_buf(
> +		error = -xfs_trans_read_buf(
>  				mp, tp, mp->m_dev,
>  				XFS_FSB_TO_DADDR(mp, map.br_startblock),
>  				XFS_FSB_TO_BB(mp, 1), 1, &bp, NULL);
> @@ -736,14 +736,14 @@ _("can't access block %" PRIu64 " (fsbno %" PRIu64 ") of realtime summary inode
>  
>  		memmove(bp->b_addr, smp, mp->m_sb.sb_blocksize);
>  
> -		libxfs_trans_log_buf(tp, bp, 0, mp->m_sb.sb_blocksize - 1);
> +		xfs_trans_log_buf(tp, bp, 0, mp->m_sb.sb_blocksize - 1);
>  
>  		smp = (xfs_suminfo_t *)((intptr_t)smp + mp->m_sb.sb_blocksize);
>  		bno++;
>  	}
>  
> -	libxfs_trans_ijoin(tp, ip, 0);
> -	error = -libxfs_trans_commit(tp);
> +	xfs_trans_ijoin(tp, ip, 0);
> +	error = -xfs_trans_commit(tp);
>  	if (error)
>  		do_error(_("%s: commit failed, error %d\n"), __func__, error);
>  	libxfs_irele(ip);
> @@ -768,7 +768,7 @@ mk_rsumino(xfs_mount_t *mp)
>  	/*
>  	 * first set up inode
>  	 */
> -	i = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 10, 0, 0, &tp);
> +	i = -xfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 10, 0, 0, &tp);
>  	if (i)
>  		res_failed(i);
>  
> @@ -794,7 +794,7 @@ mk_rsumino(xfs_mount_t *mp)
>  		ip->i_d.di_flags2 = 0;
>  		times |= XFS_ICHGTIME_CREATE;
>  	}
> -	libxfs_trans_ichgtime(tp, ip, times);
> +	xfs_trans_ichgtime(tp, ip, times);
>  
>  	/*
>  	 * now the ifork
> @@ -808,9 +808,9 @@ mk_rsumino(xfs_mount_t *mp)
>  	/*
>  	 * commit changes
>  	 */
> -	libxfs_trans_ijoin(tp, ip, 0);
> -	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> -	error = -libxfs_trans_commit(tp);
> +	xfs_trans_ijoin(tp, ip, 0);
> +	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> +	error = -xfs_trans_commit(tp);
>  	if (error)
>  		do_error(_("%s: commit failed, error %d\n"), __func__, error);
>  
> @@ -820,15 +820,15 @@ mk_rsumino(xfs_mount_t *mp)
>  	 */
>  	nsumblocks = mp->m_rsumsize >> mp->m_sb.sb_blocklog;
>  	blocks = nsumblocks + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1;
> -	error = -libxfs_trans_alloc_rollable(mp, blocks, &tp);
> +	error = -xfs_trans_alloc_rollable(mp, blocks, &tp);
>  	if (error)
>  		res_failed(error);
>  
> -	libxfs_trans_ijoin(tp, ip, 0);
> +	xfs_trans_ijoin(tp, ip, 0);
>  	bno = 0;
>  	while (bno < nsumblocks) {
>  		nmap = XFS_BMAP_MAX_NMAP;
> -		error = -libxfs_bmapi_write(tp, ip, bno,
> +		error = -xfs_bmapi_write(tp, ip, bno,
>  			  (xfs_extlen_t)(nsumblocks - bno),
>  			  0, nsumblocks, map, &nmap);
>  		if (error) {
> @@ -843,7 +843,7 @@ mk_rsumino(xfs_mount_t *mp)
>  			bno += ep->br_blockcount;
>  		}
>  	}
> -	error = -libxfs_trans_commit(tp);
> +	error = -xfs_trans_commit(tp);
>  	if (error) {
>  		do_error(
>  	_("allocation of the realtime summary ino failed, error = %d\n"),
> @@ -867,7 +867,7 @@ mk_root_dir(xfs_mount_t *mp)
>  	int		times;
>  
>  	ip = NULL;
> -	i = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 10, 0, 0, &tp);
> +	i = -xfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 10, 0, 0, &tp);
>  	if (i)
>  		res_failed(i);
>  
> @@ -894,9 +894,9 @@ mk_root_dir(xfs_mount_t *mp)
>  		ip->i_d.di_flags2 = 0;
>  		times |= XFS_ICHGTIME_CREATE;
>  	}
> -	libxfs_trans_ichgtime(tp, ip, times);
> -	libxfs_trans_ijoin(tp, ip, 0);
> -	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> +	xfs_trans_ichgtime(tp, ip, times);
> +	xfs_trans_ijoin(tp, ip, 0);
> +	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  
>  	/*
>  	 * now the ifork
> @@ -908,9 +908,9 @@ mk_root_dir(xfs_mount_t *mp)
>  	/*
>  	 * initialize the directory
>  	 */
> -	libxfs_dir_init(tp, ip, ip);
> +	xfs_dir_init(tp, ip, ip);
>  
> -	error = -libxfs_trans_commit(tp);
> +	error = -xfs_trans_commit(tp);
>  	if (error)
>  		do_error(_("%s: commit failed, error %d\n"), __func__, error);
>  
> @@ -956,14 +956,14 @@ mk_orphanage(xfs_mount_t *mp)
>  	xname.len = strlen(ORPHANAGE);
>  	xname.type = XFS_DIR3_FT_DIR;
>  
> -	if (libxfs_dir_lookup(NULL, pip, &xname, &ino, NULL) == 0)
> +	if (xfs_dir_lookup(NULL, pip, &xname, &ino, NULL) == 0)
>  		return ino;
>  
>  	/*
>  	 * could not be found, create it
>  	 */
>  	nres = XFS_MKDIR_SPACE_RES(mp, xname.len);
> -	i = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_mkdir, nres, 0, 0, &tp);
> +	i = -xfs_trans_alloc(mp, &M_RES(mp)->tr_mkdir, nres, 0, 0, &tp);
>  	if (i)
>  		res_failed(i);
>  
> @@ -977,7 +977,7 @@ mk_orphanage(xfs_mount_t *mp)
>  		do_error(_("%d - couldn't iget root inode to make %s\n"),
>  			i, ORPHANAGE);*/
>  
> -	error = -libxfs_inode_alloc(&tp, pip, mode|S_IFDIR,
> +	error = -xfs_inode_alloc(&tp, pip, mode|S_IFDIR,
>  					1, 0, &zerocr, &zerofsx, &ip);
>  	if (error) {
>  		do_error(_("%s inode allocation failed %d\n"),
> @@ -1019,12 +1019,12 @@ mk_orphanage(xfs_mount_t *mp)
>  	 * now that we know the transaction will stay around,
>  	 * add the root inode to it
>  	 */
> -	libxfs_trans_ijoin(tp, pip, 0);
> +	xfs_trans_ijoin(tp, pip, 0);
>  
>  	/*
>  	 * create the actual entry
>  	 */
> -	error = -libxfs_dir_createname(tp, pip, &xname, ip->i_ino, nres);
> +	error = -xfs_dir_createname(tp, pip, &xname, ip->i_ino, nres);
>  	if (error)
>  		do_error(
>  		_("can't make %s, createname error %d\n"),
> @@ -1041,10 +1041,10 @@ mk_orphanage(xfs_mount_t *mp)
>  	add_inode_ref(irec, 0);
>  	set_inode_disk_nlinks(irec, 0, get_inode_disk_nlinks(irec, 0) + 1);
>  
> -	libxfs_trans_log_inode(tp, pip, XFS_ILOG_CORE);
> -	libxfs_dir_init(tp, ip, pip);
> -	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> -	error = -libxfs_trans_commit(tp);
> +	xfs_trans_log_inode(tp, pip, XFS_ILOG_CORE);
> +	xfs_dir_init(tp, ip, pip);
> +	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> +	error = -xfs_trans_commit(tp);
>  	if (error) {
>  		do_error(_("%s directory creation failed -- bmapf error %d\n"),
>  			ORPHANAGE, error);
> @@ -1088,7 +1088,7 @@ mv_orphanage(
>  	 * Make sure the filename is unique in the lost+found
>  	 */
>  	incr = 0;
> -	while (libxfs_dir_lookup(NULL, orphanage_ip, &xname, &entry_ino_num,
> +	while (xfs_dir_lookup(NULL, orphanage_ip, &xname, &entry_ino_num,
>  								NULL) == 0)
>  		xname.len = snprintf((char *)fname, sizeof(fname), "%llu.%d",
>  					(unsigned long long)ino, ++incr);
> @@ -1098,7 +1098,7 @@ mv_orphanage(
>  	if (err)
>  		do_error(_("%d - couldn't iget disconnected inode\n"), err);
>  
> -	xname.type = libxfs_mode_to_ftype(VFS_I(ino_p)->i_mode);
> +	xname.type = xfs_mode_to_ftype(VFS_I(ino_p)->i_mode);
>  
>  	if (isa_dir)  {
>  		irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, orphanage_ino),
> @@ -1108,22 +1108,22 @@ mv_orphanage(
>  					irec->ino_startnum;
>  		nres = XFS_DIRENTER_SPACE_RES(mp, fnamelen) +
>  		       XFS_DIRENTER_SPACE_RES(mp, 2);
> -		err = -libxfs_dir_lookup(NULL, ino_p, &xfs_name_dotdot,
> +		err = -xfs_dir_lookup(NULL, ino_p, &xfs_name_dotdot,
>  					&entry_ino_num, NULL);
>  		if (err) {
>  			ASSERT(err == ENOENT);
>  
> -			err = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_rename,
> +			err = -xfs_trans_alloc(mp, &M_RES(mp)->tr_rename,
>  						  nres, 0, 0, &tp);
>  			if (err)
>  				do_error(
>  	_("space reservation failed (%d), filesystem may be out of space\n"),
>  					err);
>  
> -			libxfs_trans_ijoin(tp, orphanage_ip, 0);
> -			libxfs_trans_ijoin(tp, ino_p, 0);
> +			xfs_trans_ijoin(tp, orphanage_ip, 0);
> +			xfs_trans_ijoin(tp, ino_p, 0);
>  
> -			err = -libxfs_dir_createname(tp, orphanage_ip, &xname,
> +			err = -xfs_dir_createname(tp, orphanage_ip, &xname,
>  						ino, nres);
>  			if (err)
>  				do_error(
> @@ -1134,9 +1134,9 @@ mv_orphanage(
>  				add_inode_ref(irec, ino_offset);
>  			else
>  				inc_nlink(VFS_I(orphanage_ip));
> -			libxfs_trans_log_inode(tp, orphanage_ip, XFS_ILOG_CORE);
> +			xfs_trans_log_inode(tp, orphanage_ip, XFS_ILOG_CORE);
>  
> -			err = -libxfs_dir_createname(tp, ino_p, &xfs_name_dotdot,
> +			err = -xfs_dir_createname(tp, ino_p, &xfs_name_dotdot,
>  					orphanage_ino, nres);
>  			if (err)
>  				do_error(
> @@ -1144,24 +1144,24 @@ mv_orphanage(
>  					err);
>  
>  			inc_nlink(VFS_I(ino_p));
> -			libxfs_trans_log_inode(tp, ino_p, XFS_ILOG_CORE);
> -			err = -libxfs_trans_commit(tp);
> +			xfs_trans_log_inode(tp, ino_p, XFS_ILOG_CORE);
> +			err = -xfs_trans_commit(tp);
>  			if (err)
>  				do_error(
>  	_("creation of .. entry failed (%d)\n"), err);
>  		} else  {
> -			err = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_rename,
> +			err = -xfs_trans_alloc(mp, &M_RES(mp)->tr_rename,
>  						  nres, 0, 0, &tp);
>  			if (err)
>  				do_error(
>  	_("space reservation failed (%d), filesystem may be out of space\n"),
>  					err);
>  
> -			libxfs_trans_ijoin(tp, orphanage_ip, 0);
> -			libxfs_trans_ijoin(tp, ino_p, 0);
> +			xfs_trans_ijoin(tp, orphanage_ip, 0);
> +			xfs_trans_ijoin(tp, ino_p, 0);
>  
>  
> -			err = -libxfs_dir_createname(tp, orphanage_ip, &xname,
> +			err = -xfs_dir_createname(tp, orphanage_ip, &xname,
>  						ino, nres);
>  			if (err)
>  				do_error(
> @@ -1172,14 +1172,14 @@ mv_orphanage(
>  				add_inode_ref(irec, ino_offset);
>  			else
>  				inc_nlink(VFS_I(orphanage_ip));
> -			libxfs_trans_log_inode(tp, orphanage_ip, XFS_ILOG_CORE);
> +			xfs_trans_log_inode(tp, orphanage_ip, XFS_ILOG_CORE);
>  
>  			/*
>  			 * don't replace .. value if it already points
>  			 * to us.  that'll pop a libxfs/kernel ASSERT.
>  			 */
>  			if (entry_ino_num != orphanage_ino)  {
> -				err = -libxfs_dir_replace(tp, ino_p,
> +				err = -xfs_dir_replace(tp, ino_p,
>  						&xfs_name_dotdot, orphanage_ino,
>  						nres);
>  				if (err)
> @@ -1188,7 +1188,7 @@ mv_orphanage(
>  						err);
>  			}
>  
> -			err = -libxfs_trans_commit(tp);
> +			err = -xfs_trans_commit(tp);
>  			if (err)
>  				do_error(
>  	_("orphanage name replace op failed (%d)\n"), err);
> @@ -1202,17 +1202,17 @@ mv_orphanage(
>  		 * also accounted for in the create
>  		 */
>  		nres = XFS_DIRENTER_SPACE_RES(mp, xname.len);
> -		err = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_remove,
> +		err = -xfs_trans_alloc(mp, &M_RES(mp)->tr_remove,
>  					  nres, 0, 0, &tp);
>  		if (err)
>  			do_error(
>  	_("space reservation failed (%d), filesystem may be out of space\n"),
>  				err);
>  
> -		libxfs_trans_ijoin(tp, orphanage_ip, 0);
> -		libxfs_trans_ijoin(tp, ino_p, 0);
> +		xfs_trans_ijoin(tp, orphanage_ip, 0);
> +		xfs_trans_ijoin(tp, ino_p, 0);
>  
> -		err = -libxfs_dir_createname(tp, orphanage_ip, &xname, ino,
> +		err = -xfs_dir_createname(tp, orphanage_ip, &xname, ino,
>  						nres);
>  		if (err)
>  			do_error(
> @@ -1221,8 +1221,8 @@ mv_orphanage(
>  		ASSERT(err == 0);
>  
>  		set_nlink(VFS_I(ino_p), 1);
> -		libxfs_trans_log_inode(tp, ino_p, XFS_ILOG_CORE);
> -		err = -libxfs_trans_commit(tp);
> +		xfs_trans_log_inode(tp, ino_p, XFS_ILOG_CORE);
> +		err = -xfs_trans_commit(tp);
>  		if (err)
>  			do_error(
>  	_("orphanage name create failed (%d)\n"), err);
> @@ -1275,14 +1275,14 @@ dir_binval(
>  		     dabno < rec.br_startoff + rec.br_blockcount;
>  		     dabno += geo->fsbcount) {
>  			bp = NULL;
> -			error = -libxfs_da_get_buf(tp, ip, dabno, &bp,
> +			error = -xfs_da_get_buf(tp, ip, dabno, &bp,
>  					whichfork);
>  			if (error)
>  				return error;
>  			if (!bp)
>  				continue;
> -			libxfs_trans_binval(tp, bp);
> -			libxfs_trans_brelse(tp, bp);
> +			xfs_trans_binval(tp, bp);
> +			xfs_trans_brelse(tp, bp);
>  		}
>  	}
>  
> @@ -1322,37 +1322,37 @@ longform_dir2_rebuild(
>  	 * first attempt to locate the parent inode, if it can't be
>  	 * found, set it to the root inode and it'll be moved to the
>  	 * orphanage later (the inode number here needs to be valid
> -	 * for the libxfs_dir_init() call).
> +	 * for the xfs_dir_init() call).
>  	 */
>  	pip.i_ino = get_inode_parent(irec, ino_offset);
>  	if (pip.i_ino == NULLFSINO ||
> -	    libxfs_dir_ino_validate(mp, pip.i_ino))
> +	    xfs_dir_ino_validate(mp, pip.i_ino))
>  		pip.i_ino = mp->m_sb.sb_rootino;
>  
>  	nres = XFS_REMOVE_SPACE_RES(mp);
> -	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_remove, nres, 0, 0, &tp);
> +	error = -xfs_trans_alloc(mp, &M_RES(mp)->tr_remove, nres, 0, 0, &tp);
>  	if (error)
>  		res_failed(error);
> -	libxfs_trans_ijoin(tp, ip, 0);
> +	xfs_trans_ijoin(tp, ip, 0);
>  
>  	error = dir_binval(tp, ip, XFS_DATA_FORK);
>  	if (error)
>  		do_error(_("error %d invalidating directory %llu blocks\n"),
>  				error, (unsigned long long)ip->i_ino);
>  
> -	if ((error = -libxfs_bmap_last_offset(ip, &lastblock, XFS_DATA_FORK)))
> +	if ((error = -xfs_bmap_last_offset(ip, &lastblock, XFS_DATA_FORK)))
>  		do_error(_("xfs_bmap_last_offset failed -- error - %d\n"),
>  			error);
>  
>  	/* free all data, leaf, node and freespace blocks */
>  	while (!done) {
> -	       error = -libxfs_bunmapi(tp, ip, 0, lastblock, XFS_BMAPI_METADATA,
> +	       error = -xfs_bunmapi(tp, ip, 0, lastblock, XFS_BMAPI_METADATA,
>  			               0, &done);
>  	       if (error) {
>  		       do_warn(_("xfs_bunmapi failed -- error - %d\n"), error);
>  		       goto out_bmap_cancel;
>  	       }
> -	       error = -libxfs_defer_finish(&tp);
> +	       error = -xfs_defer_finish(&tp);
>  	       if (error) {
>  		       do_warn(("defer_finish failed -- error - %d\n"), error);
>  		       goto out_bmap_cancel;
> @@ -1360,18 +1360,18 @@ longform_dir2_rebuild(
>  	       /*
>  		* Close out trans and start the next one in the chain.
>  		*/
> -	       error = -libxfs_trans_roll_inode(&tp, ip);
> +	       error = -xfs_trans_roll_inode(&tp, ip);
>  	       if (error)
>  			goto out_bmap_cancel;
>          }
>  
> -	error = -libxfs_dir_init(tp, ip, &pip);
> +	error = -xfs_dir_init(tp, ip, &pip);
>  	if (error) {
>  		do_warn(_("xfs_dir_init failed -- error - %d\n"), error);
>  		goto out_bmap_cancel;
>  	}
>  
> -	error = -libxfs_trans_commit(tp);
> +	error = -xfs_trans_commit(tp);
>  	if (error)
>  		do_error(
>  	_("dir init failed (%d)\n"), error);
> @@ -1389,14 +1389,14 @@ longform_dir2_rebuild(
>  			continue;
>  
>  		nres = XFS_CREATE_SPACE_RES(mp, p->name.len);
> -		error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_create,
> +		error = -xfs_trans_alloc(mp, &M_RES(mp)->tr_create,
>  					    nres, 0, 0, &tp);
>  		if (error)
>  			res_failed(error);
>  
> -		libxfs_trans_ijoin(tp, ip, 0);
> +		xfs_trans_ijoin(tp, ip, 0);
>  
> -		error = -libxfs_dir_createname(tp, ip, &p->name, p->inum,
> +		error = -xfs_dir_createname(tp, ip, &p->name, p->inum,
>  						nres);
>  		if (error) {
>  			do_warn(
> @@ -1405,7 +1405,7 @@ _("name create failed in ino %" PRIu64 " (%d), filesystem may be out of space\n"
>  			goto out_bmap_cancel;
>  		}
>  
> -		error = -libxfs_trans_commit(tp);
> +		error = -xfs_trans_commit(tp);
>  		if (error)
>  			do_error(
>  _("name create failed (%d) during rebuild\n"), error);
> @@ -1414,7 +1414,7 @@ _("name create failed (%d) during rebuild\n"), error);
>  	return;
>  
>  out_bmap_cancel:
> -	libxfs_trans_cancel(tp);
> +	xfs_trans_cancel(tp);
>  	return;
>  }
>  
> @@ -1436,25 +1436,25 @@ dir2_kill_block(
>  	xfs_trans_t	*tp;
>  
>  	nres = XFS_REMOVE_SPACE_RES(mp);
> -	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_remove, nres, 0, 0, &tp);
> +	error = -xfs_trans_alloc(mp, &M_RES(mp)->tr_remove, nres, 0, 0, &tp);
>  	if (error)
>  		res_failed(error);
> -	libxfs_trans_ijoin(tp, ip, 0);
> -	libxfs_trans_bjoin(tp, bp);
> +	xfs_trans_ijoin(tp, ip, 0);
> +	xfs_trans_bjoin(tp, bp);
>  	memset(&args, 0, sizeof(args));
>  	args.dp = ip;
>  	args.trans = tp;
>  	args.whichfork = XFS_DATA_FORK;
>  	args.geo = mp->m_dir_geo;
>  	if (da_bno >= mp->m_dir_geo->leafblk && da_bno < mp->m_dir_geo->freeblk)
> -		error = -libxfs_da_shrink_inode(&args, da_bno, bp);
> +		error = -xfs_da_shrink_inode(&args, da_bno, bp);
>  	else
> -		error = -libxfs_dir2_shrink_inode(&args,
> +		error = -xfs_dir2_shrink_inode(&args,
>  				xfs_dir2_da_to_db(mp->m_dir_geo, da_bno), bp);
>  	if (error)
>  		do_error(_("shrink_inode failed inode %" PRIu64 " block %u\n"),
>  			ip->i_ino, da_bno);
> -	error = -libxfs_trans_commit(tp);
> +	error = -xfs_trans_commit(tp);
>  	if (error)
>  		do_error(
>  _("directory shrink failed (%d)\n"), error);
> @@ -1588,12 +1588,12 @@ longform_dir2_entry_check_data(
>  
>  		/* validate data entry size */
>  		dep = (xfs_dir2_data_entry_t *)ptr;
> -		if (ptr + libxfs_dir2_data_entsize(mp, dep->namelen) > endptr)
> +		if (ptr + xfs_dir2_data_entsize(mp, dep->namelen) > endptr)
>  			break;
> -		if (be16_to_cpu(*libxfs_dir2_data_entry_tag_p(mp, dep)) !=
> +		if (be16_to_cpu(*xfs_dir2_data_entry_tag_p(mp, dep)) !=
>  						(char *)dep - (char *)d)
>  			break;
> -		ptr += libxfs_dir2_data_entsize(mp, dep->namelen);
> +		ptr += xfs_dir2_data_entsize(mp, dep->namelen);
>  	}
>  
>  	/* did we find an empty or corrupt block? */
> @@ -1612,7 +1612,7 @@ longform_dir2_entry_check_data(
>  			dir2_kill_block(mp, ip, da_bno, bp);
>  		} else {
>  			do_warn(_("would junk block\n"));
> -			libxfs_buf_relse(bp);
> +			xfs_buf_relse(bp);
>  		}
>  		freetab->ents[db].v = NULLDATAOFF;
>  		*bpp = NULL;
> @@ -1623,13 +1623,13 @@ longform_dir2_entry_check_data(
>  	if (freetab->nents < db + 1)
>  		freetab->nents = db + 1;
>  
> -	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_remove, 0, 0, 0, &tp);
> +	error = -xfs_trans_alloc(mp, &M_RES(mp)->tr_remove, 0, 0, 0, &tp);
>  	if (error)
>  		res_failed(error);
>  	da.trans = tp;
> -	libxfs_trans_ijoin(tp, ip, 0);
> -	libxfs_trans_bjoin(tp, bp);
> -	libxfs_trans_bhold(tp, bp);
> +	xfs_trans_ijoin(tp, ip, 0);
> +	xfs_trans_bjoin(tp, bp);
> +	xfs_trans_bhold(tp, bp);
>  	if (be32_to_cpu(d->magic) != wantmagic) {
>  		do_warn(
>  	_("bad directory block magic # %#x for directory inode %" PRIu64 " block %d: "),
> @@ -1666,10 +1666,10 @@ longform_dir2_entry_check_data(
>  
>  					do_warn(_("joining together\n"));
>  					len = be16_to_cpu(dup->length);
> -					libxfs_dir2_data_use_free(&da, bp, dup,
> +					xfs_dir2_data_use_free(&da, bp, dup,
>  						ptr - (char *)d, len, &needlog,
>  						&needscan);
> -					libxfs_dir2_data_make_free(&da, bp,
> +					xfs_dir2_data_make_free(&da, bp,
>  						ptr - (char *)d, len, &needlog,
>  						&needscan);
>  				} else
> @@ -1682,7 +1682,7 @@ longform_dir2_entry_check_data(
>  		addr = xfs_dir2_db_off_to_dataptr(mp->m_dir_geo, db,
>  						  ptr - (char *)d);
>  		dep = (xfs_dir2_data_entry_t *)ptr;
> -		ptr += libxfs_dir2_data_entsize(mp, dep->namelen);
> +		ptr += xfs_dir2_data_entsize(mp, dep->namelen);
>  		inum = be64_to_cpu(dep->inumber);
>  		lastfree = 0;
>  		/*
> @@ -1693,7 +1693,7 @@ longform_dir2_entry_check_data(
>  		if (dep->name[0] == '/')  {
>  			nbad++;
>  			if (!no_modify)
> -				libxfs_dir2_data_log_entry(&da, bp, dep);
> +				xfs_dir2_data_log_entry(&da, bp, dep);
>  			continue;
>  		}
>  
> @@ -1709,7 +1709,7 @@ longform_dir2_entry_check_data(
>  	_("entry \"%s\" in directory inode %" PRIu64 " points to non-existent inode %" PRIu64 ""),
>  					fname, ip->i_ino, inum)) {
>  				dep->name[0] = '/';
> -				libxfs_dir2_data_log_entry(&da, bp, dep);
> +				xfs_dir2_data_log_entry(&da, bp, dep);
>  			}
>  			continue;
>  		}
> @@ -1726,7 +1726,7 @@ longform_dir2_entry_check_data(
>  	_("entry \"%s\" in directory inode %" PRIu64 " points to free inode %" PRIu64),
>  					fname, ip->i_ino, inum)) {
>  				dep->name[0] = '/';
> -				libxfs_dir2_data_log_entry(&da, bp, dep);
> +				xfs_dir2_data_log_entry(&da, bp, dep);
>  			}
>  			continue;
>  		}
> @@ -1744,7 +1744,7 @@ longform_dir2_entry_check_data(
>  	_("%s (ino %" PRIu64 ") in root (%" PRIu64 ") is not a directory"),
>  						ORPHANAGE, inum, ip->i_ino)) {
>  					dep->name[0] = '/';
> -					libxfs_dir2_data_log_entry(&da, bp, dep);
> +					xfs_dir2_data_log_entry(&da, bp, dep);
>  				}
>  				continue;
>  			}
> @@ -1760,13 +1760,13 @@ longform_dir2_entry_check_data(
>  		 * check for duplicate names in directory.
>  		 */
>  		if (!dir_hash_add(mp, hashtab, addr, inum, dep->namelen,
> -				dep->name, libxfs_dir2_data_get_ftype(mp, dep))) {
> +				dep->name, xfs_dir2_data_get_ftype(mp, dep))) {
>  			nbad++;
>  			if (entry_junked(
>  	_("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name"),
>  					fname, inum, ip->i_ino)) {
>  				dep->name[0] = '/';
> -				libxfs_dir2_data_log_entry(&da, bp, dep);
> +				xfs_dir2_data_log_entry(&da, bp, dep);
>  			}
>  			if (inum == orphanage_ino)
>  				orphanage_ino = 0;
> @@ -1797,12 +1797,12 @@ longform_dir2_entry_check_data(
>  	_("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is not in the the first block"), fname,
>  						inum, ip->i_ino)) {
>  					dep->name[0] = '/';
> -					libxfs_dir2_data_log_entry(&da, bp, dep);
> +					xfs_dir2_data_log_entry(&da, bp, dep);
>  				}
>  			}
>  			continue;
>  		}
> -		ASSERT(no_modify || libxfs_verify_dir_ino(mp, inum));
> +		ASSERT(no_modify || xfs_verify_dir_ino(mp, inum));
>  		/*
>  		 * special case the . entry.  we know there's only one
>  		 * '.' and only '.' points to itself because bogus entries
> @@ -1824,7 +1824,7 @@ longform_dir2_entry_check_data(
>  	_("entry \"%s\" in dir %" PRIu64 " is not the first entry"),
>  						fname, inum, ip->i_ino)) {
>  					dep->name[0] = '/';
> -					libxfs_dir2_data_log_entry(&da, bp, dep);
> +					xfs_dir2_data_log_entry(&da, bp, dep);
>  				}
>  			}
>  			*need_dot = 0;
> @@ -1833,7 +1833,7 @@ longform_dir2_entry_check_data(
>  		/*
>  		 * skip entries with bogus inumbers if we're in no modify mode
>  		 */
> -		if (no_modify && !libxfs_verify_dir_ino(mp, inum))
> +		if (no_modify && !xfs_verify_dir_ino(mp, inum))
>  			continue;
>  
>  		/* validate ftype field if supported */
> @@ -1841,7 +1841,7 @@ longform_dir2_entry_check_data(
>  			uint8_t dir_ftype;
>  			uint8_t ino_ftype;
>  
> -			dir_ftype = libxfs_dir2_data_get_ftype(mp, dep);
> +			dir_ftype = xfs_dir2_data_get_ftype(mp, dep);
>  			ino_ftype = get_inode_ftype(irec, ino_offset);
>  
>  			if (dir_ftype != ino_ftype) {
> @@ -1855,8 +1855,8 @@ longform_dir2_entry_check_data(
>  	_("fixing ftype mismatch (%d/%d) in directory/child inode %" PRIu64 "/%" PRIu64 "\n"),
>  						dir_ftype, ino_ftype,
>  						ip->i_ino, inum);
> -					libxfs_dir2_data_put_ftype(mp, dep, ino_ftype);
> -					libxfs_dir2_data_log_entry(&da, bp, dep);
> +					xfs_dir2_data_put_ftype(mp, dep, ino_ftype);
> +					xfs_dir2_data_log_entry(&da, bp, dep);
>  					dir_hash_update_ftype(hashtab, addr,
>  							      ino_ftype);
>  				}
> @@ -1912,7 +1912,7 @@ _("entry \"%s\" in dir inode %" PRIu64 " inconsistent with .. value (%" PRIu64 "
>  			nbad++;
>  			if (!no_modify)  {
>  				dep->name[0] = '/';
> -				libxfs_dir2_data_log_entry(&da, bp, dep);
> +				xfs_dir2_data_log_entry(&da, bp, dep);
>  				if (verbose)
>  					do_warn(
>  					_("\twill clear entry \"%s\"\n"),
> @@ -1925,16 +1925,16 @@ _("entry \"%s\" in dir inode %" PRIu64 " inconsistent with .. value (%" PRIu64 "
>  	}
>  	*num_illegal += nbad;
>  	if (needscan)
> -		libxfs_dir2_data_freescan(mp, d, &i);
> +		xfs_dir2_data_freescan(mp, d, &i);
>  	if (needlog)
> -		libxfs_dir2_data_log_header(&da, bp);
> -	error = -libxfs_trans_commit(tp);
> +		xfs_dir2_data_log_header(&da, bp);
> +	error = -xfs_trans_commit(tp);
>  	if (error)
>  		do_error(
>  _("directory block fixing failed (%d)\n"), error);
>  
>  	/* record the largest free space in the freetab for later checking */
> -	bf = libxfs_dir2_data_bestfree_p(mp, d);
> +	bf = xfs_dir2_data_bestfree_p(mp, d);
>  	freetab->ents[db].v = be16_to_cpu(bf[0].length);
>  	freetab->ents[db].s = 0;
>  }
> @@ -2037,7 +2037,7 @@ longform_dir2_check_leaf(
>  	}
>  
>  	leaf = bp->b_addr;
> -	libxfs_dir2_leaf_hdr_from_disk(mp, &leafhdr, leaf);
> +	xfs_dir2_leaf_hdr_from_disk(mp, &leafhdr, leaf);
>  	ents = leafhdr.ents;
>  	ltp = xfs_dir2_leaf_tail_p(mp->m_dir_geo, leaf);
>  	bestsp = xfs_dir2_leaf_bests_p(ltp);
> @@ -2050,21 +2050,21 @@ longform_dir2_check_leaf(
>  		do_warn(
>  	_("leaf block %u for directory inode %" PRIu64 " bad header\n"),
>  			da_bno, ip->i_ino);
> -		libxfs_buf_relse(bp);
> +		xfs_buf_relse(bp);
>  		return 1;
>  	}
>  
>  	if (leafhdr.magic == XFS_DIR3_LEAF1_MAGIC) {
>  		error = check_da3_header(mp, bp, ip->i_ino);
>  		if (error) {
> -			libxfs_buf_relse(bp);
> +			xfs_buf_relse(bp);
>  			return error;
>  		}
>  	}
>  
>  	seeval = dir_hash_see_all(hashtab, ents, leafhdr.count, leafhdr.stale);
>  	if (dir_hash_check(hashtab, ip, seeval)) {
> -		libxfs_buf_relse(bp);
> +		xfs_buf_relse(bp);
>  		return 1;
>  	}
>  	badtail = freetab->nents != be32_to_cpu(ltp->bestcount);
> @@ -2076,10 +2076,10 @@ longform_dir2_check_leaf(
>  		do_warn(
>  	_("leaf block %u for directory inode %" PRIu64 " bad tail\n"),
>  			da_bno, ip->i_ino);
> -		libxfs_buf_relse(bp);
> +		xfs_buf_relse(bp);
>  		return 1;
>  	}
> -	libxfs_buf_relse(bp);
> +	xfs_buf_relse(bp);
>  	return fixit;
>  }
>  
> @@ -2133,7 +2133,7 @@ longform_dir2_check_node(
>  			return 1;
>  		}
>  		leaf = bp->b_addr;
> -		libxfs_dir2_leaf_hdr_from_disk(mp, &leafhdr, leaf);
> +		xfs_dir2_leaf_hdr_from_disk(mp, &leafhdr, leaf);
>  		ents = leafhdr.ents;
>  		if (!(leafhdr.magic == XFS_DIR2_LEAFN_MAGIC ||
>  		      leafhdr.magic == XFS_DIR3_LEAFN_MAGIC ||
> @@ -2142,7 +2142,7 @@ longform_dir2_check_node(
>  			do_warn(
>  	_("unknown magic number %#x for block %u in directory inode %" PRIu64 "\n"),
>  				leafhdr.magic, da_bno, ip->i_ino);
> -			libxfs_buf_relse(bp);
> +			xfs_buf_relse(bp);
>  			return 1;
>  		}
>  
> @@ -2151,7 +2151,7 @@ longform_dir2_check_node(
>  		    leafhdr.magic == XFS_DA3_NODE_MAGIC) {
>  			error = check_da3_header(mp, bp, ip->i_ino);
>  			if (error) {
> -				libxfs_buf_relse(bp);
> +				xfs_buf_relse(bp);
>  				return error;
>  			}
>  		}
> @@ -2159,7 +2159,7 @@ longform_dir2_check_node(
>  		/* ignore nodes */
>  		if (leafhdr.magic == XFS_DA_NODE_MAGIC ||
>  		    leafhdr.magic == XFS_DA3_NODE_MAGIC) {
> -			libxfs_buf_relse(bp);
> +			xfs_buf_relse(bp);
>  			continue;
>  		}
>  
> @@ -2173,12 +2173,12 @@ longform_dir2_check_node(
>  			do_warn(
>  	_("leaf block %u for directory inode %" PRIu64 " bad header\n"),
>  				da_bno, ip->i_ino);
> -			libxfs_buf_relse(bp);
> +			xfs_buf_relse(bp);
>  			return 1;
>  		}
>  		seeval = dir_hash_see_all(hashtab, ents,
>  					leafhdr.count, leafhdr.stale);
> -		libxfs_buf_relse(bp);
> +		xfs_buf_relse(bp);
>  		if (seeval != DIR_HASH_CK_OK)
>  			return 1;
>  	}
> @@ -2201,7 +2201,7 @@ longform_dir2_check_node(
>  			return 1;
>  		}
>  		free = bp->b_addr;
> -		libxfs_dir2_free_hdr_from_disk(mp, &freehdr, free);
> +		xfs_dir2_free_hdr_from_disk(mp, &freehdr, free);
>  		bests = freehdr.bests;
>  		fdb = xfs_dir2_da_to_db(mp->m_dir_geo, da_bno);
>  		if (!(freehdr.magic == XFS_DIR2_FREE_MAGIC ||
> @@ -2213,14 +2213,14 @@ longform_dir2_check_node(
>  			do_warn(
>  	_("free block %u for directory inode %" PRIu64 " bad header\n"),
>  				da_bno, ip->i_ino);
> -			libxfs_buf_relse(bp);
> +			xfs_buf_relse(bp);
>  			return 1;
>  		}
>  
>  		if (freehdr.magic == XFS_DIR3_FREE_MAGIC) {
>  			error = check_dir3_header(mp, bp, ip->i_ino);
>  			if (error) {
> -				libxfs_buf_relse(bp);
> +				xfs_buf_relse(bp);
>  				return error;
>  			}
>  		}
> @@ -2231,7 +2231,7 @@ longform_dir2_check_node(
>  				do_warn(
>  	_("free block %u entry %i for directory ino %" PRIu64 " bad\n"),
>  					da_bno, i, ip->i_ino);
> -				libxfs_buf_relse(bp);
> +				xfs_buf_relse(bp);
>  				return 1;
>  			}
>  			used += be16_to_cpu(bests[i]) != NULLDATAOFF;
> @@ -2241,10 +2241,10 @@ longform_dir2_check_node(
>  			do_warn(
>  	_("free block %u for directory inode %" PRIu64 " bad nused\n"),
>  				da_bno, ip->i_ino);
> -			libxfs_buf_relse(bp);
> +			xfs_buf_relse(bp);
>  			return 1;
>  		}
> -		libxfs_buf_relse(bp);
> +		xfs_buf_relse(bp);
>  	}
>  	for (i = 0; i < freetab->nents; i++) {
>  		if ((freetab->ents[i].s == 0) &&
> @@ -2309,8 +2309,8 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
>  	/* is this a block, leaf, or node directory? */
>  	args.dp = ip;
>  	args.geo = mp->m_dir_geo;
> -	libxfs_dir2_isblock(&args, &isblock);
> -	libxfs_dir2_isleaf(&args, &isleaf);
> +	xfs_dir2_isblock(&args, &isblock);
> +	xfs_dir2_isleaf(&args, &isleaf);
>  
>  	/* check directory "data" blocks (ie. name/inode pairs) */
>  	for (da_bno = 0, next_da_bno = 0;
> @@ -2420,14 +2420,14 @@ out_fix:
>  		dir_hash_dup_names(hashtab);
>  		for (i = 0; i < num_bps; i++)
>  			if (bplist[i])
> -				libxfs_buf_relse(bplist[i]);
> +				xfs_buf_relse(bplist[i]);
>  		longform_dir2_rebuild(mp, ino, ip, irec, ino_offset, hashtab);
>  		*num_illegal = 0;
>  		*need_dot = 0;
>  	} else {
>  		for (i = 0; i < num_bps; i++)
>  			if (bplist[i])
> -				libxfs_buf_relse(bplist[i]);
> +				xfs_buf_relse(bplist[i]);
>  	}
>  
>  	free(bplist);
> @@ -2456,8 +2456,8 @@ shortform_dir2_junk(
>  	if (lino == orphanage_ino)
>  		orphanage_ino = 0;
>  
> -	next_elen = libxfs_dir2_sf_entsize(mp, sfp, sfep->namelen);
> -	next_sfep = libxfs_dir2_sf_nextentry(mp, sfp, sfep);
> +	next_elen = xfs_dir2_sf_entsize(mp, sfp, sfep->namelen);
> +	next_sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep);
>  
>  	/*
>  	 * if we are just checking, simply return the pointer to the next entry
> @@ -2540,7 +2540,7 @@ shortform_dir2_entry_check(xfs_mount_t	*mp,
>  			do_warn(
>  	_("setting .. in sf dir inode %" PRIu64 " to %" PRIu64 "\n"),
>  				ino, parent);
> -			libxfs_dir2_sf_put_parent_ino(sfp, parent);
> +			xfs_dir2_sf_put_parent_ino(sfp, parent);
>  			*ino_dirty = 1;
>  		}
>  		return;
> @@ -2557,7 +2557,7 @@ shortform_dir2_entry_check(xfs_mount_t	*mp,
>  	/*
>  	 * Initialise i8 counter -- the parent inode number counts as well.
>  	 */
> -	i8 = libxfs_dir2_sf_get_parent_ino(sfp) > XFS_DIR2_MAX_SHORT_INUM;
> +	i8 = xfs_dir2_sf_get_parent_ino(sfp) > XFS_DIR2_MAX_SHORT_INUM;
>  
>  	/*
>  	 * now run through entries, stop at first bad entry, don't need
> @@ -2571,7 +2571,7 @@ shortform_dir2_entry_check(xfs_mount_t	*mp,
>  			sfep = next_sfep, i++)  {
>  		bad_sfnamelen = 0;
>  
> -		lino = libxfs_dir2_sf_get_ino(mp, sfp, sfep);
> +		lino = xfs_dir2_sf_get_ino(mp, sfp, sfep);
>  
>  		namelen = sfep->namelen;
>  
> @@ -2600,7 +2600,7 @@ shortform_dir2_entry_check(xfs_mount_t	*mp,
>  				break;
>  			}
>  		} else if (no_modify && (intptr_t) sfep - (intptr_t) sfp +
> -				+ libxfs_dir2_sf_entsize(mp, sfp, sfep->namelen)
> +				+ xfs_dir2_sf_entsize(mp, sfp, sfep->namelen)
>  				> ip->i_d.di_size)  {
>  			bad_sfnamelen = 1;
>  
> @@ -2621,15 +2621,15 @@ shortform_dir2_entry_check(xfs_mount_t	*mp,
>  		fname[sfep->namelen] = '\0';
>  
>  		ASSERT(no_modify || (lino != NULLFSINO && lino != 0));
> -		ASSERT(no_modify || libxfs_verify_dir_ino(mp, lino));
> +		ASSERT(no_modify || xfs_verify_dir_ino(mp, lino));
>  
>  		/*
>  		 * Also skip entries with bogus inode numbers if we're
>  		 * in no modify mode.
>  		 */
>  
> -		if (no_modify && !libxfs_verify_dir_ino(mp, lino))  {
> -			next_sfep = libxfs_dir2_sf_nextentry(mp, sfp, sfep);
> +		if (no_modify && !xfs_verify_dir_ino(mp, lino))  {
> +			next_sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep);
>  			continue;
>  		}
>  
> @@ -2691,7 +2691,7 @@ shortform_dir2_entry_check(xfs_mount_t	*mp,
>  		if (!dir_hash_add(mp, hashtab, (xfs_dir2_dataptr_t)
>  				(sfep - xfs_dir2_sf_firstentry(sfp)),
>  				lino, sfep->namelen, sfep->name,
> -				libxfs_dir2_sf_get_ftype(mp, sfep))) {
> +				xfs_dir2_sf_get_ftype(mp, sfep))) {
>  			do_warn(
>  _("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name"),
>  				fname, lino, ino);
> @@ -2756,7 +2756,7 @@ _("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name"),
>  			uint8_t dir_ftype;
>  			uint8_t ino_ftype;
>  
> -			dir_ftype = libxfs_dir2_sf_get_ftype(mp, sfep);
> +			dir_ftype = xfs_dir2_sf_get_ftype(mp, sfep);
>  			ino_ftype = get_inode_ftype(irec, ino_offset);
>  
>  			if (dir_ftype != ino_ftype) {
> @@ -2770,7 +2770,7 @@ _("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name"),
>  	_("fixing ftype mismatch (%d/%d) in directory/child inode %" PRIu64 "/%" PRIu64 "\n"),
>  						dir_ftype, ino_ftype,
>  						ino, lino);
> -					libxfs_dir2_sf_put_ftype(mp, sfep,
> +					xfs_dir2_sf_put_ftype(mp, sfep,
>  								ino_ftype);
>  					dir_hash_update_ftype(hashtab,
>  			(xfs_dir2_dataptr_t)(sfep - xfs_dir2_sf_firstentry(sfp)),
> @@ -2791,8 +2791,8 @@ _("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name"),
>  		ASSERT(no_modify || bad_sfnamelen == 0);
>  		next_sfep = (struct xfs_dir2_sf_entry *)((intptr_t)sfep +
>  			      (bad_sfnamelen
> -				? libxfs_dir2_sf_entsize(mp, sfp, namelen)
> -				: libxfs_dir2_sf_entsize(mp, sfp, sfep->namelen)));
> +				? xfs_dir2_sf_entsize(mp, sfp, namelen)
> +				: xfs_dir2_sf_entsize(mp, sfp, sfep->namelen)));
>  	}
>  
>  	if (sfp->i8count != i8) {
> @@ -2822,7 +2822,7 @@ _("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name"),
>  	 */
>  	if (*ino_dirty && bytes_deleted > 0)  {
>  		ASSERT(!no_modify);
> -		libxfs_idata_realloc(ip, -bytes_deleted, XFS_DATA_FORK);
> +		xfs_idata_realloc(ip, -bytes_deleted, XFS_DATA_FORK);
>  		ip->i_d.di_size -= bytes_deleted;
>  	}
>  
> @@ -2935,12 +2935,12 @@ process_dir_inode(
>  			 * new define in ourselves.
>  			 */
>  			nres = no_modify ? 0 : XFS_REMOVE_SPACE_RES(mp);
> -			error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_remove,
> +			error = -xfs_trans_alloc(mp, &M_RES(mp)->tr_remove,
>  						    nres, 0, 0, &tp);
>  			if (error)
>  				res_failed(error);
>  
> -			libxfs_trans_ijoin(tp, ip, 0);
> +			xfs_trans_ijoin(tp, ip, 0);
>  
>  			shortform_dir2_entry_check(mp, ino, ip, &dirty,
>  						irec, ino_offset,
> @@ -2948,16 +2948,16 @@ process_dir_inode(
>  
>  			ASSERT(dirty == 0 || (dirty && !no_modify));
>  			if (dirty)  {
> -				libxfs_trans_log_inode(tp, ip,
> +				xfs_trans_log_inode(tp, ip,
>  					XFS_ILOG_CORE | XFS_ILOG_DDATA);
> -				error = -libxfs_trans_commit(tp);
> +				error = -xfs_trans_commit(tp);
>  				if (error)
>  					do_error(
>  _("error %d fixing shortform directory %llu\n"),
>  						error,
>  						(unsigned long long)ip->i_ino);
>  			} else  {
> -				libxfs_trans_cancel(tp);
> +				xfs_trans_cancel(tp);
>  			}
>  			break;
>  
> @@ -2982,21 +2982,21 @@ _("error %d fixing shortform directory %llu\n"),
>  		do_warn(_("recreating root directory .. entry\n"));
>  
>  		nres = XFS_MKDIR_SPACE_RES(mp, 2);
> -		error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_mkdir,
> +		error = -xfs_trans_alloc(mp, &M_RES(mp)->tr_mkdir,
>  					    nres, 0, 0, &tp);
>  		if (error)
>  			res_failed(error);
>  
> -		libxfs_trans_ijoin(tp, ip, 0);
> +		xfs_trans_ijoin(tp, ip, 0);
>  
> -		error = -libxfs_dir_createname(tp, ip, &xfs_name_dotdot,
> +		error = -xfs_dir_createname(tp, ip, &xfs_name_dotdot,
>  					ip->i_ino, nres);
>  		if (error)
>  			do_error(
>  	_("can't make \"..\" entry in root inode %" PRIu64 ", createname error %d\n"), ino, error);
>  
> -		libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> -		error = -libxfs_trans_commit(tp);
> +		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> +		error = -xfs_trans_commit(tp);
>  		if (error)
>  			do_error(
>  	_("root inode \"..\" entry recreation failed (%d)\n"), error);
> @@ -3037,22 +3037,22 @@ _("error %d fixing shortform directory %llu\n"),
>  	_("creating missing \".\" entry in dir ino %" PRIu64 "\n"), ino);
>  
>  			nres = XFS_MKDIR_SPACE_RES(mp, 1);
> -			error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_mkdir,
> +			error = -xfs_trans_alloc(mp, &M_RES(mp)->tr_mkdir,
>  						    nres, 0, 0, &tp);
>  			if (error)
>  				res_failed(error);
>  
> -			libxfs_trans_ijoin(tp, ip, 0);
> +			xfs_trans_ijoin(tp, ip, 0);
>  
> -			error = -libxfs_dir_createname(tp, ip, &xfs_name_dot,
> +			error = -xfs_dir_createname(tp, ip, &xfs_name_dot,
>  					ip->i_ino, nres);
>  			if (error)
>  				do_error(
>  	_("can't make \".\" entry in dir ino %" PRIu64 ", createname error %d\n"),
>  					ino, error);
>  
> -			libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> -			error = -libxfs_trans_commit(tp);
> +			xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> +			error = -xfs_trans_commit(tp);
>  			if (error)
>  				do_error(
>  	_("root inode \".\" entry recreation failed (%d)\n"), error);
> diff --git a/repair/phase7.c b/repair/phase7.c
> index c2996470..78df1ae0 100644
> --- a/repair/phase7.c
> +++ b/repair/phase7.c
> @@ -29,7 +29,7 @@ update_inode_nlinks(
>  	int			nres;
>  
>  	nres = no_modify ? 0 : 10;
> -	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_remove, nres, 0, 0, &tp);
> +	error = -xfs_trans_alloc(mp, &M_RES(mp)->tr_remove, nres, 0, 0, &tp);
>  	ASSERT(error == 0);
>  
>  	error = -libxfs_iget(mp, tp, ino, 0, &ip, &xfs_default_ifork_ops);
> @@ -64,16 +64,16 @@ update_inode_nlinks(
>  	}
>  
>  	if (!dirty)  {
> -		libxfs_trans_cancel(tp);
> +		xfs_trans_cancel(tp);
>  	} else  {
> -		libxfs_trans_ijoin(tp, ip, 0);
> -		libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> +		xfs_trans_ijoin(tp, ip, 0);
> +		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  		/*
>  		 * no need to do a bmap finish since
>  		 * we're not allocating anything
>  		 */
>  		ASSERT(error == 0);
> -		error = -libxfs_trans_commit(tp);
> +		error = -xfs_trans_commit(tp);
>  
>  		ASSERT(error == 0);
>  	}
> diff --git a/repair/prefetch.c b/repair/prefetch.c
> index 3ac49db1..402fdb34 100644
> --- a/repair/prefetch.c
> +++ b/repair/prefetch.c
> @@ -121,7 +121,7 @@ pf_queue_io(
>  	 * the lock holder is either reading it from disk himself or
>  	 * completely overwriting it this behaviour is perfectly fine.
>  	 */
> -	error = -libxfs_buf_get_map(mp->m_dev, map, nmaps,
> +	error = -xfs_buf_get_map(mp->m_dev, map, nmaps,
>  			LIBXFS_GETBUF_TRYLOCK, &bp);
>  	if (error)
>  		return;
> @@ -131,7 +131,7 @@ pf_queue_io(
>  			pf_read_inode_dirs(args, bp);
>  		libxfs_buf_set_priority(bp, libxfs_buf_priority(bp) +
>  						CACHE_PREFETCH_PRIORITY);
> -		libxfs_buf_relse(bp);
> +		xfs_buf_relse(bp);
>  		return;
>  	}
>  	libxfs_buf_set_priority(bp, flag);
> @@ -274,7 +274,7 @@ pf_scan_lbtree(
>  	int			rc;
>  	int			error;
>  
> -	error = -libxfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, dbno),
> +	error = -xfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, dbno),
>  			XFS_FSB_TO_BB(mp, 1), LIBXFS_READBUF_SALVAGE, &bp,
>  			&xfs_bmbt_buf_ops);
>  	if (error)
> @@ -290,13 +290,13 @@ pf_scan_lbtree(
>  	 */
>  	if (bp->b_error) {
>  		bp->b_flags |= LIBXFS_B_UNCHECKED;
> -		libxfs_buf_relse(bp);
> +		xfs_buf_relse(bp);
>  		return 0;
>  	}
>  
>  	rc = (*func)(XFS_BUF_TO_BLOCK(bp), level - 1, isadir, args);
>  
> -	libxfs_buf_relse(bp);
> +	xfs_buf_relse(bp);
>  
>  	return rc;
>  }
> @@ -375,7 +375,7 @@ pf_read_btinode(
>  		return;
>  
>  	dsize = XFS_DFORK_DSIZE(dino, mp);
> -	pp = XFS_BMDR_PTR_ADDR(dib, 1, libxfs_bmdr_maxrecs(dsize, 0));
> +	pp = XFS_BMDR_PTR_ADDR(dib, 1, xfs_bmdr_maxrecs(dsize, 0));
>  
>  	for (i = 0; i < numrecs; i++) {
>  		dbno = get_unaligned_be64(&pp[i]);
> @@ -438,7 +438,7 @@ pf_read_inode_dirs(
>  		if (be16_to_cpu(dino->di_magic) != XFS_DINODE_MAGIC)
>  			continue;
>  
> -		if (!libxfs_dinode_good_version(&mp->m_sb, dino->di_version))
> +		if (!xfs_dinode_good_version(&mp->m_sb, dino->di_version))
>  			continue;
>  
>  		if (be64_to_cpu(dino->di_size) <= XFS_DFORK_DSIZE(dino, mp))
> @@ -583,7 +583,7 @@ pf_batch_read(
>  		if ((bplist[num - 1]->b_flags & LIBXFS_B_DISCONTIG)) {
>  			libxfs_readbufr_map(mp->m_ddev_targp, bplist[num - 1], 0);
>  			bplist[num - 1]->b_flags |= LIBXFS_B_UNCHECKED;
> -			libxfs_buf_relse(bplist[num - 1]);
> +			xfs_buf_relse(bplist[num - 1]);
>  			num--;
>  		}
>  
> @@ -618,7 +618,7 @@ pf_batch_read(
>  								      'I' : 'M',
>  				bplist[i], (long long)XFS_BUF_ADDR(bplist[i]),
>  				args->agno);
> -			libxfs_buf_relse(bplist[i]);
> +			xfs_buf_relse(bplist[i]);
>  		}
>  		pthread_mutex_lock(&args->lock);
>  		if (which != PF_SECONDARY) {
> diff --git a/repair/rmap.c b/repair/rmap.c
> index a4cc6a49..efdeb621 100644
> --- a/repair/rmap.c
> +++ b/repair/rmap.c
> @@ -38,7 +38,7 @@ static bool refcbt_suspect;
>  
>  static inline int rmap_compare(const void *a, const void *b)
>  {
> -	return libxfs_rmap_compare(a, b);
> +	return xfs_rmap_compare(a, b);
>  }
>  
>  /*
> @@ -465,7 +465,7 @@ rmap_store_ag_btree_rec(
>  		goto err;
>  
>  	/* Add the AGFL blocks to the rmap list */
> -	error = -libxfs_trans_read_buf(
> +	error = -xfs_trans_read_buf(
>  			mp, NULL, mp->m_ddev_targp,
>  			XFS_AG_DADDR(mp, agno, XFS_AGFL_DADDR(mp)),
>  			XFS_FSS_TO_BB(mp, 1), 0, &agflbp, &xfs_agfl_buf_ops);
> @@ -515,7 +515,7 @@ rmap_store_ag_btree_rec(
>  	agfl_bno = xfs_buf_to_agfl_bno(agflbp);
>  	b = agfl_bno + ag_rmap->ar_flcount;
>  	while (*b != cpu_to_be32(NULLAGBLOCK) &&
> -	       b - agfl_bno < libxfs_agfl_size(mp)) {
> +	       b - agfl_bno < xfs_agfl_size(mp)) {
>  		xfs_agblock_t	agbno;
>  
>  		agbno = be32_to_cpu(*b);
> @@ -527,7 +527,7 @@ rmap_store_ag_btree_rec(
>  		}
>  		b++;
>  	}
> -	libxfs_buf_relse(agflbp);
> +	xfs_buf_relse(agflbp);
>  	agflbp = NULL;
>  	bitmap_free(&own_ag_bitmap);
>  
> @@ -546,22 +546,22 @@ rmap_store_ag_btree_rec(
>  	while (rm_rec) {
>  		struct xfs_owner_info	oinfo = {};
>  
> -		error = -libxfs_trans_alloc_rollable(mp, 16, &tp);
> +		error = -xfs_trans_alloc_rollable(mp, 16, &tp);
>  		if (error)
>  			goto err_slab;
>  
> -		error = -libxfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
> +		error = -xfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
>  		if (error)
>  			goto err_trans;
>  
>  		ASSERT(XFS_RMAP_NON_INODE_OWNER(rm_rec->rm_owner));
>  		oinfo.oi_owner = rm_rec->rm_owner;
> -		error = -libxfs_rmap_alloc(tp, agbp, agno, rm_rec->rm_startblock,
> +		error = -xfs_rmap_alloc(tp, agbp, agno, rm_rec->rm_startblock,
>  				rm_rec->rm_blockcount, &oinfo);
>  		if (error)
>  			goto err_trans;
>  
> -		error = -libxfs_trans_commit(tp);
> +		error = -xfs_trans_commit(tp);
>  		if (error)
>  			goto err_slab;
>  
> @@ -574,12 +574,12 @@ rmap_store_ag_btree_rec(
>  	return 0;
>  
>  err_trans:
> -	libxfs_trans_cancel(tp);
> +	xfs_trans_cancel(tp);
>  err_slab:
>  	free_slab_cursor(&rm_cur);
>  err:
>  	if (agflbp)
> -		libxfs_buf_relse(agflbp);
> +		xfs_buf_relse(agflbp);
>  	if (own_ag_bitmap)
>  		bitmap_free(&own_ag_bitmap);
>  	return error;
> @@ -905,7 +905,7 @@ rmap_lookup(
>  	int			error;
>  
>  	/* Use the regular btree retrieval routine. */
> -	error = -libxfs_rmap_lookup_le(bt_cur, rm_rec->rm_startblock,
> +	error = -xfs_rmap_lookup_le(bt_cur, rm_rec->rm_startblock,
>  				rm_rec->rm_blockcount,
>  				rm_rec->rm_owner, rm_rec->rm_offset,
>  				rm_rec->rm_flags, have);
> @@ -913,7 +913,7 @@ rmap_lookup(
>  		return error;
>  	if (*have == 0)
>  		return error;
> -	return -libxfs_rmap_get_rec(bt_cur, tmp, have);
> +	return -xfs_rmap_get_rec(bt_cur, tmp, have);
>  }
>  
>  /* Look for an rmap in the rmapbt that matches a given rmap. */
> @@ -925,7 +925,7 @@ rmap_lookup_overlapped(
>  	int			*have)
>  {
>  	/* Have to use our fancy version for overlapped */
> -	return -libxfs_rmap_lookup_le_range(bt_cur, rm_rec->rm_startblock,
> +	return -xfs_rmap_lookup_le_range(bt_cur, rm_rec->rm_startblock,
>  				rm_rec->rm_owner, rm_rec->rm_offset,
>  				rm_rec->rm_flags, tmp, have);
>  }
> @@ -998,16 +998,16 @@ rmaps_verify_btree(
>  	if (error)
>  		return error;
>  
> -	error = -libxfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
> +	error = -xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
>  	if (error)
>  		goto err;
>  
>  	/* Leave the per-ag data "uninitialized" since we rewrite it later */
> -	pag = libxfs_perag_get(mp, agno);
> +	pag = xfs_perag_get(mp, agno);
>  	pag->pagf_init = 0;
> -	libxfs_perag_put(pag);
> +	xfs_perag_put(pag);
>  
> -	bt_cur = libxfs_rmapbt_init_cursor(mp, NULL, agbp, agno);
> +	bt_cur = xfs_rmapbt_init_cursor(mp, NULL, agbp, agno);
>  	if (!bt_cur) {
>  		error = -ENOMEM;
>  		goto err;
> @@ -1080,9 +1080,9 @@ next_loop:
>  
>  err:
>  	if (bt_cur)
> -		libxfs_btree_del_cursor(bt_cur, XFS_BTREE_NOERROR);
> +		xfs_btree_del_cursor(bt_cur, XFS_BTREE_NOERROR);
>  	if (agbp)
> -		libxfs_buf_relse(agbp);
> +		xfs_buf_relse(agbp);
>  	free_slab_cursor(&rm_cur);
>  	return 0;
>  }
> @@ -1103,10 +1103,10 @@ rmap_diffkeys(
>  
>  	tmp = *kp1;
>  	tmp.rm_flags &= ~XFS_RMAP_REC_FLAGS;
> -	oa = libxfs_rmap_irec_offset_pack(&tmp);
> +	oa = xfs_rmap_irec_offset_pack(&tmp);
>  	tmp = *kp2;
>  	tmp.rm_flags &= ~XFS_RMAP_REC_FLAGS;
> -	ob = libxfs_rmap_irec_offset_pack(&tmp);
> +	ob = xfs_rmap_irec_offset_pack(&tmp);
>  
>  	d = (int64_t)kp1->rm_startblock - kp2->rm_startblock;
>  	if (d)
> @@ -1230,9 +1230,9 @@ _("setting reflink flag on inode %"PRIu64"\n"),
>  		dino->di_flags2 |= cpu_to_be64(XFS_DIFLAG2_REFLINK);
>  	else
>  		dino->di_flags2 &= cpu_to_be64(~XFS_DIFLAG2_REFLINK);
> -	libxfs_dinode_calc_crc(mp, dino);
> +	xfs_dinode_calc_crc(mp, dino);
>  	libxfs_buf_mark_dirty(buf);
> -	libxfs_buf_relse(buf);
> +	xfs_buf_relse(buf);
>  
>  	return 0;
>  }
> @@ -1359,16 +1359,16 @@ check_refcounts(
>  	if (error)
>  		return error;
>  
> -	error = -libxfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
> +	error = -xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
>  	if (error)
>  		goto err;
>  
>  	/* Leave the per-ag data "uninitialized" since we rewrite it later */
> -	pag = libxfs_perag_get(mp, agno);
> +	pag = xfs_perag_get(mp, agno);
>  	pag->pagf_init = 0;
> -	libxfs_perag_put(pag);
> +	xfs_perag_put(pag);
>  
> -	bt_cur = libxfs_refcountbt_init_cursor(mp, NULL, agbp, agno);
> +	bt_cur = xfs_refcountbt_init_cursor(mp, NULL, agbp, agno);
>  	if (!bt_cur) {
>  		error = -ENOMEM;
>  		goto err;
> @@ -1377,7 +1377,7 @@ check_refcounts(
>  	rl_rec = pop_slab_cursor(rl_cur);
>  	while (rl_rec) {
>  		/* Look for a refcount record in the btree */
> -		error = -libxfs_refcount_lookup_le(bt_cur,
> +		error = -xfs_refcount_lookup_le(bt_cur,
>  				rl_rec->rc_startblock, &have);
>  		if (error)
>  			goto err;
> @@ -1389,7 +1389,7 @@ _("Missing reference count record for (%u/%u) len %u count %u\n"),
>  			goto next_loop;
>  		}
>  
> -		error = -libxfs_refcount_get_rec(bt_cur, &tmp, &i);
> +		error = -xfs_refcount_get_rec(bt_cur, &tmp, &i);
>  		if (error)
>  			goto err;
>  		if (!i) {
> @@ -1415,10 +1415,10 @@ next_loop:
>  
>  err:
>  	if (bt_cur)
> -		libxfs_btree_del_cursor(bt_cur, error ? XFS_BTREE_ERROR :
> +		xfs_btree_del_cursor(bt_cur, error ? XFS_BTREE_ERROR :
>  							XFS_BTREE_NOERROR);
>  	if (agbp)
> -		libxfs_buf_relse(agbp);
> +		xfs_buf_relse(agbp);
>  	free_slab_cursor(&rl_cur);
>  	return 0;
>  }
> @@ -1443,8 +1443,8 @@ fix_freelist(
>  	args.mp = mp;
>  	args.agno = agno;
>  	args.alignment = 1;
> -	args.pag = libxfs_perag_get(mp, agno);
> -	error = -libxfs_trans_alloc_rollable(mp, 0, &tp);
> +	args.pag = xfs_perag_get(mp, agno);
> +	error = -xfs_trans_alloc_rollable(mp, 0, &tp);
>  	if (error)
>  		do_error(_("failed to fix AGFL on AG %d, error %d\n"),
>  				agno, error);
> @@ -1474,13 +1474,13 @@ fix_freelist(
>  	flags = XFS_ALLOC_FLAG_NOSHRINK;
>  	if (skip_rmapbt)
>  		flags |= XFS_ALLOC_FLAG_NORMAP;
> -	error = -libxfs_alloc_fix_freelist(&args, flags);
> -	libxfs_perag_put(args.pag);
> +	error = -xfs_alloc_fix_freelist(&args, flags);
> +	xfs_perag_put(args.pag);
>  	if (error) {
>  		do_error(_("failed to fix AGFL on AG %d, error %d\n"),
>  				agno, error);
>  	}
> -	error = -libxfs_trans_commit(tp);
> +	error = -xfs_trans_commit(tp);
>  	if (error)
>  		do_error(_("%s: commit failed, error %d\n"), __func__, error);
>  }
> diff --git a/repair/rt.c b/repair/rt.c
> index d901e751..cca654ae 100644
> --- a/repair/rt.c
> +++ b/repair/rt.c
> @@ -14,8 +14,6 @@
>  #include "err_protos.h"
>  #include "rt.h"
>  
> -#define xfs_highbit64 libxfs_highbit64	/* for XFS_RTBLOCKLOG macro */
> -
>  void
>  rtinit(xfs_mount_t *mp)
>  {
> @@ -193,7 +191,7 @@ process_rtbitmap(xfs_mount_t	*mp,
>  			error = 1;
>  			continue;
>  		}
> -		error = -libxfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),
> +		error = -xfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),
>  				XFS_FSB_TO_BB(mp, 1), 0, NULL, &bp);
>  		if (error) {
>  			do_warn(_("can't read block %d for rtbitmap inode\n"),
> @@ -222,7 +220,7 @@ process_rtbitmap(xfs_mount_t	*mp,
>  				prevbit = 0;
>  			}
>  		}
> -		libxfs_buf_relse(bp);
> +		xfs_buf_relse(bp);
>  		if (extno == mp->m_sb.sb_rextents)
>  			break;
>  	}
> @@ -255,7 +253,7 @@ process_rtsummary(xfs_mount_t	*mp,
>  			error++;
>  			continue;
>  		}
> -		error = -libxfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),
> +		error = -xfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),
>  				XFS_FSB_TO_BB(mp, 1), 0, NULL, &bp);
>  		if (error) {
>  			do_warn(_("can't read block %d for rtsummary inode\n"),
> @@ -266,7 +264,7 @@ process_rtsummary(xfs_mount_t	*mp,
>  		bytes = bp->b_un.b_addr;
>  		memmove((char *)sumfile + sumbno * mp->m_sb.sb_blocksize, bytes,
>  			mp->m_sb.sb_blocksize);
> -		libxfs_buf_relse(bp);
> +		xfs_buf_relse(bp);
>  	}
>  }
>  #endif
> diff --git a/repair/sb.c b/repair/sb.c
> index 91a36dd3..0936f5be 100644
> --- a/repair/sb.c
> +++ b/repair/sb.c
> @@ -142,7 +142,7 @@ __find_secondary_sb(
>  		 */
>  		for (i = 0; !done && i < bsize; i += BBSIZE)  {
>  			c_bufsb = (char *)sb + i;
> -			libxfs_sb_from_disk(&bufsb, (xfs_dsb_t *)c_bufsb);
> +			xfs_sb_from_disk(&bufsb, (xfs_dsb_t *)c_bufsb);
>  
>  			if (verify_sb(c_bufsb, &bufsb, 0) != XR_OK)
>  				continue;
> @@ -397,7 +397,7 @@ verify_sb(char *sb_buf, xfs_sb_t *sb, int is_primary_sb)
>  
>  	/* sector size in range - CRC check time */
>  	if (xfs_sb_version_hascrc(sb) &&
> -	    !libxfs_verify_cksum(sb_buf, sb->sb_sectsize, XFS_SB_CRC_OFF))
> +	    !xfs_verify_cksum(sb_buf, sb->sb_sectsize, XFS_SB_CRC_OFF))
>  		return XR_BAD_CRC;
>  
>  	/* check to ensure blocksize and blocklog are legal */
> @@ -480,7 +480,7 @@ verify_sb(char *sb_buf, xfs_sb_t *sb, int is_primary_sb)
>  			return(XR_BAD_RT_GEO_DATA);
>  
>  		if (sb->sb_rextslog !=
> -				libxfs_highbit32((unsigned int)sb->sb_rextents))
> +				xfs_highbit32((unsigned int)sb->sb_rextents))
>  			return(XR_BAD_RT_GEO_DATA);
>  
>  		if (sb->sb_rbmblocks != (xfs_extlen_t) howmany(sb->sb_rextents,
> @@ -540,7 +540,7 @@ write_primary_sb(xfs_sb_t *sbp, int size)
>  		do_error(_("couldn't seek to offset 0 in filesystem\n"));
>  	}
>  
> -	libxfs_sb_to_disk(buf, sbp);
> +	xfs_sb_to_disk(buf, sbp);
>  
>  	if (xfs_sb_version_hascrc(sbp))
>  		xfs_update_cksum((char *)buf, size, XFS_SB_CRC_OFF);
> @@ -589,7 +589,7 @@ get_sb(xfs_sb_t *sbp, xfs_off_t off, int size, xfs_agnumber_t agno)
>  			off, size, agno, rval);
>  		do_error("%s\n", strerror(error));
>  	}
> -	libxfs_sb_from_disk(sbp, buf);
> +	xfs_sb_from_disk(sbp, buf);
>  
>  	rval = verify_sb((char *)buf, sbp, agno == 0);
>  	free(buf);
> diff --git a/repair/scan.c b/repair/scan.c
> index 5c8d8b23..e47e71dd 100644
> --- a/repair/scan.c
> +++ b/repair/scan.c
> @@ -60,7 +60,7 @@ salvage_buffer(
>  {
>  	int			error;
>  
> -	error = -libxfs_buf_read(target, blkno, numblks,
> +	error = -xfs_buf_read(target, blkno, numblks,
>  			LIBXFS_READBUF_SALVAGE, bpp, ops);
>  	if (error != EIO)
>  		return error;
> @@ -70,7 +70,7 @@ salvage_buffer(
>  	 * be full of zeroes) and make it look like we read the data from the
>  	 * disk but it failed verification.
>  	 */
> -	error = -libxfs_buf_get(target, blkno, numblks, bpp);
> +	error = -xfs_buf_get(target, blkno, numblks, bpp);
>  	if (error)
>  		return error;
>  
> @@ -116,7 +116,7 @@ scan_sbtree(
>  
>  	(*func)(XFS_BUF_TO_BLOCK(bp), nlevels - 1, root, agno, suspect,
>  			isroot, magic, priv, ops);
> -	libxfs_buf_relse(bp);
> +	xfs_buf_relse(bp);
>  }
>  
>  /*
> @@ -187,10 +187,10 @@ scan_lbtree(
>  
>  	if ((dirty || badcrc) && !no_modify) {
>  		libxfs_buf_mark_dirty(bp);
> -		libxfs_buf_relse(bp);
> +		xfs_buf_relse(bp);
>  	}
>  	else
> -		libxfs_buf_relse(bp);
> +		xfs_buf_relse(bp);
>  
>  	return(err);
>  }
> @@ -1049,7 +1049,7 @@ _("%s rmap btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
>  			key.rm_startblock = b;
>  			key.rm_blockcount = len;
>  			key.rm_owner = owner;
> -			if (libxfs_rmap_irec_offset_unpack(offset, &key)) {
> +			if (xfs_rmap_irec_offset_unpack(offset, &key)) {
>  				/* Look for impossible flags. */
>  				do_warn(
>  	_("invalid flags in record %u of %s btree block %u/%u\n"),
> @@ -1189,7 +1189,7 @@ advance:
>  		key.rm_flags = 0;
>  		key.rm_startblock = be32_to_cpu(kp->rm_startblock);
>  		key.rm_owner = be64_to_cpu(kp->rm_owner);
> -		if (libxfs_rmap_irec_offset_unpack(be64_to_cpu(kp->rm_offset),
> +		if (xfs_rmap_irec_offset_unpack(be64_to_cpu(kp->rm_offset),
>  				&key)) {
>  			/* Look for impossible flags. */
>  			do_warn(
> @@ -1221,7 +1221,7 @@ advance:
>  				be32_to_cpu(kp->rm_startblock);
>  		rmap_priv->high_key.rm_owner =
>  				be64_to_cpu(kp->rm_owner);
> -		if (libxfs_rmap_irec_offset_unpack(be64_to_cpu(kp->rm_offset),
> +		if (xfs_rmap_irec_offset_unpack(be64_to_cpu(kp->rm_offset),
>  				&rmap_priv->high_key)) {
>  			/* Look for impossible flags. */
>  			do_warn(
> @@ -2156,8 +2156,8 @@ scan_freelist(
>  
>  	if (no_modify) {
>  		/* agf values not fixed in verify_set_agf, so recheck */
> -		if (be32_to_cpu(agf->agf_flfirst) >= libxfs_agfl_size(mp) ||
> -		    be32_to_cpu(agf->agf_fllast) >= libxfs_agfl_size(mp)) {
> +		if (be32_to_cpu(agf->agf_flfirst) >= xfs_agfl_size(mp) ||
> +		    be32_to_cpu(agf->agf_fllast) >= xfs_agfl_size(mp)) {
>  			do_warn(_("agf %d freelist blocks bad, skipping "
>  				  "freelist scan\n"), agno);
>  			return;
> @@ -2166,7 +2166,7 @@ scan_freelist(
>  
>  	state.count = 0;
>  	state.agno = agno;
> -	libxfs_agfl_walk(mp, agf, agflbuf, scan_agfl, &state);
> +	xfs_agfl_walk(mp, agf, agflbuf, scan_agfl, &state);
>  	if (state.count != be32_to_cpu(agf->agf_flcount)) {
>  		do_warn(_("freeblk count %d != flcount %d in ag %d\n"),
>  				state.count, be32_to_cpu(agf->agf_flcount),
> @@ -2175,7 +2175,7 @@ scan_freelist(
>  
>  	agcnts->fdblocks += state.count;
>  
> -	libxfs_buf_relse(agflbuf);
> +	xfs_buf_relse(agflbuf);
>  }
>  
>  static void
> @@ -2375,7 +2375,7 @@ scan_ag(
>  		objname = _("root superblock");
>  		goto out_free_sb;
>  	}
> -	libxfs_sb_from_disk(sb, sbbuf->b_addr);
> +	xfs_sb_from_disk(sb, sbbuf->b_addr);
>  
>  	error = salvage_buffer(mp->m_dev,
>  			XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
> @@ -2465,26 +2465,26 @@ scan_ag(
>  
>  	if (agi_dirty && !no_modify) {
>  		libxfs_buf_mark_dirty(agibuf);
> -		libxfs_buf_relse(agibuf);
> +		xfs_buf_relse(agibuf);
>  	}
>  	else
> -		libxfs_buf_relse(agibuf);
> +		xfs_buf_relse(agibuf);
>  
>  	if (agf_dirty && !no_modify) {
>  		libxfs_buf_mark_dirty(agfbuf);
> -		libxfs_buf_relse(agfbuf);
> +		xfs_buf_relse(agfbuf);
>  	}
>  	else
> -		libxfs_buf_relse(agfbuf);
> +		xfs_buf_relse(agfbuf);
>  
>  	if (sb_dirty && !no_modify) {
>  		if (agno == 0)
>  			memcpy(&mp->m_sb, sb, sizeof(xfs_sb_t));
> -		libxfs_sb_to_disk(sbbuf->b_addr, sb);
> +		xfs_sb_to_disk(sbbuf->b_addr, sb);
>  		libxfs_buf_mark_dirty(sbbuf);
> -		libxfs_buf_relse(sbbuf);
> +		xfs_buf_relse(sbbuf);
>  	} else
> -		libxfs_buf_relse(sbbuf);
> +		xfs_buf_relse(sbbuf);
>  	free(sb);
>  	PROG_RPT_INC(prog_rpt_done[agno], 1);
>  
> @@ -2494,11 +2494,11 @@ scan_ag(
>  	return;
>  
>  out_free_agibuf:
> -	libxfs_buf_relse(agibuf);
> +	xfs_buf_relse(agibuf);
>  out_free_agfbuf:
> -	libxfs_buf_relse(agfbuf);
> +	xfs_buf_relse(agfbuf);
>  out_free_sbbuf:
> -	libxfs_buf_relse(sbbuf);
> +	xfs_buf_relse(sbbuf);
>  out_free_sb:
>  	free(sb);
>  
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index 9d72fa8e..91f72670 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -443,7 +443,7 @@ has_plausible_rootdir(
>  	if (!S_ISDIR(VFS_I(ip)->i_mode))
>  		goto out_rele;
>  
> -	error = -libxfs_dir_lookup(NULL, ip, &xfs_name_dotdot, &ino, NULL);
> +	error = -xfs_dir_lookup(NULL, ip, &xfs_name_dotdot, &ino, NULL);
>  	if (error)
>  		goto out_rele;
>  
> @@ -475,13 +475,13 @@ guess_correct_sunit(
>  
>  	/* Try reading secondary supers to see if we find a good sb_unit. */
>  	for (agno = 1; agno < mp->m_sb.sb_agcount; agno++) {
> -		error = -libxfs_sb_read_secondary(mp, NULL, agno, &bp);
> +		error = -xfs_sb_read_secondary(mp, NULL, agno, &bp);
>  		if (error)
>  			continue;
> -		libxfs_sb_from_disk(&sb, bp->b_addr);
> -		libxfs_buf_relse(bp);
> +		xfs_sb_from_disk(&sb, bp->b_addr);
> +		xfs_buf_relse(bp);
>  
> -		calc_rootino = libxfs_ialloc_calc_rootino(mp, sb.sb_unit);
> +		calc_rootino = xfs_ialloc_calc_rootino(mp, sb.sb_unit);
>  		if (calc_rootino == mp->m_sb.sb_rootino)
>  			break;
>  	}
> @@ -498,7 +498,7 @@ guess_correct_sunit(
>  	for (sunit_guess = 1;
>  	     sunit_guess <= XFS_AG_MAX_BLOCKS(mp->m_sb.sb_blocklog);
>  	     sunit_guess *= 2) {
> -		calc_rootino = libxfs_ialloc_calc_rootino(mp, sunit_guess);
> +		calc_rootino = xfs_ialloc_calc_rootino(mp, sunit_guess);
>  		if (calc_rootino == mp->m_sb.sb_rootino)
>  			break;
>  	}
> @@ -545,7 +545,7 @@ calc_mkfs(
>  {
>  	xfs_ino_t		rootino;
>  
> -	rootino = libxfs_ialloc_calc_rootino(mp, mp->m_sb.sb_unit);
> +	rootino = xfs_ialloc_calc_rootino(mp, mp->m_sb.sb_unit);
>  
>  	/*
>  	 * If the root inode isn't where we think it is, check its plausibility
> @@ -793,7 +793,7 @@ main(int argc, char **argv)
>  	glob_agcount = mp->m_sb.sb_agcount;
>  
>  	chunks_pblock = mp->m_sb.sb_inopblock / XFS_INODES_PER_CHUNK;
> -	max_symlink_blocks = libxfs_symlink_blocks(mp, XFS_SYMLINK_MAXLEN);
> +	max_symlink_blocks = xfs_symlink_blocks(mp, XFS_SYMLINK_MAXLEN);
>  
>  	/*
>  	 * Automatic striding for high agcount filesystems.
> @@ -1097,7 +1097,7 @@ _("Note - stripe unit (%d) and width (%d) were copied from a backup superblock.\
>  	}
>  
>  	libxfs_buf_mark_dirty(sbp);
> -	libxfs_buf_relse(sbp);
> +	xfs_buf_relse(sbp);
>  
>  	/*
>  	 * Done. Flush all cached buffers and inodes first to ensure all
> diff --git a/tools/find-api-violations.sh b/tools/find-api-violations.sh
> deleted file mode 100755
> index c25fccca..00000000
> --- a/tools/find-api-violations.sh
> +++ /dev/null
> @@ -1,45 +0,0 @@
> -#!/bin/bash
> -# SPDX-License-Identifier: GPL-2.0
> -
> -# Find libxfs API violations -- calls to functions defined in libxfs/*.c that
> -# don't use the libxfs wrappers; or failing to negate the integer return
> -# values.
> -
> -# NOTE: This script doesn't look for API violations in function parameters.
> -
> -tool_dirs="copy db estimate fsck fsr growfs io logprint mdrestore mkfs quota repair rtcp scrub"
> -
> -# Calls to xfs_* functions in libxfs/*.c without the libxfs_ prefix
> -find_possible_api_calls() {
> -	grep -rn '[-[:space:],(]xfs_[a-z_]*(' $tool_dirs | sed -e 's/^.*\(xfs_[a-z_]*\)(.*$/\1/g' | sort | uniq
> -}
> -
> -check_if_api_calls() {
> -	while read f; do grep "^$f(" libxfs/*.c; done | sed -e 's/^.*:xfs_/xfs_/g' -e 's/.$//g'
> -}
> -
> -# Generate a grep search expression for troublesome API call sites.
> -# " foo(", ",foo(", "-foo(", and "(foo(" are examples.
> -grep_pattern() {
> -	sed -e 's/^/[[:space:],-\\(]/g' -e 's/$/(/g'
> -}
> -
> -find_libxfs_violations() {
> -	grep -r -n -f <(find_possible_api_calls | check_if_api_calls | grep_pattern) $tool_dirs
> -}
> -
> -# libxfs calls without negated error codes
> -find_errcode_violations() {
> -	grep -r -n 'err.* = libxfs' $tool_dirs
> -}
> -
> -# Find xfs_* calls that are in the libxfs definition list
> -find_possible_libxfs_api_calls() {
> -	grep '#define[[:space:]]*xfs' libxfs/libxfs_api_defs.h | awk '{print $2}'
> -}
> -
> -find_libxfs_api_violations() {
> -	grep -r -n -f <(find_possible_libxfs_api_calls | grep_pattern) $tool_dirs
> -}
> -
> -(find_libxfs_violations ; find_errcode_violations ; find_libxfs_api_violations) | sort -g -t ':' -k 2 | sort -g -t ':' -k 1 | uniq
> -- 
> 2.26.2
> 
