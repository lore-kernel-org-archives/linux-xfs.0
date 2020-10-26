Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B959C4363A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 22:52:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B140C2067B
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 22:52:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CQu3iuRp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394825AbgJZWwX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 18:52:23 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54850 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394824AbgJZWwX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 18:52:23 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QMiSq3107300;
        Mon, 26 Oct 2020 22:51:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=YDDJPYRPAC2Ytq1uT5o+CiEsoMcGVPG7k7otnm/uH1Q=;
 b=CQu3iuRpkAvJuxAHH8Z71ftsaRRDhALWy8mccJ8c86XDs4fr3nxUp/pIerpGF5fc/96R
 Imu0DtaQZ83eWWokptxo5MheRAjMjNSyeCFNqAYd3OKyhxzRqJH+JkciiR/Kfz6PwSH1
 H3qhPZ9ZVI2YIL6rV8N280m6GqlGzrv5w5wFKpA7vjCMjWo+awRUCS7rnAXxt88Lqrl+
 jXP3JQ91OHqQcKuh4C53pGAolE+UimeGTK5+yk3Epij2PKlMME82lY/ON/cd2K/yZEp+
 yqQEVRCUe8F7y/rGf9O8som8CeTKlsXOQuiqjI5TWcnSiM3tOSQuiXQau/KaKOZBjt4/ TQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 34dgm3vr84-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 22:51:31 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QMkMC0158104;
        Mon, 26 Oct 2020 22:51:31 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 34cwukqbsj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 22:51:31 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09QMpUmB026306;
        Mon, 26 Oct 2020 22:51:30 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 15:51:30 -0700
Date:   Mon, 26 Oct 2020 15:51:29 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH v4 2/3] xfs: check tp->t_dqinfo value instead of the
 XFS_TRANS_DQ_DIRTY flag
Message-ID: <20201026225129.GE347246@magnolia>
References: <1602130749-23093-1-git-send-email-kaixuxia@tencent.com>
 <1602130749-23093-3-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1602130749-23093-3-git-send-email-kaixuxia@tencent.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=3 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260148
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 08, 2020 at 12:19:08PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> Nowadays the only things that the XFS_TRANS_DQ_DIRTY flag seems to do
> are indicates the tp->t_dqinfo->dqs[XFS_QM_TRANS_{USR,GRP,PRJ}] values
> changed and check in xfs_trans_apply_dquot_deltas() and the unreserve
> variant xfs_trans_unreserve_and_mod_dquots(). Actually, we also can
> use the tp->t_dqinfo value instead of the XFS_TRANS_DQ_DIRTY flag, that
> is to say, we allocate the new tp->t_dqinfo only when the qtrx values
> changed, so the tp->t_dqinfo value isn't NULL equals the XFS_TRANS_DQ_DIRTY
> flag is set, we only need to check if tp->t_dqinfo == NULL in
> xfs_trans_apply_dquot_deltas() and its unreserve variant to determine
> whether lock all of the dquots and join them to the transaction.
> 
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>

Woooooo!!
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_shared.h |  1 -
>  fs/xfs/xfs_inode.c         |  8 +-------
>  fs/xfs/xfs_trans_dquot.c   | 13 ++-----------
>  3 files changed, 3 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
> index c795ae47b3c9..8c61a461bf7b 100644
> --- a/fs/xfs/libxfs/xfs_shared.h
> +++ b/fs/xfs/libxfs/xfs_shared.h
> @@ -62,7 +62,6 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
>  #define	XFS_TRANS_SB_DIRTY	0x02	/* superblock is modified */
>  #define	XFS_TRANS_PERM_LOG_RES	0x04	/* xact took a permanent log res */
>  #define	XFS_TRANS_SYNC		0x08	/* make commit synchronous */
> -#define XFS_TRANS_DQ_DIRTY	0x10	/* at least one dquot in trx dirty */
>  #define XFS_TRANS_RESERVE	0x20    /* OK to use reserved data blocks */
>  #define XFS_TRANS_NO_WRITECOUNT 0x40	/* do not elevate SB writecount */
>  #define XFS_TRANS_RES_FDBLKS	0x80	/* reserve newly freed blocks */
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 2bfbcf28b1bd..4d2cebaa3637 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -959,7 +959,6 @@ xfs_dir_ialloc(
>  	xfs_buf_t	*ialloc_context = NULL;
>  	int		code;
>  	void		*dqinfo;
> -	uint		tflags;
>  
>  	tp = *tpp;
>  	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
> @@ -1018,12 +1017,9 @@ xfs_dir_ialloc(
>  		 * and attach it to the next transaction.
>  		 */
>  		dqinfo = NULL;
> -		tflags = 0;
>  		if (tp->t_dqinfo) {
>  			dqinfo = (void *)tp->t_dqinfo;
>  			tp->t_dqinfo = NULL;
> -			tflags = tp->t_flags & XFS_TRANS_DQ_DIRTY;
> -			tp->t_flags &= ~(XFS_TRANS_DQ_DIRTY);
>  		}
>  
>  		code = xfs_trans_roll(&tp);
> @@ -1031,10 +1027,8 @@ xfs_dir_ialloc(
>  		/*
>  		 * Re-attach the quota info that we detached from prev trx.
>  		 */
> -		if (dqinfo) {
> +		if (dqinfo)
>  			tp->t_dqinfo = dqinfo;
> -			tp->t_flags |= tflags;
> -		}
>  
>  		if (code) {
>  			xfs_buf_relse(ialloc_context);
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index 67f1e275b34d..0ebfd7930382 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -84,13 +84,6 @@ xfs_trans_dup_dqinfo(
>  
>  	xfs_trans_alloc_dqinfo(ntp);
>  
> -	/*
> -	 * Because the quota blk reservation is carried forward,
> -	 * it is also necessary to carry forward the DQ_DIRTY flag.
> -	 */
> -	if (otp->t_flags & XFS_TRANS_DQ_DIRTY)
> -		ntp->t_flags |= XFS_TRANS_DQ_DIRTY;
> -
>  	for (j = 0; j < XFS_QM_TRANS_DQTYPES; j++) {
>  		oqa = otp->t_dqinfo->dqs[j];
>  		nqa = ntp->t_dqinfo->dqs[j];
> @@ -270,8 +263,6 @@ xfs_trans_mod_dquot(
>  
>  	if (delta)
>  		trace_xfs_trans_mod_dquot_after(qtrx);
> -
> -	tp->t_flags |= XFS_TRANS_DQ_DIRTY;
>  }
>  
>  
> @@ -348,7 +339,7 @@ xfs_trans_apply_dquot_deltas(
>  	int64_t			totalbdelta;
>  	int64_t			totalrtbdelta;
>  
> -	if (!(tp->t_flags & XFS_TRANS_DQ_DIRTY))
> +	if (!tp->t_dqinfo)
>  		return;
>  
>  	ASSERT(tp->t_dqinfo);
> @@ -490,7 +481,7 @@ xfs_trans_unreserve_and_mod_dquots(
>  	struct xfs_dqtrx	*qtrx, *qa;
>  	bool			locked;
>  
> -	if (!tp->t_dqinfo || !(tp->t_flags & XFS_TRANS_DQ_DIRTY))
> +	if (!tp->t_dqinfo)
>  		return;
>  
>  	for (j = 0; j < XFS_QM_TRANS_DQTYPES; j++) {
> -- 
> 2.20.0
> 
