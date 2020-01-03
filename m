Return-Path: <SRS0=vgQ5=2Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6E93C2D0C2
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Jan 2020 21:28:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B37A21835
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Jan 2020 21:28:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Qe/jzJ89"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728567AbgACV2I (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Jan 2020 16:28:08 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:44628 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728549AbgACV2H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Jan 2020 16:28:07 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 003LOHJl125272;
        Fri, 3 Jan 2020 21:28:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=aZLqR6MM2kOKyLe0iCSHJLLCEVBtk/xo3M3/HDhm4sw=;
 b=Qe/jzJ89psG0soxuYOpYRo2wXiUptyEXCtkmO7UxY/xD9b2oc1Eh6vPH/RWGJGQcHFfI
 AZS8KSkf/g9Gg9HZgxy6RPekJ6lQRW1l6lag8rFHGA56St0biUtsLcORv+s1Q5RTRasS
 4AznGhpA2BLJWTUHBJlgYhTB2P7H7PtNprVHVaz6kXN7wfOgb3BSSK6DIgU4hnrWZa2B
 6k2wdnq0QlR/meuhKW7ALbTq9jw+5+OzyObPwhe3gSHQGCsQUwo6CBnftNnHXlRd1O8d
 HkkLdfpsygDFBt9r8uaPu7DfB5C8GQok6numeaIgehKPAHNrkxsCs9qlxMwSCdrIgWXK 3w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2x5xftxdjb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jan 2020 21:28:03 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 003LRvp4150240;
        Fri, 3 Jan 2020 21:28:03 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2x9jm8326s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jan 2020 21:28:03 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 003LS2wx002396;
        Fri, 3 Jan 2020 21:28:02 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Jan 2020 13:28:01 -0800
Subject: Re: [PATCH 1/2] xfs_repair: push inode buf and dinode pointers all
 the way to inode fork processing
To:     "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
References: <157784174393.1372355.6666502611131426530.stgit@magnolia>
 <157784175007.1372355.4248483510838385930.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <8ef0d44c-4941-64ae-67b5-8f22d0dcabb7@oracle.com>
Date:   Fri, 3 Jan 2020 14:28:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <157784175007.1372355.4248483510838385930.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9489 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001030195
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9489 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001030194
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 12/31/19 6:22 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Currently, the process_dinode* family of functions assume that they have
> the buffer backing the inodes locked, and therefore the dinode pointer
> won't ever change.  However, the bmbt rebuilding code in the next patch
> will violate that assumption, so we must pass pointers to the inobp and
> the dinode pointer (that is to say, double pointers) all the way through
> to process_inode_{data,attr}_fork so that we can regrab the buffer after
> the rebuilding step finishes.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

