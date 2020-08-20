Return-Path: <SRS0=hW3p=B6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D15E2C433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Aug 2020 19:15:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7B01208B3
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Aug 2020 19:15:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pJSOA1Tl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbgHTTPE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Aug 2020 15:15:04 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38272 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726702AbgHTTPC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Aug 2020 15:15:02 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07KJD3Er117807;
        Thu, 20 Aug 2020 19:14:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=AJaSn7jW1nIO7hhqgU6Zh40UEMmCIRfzvkCqsRFqD9c=;
 b=pJSOA1TlztMW2yP8B0KB46lGeliBQihfK28SUQ+rbXZXfpvWzRiPmGYewoOseV3GN3pW
 NTHkrA938hSX9okI1GCZnyZQMGMXbENWOk0Hvg5dUJhR3hTw4BmV4ZaYQvC5AKhcLVzY
 wS54SFq0UF2OiIishf7+SliVh19d9U9ef5q4MwD3Ymb1c1BfDY2c8CHzwrcgoCJp5iiF
 YTeCof+nB5klbTAI2iPBZ0wvHmSfRTDxjbgheacePJ0mCZMsWvISjnFn/ll+wsFkc2hC
 iyT90akF2F1ZZl9f7LtHMYctZgshYbQBtNHa64Oj1SaFP95/t+u2cFb7njxnOhXjFEE3 8A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 32x8bnjcgb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 20 Aug 2020 19:14:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07KJ3r3G166599;
        Thu, 20 Aug 2020 19:12:50 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 330pvpv245-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Aug 2020 19:12:50 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07KJCmBi019390;
        Thu, 20 Aug 2020 19:12:48 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 20 Aug 2020 12:12:38 -0700
Date:   Thu, 20 Aug 2020 12:12:37 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Miaohe Lin <linmiaohe@huawei.com>
Cc:     cmaiolino@redhat.com, dchinner@redhat.com, bfoster@redhat.com,
        chandanrlinux@gmail.com, sandeen@redhat.com,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.orge
