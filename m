Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DF39C77B61
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 00:34:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbjDKAd7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Apr 2023 20:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbjDKAd7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Apr 2023 20:33:59 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1306E7C
        for <linux-xfs@vger.kernel.org>; Mon, 10 Apr 2023 17:33:57 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id pc4-20020a17090b3b8400b0024676052044so6319800pjb.1
        for <linux-xfs@vger.kernel.org>; Mon, 10 Apr 2023 17:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112; t=1681173237;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5rsZxBIhdUdpm0eZLXSYWNvsAk4rQL5AjGFRDJWP8e0=;
        b=1KD+ZrkqIg+GiYFVzGcMsIFnZ11TfFB+JCk00U6I3swzIizGTFaVWgKovWTs3OFB6r
         QibuWUqZXXGZ22XTLaEfEoDxs4NWOGjztvYSHYf/5hL4w+zjfGK2Dt6rzbNbuZjXtNx8
         47pqFej55g7xgG1CMwo9vvdwK/oXHnoaIh6ijQDogEZgwS/O29zrcXwILycMwFEkKwRW
         eew1mFxWz/nKXwFjcC/A4UIWWnoZtfinfl7XeC1qwZ1S8EdBPt9qJs2hPnF6xlEw9Max
         HouAKxWb5t3gwNdSxfz/9YXUuPTyQ74g3ggZ4bQP713J0j3BvHAg/gK6B60K6LhgvlK1
         j/wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681173237;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5rsZxBIhdUdpm0eZLXSYWNvsAk4rQL5AjGFRDJWP8e0=;
        b=foOWZjbbNQ557IkFtcnXXX+ADidA/wE4AdAf9kltJyra+prLYdCOVWDpZypi0+JXha
         t8N5oBfKUfRyW6hUcyOVqz+hhQo4NqSU4NZi+UKhMmarrJq3LAN0+LaHDZnJk31KxxLJ
         DFd2XLCfStBbQSED+IjpG4kynMUvsRFdBE/kR3ncGCNu1cexxPvC1z3FHK4VMl1uTuHl
         vutFRmseu831oqOaSKTZHmSccuqLF7+dPpjSxlneC3/9Wf6yLEv/MzRXQsA/z1G/H8aj
         N2ua4V7z75Uo9MQp8GQYfXYT5q7IOzNXTVVdDHJGor4HMhWxFiafyS5LchUXP996s5yp
         wn2g==
X-Gm-Message-State: AAQBX9ePOLXwxL6bqN5LqjfyeSpRCWeEBPhMiA/r2jqtyTb05y5/rc7g
        GG9DjtG0CDNMApDyAfZs/EAKPA==
X-Google-Smtp-Source: AKy350aiqZfiZUYJ8Du5owA4n72baFpnrEOzOXWP4Rq2S76WvLfiUDOqVYG+5ZyetVv9t3HKr6HDnw==
X-Received: by 2002:a17:90a:e7c7:b0:23b:bf03:397e with SMTP id kb7-20020a17090ae7c700b0023bbf03397emr11788470pjb.24.1681173237227;
        Mon, 10 Apr 2023 17:33:57 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-41-174.pa.nsw.optusnet.com.au. [49.180.41.174])
        by smtp.gmail.com with ESMTPSA id u7-20020a17090a4bc700b00229b00cc8desm405637pjl.0.2023.04.10.17.33.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 17:33:56 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pm1xJ-001tsB-LD; Tue, 11 Apr 2023 10:33:53 +1000
Date:   Tue, 11 Apr 2023 10:33:53 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Pengfei Xu <pengfei.xu@intel.com>
Cc:     dchinner@redhat.com, linux-xfs@vger.kernel.org, djwong@kernel.org,
        heng.su@intel.com, lkp@intel.com
Subject: Re: [Syzkaller & bisect] There is task hung in xlog_grant_head_check
 in v6.3-rc5