This one looks ok to me.
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   repair/dino_chunks.c |    5 +-
>   repair/dinode.c      |  154 +++++++++++++++++++++++++++-----------------------
>   repair/dinode.h      |    7 +-
>   3 files changed, 90 insertions(+), 76 deletions(-)
> 
> 
> diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
> index 00b67468..c7260262 100644
> --- a/repair/dino_chunks.c
> +++ b/repair/dino_chunks.c
> @@ -797,10 +797,11 @@ process_inode_chunk(
>   		ino_dirty = 0;
>   		parent = 0;
>   
> -		status = process_dinode(mp, dino, agno, agino,
> +		status = process_dinode(mp, &dino, agno, agino,
>   				is_inode_free(ino_rec, irec_offset),
>   				&ino_dirty, &is_used,ino_discovery, check_dups,
> -				extra_attr_check, &isa_dir, &parent);
> +				extra_attr_check, &isa_dir, &parent,
> +				&bplist[bp_index]);
>   
>   		ASSERT(is_used != 3);
>   		if (ino_dirty) {
> diff --git a/repair/dinode.c b/repair/dinode.c
> index 8af2cb25..8141b4ad 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -1922,20 +1922,22 @@ _("nblocks (%" PRIu64 ") smaller than nextents for inode %" PRIu64 "\n"), nblock
>    */
>   static int
>   process_inode_data_fork(
> -	xfs_mount_t	*mp,
> -	xfs_agnumber_t	agno,
> -	xfs_agino_t	ino,
> -	xfs_dinode_t	*dino,
> -	int		type,
> -	int		*dirty,
> -	xfs_rfsblock_t	*totblocks,
> -	uint64_t	*nextents,
> -	blkmap_t	**dblkmap,
> -	int		check_dups)
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		agno,
> +	xfs_agino_t		ino,
> +	struct xfs_dinode	**dinop,
> +	int			type,
> +	int			*dirty,
> +	xfs_rfsblock_t		*totblocks,
> +	uint64_t		*nextents,
> +	blkmap_t		**dblkmap,
> +	int			check_dups,
> +	struct xfs_buf		**ino_bpp)
>   {
> -	xfs_ino_t	lino = XFS_AGINO_TO_INO(mp, agno, ino);
> -	int		err = 0;
> -	int		nex;
> +	struct xfs_dinode	*dino = *dinop;
> +	xfs_ino_t		lino = XFS_AGINO_TO_INO(mp, agno, ino);
> +	int			err = 0;
> +	int			nex;
>   
>   	/*
>   	 * extent count on disk is only valid for positive values. The kernel
> @@ -2031,22 +2033,24 @@ process_inode_data_fork(
>    */
>   static int
>   process_inode_attr_fork(
> -	xfs_mount_t	*mp,
> -	xfs_agnumber_t	agno,
> -	xfs_agino_t	ino,
> -	xfs_dinode_t	*dino,
> -	int		type,
> -	int		*dirty,
> -	xfs_rfsblock_t	*atotblocks,
> -	uint64_t	*anextents,
> -	int		check_dups,
> -	int		extra_attr_check,
> -	int		*retval)
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		agno,
> +	xfs_agino_t		ino,
> +	struct xfs_dinode	**dinop,
> +	int			type,
> +	int			*dirty,
> +	xfs_rfsblock_t		*atotblocks,
> +	uint64_t		*anextents,
> +	int			check_dups,
> +	int			extra_attr_check,
> +	int			*retval,
> +	struct xfs_buf		**ino_bpp)
>   {
> -	xfs_ino_t	lino = XFS_AGINO_TO_INO(mp, agno, ino);
> -	blkmap_t	*ablkmap = NULL;
> -	int		repair = 0;
> -	int		err;
> +	xfs_ino_t		lino = XFS_AGINO_TO_INO(mp, agno, ino);
> +	struct xfs_dinode	*dino = *dinop;
> +	struct blkmap		*ablkmap = NULL;
> +	int			repair = 0;
> +	int			err;
>   
>   	if (!XFS_DFORK_Q(dino)) {
>   		*anextents = 0;
> @@ -2103,7 +2107,7 @@ process_inode_attr_fork(
>   		 * XXX - put the inode onto the "move it" list and
>   		 *	log the the attribute scrubbing
>   		 */
> -		do_warn(_("bad attribute fork in inode %" PRIu64), lino);
> +		do_warn(_("bad attribute fork in inode %" PRIu64 "\n"), lino);
>   
>   		if (!no_modify)  {
>   			do_warn(_(", clearing attr fork\n"));
> @@ -2245,21 +2249,22 @@ _("Bad %s nsec %u on inode %" PRIu64 ", "), name, be32_to_cpu(t->t_nsec), lino);
>    * for detailed, info, look at process_dinode() comments.
>    */
>   static int
> -process_dinode_int(xfs_mount_t *mp,
> -		xfs_dinode_t *dino,
> -		xfs_agnumber_t agno,
> -		xfs_agino_t ino,
> -		int was_free,		/* 1 if inode is currently free */
> -		int *dirty,		/* out == > 0 if inode is now dirty */
> -		int *used,		/* out == 1 if inode is in use */
> -		int verify_mode,	/* 1 == verify but don't modify inode */
> -		int uncertain,		/* 1 == inode is uncertain */
> -		int ino_discovery,	/* 1 == check dirs for unknown inodes */
> -		int check_dups,		/* 1 == check if inode claims
> -					 * duplicate blocks		*/
> -		int extra_attr_check, /* 1 == do attribute format and value checks */
> -		int *isa_dir,		/* out == 1 if inode is a directory */
> -		xfs_ino_t *parent)	/* out -- parent if ino is a dir */
> +process_dinode_int(
> +	struct xfs_mount	*mp,
> +	struct xfs_dinode	**dinop,
> +	xfs_agnumber_t		agno,
> +	xfs_agino_t		ino,
> +	int			was_free,	/* 1 if inode is currently free */
> +	int			*dirty,		/* out == > 0 if inode is now dirty */
> +	int			*used,		/* out == 1 if inode is in use */
> +	int			verify_mode,	/* 1 == verify but don't modify inode */
> +	int			uncertain,	/* 1 == inode is uncertain */
> +	int			ino_discovery,	/* 1 == check dirs for unknown inodes */
> +	int			check_dups,	/* 1 == check if inode claims duplicate blocks */
> +	int			extra_attr_check, /* 1 == do attribute format and value checks */
> +	int			*isa_dir,	/* out == 1 if inode is a directory */
> +	xfs_ino_t		*parent,	/* out -- parent if ino is a dir */
> +	struct xfs_buf		**ino_bpp)
>   {
>   	xfs_rfsblock_t		totblocks = 0;
>   	xfs_rfsblock_t		atotblocks = 0;
> @@ -2271,7 +2276,8 @@ process_dinode_int(xfs_mount_t *mp,
>   	xfs_ino_t		lino;
>   	const int		is_free = 0;
>   	const int		is_used = 1;
> -	blkmap_t		*dblkmap = NULL;
> +	struct blkmap		*dblkmap = NULL;
> +	struct xfs_dinode	*dino = *dinop;
>   
>   	*dirty = *isa_dir = 0;
>   	*used = is_used;
> @@ -2293,6 +2299,7 @@ process_dinode_int(xfs_mount_t *mp,
>   	 * If uncertain is set, verify_mode MUST be set.
>   	 */
>   	ASSERT(uncertain == 0 || verify_mode != 0);
> +	ASSERT(ino_bpp != NULL || verify_mode != 0);
>   
>   	/*
>   	 * This is the only valid point to check the CRC; after this we may have
> @@ -2781,18 +2788,21 @@ _("Bad CoW extent size %u on inode %" PRIu64 ", "),
>   	/*
>   	 * check data fork -- if it's bad, clear the inode
>   	 */
> -	if (process_inode_data_fork(mp, agno, ino, dino, type, dirty,
> -			&totblocks, &nextents, &dblkmap, check_dups) != 0)
> +	if (process_inode_data_fork(mp, agno, ino, dinop, type, dirty,
> +			&totblocks, &nextents, &dblkmap, check_dups,
> +			ino_bpp) != 0)
>   		goto bad_out;
> +	dino = *dinop;
>   
>   	/*
>   	 * check attribute fork if necessary.  attributes are
>   	 * always stored in the regular filesystem.
>   	 */
> -	if (process_inode_attr_fork(mp, agno, ino, dino, type, dirty,
> +	if (process_inode_attr_fork(mp, agno, ino, dinop, type, dirty,
>   			&atotblocks, &anextents, check_dups, extra_attr_check,
> -			&retval))
> +			&retval, ino_bpp))
>   		goto bad_out;
> +	dino = *dinop;
>   
>   	/*
>   	 * enforce totblocks is 0 for misc types
> @@ -2910,28 +2920,30 @@ _("Bad CoW extent size %u on inode %" PRIu64 ", "),
>   
>   int
>   process_dinode(
> -	xfs_mount_t	*mp,
> -	xfs_dinode_t	*dino,
> -	xfs_agnumber_t	agno,
> -	xfs_agino_t	ino,
> -	int		was_free,
> -	int		*dirty,
> -	int		*used,
> -	int		ino_discovery,
> -	int		check_dups,
> -	int		extra_attr_check,
> -	int		*isa_dir,
> -	xfs_ino_t	*parent)
> +	struct xfs_mount	*mp,
> +	struct xfs_dinode	**dinop,
> +	xfs_agnumber_t		agno,
> +	xfs_agino_t		ino,
> +	int			was_free,
> +	int			*dirty,
> +	int			*used,
> +	int			ino_discovery,
> +	int			check_dups,
> +	int			extra_attr_check,
> +	int			*isa_dir,
> +	xfs_ino_t		*parent,
> +	struct xfs_buf		**ino_bpp)
>   {
> -	const int	verify_mode = 0;
> -	const int	uncertain = 0;
> +	const int		verify_mode = 0;
> +	const int		uncertain = 0;
>   
>   #ifdef XR_INODE_TRACE
>   	fprintf(stderr, _("processing inode %d/%d\n"), agno, ino);
>   #endif
> -	return process_dinode_int(mp, dino, agno, ino, was_free, dirty, used,
> -				verify_mode, uncertain, ino_discovery,
> -				check_dups, extra_attr_check, isa_dir, parent);
> +	return process_dinode_int(mp, dinop, agno, ino, was_free, dirty, used,
> +			verify_mode, uncertain, ino_discovery,
> +			check_dups, extra_attr_check, isa_dir, parent,
> +			ino_bpp);
>   }
>   
>   /*
> @@ -2956,9 +2968,9 @@ verify_dinode(
>   	const int	ino_discovery = 0;
>   	const int	uncertain = 0;
>   
> -	return process_dinode_int(mp, dino, agno, ino, 0, &dirty, &used,
> -				verify_mode, uncertain, ino_discovery,
> -				check_dups, 0, &isa_dir, &parent);
> +	return process_dinode_int(mp, &dino, agno, ino, 0, &dirty, &used,
> +			verify_mode, uncertain, ino_discovery,
> +			check_dups, 0, &isa_dir, &parent, NULL);
>   }
>   
>   /*
> @@ -2982,7 +2994,7 @@ verify_uncertain_dinode(
>   	const int	ino_discovery = 0;
>   	const int	uncertain = 1;
>   
> -	return process_dinode_int(mp, dino, agno, ino, 0, &dirty, &used,
> +	return process_dinode_int(mp, &dino, agno, ino, 0, &dirty, &used,
>   				verify_mode, uncertain, ino_discovery,
> -				check_dups, 0, &isa_dir, &parent);
> +				check_dups, 0, &isa_dir, &parent, NULL);
>   }
> diff --git a/repair/dinode.h b/repair/dinode.h
> index aa177465..c57254b8 100644
> --- a/repair/dinode.h
> +++ b/repair/dinode.h
> @@ -52,8 +52,8 @@ void
>   update_rootino(xfs_mount_t *mp);
>   
>   int
> -process_dinode(xfs_mount_t *mp,
> -		xfs_dinode_t *dino,
> +process_dinode(struct xfs_mount *mp,
> +		struct xfs_dinode **dinop,
>   		xfs_agnumber_t agno,
>   		xfs_agino_t ino,
>   		int was_free,
> @@ -63,7 +63,8 @@ process_dinode(xfs_mount_t *mp,
>   		int check_dups,
>   		int extra_attr_check,
>   		int *isa_dir,
> -		xfs_ino_t *parent);
> +		xfs_ino_t *parent,
> +		struct xfs_buf **ino_bpp);
>   
>   int
>   verify_dinode(xfs_mount_t *mp,
> 
