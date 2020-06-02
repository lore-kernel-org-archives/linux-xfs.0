Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09CAFC433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 20:47:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3A8B206A2
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 20:47:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VGsHSgVx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgFBUrt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 16:47:49 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51174 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgFBUrt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 16:47:49 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 052Kbt78037388;
        Tue, 2 Jun 2020 20:47:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=OFzOb5+rUpfr7+C50+qA/zj5c6LATnt8VFIDPdafs58=;
 b=VGsHSgVxFrWOh17xWs5FcBIwCynHf7U1sZUpURlmHEzEs/QZlAM9Us4Hw5NiYPeYeOj/
 1PDeVIUCt8iWZ6b1Cs3VSHGhmJ8EDHSLiIoGyC7QtrzIs6d9idKh5X1l2s4iv0DYPwXO
 erfYbVxhEmVeSdX1WZqJLZVp+i1IyeFCjLZHtHaYcP6KKClJORhwoLWLioRQjHhXOYwr
 xsCrgC2mXymzZCGqLDSpVfcrCHkFHUY0kvh8p3rvgA8PNTTNKDW0YAsrZvdWh14/3CYT
 FS3VqRr4AR3aBzDP5LrkNiR1vSgVuzKnAV3OB0oHUMVb64naEx6w0ZfDmfwUlw8nIqGc Ew== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 31bewqx453-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 20:47:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 052KdQvL147306;
        Tue, 2 Jun 2020 20:47:46 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 31c12ptsvr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 20:47:46 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 052KljE6005081;
        Tue, 2 Jun 2020 20:47:45 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Jun 2020 13:47:45 -0700
Date:   Tue, 2 Jun 2020 13:47:44 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/30] xfs: move xfs_clear_li_failed out of
 xfs_ail_delete_one()
Message-ID: <20200602204744.GL8230@magnolia>
References: <20200601214251.4167140-1-david@fromorbit.com>
 <20200601214251.4167140-16-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200601214251.4167140-16-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 adultscore=0 suspectscore=1 spamscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006020150
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 bulkscore=0
 phishscore=0 suspectscore=1 impostorscore=0 cotscore=-2147483648
 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006020150
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 02, 2020 at 07:42:36AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_ail_delete_one() is called directly from dquot and inode IO
> completion, as well as from the generic xfs_trans_ail_delete()
> function. Inodes are about to have their own failure handling, and
> dquots will in future, too. Pull the clearing of the LI_FAILED flag
> up into the callers so we can customise the code appropriately.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_dquot.c      | 6 +-----
>  fs/xfs/xfs_inode_item.c | 3 +--
>  fs/xfs/xfs_trans_ail.c  | 2 +-
>  3 files changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index d5984a926d1d0..76353c9a723ee 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -1070,16 +1070,12 @@ xfs_qm_dqflush_done(
>  	     test_bit(XFS_LI_FAILED, &lip->li_flags))) {
>  
>  		spin_lock(&ailp->ail_lock);
> +		xfs_clear_li_failed(lip);
>  		if (lip->li_lsn == qip->qli_flush_lsn) {
>  			/* xfs_ail_update_finish() drops the AIL lock */
>  			tail_lsn = xfs_ail_delete_one(ailp, lip);
>  			xfs_ail_update_finish(ailp, tail_lsn);
>  		} else {
> -			/*
> -			 * Clear the failed state since we are about to drop the
> -			 * flush lock
> -			 */
> -			xfs_clear_li_failed(lip);
>  			spin_unlock(&ailp->ail_lock);
>  		}
>  	}
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 86c783dec2bac..0ba75764a8dc5 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -690,12 +690,11 @@ xfs_iflush_done(
>  		/* this is an opencoded batch version of xfs_trans_ail_delete */
>  		spin_lock(&ailp->ail_lock);
>  		list_for_each_entry(lip, &tmp, li_bio_list) {
> +			xfs_clear_li_failed(lip);
>  			if (lip->li_lsn == INODE_ITEM(lip)->ili_flush_lsn) {
>  				xfs_lsn_t lsn = xfs_ail_delete_one(ailp, lip);
>  				if (!tail_lsn && lsn)
>  					tail_lsn = lsn;
> -			} else {
> -				xfs_clear_li_failed(lip);
>  			}
>  		}
>  		xfs_ail_update_finish(ailp, tail_lsn);
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index ac5019361a139..ac33f6393f99c 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -843,7 +843,6 @@ xfs_ail_delete_one(
>  
>  	trace_xfs_ail_delete(lip, mlip->li_lsn, lip->li_lsn);
>  	xfs_ail_delete(ailp, lip);
> -	xfs_clear_li_failed(lip);
>  	clear_bit(XFS_LI_IN_AIL, &lip->li_flags);
>  	lip->li_lsn = 0;
>  
> @@ -874,6 +873,7 @@ xfs_trans_ail_delete(
>  	}
>  
>  	/* xfs_ail_update_finish() drops the AIL lock */
> +	xfs_clear_li_failed(lip);
>  	tail_lsn = xfs_ail_delete_one(ailp, lip);
>  	xfs_ail_update_finish(ailp, tail_lsn);
>  }
> -- 
> 2.26.2.761.g0e0b3e54be
> 
