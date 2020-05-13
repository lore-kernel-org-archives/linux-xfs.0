Return-Path: <SRS0=Dhh5=63=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAEA9C2D0FD
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 04:07:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB05C207BC
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 04:07:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbgEMEHl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 May 2020 00:07:41 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:44658 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725837AbgEMEHl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 May 2020 00:07:41 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 18059D791C5;
        Wed, 13 May 2020 14:07:37 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jYigA-0002UD-3m; Wed, 13 May 2020 14:07:34 +1000
Date:   Wed, 13 May 2020 14:07:33 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     bugzilla-daemon@bugzilla.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [Bug 207711] New: xfs: data race on ctx->space_used in
 xlog_cil_insert_items()
Message-ID: <20200513040733.GD2040@dread.disaster.area>
References: <bug-207711-201763@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-207711-201763@https.bugzilla.kernel.org/>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
        a=7-415B0cAAAA:8 a=2c7wP0xiZA3VgnoG2N8A:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 13, 2020 at 02:45:54AM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=207711
> 
>             Bug ID: 207711
>            Summary: xfs: data race on ctx->space_used in
>                     xlog_cil_insert_items()
>            Product: File System
>            Version: 2.5
>     Kernel Version: 5.4
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: XFS
>           Assignee: filesystem_xfs@kernel-bugs.kernel.org
>           Reporter: baijiaju1990@gmail.com
>         Regression: No
> 
> The functions xlog_cil_insert_items() and xlog_cil_push_background() are
> concurrently executed at runtime at the following call contexts:
> 
> Thread 1:
> xfs_file_write_iter()
>   xfs_file_buffered_aio_write()
>     xfs_file_aio_write_checks()
>       xfs_vn_update_time()
>         xfs_trans_commit()
>           __xfs_trans_commit()
>             xfs_log_commit_cil()
>               xlog_cil_insert_items()
> 
> Thread 2:
> xfs_file_write_iter()
>   xfs_file_buffered_aio_write()
>     xfs_file_aio_write_checks()
>       xfs_vn_update_time()
>         xfs_trans_commit()
>           __xfs_trans_commit()
>             xfs_log_commit_cil()
>               xlog_cil_push_background()
> 
> In xlog_cil_insert_items():
>   ctx->space_used += len;
> 
> In xlog_cil_push_background():
>   if (cil->xc_ctx->space_used < XLOG_CIL_SPACE_LIMIT(log))

Intentionally racy accounting check as it's not critical to be
perfectly accurate here.

Not a bug, please close.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
