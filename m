Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52CA6C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 08:58:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E77C61A0A
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 08:58:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbhCYI6Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 04:58:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbhCYI56 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 04:57:58 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31AE7C06174A;
        Thu, 25 Mar 2021 01:57:58 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id h25so1131369pgm.3;
        Thu, 25 Mar 2021 01:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=lRCatidXWEtdBF+VqjiHqmNTjbdAzWdEfhAUSAtoMYk=;
        b=dgPhEoMbyLFjXMCoLZaeZouoG1lNQRVtTWznm91wC8WZ6yNxzNKx00E9xHrADYMX9g
         yuNA2jfJ+oNTBiVGCy6KF9//r6B1+2Nq5Jg5JVix7PmOluIJ2qfI9G04S9TZOuC0z0e4
         lWvsukXREj2zMehWyAsvRG2L7D5dn26u6yi5P+brQkTpBVlNqaT1J+c64nJTlBFc6O34
         3kPohQs0IoLVNGyxxhlETbYp16eBYhXwu4CTSb8aMbrzPuObPZoXJxGRf2L+6FcsKgQ+
         AB8dBVB0N924GEou3+6ecW23OczozBwhxu1pCRWciWvUMvbDYWlkuykT4g8gjbEPfyKH
         mecA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=lRCatidXWEtdBF+VqjiHqmNTjbdAzWdEfhAUSAtoMYk=;
        b=E1bE2UBAukDQv+OyElw6f+vWElgMuxeG/9uxFDIA1BQBGaFoNt2qvuK6Ine9i1crnC
         9UHCenHvtHx8PwT5WAtGYYLB6Lq/q9VjFeWWZvVmWmeKICbYG9u3tOp3vPZJA9l1uq3L
         CP9p8HJCGQFMb+iav9LSpxLCaRzhccCdUEA6HCofDYi6BqfYMfMMO403eu0MgYlM8fpH
         EDrFtMfTgbMbNijsBWILOndmnEUNUiL/4fx4mQv/GoOWjhB43OpOxdr5WSKizNxAtHVg
         4/j3/ywWfSY42iXatyZ0mYwN6i/ddI3vuE4qwHCg3fGx4eyTEghCfn13iCzC3m7nzTF9
         IlBA==
X-Gm-Message-State: AOAM5333uhv9WVSYxbEZHOdV3eBDn20P4marIQS922F69lSPREE6SnKu
        mjAkODpKJOC/OKgYgqymk8Y=
X-Google-Smtp-Source: ABdhPJzJXObL56FbLhqDjZGsLHh1HKHHePllQTSOnbqRDPtzP7aj1QPCr4TxDzbWD7jV74BbbxNhJg==
X-Received: by 2002:a63:3ecb:: with SMTP id l194mr6732628pga.146.1616662677737;
        Thu, 25 Mar 2021 01:57:57 -0700 (PDT)
Received: from garuda ([122.171.175.121])
        by smtp.gmail.com with ESMTPSA id a20sm5280317pfl.97.2021.03.25.01.57.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 25 Mar 2021 01:57:57 -0700 (PDT)
References: <161647320063.3430465.17720673716578854275.stgit@magnolia> <161647320615.3430465.16963127280244500558.stgit@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/3] xfs: test rtalloc alignment and math errors
In-reply-to: <161647320615.3430465.16963127280244500558.stgit@magnolia>
Date:   Thu, 25 Mar 2021 14:27:54 +0530
Message-ID: <87o8f7objh.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 23 Mar 2021 at 09:50, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Add a couple of regression tests for "xfs: make sure the rt allocator
> doesn't run off the end" and "xfs: ensure that fpunch, fcollapse, and
> finsert operations are aligned to rt extent size".

The changes look good to me,

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

-- 
chandan
