Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CA83C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jun 2022 06:37:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbiFXGhK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jun 2022 02:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbiFXGhK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jun 2022 02:37:10 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE3C1609E2;
        Thu, 23 Jun 2022 23:37:08 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id l126-20020a1c2584000000b0039c1a10507fso944775wml.1;
        Thu, 23 Jun 2022 23:37:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zr6FFfcSHVfU4dL6GeNUNHsD85R2DDQjY7ySAlBC6is=;
        b=Cb1WmYiJNK1/LLunqLV7YNTkhs56qchXMuuCqO2gwis5WOhc2Py1OyRqZr6jNMe0Mr
         no+GO3LSiy4G2xkhM9IP2TSmGOlyXJ0MQoixRhIfHjN/WMi8CEvMgAaGZcTqa55FYrkb
         zWBCFjZ4PNtwxdTt9SBAA3r0bqM9OnBfEoD7wa3xwKa7o0c5FLs86Jt57AOSocY0iGXl
         LVITOr8T8zZBUmqcF7k3TuEHGwCMBFFfcHKmmULUQ3hnOQ1npXYCuvbNox0q5Crh66Y3
         +VFmKYuY8lOeJPUPIAPCc9650XRBBNegqpPWGRf/vMmTnu7iJzmHqeinafvusLWT2nq/
         TD6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zr6FFfcSHVfU4dL6GeNUNHsD85R2DDQjY7ySAlBC6is=;
        b=73KxCwKVt3Jrx4xJeBMXrux8VIrqeNI9c9PZUV5Q2FRZxHsErb05vwQtuVg4pRZ/nE
         4coZJAiyMCOmZ8Lu89rC1m9uzNKVgKlA5hTPvYQsRwFmh/gfpKVNuyFBXHljdjmOkvN8
         +J3F31Tesee9WEFgT2qFtLwcpFb3CYFiVpf65yQzfvG+wF3IdrkIrCPqnP0IZo0LyI2K
         LfJ//N/trHd+Ge79JGNH2fh2JtREDB4weqO4OFnkatV/lTamh8ucu1mQ7Jc4kxk9JNm5
         lisqUfGiqh53uEc60uVgeS98f/KKNhumK0i9qKpG0pCpi/tm5txnuMTCI1VLk0qTzbBL
         3Lrw==
X-Gm-Message-State: AJIora/KQ9B7D0rBdSgGOZYIRON8O+1PB+FnSxdWHxkAgB6iAxn1mNOf
        ask2PPdMaQYIUOzvdKNDTd8=
X-Google-Smtp-Source: AGRyM1sTrWP0pSDwoMbn5JvWtEz1jykuswHVIHtnPHWc3yjxVQUQr9Cnbn/IzSxXbrfGvdVUOIXIwg==
X-Received: by 2002:a1c:f318:0:b0:3a0:3015:3604 with SMTP id q24-20020a1cf318000000b003a030153604mr1885747wmq.180.1656052627178;
        Thu, 23 Jun 2022 23:37:07 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.8.191])
        by smtp.gmail.com with ESMTPSA id n14-20020a5d67ce000000b0021b89c07b6asm1540653wrw.108.2022.06.23.23.37.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 23:37:06 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [5.10 CANDIDATE v2 0/5] xfs stable candidate patches for 5.10.y (v5.15+)
Date:   Fri, 24 Jun 2022 09:36:57 +0300
Message-Id: <20220624063702.2380990-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This is the subset of patches from Leah's 5.15.y series [1] that was
tested and ACKed for 5.10.y.

The rest of the patches were more subtle to backport, so they need more
time for review.

One patch in v1 also needed missing vfs patches (syncfs error) so those
need to be tested in 5.10 as well before being posted again.

I will send these 5 patches to stable in a few days if there are no
further comments.

Thanks,
Amir.

Changes since [v1]:
- Leave 5 out of 11
- Accked by Darrick

[1] https://lore.kernel.org/linux-xfs/20220616182749.1200971-1-leah.rumancik@gmail.com/
[v1] https://lore.kernel.org/linux-xfs/20220617100641.1653164-1-amir73il@gmail.com/

Brian Foster (1):
  xfs: punch out data fork delalloc blocks on COW writeback failure

Darrick J. Wong (1):
  xfs: remove all COW fork extents when remounting readonly

Dave Chinner (1):
  xfs: check sb_meta_uuid for dabuf buffer recovery

Rustam Kovhaev (1):
  xfs: use kmem_cache_free() for kmem_cache objects

Yang Xu (1):
  xfs: Fix the free logic of state in xfs_attr_node_hasname

 fs/xfs/libxfs/xfs_attr.c      | 13 +++++--------
 fs/xfs/xfs_aops.c             | 15 ++++++++++++---
 fs/xfs/xfs_buf_item_recover.c |  2 +-
 fs/xfs/xfs_extfree_item.c     |  6 +++---
 fs/xfs/xfs_super.c            | 14 +++++++++++---
 5 files changed, 32 insertions(+), 18 deletions(-)

-- 
2.25.1

