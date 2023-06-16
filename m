Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 251E8EB64D7
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Jun 2023 22:29:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjFPW3o (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Jun 2023 18:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjFPW3n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Jun 2023 18:29:43 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E862D72
        for <linux-xfs@vger.kernel.org>; Fri, 16 Jun 2023 15:29:41 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-6668c030ec9so1126876b3a.1
        for <linux-xfs@vger.kernel.org>; Fri, 16 Jun 2023 15:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1686954581; x=1689546581;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=R9kCQYIcEm8GMdDayMOedI+x2kczTE6ieYhxS87ByOI=;
        b=Gcc9zXNEYM9qk+l+BQ+UNJT3Y217goSsnG36O5oAfcc/YOhwxs+RVuF58C2wCJJ1BX
         OfOFA+tyot9vnnB6fsgJbXOoMiGIk2x7t2WS8H6DCgIg60tp8Dfq/3AnJipzmk6LAOui
         IF0omNHfv9B3k0jhRmx2h3cPPxdAh07A5JRwxiMCekogGyOGq2Kc9vAZJsCUoBdLn742
         DHNOd0iXyQ3btkz0ledSlGv3biraMWnWn68ySSftUBY5SC2HtKbabhVIdIa1ArV9vtfS
         km/s8tL1oq85mZ+N/4PbuznX6BE87WqEibbfiYD8qjpFIzV5BuP9kFCZOolaslzTKSdX
         fuvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686954581; x=1689546581;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R9kCQYIcEm8GMdDayMOedI+x2kczTE6ieYhxS87ByOI=;
        b=h5YMvcEvOJdgaejh3xvCkSyqpSx+Nft6SxieKjGSYzTlgNu1svLRYUw0QdX/JRokzD
         A9BjC+6bI9ZxcFdsaq0UbfBoONRDkRaNMt/Dgp9mtalwZFe17qLV9DRoWwkXrBuGEvnf
         9WuXFGeCd0wvykeYciYO3yR1ytKATCAV/UrgYfrp92lum/u7o2bllRCZjtm8Bypr7Ud3
         LIO5+GCChKVwGwpleN9/7xZoNDsn0d2VgazT/G7TjaxVEEMcEdHEl7y+z5l6fbq8wRwZ
         adc9VjGhjokW5nuGhXOawf+TNnaMQo9xA57axQ9QiI5seZyvcQwji+aM9hCov8TIr5Wv
         dYyg==
X-Gm-Message-State: AC+VfDw9rbqp3lVEGEKG+tmP2alyh9WnwYsE6bv+AGdUGToIXgU8/MLH
        4JeqGzvMvoIEccpAzJOZsp1SK+EnaVuiQwcQ2WE=
X-Google-Smtp-Source: ACHHUZ5ak5pPmtNYl0jaXNfCQ378wIt7G5NxTDdjvurEj1p/K6Yrw/vwfS6qlx8oNMcr2NO26IeokA==
X-Received: by 2002:a05:6a00:22d2:b0:64d:1185:241a with SMTP id f18-20020a056a0022d200b0064d1185241amr4346502pfj.5.1686954581004;
        Fri, 16 Jun 2023 15:29:41 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-13-202.pa.nsw.optusnet.com.au. [49.180.13.202])
        by smtp.gmail.com with ESMTPSA id g17-20020a631111000000b0054ff36967f7sm3436715pgl.54.2023.06.16.15.29.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 15:29:40 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qAHwm-00CdXK-0J;
        Sat, 17 Jun 2023 08:29:36 +1000
Date:   Sat, 17 Jun 2023 08:29:36 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Wengang Wang <wen.gang.wang@oracle.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "chandanrlinux@gmail.com" <chandanrlinux@gmail.com>
Subject: Re: [PATCH 1/3] xfs: pass alloc flags through to
 xfs_extent_busy_flush()
