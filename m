Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18E06C77B70
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 15:04:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbjDKPEE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 11:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230158AbjDKPDj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 11:03:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E07E132
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 08:03:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A31B61F26
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 15:03:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67B9EC433D2;
        Tue, 11 Apr 2023 15:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681225417;
        bh=NQNGuuydzmmVRRahxD8y2+AOicOC/ixAbONFrK+PpQg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TxzJXbD7XDWrz+CMAduWssD9rRQ7knRh3VatjQRFeZfL1c8Ek/+7i1mQh96jnibCY
         ttlGZOfI9KWohOujaZLGayNIIriHek0xktQQ+9siwkIgPpJ361aPV/meUSXvNhuyk+
         dF0DKKs7nqSQ8fnjR/4SteNcIYWZpkZzfqWZrwWIeYd+aXFv8OHbr8lyBKYogYLtNk
         +EwNGsclgV8faFRwSnJIqIJpYJPc95jVz7TxbVPW2ssxTjAhiQ1+37iwSmKeL2L7F0
         mdZYYsGfGr8MWydUWdrj8NlorbtG8iklCRPQv7LztVX3YfUlfL7+po3hfTXKOOJO8b
         aGX3A/OUl8+TA==
Date:   Tue, 11 Apr 2023 08:03:36 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Pengfei Xu <pengfei.xu@intel.com>
Cc:     Dave Chinner <david@fromorbit.com>, dchinner@redhat.com,
        linux-xfs@vger.kernel.org, heng.su@intel.com, lkp@intel.com
Subject: Re: [Syzkaller & bisect] There is task hung in xlog_grant_head_check
 in v6.3-rc5
Message-ID: <20230411150336.GG360889@frogsfrogsfrogs>
References: <ZC4vmjzuOEFQuD17@xpf.sh.intel.com>
 <20230411003353.GW3223426@dread.disaster.area>
 <ZDUXGKoMK6unNXYo@xpf.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDUXGKoMK6unNXYo@xpf.sh.intel.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 11, 2023 at 04:15:20PM +0800, Pengfei Xu wrote:
