Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:14604 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756364AbeEASsR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 May 2018 14:48:17 -0400
From: Aleksei Besogonov <cyberax@amazon.com>
Subject: [PATCH 0/2] RFC: iomap-based swapfile activation
Date: Tue, 1 May 2018 18:48:05 +0000
Message-ID: <20180501184807.123111-1-cyberax@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, darrick.wong@oracle.com
Cc: Aleksei Besogonov <cyberax@amazon.com>

V2 of iomap-based swapfile support. 

Changes from V1: additional validations for file extents, based on
a patch from Darrick Wong.

Aleksei Besogonov (2):
  fs: Add iomap_swap_activate
  xfs: add support for iomap-based swapfile activation

 fs/iomap.c            | 106 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_aops.c     |   8 ++++
 include/linux/iomap.h |   5 +++
 mm/swapfile.c         |   1 +
 4 files changed, 120 insertions(+)

-- 
2.14.1

