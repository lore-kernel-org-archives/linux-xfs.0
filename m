Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BA58C43334
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jun 2022 18:28:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236866AbiFPS2L (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jun 2022 14:28:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233682AbiFPS2L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jun 2022 14:28:11 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F2F3584F
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jun 2022 11:28:10 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id f8so1909552plo.9
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jun 2022 11:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MGgIY9tznXuZlSeI6c1RqtFsTV24uEnewlmgyFVMAjk=;
        b=p1oW4ijgLGs97vwNan0tuuXsz12lUULCqRLCeU1uWrOEsAH65VIBkNkgjMJdM+sKEI
         ye9Mw014DOssGAaak1ToRWtMy34fMb6LZvW+b9CL610qdAP+Josm+RVeyBlT0CMAQMuQ
         UNNds2UJgcJDsfXQAF94enhJcfoUp1BG3+JvKUXeye5nx8v9Bxs+pJ79Hp21uQQqKlVd
         yCpm17ekZq6vw+IQ46Zt6gBVBJ/8Cb9aGKCgrvU/ziifpS8AfbUL4SCKKjl712Hb832n
         7bPYZBVSh25PmjSV4/oEBSnG5A1XVFYxDt7da7v++IKHyf6rLGgzvFbwSmInkxWiBx0c
         QgTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MGgIY9tznXuZlSeI6c1RqtFsTV24uEnewlmgyFVMAjk=;
        b=42dnBStLGVOt4WBME7J/VMAXhLOTf4suDfm63PYkmpARxUvYBpB/e5hTGELQnUYkDO
         Z4YCA5SbaMolSQy1Ttn2abDhP1kPPzD8oboYpMq31g2F1AmrN88nDM4zvt1R87KlDYs7
         a8kX52Y6nZHIw52cOVVvQnhWGbSA8jF+exWlXVEnmCdqLp5f4MAbnfQ1a9A2pVlbSWck
         PTrBNsYFSvKSNsE/prUSq1gR4DMHoofvD6RGIvMFSeWD/pfEI2DgVh42M+hWmQ3oMfsW
         qu5xBBjltokIffNTTjPCL0ky5xb8+V6oG9qlq8HATh9qIRRm8VY1MYtBK9xfT1NkI1LT
         F1/g==
X-Gm-Message-State: AJIora9v3E6uszpeAwqbojB0IaF+AJ753E2iXM34rX02znG7Djjx/nDK
        FwYK/1WURxm/rXY2DnEqmnD6vX4EdWc=
X-Google-Smtp-Source: AGRyM1vBH3GX2x3/0h/FWM+W+pljHn7Fxs58N283ePw4/eTfqJntqmk70apQyAuPHPehE/tEDctzEw==
X-Received: by 2002:a17:903:283:b0:163:be9d:483a with SMTP id j3-20020a170903028300b00163be9d483amr5752137plr.166.1655404089563;
        Thu, 16 Jun 2022 11:28:09 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2cd:202:fd57:7edc:385a:c1be])
        by smtp.gmail.com with ESMTPSA id fs20-20020a17090af29400b001ea75a02805sm4131511pjb.52.2022.06.16.11.28.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 11:28:09 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     mcgrof@kernel.org, Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE v2 0/8] xfs stable candidate patches for 5.15.y (part 1)
Date:   Thu, 16 Jun 2022 11:27:41 -0700
Message-Id: <20220616182749.1200971-1-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The patch testing has been increased to 100 runs per test on each 
config. A baseline without the patches was established with 100 runs 
to help detect hard failures / tests with a high fail rate. Any 
failures seen in the backports branch but not in the baseline branch 
were then run 1000+ times on both the baseline and backport branches 
and the failure rates compared. The failures seen on the 5.15 
baseline are listed at 
https://gist.github.com/lrumancik/5a9d85d2637f878220224578e173fc23. 
No regressions were seen with these patches.

To make the review process easier, I have been coordinating with Amir 
who has been testing this same set of patches on 5.10. He will be 
sending out the corresponding 5.10 series shortly.

Change log from v1 
(https://lore.kernel.org/all/20220603184701.3117780-1-leah.rumancik@gmail.com/):
- Increased testing
- Reduced patch set to overlap with 5.10 patches

Thanks,
Leah

Brian Foster (1):
  xfs: punch out data fork delalloc blocks on COW writeback failure

Darrick J. Wong (4):
  xfs: remove all COW fork extents when remounting readonly
  xfs: prevent UAF in xfs_log_item_in_current_chkpt
  xfs: only bother with sync_filesystem during readonly remount
  xfs: use setattr_copy to set vfs inode attributes

Dave Chinner (1):
  xfs: check sb_meta_uuid for dabuf buffer recovery

Rustam Kovhaev (1):
  xfs: use kmem_cache_free() for kmem_cache objects

Yang Xu (1):
  xfs: Fix the free logic of state in xfs_attr_node_hasname

 fs/xfs/libxfs/xfs_attr.c      | 17 +++++------
 fs/xfs/xfs_aops.c             | 15 ++++++++--
 fs/xfs/xfs_buf_item_recover.c |  2 +-
 fs/xfs/xfs_extfree_item.c     |  6 ++--
 fs/xfs/xfs_iops.c             | 56 ++---------------------------------
 fs/xfs/xfs_log_cil.c          |  6 ++--
 fs/xfs/xfs_pnfs.c             |  3 +-
 fs/xfs/xfs_super.c            | 21 +++++++++----
 8 files changed, 47 insertions(+), 79 deletions(-)

-- 
2.36.1.476.g0c4daa206d-goog

