Return-Path: <SRS0=K1zF=AH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69A9CC433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Jun 2020 07:34:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D6212076E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Jun 2020 07:34:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="keQZds/l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728780AbgFZHeH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 Jun 2020 03:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbgFZHeH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Jun 2020 03:34:07 -0400
Received: from casper.infradead.org (unknown [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37BB0C08C5C1;
        Fri, 26 Jun 2020 00:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=zbN1ulch9rZ4niblYdDmrogh/ucMAtIIdZvcbRZeJwo=; b=keQZds/lzIurEpTSTm9bSVKeC3
        B/lrVXeQQ1VEC24r4noHb6c9lQWTwezebZ4x+y8verDh2sZMFY0DufuZnX4wZTY0+unJItSfbsmVs
        LOQ2BZQDVwPtFHNRF/mArW21UbjgrY25mRJId+v2yRIFVRTo2LO2xceBlH48f9vTODaYu26SzfKm8
        Of69z6wQBHftqmx+P9g0p2LLQKGgXmE1GfK+aTOLVwPd0kcFiIR8wkgGI4mgdk1PxM8uU70VFKJEL
        QAOs8s8xubhluRWSrdp2hJQ0BDC/AdKf3hEW2U5kGLhRD+8HhNW3PxaScmOGufngoLdo2F8j/YyoW
        ZlSt8gNA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1joirt-00056l-LA; Fri, 26 Jun 2020 07:33:49 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 2ECCD301DFC;
        Fri, 26 Jun 2020 09:33:45 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 1D63B20CF218A; Fri, 26 Jun 2020 09:33:45 +0200 (CEST)
Date:   Fri, 26 Jun 2020 09:33:45 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [Bug, sched, 5.8-rc2]: PREEMPT kernels crashing in
 check_preempt_wakeup() running fsx on XFS
Message-ID: <20200626073345.GI4800@hirez.programming.kicks-ass.net>
References: <20200626004722.GF2005@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200626004722.GF2005@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 26, 2020 at 10:47:22AM +1000, Dave Chinner wrote:
> [ 1102.169209] BUG: kernel NULL pointer dereference, address: 0000000000000150
> [ 1102.171270] #PF: supervisor read access in kernel mode
> [ 1102.172894] #PF: error_code(0x0000) - not-present page
> [ 1102.174408] PGD 0 P4D 0
> [ 1102.175136] Oops: 0000 [#1] PREEMPT SMP
> [ 1102.176293] CPU: 2 PID: 909 Comm: kworker/2:1H Not tainted 5.8.0-rc2-dgc+ #2469
> [ 1102.178395] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
> [ 1102.180762] Workqueue: xfs-log/pmem0 xlog_ioend_work
> [ 1102.182286] RIP: 0010:check_preempt_wakeup+0xc8/0x1e0
> [ 1102.183804] Code: 39 c2 75 f2 89 d0 39 d0 7d 20 83 ea 01 4d 8b a4 24 48 01 00 00 39 d0 75 f1 eb 0f 48 8b 9b 48 01 00 00 4d 8b a4 24 48 01 00 00 <48> 8b bb 50 01 00 00 49 39 bc 24 b
> [ 1102.189125] RSP: 0018:ffffc9000071cea0 EFLAGS: 00010006
> [ 1102.190625] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff822305a0
> [ 1102.192737] RDX: 0000000000000000 RSI: ffff88853337cd80 RDI: ffff88853ea2a940
> [ 1102.194827] RBP: ffffc9000071ced8 R08: ffffffff822305a0 R09: ffff88853ec2b2d0
> [ 1102.196886] R10: ffff88800f74b010 R11: ffff88853ec2a970 R12: 0000000000000000
> [ 1102.199040] R13: ffff88853ea2a8c0 R14: 0000000000000001 R15: ffff88853e3b0000
> [ 1102.200883] FS:  0000000000000000(0000) GS:ffff88853ea00000(0000) knlGS:0000000000000000
> [ 1102.203306] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1102.205024] CR2: 0000000000000150 CR3: 00000000ae7b5004 CR4: 0000000000060ee0
> [ 1102.207117] Call Trace:
> [ 1102.207895]  <IRQ>
> [ 1102.208500]  ? enqueue_task_fair+0x1d7/0x9f0
> [ 1102.209709]  check_preempt_curr+0x74/0x80
> [ 1102.210931]  ttwu_do_wakeup+0x1e/0x170
> [ 1102.212064]  ttwu_do_activate+0x5b/0x70
> [ 1102.213225]  sched_ttwu_pending+0x94/0xe0
> [ 1102.214410]  flush_smp_call_function_queue+0xf1/0x190
> [ 1102.215885]  generic_smp_call_function_single_interrupt+0x13/0x20
> [ 1102.217790]  __sysvec_call_function_single+0x2b/0xe0
> [ 1102.219375]  asm_call_on_stack+0xf/0x20
> [ 1102.220599]  </IRQ>
> [ 1102.221280]  sysvec_call_function_single+0x7e/0x90
> [ 1102.222854]  asm_sysvec_call_function_single+0x12/0x20

https://git.kernel.org/tip/964ed98b075263faabe416eeebac99a9bef3f06c

Should be headed to Linus soon.
