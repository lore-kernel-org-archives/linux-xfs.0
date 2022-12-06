Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2A5AC4708C
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Dec 2022 16:20:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232825AbiLFQUw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Dec 2022 11:20:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235185AbiLFQUg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Dec 2022 11:20:36 -0500
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8B482F652
        for <linux-xfs@vger.kernel.org>; Tue,  6 Dec 2022 08:19:22 -0800 (PST)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-144bd860fdbso4842539fac.0
        for <linux-xfs@vger.kernel.org>; Tue, 06 Dec 2022 08:19:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=32ACU6T/lTFb6vWGcYTKLeiJKe3uAE6xkvBDuOzVgNk=;
        b=LbL32xRyru5kJ7wApUQbhbqQCKZYP/g/3Ns7yxI04gGsqm0cvSCS3t91kfyLioc0i/
         ZwfjQTLBO7U4z+YJN7UpT9MYByVdO7inBNnvTj9vuFz+Lt/UNwY4mEgQh0AmA+S2ERJL
         OM5DOx1b+8ucHxUma4pD1LLNDMGMid8+kwMtKHP0jqSA23bJAo1ov3rs9NCUVjT8YPk5
         UHzeYnOfrSvhRNGdDjWOZaGR0dK7wUibuQZvRh0wXGAn3Dnx3N2+CF2yUDC3P4YNQ+P5
         q+IUVDVRqL4d+1x30qM0edzO8SHMSImcw9G1pDxowYByS544VTl9Mn2jtpuVT/M2XCzb
         MVLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=32ACU6T/lTFb6vWGcYTKLeiJKe3uAE6xkvBDuOzVgNk=;
        b=oqBG3IkNS1cFFJPyZnE3PQ3uKFFaBK2tlkTXnSLDtSkghGsU4XV9ixqUw5U3RhIlek
         KjRknZyVnL20TtNRo7harTMM19vOICMZwHLL0xYGVrLV6iZHFV44Qilokx+33C34akgH
         zASXj4ZmIYizzi3aAYl1myH6zT4ELxk5fslAhPvygI4pNh6gqQBWaNBf4nQVawtMjTcP
         0MguywKgugbHdylbjLR+FZAD32PTn5dCTIVDVNbR1yWyq6whXPfpG0pqquofUdoDWxLd
         N8DP2JZqqEzumXlGctdDiqwNlcsAVKUfustf3vOwfz9ZTzNJ2Unul4+PbJPUxBUVlxqQ
         LoKA==
X-Gm-Message-State: ANoB5pkBUh1OBRbauQq7BNsxfCFIwh5NKHZrNp5tQHKX4zGNdm1c5LCG
        ufjLN2RvXRUHE2VyzE/wDTOlP56PgfxJ9Vna/crlKA==
X-Google-Smtp-Source: AA0mqf4SnW30QjXP3g6g3gwsvvzjnHccMhyPlYsKb9oa8G48oeoL94t7Lvl3VpY2ZNYxx/nf5gHDOFzTtOY9OrqsAt0=
X-Received: by 2002:a05:6871:404e:b0:144:4546:61e7 with SMTP id
 ky14-20020a056871404e00b00144454661e7mr10041556oab.282.1670343562003; Tue, 06
 Dec 2022 08:19:22 -0800 (PST)
MIME-Version: 1.0
References: <000000000000bd587705ef202b08@google.com> <20221206033450.GS3600936@dread.disaster.area>
 <CACT4Y+b-DCu=3LT+OMHuy4R1Fkgg_cBBtVT=jGtcyiBn4UcbRA@mail.gmail.com> <20221206153211.GN4001@paulmck-ThinkPad-P17-Gen-1>
In-Reply-To: <20221206153211.GN4001@paulmck-ThinkPad-P17-Gen-1>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 6 Dec 2022 17:19:10 +0100
Message-ID: <CACT4Y+ZbmxyKJXM2zrJR6gNGSUS8j2_-Nu2dpC6gBEjcE3ercw@mail.gmail.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in xfs_qm_dqfree_one
To:     paulmck@kernel.org
Cc:     Dave Chinner <david@fromorbit.com>, frederic@kernel.org,
        quic_neeraju@quicinc.com, Josh Triplett <josh@joshtriplett.org>,
        RCU <rcu@vger.kernel.org>,
        syzbot <syzbot+912776840162c13db1a3@syzkaller.appspotmail.com>,
        djwong@kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 6 Dec 2022 at 16:32, Paul E. McKenney <paulmck@kernel.org> wrote:
