Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FBA2C43334
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jun 2022 20:37:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbiFWUhD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jun 2022 16:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiFWUhC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jun 2022 16:37:02 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CFC760E2D
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jun 2022 13:37:02 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id g186so523387pgc.1
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jun 2022 13:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+KmAaMn4SZctFBkHKOCkGJvGkdm6Dx0MJ46H9DmQlnw=;
        b=f1Gt+TU0shESqhaFvgL2/pPmiizJGXQp8uibl2dKMFBO1NJbzB61Vhk4exjud3v8a5
         wxe0kjg07t7OVpujMyTUcA/SD2XEHHbXO7MQjOVvvx/XANGkG5m+z0SMDnfSsp7x08uP
         4XYwzoCY7GTP7fIOldZ6N6eDjdastStboxsevCtfh6URNLhj6ysi6+qycMBJr4uhbZzF
         pLa8/leY7sfrb4YN/uvh0wnaghjx69tJiI5SE0XyUhFXfpWH5dVWYz31zxMZr4yWUrIo
         FIr1Oe+Sw5t31r00tUKlbW00U3JouQODb8RInJUNZThR9h7+PUooq74m3AaqmAkNLx0X
         Y7pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+KmAaMn4SZctFBkHKOCkGJvGkdm6Dx0MJ46H9DmQlnw=;
        b=2AvrYim3y4h2Ig14CsbKYzqvjmcmsJG/gQIXSkfBMA5IpKhbQ8V0sn0LGB5qTTGSrW
         EqozT1mlwRBXiwzgbm2obLuANXZsA0Ve1qqtMEq22d7THCWAw7hv4NiZ6WHgK78bkx3O
         ZaJv5i02dry0WdeYgNn7nMa02MjEBd+G4DQKHhkaG50Omn7tQWFFFiroxRYeM1L4tzAT
         NWYY+Am3iNGzHlnUkOhDddJ9ekYzeY/R1SLSplKhodkVOem3a3myW1hveW4yU6g4Xb/s
         JQhHN/W6YDdBiOYO+/KGDkbx5p9k/QhvUP6SFOCzdFLv55aH6R5lnML0wsLud88VGg/S
         zXnA==
X-Gm-Message-State: AJIora8IA6x7hBXDCIKd+Fqg1S8W3GVSuoxRBl0NegmH/nDChX4sfIE9
        s7MiLfGnnqcfxpAsbh3ztzIrWr1MfHVcPw==
X-Google-Smtp-Source: AGRyM1sc3pef81GOjUPaJ2vShbo/+lBeiJltwc5gBUbeUBZu2GPS2ZCAvaUZYgYkrikAM1kZ6Vnsfg==
X-Received: by 2002:a65:6a94:0:b0:40c:977c:9665 with SMTP id q20-20020a656a94000000b0040c977c9665mr9009413pgu.5.1656016621379;
        Thu, 23 Jun 2022 13:37:01 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2cd:202:a654:18fe:feac:cac1])
        by smtp.gmail.com with ESMTPSA id m12-20020a170902768c00b0016a17da4ad4sm228386pll.39.2022.06.23.13.37.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 13:37:01 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE v3 0/7] xfs stable candidate patches for 5.15.y (part 1)
Date:   Thu, 23 Jun 2022 13:36:34 -0700
Message-Id: <20220623203641.1710377-1-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Thanks for all the comments on v2, this is the final version for
5.15.y part 1. I plan on sending this set to stable in a few days if
there are no remaining comments.

Best,
Leah

Changes from v2:
- Drop SGID fix [1]
- Added Acks from Darrick for remaining patches

Changes from v1:
- Increased testing
- Reduced patch set to overlap with 5.10 patches


v1: https://lore.kernel.org/linux-xfs/20220603184701.3117780-1-leah.rumancik@gmail.com/
v2: https://lore.kernel.org/linux-xfs/20220616182749.1200971-1-leah.rumancik@gmail.com/

[1] https://lore.kernel.org/linux-xfs/20220617100641.1653164-12-amir73il@gmail.com/

Brian Foster (1):
  xfs: punch out data fork delalloc blocks on COW writeback failure

Darrick J. Wong (3):
  xfs: remove all COW fork extents when remounting readonly
  xfs: prevent UAF in xfs_log_item_in_current_chkpt
  xfs: only bother with sync_filesystem during readonly remount

Dave Chinner (1):
  xfs: check sb_meta_uuid for dabuf buffer recovery

Rustam Kovhaev (1):
  xfs: use kmem_cache_free() for kmem_cache objects

Yang Xu (1):
  xfs: Fix the free logic of state in xfs_attr_node_hasname

 fs/xfs/libxfs/xfs_attr.c      | 17 +++++++----------
 fs/xfs/xfs_aops.c             | 15 ++++++++++++---
 fs/xfs/xfs_buf_item_recover.c |  2 +-
 fs/xfs/xfs_extfree_item.c     |  6 +++---
 fs/xfs/xfs_log_cil.c          |  6 +++---
 fs/xfs/xfs_super.c            | 21 ++++++++++++++++-----
 6 files changed, 42 insertions(+), 25 deletions(-)

-- 
2.37.0.rc0.161.g10f37bed90-goog

