Return-Path: <SRS0=eyVf=CG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F30EFC433E6
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Aug 2020 04:10:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C298C20936
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Aug 2020 04:10:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dXmBRQNs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725808AbgH1EKd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Aug 2020 00:10:33 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37166 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgH1EKd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Aug 2020 00:10:33 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07S49UIk030279;
        Fri, 28 Aug 2020 04:10:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=/UayZHFSK/WaABQQ4vQ6qF9f0dPDNBLso5WdiRQNI5k=;
 b=dXmBRQNs6LoEyYcEEAJd+CNEQ4ZnAQmax1tpBT2PdYVXf1HkL4/K1Gf6QBresigPIwc9
 CQwLvHC/KFatNOp6tN1DY9zexeAy+WlISqh6rnXrA2ATgWU9pEgtb2K1ZnjUwM6YdqfF
 sVcJ9jXkkQfSc70PV4eKwx6VyyVvFz7QOMjjsGqocEsXEgvONdtYw5DBV00a8roBYTXX
 nIsGht78QvKaHVPACj37GZXxX4rU4Pi1N4am+BVuZybB/1FlkkLEmh+nccZ8nC4RCgqu
 WmlK0UGxunJPL91uvZ6S2JFnhW8TJoPiCiimb3C3wsEcGySFT05VdpIjQc5E4fsqf5MQ EA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 333w6u8crt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 28 Aug 2020 04:10:26 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07S40uWG085699;
        Fri, 28 Aug 2020 04:08:26 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 333r9p75ak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Aug 2020 04:08:25 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07S48P4E031489;
        Fri, 28 Aug 2020 04:08:25 GMT
Received: from [192.168.1.226] (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 27 Aug 2020 21:08:25 -0700
Subject: Re: [PATCH 03/11] xfs: refactor default quota grace period setting
 code
To:     "Darrick J. Wong" <darrick.wong@oracle.com>, david@fromorbit.com,
        hch@infradead.org
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        sandeen@sandeen.net
References: <159847949739.2601708.16579235017313836378.stgit@magnolia>
 <159847951741.2601708.15806838224468188924.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <d7bbc6e1-140a-354b-57e5-bf8e8e19fcc8@oracle.com>
Date:   Thu, 27 Aug 2020 21:08:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <159847951741.2601708.15806838224468188924.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9726 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008280032
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9726 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 malwarescore=0 spamscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008280033
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 8/26/20 3:05 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor the code that sets the default quota grace period into a helper
> function so that we can override the ondisk behavior later.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Looks ok
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/libxfs/xfs_format.h |   13 +++++++++++++
>   fs/xfs/xfs_dquot.c         |    8 ++++++++
>   fs/xfs/xfs_dquot.h         |    1 +
>   fs/xfs/xfs_qm_syscalls.c   |    4 ++--
>   4 files changed, 24 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index cb316053d3db..4b68a473b090 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -1209,6 +1209,11 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
>    * been reached, and therefore no expiration has been set.  Therefore, the
>    * ondisk min and max defined here can be used directly to constrain the incore
>    * quota expiration timestamps on a Unix system.
> + *
> + * The grace period for each quota type is stored in the root dquot (id = 0)
> + * and is applied to a non-root dquot when it exceeds the soft or hard limits.
> + * The length of quota grace periods are unsigned 32-bit quantities measured in
> + * units of seconds.  A value of zero means to use the default period.
>    */
>   
>   /*
> @@ -1223,6 +1228,14 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
>    */
>   #define XFS_DQ_LEGACY_EXPIRY_MAX	((int64_t)U32_MAX)
>   
> +/*
> + * Default quota grace periods, ranging from zero (use the compiled defaults)
> + * to ~136 years.  These are applied to a non-root dquot that has exceeded
> + * either limit.
> + */
> +#define XFS_DQ_GRACE_MIN		((int64_t)0)
> +#define XFS_DQ_GRACE_MAX		((int64_t)U32_MAX)
> +
>   /*
>    * This is the main portion of the on-disk representation of quota information
>    * for a user.  We pad this with some more expansion room to construct the on
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index f34841f98d44..e63a933413a3 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -110,6 +110,14 @@ xfs_dquot_set_timeout(
>   					  qi->qi_expiry_max);
>   }
>   
> +/* Set the length of the default grace period. */
> +time64_t
> +xfs_dquot_set_grace_period(
> +	time64_t		grace)
> +{
> +	return clamp_t(time64_t, grace, XFS_DQ_GRACE_MIN, XFS_DQ_GRACE_MAX);
> +}
> +
>   /*
>    * Determine if this quota counter is over either limit and set the quota
>    * timers as appropriate.
> diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
> index 0e449101c861..f642884a6834 100644
> --- a/fs/xfs/xfs_dquot.h
> +++ b/fs/xfs/xfs_dquot.h
> @@ -238,5 +238,6 @@ int xfs_qm_dqiterate(struct xfs_mount *mp, xfs_dqtype_t type,
>   		xfs_qm_dqiterate_fn iter_fn, void *priv);
>   
>   time64_t xfs_dquot_set_timeout(struct xfs_mount *mp, time64_t timeout);
> +time64_t xfs_dquot_set_grace_period(time64_t grace);
>   
>   #endif /* __XFS_DQUOT_H__ */
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index 750f775ae915..ca1b57d291dc 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -486,8 +486,8 @@ xfs_setqlim_timer(
>   {
>   	if (qlim) {
>   		/* Set the length of the default grace period. */
> -		res->timer = timer;
> -		qlim->time = timer;
> +		res->timer = xfs_dquot_set_grace_period(timer);
> +		qlim->time = res->timer;
>   	} else {
>   		/* Set the grace period expiration on a quota. */
>   		res->timer = xfs_dquot_set_timeout(mp, timer);
> 
