Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85591C4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Oct 2022 22:34:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbiJMWeA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Oct 2022 18:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiJMWd7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Oct 2022 18:33:59 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E38B018DA89
        for <linux-xfs@vger.kernel.org>; Thu, 13 Oct 2022 15:33:58 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au [49.181.106.210])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 0D1DD11019B0;
        Fri, 14 Oct 2022 09:33:58 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oj6m4-001eTC-L8; Fri, 14 Oct 2022 09:33:56 +1100
Date:   Fri, 14 Oct 2022 09:33:56 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: fully initialize xfs_da_args in
 xchk_directory_blocks
Message-ID: <20221013223356.GA3600936@dread.disaster.area>
References: <166473478844.1083155.9238102682926048449.stgit@magnolia>
 <166473478865.1083155.10793868656289104615.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166473478865.1083155.10793868656289104615.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=63489256
        a=j6JUzzrSC7wlfFge/rmVbg==:117 a=j6JUzzrSC7wlfFge/rmVbg==:17
        a=kj9zAlcOel0A:10 a=Qawa6l4ZSaYA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=vkl3OtAPEatwWnmYsXMA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 02, 2022 at 11:19:48AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> While running the online fsck test suite, I noticed the following
> assertion in the kernel log (edited for brevity):
> 
> XFS: Assertion failed: 0, file: fs/xfs/xfs_health.c, line: 571
> ------------[ cut here ]------------
> WARNING: CPU: 3 PID: 11667 at fs/xfs/xfs_message.c:104 assfail+0x46/0x4a [xfs]
> CPU: 3 PID: 11667 Comm: xfs_scrub Tainted: G        W         5.19.0-rc7-xfsx #rc7 6e6475eb29fd9dda3181f81b7ca7ff961d277a40
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1 04/01/2014
> RIP: 0010:assfail+0x46/0x4a [xfs]
> Call Trace:
>  <TASK>
>  xfs_dir2_isblock+0xcc/0xe0
>  xchk_directory_blocks+0xc7/0x420
>  xchk_directory+0x53/0xb0
>  xfs_scrub_metadata+0x2b6/0x6b0
>  xfs_scrubv_metadata+0x35e/0x4d0
>  xfs_ioc_scrubv_metadata+0x111/0x160
>  xfs_file_ioctl+0x4ec/0xef0
>  __x64_sys_ioctl+0x82/0xa0
>  do_syscall_64+0x2b/0x80
>  entry_SYSCALL_64_after_hwframe+0x46/0xb0
> 
> This assertion triggers in xfs_dirattr_mark_sick when the caller passes
> in a whichfork value that is neither of XFS_{DATA,ATTR}_FORK.  The cause
> of this is that xchk_directory_blocks only partially initializes the
> xfs_da_args structure that is passed to xfs_dir2_isblock.  If the data
> fork is not correct, the XFS_IS_CORRUPT clause will trigger.  My
> development branch reports this failure to the health monitoring
> subsystem, which accesses the uninitialized args->whichfork field,
> leading the the assertion tripping.  We really shouldn't be passing
> random stack contents around, so the solution here is to force the
> compiler to zero-initialize the struct.
> 
> Found by fuzzing u3.bmx[0].blockcount = middlebit on xfs/1554.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/scrub/dir.c |   10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)

Looks good, surprised it took this long to trip over this...

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
