Return-Path: <SRS0=4PMG=ZG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55944C432C3
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Nov 2019 20:10:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E9CE20679
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Nov 2019 20:10:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XBE83OBb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbfKNUKB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Nov 2019 15:10:01 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:56678 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726444AbfKNUKB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Nov 2019 15:10:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573762200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=C3elXwmqurlyXYRA6ayd3FZiZvZebkX0lIRhFlceBBM=;
        b=XBE83OBbVfa9IdJ2nivIn1Phw7X0m2t2dtrWtZzxtB7cGawbj6N2YnABghLksWWy4higxf
        PCZNjwX/O7DwmV8FbTbBedvd79zUQvUHA5fcbAl8VkmiVZhzVgDf1b5K2qwHfAOGN3qCVY
        ePNnTtIg81bG25A8n8gV4k6sr8V95TQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-9BmIZViNM8uWF9ZwQkxNuw-1; Thu, 14 Nov 2019 15:09:58 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DBD8380058A
        for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2019 20:09:57 +0000 (UTC)
Received: from orion.redhat.com (ovpn-204-203.brq.redhat.com [10.40.204.203])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4402067659
        for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2019 20:09:57 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/4] Get rid of pointless wrappers
Date:   Thu, 14 Nov 2019 21:09:51 +0100
Message-Id: <20191114200955.1365926-1-cmaiolino@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: 9BmIZViNM8uWF9ZwQkxNuw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

As agreed on the first version of the series to cleanup kmem_* wrappers and=
 KM_*
flags, we've decided to split the whole work into 3 parts.

This is the first one, containing the removal of wrappers which are pointle=
ss,
requiring no logic change and no flag change, just replacing the kmem_* cal=
lers
by the proper generic memory allocation helpers.

All first 3 patches already have the reviewed-by, the last one is a new pat=
ch,
removing kmem_free() and converting their users to use kfree() directly, or
kvfree(), for those users which memory have been allocated by kmem_alloc_io=
() or
kmem_alloc_large().

Cheers

Carlos Maiolino (4):
  xfs: Remove slab init wrappers
  xfs: Remove kmem_zone_destroy() wrapper
  xfs: Remove kmem_zone_free() wrapper
  xfs: Remove kmem_free()

 fs/xfs/kmem.h                  |  35 -------
 fs/xfs/libxfs/xfs_attr.c       |   2 +-
 fs/xfs/libxfs/xfs_attr_leaf.c  |   8 +-
 fs/xfs/libxfs/xfs_btree.c      |   2 +-
 fs/xfs/libxfs/xfs_da_btree.c   |  12 +--
 fs/xfs/libxfs/xfs_defer.c      |   4 +-
 fs/xfs/libxfs/xfs_dir2.c       |  18 ++--
 fs/xfs/libxfs/xfs_dir2_block.c |   4 +-
 fs/xfs/libxfs/xfs_dir2_sf.c    |   8 +-
 fs/xfs/libxfs/xfs_iext_tree.c  |   8 +-
 fs/xfs/libxfs/xfs_inode_fork.c |  16 +--
 fs/xfs/libxfs/xfs_refcount.c   |   4 +-
 fs/xfs/scrub/agheader.c        |   2 +-
 fs/xfs/scrub/agheader_repair.c |   2 +-
 fs/xfs/scrub/attr.c            |   2 +-
 fs/xfs/scrub/bitmap.c          |   4 +-
 fs/xfs/scrub/btree.c           |   2 +-
 fs/xfs/scrub/refcount.c        |   8 +-
 fs/xfs/scrub/scrub.c           |   2 +-
 fs/xfs/xfs_acl.c               |   4 +-
 fs/xfs/xfs_attr_inactive.c     |   2 +-
 fs/xfs/xfs_attr_list.c         |   4 +-
 fs/xfs/xfs_bmap_item.c         |   8 +-
 fs/xfs/xfs_buf.c               |  25 ++---
 fs/xfs/xfs_buf_item.c          |   8 +-
 fs/xfs/xfs_dquot.c             |  20 ++--
 fs/xfs/xfs_dquot_item.c        |   8 +-
 fs/xfs/xfs_error.c             |   2 +-
 fs/xfs/xfs_extent_busy.c       |   2 +-
 fs/xfs/xfs_extfree_item.c      |  18 ++--
 fs/xfs/xfs_filestream.c        |   4 +-
 fs/xfs/xfs_icache.c            |   4 +-
 fs/xfs/xfs_icreate_item.c      |   2 +-
 fs/xfs/xfs_inode.c             |  12 +--
 fs/xfs/xfs_inode_item.c        |   4 +-
 fs/xfs/xfs_ioctl.c             |   6 +-
 fs/xfs/xfs_ioctl32.c           |   2 +-
 fs/xfs/xfs_iops.c              |   2 +-
 fs/xfs/xfs_itable.c            |   4 +-
 fs/xfs/xfs_iwalk.c             |   4 +-
 fs/xfs/xfs_log.c               |  14 +--
 fs/xfs/xfs_log_cil.c           |  16 +--
 fs/xfs/xfs_log_recover.c       |  50 +++++-----
 fs/xfs/xfs_mount.c             |   8 +-
 fs/xfs/xfs_mru_cache.c         |   8 +-
 fs/xfs/xfs_qm.c                |   6 +-
 fs/xfs/xfs_refcount_item.c     |  10 +-
 fs/xfs/xfs_rmap_item.c         |  10 +-
 fs/xfs/xfs_rtalloc.c           |   8 +-
 fs/xfs/xfs_super.c             | 171 ++++++++++++++++++---------------
 fs/xfs/xfs_trans.c             |   2 +-
 fs/xfs/xfs_trans_ail.c         |   4 +-
 fs/xfs/xfs_trans_dquot.c       |   2 +-
 53 files changed, 292 insertions(+), 305 deletions(-)

--=20
2.23.0

