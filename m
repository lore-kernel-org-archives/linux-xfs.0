Return-Path: <SRS0=UH25=7B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D385C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 16:26:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A60D20756
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 16:26:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xBSaruwL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729385AbgESQ0S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 May 2020 12:26:18 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39126 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729340AbgESQ0R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 May 2020 12:26:17 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04JGHjFc079431;
        Tue, 19 May 2020 16:26:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=qECBiHqCUB2LXj/vXJUYbO3Q2bBiBsxTz/BD3JVOiW8=;
 b=xBSaruwLK2fBZQ+6RtnDmUkcW8cfZXgY3mzv9t7aXrmn10VZrtn0BT6IcCeXib2+IOqv
 YKcfcTqcccjouavepbNvCL5bYndGXQzdM9Y2dvj9EvNHouDRS995hrS9l9cgl/6cxl3W
 mT8yRuZiUTRmFEXNZsDiIOCpenUmcGR2/DLrMO9VbNAA1sxTHXxuoQEZBR7e+wQYA5AM
 H2cUPEMT0TS22pQUwJjXYjBHDK3WozpfP9s2JqA6V4ezJtBlLVDe/ludBdin0/nWlMSa
 4St5t0bGzbgKKPbrR3BA1mCQ5QuO/k6tMAh3vuRkGEGMKX8fZ1E4q30QXfJTTq9VmN/h aA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 31284kxepw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 19 May 2020 16:26:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04JGMOtq174307;
        Tue, 19 May 2020 16:26:12 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 314gm59pne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 May 2020 16:26:11 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04JGQA4w015832;
        Tue, 19 May 2020 16:26:10 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 May 2020 09:26:10 -0700
Date:   Tue, 19 May 2020 09:26:09 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 4/6] xfs: pass xfs_dquot to xfs_qm_adjust_dqtimers
Message-ID: <20200519162609.GN17627@magnolia>
References: <ea649599-f8a9-deb9-726e-329939befade@redhat.com>
 <842a7671-b514-d698-b996-5c1ccf65a6ad@redhat.com>
 <731f9886-d36f-aafb-8bb4-a82d3868268d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <731f9886-d36f-aafb-8bb4-a82d3868268d@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 phishscore=0 mlxscore=0 spamscore=0 suspectscore=1
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005190139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxscore=0
 cotscore=-2147483648 impostorscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005190138
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 18, 2020 at 01:50:18PM -0500, Eric Sandeen wrote:
> Pass xfs_dquot rather than xfs_disk_dquot to xfs_qm_adjust_dqtimers;
> this makes it symmetric with xfs_qm_adjust_dqlimits and will help
> the next patch.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Reviewed-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Seems reasonable,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_dquot.c       | 3 ++-
>  fs/xfs/xfs_dquot.h       | 2 +-
>  fs/xfs/xfs_qm.c          | 2 +-
>  fs/xfs/xfs_qm_syscalls.c | 2 +-
>  fs/xfs/xfs_trans_dquot.c | 2 +-
>  5 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 96e33390c6a0..6d6afc0297b3 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -114,8 +114,9 @@ xfs_qm_adjust_dqlimits(
>  void
>  xfs_qm_adjust_dqtimers(
>  	struct xfs_mount	*mp,
> -	struct xfs_disk_dquot	*d)
> +	struct xfs_dquot	*dq)
>  {
> +	struct xfs_disk_dquot	*d = &dq->q_core;
>  	ASSERT(d->d_id);
>  
>  #ifdef DEBUG
> diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
> index fe3e46df604b..71e36c85e20b 100644
> --- a/fs/xfs/xfs_dquot.h
> +++ b/fs/xfs/xfs_dquot.h
> @@ -154,7 +154,7 @@ void		xfs_qm_dqdestroy(struct xfs_dquot *dqp);
>  int		xfs_qm_dqflush(struct xfs_dquot *dqp, struct xfs_buf **bpp);
>  void		xfs_qm_dqunpin_wait(struct xfs_dquot *dqp);
>  void		xfs_qm_adjust_dqtimers(struct xfs_mount *mp,
> -						struct xfs_disk_dquot *d);
> +						struct xfs_dquot *d);
>  void		xfs_qm_adjust_dqlimits(struct xfs_mount *mp,
>  						struct xfs_dquot *d);
>  xfs_dqid_t	xfs_qm_id_for_quotatype(struct xfs_inode *ip, uint type);
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 591779aa2fd0..e97a3802939c 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -1116,7 +1116,7 @@ xfs_qm_quotacheck_dqadjust(
>  	 */
>  	if (dqp->q_core.d_id) {
>  		xfs_qm_adjust_dqlimits(mp, dqp);
> -		xfs_qm_adjust_dqtimers(mp, &dqp->q_core);
> +		xfs_qm_adjust_dqtimers(mp, dqp);
>  	}
>  
>  	dqp->dq_flags |= XFS_DQ_DIRTY;
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index 5d5ac65aa1cc..301a284ee4f9 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -588,7 +588,7 @@ xfs_qm_scall_setqlim(
>  		 * is on or off. We don't really want to bother with iterating
>  		 * over all ondisk dquots and turning the timers on/off.
>  		 */
> -		xfs_qm_adjust_dqtimers(mp, ddq);
> +		xfs_qm_adjust_dqtimers(mp, dqp);
>  	}
>  	dqp->dq_flags |= XFS_DQ_DIRTY;
>  	xfs_trans_log_dquot(tp, dqp);
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index 2c07897a3c37..20542076e32a 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -388,7 +388,7 @@ xfs_trans_apply_dquot_deltas(
>  			 */
>  			if (d->d_id) {
>  				xfs_qm_adjust_dqlimits(tp->t_mountp, dqp);
> -				xfs_qm_adjust_dqtimers(tp->t_mountp, d);
> +				xfs_qm_adjust_dqtimers(tp->t_mountp, dqp);
>  			}
>  
>  			dqp->dq_flags |= XFS_DQ_DIRTY;
> -- 
> 2.17.0
> 
> 
