Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94301C38A24
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 15:15:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 691732083B
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 15:15:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lVjTz7oe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726356AbgEGPPY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 11:15:24 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44016 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbgEGPPW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 11:15:22 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 047FDnQV047207;
        Thu, 7 May 2020 15:15:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=toyfmOpj7c8BOaU+bNqn/na1Jo9e37+7EIqCUITdNDY=;
 b=lVjTz7oeD+NC/bdfG5pkav8XdmhEsLs+8gsjlqss2MC/F2Cxk4SpwU20k1kem6u9r9YN
 NZCDwUUUHJ0SrXKqP/zzLhMcQuqXJM+mtt3AaNN1Fm3tAXXNuvMUTIjKWGCGlAWiZ7AZ
 xoVeIbadPcZKby/NL7yQat2k7Mg54BZwD7+cms3BVRGWmQ96oq9U9ZsBB+28ApOS84Dy
 H/I1hoyP1S4S5eiuSxxGmjqPp/aVXoTuktXqBXpTihYZQHSqW2y2Lb8q57dub8IO/ni+
 3nVaQBvff2+5BKDuD0DJnkOXruh66lsgevKGMU/ocqCW9uLvQId8Glmr2+bVjypOc8iv 5Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 30vhvyh2f6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 May 2020 15:15:19 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 047FCHCk183214;
        Thu, 7 May 2020 15:15:19 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 30sjnpkh5u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 May 2020 15:15:18 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 047FFHHE032460;
        Thu, 7 May 2020 15:15:17 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 May 2020 08:15:17 -0700
Date:   Thu, 7 May 2020 08:15:16 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     chandanrlinux@gmail.com
Subject: [chandanrlinux@gmail.com: Re: [PATCH 20/25] xfs: refactor adding
 recovered intent items to the log]
Message-ID: <20200507151516.GF6714@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005070124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxlogscore=999
 spamscore=0 phishscore=0 impostorscore=0 bulkscore=0 priorityscore=1501
 malwarescore=0 mlxscore=0 adultscore=0 suspectscore=1 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005070124
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

[Forwarding this RVB to the list for more permanent recording...]

--D

----- Forwarded message from Chandan Babu R <chandanrlinux@gmail.com> -----

Date: Thu, 07 May 2020 09:32:27 +0530
From: Chandan Babu R <chandanrlinux@gmail.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 20/25] xfs: refactor adding recovered intent items to the log

On Thursday 7 May 2020 6:33:49 AM IST you wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> During recovery, every intent that we recover from the log has to be
> added to the AIL.  Replace the open-coded addition with a helper.
>

