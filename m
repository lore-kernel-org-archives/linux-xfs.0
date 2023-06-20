Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC02CEB64D7
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jun 2023 21:32:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbjFTVcX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Jun 2023 17:32:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbjFTVcW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Jun 2023 17:32:22 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1259E170D
        for <linux-xfs@vger.kernel.org>; Tue, 20 Jun 2023 14:32:22 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id 98e67ed59e1d1-260a4020ebaso1891562a91.2
        for <linux-xfs@vger.kernel.org>; Tue, 20 Jun 2023 14:32:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20221208.gappssmtp.com; s=20221208; t=1687296741; x=1689888741;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EJCUZTc8kL/04TsNhkNObmmWzUcET0YVuG5SvjRUzRk=;
        b=GWJVZmki1KBe2REwmyAAdz81L+6/SgZgpwuyNxAKcFeNVJBe0VpEXtBBcYJ3tefxLj
         UnWkVDPrAUtI3xq0FOgCJvhuWVR1+D1P1aGw++SN/1GX7StjxTjQG2mm1MUPzm7nvjvL
         QxAf4riGMSvlCy/eSIG1DpsoFjJXsm/SjJaqo9LFgoRQRcaFol7yMxT/Dw4N4U3ygMUF
         mXP53T5r8ZP+p6nDi4DtDzUb6tszrQHWqiv4XWh9RlftCpuRp9ZeyxQt/X5cbIBCaDVy
         cTmx6QSbcW8kNNCmTacAm3lDFbcTqmhJvYa3a4rXm2DI3I5v4t8oXrEFpY0nHQyZ5VYj
         LC9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687296741; x=1689888741;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EJCUZTc8kL/04TsNhkNObmmWzUcET0YVuG5SvjRUzRk=;
        b=hfquUYvO3Xz2QqBSH7GJPfiOUhVTteVcn5oyR1boPqIhyQNpefUH+Ym51cI2HvhuxA
         yko7ba1RD1IfJdI3v/tB1Xm1f+UYwvVZuaYpYqXt0SzxwL2J9IbtHuPg43Bn5bw1amK7
         1tygT++ZxhbMoTszVRL5yeMm68vOHbgCKUG6C0ubKZAs2l6T3ovIidimfmnM4/C92O3M
         SDX4tYbSlmDVGcOkx8qIFvP0DLSMs+X5WYI8ZsdCOudY6GKnMi5eGdCcp3MZkPdY5/+b
         E675BMHAm86ECxJRetm4elu/ucHxJNG8rofqxD6sgGdvRGIj+71xaUfKOcs6FFM0WZs9
         t8eA==
X-Gm-Message-State: AC+VfDwWyLTnbAYinwo4Xi4zeLvFth5CaqO8ORHRAI9qZiPaeNp2fay4
        awFingicYj7NZoNE7Ue+jauKDz1F4vDAhxJc6PY=
X-Google-Smtp-Source: ACHHUZ4NdT1BwChX1jdPmKqolCxerCxD0sjBa9TV8Kccv0jtnrpABi8VRgHPPf7PCA441pjSSAEf/g==
X-Received: by 2002:a05:6a20:734f:b0:10c:3cf3:ef7e with SMTP id v15-20020a056a20734f00b0010c3cf3ef7emr18182640pzc.42.1687296741149;
        Tue, 20 Jun 2023 14:32:21 -0700 (PDT)
Received: from telecaster.hsd1.wa.comcast.net ([2620:10d:c090:400::5:ea8e])
        by smtp.gmail.com with ESMTPSA id 5-20020aa79205000000b0064d3a9def35sm1688188pfo.188.2023.06.20.14.32.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jun 2023 14:32:20 -0700 (PDT)
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <djwong@kernel.org>, kernel-team@fb.com,
        Prashant Nema <pnema@fb.com>
Subject: [PATCH 0/6] xfs: CPU usage optimizations for realtime allocator
Date:   Tue, 20 Jun 2023 14:32:10 -0700
Message-ID: <cover.1687296675.git.osandov@osandov.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

Our distributed storage system uses XFS's realtime device support as a
way to split an XFS filesystem between an SSD and an HDD -- we configure
the HDD as the realtime device so that metadata goes on the SSD and data
goes on the HDD.

We've been running this in production for a few years now, so we have
some fairly fragmented filesystems. This has exposed various CPU
inefficiencies in the realtime allocator. These became even worse when
we experimented with using XFS_XFLAG_EXTSIZE to force files to be
allocated contiguously.

This series adds several optimizations that don't change the realtime
allocator's decisions, but make them happen more efficiently, mainly by
avoiding redundant work. We've tested these in production and measured
~10% lower CPU utilization. Furthermore, it made it possible to use
XFS_XFLAG_EXTSIZE to force contiguous allocations -- without these
patches, our most fragmented systems would become unresponsive due to
high CPU usage in the realtime allocator, but with them, CPU utilization
is actually ~4-6% lower than before, and disk I/O utilization is 15-20%
lower.

Patches 2 and 3 are preparations for later optimizations; the remaining
patches are the optimizations themselves.

This is based on Linus' tree as of today (commit
692b7dc87ca6d55ab254f8259e6f970171dc9d01).

Thanks!

Omar Sandoval (6):
  xfs: cache last bitmap block in realtime allocator
  xfs: invert the realtime summary cache
  xfs: return maximum free size from xfs_rtany_summary()
  xfs: limit maxlen based on available space in
    xfs_rtallocate_extent_near()
  xfs: don't try redundant allocations in xfs_rtallocate_extent_near()
  xfs: don't look for end of extent further than necessary in
    xfs_rtallocate_extent_near()

 fs/xfs/libxfs/xfs_rtbitmap.c | 173 ++++++++++++++--------------
 fs/xfs/xfs_mount.h           |   6 +-
 fs/xfs/xfs_rtalloc.c         | 215 ++++++++++++++++-------------------
 fs/xfs/xfs_rtalloc.h         |  28 +++--
 4 files changed, 207 insertions(+), 215 deletions(-)

-- 
2.41.0