Subject: Re: [PATCH] xfs: Convert to use the preferred fallthrough macro
Message-ID: <20200820191237.GK6096@magnolia>
References: <20200820114531.47465-1-linmiaohe@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820114531.47465-1-linmiaohe@huawei.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9718 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 malwarescore=0 adultscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008200151
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9718 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 clxscore=1011 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008200152
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 20, 2020 at 07:45:31AM -0400, Miaohe Lin wrote:
> Convert the uses of fallthrough comments to fallthrough macro. Please see
> commit 294f69e662d1 ("compiler_attributes.h: Add 'fallthrough' pseudo
> keyword for switch/case use") for detail.
> 
> Signed-off-by: Hongxiang Lou <louhongxiang@huawei.com>
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>

NAK.

From the /previous/ attempt[0] to shovel in this compliance bullshit[1]
that will do nothing but increase the cost of rebasing developers'
trees, I'll just wait until "...the C17/C18 [[fallthrough]] syntax is
more commonly supported by C compilers, static analyzers, and IDEs,
[and] switch to using that syntax".  Then I only have to accept the cost
of this *once*.

If you feel really passionate about ramming a bunch of pointless churn
into the kernel tree to make my life more painful, send this to Linus
and let him make the change.

--D

[0] https://lore.kernel.org/linux-xfs/20200707200504.GA4796@embeddedor/

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html?highlight=fallthrough#implicit-switch-case-fall-through

> ---
>  fs/xfs/libxfs/xfs_ag_resv.c  | 4 ++--
>  fs/xfs/libxfs/xfs_da_btree.c | 2 +-
>  fs/xfs/scrub/bmap.c          | 2 +-
>  fs/xfs/scrub/btree.c         | 2 +-
>  fs/xfs/scrub/common.c        | 6 +++---
>  fs/xfs/scrub/dabtree.c       | 2 +-
>  fs/xfs/scrub/repair.c        | 2 +-
>  fs/xfs/xfs_bmap_util.c       | 2 +-
>  fs/xfs/xfs_file.c            | 2 +-
>  fs/xfs/xfs_fsmap.c           | 2 +-
>  fs/xfs/xfs_ioctl.c           | 2 +-
>  fs/xfs/xfs_trans_buf.c       | 2 +-
>  12 files changed, 15 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
> index fdfe6dc0d307..0b061a027e4e 100644
> --- a/fs/xfs/libxfs/xfs_ag_resv.c
> +++ b/fs/xfs/libxfs/xfs_ag_resv.c
> @@ -338,7 +338,7 @@ xfs_ag_resv_alloc_extent(
>  		break;
>  	default:
>  		ASSERT(0);
> -		/* fall through */
> +		fallthrough;
>  	case XFS_AG_RESV_NONE:
>  		field = args->wasdel ? XFS_TRANS_SB_RES_FDBLOCKS :
>  				       XFS_TRANS_SB_FDBLOCKS;
> @@ -380,7 +380,7 @@ xfs_ag_resv_free_extent(
>  		break;
>  	default:
>  		ASSERT(0);
> -		/* fall through */
> +		fallthrough;
>  	case XFS_AG_RESV_NONE:
>  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, (int64_t)len);
>  		return;
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index e46bc03365db..5a13bfe0ebbf 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -282,7 +282,7 @@ xfs_da3_node_read_verify(
>  						__this_address);
>  				break;
>  			}
> -			/* fall through */
> +			fallthrough;
>  		case XFS_DA_NODE_MAGIC:
>  			fa = xfs_da3_node_verify(bp);
>  			if (fa)
> diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> index 955302e7cdde..6abd469d49d2 100644
> --- a/fs/xfs/scrub/bmap.c
> +++ b/fs/xfs/scrub/bmap.c
> @@ -270,7 +270,7 @@ xchk_bmap_iextent_xref(
>  	case XFS_DATA_FORK:
>  		if (xfs_is_reflink_inode(info->sc->ip))
>  			break;
> -		/* fall through */
> +		fallthrough;
>  	case XFS_ATTR_FORK:
>  		xchk_xref_is_not_shared(info->sc, agbno,
>  				irec->br_blockcount);
> diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
> index f52a7b8256f9..990a379fc322 100644
> --- a/fs/xfs/scrub/btree.c
> +++ b/fs/xfs/scrub/btree.c
> @@ -43,7 +43,7 @@ __xchk_btree_process_error(
>  		/* Note the badness but don't abort. */
>  		sc->sm->sm_flags |= errflag;
>  		*error = 0;
> -		/* fall through */
> +		fallthrough;
>  	default:
>  		if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
>  			trace_xchk_ifork_btree_op_error(sc, cur, level,
> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> index 18876056e5e0..63f13c8ed8c7 100644
> --- a/fs/xfs/scrub/common.c
> +++ b/fs/xfs/scrub/common.c
> @@ -81,7 +81,7 @@ __xchk_process_error(
>  		/* Note the badness but don't abort. */
>  		sc->sm->sm_flags |= errflag;
>  		*error = 0;
> -		/* fall through */
> +		fallthrough;
>  	default:
>  		trace_xchk_op_error(sc, agno, bno, *error,
>  				ret_ip);
> @@ -134,7 +134,7 @@ __xchk_fblock_process_error(
>  		/* Note the badness but don't abort. */
>  		sc->sm->sm_flags |= errflag;
>  		*error = 0;
> -		/* fall through */
> +		fallthrough;
>  	default:
>  		trace_xchk_file_op_error(sc, whichfork, offset, *error,
>  				ret_ip);
> @@ -713,7 +713,7 @@ xchk_get_inode(
>  		if (error)
>  			return -ENOENT;
>  		error = -EFSCORRUPTED;
> -		/* fall through */
> +		fallthrough;
>  	default:
>  		trace_xchk_op_error(sc,
>  				XFS_INO_TO_AGNO(mp, sc->sm->sm_ino),
> diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
> index e56786f0a13c..2b3fb0b37e18 100644
> --- a/fs/xfs/scrub/dabtree.c
> +++ b/fs/xfs/scrub/dabtree.c
> @@ -47,7 +47,7 @@ xchk_da_process_error(
>  		/* Note the badness but don't abort. */
>  		sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
>  		*error = 0;
> -		/* fall through */
> +		fallthrough;
>  	default:
>  		trace_xchk_file_op_error(sc, ds->dargs.whichfork,
>  				xfs_dir2_da_to_db(ds->dargs.geo,
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index 25e86c71e7b9..c814b18efba9 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -944,7 +944,7 @@ xrep_ino_dqattach(
>  			xrep_force_quotacheck(sc, XFS_DQTYPE_GROUP);
>  		if (XFS_IS_PQUOTA_ON(sc->mp) && !sc->ip->i_pdquot)
>  			xrep_force_quotacheck(sc, XFS_DQTYPE_PROJ);
> -		/* fall through */
> +		fallthrough;
>  	case -ESRCH:
>  		error = 0;
>  		break;
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 73cafc843cd7..6045cc20b0fb 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -244,7 +244,7 @@ xfs_bmap_count_blocks(
>  		 */
>  		*count += btblocks - 1;
>  
> -		/* fall through */
> +		fallthrough;
>  	case XFS_DINODE_FMT_EXTENTS:
>  		*nextents = xfs_bmap_count_leaves(ifp, count);
>  		break;
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index c31cd3be9fb2..976306724093 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -772,7 +772,7 @@ xfs_break_layouts(
>  			error = xfs_break_dax_layouts(inode, &retry);
>  			if (error || retry)
>  				break;
> -			/* fall through */
> +			fallthrough;
>  		case BREAK_WRITE:
>  			error = xfs_break_leased_layouts(inode, iolock, &retry);
>  			break;
> diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> index 4eebcec4aae6..c334550aeea7 100644
> --- a/fs/xfs/xfs_fsmap.c
> +++ b/fs/xfs/xfs_fsmap.c
> @@ -100,7 +100,7 @@ xfs_fsmap_owner_to_rmap(
>  		dest->rm_owner = XFS_RMAP_OWN_COW;
>  		break;
>  	case XFS_FMR_OWN_DEFECTIVE:	/* not implemented */
> -		/* fall through */
> +		fallthrough;
>  	default:
>  		return -EINVAL;
>  	}
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 6f22a66777cd..85d6631f7e99 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -557,7 +557,7 @@ xfs_ioc_attrmulti_one(
>  	case ATTR_OP_REMOVE:
>  		value = NULL;
>  		*len = 0;
> -		/* fall through */
> +		fallthrough;
>  	case ATTR_OP_SET:
>  		error = mnt_want_write_file(parfilp);
>  		if (error)
> diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> index 11cd666cd99a..86ba71580ffd 100644
> --- a/fs/xfs/xfs_trans_buf.c
> +++ b/fs/xfs/xfs_trans_buf.c
> @@ -310,7 +310,7 @@ xfs_trans_read_buf_map(
>  	default:
>  		if (tp && (tp->t_flags & XFS_TRANS_DIRTY))
>  			xfs_force_shutdown(tp->t_mountp, SHUTDOWN_META_IO_ERROR);
> -		/* fall through */
> +		fallthrough;
>  	case -ENOMEM:
>  	case -EAGAIN:
>  		return error;
> -- 
> 2.19.1
> 
