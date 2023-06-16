Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BF90EB64DB
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Jun 2023 07:36:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245178AbjFPHgw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Jun 2023 03:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245155AbjFPHgv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Jun 2023 03:36:51 -0400
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 804D22137
        for <linux-xfs@vger.kernel.org>; Fri, 16 Jun 2023 00:36:46 -0700 (PDT)
Received: by mail-oo1-xc2a.google.com with SMTP id 006d021491bc7-55b2fb308bbso222057eaf.1
        for <linux-xfs@vger.kernel.org>; Fri, 16 Jun 2023 00:36:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1686901006; x=1689493006;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HQT44tAU+jQwsuvVWUITQi5RGnydNwGtYWnClDNE2HQ=;
        b=BKUAZfT5/lsGYwPJlDlOUw8IZSItat/UiRhrUR+9zbMCpwooFPiXogw1bYHq+UPvQ9
         /4WRlEh+rIS/Ygf0HKUDIZN/wFHTSBG6KhOPddeN8ili/bt+WajHbTcLv1Wdq7D4wTlj
         yQ8O4k6D6qYppRVl+ZtuuAT2p7v/1lmPsB1o/MtJrKhoQjR5PR/r1kuHGFp6e6KVa/XF
         78Bg6qY5IQpcc0U+4dGx9NhqpTxlOsAO7MHtkJvwWistMJvkvrGbefu+BaPmErapfX3P
         PN4uZHCrN4SY8JZyQyf515kTm1Qm6ihZJW3wlHkAwwBnZnhvMJ/+ok3MMCE9O/OvSkXm
         B9zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686901006; x=1689493006;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HQT44tAU+jQwsuvVWUITQi5RGnydNwGtYWnClDNE2HQ=;
        b=WJgflqiSLSwi/L3i3tZrOBI41HLBC6I2IiKuHUMHH/lt46L2hyHFwMPFzIqIuL9YGN
         W8RO3TvJN2zJR3Hx3wnyG5xrCunIMJsHTbZfqam6XBXNYS2B5u+Nrx1+n7Zq0DlT+QSW
         YNiID3jagt7KD0gw9b4/lnmQh73NdJsjR3KzriH3MVsD4RDBEaL2VmMSNZlEUrbY5wYY
         x24f0a03/4fekgu8gmeEl7ZbnNX5JH6ltF/fefuztnj5VSrouOmRE8TPetpUWEY3vK1U
         DJYlLsjoY4F4bLr8r2CN5OfFxTHqpsTZkwfpt6/DSrDAm2DM3HLXzm6KhZUYFpB1+VsT
         VzCw==
X-Gm-Message-State: AC+VfDzV/Mlpu3HDrZdFr3tyjSVEEPP8mFSloLKWccIX3W2Qaeq36wZ4
        0Apj4iQqK7z3DRB2rki4dqelmw==
X-Google-Smtp-Source: ACHHUZ6jhTevJ/U23k9ZxeZ9VuUUTK2pMi8J/HhjEn5uNAZn40qSw7CDEQr6kliaTm3UuFmyGvhgiA==
X-Received: by 2002:a05:6808:3088:b0:39c:877e:d8ca with SMTP id bl8-20020a056808308800b0039c877ed8camr1646705oib.27.1686901005592;
        Fri, 16 Jun 2023 00:36:45 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-13-202.pa.nsw.optusnet.com.au. [49.180.13.202])
        by smtp.gmail.com with ESMTPSA id d15-20020a17090a2a4f00b0025bd4db25f0sm774422pjg.53.2023.06.16.00.36.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 00:36:45 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qA40f-00COBi-1l;
        Fri, 16 Jun 2023 17:36:41 +1000
Date:   Fri, 16 Jun 2023 17:36:41 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Wengang Wang <wen.gang.wang@oracle.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "chandanrlinux@gmail.com" <chandanrlinux@gmail.com>
Subject: Re: [PATCH 1/3] xfs: pass alloc flags through to
 xfs_extent_busy_flush()
Message-ID: <ZIwRCczAhdwlt795@dread.disaster.area>
References: <20230615014201.3171380-2-david@fromorbit.com>
 <25F855D8-F944-45D0-9BB2-3E475A301EDB@oracle.com>
 <ZIuNV8UqlOFmUmOY@dread.disaster.area>
 <3EEEEF48-A255-459E-99A9-5C92344B4B7A@oracle.com>
 <8E15D551-C11A-4A0F-86F0-21EA6447CBF5@oracle.com>
 <ZIuftY4gKcjygvYv@dread.disaster.area>
 <396ACF78-518E-432A-9016-B2EAFD800B7C@oracle.com>
 <ZIuqKv58eTQL/Iij@dread.disaster.area>
 <903FC127-8564-4F12-86E8-0FF5A5A87E2E@oracle.com>
 <46BB02A0-DCEA-4FD6-9E30-A55480F16355@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46BB02A0-DCEA-4FD6-9E30-A55480F16355@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 16, 2023 at 04:27:32AM +0000, Wengang Wang wrote:
