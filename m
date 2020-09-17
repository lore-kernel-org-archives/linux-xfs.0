Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF48BC43461
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 05:05:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 898792078D
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 05:05:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PfGKKTW3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgIQFFL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 01:05:11 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36226 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbgIQFFK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 01:05:10 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08GNsmSB141541;
        Thu, 17 Sep 2020 00:10:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=MKrNKwE7FxlymFq0/bip/Zy1PpJMv6dF0ypCGbojydE=;
 b=PfGKKTW3kIRNKzeRsz1fR38Izqm/bAIKi3G0AoBHo1qwZ8LePljaHzZHY5ZvaoMcvIWe
 3r3km91K1kdM/jgjRsPXvPukiMkKW+44M5h5k3KzxMsDX0p58stYxA5S1DGwj+W87wY+
 AdQw8TZ9RG+RToaRDWRSOgtlsOI0mDj0LXIuCSKUK7j4oW11ImYh+2VsWgujleligKUn
 5S5gFKbJl8RNwk7wwT2R7SlpiA1sPO203SkYBkrPt0YL2O0Hc7MwZRi3dU2vTZlQIPCY
 Dw+ALOVPZlFW9zQMuAo8KExoVR/RH1O0shmwVQnnnbcuMzqNf87dcVvu5PEv8YCzy0z9 kA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 33j91dqptg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Sep 2020 00:10:45 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08GNsmWl019869;
        Thu, 17 Sep 2020 00:10:44 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 33h892pxqg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 00:10:44 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08H0AhCC002948;
        Thu, 17 Sep 2020 00:10:43 GMT
Received: from localhost (/10.159.158.133)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Sep 2020 00:10:43 +0000
Date:   Wed, 16 Sep 2020 17:10:42 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] xfs: do the assert for all the log done items in
 xfs_trans_cancel
Message-ID: <20200917001042.GP7955@magnolia>
References: <1600255152-16086-1-git-send-email-kaixuxia@tencent.com>
 <1600255152-16086-5-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600255152-16086-5-git-send-email-kaixuxia@tencent.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=3 mlxscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009160177
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=3 mlxlogscore=999
 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009160177
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 16, 2020 at 07:19:07PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> We should do the assert for all the log done items if they appear
> here. This patch also add the XFS_ITEM_LOG_DONE flag to check if
> the item is a log done item.
> 
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
> ---
>  fs/xfs/xfs_bmap_item.c     | 2 +-
>  fs/xfs/xfs_extfree_item.c  | 2 +-
>  fs/xfs/xfs_refcount_item.c | 2 +-
>  fs/xfs/xfs_rmap_item.c     | 2 +-
>  fs/xfs/xfs_trans.c         | 2 +-
>  fs/xfs/xfs_trans.h         | 4 ++++
>  6 files changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index ec3691372e7c..2e49f48666f1 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -202,7 +202,7 @@ xfs_bud_item_release(
>  }
>  
>  static const struct xfs_item_ops xfs_bud_item_ops = {
> -	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
> +	.flags		= XFS_ITEM_LOG_DONE_FLAG,
>  	.iop_size	= xfs_bud_item_size,
>  	.iop_format	= xfs_bud_item_format,
>  	.iop_release	= xfs_bud_item_release,
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 6cb8cd11072a..f2c6cb67262e 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -307,7 +307,7 @@ xfs_efd_item_release(
>  }
>  
>  static const struct xfs_item_ops xfs_efd_item_ops = {
> -	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
> +	.flags		= XFS_ITEM_LOG_DONE_FLAG,
>  	.iop_size	= xfs_efd_item_size,
>  	.iop_format	= xfs_efd_item_format,
>  	.iop_release	= xfs_efd_item_release,
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index ca93b6488377..551bcc93acdd 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -208,7 +208,7 @@ xfs_cud_item_release(
>  }
>  
>  static const struct xfs_item_ops xfs_cud_item_ops = {
> -	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
> +	.flags		= XFS_ITEM_LOG_DONE_FLAG,
>  	.iop_size	= xfs_cud_item_size,
>  	.iop_format	= xfs_cud_item_format,
>  	.iop_release	= xfs_cud_item_release,
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index dc5b0753cd51..427f90ef4509 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -231,7 +231,7 @@ xfs_rud_item_release(
>  }
>  
>  static const struct xfs_item_ops xfs_rud_item_ops = {
> -	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
> +	.flags		= XFS_ITEM_LOG_DONE_FLAG,
>  	.iop_size	= xfs_rud_item_size,
>  	.iop_format	= xfs_rud_item_format,
>  	.iop_release	= xfs_rud_item_release,
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 4257fdb03778..d33d0ba6f3bd 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -1050,7 +1050,7 @@ xfs_trans_cancel(
>  		struct xfs_log_item *lip;
>  
>  		list_for_each_entry(lip, &tp->t_items, li_trans)
> -			ASSERT(!(lip->li_type == XFS_LI_EFD));
> +			ASSERT(!(lip->li_ops->flags & XFS_ITEM_LOG_DONE));
>  	}
>  #endif
>  	xfs_trans_unreserve_and_mod_sb(tp);
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index 7fb82eb92e65..b92138b13c40 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -85,6 +85,10 @@ struct xfs_item_ops {
>   * intents that never need to be written back in place.
>   */
>  #define XFS_ITEM_RELEASE_WHEN_COMMITTED	(1 << 0)
> +#define XFS_ITEM_LOG_DONE		(1 << 1)	/* log done item */
> +
> +#define XFS_ITEM_LOG_DONE_FLAG	(XFS_ITEM_RELEASE_WHEN_COMMITTED | \
> +				 XFS_ITEM_LOG_DONE)

Please don't go adding more flags for a debugging check.

You /could/ just detect intent-done items by the fact that their item
ops don't have unpin or push methods, kind of like what we do for
detecting intent items in log recovery.

Oh wait, you mowed /that/ down too.

--D

>  
>  void	xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *item,
>  			  int type, const struct xfs_item_ops *ops);
> -- 
> 2.20.0
> 
