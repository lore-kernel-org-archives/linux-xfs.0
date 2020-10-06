Return-Path: <SRS0=guuR=DN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71517C41604
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 04:43:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FCCF2075A
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 04:43:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="M3EX3Hf1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725917AbgJFEnk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Oct 2020 00:43:40 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:60260 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725806AbgJFEnk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Oct 2020 00:43:40 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0964Q745095178;
        Tue, 6 Oct 2020 04:42:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=lZ2m38k7RtCNl5KJ7mrUrXSAz2KyEB5kxJPtlZzgskk=;
 b=M3EX3Hf1gUuVlGkdg+NNvm1BRAC34kEHhrBMa6GbsGkNUGShICoCv4OmxHagLiFVooq1
 VnVXvBXerh58uHA+kRRrOB+3E4BIVWCiKOMLxiepDO+1WT5//9GO14re4R0o+J27ErPz
 6B/YD+gx946QRECJ+5TqSH78sKcm4bbXGyQUqVw+/JqCQ1w5gPyP8jCWiJuIgy03F9Br
 rT4cTHjWhKHR8w8YyJPEJbWs6pbPY1I6ClcMB5kxej84N6tWyFL5CLyVhLSnukO/5xTf
 sFFB+lyAQApvyRgP4dgaoB97/hvOpgtu3MiZdGziDkz+2xBBsVKdVrxt0zMLHlG0XEEg sg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 33xetasyhg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 06 Oct 2020 04:42:40 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0964fR4w136537;
        Tue, 6 Oct 2020 04:42:39 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 33y2vmfbft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Oct 2020 04:42:39 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0964gcbe007499;
        Tue, 6 Oct 2020 04:42:38 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 05 Oct 2020 21:42:38 -0700
Date:   Mon, 5 Oct 2020 21:42:37 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH v2 3/4] xfs: check tp->t_dqinfo value instead of the
 XFS_TRANS_DQ_DIRTY flag
Message-ID: <20201006044237.GV49547@magnolia>
References: <1601126073-32453-1-git-send-email-kaixuxia@tencent.com>
 <1601126073-32453-4-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1601126073-32453-4-git-send-email-kaixuxia@tencent.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=3 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010060026
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=3 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010060025
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Sep 26, 2020 at 09:14:32PM +0800, xiakaixu1987@gmail.com wrote:
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
> ---
>  fs/xfs/libxfs/xfs_shared.h |  1 -
>  fs/xfs/xfs_inode.c         |  8 +-------
>  fs/xfs/xfs_trans_dquot.c   | 20 ++------------------
>  3 files changed, 3 insertions(+), 26 deletions(-)
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
> index 49624973eecc..9108eed0ea45 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -941,7 +941,6 @@ xfs_dir_ialloc(
>  	xfs_buf_t	*ialloc_context = NULL;
>  	int		code;
>  	void		*dqinfo;
> -	uint		tflags;
>  
>  	tp = *tpp;
>  	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
> @@ -1000,12 +999,9 @@ xfs_dir_ialloc(
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
> @@ -1013,10 +1009,8 @@ xfs_dir_ialloc(
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
> index fe45b0c3970c..0ebfd7930382 100644
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
> @@ -143,9 +136,6 @@ xfs_trans_mod_dquot_byino(
>  	    xfs_is_quota_inode(&mp->m_sb, ip->i_ino))
>  		return;
>  
> -	if (tp->t_dqinfo == NULL)
> -		xfs_trans_alloc_dqinfo(tp);

This change ought to be a separate clean patch.

> -
>  	if (XFS_IS_UQUOTA_ON(mp) && ip->i_udquot)
>  		(void) xfs_trans_mod_dquot(tp, ip->i_udquot, field, delta);
>  	if (XFS_IS_GQUOTA_ON(mp) && ip->i_gdquot)
> @@ -273,8 +263,6 @@ xfs_trans_mod_dquot(
>  
>  	if (delta)
>  		trace_xfs_trans_mod_dquot_after(qtrx);
> -
> -	tp->t_flags |= XFS_TRANS_DQ_DIRTY;
>  }
>  
>  
> @@ -351,7 +339,7 @@ xfs_trans_apply_dquot_deltas(
>  	int64_t			totalbdelta;
>  	int64_t			totalrtbdelta;
>  
> -	if (!(tp->t_flags & XFS_TRANS_DQ_DIRTY))
> +	if (!tp->t_dqinfo)
>  		return;
>  
>  	ASSERT(tp->t_dqinfo);
> @@ -493,7 +481,7 @@ xfs_trans_unreserve_and_mod_dquots(
>  	struct xfs_dqtrx	*qtrx, *qa;
>  	bool			locked;
>  
> -	if (!tp->t_dqinfo || !(tp->t_flags & XFS_TRANS_DQ_DIRTY))
> +	if (!tp->t_dqinfo)
>  		return;
>  
>  	for (j = 0; j < XFS_QM_TRANS_DQTYPES; j++) {
> @@ -698,7 +686,6 @@ xfs_trans_dqresv(
>  	 * because we don't have the luxury of a transaction envelope then.
>  	 */
>  	if (tp) {
> -		ASSERT(tp->t_dqinfo);
>  		ASSERT(flags & XFS_QMOPT_RESBLK_MASK);
>  		if (nblks != 0)
>  			xfs_trans_mod_dquot(tp, dqp,
> @@ -752,9 +739,6 @@ xfs_trans_reserve_quota_bydquots(
>  	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
>  		return 0;
>  
> -	if (tp && tp->t_dqinfo == NULL)
> -		xfs_trans_alloc_dqinfo(tp);

Um, who allocates the dqinfo in this case?

--D

> -
>  	ASSERT(flags & XFS_QMOPT_RESBLK_MASK);
>  
>  	if (udqp) {
> -- 
> 2.20.0
> 
