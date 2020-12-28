Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83D3EC433E6
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Dec 2020 23:14:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B4F5223C8
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Dec 2020 23:14:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727231AbgL1XOV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Dec 2020 18:14:21 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:50131 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729666AbgL1XOR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 28 Dec 2020 18:14:17 -0500
Received: from [192.168.0.8] (ip5f5aef2f.dynamic.kabel-deutschland.de [95.90.239.47])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: buczek)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 4C9012064622D;
        Tue, 29 Dec 2020 00:13:34 +0100 (CET)
Subject: Re: v5.10.1 xfs deadlock
From:   Donald Buczek <buczek@molgen.mpg.de>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        it+linux-xfs@molgen.mpg.de
References: <b8da4aed-ee44-5d9f-88dc-3d32f0298564@molgen.mpg.de>
 <20201217194317.GD2507317@bfoster>
 <39b92850-f2ff-e4b6-0b2e-477ab3ec3c87@molgen.mpg.de>
 <20201218153533.GA2563439@bfoster>
 <8e9a2939-220d-b12f-a24e-0fb48fa95215@molgen.mpg.de>
 <066cb9e2-f583-b2c7-f42c-861568d38e2f@molgen.mpg.de>
Message-ID: <1705b481-16db-391e-48a8-a932d1f137e7@molgen.mpg.de>
Date:   Tue, 29 Dec 2020 00:13:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <066cb9e2-f583-b2c7-f42c-861568d38e2f@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 27.12.20 18:34, Donald Buczek wrote:
> On 18.12.20 19:35, Donald Buczek wrote:
>> On 18.12.20 16:35, Brian Foster wrote:
>>> On Thu, Dec 17, 2020 at 10:30:37PM +0100, Donald Buczek wrote:
>>>> On 17.12.20 20:43, Brian Foster wrote:
>>>>> On Thu, Dec 17, 2020 at 06:44:51PM +0100, Donald Buczek wrote:
>>>>>> Dear xfs developer,
>>>>>>
>>>>>> I was doing some testing on a Linux 5.10.1 system with two 100 TB xfs filesystems on md raid6 raids.
>>>>>>
>>>>>> The stress test was essentially `cp -a`ing a Linux source repository with two threads in parallel on each filesystem.
>>>>>>
>>>>>> After about on hour, the processes to one filesystem (md1) blocked, 30 minutes later the process to the other filesystem (md0) did.
>>>>>>
>>>>>>       root      7322  2167  0 Dec16 pts/1    00:00:06 cp -a /jbod/M8068/scratch/linux /jbod/M8068/scratch/1/linux.018.TMP
>>>>>>       root      7329  2169  0 Dec16 pts/1    00:00:05 cp -a /jbod/M8068/scratch/linux /jbod/M8068/scratch/2/linux.019.TMP
>>>>>>       root     13856  2170  0 Dec16 pts/1    00:00:08 cp -a /jbod/M8067/scratch/linux /jbod/M8067/scratch/2/linux.028.TMP
>>>>>>       root     13899  2168  0 Dec16 pts/1    00:00:05 cp -a /jbod/M8067/scratch/linux /jbod/M8067/scratch/1/linux.027.TMP
>>>>>>
>>>
>>> Do you have any indication of whether these workloads actually hung or
>>> just became incredibly slow?
>>
>> There is zero progress. iostat doesn't show any I/O on any of the block devices (md or member)
>>
>>>>>> Some info from the system (all stack traces, slabinfo) is available here: https://owww.molgen.mpg.de/~buczek/2020-12-16.info.txt
>>>>>>
>>>>>> It stands out, that there are many (549 for md0, but only 10 for md1)  "xfs-conv" threads all with stacks like this
>>>>>>
>>>>>>       [<0>] xfs_log_commit_cil+0x6cc/0x7c0
>>>>>>       [<0>] __xfs_trans_commit+0xab/0x320
>>>>>>       [<0>] xfs_iomap_write_unwritten+0xcb/0x2e0
>>>>>>       [<0>] xfs_end_ioend+0xc6/0x110
>>>>>>       [<0>] xfs_end_io+0xad/0xe0
>>>>>>       [<0>] process_one_work+0x1dd/0x3e0
>>>>>>       [<0>] worker_thread+0x2d/0x3b0
>>>>>>       [<0>] kthread+0x118/0x130
>>>>>>       [<0>] ret_from_fork+0x22/0x30
>>>>>>
>>>>>> xfs_log_commit_cil+0x6cc is
>>>>>>
>>>>>>     xfs_log_commit_cil()
>>>>>>       xlog_cil_push_background(log)
>>>>>>         xlog_wait(&cil->xc_push_wait, &cil->xc_push_lock);
>>>>>>
>>>
>>> This looks like the transaction commit throttling code. That was
>>> introduced earlier this year in v5.7 via commit 0e7ab7efe7745 ("xfs:
>>> Throttle commits on delayed background CIL push"). The purpose of that
>>> change was to prevent the CIL from growing too large. FWIW, I don't
>>> recall that being a functional problem so it should be possible to
>>> simply remove that blocking point and see if that avoids the problem or
>>> if we simply stall out somewhere else, if you wanted to give that a
>>> test.
>>
>> Will do. Before trying with this commit reverted, I will repeat the test without any change to see if the problem is reproducible at all.
> 
> I'm now able to reliably reproduce the deadlock with a little less complex setup (e.g. with only one filesystem involved). One key to that was to run the test against a freshly created filesystem (mkfs).
> 
> And, yes, you are right: When I revert ef565ab8cc2e ("xfs: Throttle commits on delayed background CIL push") and 7ee6dfa2a245 ("xfs: fix use-after-free on CIL context on shutdown") the deadlock seems to be gone.

Hash Correction: 0e7ab7efe774 ("xfs: Throttle commits on delayed background CIL push") and c7f87f3984cf ("xfs: fix use-after-free on CIL context on shutdown")

When I tried to remove only the wait:

     --- a/fs/xfs/xfs_log_cil.c
     +++ b/fs/xfs/xfs_log_cil.c
     @@ -936,7 +936,6 @@ xlog_cil_push_background(
             if (cil->xc_ctx->space_used >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log)) {
                     trace_xfs_log_cil_wait(log, cil->xc_ctx->ticket);
                     ASSERT(cil->xc_ctx->space_used < log->l_logsize);
     -               xlog_wait(&cil->xc_push_wait, &cil->xc_push_lock);
                     return;
             }

the system got into a critical overload situation with many kworker threads at 100% CPU and became totally unresponsive after a while, requiring sysrq triggered reboot.

I noticed, that 7ee6dfa2a245 ("xfs: fix use-after-free on CIL context on shutdown") put the `wake_up_all(&ctx->push_wait)` into an additional conditional `if (ctx->space_used >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log))` - the same as is used to decide whether the background push is triggered at all. But in the deadlock situation, I've seen waiters waiting on cil->xc_push_wait with ctx->space_used being zero with the debugger:

     $L_003: (struct xfs_cil *) 0xffff889886db0700 : {
         xc_cil = {next = 0xffff889886db0708, prev = 0xffff889886db0708}    /* empty */
         xc_ctx = 0xffff888e2cb6dd80 /* --> $L_004 */
         xc_push_seq = 31
         xc_committing = {next = 0xffff889886db0790, prev = 0xffff889886db0790}    /* empty */
         xc_current_sequence = 32
         xc_push_wait = {
             head = {next = 0xffffc9000dbcbd48, prev = 0xffffc90021a1bd20}
         }
     }
     $L_004: (struct xfs_cil_ctx *) 0xffff888e2cb6dd80 : {
         sequence = 32
         start_lsn = 0
         commit_lsn = 0
         space_used = 0
         committing = {next = 0xffff888e2cb6ddd8, prev = 0xffff888e2cb6ddd8}    /* empty */
     }


So, out of curiosity I've tried

     --- a/fs/xfs/xfs_log_cil.c
     +++ b/fs/xfs/xfs_log_cil.c
     @@ -670,8 +670,7 @@ xlog_cil_push_work(
             /*
              * Wake up any background push waiters now this context is being pushed.
              */
     -       if (ctx->space_used >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log))
     -               wake_up_all(&cil->xc_push_wait);
     +       wake_up_all(&cil->xc_push_wait);
      
             /*
              * Check if we've anything to push. If there is nothing, then we don't

and this seems to fix the problem. But I don't understand, how this is possible.