> Hi Dave,
> 
> On 2023-04-11 at 10:33:53 +1000, Dave Chinner wrote:
> > On Thu, Apr 06, 2023 at 10:34:02AM +0800, Pengfei Xu wrote:
> > > Hi Dave Chinner and xfs experts,
> > > 
> > > Greeting!
> > > 
> > > There is task hung in xlog_grant_head_check in v6.3-rc5 kernel.
> > > 
> > > Platform: x86 platforms
> > > 
> > > All detailed info: https://github.com/xupengfe/syzkaller_logs/tree/main/230405_094839_xlog_grant_head_check
> > > Syzkaller reproduced code: https://github.com/xupengfe/syzkaller_logs/blob/main/230405_094839_xlog_grant_head_check/repro.c
> > > Syzkaller analysis repro.report: https://github.com/xupengfe/syzkaller_logs/blob/main/230405_094839_xlog_grant_head_check/repro.report
> > > Syzkaller analysis repro.stats: https://github.com/xupengfe/syzkaller_logs/blob/main/230405_094839_xlog_grant_head_check/repro.stats
> > > Reproduced prog repro.prog: https://github.com/xupengfe/syzkaller_logs/blob/main/230405_094839_xlog_grant_head_check/repro.prog
> > > Kconfig: https://github.com/xupengfe/syzkaller_logs/blob/main/230405_094839_xlog_grant_head_check/kconfig_origin
> > > Bisect info: https://github.com/xupengfe/syzkaller_logs/blob/main/230405_094839_xlog_grant_head_check/bisect_info.log
> > > 
> > > It could be reproduced in maximum 2100s.
> > > Bisected and found bad commit was:
> > > "
> > > fe08cc5044486096bfb5ce9d3db4e915e53281ea
> > > xfs: open code sb verifier feature checks
> > > "
> > > It's just the suspected commit, because reverted above commit on top of v6.3-rc5
> > > kernel then made kernel failed, could not double confirm for the issue.
> > > 
> > > "
> > > [   24.818100] memfd_create() without MFD_EXEC nor MFD_NOEXEC_SEAL, pid=339 'systemd'
> > > [   28.230533] loop0: detected capacity change from 0 to 65536
> > > [   28.232522] XFS (loop0): Deprecated V4 format (crc=0) will not be supported after September 2030.
> > > [   28.233447] XFS (loop0): Mounting V10 Filesystem d28317a9-9e04-4f2a-be27-e55b4c413ff6
> > 
> > Yeah, there's the issue that the bisect found - has nothing to do
> > with the log hang. fe08cc5044486 allowed filesystem versions > 5 to
> > be mounted, prior to that it wasn't allowed. I think this was just a
> > simple oversight.
> > 
> > Not a bit deal, everything is based on feature support checks and
> > not version numbers, so it's not a critical issue.
> > 
> > Low severity, low priority, but something we should fix and push
> > back to stable kernels sooner rather than later.
> > 
>   Ah, this issue was found from somewhere else, not the target place, and
>   bisect is rewarding instead of wasting your time.
>   It's great and lucky this time!  :)
> 
> 
> > > [   28.234235] XFS (loop0): Log size 66 blocks too small, minimum size is 1968 blocks
> > > [   28.234856] XFS (loop0): Log size out of supported range.
> > > [   28.235289] XFS (loop0): Continuing onwards, but if log hangs are experienced then please report this message in the bug report.
> > > [   28.239290] XFS (loop0): Starting recovery (logdev: internal)
> > > [   28.240979] XFS (loop0): Ending recovery (logdev: internal)
> > > [  300.150944] INFO: task repro:541 blocked for more than 147 seconds.
> > > [  300.151523]       Not tainted 6.3.0-rc5-7e364e56293b+ #1
> > > [  300.152102] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > > [  300.152716] task:repro           state:D stack:0     pid:541   ppid:540    flags:0x00004004
> > > [  300.153373] Call Trace:
> > > [  300.153580]  <TASK>
> > > [  300.153765]  __schedule+0x40a/0xc30
> > > [  300.154078]  schedule+0x5b/0xe0
> > > [  300.154349]  xlog_grant_head_wait+0x53/0x3a0
> > > [  300.154715]  xlog_grant_head_check+0x1a5/0x1c0
> > > [  300.155113]  xfs_log_reserve+0x145/0x380
> > > [  300.155442]  xfs_trans_reserve+0x226/0x270
> > > [  300.155780]  xfs_trans_alloc+0x147/0x470
> > > [  300.156112]  xfs_qm_qino_alloc+0xcf/0x510
> > 
> > This log hang is *not a bug*. It is -expected- given that syzbot is
> > screwing around with fuzzed V4 filesystems. I almost just threw this
> > report in the bin because I saw it was a V4 filesytsem being
> > mounted.
> > 
> > That is, V5 filesystems will refuse to mount a filesystem with a log
> > that is too small, completely avoiding this sort of hang caused by
> > the log being way smaller than a transaction reservation (guaranteed
> > hang). But we cannot do the same thing for V4 filesystems, because
> > there were bugs in and inconsistencies between mkfs and the kernel
> > over the minimum valid log size. Hence when we hit a V4 filesystem
> > in that situation, we issue a warning and allow operation to
> > continue because that's historical V4 filesystem behaviour.
> > 
> > This kernel issued the "log size too small" warning, and then there
> > was a log space hang which is entirely predictable and not a kernel
> > bug. syzbot is doing something stupid, syzbot needs to be taught not
> > to do stupid things.
> > 
>  Thanks for pointing out this syzkaller issue, I will send the problem to
>  syzkaller and related syzkaller author.

Don't bother, we already had this discussion *five years ago*:

https://lore.kernel.org/linux-xfs/20180523044742.GZ23861@dastard/

The same points there still apply -- we cannot break existing V4 users,
the format is scheduled for removal, and it's *really unfair* for
megacorporations like Intel and Google to dump zeroday reproducers onto
public mailing lists expecting the maintainers will just magically come
up with engineering resources to go fix all these corner cases.

Silicon Valley tech companies just laid off what, like 295,000
programmers in the last 9 months?  Just think about what we could do if
1% of that went back to work fixing all the broken crap.

Hire a team to triage and fix the damn bugs or stop sending them.

--D

>  Thanks again!
>  BR.
>  -Pengfei
> 
> > -Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
