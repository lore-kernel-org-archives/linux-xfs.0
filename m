Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E82D0C4332F
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Nov 2023 20:59:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234426AbjKBU7H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Nov 2023 16:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234346AbjKBU7G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Nov 2023 16:59:06 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06AFC1A1
        for <linux-xfs@vger.kernel.org>; Thu,  2 Nov 2023 13:59:04 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id 5614622812f47-3b3ec45d6e9so834055b6e.0
        for <linux-xfs@vger.kernel.org>; Thu, 02 Nov 2023 13:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1698958743; x=1699563543; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EMCv8L4qDlN17fz0fyUUYQhnRH3sTmgA6VjM0RpJ4FY=;
        b=hTkAQgQbz9DtG31FrBiCVlDwps5xModUrgs6n87j1TU5UvzFJDHQ6FV+g4fmk0EfPk
         Rghz+1KHcetwAWHSWJLPm1sP6wxtEFSAN3cK5aXMRFttBGwHKAXgJPmK3ScKBGxhYhTk
         1pbOuHjrY3xKLZdgS0H8B2i3SiYuy4g8Dr/cvcsEDewmbX8iXtxuRPI/tBK7au3O7ZoR
         6e4S7iOZb4Er7SZnN4Qw9dGO6QTEpx0Yc6vz9gKFVFMLoB9ue468xxW75s4WN17EbnNl
         ZUI9OeW9Kqqz8kRzMy6VLaCbNsc8HMsxTo/tT3p8nrZMlKLth3gpt2KtxBMtLcG/K3Tp
         D6uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698958743; x=1699563543;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EMCv8L4qDlN17fz0fyUUYQhnRH3sTmgA6VjM0RpJ4FY=;
        b=j8QTLtQWYFdpD/fPujzMbyoI7nxLHmbEzYRRFPJy1xepbPFQFy72N/FalOX0jM9nPW
         kbYF50quodQlr+Cg3EWKUlkyitGHj6BpjXl83DXqBjxWb7afpT5n1WhkqhKH+baAaCUk
         3FpGOrVZV2qYjtfWogNA/WjPF2s0U4eNzULYrdErN+rbWF2YjDpYkxtph9gAhplRCxFR
         tWLPZ8viIFKKHpr0LpkFEgAs++bTE54oe9qSMNwVgbCw2IaVzSu6uqXbjQljvEWzUIIq
         nYKPRGULu60j5cHEYgOSga+/4vzwCUcK6jUk9aplXvugjuPGbiKxo9NVtDkhlBeLAb4U
         X6Mw==
X-Gm-Message-State: AOJu0Yy8J8G6lToWs8ouAxoz9s6OzhExxKpn7apCXTjeOVVsO+Q211In
        /g1IjOhXXUvuz+KDGSqHicD4pTDcJ5Hp9a7nFfM=
X-Google-Smtp-Source: AGHT+IEUZPial5uu1P9GkpLmq3NygFLDKSz8/Hdppiw3y8z/6R4NNGha/yvBAER/hq3Xc4GBgRzh/A==
X-Received: by 2002:a05:6358:3403:b0:16b:2f05:7fb8 with SMTP id h3-20020a056358340300b0016b2f057fb8mr2810218rwd.2.1698958743212;
        Thu, 02 Nov 2023 13:59:03 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id z1-20020a63c041000000b0056606274e54sm159630pgi.31.2023.11.02.13.59.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Nov 2023 13:59:02 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qyemJ-007O6a-0D;
        Fri, 03 Nov 2023 07:58:59 +1100
Date:   Fri, 3 Nov 2023 07:58:59 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     bugzilla-daemon@kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [Bug 217572] Initial blocked tasks causing deterioration over
 hours until (nearly) complete system lockup and data loss with PostgreSQL 13
Message-ID: <ZUQNkyqAXdi8MQa4@dread.disaster.area>
References: <bug-217572-201763@https.bugzilla.kernel.org/>
 <bug-217572-201763-LUmZsDeuuk@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-217572-201763-LUmZsDeuuk@https.bugzilla.kernel.org/>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 02, 2023 at 03:27:58PM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=217572
> 
> --- Comment #18 from Christian Theune (ct@flyingcircus.io) ---
> We've updated a while ago and our fleet is not seeing improved results. They've
> actually seemed to have gotten worse according to the number of alerts we've
> seen. 

This is still an unreproducable, unfixed bug in upstream kernels.
There is no known reproducer, so actually triggering it and hence
performing RCA is extremely difficult at this point in time. We don't
really even know what workload triggers it.

> We've had a multitude of crashes in the last weeks with the following
> statistics:
> 
> 6.1.31 - 2 affected machines
> 6.1.35 - 1 affected machine
> 6.1.37 - 1 affected machine
> 6.1.51 - 5 affected machines
> 6.1.55 - 2 affected machines
> 6.1.57 - 2 affected machines

Do these machines have ECC memory?

> Here's the more detailed behaviour of one of the machines with 6.1.57.
> 
> $ uptime
>  16:10:23  up 13 days 19:00,  1 user,  load average: 3.21, 1.24, 0.57

Yeah, that's the problem - such a rare, one off issue that we don't
really even know where to begin looking. :(

Given you seem to have a workload that occasionally triggers it,
could you try to craft a reproducer workload that does stuff similar
to your production workload and see if you can find out something
that makes this easier to trigger?

> $ uname -a
> Linux ts00 6.1.57 #1-NixOS SMP PREEMPT_DYNAMIC Tue Oct 10 20:00:46 UTC 2023
> x86_64 GNU/Linux
> 
> And here' the stall:
....
> [654042.645101]  <TASK>
> [654042.645353]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
> [654042.645956]  ? xas_descend+0x22/0x90
> [654042.646366]  xas_load+0x30/0x40
> [654042.646738]  filemap_get_read_batch+0x16e/0x250
> [654042.647253]  filemap_get_pages+0xa9/0x630
> [654042.647714]  filemap_read+0xd2/0x340
> [654042.648124]  ? __mod_memcg_lruvec_state+0x6e/0xd0
> [654042.648670]  xfs_file_buffered_read+0x4f/0xd0 [xfs]

This implies you are using memcg to constrain memory footprint of
the applications? Are these workloads running in memcgs that
experience random memcg OOM conditions? Or maybe the failure
correlates with global OOM conditions triggering memcg reclaim?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
