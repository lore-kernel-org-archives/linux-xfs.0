Return-Path: <SRS0=dccG=B5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5695C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Aug 2020 00:32:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFFE1207BB
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Aug 2020 00:32:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cV4jT1O0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbgHSAca (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 20:32:30 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34690 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbgHSAc3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 20:32:29 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07J0NCCi104035;
        Wed, 19 Aug 2020 00:32:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=QuH2ZHWijofOuv9qxxl+PaUCXx7y39sOhNrSx/pqsAE=;
 b=cV4jT1O0uq4q1U3Bx8Gyqnm2zosZVYUXmfxTVR8rOm1+zLoXcvjPqPfXR0ZWYKuLnaAh
 lwLHzUAUiWq574qJpJDEg1htG1DcQGuzboaukSIRQNSYu3Bmx7pOszdQfQYg5WZ8tuwj
 8S4hVlLWCF/k1OTFPM4TeW1mxjjmuZadJJ9CVPGaTe2QQPJX4LyJ3XLCrF6C+RsxJYV9
 wZiLtV4w0Mz4BIks1D+T1LypKQb5bXlQkxXn+HXfldLmW1240f4sT+5rmY9rR0GWFzme
 BgPfZX8NK6j1adT3mX+xxhzUKqIN6fwyaBHN3gcx4jvLxF4BMsuy2Fnyc+JA3jSHG9Zo Mg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 32x8bn7tks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 19 Aug 2020 00:32:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07J0SFF5118330;
        Wed, 19 Aug 2020 00:30:26 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 32xsfsgsbh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Aug 2020 00:30:26 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07J0UPfb009366;
        Wed, 19 Aug 2020 00:30:26 GMT
Received: from localhost (/10.159.129.94)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Aug 2020 17:30:25 -0700
Date:   Tue, 18 Aug 2020 17:30:24 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/13] xfs: combine iunlink inode update functions
Message-ID: <20200819003024.GY6096@magnolia>
References: <20200812092556.2567285-1-david@fromorbit.com>
 <20200812092556.2567285-12-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200812092556.2567285-12-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 spamscore=0 suspectscore=1 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008190002
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=1 adultscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008190001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 12, 2020 at 07:25:54PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Combine the logging of the inode unlink list update into the
> calling function that looks up the buffer we end up logging. These
> do not need to be separate functions as they are both short, simple
> operations and there's only a single call path through them. This
> new function will end up being the core of the iunlink log item
> processing...
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

This was pretty easy to follow,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_inode.c | 58 ++++++++++++++++------------------------------
>  1 file changed, 20 insertions(+), 38 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 4f616e1b64dc..82242d15b1d7 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1972,38 +1972,12 @@ xfs_iunlink_update_bucket(
>  	return 0;
>  }
>  
> -/* Set an on-disk inode's next_unlinked pointer. */
> -STATIC void
> -xfs_iunlink_update_dinode(
> -	struct xfs_trans	*tp,
> -	xfs_agnumber_t		agno,
> -	xfs_agino_t		agino,
> -	struct xfs_buf		*ibp,
> -	struct xfs_dinode	*dip,
> -	struct xfs_imap		*imap,
> -	xfs_agino_t		next_agino)
> -{
> -	struct xfs_mount	*mp = tp->t_mountp;
> -	int			offset;
> -
> -	ASSERT(xfs_verify_agino_or_null(mp, agno, next_agino));
> -
> -	trace_xfs_iunlink_update_dinode(mp, agno, agino,
> -			be32_to_cpu(dip->di_next_unlinked), next_agino);
> -
> -	dip->di_next_unlinked = cpu_to_be32(next_agino);
> -	offset = imap->im_boffset +
> -			offsetof(struct xfs_dinode, di_next_unlinked);
> -
> -	/* need to recalc the inode CRC if appropriate */
> -	xfs_dinode_calc_crc(mp, dip);
> -	xfs_trans_inode_buf(tp, ibp);
> -	xfs_trans_log_buf(tp, ibp, offset, offset + sizeof(xfs_agino_t) - 1);
> -}
> -
> -/* Set an in-core inode's unlinked pointer and return the old value. */
> +/*
> + * Look up the inode cluster buffer and log the on-disk unlinked inode change
> + * we need to make.
> + */
>  STATIC int
> -xfs_iunlink_update_inode(
> +xfs_iunlink_log_inode(
>  	struct xfs_trans	*tp,
>  	struct xfs_inode	*ip,
>  	xfs_agnumber_t		agno,
> @@ -2013,6 +1987,7 @@ xfs_iunlink_update_inode(
>  	struct xfs_mount	*mp = tp->t_mountp;
>  	struct xfs_dinode	*dip;
>  	struct xfs_buf		*ibp;
> +	int			offset;
>  	int			error;
>  
>  	ASSERT(xfs_verify_agino_or_null(mp, agno, next_agino));
> @@ -2028,9 +2003,17 @@ xfs_iunlink_update_inode(
>  		return -EFSCORRUPTED;
>  	}
>  
> -	/* Ok, update the new pointer. */
> -	xfs_iunlink_update_dinode(tp, agno, XFS_INO_TO_AGINO(mp, ip->i_ino),
> -			ibp, dip, &ip->i_imap, next_agino);
> +	trace_xfs_iunlink_update_dinode(mp, agno,
> +			XFS_INO_TO_AGINO(mp, ip->i_ino),
> +			be32_to_cpu(dip->di_next_unlinked), next_agino);
> +
> +	dip->di_next_unlinked = cpu_to_be32(next_agino);
> +	offset = ip->i_imap.im_boffset +
> +			offsetof(struct xfs_dinode, di_next_unlinked);
> +
> +	xfs_dinode_calc_crc(mp, dip);
> +	xfs_trans_inode_buf(tp, ibp);
> +	xfs_trans_log_buf(tp, ibp, offset, offset + sizeof(xfs_agino_t) - 1);
>  	return 0;
>  }
>  
> @@ -2056,7 +2039,7 @@ xfs_iunlink_insert_inode(
>  		 * inode to the current head of the list.
>  		 */
>  		next_agino = XFS_INO_TO_AGINO(mp, nip->i_ino);
> -		error = xfs_iunlink_update_inode(tp, ip, agno, NULLAGINO,
> +		error = xfs_iunlink_log_inode(tp, ip, agno, NULLAGINO,
>  						 next_agino);
>  		if (error)
>  			return error;
> @@ -2129,7 +2112,7 @@ xfs_iunlink_remove_inode(
>  	}
>  
>  	/* Clear the on disk next unlinked pointer for this inode. */
> -	error = xfs_iunlink_update_inode(tp, ip, agno, next_agino, NULLAGINO);
> +	error = xfs_iunlink_log_inode(tp, ip, agno, next_agino, NULLAGINO);
>  	if (error)
>  		return error;
>  
> @@ -2138,8 +2121,7 @@ xfs_iunlink_remove_inode(
>  					struct xfs_inode, i_unlink)) {
>  		struct xfs_inode *pip = list_prev_entry(ip, i_unlink);
>  
> -		return xfs_iunlink_update_inode(tp, pip, agno, agino,
> -						next_agino);
> +		return xfs_iunlink_log_inode(tp, pip, agno, agino, next_agino);
>  	}
>  
>  	/* Point the head of the list to the next unlinked inode. */
> -- 
> 2.26.2.761.g0e0b3e54be
> 
