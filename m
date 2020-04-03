Return-Path: <SRS0=euis=5T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A257EC43331
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Apr 2020 15:42:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FCEA20721
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Apr 2020 15:42:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="t7gi+pdq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404344AbgDCPmJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Apr 2020 11:42:09 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58270 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727927AbgDCPmJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Apr 2020 11:42:09 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033Fdtg9157508;
        Fri, 3 Apr 2020 15:42:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=mtcJymhz5hDizmlt2uQ86A2JrogqAw4WyC7M0j/o20g=;
 b=t7gi+pdq6w2KYEItTsVG7ux7rpzGBvH0gvctGH/daLqnMfk8L3hcZ/EaM/Sjkm7Hc8TM
 O4grVNyhM58WGLEBXIwgN/d+r+fKZaCdhroe5GIwpZ5dK51mJ000jHj4+YH4WQRM+SNe
 dQds/6zuBO3AMYVzCB0r/gAAwRf4lJlfqIUtGvHh8FH6PJ15qfjUWYNvyCXsDRTAxyXB
 D9y71YrlfnHoT4pH4dI4YWNRHS8dTcxhhI9RTGZcI6bZe9OKtH3SYxi/hh7hguiGCeJx
 CZxUaVE/ntnN/cNfgTmBHDAZKGUZ7ZoHE4JFOZcQkQeqt+8kp93zUWu8lQejtygUyw+w 0A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 303cevhsuq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Apr 2020 15:42:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033FbJZ3137064;
        Fri, 3 Apr 2020 15:42:04 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 304sjt4u7w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Apr 2020 15:42:04 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 033Fg3H2019688;
        Fri, 3 Apr 2020 15:42:03 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Apr 2020 08:42:02 -0700
Date:   Fri, 3 Apr 2020 08:42:02 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: factor out a new xfs_log_force_inode helper
Message-ID: <20200403154202.GM80283@magnolia>
References: <20200403125522.450299-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200403125522.450299-1-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 adultscore=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030134
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 03, 2020 at 02:55:21PM +0200, Christoph Hellwig wrote:
> Create a new helper to force the log up to the last LSN touching an
> inode.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks reasonable,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_export.c | 14 +-------------
>  fs/xfs/xfs_file.c   | 12 +-----------
>  fs/xfs/xfs_inode.c  | 19 +++++++++++++++++++
>  fs/xfs/xfs_inode.h  |  1 +
>  4 files changed, 22 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
> index f1372f9046e3..5a4b0119143a 100644
> --- a/fs/xfs/xfs_export.c
> +++ b/fs/xfs/xfs_export.c
> @@ -15,7 +15,6 @@
>  #include "xfs_trans.h"
>  #include "xfs_inode_item.h"
>  #include "xfs_icache.h"
> -#include "xfs_log.h"
>  #include "xfs_pnfs.h"
>  
>  /*
> @@ -221,18 +220,7 @@ STATIC int
>  xfs_fs_nfs_commit_metadata(
>  	struct inode		*inode)
>  {
> -	struct xfs_inode	*ip = XFS_I(inode);
> -	struct xfs_mount	*mp = ip->i_mount;
> -	xfs_lsn_t		lsn = 0;
> -
> -	xfs_ilock(ip, XFS_ILOCK_SHARED);
> -	if (xfs_ipincount(ip))
> -		lsn = ip->i_itemp->ili_last_lsn;
> -	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> -
> -	if (!lsn)
> -		return 0;
> -	return xfs_log_force_lsn(mp, lsn, XFS_LOG_SYNC, NULL);
> +	return xfs_log_force_inode(XFS_I(inode));
>  }
>  
>  const struct export_operations xfs_export_operations = {
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index b8a4a3f29b36..68e1cbb3cfcc 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -80,19 +80,9 @@ xfs_dir_fsync(
>  	int			datasync)
>  {
>  	struct xfs_inode	*ip = XFS_I(file->f_mapping->host);
> -	struct xfs_mount	*mp = ip->i_mount;
> -	xfs_lsn_t		lsn = 0;
>  
>  	trace_xfs_dir_fsync(ip);
> -
> -	xfs_ilock(ip, XFS_ILOCK_SHARED);
> -	if (xfs_ipincount(ip))
> -		lsn = ip->i_itemp->ili_last_lsn;
> -	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> -
> -	if (!lsn)
> -		return 0;
> -	return xfs_log_force_lsn(mp, lsn, XFS_LOG_SYNC, NULL);
> +	return xfs_log_force_inode(ip);
>  }
>  
>  STATIC int
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index c5077e6326c7..e48fc835cb85 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3951,3 +3951,22 @@ xfs_irele(
>  	trace_xfs_irele(ip, _RET_IP_);
>  	iput(VFS_I(ip));
>  }
> +
> +/*
> + * Ensure all commited transactions touching the inode are written to the log.
> + */
> +int
> +xfs_log_force_inode(
> +	struct xfs_inode	*ip)
> +{
> +	xfs_lsn_t		lsn = 0;
> +
> +	xfs_ilock(ip, XFS_ILOCK_SHARED);
> +	if (xfs_ipincount(ip))
> +		lsn = ip->i_itemp->ili_last_lsn;
> +	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> +
> +	if (!lsn)
> +		return 0;
> +	return xfs_log_force_lsn(ip->i_mount, lsn, XFS_LOG_SYNC, NULL);
> +}
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 492e53992fa9..c6a63f6764a6 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -426,6 +426,7 @@ int		xfs_itruncate_extents_flags(struct xfs_trans **,
>  				struct xfs_inode *, int, xfs_fsize_t, int);
>  void		xfs_iext_realloc(xfs_inode_t *, int, int);
>  
> +int		xfs_log_force_inode(struct xfs_inode *ip);
>  void		xfs_iunpin_wait(xfs_inode_t *);
>  #define xfs_ipincount(ip)	((unsigned int) atomic_read(&ip->i_pincount))
>  
> -- 
> 2.25.1
> 