> > On Jun 15, 2023, at 5:42 PM, Wengang Wang <wen.gang.wang@oracle.com> wrote:
> >> On Jun 15, 2023, at 5:17 PM, Dave Chinner <david@fromorbit.com> wrote:
> >> Can you please post that debug and analysis, rather than just a
> >> stack trace that is completely lacking in context? Nothing can be
> >> inferred from a stack trace, and what you are saying is occurring
> >> does not match what the code should actually be doing. So I need to
> >> actually look at what is happening in detail to work out where this
> >> mismatch is coming from....
> > 
> > The debug patch was based on my previous patch, I will rework the debug patch
> > basing on yours. I will share you the debug patch, output and my analysis later. 
> > 
> 
> My analysis:
> It’s problem of double free. The first free is from xfs_efi_item_recover(), the
> second free is from xfs_extent_free_finish_item().
> Dave’s patch makes it possible that xfs_trans_free_extent() returns -EAGAIN.
> The double free problem begins when the -EAGAIN is returned.
> 
> 1. -EAGAIN returned by xfs_trans_free_extent(),  see line 5 in the debug output.
> 2. according to -EAGAIN, xfs_free_extent_later() is called to create a deferred
>    operation of type XFS_DEFER_OPS_TYPE_AGFL_FREE  to current transaction.
>    see line 6.
> 3. New EFI (xfs_efi_log_item) is created and attached to current transaction.
>    And the deferred options is moved to capture_list. see line 9. The call path is:
>    xfs_efi_item_recover()
>      xfs_defer_ops_capture_and_commit(tp, capture_list)
>        xfs_defer_ops_capture()
>          xfs_defer_create_intents()
>            xfs_defer_create_intent()
>              ops->create_intent() —>   xfs_extent_free_create_intent()
> 4. The new EFI is committed with current transaction. see line 10.
> 5. The mount process (log recover) continue to work with other intents. line 11 and line 12.
> 6. The committed new EFI was added to AIL after log flush by a parallel thread. line 20.
> 7. The mount process (log recover) continue work with other intents. line 21 to line 35.
> 8. The mount process (log recover) come to process the new EFI that was added to AIL
>    at step 6. I guess the previous log items, which were added to AIL together with the
>    EFI, were removed by xfsaild (I didn’t log that) so they didn’t appear in the AIL intents
>    iteration in xlog_recover_process_intents().  see line 36.
> 9. The new EFI record (0x25441ca, 0x30) is freed by xfs_efi_item_recover(). \
>    That’s the first free. see line 37.
> 10. The AIL intents iteration is done. It begins to process the capture_list.
> 11. it comes to the XFS_DEFER_OPS_TYPE_AGFL_FREE deferred operation which is
>     added in step 3. xfs_extent_free_finish_item() is called to free (2nd free) (0x25441ca, 0x30)
>     and it failed because (0x25441ca, 0x30) was already freed at step 9. see line 43.
>     So, it’s a double free issue.

Yes, this much I understand.

As I've been saying all along, there's something else wrong here,
because we should never encounter that new EFI in the recovery loop.
The recovery loop should see some other type of item and abort
before it sees that EFI.

So, on to the raw debug output.

> ftrace log output:
>  1            mount-4557    [003] ...1.   160.746048: xlog_recover_process_intents: last_lsn: 1b0000515f
>  2            mount-4557    [003] ...1.   160.746049: xlog_recover_process_intents: processing intent 00000000e190b7a0 lsn=1a000067b4

lsn of this EFI is 1a000067b.

>  3            mount-4557    [003] .....   160.746059: xfs_efi_item_recover: recover EFI 00000000e190b7a0 (0x2543cc4, 0x30)
>  4            mount-4557    [003] .....   160.746089: xfs_efi_item_recover: recover EFI 00000000e190b7a0 (0x25441ca, 0x30)
>  5            mount-4557    [003] .....   160.746095: xfs_efi_item_recover: -EAGAIN for EFI record (0x25441ca, 0x30)
>  6            mount-4557    [003] .....   160.746096: __xfs_free_extent_later: adding deferred op XFS_DEFER_OPS_TYPE_AGFL_FREE (0x25441ca, 0x30) to trans 00000000e503eaf8
>  7            mount-4557    [003] .....   160.746097: xfs_efi_item_recover: recover EFI 00000000e190b7a0 (0x25441b0, 0x1)
>  8            mount-4557    [003] .....   160.746098: __xfs_free_extent_later: adding deferred op XFS_DEFER_OPS_TYPE_AGFL_FREE (0x25441b0, 0x1) to trans 00000000e503eaf8
>  9            mount-4557    [003] .....   160.746099: xfs_extent_free_create_intent: new EFI 000000002027a359 to trans 00000000e503eaf8
> 10            mount-4557    [003] .....   160.746100: xfs_defer_ops_capture_and_commit: committing trans: 00000000e503eaf8

