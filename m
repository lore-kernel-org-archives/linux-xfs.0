Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC9A8C433DB
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jan 2021 19:31:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A55AE23433
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jan 2021 19:31:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbhAGTbg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Jan 2021 14:31:36 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:37718 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726052AbhAGTbf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jan 2021 14:31:35 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 107JPeCN087704;
        Thu, 7 Jan 2021 19:30:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=AZilLrSJK8E3raWk1QNQllxSHTJ2YnpVahlIogZR9OQ=;
 b=gzxIzlbpbZbyvj72dPhfxtvcE0DmRZxMF8dQdmTLVFCMeWY/CQ5hqu36yuDrRTCZiIsg
 yFdssHwUrECvjSGY15VFqoBA/oG0TLG/O+WhBPO8jDn+ztSFLbPdmsdPYq6wcNXtXoU0
 Wcd7luoJEy5DpObKZD94dWcqTqox+hrJs88b+jrIzlk52+8IziwT9Otrc4UzevKjZ+pH
 MGrOBCbMpEwaBUn3DFeCefRHPlJCg4XD+079x2xUQ4b17D5TlX6ehXV0B4mYDulS2SGe
 d8noqTy2iViSZvGE759Ltyrpfd5RNQjggQA7RlNFZ+IK3wc2lYYERT/DsnQ1JAj7O1mp dA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 35wcuxxbpx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 07 Jan 2021 19:30:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 107JQSb3109482;
        Thu, 7 Jan 2021 19:30:52 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 35w3qu5bxu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jan 2021 19:30:52 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 107JUptO008838;
        Thu, 7 Jan 2021 19:30:51 GMT
Received: from localhost (/10.159.138.126)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Jan 2021 19:30:51 +0000
Date:   Thu, 7 Jan 2021 11:30:50 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] xfs: don't reset log idle state on covering
 checkpoints
Message-ID: <20210107193050.GG6918@magnolia>
References: <20210106174127.805660-1-bfoster@redhat.com>
 <20210106174127.805660-6-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210106174127.805660-6-bfoster@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101070113
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 clxscore=1015 spamscore=0 impostorscore=0 priorityscore=1501 mlxscore=0
 adultscore=0 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101070113
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 06, 2021 at 12:41:23PM -0500, Brian Foster wrote:
> Now that log covering occurs on quiesce, we'd like to reuse the
> underlying superblock sync for final superblock updates. This
> includes things like lazy superblock counter updates, log feature
> incompat bits in the future, etc. One quirk to this approach is that
> once the log is in the IDLE (i.e. already covered) state, any
> subsequent log write resets the state back to NEED. This means that
> a final superblock sync to an already covered log requires two more
> sb syncs to return the log back to IDLE again.
> 
> For example, if a lazy superblock enabled filesystem is mount cycled
> without any modifications, the unmount path syncs the superblock
> once and writes an unmount record. With the desired log quiesce
> covering behavior, we sync the superblock three times at unmount
> time: once for the lazy superblock counter update and twice more to
> cover the log. By contrast, if the log is active or only partially
> covered at unmount time, a final superblock sync would doubly serve
> as the one or two remaining syncs required to cover the log.
> 
> This duplicate covering sequence is unnecessary because the
> filesystem remains consistent if a crash occurs at any point. The
> superblock will either be recovered in the event of a crash or
> written back before the log is quiesced and potentially cleaned with
> an unmount record.
> 
> Update the log covering state machine to remain in the IDLE state if
> additional covering checkpoints pass through the log. This
> facilitates final superblock updates (such as lazy superblock
> counters) via a single sb sync without losing covered status. This
> provides some consistency with the active and partially covered
> cases and also avoids harmless, but spurious checkpoints when
> quiescing the log.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

I /think/ the premise of this is ok.

I found myself wondering if xlog_state_activate_iclog could mistake an
iclog containing 5 log ops from a real update for an iclog containing
just the dummy transaction, since a synchronous inode mtime update
transaction can also produce an iclog with 5 ops.  I /think/ that
doesn't matter because xlog_covered_state only cares about the value of
iclogs_changed if the log worker previously set the log state to DONE or
DONE2, and iclogs_changed won't be 1 here if there were multiple dirty
iclogs or if the sole dirty iclog contains more than just the dummy.

If I got that right,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_log.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index f7b23044723d..9b8564f280b7 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2597,12 +2597,15 @@ xlog_covered_state(
>  	int			iclogs_changed)
>  {
>  	/*
> -	 * We usually go to NEED. But we go to NEED2 if the changed indicates we
> -	 * are done writing the dummy record.  If we are done with the second
> -	 * dummy recored (DONE2), then we go to IDLE.
> +	 * We go to NEED for any non-covering writes. We go to NEED2 if we just
> +	 * wrote the first covering record (DONE). We go to IDLE if we just
> +	 * wrote the second covering record (DONE2) and remain in IDLE until a
> +	 * non-covering write occurs.
>  	 */
>  	switch (prev_state) {
>  	case XLOG_STATE_COVER_IDLE:
> +		if (iclogs_changed == 1)
> +			return XLOG_STATE_COVER_IDLE;
>  	case XLOG_STATE_COVER_NEED:
>  	case XLOG_STATE_COVER_NEED2:
>  		break;
> -- 
> 2.26.2
> 