Message-ID: <ZIziUAhl71xz305l@dread.disaster.area>
References: <ZIuNV8UqlOFmUmOY@dread.disaster.area>
 <3EEEEF48-A255-459E-99A9-5C92344B4B7A@oracle.com>
 <8E15D551-C11A-4A0F-86F0-21EA6447CBF5@oracle.com>
 <ZIuftY4gKcjygvYv@dread.disaster.area>
 <396ACF78-518E-432A-9016-B2EAFD800B7C@oracle.com>
 <ZIuqKv58eTQL/Iij@dread.disaster.area>
 <903FC127-8564-4F12-86E8-0FF5A5A87E2E@oracle.com>
 <46BB02A0-DCEA-4FD6-9E30-A55480F16355@oracle.com>
 <ZIwRCczAhdwlt795@dread.disaster.area>
 <B7796875-650A-4EC5-8977-2016C24C5824@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <B7796875-650A-4EC5-8977-2016C24C5824@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 16, 2023 at 05:43:42PM +0000, Wengang Wang wrote:
> > On Jun 16, 2023, at 12:36 AM, Dave Chinner <david@fromorbit.com> wrote:
> > On Fri, Jun 16, 2023 at 04:27:32AM +0000, Wengang Wang wrote:
> >>> On Jun 15, 2023, at 5:42 PM, Wengang Wang <wen.gang.wang@oracle.com> wrote:
> >>>> On Jun 15, 2023, at 5:17 PM, Dave Chinner <david@fromorbit.com> wrote:
> >>>> Can you please post that debug and analysis, rather than just a
> >>>> stack trace that is completely lacking in context? Nothing can be
> >>>> inferred from a stack trace, and what you are saying is occurring
> >>>> does not match what the code should actually be doing. So I need to
> >>>> actually look at what is happening in detail to work out where this
> >>>> mismatch is coming from....
> >>> 
> >>> The debug patch was based on my previous patch, I will rework the debug patch
> >>> basing on yours. I will share you the debug patch, output and my analysis later. 
> >>> 
> >> 
> >> My analysis:
> >> It’s problem of double free. The first free is from xfs_efi_item_recover(), the
> >> second free is from xfs_extent_free_finish_item().
> >> Dave’s patch makes it possible that xfs_trans_free_extent() returns -EAGAIN.
> >> The double free problem begins when the -EAGAIN is returned.
> >> 
> >> 1. -EAGAIN returned by xfs_trans_free_extent(),  see line 5 in the debug output.
> >> 2. according to -EAGAIN, xfs_free_extent_later() is called to create a deferred
> >>   operation of type XFS_DEFER_OPS_TYPE_AGFL_FREE  to current transaction.
> >>   see line 6.
> >> 3. New EFI (xfs_efi_log_item) is created and attached to current transaction.
> >>   And the deferred options is moved to capture_list. see line 9. The call path is:
> >>   xfs_efi_item_recover()
> >>     xfs_defer_ops_capture_and_commit(tp, capture_list)
> >>       xfs_defer_ops_capture()
> >>         xfs_defer_create_intents()
> >>           xfs_defer_create_intent()
> >>             ops->create_intent() —>   xfs_extent_free_create_intent()
> >> 4. The new EFI is committed with current transaction. see line 10.
> >> 5. The mount process (log recover) continue to work with other intents. line 11 and line 12.
> >> 6. The committed new EFI was added to AIL after log flush by a parallel thread. line 20.
> >> 7. The mount process (log recover) continue work with other intents. line 21 to line 35.
> >> 8. The mount process (log recover) come to process the new EFI that was added to AIL
> >>   at step 6. I guess the previous log items, which were added to AIL together with the
> >>   EFI, were removed by xfsaild (I didn’t log that) so they didn’t appear in the AIL intents
> >>   iteration in xlog_recover_process_intents().  see line 36.
> >> 9. The new EFI record (0x25441ca, 0x30) is freed by xfs_efi_item_recover(). \
> >>   That’s the first free. see line 37.
> >> 10. The AIL intents iteration is done. It begins to process the capture_list.
> >> 11. it comes to the XFS_DEFER_OPS_TYPE_AGFL_FREE deferred operation which is
> >>    added in step 3. xfs_extent_free_finish_item() is called to free (2nd free) (0x25441ca, 0x30)
> >>    and it failed because (0x25441ca, 0x30) was already freed at step 9. see line 43.
> >>    So, it’s a double free issue.
> > 
> > Yes, this much I understand.
> > 
> > As I've been saying all along, there's something else wrong here,
> > because we should never encounter that new EFI in the recovery loop.
> > The recovery loop should see some other type of item and abort
> > before it sees that EFI.
> 
> Maybe you are right. But here is my concern, its possible that:
> Even the were other types of items placed in AIL before that new EFI
> (after your change list_add() -> list_add_tail()), suppose this scenario:
> 
> # suppose there were many log intents after the Original EFI (which needs retry)
>    to process. 
> 1.  Non EFI type log items (say Item A to Item C) were added to AIL.
> 2.  That new EFI log item, Item D was added to AIL.
> 3.  Now the recovery process the remaining log intents. it takes long enough
>      to let step 4 happen. 
> 4.  During the time that the mount (log recover) process was processing the
>      remaining intents (suppose that needs long enough time), Item A, Item B
>      and Item C (on AIL) were processed by xfs_aild (iop_push()) and them was
>      removed from AIL later.  Possible?
> 5.  In the recovery intents loop, it comes to the first new log item, that is Item D,
>      the new EFI.  (Item A to Item C didn’t come before Item D because they were
>      removed in step 4).
> 6.  the records in the new EFI was freed by xfs_efi_item_recover()
> 7.  the same records in the same new EFI was freed by xfs_extent_free_finish_item()
>      again.
> 
> If above is possible, the problem still exists even you make sure the new log
> items in original order when they are placed to AIL.

