Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE7D2C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 22:13:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B42FB20757
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 22:13:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aFnRGWF7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731117AbgEVWNY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 May 2020 18:13:24 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43490 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731051AbgEVWNX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 May 2020 18:13:23 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MMBci4104031;
        Fri, 22 May 2020 22:13:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=JN5bDQzmuHc9RuZgP8aSXtbHtCNTZrCrO3udlZkMwIM=;
 b=aFnRGWF7LyydKzWUhws8N3nGzreBvV2PPQUqv3WBiayVArxQ1ZlJxOSwH1XAw5Cgc8fd
 Nl9CVT67juTRUzv34QtEPUIlBOv2le/vUijROitGGYG9Z8/vkmuz6NMzumhTNcHu/xz2
 2QcWmbKMCLRT6FV1kNwbIrcIMxTuzfCsAKWEPXkvmI+hwHZBqiwUCph3vfvFLySMeMMw
 JTHTjD02P0KA/IK6NtVAz7xkPYeSgs4PEs6BgOjBMDeefKWWEJ8eqVpYM3QiOHSBty/K
 lIWmNjNgIaQs3WtQe88kkxzgebkKq8qU6QLZE+6GGbBBuJIsKvNctK/shmVu8LTJa2g4 kA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 3127krr02c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 22:13:21 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MMDKhQ064712;
        Fri, 22 May 2020 22:13:21 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 3150252wmr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 May 2020 22:13:21 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04MMDFUO008736;
        Fri, 22 May 2020 22:13:15 GMT
Received: from localhost (/10.159.153.228)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 May 2020 15:13:15 -0700
Date:   Fri, 22 May 2020 15:13:14 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/24] xfs: use direct calls for dquot IO completion
Message-ID: <20200522221314.GM8230@magnolia>
References: <20200522035029.3022405-1-david@fromorbit.com>
 <20200522035029.3022405-10-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522035029.3022405-10-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 suspectscore=1 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005220172
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=1 mlxlogscore=999 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005220172
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 22, 2020 at 01:50:14PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Similar to inodes, we can call the dquot IO completion functions
> directly from the buffer completion code, removing another user of
> log item callbacks for IO completion processing.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks pretty straightforward.  I bet li_cb goes away soon?

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_buf_item.c | 18 +++++++++++++++++-
>  fs/xfs/xfs_dquot.c    | 27 +++++++++++++++++++++++----
>  fs/xfs/xfs_dquot.h    |  1 +
>  3 files changed, 41 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index e376f778bf57c..57e5d37f6852e 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -15,6 +15,9 @@
>  #include "xfs_buf_item.h"
>  #include "xfs_inode.h"
>  #include "xfs_inode_item.h"
> +#include "xfs_quota.h"
> +#include "xfs_dquot_item.h"
> +#include "xfs_dquot.h"
>  #include "xfs_trans_priv.h"
>  #include "xfs_trace.h"
>  #include "xfs_log.h"
> @@ -1209,7 +1212,20 @@ void
>  xfs_buf_dquot_iodone(
>  	struct xfs_buf		*bp)
>  {
> -	xfs_buf_run_callbacks(bp);
> +	struct xfs_buf_log_item *blip = bp->b_log_item;
> +	struct xfs_log_item	*lip;
> +
> +	if (xfs_buf_had_callback_errors(bp))
> +		return;
> +
> +	/* a newly allocated dquot buffer might have a log item attached */
> +	if (blip) {
> +		lip = &blip->bli_item;
> +		lip->li_cb(bp, lip);
> +		bp->b_log_item = NULL;
> +	}
> +
> +	xfs_dquot_done(bp);
>  	xfs_buf_ioend_finish(bp);
>  }
>  
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 25592b701db40..1d7f34a9bc989 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -1043,9 +1043,8 @@ xfs_qm_dqrele(
>   * from the AIL if it has not been re-logged, and unlocking the dquot's
>   * flush lock. This behavior is very similar to that of inodes..
>   */
> -STATIC void
> +static void
>  xfs_qm_dqflush_done(
> -	struct xfs_buf		*bp,
>  	struct xfs_log_item	*lip)
>  {
>  	struct xfs_dq_logitem	*qip = (struct xfs_dq_logitem *)lip;
> @@ -1086,6 +1085,27 @@ xfs_qm_dqflush_done(
>  	xfs_dqfunlock(dqp);
>  }
>  
> +void
> +xfs_dquot_done(
> +	struct xfs_buf		*bp)
> +{
> +	struct xfs_log_item	*lip;
> +
> +	while (!list_empty(&bp->b_li_list)) {
> +		lip = list_first_entry(&bp->b_li_list, struct xfs_log_item,
> +				       li_bio_list);
> +
> +		/*
> +		 * Remove the item from the list, so we don't have any
> +		 * confusion if the item is added to another buf.
> +		 * Don't touch the log item after calling its
> +		 * callback, because it could have freed itself.
> +		 */
> +		list_del_init(&lip->li_bio_list);
> +		xfs_qm_dqflush_done(lip);
> +	}
> +}
> +
>  /*
>   * Write a modified dquot to disk.
>   * The dquot must be locked and the flush lock too taken by caller.
> @@ -1175,8 +1195,7 @@ xfs_qm_dqflush(
>  	 * AIL and release the flush lock once the dquot is synced to disk.
>  	 */
>  	bp->b_flags |= _XBF_DQUOTS;
> -	xfs_buf_attach_iodone(bp, xfs_qm_dqflush_done,
> -				  &dqp->q_logitem.qli_item);
> +	xfs_buf_attach_iodone(bp, NULL, &dqp->q_logitem.qli_item);
>  
>  	/*
>  	 * If the buffer is pinned then push on the log so we won't
> diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
> index fe3e46df604b4..f1924288986d3 100644
> --- a/fs/xfs/xfs_dquot.h
> +++ b/fs/xfs/xfs_dquot.h
> @@ -174,6 +174,7 @@ void		xfs_qm_dqput(struct xfs_dquot *dqp);
>  void		xfs_dqlock2(struct xfs_dquot *, struct xfs_dquot *);
>  
>  void		xfs_dquot_set_prealloc_limits(struct xfs_dquot *);
> +void		xfs_dquot_done(struct xfs_buf *);
>  
>  static inline struct xfs_dquot *xfs_qm_dqhold(struct xfs_dquot *dqp)
>  {
> -- 
> 2.26.2.761.g0e0b3e54be
> 
