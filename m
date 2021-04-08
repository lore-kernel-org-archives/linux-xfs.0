Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D45D8C433B4
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Apr 2021 07:39:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F8466113A
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Apr 2021 07:39:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbhDHHjk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Apr 2021 03:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbhDHHjk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Apr 2021 03:39:40 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 954E9C061760
        for <linux-xfs@vger.kernel.org>; Thu,  8 Apr 2021 00:39:29 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id t22so249021ply.1
        for <linux-xfs@vger.kernel.org>; Thu, 08 Apr 2021 00:39:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=IJDjb47b9EkmpGHlFAlqfqxKlareYLYv4eT9TRR42uA=;
        b=Di+wNaWu/UqFsa1SomPSOdXxpMYv0H9GVTHR4qPIo4SVhtqYREkbm3tYYVda9mPuOw
         TQ7SFxGb4MWeYftYywNcnj9Vo578FeoxmfLcx+5CjA71TdtJ42z1NJM+JfDYmYdOCEpM
         OJQo8IJHH2fT8CyDTxIlLFz/n8y6PQ6fCjdFNM7MsB3SFJekZWRpYMR0lNi5KgmKxdSU
         SzoCPxmG6EmsZJKoRKixkGJa08Wj4q5ZPzSZsMTTL7WPHhpSRKWWDDyiVjMDTOZtVs4y
         yRQkvB9I05TsQOmmPBF63dtkOeOtxi+Ldej6OnZQGR367iOe8S0pWEb9iIcAwrN5diO1
         dB9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=IJDjb47b9EkmpGHlFAlqfqxKlareYLYv4eT9TRR42uA=;
        b=bER+v++gNV1Fs0ijOvadTwjxWQeiCJuGKwFEK1tNfbHnuhD7Xz0tQW1OuCajqrCm8Z
         tiNWW7hNF+tHys88a0X5yMjHSn0VqnxO/brNuULXjDTDBOf02vqcAhyULoQ2NHCEQvT0
         /4jD9ZqiL3/SefBu47q+YYkn6sF1VeNLThvssDcNUh29nwairpxIImrbHhoHoiuayBGQ
         un/wgrsZUluCxFeXeYEPdz0diB0KBA+1dOzTK5FbJaNIEqDccFeBtPzlAyv/NKXNHUCF
         xQ/WdS7Ucn7PTfDI0V8Xc07wAGjHQlUkwaXWtU+UZkbJIsTQ0Qe6psxWvnNoQyhdK32k
         HyzQ==
X-Gm-Message-State: AOAM533OPtMjmhz6uNdobA8iaVjDRVONveXoVFZaRKq+Xz5q9A6fRiC1
        fFoFd0nKVh+MZYkOmgrSvkAxPh5n8s0=
X-Google-Smtp-Source: ABdhPJznk1KH9gB0lkdR3wySkXXMDxkVqZ3N/k6j26BI6eTVAM3NEvGWq1D7vytQPhKjRkAp2Jna/g==
X-Received: by 2002:a17:90a:7182:: with SMTP id i2mr6974333pjk.111.1617867569005;
        Thu, 08 Apr 2021 00:39:29 -0700 (PDT)
Received: from garuda ([122.179.88.135])
        by smtp.gmail.com with ESMTPSA id q14sm24724321pgt.54.2021.04.08.00.39.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 08 Apr 2021 00:39:28 -0700 (PDT)
References: <20210408005636.GS3957620@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix scrub and remount-ro protection when running scrub
In-reply-to: <20210408005636.GS3957620@magnolia>
Date:   Thu, 08 Apr 2021 13:09:25 +0530
Message-ID: <877dldgr82.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 08 Apr 2021 at 06:26, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> While running a new fstest that races a readonly remount with scrub
> running in repair mode, I observed the kernel tripping over debugging
> assertions in the log quiesce code that were checking that the CIL was
> empty.  When the sysadmin runs scrub in repair mode, the scrub code
> allocates real transactions (with reservations) to change things, but
> doesn't increment the superblock writers count to block a readonly
> remount attempt while it is running.
>
> We don't require the userspace caller to have a writable file descriptor
> to run repairs, so we have to call mnt_want_write_file to obtain freeze
> protection and increment the writers count.  It's ok to remove the call
> to sb_start_write for the dry-run case because commit 8321ddb2fa29
> removed the behavior where scrub and fsfreeze fight over the buffer LRU.

I see that, during remount process, sb_prepare_remount_readonly() depends on
the value of mnt_get_writers() to determine if it has to abort remount.

However, sb_start_write() (used by xfs_scrub_metadata()) will only obtain the
semaphore at sb->s_writers.rw_sem[1]. Hence a task running scrub in repair
mode would not be able prevent another task from remounting the filesystem
into a read-only state.

mnt_want_write_file() is the right fix since it increments the mnt writer
count and also prevents the filesystem from getting frozen.

Hence,

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

-- 
chandan
