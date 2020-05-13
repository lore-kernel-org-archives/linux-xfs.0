Return-Path: <SRS0=Dhh5=63=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A2BDC2D0FD
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 04:10:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E109E20708
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 04:10:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725925AbgEMEK6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 May 2020 00:10:58 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:53574 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725837AbgEMEK6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 May 2020 00:10:58 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id E3F683A2F5D;
        Wed, 13 May 2020 14:10:53 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jYijN-0002Uf-F1; Wed, 13 May 2020 14:10:53 +1000
Date:   Wed, 13 May 2020 14:10:53 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     bugzilla-daemon@bugzilla.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [Bug 207715] New: xfs: data race on lip->li_lsn in
 xfs_trans_ail_update_bulk()
Message-ID: <20200513041053.GE2040@dread.disaster.area>
References: <bug-207715-201763@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-207715-201763@https.bugzilla.kernel.org/>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
        a=7-415B0cAAAA:8 a=j4_Fea25z9owWY784NQA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 13, 2020 at 03:21:05AM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=207715
> 
>             Bug ID: 207715
>            Summary: xfs: data race on lip->li_lsn in
>                     xfs_trans_ail_update_bulk()
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
> The functions xfs_trans_ail_update_bulk() and xfs_inode_item_format_core() are
> concurrently executed at runtime in the following call contexts:
> 
> Thread 1:
> xlog_ioend_work()
>   xlog_state_done_syncing()
>     xlog_state_do_callback()
>       xlog_state_do_iclog_callbacks()
>         xlog_cil_process_committed()
>           xlog_cil_committed()
>             xfs_trans_committed_bulk()
>               xfs_log_item_batch_insert()
>                 xfs_trans_ail_update_bulk()
> 
> Thread 2:
> xfs_file_write_iter()
>   xfs_file_buffered_aio_write()
>     xfs_file_aio_write_checks()
>       xfs_vn_update_time()
>         xfs_trans_commit()
>           __xfs_trans_commit()
>             xfs_log_commit_cil()
>               xlog_cil_insert_items()
>                 xlog_cil_insert_format_items()
>                   xfs_inode_item_format()
>                     xfs_inode_item_format_core()
> 
> In xfs_trans_ail_update_bulk():
>   lip->li_lsn = lsn;
> 
> In xfs_inode_item_format_core():
>   xfs_inode_to_log_dinode(ip, dic, ip->i_itemp->ili_item.li_lsn);

Probably a bug on 32 bit systems where a torn write can be seen.
Likely should use xfs_trans_ail_copy_lsn() to sample the lsn out
of the log item.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