>
> On Tue, Dec 06, 2022 at 12:06:10PM +0100, Dmitry Vyukov wrote:
> > On Tue, 6 Dec 2022 at 04:34, Dave Chinner <david@fromorbit.com> wrote:
> > >
> > > On Mon, Dec 05, 2022 at 07:12:15PM -0800, syzbot wrote:
> > > > Hello,
> > > >
> > > > syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> > > > INFO: rcu detected stall in corrupted
> > > >
> > > > rcu: INFO: rcu_preempt detected expedited stalls on CPUs/tasks: { P4122 } 2641 jiffies s: 2877 root: 0x0/T
> > > > rcu: blocking rcu_node structures (internal RCU debug):
> > >
> > > I'm pretty sure this has nothing to do with the reproducer - the
> > > console log here:
> > >
> > > > Tested on:
> > > >
> > > > commit:         bce93322 proc: proc_skip_spaces() shouldn't think it i..
> > > > git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> > > > console output: https://syzkaller.appspot.com/x/log.txt?x=1566216b880000
> > >
> > > indicates that syzbot is screwing around with bluetooth, HCI,
> > > netdevsim, bridging, bonding, etc.
> > >
> > > There's no evidence that it actually ran the reproducer for the bug
> > > reported in this thread - there's no record of a single XFS
> > > filesystem being mounted in the log....
> > >
> > > It look slike someone else also tried a private patch to fix this
> > > problem (which was obviously broken) and it failed with exactly the
> > > same RCU warnings. That was run from the same commit id as the
> > > original reproducer, so this looks like either syzbot is broken or
> > > there's some other completely unrelated problem that syzbot is
> > > tripping over here.
> > >
> > > Over to the syzbot people to debug the syzbot failure....
> >
> > Hi Dave,
> >
> > It's not uncommon for a single program to trigger multiple bugs.
> > That's what happens here. The rcu stall issue is reproducible with
> > this test program.
> > In such cases you can either submit more test requests, or test manually.
> >
> > I think there is an RCU expedited stall detection.
> > For some reason CONFIG_RCU_EXP_CPU_STALL_TIMEOUT is limited to 21
> > seconds, and that's not enough for reliable flake-free stress testing.
> > We bump other timeouts to 100+ seconds.
> > +RCU maintainers, do you mind removing the overly restrictive limit on
> > CONFIG_RCU_EXP_CPU_STALL_TIMEOUT?
> > Or you think there is something to fix in the kernel to not stall? I
> > see the test writes to
> > /proc/sys/vm/drop_caches, maybe there is some issue in that code.
>
> Like this?
>
> If so, I don't see why not.  And in that case, may I please have
> your Tested-by or similar?

I've tried with this patch and RCU_EXP_CPU_STALL_TIMEOUT=80000.
Running the test program I got some kernel BUG in XFS and no RCU
errors/warnings.

Tested-by: Dmitry Vyukov <dvyukov@google.com>

Thanks

> At the same time, I am sure that there are things in the kernel that
> should be adjusted to avoid stalls, but I recognize that different
> developers in different situations will have different issues that they
> choose to focus on.  ;-)
>
>                                                         Thanx, Paul
>
> ------------------------------------------------------------------------
>
> diff --git a/kernel/rcu/Kconfig.debug b/kernel/rcu/Kconfig.debug
> index 49da904df6aa6..2984de629f749 100644
> --- a/kernel/rcu/Kconfig.debug
> +++ b/kernel/rcu/Kconfig.debug
> @@ -82,7 +82,7 @@ config RCU_CPU_STALL_TIMEOUT
>  config RCU_EXP_CPU_STALL_TIMEOUT
>         int "Expedited RCU CPU stall timeout in milliseconds"
>         depends on RCU_STALL_COMMON
> -       range 0 21000
> +       range 0 300000
>         default 0
>         help
>           If a given expedited RCU grace period extends more than the
