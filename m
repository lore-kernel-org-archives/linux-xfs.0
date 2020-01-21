Return-Path: <SRS0=uPG+=3K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E2D5C2D0CE
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 18:13:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1405424672
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 18:13:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VrnfdEMb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729186AbgAUSNg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jan 2020 13:13:36 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:46648 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728829AbgAUSNg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jan 2020 13:13:36 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LI8OLZ191805;
        Tue, 21 Jan 2020 18:13:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=84nRUu6NnJ14bVz5Nbw5o8vuI4YWyppPY+LjJyanBDk=;
 b=VrnfdEMbb4LLXPLNE/Hs5QIBL0J+boZEibm3fnawnl8tHIgGfJOIZy9AYV5ssN5k2PmK
 s4sK+ME5xpG/EmXDrOYb/p/V95gv2UrsKMRbCM0YrIdhiHFtwQm4lM53Mxd41W+dkWzD
 K+6Lovns6zTFhszaixyOOEzwTi/36NxfpTkIe9muJxNC0Z9UB+MXeva084LsAdkXwa9V
 GM/F4Rd/FC+vB4T1seBg7mIVMSLt0H4JixnlrOsc5P0dRrBOUpw0CK22Qoa1j5UtN8Mq
 dpurvONimMmHZKy4MnhCp1nFYnE1ftI8Ew3rMMMiMID9IuXPsOiLzvZCw98QjdmNSBRB XQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2xkseueygj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 18:13:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LI8rfa033698;
        Tue, 21 Jan 2020 18:13:31 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2xnpef8c95-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 18:13:31 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00LIDVYH001535;
        Tue, 21 Jan 2020 18:13:31 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jan 2020 10:13:31 -0800
Date:   Tue, 21 Jan 2020 10:13:29 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 12/29] xfs: remove the xfs_inode argument to
 xfs_attr_get_ilocked
Message-ID: <20200121181329.GL8247@magnolia>
References: <20200114081051.297488-1-hch@lst.de>
 <20200114081051.297488-13-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114081051.297488-13-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001210138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001210138
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 14, 2020 at 09:10:34AM +0100, Christoph Hellwig wrote:
> The inode can easily be derived from the args structure.  Also
> don't bother with else statements after early returns.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c | 15 +++++++--------
>  fs/xfs/libxfs/xfs_attr.h |  2 +-
>  fs/xfs/scrub/attr.c      |  2 +-
>  3 files changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 4aaec6304f98..09954c0e8456 100644
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
> -- 
> 2.24.1
> 
