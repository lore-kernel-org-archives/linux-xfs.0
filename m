Return-Path: <SRS0=JvtZ=5L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E347C43331
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Mar 2020 05:10:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 269AA20772
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Mar 2020 05:10:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jP4GD55i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbgCZFKH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Mar 2020 01:10:07 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42646 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbgCZFKH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Mar 2020 01:10:07 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02Q58aUl141695;
        Thu, 26 Mar 2020 05:10:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=AhOQDoYH7oFsLFwInFhzhCbIOsy8PJcKonvvu7AzlLc=;
 b=jP4GD55iYOY94XpkQAYFOmRNS0B04b8p8+TKmNO1jCGUK8Spfg8nZTe2SxkVCF/JOPxV
 MGRiiGg9CmE/GcOUgmvw3OqkN6mvWE3yegEvsZNLElgeB1vfF2ghpzikfWJI0O/PAYqV
 MRWt4i7wTTPUK2ohmL69Nd2lD/ecXMLhK5IVxhYtv40c0wNhCwU4D1xAFb7Wwkprqhrs
 wt/BU5qoXDhQdRKxVsFwfe6apPBca8jxQxvejNQJkt0ahK9lr1cBF8LJciD3cHlyhJf6
 vifUm2UnpVWTNLPIMSVWf58OwZhR9X1UJCxWAuvklR6r/Hqt5H3C/5bOpQA/gVAUN24r mA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 3005kvchb6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Mar 2020 05:10:05 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02Q57uER180409;
        Thu, 26 Mar 2020 05:10:04 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 3003gk47jk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Mar 2020 05:10:04 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02Q5A3tS017835;
        Thu, 26 Mar 2020 05:10:03 GMT
Received: from localhost (/10.159.237.96)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Mar 2020 22:10:03 -0700
Date:   Wed, 25 Mar 2020 22:10:01 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/8] xfs: factor common AIL item deletion code
Message-ID: <20200326051001.GB29339@magnolia>
References: <20200325014205.11843-1-david@fromorbit.com>
 <20200325014205.11843-7-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200325014205.11843-7-david@fromorbit.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9571 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 adultscore=0 spamscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003260032
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9571 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 phishscore=0
 suspectscore=0 impostorscore=0 spamscore=0 adultscore=0 priorityscore=1501
 mlxlogscore=999 lowpriorityscore=0 mlxscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003260032
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 25, 2020 at 12:42:03PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Factor the common AIL deletion code that does all the wakeups into a
> helper so we only have one copy of this somewhat tricky code to
> interface with all the wakeups necessary when the LSN of the log
> tail changes.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

