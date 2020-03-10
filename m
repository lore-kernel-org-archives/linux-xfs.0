Return-Path: <SRS0=iJk4=43=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36873C10DCE
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Mar 2020 22:25:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 055532071B
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Mar 2020 22:25:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgCJWZA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Mar 2020 18:25:00 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:57918 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726402AbgCJWZA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Mar 2020 18:25:00 -0400
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id B0D8A3A1F53;
        Wed, 11 Mar 2020 09:24:58 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jBnJ2-0004dc-SL; Wed, 11 Mar 2020 09:24:56 +1100
Date:   Wed, 11 Mar 2020 09:24:56 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     bugzilla-daemon@bugzilla.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [Bug 206807] New: [xfstests generic/053]: WARNING: possible
 circular locking between fs_reclaim_acquire.part and
 xfs_ilock_attr_map_shared
Message-ID: <20200310222456.GQ10776@dread.disaster.area>
References: <bug-206807-201763@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-206807-201763@https.bugzilla.kernel.org/>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=qUffnYj2xXIgkKXBrH8A:9
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 10, 2020 at 09:26:11AM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=206807
> 
>             Bug ID: 206807
>            Summary: [xfstests generic/053]: WARNING: possible circular
>                     locking between fs_reclaim_acquire.part and
>                     xfs_ilock_attr_map_shared
>            Product: File System
>            Version: 2.5
>     Kernel Version: xfs-5.7-merge-1
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: XFS
>           Assignee: filesystem_xfs@kernel-bugs.kernel.org
>           Reporter: zlang@redhat.com
>         Regression: No
> 
> xfstests generic/053 always hit below warning. I'm not sure if it's a real
> issue, just due to it can be reproduced easily. So report this bug to get more
> xfs developer review.

False positive. Please close.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
