Return-Path: <SRS0=Pbt4=DF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C981C2D0A8
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Sep 2020 05:52:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8DED20809
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Sep 2020 05:52:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725294AbgI1Fwe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Sep 2020 01:52:34 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:46247 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725287AbgI1Fwe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Sep 2020 01:52:34 -0400
Received: from dread.disaster.area (pa49-195-191-192.pa.nsw.optusnet.com.au [49.195.191.192])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 7B8D382831A;
        Mon, 28 Sep 2020 15:52:31 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kMm5O-0004mP-Tg; Mon, 28 Sep 2020 15:52:30 +1000
Date:   Mon, 28 Sep 2020 15:52:30 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de, bfoster@redhat.com
Subject: Re: [PATCH 4/4] xfs: xfs_defer_capture should absorb remaining
 transaction reservation
Message-ID: <20200928055230.GF14422@dread.disaster.area>
References: <160125006793.174438.10683462598722457550.stgit@magnolia>
 <160125009361.174438.2579393022515355249.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160125009361.174438.2579393022515355249.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=vvDRHhr1aDYKXl+H6jx2TA==:117 a=vvDRHhr1aDYKXl+H6jx2TA==:17
        a=kj9zAlcOel0A:10 a=reM5J-MqmosA:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=36XEzLai2Xpi57uKWTMA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Sep 27, 2020 at 04:41:33PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When xfs_defer_capture extracts the deferred ops and transaction state
> from a transaction, it should record the transaction reservation type
> from the old transaction so that when we continue the dfops chain, we
> still use the same reservation parameters.
> 
> This avoids a potential failure vector by ensuring that we never ask for
> more log reservation space than we would have asked for had the system
> not gone down.

Nope, it does not do that.

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_defer.c |    5 +++++
>  fs/xfs/libxfs/xfs_defer.h |    1 +
>  fs/xfs/xfs_log_recover.c  |    4 ++--
>  3 files changed, 8 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 85d70f1edc1c..c53443252389 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -577,6 +577,11 @@ xfs_defer_capture(
>  	dfc->dfc_blkres = tp->t_blk_res - tp->t_blk_res_used;
>  	tp->t_blk_res = tp->t_blk_res_used;
>  
> +	/* Preserve the transaction reservation type. */
> +	dfc->dfc_tres.tr_logres = tp->t_log_res;
> +	dfc->dfc_tres.tr_logcount = tp->t_log_count;
> +	dfc->dfc_tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;

This means every child deferop takes a full tp->t_log_count
reservation, whilst in memory the child reservation would ahve been
handled by the parent via the log ticket unit count being
decremented by one. Hence child deferops -never- run with the same
maximal reservation that their parents held.

The difference is that at runtime we are rolling transaction which
regrant space from the initial reservation of (tp->t_log_count *
tp->t_log_res) made a run time. i.e. the first child deferop that
runs has a total log space grant of ((tp->t_log_count - 1)
* tp->t_log_res), the second it is "- 2", and so on right down to
when the log ticket runs out of initial reservation and so it goes
to reserving a single unit (tp->t_log_res) at a time.

Hence both the intents being recovered and all their children are
over-reserving log space by using the default log count for the
&M_RES(mp)->tr_itruncate reservation. Even if we ignore the initial
reservation being incorrect, the child reservations of the same size
as the parent are definitely incorrect. They really should be
allowed only a single unit reservation, and if the transaction rolls
to process defer ops, it needs to regrant new log space during the
commit process.

Hence I think this can only be correct as:

	dfc->dfc_tres.tr_log_count = 1;

Regardless of how many units the parent recovery reservation
obtained. (Which I also think can only be correct as 1 because we
don't know how many units of reservation space the parent had
consumed when it was logged.)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
