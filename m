Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB5E3CA1019
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Sep 2023 21:52:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233340AbjIEVwS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Sep 2023 17:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244544AbjIEVwR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Sep 2023 17:52:17 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 921C6D2
        for <linux-xfs@vger.kernel.org>; Tue,  5 Sep 2023 14:52:12 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-68bec3a1c0fso1936726b3a.1
        for <linux-xfs@vger.kernel.org>; Tue, 05 Sep 2023 14:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20230601.gappssmtp.com; s=20230601; t=1693950732; x=1694555532; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hCRdx6T4oavxlcMwMQFB8HjQPrZt7oT7ivN/dsqcqkg=;
        b=Pg10OpZXIgNuDyjG1CPINpbA8MOr6wSmvXg8qcdxn3f3LxgptrsPtzDzX8iv4GIbEz
         26rYfWFnjupGDJuuu/3yz3PxxMbHkOEoECuNt2bKk7weyQRl4rtvlZYhvgKgNCEt01ru
         Z7D1lh6UV0Em7gXTAoR8twknl13wGp1GDB/TXo1fyru8qnmQJpDYOUeNLv9vpsBSLyCx
         NcXtAtf7Ii1Y2R2N4Z7WdpcSxAJqXOLKaiNmr6cmyK+hfmTYFg6Pa14LsNdJjNzkybGb
         2OJehcdbOB9sWmSkk6xgq2sY19hTawzMJjTOZluo5O6kSDaihjS120mIhX2n+07mEiko
         QoxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693950732; x=1694555532;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hCRdx6T4oavxlcMwMQFB8HjQPrZt7oT7ivN/dsqcqkg=;
        b=E05W/LkyHhSnXVZ/rd9MNXTF6ZYjGZmTwf0iphi5fjy/oTLL/yvgJXyU8wNglbqdLJ
         duua7hu333Bye1VqKOOKTE1NAl1F9AZRoagCamh8QdMZefoTIaWK9CyqtqY33lZHE2B6
         8LvddzllvNHpCXuJKP/sYnvZVvvRLqqXp2yHUOwI1JoON13nXeX6S+WmAXMUYC+vmaOv
         qqcz9zTrR9FchcMgjVt7HD0tqlqpvsqh84b+j3j/azEbIH7rP2p8hdSSlmnQy8VVM8HR
         zJR5nlMqBZo/qHls1mUPN4dmOninaNzbr6yC64rSPmTx/ozO4+0Kn7faeMO2/1PzBkQ1
         Mp2w==
X-Gm-Message-State: AOJu0Yx++xf9Lih4y1pms3WSpq1w2aB68IxRhWKdMPFKTisjQYT1OJeT
        Cy/dK51EmDio8Sf8x47iPID3GWhM58BmpQJnh3F3WQ==
X-Google-Smtp-Source: AGHT+IGBCM5nh+b3dYAcG1M5yPQnKTndaMBxkt3U+4L9Z2YvZejgmye+NyrKfqMzlmshpg6tEVQRfw==
X-Received: by 2002:a05:6a00:b95:b0:68b:daf4:212f with SMTP id g21-20020a056a000b9500b0068bdaf4212fmr14318151pfj.21.1693950731774;
        Tue, 05 Sep 2023 14:52:11 -0700 (PDT)
Received: from telecaster.hsd1.wa.comcast.net ([2620:10d:c090:400::5:e75a])
        by smtp.gmail.com with ESMTPSA id p6-20020a62ab06000000b0068bbf578694sm9856266pff.18.2023.09.05.14.52.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Sep 2023 14:52:11 -0700 (PDT)
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <djwong@kernel.org>, kernel-team@fb.com,
        Prashant Nema <pnema@fb.com>
Subject: [PATCH v2 0/6] xfs: CPU usage optimizations for realtime allocator
Date:   Tue,  5 Sep 2023 14:51:51 -0700
Message-ID: <cover.1693950248.git.osandov@osandov.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

This is version 2 of my XFS realtime allocator opimization patch series.

Changes since v1 [1]:

- Fixed potential overflow in patch 4.
- Changed deprecated typedefs to normal struct names
- Fixed broken indentation
- Used xfs_fileoff_t instead of xfs_fsblock_t where appropriate.
- Added calls to xfs_rtbuf_cache_relse anywhere that the cache is used
  instead of relying on the buffers being dirtied and thus attached to
  the transaction.
- Clarified comments and commit messages in a few places.
- Added Darrick's Reviewed-bys.

Cover letter from v1:

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

1: https://lore.kernel.org/linux-xfs/cover.1687296675.git.osandov@osandov.com/

Omar Sandoval (6):
  xfs: cache last bitmap block in realtime allocator
  xfs: invert the realtime summary cache
  xfs: return maximum free size from xfs_rtany_summary()
  xfs: limit maxlen based on available space in
    xfs_rtallocate_extent_near()
  xfs: don't try redundant allocations in xfs_rtallocate_extent_near()
  xfs: don't look for end of extent further than necessary in
    xfs_rtallocate_extent_near()

 fs/xfs/libxfs/xfs_rtbitmap.c | 185 ++++++++++++++--------------
 fs/xfs/xfs_mount.h           |   6 +-
 fs/xfs/xfs_rtalloc.c         | 228 ++++++++++++++++-------------------
 fs/xfs/xfs_rtalloc.h         |  30 +++--
 4 files changed, 224 insertions(+), 225 deletions(-)

-- 
2.41.0

