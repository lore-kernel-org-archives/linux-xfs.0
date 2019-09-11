Return-Path: <SRS0=7YMi=XG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CECDDC49ED6
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Sep 2019 13:13:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1611206A5
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Sep 2019 13:13:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ee7sc/sQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728076AbfIKNNd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Sep 2019 09:13:33 -0400
Received: from mail-pf1-f171.google.com ([209.85.210.171]:44740 "EHLO
        mail-pf1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727302AbfIKNNd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Sep 2019 09:13:33 -0400
Received: by mail-pf1-f171.google.com with SMTP id q21so13633413pfn.11;
        Wed, 11 Sep 2019 06:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=8EAp/cmVBJI5gxV1bwRmKCl916kU2WZYKxk189KJy8Y=;
        b=Ee7sc/sQY2LNTVs2aWUSefzCip590OlWxxT4y2Mau57xLXAuczA9QRaxYEeo4Ts2rx
         tLXc77p+1ZytafzEAVxbv3bBSTcK3esbO3xVL/Bdq6n+fk1pAijjkAqB6Z3vMpa9uLdi
         LwI28Wzmm/IuX2Iy9Z7a+tH0TChNkEE9L/2HXW272oQ8tT4CBoLSjDCVqKJLUxbPGQBk
         EicSzpy3FVRc95rv8YIfAFvdk46jAdaFjrYwwu1YdUrwTBXi7Or5622oP4eJVADmxap7
         dS7nl4bzPEaW362jiVIMPbnJb37itL2jmznWr29d4WCw7IGouYGxZoZQpCh6JCthdfDJ
         JQuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=8EAp/cmVBJI5gxV1bwRmKCl916kU2WZYKxk189KJy8Y=;
        b=XHGb8nkCMq15BiOcoqU8ifEler22Gavd1A7j6ZYQoBjWFHX4UgYUb1RTfpaNc0LmhW
         7b+3O7ZABK9uyjKijoztwTYg3V3MwSeHnSXcEqlWpas7Tgd6+rnhy6VOOO6KAQTlHuf7
         coaRzkW1zR8UOsHw30gwQM2nImIX4+/Ex4pc0gV6zWlGTALTWSqCwUboAGixrcwvkty7
         u+Q7engTxWYEcjnSQ0AVvqLtCqI4JIkSzPZtATIPQ8KCALyD2ut0u2od9eLGZLb4adh8
         WeFXhHhLuB8/AYg2M7dqNm5pDF0i3VZGu18Kj6R6TK/E2a1LT6wowMY14JYie1B1gWti
         WCHQ==
X-Gm-Message-State: APjAAAUQOX8csn09qetKwaUEO23RKQEjb7aqjBVYhfSSK+RAumnQmYJs
        Dyei8+1Tw1WQLeljcsA8lA==
X-Google-Smtp-Source: APXvYqykjS4eiX/26OJ9Pzzg2kQSfrQSd1Y8B0JoLWhpWGWA5blkRxa/JuM3R1CEbwiaG/orADHYkg==
X-Received: by 2002:a17:90a:e292:: with SMTP id d18mr5586940pjz.100.1568207612359;
        Wed, 11 Sep 2019 06:13:32 -0700 (PDT)
Received: from [10.76.90.34] ([203.205.141.123])
        by smtp.gmail.com with ESMTPSA id x12sm25059483pff.49.2019.09.11.06.13.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Sep 2019 06:13:31 -0700 (PDT)
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, Eryu Guan <guaneryu@gmail.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>, newtongao@tencent.com,
        jasperwang@tencent.com
From:   kaixuxia <xiakaixu1987@gmail.com>
Subject: [PATCH 0/2] xfstests: add deadlock between the AGI and AGF with
 RENAME_WHITEOUT test
Message-ID: <d33e4af0-2c81-fcf1-3410-6d5c5fe26eab@gmail.com>
Date:   Wed, 11 Sep 2019 21:13:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

There is ABBA deadlock bug between the AGI and AGF when performing
rename() with RENAME_WHITEOUT flag, so add test to check that whether
the rename() call works well. This test require a special rename flag,
so add support check for if a given rename flag is supported in
_requires_renameat2.

kaixuxia (2):
  common: check if a given rename flag is supported in
    _requires_renameat2
  xfs: test the deadlock between the AGI and AGF with RENAME_WHITEOUT

 common/renameat2  | 41 +++++++++++++++++++++--
 tests/generic/024 | 13 ++------
 tests/generic/025 | 13 ++------
 tests/generic/078 | 13 ++------
 tests/xfs/512     | 99 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/512.out |  2 ++
 tests/xfs/group   |  1 +
 7 files changed, 150 insertions(+), 32 deletions(-)
 create mode 100755 tests/xfs/512
 create mode 100644 tests/xfs/512.out

-- 
1.8.3.1

-- 
kaixuxia
