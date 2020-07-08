Return-Path: <SRS0=1kUG=AT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32415C433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jul 2020 12:56:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E08820774
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jul 2020 12:56:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hnU2WYPU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728803AbgGHM4Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jul 2020 08:56:16 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:56611 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728759AbgGHM4P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jul 2020 08:56:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594212974;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Abe7YPSOhBYIZPP09Qf+aIPV78DxXE9sjAbJ9OfQeIY=;
        b=hnU2WYPUOROLASxAoHOZmoYaiMyNZpUJR2ZHAHuM0oSZzYU7+jvkwNfhIun3v8rtmXMgeO
        EQeaPvi34GeTI1pKKzOEGWu+rJFO0fd4hhEdS08fXerak8GqdoMOzoybK5Pjc6WL+ZqNUH
        qi36hUA6vu63NTvMPoVtYm0TC8JnXQs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-18-KNlaQYSgNBS5RfXDKoLBQw-1; Wed, 08 Jul 2020 08:56:12 -0400
X-MC-Unique: KNlaQYSgNBS5RfXDKoLBQw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E2817107BEF5
        for <linux-xfs@vger.kernel.org>; Wed,  8 Jul 2020 12:56:11 +0000 (UTC)
Received: from eorzea.redhat.com (unknown [10.40.194.83])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5BD4B60E3E
        for <linux-xfs@vger.kernel.org>; Wed,  8 Jul 2020 12:56:11 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/4] Continue xfs kmem cleanup
Date:   Wed,  8 Jul 2020 14:56:04 +0200
Message-Id: <20200708125608.155645-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

a while ago I started to cleanup the kmem helpers we have, and use kernel's MM
API. The discussion has stalled because I've got caugh on other stuff, and I'm
trying to continue that cleanup.

The following series basically removes kmem_zone_alloc() and kmem_zone_zalloc(),
replacing them by kmem_cache_{alloc,zalloc}.

It uses __GFP_NOFAIL where we are not allowed to fail, to replicate the behavior
of kmem_zone_alloc().

Patches have been tested with xfstests, on a 1GiG and a 64GiB RAM systems to
check the patches under memory pressure.

The patches are good as-is, but my main point is to revive the topic, and I
though it would be better to do it with the patches. Which is another reason I
decided to split the series in a few more patches than would be required, I
thought it would be better segmenting the changes in the way I did.

Comments?

Cheers

 fs/xfs/kmem.c                      | 21 ---------------------
 fs/xfs/kmem.h                      |  8 --------
 fs/xfs/libxfs/xfs_alloc.c          |  3 ++-
 fs/xfs/libxfs/xfs_alloc_btree.c    |  3 ++-
 fs/xfs/libxfs/xfs_bmap.c           |  8 ++++++--
 fs/xfs/libxfs/xfs_bmap_btree.c     |  3 ++-
 fs/xfs/libxfs/xfs_da_btree.c       |  4 +++-
 fs/xfs/libxfs/xfs_ialloc_btree.c   |  2 +-
 fs/xfs/libxfs/xfs_inode_fork.c     |  6 +++---
 fs/xfs/libxfs/xfs_refcount_btree.c |  2 +-
 fs/xfs/libxfs/xfs_rmap_btree.c     |  2 +-
 fs/xfs/xfs_bmap_item.c             |  4 ++--
 fs/xfs/xfs_buf.c                   |  2 +-
 fs/xfs/xfs_buf_item.c              |  2 +-
 fs/xfs/xfs_dquot.c                 |  2 +-
 fs/xfs/xfs_extfree_item.c          |  6 ++++--
 fs/xfs/xfs_icache.c                | 11 +++--------
 fs/xfs/xfs_icreate_item.c          |  2 +-
 fs/xfs/xfs_inode_item.c            |  3 ++-
 fs/xfs/xfs_log.c                   |  7 ++++---
 fs/xfs/xfs_log_cil.c               |  2 +-
 fs/xfs/xfs_log_priv.h              |  2 +-
 fs/xfs/xfs_refcount_item.c         |  5 +++--
 fs/xfs/xfs_rmap_item.c             |  6 ++++--
 fs/xfs/xfs_trace.h                 |  1 -
 fs/xfs/xfs_trans.c                 |  5 +++--
 fs/xfs/xfs_trans_dquot.c           |  3 ++-
 27 files changed, 54 insertions(+), 71 deletions(-)

-- 
2.26.2

