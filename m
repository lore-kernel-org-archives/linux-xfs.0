Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2983C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 21:42:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B91B920759
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 21:42:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ieKJBz9g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731036AbgEVVmB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 May 2020 17:42:01 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52108 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731033AbgEVVmA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 May 2020 17:42:00 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MLfWbW055000;
        Fri, 22 May 2020 21:41:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=WpTXIVMeIRGYlqpW870hrtLNLd4Owwrjguip/QY8jTU=;
 b=ieKJBz9gz6f/v/ajNLlgQ2G4sPZQzLuIBWyCa+Xc9lizzR4tfsUd+ETbG13JepxIw9hB
 DxRruqkj5RiRud3Ox/O7RGUwpHbcE8/snZFElfPZIThPPFlFplegGB06q6UbK+Mc5cUM
 1RlMs1uDo+7omF7bILa+Ze/v1TnyFZCxtpoTbcoutO/d03TgXTtZwoz6aem4AfQDSNR+
 R8C3uDlx+gwd2Jm4fts5VxLPZIAW6rk8uQRld+S0do9zqXbC3ZT8slxRMsWW4ILrWHyz
 ByqISaBG/8tbK6daaiOPjCjRgnVRK61Wgeaf+4N99P37/CudKBmixwUL0OKx5cw3T5kP +A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3127krqweh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 21:41:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MLcbqu171124;
        Fri, 22 May 2020 21:41:58 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 314gmburt9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 May 2020 21:41:58 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04MLfvuq008317;
        Fri, 22 May 2020 21:41:57 GMT
