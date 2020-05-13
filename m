Return-Path: <SRS0=Dhh5=63=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A688DC2D0F8
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 04:06:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B8DF206F5
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 04:06:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725973AbgEMEGc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 May 2020 00:06:32 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:36253 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725837AbgEMEGb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 May 2020 00:06:31 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 3658F1A7BC2;
        Wed, 13 May 2020 14:06:27 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jYif3-0002U3-Ch; Wed, 13 May 2020 14:06:25 +1000
Date:   Wed, 13 May 2020 14:06:25 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     bugzilla-daemon@bugzilla.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [Bug 207713] New: xfs: data races on ip->i_itemp->ili_fields in
 xfs_inode_clean()
Message-ID: <20200513040625.GC2040@dread.disaster.area>
References: <bug-207713-201763@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-207713-201763@https.bugzilla.kernel.org/>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
        a=7-415B0cAAAA:8 a=3-djASXm5S0BShuhdQkA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 13, 2020 at 03:02:10AM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=207713
> 
>             Bug ID: 207713
>            Summary: xfs: data races on ip->i_itemp->ili_fields in
>                     xfs_inode_clean()
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
> The function xfs_inode_clean() is concurrently executed with the functions
> xfs_inode_item_format_data_fork(), xfs_trans_log_inode() and
> xfs_inode_item_format() at runtime in the following call contexts:
> 
> Thread 1:
> xfsaild()
>   xfsaild_push()
>     xfsaild_push_item()
>       xfs_inode_item_push()
>         xfs_iflush()
>           xfs_iflush_cluster()
>             xfs_inode_clean()

The code explains:

                /*
                 * Do an un-protected check to see if the inode is dirty and
                 * is a candidate for flushing.  These checks will be repeated
                 * later after the appropriate locks are acquired.
                 */
                if (xfs_inode_clean(cip) && xfs_ipincount(cip) == 0)
                        continue;

Then it is repeated if the racy check indicates the inode is dirty
whilst holding the correct inode locks.  All three of the "thread 2"
cases are modifying the fields with the correct locks held, so there
isn't actually a data race bug we care about here.

IOWs, this code is simply avoiding taking locks if we don't need
them - it's a pattern we use in numerous places in XFS, so you're
going to get lots of false positives from your tool.

Not a bug, please close.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
