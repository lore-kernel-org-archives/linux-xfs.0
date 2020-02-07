Return-Path: <SRS0=0es8=33=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BC0AC352A2
	for <linux-xfs@archiver.kernel.org>; Fri,  7 Feb 2020 13:16:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36449218AC
	for <linux-xfs@archiver.kernel.org>; Fri,  7 Feb 2020 13:16:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgBGNQo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 7 Feb 2020 08:16:44 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:29610 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726674AbgBGNQo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Feb 2020 08:16:44 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 017DGda6120803
        for <linux-xfs@vger.kernel.org>; Fri, 7 Feb 2020 08:16:42 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2y0murm62y-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Fri, 07 Feb 2020 08:16:41 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Fri, 7 Feb 2020 13:16:37 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 7 Feb 2020 13:16:35 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 017DGY0I59572240
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 7 Feb 2020 13:16:34 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F92AAE051;
        Fri,  7 Feb 2020 13:16:34 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9267CAE045;
        Fri,  7 Feb 2020 13:16:33 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.102.23.88])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  7 Feb 2020 13:16:33 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 13/30] xfs: remove the xfs_inode argument to xfs_attr_get_ilocked
Date:   Fri, 07 Feb 2020 18:49:18 +0530
Organization: IBM
In-Reply-To: <20200129170310.51370-14-hch@lst.de>
References: <20200129170310.51370-1-hch@lst.de> <20200129170310.51370-14-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20020713-0012-0000-0000-00000384AA32
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20020713-0013-0000-0000-000021C11B67
Message-Id: <4456617.JWiNkdPKL8@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-07_01:2020-02-07,2020-02-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 impostorscore=0 suspectscore=1 bulkscore=0 spamscore=0 lowpriorityscore=0
 malwarescore=0 clxscore=1015 priorityscore=1501 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002070103
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday, January 29, 2020 10:32 PM Christoph Hellwig wrote: 
> The inode can easily be derived from the args structure.  Also
> don't bother with else statements after early returns.
>

The newly introduced changes logically match with the code flow that existed
earlier.

Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 15 +++++++--------
>  fs/xfs/libxfs/xfs_attr.h |  2 +-
>  fs/xfs/scrub/attr.c      |  2 +-
>  3 files changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 288b39e81efd..fd095e3d4a9a 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -77,19 +77,18 @@ xfs_inode_hasattr(
>   */
>  int
>  xfs_attr_get_ilocked(
> -	struct xfs_inode	*ip,
>  	struct xfs_da_args	*args)
>  {
> -	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
> +	ASSERT(xfs_isilocked(args->dp, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
> 
> -	if (!xfs_inode_hasattr(ip))
> +	if (!xfs_inode_hasattr(args->dp))
>  		return -ENOATTR;
> -	else if (ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL)
> +
> +	if (args->dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL)
>  		return xfs_attr_shortform_getvalue(args);
> -	else if (xfs_bmap_one_block(ip, XFS_ATTR_FORK))
> +	if (xfs_bmap_one_block(args->dp, XFS_ATTR_FORK))
>  		return xfs_attr_leaf_get(args);
> -	else
> -		return xfs_attr_node_get(args);
> +	return xfs_attr_node_get(args);
>  }
> 
>  /*
> @@ -133,7 +132,7 @@ xfs_attr_get(
>  		args->op_flags |= XFS_DA_OP_ALLOCVAL;
> 
>  	lock_mode = xfs_ilock_attr_map_shared(args->dp);
> -	error = xfs_attr_get_ilocked(args->dp, args);
> +	error = xfs_attr_get_ilocked(args);
>  	xfs_iunlock(args->dp, lock_mode);
> 
>  	/* on error, we have to clean up allocated value buffers */
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index be77d13a2902..b8c4ed27f626 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -145,7 +145,7 @@ int xfs_attr_inactive(struct xfs_inode *dp);
>  int xfs_attr_list_int_ilocked(struct xfs_attr_list_context *);
>  int xfs_attr_list_int(struct xfs_attr_list_context *);
>  int xfs_inode_hasattr(struct xfs_inode *ip);
> -int xfs_attr_get_ilocked(struct xfs_inode *ip, struct xfs_da_args *args);
> +int xfs_attr_get_ilocked(struct xfs_da_args *args);
>  int xfs_attr_get(struct xfs_da_args *args);
>  int xfs_attr_set(struct xfs_da_args *args);
>  int xfs_attr_set_args(struct xfs_da_args *args);
> diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
> index d804558cdbca..f983c2b969e0 100644
> --- a/fs/xfs/scrub/attr.c
> +++ b/fs/xfs/scrub/attr.c
> @@ -162,7 +162,7 @@ xchk_xattr_listent(
>  	args.value = xchk_xattr_valuebuf(sx->sc);
>  	args.valuelen = valuelen;
> 
> -	error = xfs_attr_get_ilocked(context->dp, &args);
> +	error = xfs_attr_get_ilocked(&args);
>  	if (!xchk_fblock_process_error(sx->sc, XFS_ATTR_FORK, args.blkno,
>  			&error))
>  		goto fail_xref;
> 


-- 
chandan