Ah, XFS_DEFER_OPS_TYPE_AGFL_FREE? where did that come from? That op
type only occurs from xfs_agfl_defer_free(), and the problem here is
that -EAGAIN comes from when we are doing allocation for the AGFL.
We are not going anywhere near the code that should set that xefi op
type.

Oh, you hard coded that in the trace_printk().

Hmmm, and none of the actual xfs trace points that tell us what is
actually going on.

Ok. trace-cmd is your friend - you can get rid of that "should
debug" stuff in the debug code...

First, create a tmpfs filesystem, cd into it so trace-cmd will dump
it's tracing data without creating xfs trace events.

then run:

# trace-cmd record -e xfs\* -e printk
....

and leave it running.

In another shell, run:

# mount test.img /mnt/test
<hang or oops>

Go back to your trace-cmd shell and ctrl-c it. Wait for it to dump
all the trace events to the trace.dat file. Then run:

# trace-cmd report > trace.txt

the trace.txt file should have the entire mount trace in it, all the
xfs events, the trace-printk output and the console output. now you
can filter everything with grep, sed, awk, python, perl, any way you
like.

Anyway, back to the printk trace. the extents in the EFI are:

1. (0x2543cc4, 0x30)
2. (0x25441ca, 0x30)
3. (0x25441b0, 0x1)

Extent #1 was freed.

Extent #2 was not freed, it got -EAGAIN. It was deferred.
Extent #3 was deferred.

The commit was done, we have a new EFI 000000002027a359 created with
extents #2 and #3.

> 11            mount-4557    [003] ...1.   160.746109: xlog_recover_process_intents: processing intent 00000000def04d9f lsn=1a000069c4
> 12            mount-4557    [003] .....   160.746110: xfs_efi_item_recover: recover EFI 00000000def04d9f (0x22ad0b9, 0x1)
> 13    kworker/42:1H-502     [042] ...1.   161.025882: xfs_trans_ail_update_bulk: adding lip 00000000cc1ccecb to AIL
> 14    kworker/42:1H-502     [042] ...1.   161.025883: xfs_trans_ail_update_bulk: adding lip 00000000b8a3774a to AIL
> 15    kworker/42:1H-502     [042] ...1.   161.025884: xfs_trans_ail_update_bulk: adding lip 000000002190f497 to AIL
> 16    kworker/42:1H-502     [042] ...1.   161.025884: xfs_trans_ail_update_bulk: adding lip 0000000043992ff9 to AIL
> 17    kworker/42:1H-502     [042] ...1.   161.025885: xfs_trans_ail_update_bulk: adding lip 000000003554d2a3 to AIL
> 18    kworker/42:1H-502     [042] ...1.   161.025885: xfs_trans_ail_update_bulk: adding lip 00000000823e9198 to AIL
> 19    kworker/42:1H-502     [042] ...1.   161.025885: xfs_trans_ail_update_bulk: adding lip 00000000ee3155a9 to AIL
> 20    kworker/42:1H-502     [042] ...1.   161.025886: xfs_trans_ail_update_bulk: adding lip 000000002027a359 to AIL

And here we have what appears to be journal IO completion adding a
bunch of log items to the AIL. The last of those log items is
000000002027a359, which is the new EFI. Ok, so we should have at
least half a dozen items in the AIL before the new EFI. All good
here.

