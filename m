Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D06BEC56202
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Nov 2020 20:29:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7138E20678
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Nov 2020 20:29:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgKXU3N (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Nov 2020 15:29:13 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:45200 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726631AbgKXU3M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Nov 2020 15:29:12 -0500
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 7DD6F58C7B8;
        Wed, 25 Nov 2020 07:29:10 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1khew1-00EeTu-N9; Wed, 25 Nov 2020 07:29:09 +1100
Date:   Wed, 25 Nov 2020 07:29:09 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     bugzilla-daemon@bugzilla.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [Bug 210341] New: XFS (dm-3): Internal error xfs_trans_cancel at
 line 1041 of file fs/xfs/xfs_trans.c.
Message-ID: <20201124202909.GB2842436@dread.disaster.area>
References: <bug-210341-201763@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-210341-201763@https.bugzilla.kernel.org/>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=nNwsprhYR40A:10 a=VwQbUJbxAAAA:8 a=JJa4EKUDAAAA:8
        a=7-415B0cAAAA:8 a=l53b9WMv9s8PVzMLClIA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=pcahhcY2dJ4xbbEV-xyx:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 24, 2020 at 05:53:09AM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=210341
> 
>             Bug ID: 210341
>            Summary: XFS (dm-3): Internal error xfs_trans_cancel at line
>                     1041 of file fs/xfs/xfs_trans.c.
>            Product: File System
>            Version: 2.5
>     Kernel Version: 4.18.0-147
>           Hardware: Intel
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: blocking
>           Priority: P1
>          Component: XFS
>           Assignee: filesystem_xfs@kernel-bugs.kernel.org
>           Reporter: lokendra.rathour@hsc.com
>         Regression: No
> 
> Created attachment 293797
>   --> https://bugzilla.kernel.org/attachment.cgi?id=293797&action=edit
> Detailed logs as shown above
> 
> Getting errror for xfs file system :
> 
> 2020-11-11T11:55:16.809 controller-1 kernel: alert [419472.614847] XFS (dm-3):
> xfs_dabuf_map: bno 8388608 dir: inode 122425344
> 2020-11-11T11:55:16.809 controller-1 kernel: alert [419472.621963] XFS (dm-3):
> [00] br_startoff 8388608 br_startblock -2 br_blockcount 1 br_state 0
> 2020-11-11T11:55:16.823 controller-1 kernel: alert [419472.630908] XFS (dm-3):
> Internal error xfs_da_do_buf(1) at line 2558 of file
> fs/xfs/libxfs/xfs_da_btree.c.  Caller xfs_da_read_buf+0x6c/0x120 [xfs]
> 2020-11-11T11:55:16.824 controller-1 kernel: warning [419472.644671] CPU: 1
> PID: 83210 Comm: heat-manage Kdump: loaded Tainted: G           O     ---------
> -t - 4.18.0-147.3.1.el8_1.7.tis.x86_64 #1

So you have a corrupt directory (missing a leaf root pointer). Have
you run `xfs_repair -n` on that filesystem to see if it finds the
same corruption?

Keep in mind that you are running on a CentOS8/RHEL8 kernel. It is
unlikely that upstream developers will be able to reliably diagnose
the root cause of your issue as the kernel codebase is a highly
modified vendor kernel.  You really should report this to your
vendor support contacts, not upstream....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