This call site didn't have a wake_up_all and now it does; is that going
to make a difference?  I /think/ the answer is that this function
usually puts things on the AIL so we won't trigger the ail_empty wakeup;
and if the AIL was previously empty and we didn't match any log items
(such that it's still empty) then it's fine to wake up anyone who was
waiting for the ail to clear out?

If so,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_inode_item.c | 12 +----------
>  fs/xfs/xfs_trans_ail.c  | 48 ++++++++++++++++++++++-------------------
>  fs/xfs/xfs_trans_priv.h |  4 +++-
>  3 files changed, 30 insertions(+), 34 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 4a3d13d4a0228..bd8c368098707 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -742,17 +742,7 @@ xfs_iflush_done(
>  				xfs_clear_li_failed(blip);
>  			}
>  		}
> -
> -		if (mlip_changed) {
> -			if (!XFS_FORCED_SHUTDOWN(ailp->ail_mount))
> -				xlog_assign_tail_lsn_locked(ailp->ail_mount);
> -			if (list_empty(&ailp->ail_head))
> -				wake_up_all(&ailp->ail_empty);
> -		}
> -		spin_unlock(&ailp->ail_lock);
> -
> -		if (mlip_changed)
> -			xfs_log_space_wake(ailp->ail_mount);
> +		xfs_ail_update_finish(ailp, mlip_changed);
>  	}
>  
>  	/*
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 2ef0dfbfb303d..26d2e7928121c 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -681,6 +681,27 @@ xfs_ail_push_all_sync(
>  	finish_wait(&ailp->ail_empty, &wait);
>  }
>  
> +void
> +xfs_ail_update_finish(
> +	struct xfs_ail		*ailp,
> +	bool			do_tail_update) __releases(ailp->ail_lock)
> +{
> +	struct xfs_mount	*mp = ailp->ail_mount;
> +
> +	if (!do_tail_update) {
> +		spin_unlock(&ailp->ail_lock);
> +		return;
> +	}
> +
> +	if (!XFS_FORCED_SHUTDOWN(mp))
> +		xlog_assign_tail_lsn_locked(mp);
> +
> +	if (list_empty(&ailp->ail_head))
> +		wake_up_all(&ailp->ail_empty);
> +	spin_unlock(&ailp->ail_lock);
> +	xfs_log_space_wake(mp);
> +}
> +
>  /*
>   * xfs_trans_ail_update - bulk AIL insertion operation.
>   *
> @@ -740,15 +761,7 @@ xfs_trans_ail_update_bulk(
>  	if (!list_empty(&tmp))
>  		xfs_ail_splice(ailp, cur, &tmp, lsn);
>  
> -	if (mlip_changed) {
> -		if (!XFS_FORCED_SHUTDOWN(ailp->ail_mount))
> -			xlog_assign_tail_lsn_locked(ailp->ail_mount);
> -		spin_unlock(&ailp->ail_lock);
> -
> -		xfs_log_space_wake(ailp->ail_mount);
> -	} else {
> -		spin_unlock(&ailp->ail_lock);
> -	}
> +	xfs_ail_update_finish(ailp, mlip_changed);
>  }
>  
>  bool
> @@ -792,10 +805,10 @@ void
>  xfs_trans_ail_delete(
>  	struct xfs_ail		*ailp,
>  	struct xfs_log_item	*lip,
> -	int			shutdown_type) __releases(ailp->ail_lock)
> +	int			shutdown_type)
>  {
>  	struct xfs_mount	*mp = ailp->ail_mount;
> -	bool			mlip_changed;
> +	bool			need_update;
>  
>  	if (!test_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
>  		spin_unlock(&ailp->ail_lock);
> @@ -808,17 +821,8 @@ xfs_trans_ail_delete(
>  		return;
>  	}
>  
> -	mlip_changed = xfs_ail_delete_one(ailp, lip);
> -	if (mlip_changed) {
> -		if (!XFS_FORCED_SHUTDOWN(mp))
> -			xlog_assign_tail_lsn_locked(mp);
> -		if (list_empty(&ailp->ail_head))
> -			wake_up_all(&ailp->ail_empty);
> -	}
> -
> -	spin_unlock(&ailp->ail_lock);
> -	if (mlip_changed)
> -		xfs_log_space_wake(ailp->ail_mount);
> +	need_update = xfs_ail_delete_one(ailp, lip);
> +	xfs_ail_update_finish(ailp, need_update);
>  }
>  
>  int
> diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
> index 2e073c1c4614f..64ffa746730e4 100644
> --- a/fs/xfs/xfs_trans_priv.h
> +++ b/fs/xfs/xfs_trans_priv.h
> @@ -92,8 +92,10 @@ xfs_trans_ail_update(
>  }
>  
>  bool xfs_ail_delete_one(struct xfs_ail *ailp, struct xfs_log_item *lip);
> +void xfs_ail_update_finish(struct xfs_ail *ailp, bool do_tail_update)
> +			__releases(ailp->ail_lock);
>  void xfs_trans_ail_delete(struct xfs_ail *ailp, struct xfs_log_item *lip,
> -		int shutdown_type) __releases(ailp->ail_lock);
> +		int shutdown_type);
>  
>  static inline void
>  xfs_trans_ail_remove(
> -- 
> 2.26.0.rc2
> 
