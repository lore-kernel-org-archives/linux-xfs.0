Return-Path: <SRS0=3qtu=37=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A1EFC35242
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Feb 2020 05:31:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 347E32082F
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Feb 2020 05:31:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="uTLORr9S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728185AbgBKFbG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Feb 2020 00:31:06 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:48596 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728172AbgBKFbG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Feb 2020 00:31:06 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01B5V3dm010658;
        Tue, 11 Feb 2020 05:31:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=lisBRp0FwSTCftyO948lxn647gqSQT9zBtQSdgai8h0=;
 b=uTLORr9Sr+zuHWu4JlbKKkfdXVOqplIIRforuA5GyWBMi4EWiOihU6Hy2I4cjtUNENWy
 i03aVwzYcj1qtSOi3Be2vxkc/mEjiWJ3ENroIeNgxKGBQIX2TKuc92gYJHjI5+299Gu6
 fnbvfvbOw5GYCEP4kIBD+ZzveWWDRHY+zxy5zJctScFlOlDkFaN+AR1odTnovtqOmlwU
 YyKohlKC3uZ/IqZ+0DXIZ5JUsg4dzU4QLUYc7z8ZWTHz5DYuPvDPpcPmJPO1RBTwSjhV
 N8lFD2CEivaKx0V9hBX4axQSOmZqkuBsdAyoVG7E9gJEP7RV1S+IJZ5qrUCt5EZ0U4Tu Fw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2y2p3s8tuj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 11 Feb 2020 05:31:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01B5Qw4c183845;
        Tue, 11 Feb 2020 05:30:57 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2y26fgg4te-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Feb 2020 05:30:56 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01B5UtXV032429;
        Tue, 11 Feb 2020 05:30:56 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 10 Feb 2020 21:30:55 -0800
Subject: Re: [PATCH 3/4] xfs: pass xfs_dquot to xfs_qm_adjust_dqtimers
To:     Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
References: <333ea747-8b45-52ae-006e-a1804e14de32@redhat.com>
 <f4fcefdf-3560-1b1d-fb67-cd289967b6e3@redhat.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <ce67f3a7-fbb4-c918-ad7d-aa09c1af72c7@oracle.com>
Date:   Mon, 10 Feb 2020 22:30:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <f4fcefdf-3560-1b1d-fb67-cd289967b6e3@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9527 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 adultscore=0 bulkscore=0 mlxscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002110039
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9527 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 priorityscore=1501 clxscore=1015
 impostorscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002110039
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/8/20 2:11 PM, Eric Sandeen wrote:
> Pass xfs_dquot rather than xfs_disk_dquot to xfs_qm_adjust_dqtimers;
> this makes it symmetric with xfs_qm_adjust_dqlimits and will help
> the next patch.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Looks fine
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/xfs_dquot.c       | 3 ++-
>   fs/xfs/xfs_dquot.h       | 2 +-
>   fs/xfs/xfs_qm.c          | 2 +-
>   fs/xfs/xfs_qm_syscalls.c | 2 +-
>   fs/xfs/xfs_trans_dquot.c | 2 +-
>   5 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index ddf41c24efcd..5c5fdb62f69c 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -113,8 +113,9 @@ xfs_qm_adjust_dqlimits(
>   void
>   xfs_qm_adjust_dqtimers(
>   	struct xfs_mount	*mp,
> -	struct xfs_disk_dquot	*d)
> +	struct xfs_dquot	*dq)
>   {
> +	struct xfs_disk_dquot	*d = &dq->q_core;
>   	ASSERT(d->d_id);
>   
>   #ifdef DEBUG
> diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
> index fe3e46df604b..71e36c85e20b 100644
> --- a/fs/xfs/xfs_dquot.h
> +++ b/fs/xfs/xfs_dquot.h
> @@ -154,7 +154,7 @@ void		xfs_qm_dqdestroy(struct xfs_dquot *dqp);
>   int		xfs_qm_dqflush(struct xfs_dquot *dqp, struct xfs_buf **bpp);
>   void		xfs_qm_dqunpin_wait(struct xfs_dquot *dqp);
>   void		xfs_qm_adjust_dqtimers(struct xfs_mount *mp,
> -						struct xfs_disk_dquot *d);
> +						struct xfs_dquot *d);
>   void		xfs_qm_adjust_dqlimits(struct xfs_mount *mp,
>   						struct xfs_dquot *d);
>   xfs_dqid_t	xfs_qm_id_for_quotatype(struct xfs_inode *ip, uint type);
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index b3cd87d0bccb..4e543e2bc290 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -1103,7 +1103,7 @@ xfs_qm_quotacheck_dqadjust(
>   	 */
>   	if (dqp->q_core.d_id) {
>   		xfs_qm_adjust_dqlimits(mp, dqp);
> -		xfs_qm_adjust_dqtimers(mp, &dqp->q_core);
> +		xfs_qm_adjust_dqtimers(mp, dqp);
>   	}
>   
>   	dqp->dq_flags |= XFS_DQ_DIRTY;
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index e08c2f04f3ab..ba79f355a14e 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -587,7 +587,7 @@ xfs_qm_scall_setqlim(
>   		 * is on or off. We don't really want to bother with iterating
>   		 * over all ondisk dquots and turning the timers on/off.
>   		 */
> -		xfs_qm_adjust_dqtimers(mp, ddq);
> +		xfs_qm_adjust_dqtimers(mp, dqp);
>   	}
>   	dqp->dq_flags |= XFS_DQ_DIRTY;
>   	xfs_trans_log_dquot(tp, dqp);
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index 7470b02c5198..7ae907ec7d47 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -388,7 +388,7 @@ xfs_trans_apply_dquot_deltas(
>   			 */
>   			if (d->d_id) {
>   				xfs_qm_adjust_dqlimits(tp->t_mountp, dqp);
> -				xfs_qm_adjust_dqtimers(tp->t_mountp, d);
> +				xfs_qm_adjust_dqtimers(tp->t_mountp, dqp);
>   			}
>   
>   			dqp->dq_flags |= XFS_DQ_DIRTY;
> 