Message-ID: <20230411003353.GW3223426@dread.disaster.area>
References: <ZC4vmjzuOEFQuD17@xpf.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZC4vmjzuOEFQuD17@xpf.sh.intel.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 06, 2023 at 10:34:02AM +0800, Pengfei Xu wrote:
> Hi Dave Chinner and xfs experts,
> 
> Greeting!
> 
> There is task hung in xlog_grant_head_check in v6.3-rc5 kernel.
> 
> Platform: x86 platforms
> 
> All detailed info: https://github.com/xupengfe/syzkaller_logs/tree/main/230405_094839_xlog_grant_head_check
> Syzkaller reproduced code: https://github.com/xupengfe/syzkaller_logs/blob/main/230405_094839_xlog_grant_head_check/repro.c
> Syzkaller analysis repro.report: https://github.com/xupengfe/syzkaller_logs/blob/main/230405_094839_xlog_grant_head_check/repro.report
> Syzkaller analysis repro.stats: https://github.com/xupengfe/syzkaller_logs/blob/main/230405_094839_xlog_grant_head_check/repro.stats
> Reproduced prog repro.prog: https://github.com/xupengfe/syzkaller_logs/blob/main/230405_094839_xlog_grant_head_check/repro.prog
> Kconfig: https://github.com/xupengfe/syzkaller_logs/blob/main/230405_094839_xlog_grant_head_check/kconfig_origin
> Bisect info: https://github.com/xupengfe/syzkaller_logs/blob/main/230405_094839_xlog_grant_head_check/bisect_info.log
> 
> It could be reproduced in maximum 2100s.
> Bisected and found bad commit was:
> "
> fe08cc5044486096bfb5ce9d3db4e915e53281ea
> xfs: open code sb verifier feature checks
> "
> It's just the suspected commit, because reverted above commit on top of v6.3-rc5
> kernel then made kernel failed, could not double confirm for the issue.
> 
> "
> [   24.818100] memfd_create() without MFD_EXEC nor MFD_NOEXEC_SEAL, pid=339 'systemd'
> [   28.230533] loop0: detected capacity change from 0 to 65536
> [   28.232522] XFS (loop0): Deprecated V4 format (crc=0) will not be supported after September 2030.
> [   28.233447] XFS (loop0): Mounting V10 Filesystem d28317a9-9e04-4f2a-be27-e55b4c413ff6

Yeah, there's the issue that the bisect found - has nothing to do
with the log hang. fe08cc5044486 allowed filesystem versions > 5 to
be mounted, prior to that it wasn't allowed. I think this was just a
simple oversight.

Not a bit deal, everything is based on feature support checks and
not version numbers, so it's not a critical issue.

Low severity, low priority, but something we should fix and push
back to stable kernels sooner rather than later.

> [   28.234235] XFS (loop0): Log size 66 blocks too small, minimum size is 1968 blocks
> [   28.234856] XFS (loop0): Log size out of supported range.
> [   28.235289] XFS (loop0): Continuing onwards, but if log hangs are experienced then please report this message in the bug report.
> [   28.239290] XFS (loop0): Starting recovery (logdev: internal)
> [   28.240979] XFS (loop0): Ending recovery (logdev: internal)
> [  300.150944] INFO: task repro:541 blocked for more than 147 seconds.
> [  300.151523]       Not tainted 6.3.0-rc5-7e364e56293b+ #1
> [  300.152102] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  300.152716] task:repro           state:D stack:0     pid:541   ppid:540    flags:0x00004004
> [  300.153373] Call Trace:
> [  300.153580]  <TASK>
> [  300.153765]  __schedule+0x40a/0xc30
> [  300.154078]  schedule+0x5b/0xe0
> [  300.154349]  xlog_grant_head_wait+0x53/0x3a0
> [  300.154715]  xlog_grant_head_check+0x1a5/0x1c0
> [  300.155113]  xfs_log_reserve+0x145/0x380
> [  300.155442]  xfs_trans_reserve+0x226/0x270
> [  300.155780]  xfs_trans_alloc+0x147/0x470
> [  300.156112]  xfs_qm_qino_alloc+0xcf/0x510

This log hang is *not a bug*. It is -expected- given that syzbot is
screwing around with fuzzed V4 filesystems. I almost just threw this
report in the bin because I saw it was a V4 filesytsem being
mounted.

That is, V5 filesystems will refuse to mount a filesystem with a log
that is too small, completely avoiding this sort of hang caused by
the log being way smaller than a transaction reservation (guaranteed
hang). But we cannot do the same thing for V4 filesystems, because
there were bugs in and inconsistencies between mkfs and the kernel
over the minimum valid log size. Hence when we hit a V4 filesystem
in that situation, we issue a warning and allow operation to
continue because that's historical V4 filesystem behaviour.

This kernel issued the "log size too small" warning, and then there
was a log space hang which is entirely predictable and not a kernel
bug. syzbot is doing something stupid, syzbot needs to be taught not
to do stupid things.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
