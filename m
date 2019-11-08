Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C821AFC6197
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 22:30:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EEC120865
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 22:30:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jvqjryru"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbfKHWaC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 17:30:02 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:60206 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726095AbfKHWaB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 17:30:01 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA8MKpcI018815;
        Fri, 8 Nov 2019 22:29:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=SANk6kyAnsMntXSRpgftEoG5wxArGibhn0QllMSxj4s=;
 b=jvqjryruC8ujJed3Ybc2QL54gqpj31j4fyCsM4tIQqV/wOEY6NHr2JlhTv3P8NzlMePG
 24HyyBR3HZtH8JXvrh3w2/BsegxIyAQ1G8d1VzJez+QnAS7GNaPi3NMw1imhj9YW1i0h
 xfa1PH2ipagWo9ez0SNnPMYxTWcd2CMDliMUcmw2dz63iH24kqHpeaC3zTtC0HDz2D5F
 SL/EEtxEBMhSIVvTmUEWqxNOSeAQ/vC+sUR7ETDHpB3ZZ9Pql1v+LEv1C6t8evqp7zRB
 +PZ4uvr3zO/cVYI2qta1juZqUwPIy4LQ5/UG3pnKF0HQvoOmloU2ShDIS2ReWC8TfJvm Sw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2w41w17yu6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 22:29:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA8MOBga142309;
        Fri, 8 Nov 2019 22:29:50 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2w5bmqhfyb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 22:29:50 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA8MTntT020133;
        Fri, 8 Nov 2019 22:29:49 GMT
