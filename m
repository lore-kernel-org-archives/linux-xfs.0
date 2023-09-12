Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0A15CA0EC3
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Sep 2023 04:46:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbjILEq4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Sep 2023 00:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjILEqz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Sep 2023 00:46:55 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FEBE120
        for <linux-xfs@vger.kernel.org>; Mon, 11 Sep 2023 21:46:52 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-68fbbea0dfeso1453927b3a.0
        for <linux-xfs@vger.kernel.org>; Mon, 11 Sep 2023 21:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1694494011; x=1695098811; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6LmTr31naRcrrFN1E8gtoBrTZZTf/hWZ+9ty/UBN43c=;
        b=Z/p9WxqW9BMEzmmQnBDJMNtVh/731Wjey6nMAYJGkrGJRrNWEuZUQMexJNVelr4W+j
         lDU+jzQNc4ZOYh4yrEu/smcfBdd9Aj4pwAOB93r4pnP1vTOcyGDMLnRGwkOFrj2hSpg9
         TI0u/RD9OG88RPBVbEJKr47HhBw710Tpfd0TFrExKyFhEdB6bPUZv+cXYUfvIyTLUt0i
         ONuiecp6h/KkJhpkOpdWz4yuB4W/60+1ZcREgwSMwrHZE8Am9jqHmhucLylDMcVBuZ6R
         V8zDxc91lGYfAK8fu9LKo0ORa17+vZTUQ85Djce9ZE/tsqw++/8JSjFgbzpmYYNq0mZH
         w5CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694494011; x=1695098811;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6LmTr31naRcrrFN1E8gtoBrTZZTf/hWZ+9ty/UBN43c=;
        b=DEAKqLuSALKEnmXKNAeYuo2xEcyxKAlmsMEDTaMQ+sRHuGFl335tcTxEnIIOTiDkDJ
         ID0EH8wFAiitdaBW9fd8NltTpUCih3Rcgy2l4zq4HRRRo2tSGAcQ7Iar2X0tHbQ6/QnO
         WwG25IiEB41d4Y6L0F4wYcwyeiSrXc7gCsWYyWKNvdkpA1lkoFOFpWoacxIFHk6kIJ6D
         VByy9j4R7g9LfiqYKRu3ovLBab/u3kBD45tDsg2jxN/ERBIjRhrt6HXs9gFpWGJwOdrl
         QiZgjAUCdzcPCYec2MTLazzSMnwIIVRiftZxU/IXR7sONTlOrNlwn35ZH8F2b9Y9e+G6
         qRMA==
X-Gm-Message-State: AOJu0YzS6wdXojWvayP9K7t3cOaKMa7ktfYspTHWx7WEcWSiRrz9bFYj
        pwTb+V9+PVBgwuxZihXiG06G9g==
X-Google-Smtp-Source: AGHT+IEm76xQ5qf3+6OLCdVmQVM8Bh6kZJmd56V1Jv0MSsw75CPqIERSV0AKKjFxVFEv2T2/6d4IKw==
X-Received: by 2002:a05:6a00:3022:b0:68f:cf6f:e228 with SMTP id ay34-20020a056a00302200b0068fcf6fe228mr2937567pfb.23.1694494011446;
        Mon, 11 Sep 2023 21:46:51 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-66-88.pa.nsw.optusnet.com.au. [49.195.66.88])
        by smtp.gmail.com with ESMTPSA id bg17-20020a056a001f9100b0068be3489b0dsm3733850pfb.172.2023.09.11.21.46.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Sep 2023 21:46:50 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qfvIW-00E4zI-0B;
        Tue, 12 Sep 2023 14:46:48 +1000
Date:   Tue, 12 Sep 2023 14:46:48 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        xfs <linux-xfs@vger.kernel.org>, harshit.m.mogalapalli@oracle.com
Subject: Re: [PATCH] xfs: only call xchk_stats_merge after validating scrub
 inputs
