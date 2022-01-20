Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 789DCC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 18:02:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236851AbiATSCc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Jan 2022 13:02:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233185AbiATSCc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jan 2022 13:02:32 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD14C061574;
        Thu, 20 Jan 2022 10:02:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 37657CE217B;
        Thu, 20 Jan 2022 18:02:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E7BAC340E0;
        Thu, 20 Jan 2022 18:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642701748;
        bh=c0TE2ZLod1lZ+/G5RUqHJqsSZ6N1yhRmxVbalsZEfV8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fXJTL90xd3OLAf0XAutbwJyhVrQjqfiyamiX9JJlxJJTS7evPA/b1mM5jC+1CKhZk
         fre4nyiF4fpvau11SotovHv/ku7dgAwZjYSc2yfHxnrq9UgkK8bR4brw5CSOMYGJyU
         hwMCSbTNenJJk9BCSLFNrjDAZCHNf6i/d99peSnK9FfK0bcgNMkyGVDBLF+Auhu116
         RESXq2vPngejw1N0LMCR1UnkNQ0tugJ5ln9TheZhNHpILyj0zSOGOU7F649v7Kx71q
         FR4Hton4VtFDSn+anek0GK/OxgIGIt4erb5sUfEiRnsa6Ti1TVEVCu9QqYf4C6nGIw
         VfG/gEShPr6NA==
Date:   Thu, 20 Jan 2022 10:02:28 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Andrea Tomassetti <andrea.tomassetti@devo.com>
Cc:     fstests@vger.kernel.org, xfs <linux-xfs@vger.kernel.org>
Subject: Re: xfs/311 test pass but leave block device unusable
Message-ID: <20220120180228.GE13514@magnolia>
References: <CAG2S0o-wJc-2_wm=35mE5Lt0e4idXwb3g5ezc9=LdWrLHfRM_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG2S0o-wJc-2_wm=35mE5Lt0e4idXwb3g5ezc9=LdWrLHfRM_Q@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

[cc xfs list]

On Thu, Jan 20, 2022 at 12:04:47PM +0100, Andrea Tomassetti wrote:
> Hi all,
> I was using the (x)fstest utility on the Kernel 5.11 to try to
> reproduce some xfs-related issues:
>   INFO: task xfs-conv/dm-3:1360 blocked for more than 120 seconds.
>   Workqueue: xfs-conv/dm-3 xfs_end_io [xfs]
>    Call Trace:
>     __schedule+0x44c/0x8a0
>     schedule+0x4f/0xc0
>     xlog_grant_head_wait+0xb5/0x1a0 [xfs]
>     xlog_grant_head_check+0xe1/0x100 [xfs]

Threads are stuck waiting for log space; can you post the full dmesg?
And the xfs_info output of the test device?

> When I realized that xfs test n. 311 was passing correctly but every
> further attempt to use the block device (e.g. mount it) was failing.
> The issue is reproducible after reboot.
> 
> Test passed:
>   ./check xfs/311
>   FSTYP         -- xfs (non-debug)
>   PLATFORM      -- Linux/x86_64 test 5.11.0-1021-aws
> #22~20.04.2-Ubuntu SMP Wed Oct 27 21:27:13 UTC 2021
>   MKFS_OPTIONS  -- -f /dev/xvdz
>   MOUNT_OPTIONS -- /dev/xvdz /home/test/z
> 
>   xfs/311 25s ...  25s
>   Ran: xfs/311
>   Passed all 1 tests
> 
> Fail:
>   # mount /dev/xvdz /home/test/z/
>     mount: /home/test/z: /dev/xvdz already mounted or mount point busy.
>     [ 2222.028417] /dev/xvdz: Can't open blockdev
> 
> lsof does not show anything that is using either /dev/xvdz or /home/test/z
> 
> Any idea why is this happening?

xfs-conv handles unwritten extent conversion after writeback, so I would
speculate (without dmesg data) that everyone got wedged trying to start
a transaction, and the log is blocked up for whatever reason.

> The `xlog_grant_head_wait` race issue has been resolved in a later
> Kernel version, am I right?

Beats me.

> Best regards,
> Andrea
> 
> -- 
> 
> 
> 
> 
> 
> 
> 
> The contents of this email are confidential. If the reader of this 

Not anymore they aren't.

--D

> message is not the intended recipient, you are hereby notified that any 
> dissemination, distribution or copying of this communication is strictly 
> prohibited. If you have received this communication in error, please notify 
> us immediately by replying to this message and deleting it from your 
> computer. Thank you. Devo, Inc; arco@devo.com <mailto:arco@devo.com>;  
> Calle Estébanez Calderón 3-5, 5th Floor. Madrid, Spain 28020
> 
