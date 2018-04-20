Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:31865 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752159AbeDTWJM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Apr 2018 18:09:12 -0400
From: Aleksei Besogonov <cyberax@amazon.com>
Subject: [PATCH 0/2] RFC: iomap-based swap file activation
Date: Fri, 20 Apr 2018 22:08:13 +0000
Message-ID: <20180420220815.44160-1-cyberax@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Aleksei Besogonov <cyberax@amazon.com>

This patch set adds iomap-based swap file initialization, this allows
it to use files with holes on XFS for swap.

Aleksei Besogonov (2):
  fs: Add iomap_swap_activate
  xfs: add support for iomap-based swapfile activation

 fs/iomap.c            | 87 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_aops.c     |  7 +++++
 include/linux/iomap.h |  5 +++
 mm/swapfile.c         |  1 +
 4 files changed, 100 insertions(+)

-- 
2.14.1

