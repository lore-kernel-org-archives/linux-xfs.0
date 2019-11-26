Return-Path: <SRS0=SRpQ=ZS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F16EC432C0
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Nov 2019 20:13:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F0A92080F
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Nov 2019 20:13:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="ILaUve1i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbfKZUNj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Nov 2019 15:13:39 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33464 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfKZUNj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Nov 2019 15:13:39 -0500
Received: by mail-pg1-f193.google.com with SMTP id 6so5009947pgk.0
        for <linux-xfs@vger.kernel.org>; Tue, 26 Nov 2019 12:13:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HuzTARrtR40oXnATNDYzRR3IF9EPlV+rc5qVdXIyaQM=;
        b=ILaUve1i2GNtY6VkxK1xclR5VJBHNrSR+OkDNoDBB9U43pjLXTRUdTLpe+FTX3uAgb
         xtzd9vj+cZPtcJMoTMOwfHVz/srChrvMgWsXhdqgBpIsCNEqxmLDQVQWPMI0nQSDwTFs
         Sdc+CeLIymrWFtff6xIfPY+BpDGlNs5l44VDoG3WgtcpvPZlzm0AmBTY9TRQsXZjB/dY
         OLM3xfZx3iz4yIBXy6q4MHrtM4vfF7IAUm3jFpWHHtyMb+wlPUL7do0MWuMyE+7Zrmu6
         0RSO+PdqYgX25EEah9kP1MJ9MBOlTuXT4fWGh4dTh8BB4pSQpefwPNA7+v4F1kfxrSdY
         6iHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HuzTARrtR40oXnATNDYzRR3IF9EPlV+rc5qVdXIyaQM=;
        b=L/BvszYvPl+KhEW6fXJs8aGcawnj9IQLy1oEjQmDAMyFSaSjmtzoqbLoAKQa5luwzh
         f9LktYNQCq22nlcclE5f0sb7qnSpT4XIASEwX4t/h6jQdgR9IGXohU7NcPhdbMvPkWpB
         TxOBwFRJDkGBy+xTMsOuO23bkhEtfkwMngmILSpo7QEgaDvLVpfmBmGnSLHFvOT/Ibin
         OE87K6vlKu0I9L/aAeyOfSfoqjF59v3e9gw5Haeok6UhLG640VOuk4vTix+oZIl6yCWp
         thczIpwb1R/4PJQodfvWIYs7Tu4RltpqULjniG0maDOR+KwOZ2Z2Psp/ITdnoMOMzhb3
         ffuQ==
X-Gm-Message-State: APjAAAXR8MufcBI3EiAUFaDrv8BKcDdq0QfvHIAfLWQxKX5ESxjO3B9K
        08B06UJR7UCceia7836k14TTl1b842C5Kw==
X-Google-Smtp-Source: APXvYqxLVyqBVA33k2IV0GqaRdpiJslZtRvcJWp3yzH0Sf/tpYVIL4urIX2fy2CJs3AxUanv3OFtZw==
X-Received: by 2002:a63:68c3:: with SMTP id d186mr251262pgc.301.1574799218357;
        Tue, 26 Nov 2019 12:13:38 -0800 (PST)
Received: from vader.thefacebook.com ([2620:10d:c090:180::30de])
        by smtp.gmail.com with ESMTPSA id p123sm13802327pfg.30.2019.11.26.12.13.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 12:13:37 -0800 (PST)
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-xfs@vger.kernel.org
Cc:     kernel-team@fb.com
Subject: [PATCH 0/2] xfs: fixes for realtime file truncation
Date:   Tue, 26 Nov 2019 12:13:27 -0800
Message-Id: <cover.1574799066.git.osandov@fb.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

Hello,

These two patches fix bugs in a corner case of truncating realtime
files. We encountered this as a soft lockup in production while
truncating certain files, but I found the space leak on further
investigation. The lockup is caused by an interaction between the two
bugs fixed by these patches. I've also sent a reproducer for xfstests.

These patches are based on v5.4. Thanks!

Omar Sandoval (2):
  xfs: fix realtime file data space leak
  xfs: don't check for AG deadlock for realtime files in bunmapi

 fs/xfs/libxfs/xfs_bmap.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

-- 
2.24.0

