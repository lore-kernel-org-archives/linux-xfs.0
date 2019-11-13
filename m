Return-Path: <SRS0=J5MO=ZF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B253C43331
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 04:44:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00CA2222D3
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 04:44:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LodtfLzd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbfKMEoF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Nov 2019 23:44:05 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:53756 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727140AbfKMEoF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Nov 2019 23:44:05 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAD4hoCY182811;
        Wed, 13 Nov 2019 04:44:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=iTExIWsEhAy+tiXTBGXHS8SE85Q1wH/rt9Y3k1Edh+c=;
 b=LodtfLzdtJd5jwCr3inOcX9oun+6DsK8cIfsAGOc1EMOzFovff7193jM9UVVE/FEWtB+
 u+uDUT8L+Lvzgq8ovkFYizJ36Sl7coNSanN1fRj23KwLVWafaI69YMe6BcBr6hCzZRgG
 r4gGurrCnv+AiAGtELhZWPCrlZZNykMLIL4iCBBsskQuhX8yBUqveRGhiYwN3DSAchwq
 s0e8HsPo82PcIMD07044AVqVt5Jaii8IBUrCuJgpMHoy0TG2ohAYny4Fa6AdyJWzJ/9E
 nFOYBoxgc5mFHbb5d5xpVnDqiltsvfb8GRvGIECPYQTPRYCbTV2v6R89v1sRh1Yw3cnH kg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2w5mvtsmgm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 04:44:01 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAD4hi7A188186;
        Wed, 13 Nov 2019 04:44:01 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2w7vbc5834-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 04:44:01 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAD4i0ko031984;
        Wed, 13 Nov 2019 04:44:00 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Nov 2019 20:43:59 -0800
Date:   Tue, 12 Nov 2019 20:43:58 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 5/5] Replace function declartion by actual definition
Message-ID: <20191113044358.GL6219@magnolia>
References: <20191112213310.212925-1-preichl@redhat.com>
 <20191112213310.212925-6-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191112213310.212925-6-preichl@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9439 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911130041
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9439 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911130041
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 12, 2019 at 10:33:10PM +0100, Pavel Reichl wrote:

The subject line is missing the usual 'xfs:'

