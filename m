Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3D38C433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 19:27:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 797D0206E2
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 19:27:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="c/aAw+x6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726625AbgFBT1b (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 15:27:31 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49680 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbgFBT1b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 15:27:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 052JMAhQ118145;
        Tue, 2 Jun 2020 19:27:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=wSkjXy+BErIDKboRvUY35BJ4nSK5QDiSZ7YmePRrUy4=;
 b=c/aAw+x6xJC2IipeYyoFqXXOpN3SPFgAlIf5829EOVrb7CJJYRTLT+IanMNlKl7euWfi
 eLUMOjoBW+oAhS7Jf6vOhUWKa0Sqebsfj4nt98sHPExCtZvFWoO+xR9AAaCz4Z4SlWLq
 K5h8dFFtu4jGgkTiYxC63vRPnzsOjCbY004FLjd8h1p1iCEI87tCB4IIg/u4l0yHcvGl
 xbSpfYYQoqQMStSEmEt6cdNrWJZlojAdKs+PRWknL5C0HzSKPtY87mK8Yyx+XDMRbQgl
 PwWBR9soKb4uU7QtROxinqThYnvcnufE060V96fDhVkLM5xoryGyrf07KDLtZmHO2O8U SQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 31dkrujt02-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 19:27:29 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 052JNcu7043218;
        Tue, 2 Jun 2020 19:25:28 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 31c12pqq1s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 19:25:28 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 052JPRMf030633;
        Tue, 2 Jun 2020 19:25:27 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Jun 2020 12:25:27 -0700
Date:   Tue, 2 Jun 2020 12:25:26 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/30] xfs: use direct calls for dquot IO completion
Message-ID: <20200602192526.GI8230@magnolia>
References: <20200601214251.4167140-1-david@fromorbit.com>
 <20200601214251.4167140-11-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200601214251.4167140-11-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 adultscore=0 suspectscore=1 spamscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006020141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 priorityscore=1501
 mlxscore=0 lowpriorityscore=0 suspectscore=1 malwarescore=0 clxscore=1015
 adultscore=0 mlxlogscore=999 cotscore=-2147483648 phishscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020141
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 02, 2020 at 07:42:31AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Similar to inodes, we can call the dquot IO completion functions
> directly from the buffer completion code, removing another user of
> log item callbacks for IO completion processing.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_buf_item.c | 18 +++++++++++++++++-
>  fs/xfs/xfs_dquot.c    | 18 ++++++++++++++----
>  fs/xfs/xfs_dquot.h    |  1 +
>  3 files changed, 32 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index a4e416af5c614..f46e5ec28111c 100644
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
> index 2e2146fa0914c..403bc4e9f21ff 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -1048,9 +1048,8 @@ xfs_qm_dqrele(
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
> @@ -1091,6 +1090,18 @@ xfs_qm_dqflush_done(
>  	xfs_dqfunlock(dqp);
>  }
>  
> +void
> +xfs_dquot_done(
> +	struct xfs_buf		*bp)
> +{
> +	struct xfs_log_item	*lip, *n;
> +
> +	list_for_each_entry_safe(lip, n, &bp->b_li_list, li_bio_list) {
> +		list_del_init(&lip->li_bio_list);
> +		xfs_qm_dqflush_done(lip);
> +	}
> +}
> +
>  /*
>   * Write a modified dquot to disk.
>   * The dquot must be locked and the flush lock too taken by caller.
> @@ -1180,8 +1191,7 @@ xfs_qm_dqflush(
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
> index 71e36c85e20b6..fe9cc3e08ed6d 100644
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
