Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EDA3C47253
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 18:59:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3293F2073E
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 18:59:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Yz9DZv93"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgD3S7E (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 14:59:04 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53594 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726375AbgD3S7E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 14:59:04 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UInvHr064130;
        Thu, 30 Apr 2020 18:58:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=z7OiV1PAiNx8vXf641tRswVVmKm28isN++2LR/vxzqU=;
 b=Yz9DZv93ORap7xUekxrkiB84KT5vyhE3BLO8muY0oND1Hrg1rSQw7VZgeX17ReFvBR+I
 OPPh/CPf2cB9D9O+2cOZZJICCz64Lx9G+oziFjEWt9nJHFAa5kghCfeLqlOnCCqACpZS
 nvCWLA+J0JNqXXk54BYO1X9XUrOiLyeprWE5/k/gU4NNaKdu0TwKuLFCdcv5ZmAaMHkp
 qcU7gV7ogwOf2truuLG5n+lI3iVV16vtW3q5bg3iwYgBJKk7noD2sedY8qY5mw+gYd7d
 8E+X4yc8IWPQiKP9nSck6BpswmniBMTh+Be/6a8kGfSVsyqOQXJrww3AL79MoMNTzDcT Gg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30p2p0jrbm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 18:58:59 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UIkT2D052550;
        Thu, 30 Apr 2020 18:58:58 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 30qtkx11rs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 18:58:58 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03UIwuRG020401;
        Thu, 30 Apr 2020 18:58:57 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 11:58:56 -0700
Date:   Thu, 30 Apr 2020 11:58:55 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 14/17] xfs: remove unused iflush stale parameter
Message-ID: <20200430185855.GO6742@magnolia>
References: <20200429172153.41680-1-bfoster@redhat.com>
 <20200429172153.41680-15-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429172153.41680-15-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 clxscore=1015
 bulkscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300145
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 29, 2020 at 01:21:50PM -0400, Brian Foster wrote:
> The stale parameter was used to control the now unused shutdown
> parameter of xfs_trans_ail_remove().
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks good,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_icache.c     | 2 +-
>  fs/xfs/xfs_inode.c      | 2 +-
>  fs/xfs/xfs_inode_item.c | 7 +++----
>  fs/xfs/xfs_inode_item.h | 2 +-
>  4 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 8bf1d15be3f6..7032efcb6814 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1128,7 +1128,7 @@ xfs_reclaim_inode(
>  	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
>  		xfs_iunpin_wait(ip);
>  		/* xfs_iflush_abort() drops the flush lock */
> -		xfs_iflush_abort(ip, false);
> +		xfs_iflush_abort(ip);
>  		goto reclaim;
>  	}
>  	if (xfs_ipincount(ip)) {
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 6fb3e26afa8b..e0d9a5bf7507 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3702,7 +3702,7 @@ xfs_iflush(
>  	return 0;
>  
>  abort:
> -	xfs_iflush_abort(ip, false);
> +	xfs_iflush_abort(ip);
>  shutdown:
>  	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
>  	return error;
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 1a02058178d1..cefa2484f0db 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -762,10 +762,9 @@ xfs_iflush_done(
>   */
>  void
>  xfs_iflush_abort(
> -	xfs_inode_t		*ip,
> -	bool			stale)
> +	struct xfs_inode		*ip)
>  {
> -	xfs_inode_log_item_t	*iip = ip->i_itemp;
> +	struct xfs_inode_log_item	*iip = ip->i_itemp;
>  
>  	if (iip) {
>  		xfs_trans_ail_delete(&iip->ili_item, 0);
> @@ -793,7 +792,7 @@ xfs_istale_done(
>  	struct xfs_buf		*bp,
>  	struct xfs_log_item	*lip)
>  {
> -	xfs_iflush_abort(INODE_ITEM(lip)->ili_inode, true);
> +	xfs_iflush_abort(INODE_ITEM(lip)->ili_inode);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
> index 07a60e74c39c..a68c114b79a0 100644
> --- a/fs/xfs/xfs_inode_item.h
> +++ b/fs/xfs/xfs_inode_item.h
> @@ -34,7 +34,7 @@ extern void xfs_inode_item_init(struct xfs_inode *, struct xfs_mount *);
>  extern void xfs_inode_item_destroy(struct xfs_inode *);
>  extern void xfs_iflush_done(struct xfs_buf *, struct xfs_log_item *);
>  extern void xfs_istale_done(struct xfs_buf *, struct xfs_log_item *);
> -extern void xfs_iflush_abort(struct xfs_inode *, bool);
> +extern void xfs_iflush_abort(struct xfs_inode *);
>  extern int xfs_inode_item_format_convert(xfs_log_iovec_t *,
>  					 struct xfs_inode_log_format *);
>  
> -- 
> 2.21.1
> 