The changes look good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_bmap_item.c     |   10 +++-------
>  fs/xfs/xfs_extfree_item.c  |   10 +++-------
>  fs/xfs/xfs_refcount_item.c |   10 +++-------
>  fs/xfs/xfs_rmap_item.c     |   10 +++-------
>  fs/xfs/xfs_trans_ail.c     |   11 +++++++++++
>  fs/xfs/xfs_trans_priv.h    |    3 +++
>  6 files changed, 26 insertions(+), 28 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index b3996f361b87..1e9bc8d15f51 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -651,15 +651,11 @@ xlog_recover_bui_commit_pass2(
>  		return error;
>  	}
>  	atomic_set(&buip->bui_next_extent, bui_formatp->bui_nextents);
> -
> -	spin_lock(&log->l_ailp->ail_lock);
>  	/*
> -	 * The RUI has two references. One for the RUD and one for RUI to ensure
> -	 * it makes it into the AIL. Insert the RUI into the AIL directly and
> -	 * drop the RUI reference. Note that xfs_trans_ail_update() drops the
> -	 * AIL lock.
> +	 * Insert the intent into the AIL directly and drop one reference so
> +	 * that finishing or canceling the work will drop the other.
>  	 */
> -	xfs_trans_ail_update(log->l_ailp, &buip->bui_item, lsn);
> +	xfs_trans_ail_insert(log->l_ailp, &buip->bui_item, lsn);
>  	xfs_bui_release(buip);
>  	return 0;
>  }
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 3855e30109bf..99c4643d0ae8 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -710,15 +710,11 @@ xlog_recover_efi_commit_pass2(
>  		return error;
>  	}
>  	atomic_set(&efip->efi_next_extent, efi_formatp->efi_nextents);
> -
> -	spin_lock(&log->l_ailp->ail_lock);
>  	/*
> -	 * The EFI has two references. One for the EFD and one for EFI to ensure
> -	 * it makes it into the AIL. Insert the EFI into the AIL directly and
> -	 * drop the EFI reference. Note that xfs_trans_ail_update() drops the
> -	 * AIL lock.
> +	 * Insert the intent into the AIL directly and drop one reference so
> +	 * that finishing or canceling the work will drop the other.
>  	 */
> -	xfs_trans_ail_update(log->l_ailp, &efip->efi_item, lsn);
> +	xfs_trans_ail_insert(log->l_ailp, &efip->efi_item, lsn);
>  	xfs_efi_release(efip);
>  	return 0;
>  }
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index c03836e1a6d7..a9c513338ddc 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -660,15 +660,11 @@ xlog_recover_cui_commit_pass2(
>  		return error;
>  	}
>  	atomic_set(&cuip->cui_next_extent, cui_formatp->cui_nextents);
> -
> -	spin_lock(&log->l_ailp->ail_lock);
>  	/*
> -	 * The CUI has two references. One for the CUD and one for CUI to ensure
> -	 * it makes it into the AIL. Insert the CUI into the AIL directly and
> -	 * drop the CUI reference. Note that xfs_trans_ail_update() drops the
> -	 * AIL lock.
> +	 * Insert the intent into the AIL directly and drop one reference so
> +	 * that finishing or canceling the work will drop the other.
>  	 */
> -	xfs_trans_ail_update(log->l_ailp, &cuip->cui_item, lsn);
> +	xfs_trans_ail_insert(log->l_ailp, &cuip->cui_item, lsn);
>  	xfs_cui_release(cuip);
>  	return 0;
>  }
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index 31d35de518d1..ee0be4310c7c 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -651,15 +651,11 @@ xlog_recover_rui_commit_pass2(
>  		return error;
>  	}
>  	atomic_set(&ruip->rui_next_extent, rui_formatp->rui_nextents);
> -
> -	spin_lock(&log->l_ailp->ail_lock);
>  	/*
> -	 * The RUI has two references. One for the RUD and one for RUI to ensure
> -	 * it makes it into the AIL. Insert the RUI into the AIL directly and
> -	 * drop the RUI reference. Note that xfs_trans_ail_update() drops the
> -	 * AIL lock.
> +	 * Insert the intent into the AIL directly and drop one reference so
> +	 * that finishing or canceling the work will drop the other.
>  	 */
> -	xfs_trans_ail_update(log->l_ailp, &ruip->rui_item, lsn);
> +	xfs_trans_ail_insert(log->l_ailp, &ruip->rui_item, lsn);
>  	xfs_rui_release(ruip);
>  	return 0;
>  }
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index bf09d4b4df58..ac5019361a13 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -815,6 +815,17 @@ xfs_trans_ail_update_bulk(
>  	xfs_ail_update_finish(ailp, tail_lsn);
>  }
>  
> +/* Insert a log item into the AIL. */
> +void
> +xfs_trans_ail_insert(
> +	struct xfs_ail		*ailp,
> +	struct xfs_log_item	*lip,
> +	xfs_lsn_t		lsn)
> +{
> +	spin_lock(&ailp->ail_lock);
> +	xfs_trans_ail_update_bulk(ailp, NULL, &lip, 1, lsn);
> +}
> +
>  /*
>   * Delete one log item from the AIL.
>   *
> diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
> index cc046d9557ae..3004aeac9110 100644
> --- a/fs/xfs/xfs_trans_priv.h
> +++ b/fs/xfs/xfs_trans_priv.h
> @@ -91,6 +91,9 @@ xfs_trans_ail_update(
>  	xfs_trans_ail_update_bulk(ailp, NULL, &lip, 1, lsn);
>  }
>  
> +void xfs_trans_ail_insert(struct xfs_ail *ailp, struct xfs_log_item *lip,
> +		xfs_lsn_t lsn);
> +
>  xfs_lsn_t xfs_ail_delete_one(struct xfs_ail *ailp, struct xfs_log_item *lip);
>  void xfs_ail_update_finish(struct xfs_ail *ailp, xfs_lsn_t old_lsn)
>  			__releases(ailp->ail_lock);
> 
> 


-- 
chandan




----- End forwarded message -----