OTOH this looks like a simple enough code move that I'll just fix it on
the way in.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> Signed-off-by: Pavel Reichl <preichl@redhat.com>
> ---
>  fs/xfs/xfs_qm_syscalls.c | 140 ++++++++++++++++++---------------------
>  1 file changed, 66 insertions(+), 74 deletions(-)
> 
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index e685b9ae90b9..1ea82764bf89 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -19,12 +19,72 @@
>  #include "xfs_qm.h"
>  #include "xfs_icache.h"
>  
> -STATIC int xfs_qm_log_quotaoff(struct xfs_mount *mp,
> -					struct xfs_qoff_logitem **qoffstartp,
> -					uint flags);
> -STATIC int xfs_qm_log_quotaoff_end(struct xfs_mount *mp,
> -					struct xfs_qoff_logitem *startqoff,
> -					uint flags);
> +STATIC int
> +xfs_qm_log_quotaoff(
> +	struct xfs_mount	*mp,
> +	struct xfs_qoff_logitem	**qoffstartp,
> +	uint			flags)
> +{
> +	struct xfs_trans	*tp;
> +	int			error;
> +	struct xfs_qoff_logitem	*qoffi;
> +
> +	*qoffstartp = NULL;
> +
> +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_quotaoff, 0, 0, 0, &tp);
> +	if (error)
> +		goto out;
> +
> +	qoffi = xfs_trans_get_qoff_item(tp, NULL, flags & XFS_ALL_QUOTA_ACCT);
> +	xfs_trans_log_quotaoff_item(tp, qoffi);
> +
> +	spin_lock(&mp->m_sb_lock);
> +	mp->m_sb.sb_qflags = (mp->m_qflags & ~(flags)) & XFS_MOUNT_QUOTA_ALL;
> +	spin_unlock(&mp->m_sb_lock);
> +
> +	xfs_log_sb(tp);
> +
> +	/*
> +	 * We have to make sure that the transaction is secure on disk before we
> +	 * return and actually stop quota accounting. So, make it synchronous.
> +	 * We don't care about quotoff's performance.
> +	 */
> +	xfs_trans_set_sync(tp);
> +	error = xfs_trans_commit(tp);
> +	if (error)
> +		goto out;
> +
> +	*qoffstartp = qoffi;
> +out:
> +	return error;
> +}
> +
> +STATIC int
> +xfs_qm_log_quotaoff_end(
> +	struct xfs_mount	*mp,
> +	struct xfs_qoff_logitem	*startqoff,
> +	uint			flags)
> +{
> +	struct xfs_trans	*tp;
> +	int			error;
> +	struct xfs_qoff_logitem	*qoffi;
> +
> +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_equotaoff, 0, 0, 0, &tp);
> +	if (error)
> +		return error;
> +
> +	qoffi = xfs_trans_get_qoff_item(tp, startqoff,
> +					flags & XFS_ALL_QUOTA_ACCT);
> +	xfs_trans_log_quotaoff_item(tp, qoffi);
> +
> +	/*
> +	 * We have to make sure that the transaction is secure on disk before we
> +	 * return and actually stop quota accounting. So, make it synchronous.
> +	 * We don't care about quotoff's performance.
> +	 */
> +	xfs_trans_set_sync(tp);
> +	return xfs_trans_commit(tp);
> +}
>  
>  /*
>   * Turn off quota accounting and/or enforcement for all udquots and/or
> @@ -541,74 +601,6 @@ xfs_qm_scall_setqlim(
>  	return error;
>  }
>  
> -STATIC int
> -xfs_qm_log_quotaoff_end(
> -	struct xfs_mount	*mp,
> -	struct xfs_qoff_logitem	*startqoff,
> -	uint			flags)
> -{
> -	struct xfs_trans	*tp;
> -	int			error;
> -	struct xfs_qoff_logitem	*qoffi;
> -
> -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_equotaoff, 0, 0, 0, &tp);
> -	if (error)
> -		return error;
> -
> -	qoffi = xfs_trans_get_qoff_item(tp, startqoff,
> -					flags & XFS_ALL_QUOTA_ACCT);
> -	xfs_trans_log_quotaoff_item(tp, qoffi);
> -
> -	/*
> -	 * We have to make sure that the transaction is secure on disk before we
> -	 * return and actually stop quota accounting. So, make it synchronous.
> -	 * We don't care about quotoff's performance.
> -	 */
> -	xfs_trans_set_sync(tp);
> -	return xfs_trans_commit(tp);
> -}
> -
> -
> -STATIC int
> -xfs_qm_log_quotaoff(
> -	struct xfs_mount	*mp,
> -	struct xfs_qoff_logitem	**qoffstartp,
> -	uint			flags)
> -{
> -	struct xfs_trans	*tp;
> -	int			error;
> -	struct xfs_qoff_logitem	*qoffi;
> -
> -	*qoffstartp = NULL;
> -
> -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_quotaoff, 0, 0, 0, &tp);
> -	if (error)
> -		goto out;
> -
> -	qoffi = xfs_trans_get_qoff_item(tp, NULL, flags & XFS_ALL_QUOTA_ACCT);
> -	xfs_trans_log_quotaoff_item(tp, qoffi);
> -
> -	spin_lock(&mp->m_sb_lock);
> -	mp->m_sb.sb_qflags = (mp->m_qflags & ~(flags)) & XFS_MOUNT_QUOTA_ALL;
> -	spin_unlock(&mp->m_sb_lock);
> -
> -	xfs_log_sb(tp);
> -
> -	/*
> -	 * We have to make sure that the transaction is secure on disk before we
> -	 * return and actually stop quota accounting. So, make it synchronous.
> -	 * We don't care about quotoff's performance.
> -	 */
> -	xfs_trans_set_sync(tp);
> -	error = xfs_trans_commit(tp);
> -	if (error)
> -		goto out;
> -
> -	*qoffstartp = qoffi;
> -out:
> -	return error;
> -}
> -
>  /* Fill out the quota context. */
>  static void
>  xfs_qm_scall_getquota_fill_qc(
> -- 
> 2.23.0
> 
