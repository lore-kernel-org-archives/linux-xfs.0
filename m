Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A83D9C00140
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Aug 2022 16:12:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbiHOQMU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 Aug 2022 12:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiHOQMS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Aug 2022 12:12:18 -0400
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 727FBD110
        for <linux-xfs@vger.kernel.org>; Mon, 15 Aug 2022 09:12:17 -0700 (PDT)
Received: by mail-vs1-xe2b.google.com with SMTP id v128so7585590vsb.10
        for <linux-xfs@vger.kernel.org>; Mon, 15 Aug 2022 09:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=hGI7+30TGL6i74E98fJnSSmDsKfYeA3LK36S1KV4ts4=;
        b=BMjN9TLaUOkYmsdSk2igMHIKPgcRqu2XfZjPfQZcEeYCweSKkeXPphP9bfRb5MOJTK
         bWZdCh+FWzDLGxDfGros0MpX60mMvAFJEsuYgRTQQtJnUMMjKPIVAIG9eJOQAXqFXLAP
         AeMuby1Ij8UI/0IL5lwLY1hNt+iMenyyj3wZGEQ94AZA00RSOOI2O0Z6eCh+21LgjTkZ
         8KXBMalqqy9oEmOOi0nREDQ37XbA0b92TWUAXQwDGbgHF38DM00alXLCcO4hr0y2gQHr
         g1P89kFxHzAPyiKq21TUmhDrvTcf0wiwCdlK69BwbQPQwiEITPg+G02SFt8ovQZA5SBJ
         dV7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=hGI7+30TGL6i74E98fJnSSmDsKfYeA3LK36S1KV4ts4=;
        b=A7fant+cIUjKbVwmLfPU7oW/U966zZ7ZyTclmqmWEUNLBt/tAUByf1KuDnA1vPYFhX
         iijRpDvYKCQnfUKSUZlthnBSM0YpunAOjdR2BIje5zmvp5LT2/KOocojcB9CdqLMUhH8
         LS5JxDTUF+qbDdafVXFFNXYhraHfgMIHLGmJX+RYQmWOYr3NhPG9RI9kzlXoIMigRNhD
         XmXkHkyMBNcyxjFHLbe47uEXJrKmlYqszKSUNIHg5sFhfyHENihpwL6wCl0zXpf1vxRB
         NLYWcs3zZzq5oYGLd9QMUkHDECxGhXm8bqhk54TL3jrpx0JKCHHqMvUFCJsyUmz6o4Fe
         nMMA==
X-Gm-Message-State: ACgBeo0Q90MKMeFK8oC0H+sFSGFMRGKbXBSjhV3arLiF/NNm3uYq2FOq
        sPuKJG5NWdJSkwh5FycpjVsBFZYC8dvZmBkzwc2mxrnB
X-Google-Smtp-Source: AA6agR41TeABhcSWY6KGOz/wlrNppj+mCw9OIhg0tztUFGllLmbg3cInw6zDM5Dg9THDNW/6AGwsMjdUPVYsAMEqaPs=
X-Received: by 2002:a05:6102:578d:b0:388:afb5:23f3 with SMTP id
 dh13-20020a056102578d00b00388afb523f3mr6966815vsb.3.1660579936525; Mon, 15
 Aug 2022 09:12:16 -0700 (PDT)
