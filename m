Return-Path: <SRS0=IY5l=AV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF801C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jul 2020 09:15:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8470C2065D
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jul 2020 09:15:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KNm1sxFr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbgGJJPu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jul 2020 05:15:50 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41333 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726496AbgGJJPt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jul 2020 05:15:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594372548;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=q73+bxK0AsmcQmcfY+J5J+ST+7JC3I8fjtPtysmapz4=;
        b=KNm1sxFry/OVv23WknP31Jqhx4I2R/Rb7INpASGUyWnyjCVm7QnmvvoEpo9viL+at2/gde
        QHGg7flXLa08C4FHO+4Mx9EcsR6S+CVepI5cDe2LwXFPYAZQdNF7ODmcTIucS360jnXzKc
        o3NuaLGMs3Jh5BKlwSlHJJhtDcP4Fgc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-434-VuF78DipNVmEisqSANMN0w-1; Fri, 10 Jul 2020 05:15:46 -0400
X-MC-Unique: VuF78DipNVmEisqSANMN0w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 28ABE107ACCA
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jul 2020 09:15:46 +0000 (UTC)
Received: from eorzea.redhat.com (unknown [10.40.193.235])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 836AC5D9E5
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jul 2020 09:15:45 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/5] Continue xfs kmem cleanup - V2
Date:   Fri, 10 Jul 2020 11:15:31 +0200
Message-Id: <20200710091536.95828-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

This is a V2 of the kmem cleanup series, which includes the changes suggested by
Dave on V1, including his reviewed-by tag on patch 4.

Detailed changelog is written on each patch.

Patches have been tested with xfstests, on a 1GiG and a 64GiB RAM systems to
check the patches under memory pressure.

Cheers.

Comments?

Carlos Maiolino (5):
  xfs: Remove kmem_zone_alloc() usage
  xfs: Remove kmem_zone_zalloc() usage
  xfs: Modify xlog_ticket_alloc() to use kernel's MM API
  xfs: remove xfs_zone_{alloc,zalloc} helpers
  xfs: Remove xfs_da_state_alloc() helper

 fs/xfs/kmem.c                      | 21 ---------------------
 fs/xfs/kmem.h                      |  8 --------
 fs/xfs/libxfs/xfs_alloc.c          |  3 ++-
 fs/xfs/libxfs/xfs_alloc_btree.c    |  2 +-
 fs/xfs/libxfs/xfs_attr.c           |  9 +++++----
 fs/xfs/libxfs/xfs_bmap.c           |  8 ++++++--
 fs/xfs/libxfs/xfs_bmap_btree.c     |  2 +-
 fs/xfs/libxfs/xfs_da_btree.c       | 10 ----------
 fs/xfs/libxfs/xfs_da_btree.h       |  1 -
 fs/xfs/libxfs/xfs_dir2_node.c      |  8 ++++----
 fs/xfs/libxfs/xfs_ialloc_btree.c   |  2 +-
 fs/xfs/libxfs/xfs_inode_fork.c     |  6 +++---
 fs/xfs/libxfs/xfs_refcount_btree.c |  2 +-
 fs/xfs/libxfs/xfs_rmap_btree.c     |  2 +-
 fs/xfs/scrub/dabtree.c             |  3 ++-
 fs/xfs/xfs_bmap_item.c             |  4 ++--
 fs/xfs/xfs_buf.c                   |  4 +---
 fs/xfs/xfs_buf_item.c              |  2 +-
 fs/xfs/xfs_dquot.c                 |  2 +-
 fs/xfs/xfs_extfree_item.c          |  6 ++++--
 fs/xfs/xfs_icache.c                | 13 +++++++++----
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
 31 files changed, 63 insertions(+), 94 deletions(-)

-- 
2.26.2