> 21            mount-4557    [003] ...1.   161.025937: xlog_recover_process_intents: processing intent 000000005baced87 lsn=1a00006e20
> 22            mount-4557    [003] .....   161.025945: xfs_efi_item_recover: recover EFI 000000005baced87 (0x254425f, 0x2c)
> 23            mount-4557    [003] .....   161.025952: xfs_efi_item_recover: recover EFI 000000005baced87 (0x2544350, 0x14)
> 24            mount-4557    [003] ...1.   161.025961: xlog_recover_process_intents: processing intent 0000000032c6e417 lsn=1a000072aa
> 25            mount-4557    [003] .....   161.025962: xfs_efi_item_recover: recover EFI 0000000032c6e417 (0x20e30a4, 0x1)
> 26            mount-4557    [003] ...1.   161.025972: xlog_recover_process_intents: processing intent 000000001ce29d3a lsn=1a00007c5c
> 27            mount-4557    [003] .....   161.025973: xfs_efi_item_recover: recover EFI 000000001ce29d3a (0x20d2ec8, 0x1)
> 28            mount-4557    [003] ...1.   161.025980: xlog_recover_process_intents: processing intent 0000000021ef376d lsn=1a0000abfb
> 29            mount-4557    [003] .....   161.025981: xfs_efi_item_recover: recover EFI 0000000021ef376d (0x23552bd, 0x1)
> 30            mount-4557    [003] ...1.   161.025988: xlog_recover_process_intents: processing intent 00000000e1d79fc3 lsn=1a00011100
> 31            mount-4557    [003] .....   161.025989: xfs_efi_item_recover: recover EFI 00000000e1d79fc3 (0x258bf61, 0x1)
> 32            mount-4557    [003] ...1.   161.025996: xlog_recover_process_intents: processing intent 00000000a1474aa7 lsn=1a00017075
> 33            mount-4557    [003] .....   161.025998: xfs_efi_item_recover: recover EFI 00000000a1474aa7 (0x2028b96, 0x1)
> 34            mount-4557    [003] ...1.   161.026005: xlog_recover_process_intents: processing intent 000000005ae385b9 lsn=1a0001810e
> 35            mount-4557    [003] .....   161.026006: xfs_efi_item_recover: recover EFI 000000005ae385b9 (0x231579e, 0x1)

lsn is 1a0001810e, so this must be the last of the pending recovery
intents.  Now we've finished all the pending intents that needed
recovery and....

> 36            mount-4557    [003] ...1.   161.026013: xlog_recover_process_intents: processing intent 000000002027a359 lsn=1b0000515f

... we immediately find the EFI at the new head of the AIL @
lsn=1b0000515f.

So what happened to all the items added to the AIL before this item?
We clearly see them being processed in the trace above, why didn't
we trip over one of them here and abort the recovery loop?

> 37            mount-4557    [003] .....   161.026014: xfs_efi_item_recover: recover EFI 000000002027a359 (0x25441ca, 0x30)
> 38            mount-4557    [003] .....   161.026019: xfs_efi_item_recover: recover EFI 000000002027a359 (0x25441b0, 0x1)
> 39    kworker/42:1H-502     [042] ...1.   161.027123: xfs_trans_ail_update_bulk: adding lip 00000000cc1ccecb to AIL
> 40    kworker/42:1H-502     [042] ...1.   161.027123: xfs_trans_ail_update_bulk: adding lip 000000006c56fcb9 to AIL
> 41    kworker/42:1H-502     [042] ...1.   161.027124: xfs_trans_ail_update_bulk: adding lip 00000000823e9198 to AIL
> 42    kworker/42:1H-502     [042] ...1.   161.027124: xfs_trans_ail_update_bulk: adding lip 00000000b8a3774a to AIL
> 43            mount-4557    [003] .N...   161.076277: xfs_extent_free_finish_item: failed, efi: 000000002027a359, (0x25441ca, 0x30)

Yeah, so that is the -third- attempt to free the extent, not the
second.

The trace makes it pretty obvious what is happening: there's an
ordering problem in bulk AIL insertion.

Can you test the patch below on top of the three in this patchset?

-Dave
-- 
Dave Chinner
david@fromorbit.com


xfs: don't reverse order of items in bulk AIL insertion

From: Dave Chinner <dchinner@redhat.com>

Log recovery depends on the items appearing in the AIL in the same
order that they are committed into the CIL. Unfortunately, the bulk
AIL insertion has been reversing the order of the items it pulls off
the CIL at checkpoint completion. This results in intents that are
created at the end of a commit being placed into the AIL before all
the other items that were modified in the commit are placed in the
AIL.

This can cause intent recovery from the log to fail to detect the
end of initial recovery correctly.

Lucky for us, all the items fed to bulk insertion have the same LSN,
otherwise this would have screwed up both the head and tail lsn
tracking in the log.

Make sure bulk AIL insertion does not reorder items.

Fixes: 0e57f6a36f9b ("xfs: bulk AIL insertion during transaction commit")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_trans_ail.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 7d4109af193e..1098452e7f95 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -823,7 +823,7 @@ xfs_trans_ail_update_bulk(
 			trace_xfs_ail_insert(lip, 0, lsn);
 		}
 		lip->li_lsn = lsn;
-		list_add(&lip->li_ail, &tmp);
+		list_add_tail(&lip->li_ail, &tmp);
 	}
 
 	if (!list_empty(&tmp))
