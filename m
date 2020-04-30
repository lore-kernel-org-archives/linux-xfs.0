Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9081EC47247
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 18:56:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B0DD2073E
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 18:56:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="F3yUc9D2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgD3S4w (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 14:56:52 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54490 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbgD3S4v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 14:56:51 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UInTSr079636;
        Thu, 30 Apr 2020 18:56:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=ZIT/0d3cFFxAgBR67Rtd1RmdYJhxxxhfvdneHhNobls=;
 b=F3yUc9D2R/EgxOM78Fq3JySAapWDojTKbMSVpoiea/Q2V1A2+cslpuFd1Q9q5e5yUcRY
 qn+9ZTdpAhZ8ne2GMClrTZZ4114HDj4KQL2w/w9vndujnkafZeDU/EIlakFoJnO6CTFI
 uLcOQFsazGxAApshs1DfnIFqyjA25ZWELSjyplAb8JgBaQ6UIA9VKbN3E2oFCnwkxXyt
 ATmwMF5jJQzzAFLoAIbkppWUjPffomaQhBND2CTvgbwNUfGMnWhdPLqipLGFnXHRobkF
 +UjDEM/o4gBPgTrgUpdFBbyV4JvQE/f2e8GJqeRAq4aEDjYh6tK+fExTtwIQGhtHpYnG 8A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 30p01p3tp9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 18:56:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UImEIs120945;
        Thu, 30 Apr 2020 18:56:48 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 30qtg1nq33-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 18:56:48 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03UIulVQ008121;
        Thu, 30 Apr 2020 18:56:47 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 11:56:47 -0700
Date:   Thu, 30 Apr 2020 11:56:46 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 12/17] xfs: drop unused shutdown parameter from
 xfs_trans_ail_remove()
Message-ID: <20200430185646.GM6742@magnolia>
References: <20200429172153.41680-1-bfoster@redhat.com>
 <20200429172153.41680-13-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429172153.41680-13-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 adultscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 clxscore=1015
 phishscore=0 mlxlogscore=999 adultscore=0 priorityscore=1501 mlxscore=0
 suspectscore=2 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300145
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 29, 2020 at 01:21:48PM -0400, Brian Foster wrote:
> The shutdown parameter of xfs_trans_ail_remove() is no longer used.
> The remaining callers use it for items that legitimately might not
> be in the AIL or from contexts where AIL state has already been
> checked. Remove the unnecessary parameter and fix up the callers.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_buf_item.c   | 2 +-
>  fs/xfs/xfs_dquot.c      | 2 +-
>  fs/xfs/xfs_dquot_item.c | 2 +-
>  fs/xfs/xfs_inode_item.c | 6 +-----
>  fs/xfs/xfs_trans_priv.h | 3 +--
>  5 files changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 06e306b49283..47c547aca1f1 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -558,7 +558,7 @@ xfs_buf_item_put(
>  	 * state.
>  	 */
>  	if (aborted)
> -		xfs_trans_ail_remove(lip, SHUTDOWN_LOG_IO_ERROR);
> +		xfs_trans_ail_remove(lip);
>  	xfs_buf_item_relse(bip->bli_buf);
>  	return true;
>  }
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 5fb65f43b980..497a9dbef1c9 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -1162,7 +1162,7 @@ xfs_qm_dqflush(
>  
>  out_abort:
>  	dqp->dq_flags &= ~XFS_DQ_DIRTY;
> -	xfs_trans_ail_remove(lip, SHUTDOWN_CORRUPT_INCORE);
> +	xfs_trans_ail_remove(lip);
>  	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
>  out_unlock:
>  	xfs_dqfunlock(dqp);
> diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
> index 5a7808299a32..8bd46810d5db 100644
> --- a/fs/xfs/xfs_dquot_item.c
> +++ b/fs/xfs/xfs_dquot_item.c
> @@ -343,7 +343,7 @@ xfs_qm_qoff_logitem_relse(
>  	ASSERT(test_bit(XFS_LI_IN_AIL, &lip->li_flags) ||
>  	       test_bit(XFS_LI_ABORTED, &lip->li_flags) ||
>  	       XFS_FORCED_SHUTDOWN(lip->li_mountp));
> -	xfs_trans_ail_remove(lip, SHUTDOWN_LOG_IO_ERROR);
> +	xfs_trans_ail_remove(lip);
>  	kmem_free(lip->li_lv_shadow);
>  	kmem_free(qoff);
>  }
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 1d4d256a2e96..0e449d0a3d5c 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -768,11 +768,7 @@ xfs_iflush_abort(
>  	xfs_inode_log_item_t	*iip = ip->i_itemp;
>  
>  	if (iip) {
> -		if (test_bit(XFS_LI_IN_AIL, &iip->ili_item.li_flags)) {
> -			xfs_trans_ail_remove(&iip->ili_item,
> -					     stale ? SHUTDOWN_LOG_IO_ERROR :
> -						     SHUTDOWN_CORRUPT_INCORE);
> -		}
> +		xfs_trans_ail_remove(&iip->ili_item);
>  		iip->ili_logged = 0;
>  		/*
>  		 * Clear the ili_last_fields bits now that we know that the
> diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
> index e4362fb8d483..ab0a82e90825 100644
> --- a/fs/xfs/xfs_trans_priv.h
> +++ b/fs/xfs/xfs_trans_priv.h
> @@ -98,8 +98,7 @@ void xfs_trans_ail_delete(struct xfs_log_item *lip, int shutdown_type);
>  
>  static inline void
>  xfs_trans_ail_remove(
> -	struct xfs_log_item	*lip,
> -	int			shutdown_type)
> +	struct xfs_log_item	*lip)
>  {
>  	struct xfs_ail		*ailp = lip->li_ailp;
>  	xfs_lsn_t		tail_lsn;
> -- 
> 2.21.1
> 