Received: from localhost (/10.159.153.228)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 May 2020 14:41:57 -0700
Date:   Fri, 22 May 2020 14:41:55 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/24] xfs: mark log recovery buffers for completion
Message-ID: <20200522214155.GI8230@magnolia>
References: <20200522035029.3022405-1-david@fromorbit.com>
 <20200522035029.3022405-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522035029.3022405-6-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 phishscore=0 mlxscore=0 spamscore=0 suspectscore=1
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005220167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=1 mlxlogscore=999 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005220168
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 22, 2020 at 01:50:10PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Log recovery has it's own buffer write completion handler for
> buffers that it directly recovers. Convert these to direct calls by
> flagging these buffers as being log recovery buffers. The flag will
> get cleared by the log recovery IO completion routine, so it will
> never leak out of log recovery.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_buf.c                | 10 ++++++++++
>  fs/xfs/xfs_buf.h                |  2 ++
>  fs/xfs/xfs_buf_item_recover.c   |  5 ++---
>  fs/xfs/xfs_dquot_item_recover.c |  2 +-
>  fs/xfs/xfs_inode_item_recover.c |  2 +-
>  fs/xfs/xfs_log_recover.c        |  5 ++---
>  6 files changed, 18 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 77d40eb4a11db..b89685ce8519d 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -14,6 +14,7 @@
>  #include "xfs_mount.h"
>  #include "xfs_trace.h"
>  #include "xfs_log.h"
> +#include "xfs_log_recover.h"
>  #include "xfs_trans.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_errortag.h"
> @@ -1207,6 +1208,15 @@ xfs_buf_ioend(
>  	if (read)
>  		goto out_finish;
>  
> +	/*
> +	 * If this is a log recovery buffer, we aren't doing transactional IO
> +	 * yet so we need to let it handle IO completions.
> +	 */
> +	if (bp->b_flags & _XBF_LOGRCVY) {
> +		xlog_recover_iodone(bp);
> +		return;
> +	}
> +
>  	/* inodes always have a callback on write */
>  	if (bp->b_flags & _XBF_INODES) {
>  		xfs_buf_inode_iodone(bp);
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index cbde44ecb3963..c5fe4c48c9080 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -33,6 +33,7 @@
>  /* buffer type flags for write callbacks */
>  #define _XBF_INODES	 (1 << 16)/* inode buffer */
>  #define _XBF_DQUOTS	 (1 << 17)/* dquot buffer */
> +#define _XBF_LOGRCVY	 (1 << 18)/* log recovery buffer */
>  
>  /* flags used only internally */
>  #define _XBF_PAGES	 (1 << 20)/* backed by refcounted pages */
> @@ -57,6 +58,7 @@ typedef unsigned int xfs_buf_flags_t;
>  	{ XBF_WRITE_FAIL,	"WRITE_FAIL" }, \
>  	{ _XBF_INODES,		"INODES" }, \
>  	{ _XBF_DQUOTS,		"DQUOTS" }, \
> +	{ _XBF_LOGRCVY,		"LOG_RECOVERY" }, \

Pat Sajak would be very displeased with you for cheating him out of
the purchase of three vowels. :P

_XBF_LOGRECOVERY, please...

Otherwise this looks like a pretty straightforward change.

Ahah, I guess I was wrong, there are *four* states.

--D

>  	{ _XBF_PAGES,		"PAGES" }, \
>  	{ _XBF_KMEM,		"KMEM" }, \
>  	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
> diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
> index 04faa7310c4f0..bfd50daa16606 100644
> --- a/fs/xfs/xfs_buf_item_recover.c
> +++ b/fs/xfs/xfs_buf_item_recover.c
> @@ -419,8 +419,7 @@ xlog_recover_validate_buf_type(
>  	if (bp->b_ops) {
>  		struct xfs_buf_log_item	*bip;
>  
> -		ASSERT(!bp->b_iodone || bp->b_iodone == xlog_recover_iodone);
> -		bp->b_iodone = xlog_recover_iodone;
> +		bp->b_flags |= _XBF_LOGRCVY;
>  		xfs_buf_item_init(bp, mp);
>  		bip = bp->b_log_item;
>  		bip->bli_item.li_lsn = current_lsn;
> @@ -963,7 +962,7 @@ xlog_recover_buf_commit_pass2(
>  		error = xfs_bwrite(bp);
>  	} else {
>  		ASSERT(bp->b_mount == mp);
> -		bp->b_iodone = xlog_recover_iodone;
> +		bp->b_flags |= _XBF_LOGRCVY;
>  		xfs_buf_delwri_queue(bp, buffer_list);
>  	}
>  
> diff --git a/fs/xfs/xfs_dquot_item_recover.c b/fs/xfs/xfs_dquot_item_recover.c
> index 3400be4c88f08..a0a4b089e0cdd 100644
> --- a/fs/xfs/xfs_dquot_item_recover.c
> +++ b/fs/xfs/xfs_dquot_item_recover.c
> @@ -153,7 +153,7 @@ xlog_recover_dquot_commit_pass2(
>  
>  	ASSERT(dq_f->qlf_size == 2);
>  	ASSERT(bp->b_mount == mp);
> -	bp->b_iodone = xlog_recover_iodone;
> +	bp->b_flags |= _XBF_LOGRCVY;
>  	xfs_buf_delwri_queue(bp, buffer_list);
>  
>  out_release:
> diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
> index dc3e26ff16c90..b67f1b7c5b65f 100644
> --- a/fs/xfs/xfs_inode_item_recover.c
> +++ b/fs/xfs/xfs_inode_item_recover.c
> @@ -376,7 +376,7 @@ xlog_recover_inode_commit_pass2(
>  	xfs_dinode_calc_crc(log->l_mp, dip);
>  
>  	ASSERT(bp->b_mount == mp);
> -	bp->b_iodone = xlog_recover_iodone;
> +	bp->b_flags |= _XBF_LOGRCVY;
>  	xfs_buf_delwri_queue(bp, buffer_list);
>  
>  out_release:
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index ec015df55b77a..0aa823aeafca9 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -287,9 +287,8 @@ xlog_recover_iodone(
>  	if (bp->b_log_item)
>  		xfs_buf_item_relse(bp);
>  	ASSERT(bp->b_log_item == NULL);
> -
> -	bp->b_iodone = NULL;
> -	xfs_buf_ioend(bp);
> +	bp->b_flags &= ~_XBF_LOGRCVY;
> +	xfs_buf_ioend_finish(bp);
>  }
>  
>  /*
> -- 
> 2.26.2.761.g0e0b3e54be
> 
