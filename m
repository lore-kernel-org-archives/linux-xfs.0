Return-Path: <SRS0=ArDI=ZM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E8B8C432C0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 10:44:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4DDC2243F
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 10:44:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZXev6z/O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728808AbfKTKoe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Nov 2019 05:44:34 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:29889 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728777AbfKTKoe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Nov 2019 05:44:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574246672;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=VmlsM2woq6XwR5nLpbXc7Dtt/8TsaAO31eoqEXCJFq8=;
        b=ZXev6z/OufF0sIHSqhuLgrRTuhLF1a40k7w5vLnyOONFpwZp+Kss6F3ItJkia+yLr8/RZj
        5VWWkdFFi6+EerR2Ob0Y7nC1JRgZvbIHAtda7BRDtBygyPC9rv1yu7Sg6dMx8fUQi88lZi
        hLSPQpiISrvcHFhyZsq/T8XmpszKit0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-v0WNjSChO2e5RNOAMTHMow-1; Wed, 20 Nov 2019 05:44:31 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 834F98024C0
        for <linux-xfs@vger.kernel.org>; Wed, 20 Nov 2019 10:44:30 +0000 (UTC)
Received: from orion.redhat.com (ovpn-204-164.brq.redhat.com [10.40.204.164])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB64266D4D
        for <linux-xfs@vger.kernel.org>; Wed, 20 Nov 2019 10:44:29 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/5] Remove/convert more kmem_* wrappers
Date:   Wed, 20 Nov 2019 11:44:20 +0100
Message-Id: <20191120104425.407213-1-cmaiolino@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: v0WNjSChO2e5RNOAMTHMow-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

in this new series, we remove most of the remaining kmem_* wrappers.

All of the wrappers being removed in this series can be directly replaced b=
y
generic kernel kmalloc()/kzalloc() interface.

Only interface kept is kmem_alloc() but has been converted into a local hel=
per.

This series should be applied on top of my previous series aiming to clean =
up
our memory allocation interface.


Darrick, I believe this is slightly different from what you suggested
previously, about converting kmem_* interfaces to use GFP flags directly. A=
t
least I read that as keeping current kmem_* interface, and getting rid of K=
M_*
flags now.

But, I believe these patches does not change any allocation logic, and afte=
r the
series we are left with fewer users of KM_* flags users to get rid of, whic=
h
IMHO will be easier. And also I already had the patches mostly done :)

Let me know if this is ok for you.


Carlos Maiolino (5):
  xfs: remove kmem_zone_zalloc()
  xfs: Remove kmem_zone_alloc() wrapper
  xfs: remove kmem_zalloc() wrapper
  xfs: Remove kmem_realloc
  xfs: Convert kmem_alloc() users

 fs/xfs/kmem.c                      | 51 +++---------------------------
 fs/xfs/kmem.h                      | 16 ----------
 fs/xfs/libxfs/xfs_alloc.c          |  3 +-
 fs/xfs/libxfs/xfs_alloc_btree.c    |  2 +-
 fs/xfs/libxfs/xfs_attr_leaf.c      |  9 +++---
 fs/xfs/libxfs/xfs_bmap.c           |  8 +++--
 fs/xfs/libxfs/xfs_bmap_btree.c     |  2 +-
 fs/xfs/libxfs/xfs_da_btree.c       | 16 +++++-----
 fs/xfs/libxfs/xfs_defer.c          |  4 +--
 fs/xfs/libxfs/xfs_dir2.c           | 29 ++++++++---------
 fs/xfs/libxfs/xfs_dir2_block.c     |  2 +-
 fs/xfs/libxfs/xfs_dir2_sf.c        |  8 ++---
 fs/xfs/libxfs/xfs_ialloc_btree.c   |  2 +-
 fs/xfs/libxfs/xfs_iext_tree.c      | 14 +++++---
 fs/xfs/libxfs/xfs_inode_fork.c     | 26 ++++++++-------
 fs/xfs/libxfs/xfs_refcount.c       |  9 +++---
 fs/xfs/libxfs/xfs_refcount_btree.c |  2 +-
 fs/xfs/libxfs/xfs_rmap.c           |  2 +-
 fs/xfs/libxfs/xfs_rmap_btree.c     |  2 +-
 fs/xfs/scrub/agheader.c            |  4 +--
 fs/xfs/scrub/bitmap.c              |  7 ++--
 fs/xfs/scrub/btree.c               |  4 +--
 fs/xfs/scrub/fscounters.c          |  3 +-
 fs/xfs/scrub/refcount.c            |  4 +--
 fs/xfs/xfs_attr_inactive.c         |  2 +-
 fs/xfs/xfs_attr_list.c             |  2 +-
 fs/xfs/xfs_bmap_item.c             |  4 +--
 fs/xfs/xfs_buf.c                   | 13 ++++----
 fs/xfs/xfs_buf_item.c              |  6 ++--
 fs/xfs/xfs_dquot.c                 |  2 +-
 fs/xfs/xfs_dquot_item.c            |  3 +-
 fs/xfs/xfs_error.c                 |  4 +--
 fs/xfs/xfs_extent_busy.c           |  3 +-
 fs/xfs/xfs_extfree_item.c          | 12 ++++---
 fs/xfs/xfs_filestream.c            |  2 +-
 fs/xfs/xfs_icache.c                |  2 +-
 fs/xfs/xfs_icreate_item.c          |  2 +-
 fs/xfs/xfs_inode.c                 |  4 +--
 fs/xfs/xfs_inode_item.c            |  3 +-
 fs/xfs/xfs_itable.c                |  8 ++---
 fs/xfs/xfs_iwalk.c                 |  5 +--
 fs/xfs/xfs_log.c                   | 12 ++++---
 fs/xfs/xfs_log_cil.c               |  8 ++---
 fs/xfs/xfs_log_priv.h              |  2 +-
 fs/xfs/xfs_log_recover.c           | 21 ++++++------
 fs/xfs/xfs_mount.c                 |  7 ++--
 fs/xfs/xfs_mru_cache.c             |  5 +--
 fs/xfs/xfs_qm.c                    |  6 ++--
 fs/xfs/xfs_refcount_item.c         |  9 +++---
 fs/xfs/xfs_rmap_item.c             |  8 +++--
 fs/xfs/xfs_rtalloc.c               |  2 +-
 fs/xfs/xfs_super.c                 |  2 +-
 fs/xfs/xfs_trace.h                 |  1 -
 fs/xfs/xfs_trans.c                 |  4 +--
 fs/xfs/xfs_trans_ail.c             |  3 +-
 fs/xfs/xfs_trans_dquot.c           |  3 +-
 56 files changed, 185 insertions(+), 214 deletions(-)

--=20
2.23.0

