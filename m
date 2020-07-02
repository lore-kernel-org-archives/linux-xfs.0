Return-Path: <SRS0=cy20=AN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F4102C433DF
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jul 2020 02:06:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2AC82083E
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jul 2020 02:06:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RzzdRdjf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728087AbgGBCGp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 22:06:45 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46254 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727778AbgGBCGp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 22:06:45 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0621xmOt066489
        for <linux-xfs@vger.kernel.org>; Thu, 2 Jul 2020 02:06:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=xoasW5Ghcr0svmwzRrlYQuf2U041uqtVNk1QVoju+6g=;
 b=RzzdRdjfS4nPZpFVweaM+r0ZY4veJqjbKItymG/87U/SgDLnHjz+xsoFKhomIzv991z2
 qItSpVlaOVB1HzJLOAnpCOhnuPu+bdEGN2RIwFVzCr6jFcGHyane4OeA7unJBBQBvdAG
 nMjAkBH0ctyUMpr+beFuj8i7WKM4ql1P8JtJKCd7MEzlSStFm6fGhtZHKu4fCBF05ZHV
 zxH6ia2m1T2kC/xRHYzUrp1Ye9Ji7rvvbn5XlWi2zonRgmbqrrxMNJLdm+77Ta0mTLGD
 Hdd8zWB65N1hyR5NeMhU5FnsjafYCgyRGtYPQ68bKOAk+VXT5HVw3G5ApFjNlWquq2wZ Rg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 31ywrbuy34-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 02 Jul 2020 02:06:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0621vpre136206
        for <linux-xfs@vger.kernel.org>; Thu, 2 Jul 2020 02:06:43 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 31xg205dqc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 02 Jul 2020 02:06:43 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06226gvZ026206
        for <linux-xfs@vger.kernel.org>; Thu, 2 Jul 2020 02:06:42 GMT
Received: from [192.168.1.226] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Jul 2020 02:06:42 +0000
Subject: Re: [PATCH 13/18] xfs: remove unnecessary arguments from quota adjust
 functions
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
 <159353179380.2864738.11917531841285726141.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <b32fe295-89a3-a1fb-47ff-4f6f89bda232@oracle.com>
Date:   Wed, 1 Jul 2020 19:06:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <159353179380.2864738.11917531841285726141.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007020012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 clxscore=1015 cotscore=-2147483648 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 mlxscore=0 adultscore=0 suspectscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007020012
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 6/30/20 8:43 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> struct xfs_dquot already has a pointer to the xfs mount, so remove the
> redundant parameter from xfs_qm_adjust_dq*.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/xfs_dquot.c       |    4 ++--
>   fs/xfs/xfs_dquot.h       |    6 ++----
>   fs/xfs/xfs_qm.c          |    4 ++--
>   fs/xfs/xfs_qm_syscalls.c |    2 +-
>   fs/xfs/xfs_trans_dquot.c |    4 ++--
>   5 files changed, 9 insertions(+), 11 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 6975c27145fc..35a113d1b42b 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -66,9 +66,9 @@ xfs_qm_dqdestroy(
>    */
>   void
>   xfs_qm_adjust_dqlimits(
> -	struct xfs_mount	*mp,
>   	struct xfs_dquot	*dq)
>   {
> +	struct xfs_mount	*mp = dq->q_mount;
>   	struct xfs_quotainfo	*q = mp->m_quotainfo;
>   	struct xfs_def_quota	*defq;
>   	int			prealloc = 0;
> @@ -112,9 +112,9 @@ xfs_qm_adjust_dqlimits(
>    */
>   void
>   xfs_qm_adjust_dqtimers(
> -	struct xfs_mount	*mp,
>   	struct xfs_dquot	*dq)
>   {
> +	struct xfs_mount	*mp = dq->q_mount;
>   	struct xfs_quotainfo	*qi = mp->m_quotainfo;
>   	struct xfs_def_quota	*defq;
>   
> diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
> index 62b0fc6e0133..e37b4bebc1ea 100644
> --- a/fs/xfs/xfs_dquot.h
> +++ b/fs/xfs/xfs_dquot.h
> @@ -181,10 +181,8 @@ void xfs_dquot_to_disk(struct xfs_disk_dquot *ddqp, struct xfs_dquot *dqp);
>   void		xfs_qm_dqdestroy(struct xfs_dquot *dqp);
>   int		xfs_qm_dqflush(struct xfs_dquot *dqp, struct xfs_buf **bpp);
>   void		xfs_qm_dqunpin_wait(struct xfs_dquot *dqp);
> -void		xfs_qm_adjust_dqtimers(struct xfs_mount *mp,
> -						struct xfs_dquot *d);
> -void		xfs_qm_adjust_dqlimits(struct xfs_mount *mp,
> -						struct xfs_dquot *d);
> +void		xfs_qm_adjust_dqtimers(struct xfs_dquot *d);
> +void		xfs_qm_adjust_dqlimits(struct xfs_dquot *d);
>   xfs_dqid_t	xfs_qm_id_for_quotatype(struct xfs_inode *ip, uint type);
>   int		xfs_qm_dqget(struct xfs_mount *mp, xfs_dqid_t id,
>   					uint type, bool can_alloc,
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 28326a6264a8..30deb6cf6a7a 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -1107,8 +1107,8 @@ xfs_qm_quotacheck_dqadjust(
>   	 * There are no timers for the default values set in the root dquot.
>   	 */
>   	if (dqp->q_id) {
> -		xfs_qm_adjust_dqlimits(mp, dqp);
> -		xfs_qm_adjust_dqtimers(mp, dqp);
> +		xfs_qm_adjust_dqlimits(dqp);
> +		xfs_qm_adjust_dqtimers(dqp);
>   	}
>   
>   	dqp->dq_flags |= XFS_DQ_DIRTY;
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index 393b88612cc8..5423e02f9837 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -594,7 +594,7 @@ xfs_qm_scall_setqlim(
>   		 * is on or off. We don't really want to bother with iterating
>   		 * over all ondisk dquots and turning the timers on/off.
>   		 */
> -		xfs_qm_adjust_dqtimers(mp, dqp);
> +		xfs_qm_adjust_dqtimers(dqp);
>   	}
>   	dqp->dq_flags |= XFS_DQ_DIRTY;
>   	xfs_trans_log_dquot(tp, dqp);
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index 392e51baad6f..2712814d696d 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -382,8 +382,8 @@ xfs_trans_apply_dquot_deltas(
>   			 * Start/reset the timer(s) if needed.
>   			 */
>   			if (dqp->q_id) {
> -				xfs_qm_adjust_dqlimits(tp->t_mountp, dqp);
> -				xfs_qm_adjust_dqtimers(tp->t_mountp, dqp);
> +				xfs_qm_adjust_dqlimits(dqp);
> +				xfs_qm_adjust_dqtimers(dqp);
>   			}
>   
>   			dqp->dq_flags |= XFS_DQ_DIRTY;
> 