MIME-Version: 1.0
References: <bug-216343-201763@https.bugzilla.kernel.org/> <20220814235445.GS3600936@dread.disaster.area>
In-Reply-To: <20220814235445.GS3600936@dread.disaster.area>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 15 Aug 2022 19:12:04 +0300
Message-ID: <CAOQ4uxhCM5bV+ZvyCddFTU-9mH-OGyTG0ewvoBdUWquWKthfjw@mail.gmail.com>
Subject: Re: [Bug 216343] New: XFS: no space left in xlog cause system hang
To:     Dave Chinner <david@fromorbit.com>
Cc:     bugzilla-daemon@kernel.org, linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 15, 2022 at 2:54 AM Dave Chinner <david@fromorbit.com> wrote:
>
> [cc Amir, the 5.10 stable XFS maintainer]
>
> On Tue, Aug 09, 2022 at 11:46:23AM +0000, bugzilla-daemon@kernel.org wrote:
> > https://bugzilla.kernel.org/show_bug.cgi?id=216343
> >
> >             Bug ID: 216343
> >            Summary: XFS: no space left in xlog cause system hang
> >            Product: File System
> >            Version: 2.5
> >     Kernel Version: 5.10.38
> >           Hardware: ARM
> >                 OS: Linux
> >               Tree: Mainline
> >             Status: NEW
> >           Severity: normal
> >           Priority: P1
> >          Component: XFS
> >           Assignee: filesystem_xfs@kernel-bugs.kernel.org
> >           Reporter: zhoukete@126.com
> >         Regression: No
> >
> > Created attachment 301539
> >   --> https://bugzilla.kernel.org/attachment.cgi?id=301539&action=edit
> > stack
> >
> > 1. cannot login with ssh, system hanged and cannot do anything
> > 2. dmesg report 'audit: audit_backlog=41349 > audit_backlog_limit=8192'
> > 3. I send sysrq-crash and get vmcore file , I dont know how to reproduce it.
> >
> > Follwing is my analysis from vmcore:
> >
> > The reason why tty cannot login is pid 2021571 hold the acct_process mutex, and
> > 2021571 cannot release mutex because it is wait for xlog release space. See the
> > stac info in the attachment of stack.txt
> >
> > So I try to figure out what happened to xlog
> >
> > crash> struct xfs_ail.ail_target_prev,ail_targe,ail_head 0xffff00ff884f1000
> >   ail_target_prev = 0xe9200058600
> >   ail_target = 0xe9200058600
> >   ail_head = {
> >     next = 0xffff0340999a0a80,
> >     prev = 0xffff020013c66b40
> >   }
> >
> > there are 112 log item in ail list
> > crash> list 0xffff0340999a0a80 | wc -l
> > 112
> >
> > 79 item of them are xlog_inode_item
> > 30 item of them are xlog_buf_item
> >
> > crash> xfs_log_item.li_flags,li_lsn 0xffff0340999a0a80 -x
> >   li_flags = 0x1
> >   li_lsn = 0xe910005cc00 ===> first item lsn
> >
> > crash> xfs_log_item.li_flags,li_lsn ffff020013c66b40 -x
> >   li_flags = 0x1
> >   li_lsn = 0xe9200058600 ===> last item lsn
> >
> > crash>xfs_log_item.li_buf 0xffff0340999a0a80
> >  li_buf = 0xffff0200125b7180
> >
> > crash> xfs_buf.b_flags 0xffff0200125b7180 -x
> >  b_flags = 0x110032  (XBF_WRITE|XBF_ASYNC|XBF_DONE|_XBF_INODES|_XBF_PAGES)
> >
> > crash> xfs_buf.b_state 0xffff0200125b7180 -x
> >   b_state = 0x2 (XFS_BSTATE_IN_FLIGHT)
> >
> > crash> xfs_buf.b_last_error,b_retries,b_first_retry_time 0xffff0200125b7180 -x
> >   b_last_error = 0x0
> >   b_retries = 0x0
> >   b_first_retry_time = 0x0
> >
> > The buf flags show the io had been done(XBF_DONE is set).
> > When I review the code xfs_buf_ioend, if XBF_DONE is set, xfs_buf_inode_iodone
> > will be called and it will remove the log item from ail list, then release the
> > xlog space by moving the tail_lsn.
> >
> > But now this item is still in the ail list, and the b_last_error = 0, XBF_WRITE
> > is set.
> >
> > xfs buf log item is the same as the inode log item.
> >
> > crash> list -s xfs_log_item.li_buf 0xffff0340999a0a80
> > ffff033f8d7c9de8
> >   li_buf = 0x0
> > crash> xfs_buf_log_item.bli_buf  ffff033f8d7c9de8
> >   bli_buf = 0xffff0200125b4a80
> > crash> xfs_buf.b_flags 0xffff0200125b4a80 -x
> >   b_flags = 0x100032 (XBF_WRITE|XBF_ASYNC|XBF_DONE|_XBF_PAGES)
> >
> > I think it is impossible that (XBF_DONE is set & b_last_error = 0) and the item
> > still in the ail.
> >
> > Is my analysis correct?

I don't think so.
I think this buffer write is in-flight.

> > Why xlog space cannot release space?

Not sure if space cannot be released or just takes a lot of time.
There are several AIL/CIL improvements in upstream kernel and
none of them are going to land in 5.10.y.

The reported kernel version 5.10.38 has almost no upstream fixes
at all, but I don't think that any of the fixes in 5.10.y are relevant for
this case anyway.

If this hang happens often with your workload, I suggest using
a newer kernel and/or formatting xfs with a larger log to meet
the demands of your workload.

Thanks,
Amir.