Yes, I *know this can happen*.

What I've been trying to understand is *how the bug occurred in the
first place*. 

Root cause analysis comes first. Second is confirming the analysis
is correct. Only then do we really start thinking about how to fix
it properly.

We are at the second step: I need *empirical confirmation* that this
ordering problem is the root cause of the behaviour that was
observed.

Stop trying to fix the problem before we understand how it happened!

> > Go back to your trace-cmd shell and ctrl-c it. Wait for it to dump
> > all the trace events to the trace.dat file. Then run:
> > 
> > # trace-cmd report > trace.txt
> > 
> > the trace.txt file should have the entire mount trace in it, all the
> > xfs events, the trace-printk output and the console output. now you
> > can filter everything with grep, sed, awk, python, perl, any way you
> > like.
> > 
> 
> Good to know. Well, seems it can’t tell us the -EAGAIN thing? We don’t
> have trace even in every function for every case.

We don't need an explicit trace for that. If we hit that code path
in recovery, we will see a xfs_bmap_free_deferred trace for an
extent from recovery, followed by a xfs_alloc_size_busy/xfs_alloc_near_busy
event followed immediately by a xfs_bmap_free_defer event for the
extent we were trying to free.

That tells us an EAGAIN was received and the extent free was
deferred.

All the tracepoints we need to tell us what is happening in this
path, one just needs to connect the dots correctly.

> > The trace makes it pretty obvious what is happening: there's an
> > ordering problem in bulk AIL insertion.
> > 
> > Can you test the patch below on top of the three in this patchset?
> 
> This maybe work for this specific mounting, but it looks a bit tricky to me.
> Please see my comment above. I meant the below patch maybe can ‘fix’ the issue
> occurred to this specific xfs volume(metadump), but will is it sure to fix all cases?

I don't care about "other cases" right now. All I'm trying to do is
confirm that this is the *root cause* of *this problem*.

I am aware that this is a test patch, and that I wrote it purely to
confirm my hypothesis. I am aware that it doesn't fix everything and
I am aware that I am not *trying to fix everything* with it. I need
confirmation that my root cause analysis is correct before I spend
any time on working out how to fix the problem completely.

So, can you please just test the patch and see if the problem is
fixed?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
