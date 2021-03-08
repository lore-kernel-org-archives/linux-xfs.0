Return-Path: <SRS0=7MVS=IG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC4C1C433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 08:35:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F20C650F3
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 08:35:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbhCHIfF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 03:35:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231408AbhCHIev (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Mar 2021 03:34:51 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 105F1C06174A
        for <linux-xfs@vger.kernel.org>; Mon,  8 Mar 2021 00:34:51 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id p5so4524423plo.4
        for <linux-xfs@vger.kernel.org>; Mon, 08 Mar 2021 00:34:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=M6CV3L5vNJTA1mlKLhnpRoxvlqydfHvbc3gM6PkV4G0=;
        b=prJjpbDOZM8IzXzqpSEKil9XLD8Y5yq16wBukTtRwS5KtP7h8hvXnm2v5v8gJcGpiK
         xmPScoBcsq3wE4LIWGGseEcCuNhEs8V3SmlnBPCUYMjxqT9/1je0AntNmqaTBqUrHpOf
         h/u2cBgTklvBbWrqWE67e6D/H7OVdC0PZ5dv9tZ2sm4YHXkSAuHXTtOImxtD7VheDMvX
         SCZQZZG1IP0XyDtSpHDOUZh873cZwlYHpIQgRSiytc4zjvQRuDppKnrKSM8GnxNjr3cu
         zYQfkcG7/s96DUlwfwMnQOAXDIYbjVWcgprK9/Br89inBC+Zlwrg6hnBqq4HHAE3936+
         JW8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=M6CV3L5vNJTA1mlKLhnpRoxvlqydfHvbc3gM6PkV4G0=;
        b=p9DMG2fQsMqDYzaVDbJ++l9tEpD9gIqJxLpaC63ZjRsiPEz5xlwcTAoXn0i3fTRg6Y
         8AK0+M1WrUuHYquHgRQwsLEftPPkCI7R17kYCA7D16OYWD5LG3ghQh7tyDx384wr7N4h
         arRaMUFc0meH3eE9nxfLOkglvrWk6TJbZxg/6z6TePqpumCCWZyyNAUXF8MAczZJga3R
         z+dT8q3MMkBOvogUsZuWD+iM2D+L1GF+jzO32V2OSKVidDj0DDFRcURb7U5CBPm2d4gX
         7L14sPeXci8ZfBD3aHRHg1fPe5IE+9uCmtCPtXQ+ytJviNQTUoBfptdeq152/LKieRH0
         47OA==
X-Gm-Message-State: AOAM533u905R+BInFaxCikQKTtXmNUSiADtzZZ4BasoMPvZcGK+jFlUm
        ThOcA/kj4u2PU99FWIqc2jclfdde53U=
X-Google-Smtp-Source: ABdhPJxDKrPHWrJ5pl+ENZonrhiLPsXBRBBfOzOJ0xuTuQxF7JU2GTGu1aP1Ui3n3EKry82D43nA5Q==
X-Received: by 2002:a17:90a:5510:: with SMTP id b16mr23806901pji.87.1615192490415;
        Mon, 08 Mar 2021 00:34:50 -0800 (PST)
Received: from garuda ([122.167.156.41])
        by smtp.gmail.com with ESMTPSA id b3sm10493106pjg.41.2021.03.08.00.34.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Mar 2021 00:34:49 -0800 (PST)
References: <20210305051143.182133-1-david@fromorbit.com> <20210305051143.182133-4-david@fromorbit.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/45] xfs: separate CIL commit record IO
In-reply-to: <20210305051143.182133-4-david@fromorbit.com>
Date:   Mon, 08 Mar 2021 14:04:47 +0530
Message-ID: <87h7lm3uxk.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 05 Mar 2021 at 10:41, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> To allow for iclog IO device cache flush behaviour to be optimised,
> we first need to separate out the commit record iclog IO from the
> rest of the checkpoint so we can wait for the checkpoint IO to
> complete before we issue the commit record.
>
> This separation is only necessary if the commit record is being
> written into a different iclog to the start of the checkpoint as the
> upcoming cache flushing changes requires completion ordering against
> the other iclogs submitted by the checkpoint.
>
> If the entire checkpoint and commit is in the one iclog, then they
> are both covered by the one set of cache flush primitives on the
> iclog and hence there is no need to separate them for ordering.
>
> Otherwise, we need to wait for all the previous iclogs to complete
> so they are ordered correctly and made stable by the REQ_PREFLUSH
> that the commit record iclog IO issues. This guarantees that if a
> reader sees the commit record in the journal, they will also see the
> entire checkpoint that commit record closes off.
>
> This also provides the guarantee that when the commit record IO
> completes, we can safely unpin all the log items in the checkpoint
> so they can be written back because the entire checkpoint is stable
> in the journal.
>

I see that xlog_state_clean_iclog() wakes up tasks waiting on
iclog->ic_force_wait and that xlog_state_clean_iclog() itself is invoked after
the corresponding iclog is written to disk and the log vectors are moved to
AIL. Hence using iclog->ic_force_wait to wait for previous iclogs to complete
I/O ensures that the commit record iclog is written to disk only after the
previous iclogs have already been written.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

--
chandan
