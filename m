Return-Path: <SRS0=tkkj=YB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F392C4360C
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Oct 2019 16:12:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4469B21721
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Oct 2019 16:12:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OfE7paoy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbfJHQL7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Oct 2019 12:11:59 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42032 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbfJHQL7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Oct 2019 12:11:59 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x98FsNQ3164303;
        Tue, 8 Oct 2019 16:11:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=JIQ/ImRdfLpOWb0AXX8Cx4ksJ8ooU/TX27tmUOsgXq0=;
 b=OfE7paoyGdYluW5UYuK/A4iCuj4FCrViPOkK97TsdJ70btVvx4DtpriifUIPq+u++68u
 qYFQMIxRWuMpFd8Kw3xwkHflUOw+8abDs9RshtBzRa+9uBokgsjDID2u7HeR5Q0dlamw
 ZHIybmVaR19kiaeMvTwxbtmmyWoARNiOOlwfqSOrcMpAET7g1y3U8Q4XbB94y3iyWQx6
 fZwr+QSFz5s275HRGO1tlW7VpnvFGv8i5QqrOCOY8zORgK7fOz36J9yH+Vo4lzX+fyb8
 uPdfLvmAI4SuCyC8vq6w0WeR3RJHXfOlGpsW7K7CnFh6ApynDNlesMPC+zLEDms6KKo1 gg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2vejkued5v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Oct 2019 16:11:43 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x98Fqg00098220;
        Tue, 8 Oct 2019 16:11:42 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2vg1yw7d80-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Oct 2019 16:11:42 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x98GBgSd019927;
        Tue, 8 Oct 2019 16:11:42 GMT
Received: from localhost (/10.159.136.81)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 08 Oct 2019 09:11:41 -0700
Date:   Tue, 8 Oct 2019 09:11:40 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 3/3] xfs: move local to extent inode logging into bmap
 helper
Message-ID: <20191008161140.GE13108@magnolia>
References: <20191007131938.23839-1-bfoster@redhat.com>
 <20191007131938.23839-4-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191007131938.23839-4-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9404 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910080137
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9404 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910080137
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 07, 2019 at 09:19:38AM -0400, Brian Foster wrote:
> The callers of xfs_bmap_local_to_extents_empty() log the inode
> external to the function, yet this function is where the on-disk
> format value is updated. Push the inode logging down into the
> function itself to help prevent future mistakes.
> 
> Note that internal bmap callers track the inode logging flags
> independently and thus may log the inode core twice due to this
> change. This is harmless, so leave this code around for consistency
> with the other attr fork conversion functions.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c  | 3 +--
>  fs/xfs/libxfs/xfs_bmap.c       | 6 ++++--
>  fs/xfs/libxfs/xfs_bmap.h       | 3 ++-
>  fs/xfs/libxfs/xfs_dir2_block.c | 3 +--
>  4 files changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 1b956c313b6b..f0089e862216 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -826,8 +826,7 @@ xfs_attr_shortform_to_leaf(
>  	sf = (xfs_attr_shortform_t *)tmpbuffer;
>  
>  	xfs_idata_realloc(dp, -size, XFS_ATTR_FORK);
> -	xfs_bmap_local_to_extents_empty(dp, XFS_ATTR_FORK);
> -	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE);
> +	xfs_bmap_local_to_extents_empty(args->trans, dp, XFS_ATTR_FORK);
>  
>  	bp = NULL;
>  	error = xfs_da_grow_inode(args, &blkno);
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 4edc25a2ba80..02469d59c787 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -792,6 +792,7 @@ xfs_bmap_extents_to_btree(
>   */
>  void
>  xfs_bmap_local_to_extents_empty(
> +	struct xfs_trans	*tp,
>  	struct xfs_inode	*ip,
>  	int			whichfork)
>  {
> @@ -808,6 +809,7 @@ xfs_bmap_local_to_extents_empty(
>  	ifp->if_u1.if_root = NULL;
>  	ifp->if_height = 0;
>  	XFS_IFORK_FMT_SET(ip, whichfork, XFS_DINODE_FMT_EXTENTS);
> +	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  }
>  
>  
> @@ -840,7 +842,7 @@ xfs_bmap_local_to_extents(
>  	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_LOCAL);
>  
>  	if (!ifp->if_bytes) {
> -		xfs_bmap_local_to_extents_empty(ip, whichfork);
> +		xfs_bmap_local_to_extents_empty(tp, ip, whichfork);
>  		flags = XFS_ILOG_CORE;
>  		goto done;
>  	}
> @@ -887,7 +889,7 @@ xfs_bmap_local_to_extents(
>  
>  	/* account for the change in fork size */
>  	xfs_idata_realloc(ip, -ifp->if_bytes, whichfork);
> -	xfs_bmap_local_to_extents_empty(ip, whichfork);
> +	xfs_bmap_local_to_extents_empty(tp, ip, whichfork);
>  	flags |= XFS_ILOG_CORE;
>  
>  	ifp->if_u1.if_root = NULL;
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index 5bb446d80542..e2798c6f3a5f 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -182,7 +182,8 @@ void	xfs_trim_extent(struct xfs_bmbt_irec *irec, xfs_fileoff_t bno,
>  		xfs_filblks_t len);
>  int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
>  int	xfs_bmap_set_attrforkoff(struct xfs_inode *ip, int size, int *version);
> -void	xfs_bmap_local_to_extents_empty(struct xfs_inode *ip, int whichfork);
> +void	xfs_bmap_local_to_extents_empty(struct xfs_trans *tp,
> +		struct xfs_inode *ip, int whichfork);
>  void	__xfs_bmap_add_free(struct xfs_trans *tp, xfs_fsblock_t bno,
>  		xfs_filblks_t len, const struct xfs_owner_info *oinfo,
>  		bool skip_discard);
> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
> index 3d1e5f6d64fd..49e4bc39e7bb 100644
> --- a/fs/xfs/libxfs/xfs_dir2_block.c
> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
> @@ -1096,9 +1096,8 @@ xfs_dir2_sf_to_block(
>  	memcpy(sfp, oldsfp, ifp->if_bytes);
>  
>  	xfs_idata_realloc(dp, -ifp->if_bytes, XFS_DATA_FORK);
> -	xfs_bmap_local_to_extents_empty(dp, XFS_DATA_FORK);
> +	xfs_bmap_local_to_extents_empty(tp, dp, XFS_DATA_FORK);
>  	dp->i_d.di_size = 0;
> -	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
>  
>  	/*
>  	 * Add block 0 to the inode.
> -- 
> 2.20.1
> 
