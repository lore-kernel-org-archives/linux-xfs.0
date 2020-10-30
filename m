Return-Path: <SRS0=YpFG=EF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91B9DC4741F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Oct 2020 11:37:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AEB92054F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Oct 2020 11:37:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lf8p/BEQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgJ3LhQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Oct 2020 07:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726612AbgJ3Lgm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Oct 2020 07:36:42 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 291B7C0613D4;
        Fri, 30 Oct 2020 04:36:42 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id k1so6174317ilc.10;
        Fri, 30 Oct 2020 04:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=Ew4StMpVo5ez/gEFLEgiv2+lcmSuiaGgtLUtTDkvJwo=;
        b=Lf8p/BEQUhthouU+btyK82bWtOqlH6j+tun8LQ2ImKsTkxUHsHb5+GN+hxt72GN9fe
         fmQMgtAeAwqWNXH+W3cJxBIFAHF27J17AQpdWKKdeh1RjkCObSktx8sV/JYv98cfl4ZI
         YMnjtZQLg9TFYrgCjS9ErR0O0HSI4Ns8WUUcz/fDV/XU8C2UZNCGo1CCS8KaW9UubxON
         dqL8IE71wUvGVQefVF1LQ5fxVDZo68cpE2kRUON9aSVULMXeY/pYeqCFjmq2NfCGiE3w
         vip2Hifunp9agDufsEnquFjeFy1L7QEvcaY1Fr4SetVaVYYT0/d0nhaGwfuw7t0LbIdw
         7zFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=Ew4StMpVo5ez/gEFLEgiv2+lcmSuiaGgtLUtTDkvJwo=;
        b=T7sxqYriwqhG4ymZT+jYDqdU9p1lz0cGefmmWt5y6tS70ZPxeGZ74bDKxtQu0oNxbM
         abjR4C03GCkhGGki8aRAcN6a0hntzo7d4flHyQOVTtxfaphbcfcF9+7EZUM58RVwmWMY
         FRvIjlyw6zR2uODcy5DM8RE/t0+R1yulqtrDCfF9fEoKLYaq+4CWXIGkorAI3tL68Iby
         2Hqn9EDuEsjlAgTFmjpe383mnIQxGGNMnEbG4TLV7Khd8z1qEvUKqrdwt4+igTMP9RWU
         y0z9GrhxUPmi6as2JMcuacUGUzK8yA0DfO41oaKhCFQMk/s+g1f0PgKHVahuGso4fwPy
         q0DA==
X-Gm-Message-State: AOAM5313KNESrL7FQJAQCBIkAqqHhY2btMCMacYQ4BKXcaDTHpxMSqMs
        hf4biHhcj3m/dpU1Uc4EXQDONYR9Ox4v0GDdiqQ=
X-Google-Smtp-Source: ABdhPJxqH9M8AIb8SmhcdDwUNFZKXLMtHK1hDHZ5JOyAaF0QPeUmS+TCTxpLKzJuKPwyUkiggZXt1qHu7upJZt8uPjg=
X-Received: by 2002:a05:6e02:c1:: with SMTP id r1mr1500489ilq.250.1604057801608;
 Fri, 30 Oct 2020 04:36:41 -0700 (PDT)
MIME-Version: 1.0
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 30 Oct 2020 13:36:30 +0200
Message-ID: <CAOQ4uxjia_L5mzEa=R9221sdO9KrsmvyGyKGcrmYKc47msJ=bg@mail.gmail.com>
Subject: Random xfs_check errors
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>, Eryu Guan <guaneryu@gmail.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi guys,

I've been running the latest xfstests with xfsprogs v5.9 and stable
kernel v5.9.y past week (including v5.9.2 today) and I'm getting
reports like below after random tests.

This one was after generic/466, but already got similar reports
(with more blocks) after generic/511,518,519 on different test runs.

Is anyone else seeing this?
Any advice on what to look for?

Did not get to test v5.10-rc1 yet. I thought I would ask here first
in case it's a known issue.

Sasha, I am wondering which xfsprogs version are you using
when verifying stable kernel patches, because I have just recently
upgraded xfsprogs to v5.9 in my stable test environment.

Thanks,
Amir.


_check_xfs_filesystem: filesystem on
/dev/mapper/0fce4d2d--779b--44e8--91d0--2cb1b252f68e-xfs_scratch is
inconsistent (c)
*** xfs_check output ***
block 0/10 expected type unknown got free1
agf_freeblks 1310702, counted 1310701 in ag 0
agi_freecount 61, counted 58 in ag 0
sb_ifree 61, counted 58
sb_fdblocks 5240288, counted 5240287
sb_fdblocks 5240288, aggregate AGF count 5240287
*** end xfs_check output
