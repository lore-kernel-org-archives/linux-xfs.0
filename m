Return-Path: <SRS0=rRn/=BB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0144C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jul 2020 09:05:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77F182065D
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jul 2020 09:05:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FT5rebMp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729894AbgGVJFa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Jul 2020 05:05:30 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42825 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726555AbgGVJF3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Jul 2020 05:05:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595408727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=p8VsyiD7oWBk7n9h69rHXtPk6p1tf31rYGYRBZdvtxY=;
        b=FT5rebMpExZOhI7xk42C3zavDDU9YhR3NS+7UGbdO39ufg+1JPy0F+1meG+oYmwOT2/Qxg
        cYM5rgoyy2RgFoLifYqYOZMpLUTPO1kZwCdQSzkSxuywJGeT9+p3SRnPDwEXj2k9IjW4jD
        pMuMFMtDjoXw3Z5QFiP71nVgPKTsnTo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-315-pW676GjWP_q44Nlr418jVA-1; Wed, 22 Jul 2020 05:05:25 -0400
X-MC-Unique: pW676GjWP_q44Nlr418jVA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7BEC58015FB
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jul 2020 09:05:24 +0000 (UTC)
Received: from eorzea.redhat.com (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D72A761176
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jul 2020 09:05:23 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/5] Continue xfs kmem cleanup - V3
Date:   Wed, 22 Jul 2020 11:05:13 +0200
Message-Id: <20200722090518.214624-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi, new version of this series, including suggestions on the previous one.

In summary, this new version mostly changes patches 1 and 5 only, where:

Patch 1: uses __GFP_NOFAIL unconditionally in xfs_inode_alloc() instead of
current->flags, so it keeps the original function's logic, which will be changed
in a different patch not belonging to this series.

Patch 5: instead of removing xfs_da_state_alloc(), it refactors the function to
also set state->{args, mp} removing some lines of code. This patch now doesn't
'really' belong to this series since it's now just a refactoring, but
essentially it's a V2 of the previous one, but if needed I can submit it alone.

Series survived a few xfstests run.

Cheers.

Carlos Maiolino (5):
  xfs: Remove kmem_zone_alloc() usage
  xfs: Remove kmem_zone_zalloc() usage
  xfs: Modify xlog_ticket_alloc() to use kernel's MM API
  xfs: remove xfs_zone_{alloc,zalloc} helpers
  xfs: Refactor xfs_da_state_alloc() helper

 fs/xfs/kmem.c                      | 21 ---------------------
 fs/xfs/kmem.h                      |  8 --------
 fs/xfs/libxfs/xfs_alloc.c          |  3 ++-
 fs/xfs/libxfs/xfs_alloc_btree.c    |  2 +-
 fs/xfs/libxfs/xfs_attr.c           | 17 +++++------------
 fs/xfs/libxfs/xfs_bmap.c           |  8 ++++++--
 fs/xfs/libxfs/xfs_bmap_btree.c     |  2 +-
 fs/xfs/libxfs/xfs_da_btree.c       |  8 ++++++--
 fs/xfs/libxfs/xfs_da_btree.h       |  2 +-
 fs/xfs/libxfs/xfs_dir2_node.c      | 17 +++++------------
 fs/xfs/libxfs/xfs_ialloc_btree.c   |  2 +-
 fs/xfs/libxfs/xfs_inode_fork.c     |  6 +++---
 fs/xfs/libxfs/xfs_refcount_btree.c |  2 +-
 fs/xfs/libxfs/xfs_rmap_btree.c     |  2 +-
 fs/xfs/scrub/dabtree.c             |  4 +---
 fs/xfs/xfs_bmap_item.c             |  4 ++--
 fs/xfs/xfs_buf.c                   |  4 +---
 fs/xfs/xfs_buf_item.c              |  2 +-
 fs/xfs/xfs_dquot.c                 |  2 +-
 fs/xfs/xfs_extfree_item.c          |  6 ++++--
 fs/xfs/xfs_icache.c                | 10 ++--------
 fs/xfs/xfs_icreate_item.c          |  2 +-
 fs/xfs/xfs_inode_item.c            |  3 ++-
 fs/xfs/xfs_log.c                   |  9 +++------
 fs/xfs/xfs_log_cil.c               |  3 +--
 fs/xfs/xfs_log_priv.h              |  4 +---
 fs/xfs/xfs_refcount_item.c         |  5 +++--
 fs/xfs/xfs_rmap_item.c             |  5 +++--
 fs/xfs/xfs_trace.h                 |  1 -
 fs/xfs/xfs_trans.c                 |  4 ++--
 fs/xfs/xfs_trans_dquot.c           |  3 ++-
 31 files changed, 63 insertions(+), 108 deletions(-)

-- 
2.26.2

