Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36942 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731111AbfCaOZ0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 31 Mar 2019 10:25:26 -0400
Received: by mail-wm1-f65.google.com with SMTP id v14so8257844wmf.2
        for <linux-xfs@vger.kernel.org>; Sun, 31 Mar 2019 07:25:25 -0700 (PDT)
From: Alex Lyakas <alex@zadara.com>
Subject: [STABLE PATCH 0/2] Fix in-memory metadata corruption at xfs_attr3_leaf_write_verify()
Date: Sun, 31 Mar 2019 17:24:33 +0300
Message-Id: <1554042273-3307-1-git-send-email-alex@zadara.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: stable@vger.kernel.org, darrick.wong@oracle.com, hch@lst.de, shyam@zadara.com

This is a partial backport of original Darrick's series "xfs: logging fixes" to kernel 4.14.
It fixes the in-memory metadata corruption error, which happens
when a partially initialized attribute buffer is attemped to be written to disk. 
This issue is reproducible with kernel 4.14, when adding a 1-sec sleep in xfs_attr_set(),
between the call to  xfs_attr_shortform_to_leaf() and the call to xfs_attr_leaf_addname().

Darrick J. Wong (2):
  xfs: add the ability to join a held buffer to a defer_ops
  xfs: hold xfs_buf locked between shortform->leaf conversion and the
    addition of an attribute

 fs/xfs/libxfs/xfs_attr.c      | 20 +++++++++++++++-----
 fs/xfs/libxfs/xfs_attr_leaf.c |  9 ++++++---
 fs/xfs/libxfs/xfs_attr_leaf.h |  3 ++-
 fs/xfs/libxfs/xfs_defer.c     | 39 ++++++++++++++++++++++++++++++++++++---
 fs/xfs/libxfs/xfs_defer.h     |  5 ++++-
 5 files changed, 63 insertions(+), 13 deletions(-)

-- 
1.9.1