Received: from localhost (/10.159.140.196)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 Nov 2019 14:29:49 -0800
Date:   Fri, 8 Nov 2019 14:29:46 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 4/4] xfs: remove the xfs_qoff_logitem_t typedef
Message-ID: <20191108222946.GN6219@magnolia>
References: <20191108210612.423439-1-preichl@redhat.com>
 <20191108210612.423439-5-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108210612.423439-5-preichl@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9435 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080215
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9435 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911080215
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 08, 2019 at 10:06:12PM +0100, Pavel Reichl wrote:
> Signed-off-by: Pavel Reichl <preichl@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_trans_resv.c |  4 ++--
>  fs/xfs/xfs_dquot_item.h        | 14 ++++++++------
>  fs/xfs/xfs_qm_syscalls.c       | 35 ++++++++++++++++++----------------
>  fs/xfs/xfs_trans_dquot.c       | 14 +++++++-------
>  4 files changed, 36 insertions(+), 31 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> index 271cca13565b..eb7fe42b1d61 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.c
> +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> @@ -741,7 +741,7 @@ xfs_calc_qm_dqalloc_reservation(
>  
>  /*
>   * Turning off quotas.
> - *    the xfs_qoff_logitem_t: sizeof(struct xfs_qoff_logitem) * 2
> + *    sizeof(struct xfs_qoff_logitem) * 2
>   *    the superblock for the quota flags: sector size
>   */
>  STATIC uint
> @@ -754,7 +754,7 @@ xfs_calc_qm_quotaoff_reservation(
>  
>  /*
>   * End of turning off quotas.
> - *    the xfs_qoff_logitem_t: sizeof(struct xfs_qoff_logitem) * 2
> + *    sizeof(struct xfs_qoff_logitem) * 2
>   */
>  STATIC uint
>  xfs_calc_qm_quotaoff_end_reservation(void)
> diff --git a/fs/xfs/xfs_dquot_item.h b/fs/xfs/xfs_dquot_item.h
> index e0a24eb7a545..e2348a99fa1a 100644
> --- a/fs/xfs/xfs_dquot_item.h
> +++ b/fs/xfs/xfs_dquot_item.h
> @@ -17,18 +17,20 @@ struct xfs_dq_logitem {
>  	xfs_lsn_t		 qli_flush_lsn;	   /* lsn at last flush */
>  };
>  
> -typedef struct xfs_qoff_logitem {
> +struct xfs_qoff_logitem {
>  	struct xfs_log_item	 qql_item;	/* common portion */
>  	struct xfs_qoff_logitem *qql_start_lip; /* qoff-start logitem, if any */
>  	unsigned int		qql_flags;
> -} xfs_qoff_logitem_t;
> +};
>  
>  
>  extern void		   xfs_qm_dquot_logitem_init(struct xfs_dquot *);
> -extern xfs_qoff_logitem_t *xfs_qm_qoff_logitem_init(struct xfs_mount *,
> -					struct xfs_qoff_logitem *, uint);
> -extern xfs_qoff_logitem_t *xfs_trans_get_qoff_item(struct xfs_trans *,
> -					struct xfs_qoff_logitem *, uint);
> +extern struct xfs_qoff_logitem *xfs_qm_qoff_logitem_init(struct xfs_mount *mp,
> +					struct xfs_qoff_logitem *start,
> +					uint flags);
> +extern struct xfs_qoff_logitem *xfs_trans_get_qoff_item(struct xfs_trans *tp,
> +					struct xfs_qoff_logitem *startqoff,
> +					uint flags);

Kill the 'extern's, and only indent the second and third lines twice:

struct xfs_qoff_logitem *xfs_trans_get_qoff_item(struct xfs_trans *tp,
		struct xfs_qoff_logitem *startqoff, uint flags);

(Here and everywhere else...)

((Others will have different opinions about indentation but I'm lazy and
only bother doing two indents, like a lot of code in XFS.))

(((I personally dislike the kernel indent style because I don't want to
spend brainpower making all the spaces line up just exactly; I'd rather
just put in my two tabs with muscle memory and concentrate on getting
the code to work properly.)))

>  extern void		   xfs_trans_log_quotaoff_item(struct xfs_trans *,
>  					struct xfs_qoff_logitem *);
>  
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index da7ad0383037..52909cb00249 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -19,9 +19,12 @@
>  #include "xfs_qm.h"
>  #include "xfs_icache.h"
>  
> -STATIC int	xfs_qm_log_quotaoff(xfs_mount_t *, xfs_qoff_logitem_t **, uint);
> -STATIC int	xfs_qm_log_quotaoff_end(xfs_mount_t *, xfs_qoff_logitem_t *,
> -					uint);
> +STATIC int xfs_qm_log_quotaoff(struct xfs_mount *mp,
> +			       struct xfs_qoff_logitem **qoffstartp,
> +			       uint flags);
> +STATIC int xfs_qm_log_quotaoff_end(struct xfs_mount *mp,
> +				   struct xfs_qoff_logitem *startqoff,
> +				   uint flags);
>  
>  /*
>   * Turn off quota accounting and/or enforcement for all udquots and/or
> @@ -40,7 +43,7 @@ xfs_qm_scall_quotaoff(
>  	uint			dqtype;
>  	int			error;
>  	uint			inactivate_flags;
> -	xfs_qoff_logitem_t	*qoffstart;
> +	struct xfs_qoff_logitem	*qoffstart;
>  
>  	/*
>  	 * No file system can have quotas enabled on disk but not in core.
> @@ -540,13 +543,13 @@ xfs_qm_scall_setqlim(
>  
>  STATIC int
>  xfs_qm_log_quotaoff_end(
> -	xfs_mount_t		*mp,
> -	xfs_qoff_logitem_t	*startqoff,
> -	uint			flags)
> +	struct xfs_mount	*mp,
> +	struct xfs_qoff_logitem	*startqoff,
> +	uint			 flags)
>  {
> -	xfs_trans_t		*tp;
> -	int			error;
> -	xfs_qoff_logitem_t	*qoffi;
> +	struct xfs_trans	*tp;
> +	int			 error;

You don't need the extra space before 'error'.  The '*' is as much a
part of the parameter as the name.

> +	struct xfs_qoff_logitem	*qoffi;
>  
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_equotaoff, 0, 0, 0, &tp);
>  	if (error)
> @@ -568,13 +571,13 @@ xfs_qm_log_quotaoff_end(
>  
>  STATIC int
>  xfs_qm_log_quotaoff(
> -	xfs_mount_t	       *mp,
> -	xfs_qoff_logitem_t     **qoffstartp,
> -	uint		       flags)
> +	struct xfs_mount	 *mp,
> +	struct xfs_qoff_logitem **qoffstartp,
> +	uint			  flags)
>  {
> -	xfs_trans_t	       *tp;
> -	int			error;
> -	xfs_qoff_logitem_t     *qoffi;
> +	struct xfs_trans	 *tp;
> +	int			  error;
> +	struct xfs_qoff_logitem	 *qoffi;
>  
>  	*qoffstartp = NULL;
>  
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index 4789f7e11f53..0c4638c74f44 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -824,13 +824,13 @@ xfs_trans_reserve_quota_nblks(
>  /*
>   * This routine is called to allocate a quotaoff log item.
>   */
> -xfs_qoff_logitem_t *
> +struct xfs_qoff_logitem *
>  xfs_trans_get_qoff_item(
> -	xfs_trans_t		*tp,
> -	xfs_qoff_logitem_t	*startqoff,
> -	uint			flags)
> +	struct xfs_trans		*tp,

Er, please make these line up.

--D

> +	struct xfs_qoff_logitem	*startqoff,
> +	uint			 flags)
>  {
> -	xfs_qoff_logitem_t	*q;
> +	struct xfs_qoff_logitem	*q;
>  
>  	ASSERT(tp != NULL);
>  
> @@ -852,8 +852,8 @@ xfs_trans_get_qoff_item(
>   */
>  void
>  xfs_trans_log_quotaoff_item(
> -	xfs_trans_t		*tp,
> -	xfs_qoff_logitem_t	*qlp)
> +	struct xfs_trans	*tp,
> +	struct xfs_qoff_logitem	*qlp)
>  {
>  	tp->t_flags |= XFS_TRANS_DIRTY;
>  	set_bit(XFS_LI_DIRTY, &qlp->qql_item.li_flags);
> -- 
> 2.23.0
> 