Message-ID: <ZP/tOMEfDaSe3ndX@dread.disaster.area>
References: <20230911153732.GZ28186@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230911153732.GZ28186@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 11, 2023 at 08:37:32AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Harshit Mogalapalli slogged through several reports from our internal
> syzbot instance and observed that they all had a common stack trace:
> 
> BUG: KASAN: user-memory-access in instrument_atomic_read_write include/linux/instrumented.h:96 [inline]
> BUG: KASAN: user-memory-access in atomic_try_cmpxchg_acquire include/linux/atomic/atomic-instrumented.h:1294 [inline]
> BUG: KASAN: user-memory-access in queued_spin_lock include/asm-generic/qspinlock.h:111 [inline]
> BUG: KASAN: user-memory-access in do_raw_spin_lock include/linux/spinlock.h:187 [inline]
> BUG: KASAN: user-memory-access in __raw_spin_lock include/linux/spinlock_api_smp.h:134 [inline]
> BUG: KASAN: user-memory-access in _raw_spin_lock+0x76/0xe0 kernel/locking/spinlock.c:154
> Write of size 4 at addr 0000001dd87ee280 by task syz-executor365/1543
> 
> CPU: 2 PID: 1543 Comm: syz-executor365 Not tainted 6.5.0-syzk #1
> Hardware name: Red Hat KVM, BIOS 1.13.0-2.module+el8.3.0+7860+a7792d29 04/01/2014
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0x83/0xb0 lib/dump_stack.c:106
>  print_report+0x3f8/0x620 mm/kasan/report.c:478
>  kasan_report+0xb0/0xe0 mm/kasan/report.c:588
>  check_region_inline mm/kasan/generic.c:181 [inline]
>  kasan_check_range+0x139/0x1e0 mm/kasan/generic.c:187
>  instrument_atomic_read_write include/linux/instrumented.h:96 [inline]
>  atomic_try_cmpxchg_acquire include/linux/atomic/atomic-instrumented.h:1294 [inline]
>  queued_spin_lock include/asm-generic/qspinlock.h:111 [inline]
>  do_raw_spin_lock include/linux/spinlock.h:187 [inline]
>  __raw_spin_lock include/linux/spinlock_api_smp.h:134 [inline]
>  _raw_spin_lock+0x76/0xe0 kernel/locking/spinlock.c:154
>  spin_lock include/linux/spinlock.h:351 [inline]
>  xchk_stats_merge_one.isra.1+0x39/0x650 fs/xfs/scrub/stats.c:191
>  xchk_stats_merge+0x5f/0xe0 fs/xfs/scrub/stats.c:225
>  xfs_scrub_metadata+0x252/0x14e0 fs/xfs/scrub/scrub.c:599
>  xfs_ioc_scrub_metadata+0xc8/0x160 fs/xfs/xfs_ioctl.c:1646
>  xfs_file_ioctl+0x3fd/0x1870 fs/xfs/xfs_ioctl.c:1955
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:871 [inline]
>  __se_sys_ioctl fs/ioctl.c:857 [inline]
>  __x64_sys_ioctl+0x199/0x220 fs/ioctl.c:857
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x3e/0x90 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
> RIP: 0033:0x7ff155af753d
> Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 1b 79 2c 00 f7 d8 64 89 01 48
> RSP: 002b:00007ffc006e2568 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007ff155af753d
> RDX: 00000000200000c0 RSI: 00000000c040583c RDI: 0000000000000003
> RBP: 00000000ffffffff R08: 00000000004010c0 R09: 00000000004010c0
> R10: 00000000004010c0 R11: 0000000000000246 R12: 0000000000400cb0
> R13: 00007ffc006e2670 R14: 0000000000000000 R15: 0000000000000000
>  </TASK>
> 
> The root cause here is that xchk_stats_merge_one walks off the end of
> the xchk_scrub_stats.cs_stats array because it has been fed a garbage
> value in sm->sm_type.  That occurs because I put the xchk_stats_merge
> in the wrong place -- it should have been after the last xchk_teardown
> call on our way out of xfs_scrub_metadata because we only call the
> teardown function if we called the setup function, and we don't call the
> setup functions if the inputs are obviously garbage.
> 
> Thanks to Harshit for triaging the bug reports and bringing this to my
> attention.  This is a helluva better way to handle syzbot reports than
> spraying sploits on the public list like Googlers do.

That last sentence doesn't need to be in the commit message.

Other than that, the fix looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
