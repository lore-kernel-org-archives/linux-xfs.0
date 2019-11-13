Return-Path: <SRS0=J5MO=ZF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2B7FC43331
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 14:23:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74F27222C9
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 14:23:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OLYT+n9G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727493AbfKMOXs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Nov 2019 09:23:48 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31539 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727481AbfKMOXr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Nov 2019 09:23:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573655026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Dmcw4k6bVlwzvnndn7mvEug+CdckybSb9XEgOaPfs30=;
        b=OLYT+n9GxLKhdbU+qgJj7hWUWNSm1oW5gMX9/h5tb23GBsHP3p/dI4ZVOZfQphbDr+MwG6
        GvIu962DJRUSg/NdlyEWZockBFAyI7MazAXiRwL3QDNnyB8+Uox3iEJoNqN4ejnObY8fh+
        WWYQlzl2MkPausY1JATyFsHwKoVaqM4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287-wg1dpZqRPnWjNBSeJSv6lw-1; Wed, 13 Nov 2019 09:23:45 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8A03010C092E
        for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2019 14:23:44 +0000 (UTC)
Received: from orion.redhat.com (ovpn-204-203.brq.redhat.com [10.40.204.203])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E0F984D9E1
        for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2019 14:23:43 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 00/11] Use generic memory API instead of a custom one
Date:   Wed, 13 Nov 2019 15:23:24 +0100
Message-Id: <20191113142335.1045631-1-cmaiolino@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: wg1dpZqRPnWjNBSeJSv6lw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi.

This patchset aims to remove most of XFS custom memory allocation mechanism=
 and
replace it with generic memory interfaces. This includes:

- removing KM_* flags
- removing most of the kmem_* API, with the exception of 2 helpers (see the=
 last
  two patches).

All mem alloc requests using KM_* flags, were replaced following these rule=
s:

- KM_ZONE_* flags were directly replaced by their SLAB_* relative

- KM_NOFS: Replaced by GFP_NOFS
- KM_MAYFAIL: Replaced by __GFP_RETRY_MAYFAIL

- All memalloc requests made with no KM_* flags, like:
=09kmem_alloc(item, 0);

  Have been replaced by GFP_KERNEL.

- Every memalloc request without KM_MAYFAIL have been replaced by __GFP_NOF=
AIL
  and the other flags OR'ed together.

These patches passed a few xfstests runs without issues.
Cheers


Carlos Maiolino (11):
  xfs: Remove slab init wrappers
  xfs: Remove kmem_zone_destroy() wrapper
  xfs: Remove kmem_zone_free() wrapper
  xfs: remove kmem_zone_zalloc()
  xfs: Remove kmem_zone_alloc() wrapper
  xfs: remove kmem_zalloc() wrapper
  xfs: Remove kmem_realloc
  xfs: Convert kmem_alloc() users
  xfs: rework kmem_alloc_{io,large} to use GFP_* flags
  xfs: Remove KM_* flags
  xfs: Remove kmem_alloc_{io, large} and kmem_zalloc_large

 fs/xfs/kmem.c                      | 134 +++-------------------
 fs/xfs/kmem.h                      |  93 +---------------
 fs/xfs/libxfs/xfs_alloc.c          |   3 +-
 fs/xfs/libxfs/xfs_alloc_btree.c    |   2 +-
 fs/xfs/libxfs/xfs_attr_leaf.c      |  11 +-
 fs/xfs/libxfs/xfs_bmap.c           |   8 +-
 fs/xfs/libxfs/xfs_bmap_btree.c     |   2 +-
 fs/xfs/libxfs/xfs_btree.c          |   2 +-
 fs/xfs/libxfs/xfs_da_btree.c       |  18 +--
 fs/xfs/libxfs/xfs_defer.c          |   4 +-
 fs/xfs/libxfs/xfs_dir2.c           |  20 ++--
 fs/xfs/libxfs/xfs_dir2_block.c     |   2 +-
 fs/xfs/libxfs/xfs_dir2_sf.c        |   8 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c   |   2 +-
 fs/xfs/libxfs/xfs_iext_tree.c      |  14 ++-
 fs/xfs/libxfs/xfs_inode_fork.c     |  32 +++---
 fs/xfs/libxfs/xfs_refcount.c       |   9 +-
 fs/xfs/libxfs/xfs_refcount_btree.c |   2 +-
 fs/xfs/libxfs/xfs_rmap.c           |   2 +-
 fs/xfs/libxfs/xfs_rmap_btree.c     |   2 +-
 fs/xfs/scrub/agheader.c            |   4 +-
 fs/xfs/scrub/attr.c                |  10 +-
 fs/xfs/scrub/attr.h                |   3 +-
 fs/xfs/scrub/bitmap.c              |   7 +-
 fs/xfs/scrub/btree.c               |   4 +-
 fs/xfs/scrub/fscounters.c          |   3 +-
 fs/xfs/scrub/refcount.c            |   4 +-
 fs/xfs/scrub/symlink.c             |   3 +-
 fs/xfs/xfs_acl.c                   |   3 +-
 fs/xfs/xfs_attr_inactive.c         |   2 +-
 fs/xfs/xfs_attr_list.c             |   2 +-
 fs/xfs/xfs_bmap_item.c             |   8 +-
 fs/xfs/xfs_buf.c                   |  35 +++---
 fs/xfs/xfs_buf_item.c              |  10 +-
 fs/xfs/xfs_dquot.c                 |  20 ++--
 fs/xfs/xfs_dquot_item.c            |   3 +-
 fs/xfs/xfs_error.c                 |   4 +-
 fs/xfs/xfs_extent_busy.c           |   3 +-
 fs/xfs/xfs_extfree_item.c          |  16 +--
 fs/xfs/xfs_filestream.c            |   2 +-
 fs/xfs/xfs_icache.c                |   6 +-
 fs/xfs/xfs_icreate_item.c          |   4 +-
 fs/xfs/xfs_inode.c                 |   4 +-
 fs/xfs/xfs_inode_item.c            |   5 +-
 fs/xfs/xfs_ioctl.c                 |   8 +-
 fs/xfs/xfs_ioctl32.c               |   3 +-
 fs/xfs/xfs_itable.c                |   8 +-
 fs/xfs/xfs_iwalk.c                 |   5 +-
 fs/xfs/xfs_log.c                   |  19 ++--
 fs/xfs/xfs_log_cil.c               |  10 +-
 fs/xfs/xfs_log_priv.h              |   2 +-
 fs/xfs/xfs_log_recover.c           |  24 ++--
 fs/xfs/xfs_mount.c                 |   7 +-
 fs/xfs/xfs_mru_cache.c             |   5 +-
 fs/xfs/xfs_qm.c                    |   6 +-
 fs/xfs/xfs_refcount_item.c         |  12 +-
 fs/xfs/xfs_rmap_item.c             |  12 +-
 fs/xfs/xfs_rtalloc.c               |   5 +-
 fs/xfs/xfs_super.c                 | 171 ++++++++++++++++-------------
 fs/xfs/xfs_trace.h                 |   1 -
 fs/xfs/xfs_trans.c                 |   6 +-
 fs/xfs/xfs_trans_ail.c             |   3 +-
 fs/xfs/xfs_trans_dquot.c           |   5 +-
 63 files changed, 353 insertions(+), 494 deletions(-)

--=20
2.23.0

