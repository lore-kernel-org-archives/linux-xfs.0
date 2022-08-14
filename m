Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01D28C25B06
	for <linux-xfs@archiver.kernel.org>; Sun, 14 Aug 2022 23:54:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbiHNXyt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 14 Aug 2022 19:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiHNXyt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 14 Aug 2022 19:54:49 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E697BE0C3
        for <linux-xfs@vger.kernel.org>; Sun, 14 Aug 2022 16:54:47 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-193-158.pa.nsw.optusnet.com.au [49.181.193.158])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id AB0DC10E89F4;
        Mon, 15 Aug 2022 09:54:46 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oNNRN-00DC3o-3n; Mon, 15 Aug 2022 09:54:45 +1000
Date:   Mon, 15 Aug 2022 09:54:45 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     bugzilla-daemon@kernel.org
Cc:     linux-xfs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>
Subject: Re: [Bug 216343] New: XFS: no space left in xlog cause system hang
Message-ID: <20220814235445.GS3600936@dread.disaster.area>
References: <bug-216343-201763@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bug-216343-201763@https.bugzilla.kernel.org/>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=62f98b47
        a=SeswVvpAPK2RnNNwqI8AaA==:117 a=SeswVvpAPK2RnNNwqI8AaA==:17
        a=8nJEP1OIZ-IA:10 a=biHskzXt2R4A:10 a=VwQbUJbxAAAA:8 a=gnbuhwpKAAAA:8
        a=7-415B0cAAAA:8 a=Trh7RUjsQYzmlyP2qNEA:9 a=wPNLvfGTeEIA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

[cc Amir, the 5.10 stable XFS maintainer]

On Tue, Aug 09, 2022 at 11:46:23AM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=216343
> 
>             Bug ID: 216343
>            Summary: XFS: no space left in xlog cause system hang
>            Product: File System
>            Version: 2.5
>     Kernel Version: 5.10.38
>           Hardware: ARM
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: XFS
>           Assignee: filesystem_xfs@kernel-bugs.kernel.org
>           Reporter: zhoukete@126.com
>         Regression: No
> 
> Created attachment 301539
>   --> https://bugzilla.kernel.org/attachment.cgi?id=301539&action=edit
> stack
> 
> 1. cannot login with ssh, system hanged and cannot do anything
> 2. dmesg report 'audit: audit_backlog=41349 > audit_backlog_limit=8192'
> 3. I send sysrq-crash and get vmcore file , I dont know how to reproduce it.
> 
> Follwing is my analysis from vmcore:
> 
> The reason why tty cannot login is pid 2021571 hold the acct_process mutex, and
> 2021571 cannot release mutex because it is wait for xlog release space. See the
> stac info in the attachment of stack.txt
> 
> So I try to figure out what happened to xlog
> 
> crash> struct xfs_ail.ail_target_prev,ail_targe,ail_head 0xffff00ff884f1000 
>   ail_target_prev = 0xe9200058600
>   ail_target = 0xe9200058600
>   ail_head = {
>     next = 0xffff0340999a0a80, 
>     prev = 0xffff020013c66b40
>   }
> 
> there are 112 log item in ail list
> crash> list 0xffff0340999a0a80 | wc -l
> 112 
> 
> 79 item of them are xlog_inode_item
> 30 item of them are xlog_buf_item
> 
> crash> xfs_log_item.li_flags,li_lsn 0xffff0340999a0a80 -x 
>   li_flags = 0x1
>   li_lsn = 0xe910005cc00 ===> first item lsn
> 
> crash> xfs_log_item.li_flags,li_lsn ffff020013c66b40 -x
>   li_flags = 0x1
>   li_lsn = 0xe9200058600 ===> last item lsn
> 
> crash>xfs_log_item.li_buf 0xffff0340999a0a80               
>  li_buf = 0xffff0200125b7180
> 
> crash> xfs_buf.b_flags 0xffff0200125b7180 -x
>  b_flags = 0x110032  (XBF_WRITE|XBF_ASYNC|XBF_DONE|_XBF_INODES|_XBF_PAGES) 
> 
> crash> xfs_buf.b_state 0xffff0200125b7180 -x
>   b_state = 0x2 (XFS_BSTATE_IN_FLIGHT)
> 
> crash> xfs_buf.b_last_error,b_retries,b_first_retry_time 0xffff0200125b7180 -x
>   b_last_error = 0x0
>   b_retries = 0x0
>   b_first_retry_time = 0x0 
> 
> The buf flags show the io had been done(XBF_DONE is set).
> When I review the code xfs_buf_ioend, if XBF_DONE is set, xfs_buf_inode_iodone
> will be called and it will remove the log item from ail list, then release the
> xlog space by moving the tail_lsn.
> 
> But now this item is still in the ail list, and the b_last_error = 0, XBF_WRITE
> is set.
> 
> xfs buf log item is the same as the inode log item.
> 
> crash> list -s xfs_log_item.li_buf 0xffff0340999a0a80
> ffff033f8d7c9de8
>   li_buf = 0x0
> crash> xfs_buf_log_item.bli_buf  ffff033f8d7c9de8
>   bli_buf = 0xffff0200125b4a80
> crash> xfs_buf.b_flags 0xffff0200125b4a80 -x
>   b_flags = 0x100032 (XBF_WRITE|XBF_ASYNC|XBF_DONE|_XBF_PAGES) 
> 
> I think it is impossible that (XBF_DONE is set & b_last_error = 0) and the item
> still in the ail.
> 
> Is my analysis correct? 
> Why xlog space cannot release space?
> 
> -- 
> You may reply to this email to add a comment.
> 
> You are receiving this mail because:
> You are watching the assignee of the bug.

-- 
Dave Chinner
david@fromorbit.com
