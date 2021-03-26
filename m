Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7D72C433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 04:06:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 890A061A42
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 04:06:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbhCZEGF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 Mar 2021 00:06:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbhCZEFh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Mar 2021 00:05:37 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22DEBC06174A;
        Thu, 25 Mar 2021 21:05:37 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id x26so4057841pfn.0;
        Thu, 25 Mar 2021 21:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=Y10Oef8LBbuVvlB62XaRhXH3K99dIgRzeWySW/bPFRQ=;
        b=BKgOiY/Vjgbm73jlCqkvJAjMjYM/GhaEqw9nlYwUWQeA82nkv5V4PPnlbYWEfLnah4
         pbfUG9K03maA3nUCt3JT0Nf66ib8BiTvAI7NPg6HSdgvhD80v9QgxepF4zMxqwW0gKmF
         0qOu7Pkt2ghtSbM0scrcvDCulZC45uhjngAezvLjOeGbKfw0DQqs1Vc+9WCHQ0WfdHUL
         0XMbT7exnwRlp6DNKQWvO9AsR6ENU6l8yDKGKoErhnuPFAXRVd9PWsIgM8CpEPQyLgLA
         6KhOKSN277z5eXB5cPDsrByJ0BrO9ELnHOyw8yZsAwaMQ5Ax/dNdrA0CWcAx04jJUZAy
         ic2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=Y10Oef8LBbuVvlB62XaRhXH3K99dIgRzeWySW/bPFRQ=;
        b=EgI5eW1kGQFz3+z4p8yBwShoVsBCboJfbmml2JWdh6yHCxDuw/HcLknASMwlqghJV+
         IxwPmAuyvwmKqeJtKPqx/5aYdwsVxuXh2A36rRe4+dksc5fZWVuPOBZQ6YsWIMPjidYv
         lP1rXgTBnziDGZtiNAxdWfvxQN6mkflif9F0K0TXA27hddirURuNkcyfNwV1ZGSRhoW/
         E0kwjkKMX4oUpkJ64G1J7fM31Rp6v5IHtuQZDfZlM/9t0KdLvcjDrR3EBEZT9kQwkckC
         8VcpvjkpCKte/PQPC/INFbXTnA6vTtoz7C6b5zJtfPSvZzKTVTADkmlXLxkAD5YwmtZN
         5MCg==
X-Gm-Message-State: AOAM531BVhCf8LVzqbsao2KYookuVzlrMg0zqlZpwZjXwOZU6EzZENv2
        qlxW/wjpxKdYvVnicJN0zBQjWuFtJqM=
X-Google-Smtp-Source: ABdhPJwZWyu/5qZe6MQvcExnj84ZEGtUPsEHqfs7ggjPTi2JWGhlTckTMzfdydrg4cLPcxYAWyHJDA==
X-Received: by 2002:a63:5a50:: with SMTP id k16mr10343344pgm.155.1616731536362;
        Thu, 25 Mar 2021 21:05:36 -0700 (PDT)
Received: from garuda ([122.179.126.69])
        by smtp.gmail.com with ESMTPSA id g4sm7375034pgu.46.2021.03.25.21.05.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 25 Mar 2021 21:05:36 -0700 (PDT)
References: <20210309050124.23797-1-chandanrlinux@gmail.com> <20210309050124.23797-14-chandanrlinux@gmail.com> <20210322185413.GH1670408@magnolia> <877dlyqw0k.fsf@garuda>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V6 13/13] xfs: Stress test with bmap_alloc_minlen_extent error tag enabled
In-reply-to: <877dlyqw0k.fsf@garuda>
Date:   Fri, 26 Mar 2021 09:35:33 +0530
Message-ID: <8735wir242.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 23 Mar 2021 at 10:58, Chandan Babu R wrote:
> On 23 Mar 2021 at 00:24, Darrick J. Wong wrote:
>> On Tue, Mar 09, 2021 at 10:31:24AM +0530, Chandan Babu R wrote:
>>> This commit adds a stress test that executes fsstress with
>>> bmap_alloc_minlen_extent error tag enabled.
>>
>> Continuing along the theme of watching the magic smoke come out when dir
>> block size > fs block size, I also observed the following assertion when
>> running this test:

Apart from "xfs_dir2_shrink_inode only calls xfs_bunmapi once" bug, I
noticed that scrub has detected metadata inconsistency,

FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 debian-guest 5.12.0-rc4-chandan #30 SMP Thu Mar 25 11:00:08 IST 2021
MKFS_OPTIONS  -- -f -b size=1k -m rmapbt=0,reflink=0 -n size=64k /dev/vdc2
MOUNT_OPTIONS -- /dev/vdc2 /mnt/scratch

xfs/538 43s ... _check_xfs_filesystem: filesystem on /dev/vdc2 failed scrub
(see /root/repos/xfstests-dev/results//xfs/538.full for details)

Ran: xfs/538
Failures: xfs/538
Failed 1 of 1 tests

I will work on fixing this one as well.

-- 
chandan
