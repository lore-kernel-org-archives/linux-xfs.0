Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 027E9C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 16:57:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE4A96143C
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 16:57:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241381AbhD1Q6A (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 12:58:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21933 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241290AbhD1Q57 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Apr 2021 12:57:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619629034;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=1A9dvF/iFHXckxOMHvqAMkS/gfmi+QW2BPLZpRbNLkI=;
        b=AA3mnqxSOAmbfiCqna+003SElEZtvflRbn9MkZL0D+2MhAZPBF7zcqkCb3Hz7zJ3fXZKmW
        Ibj6CW7Rcd1hwHvJR788JSGlGjQwi3JZxHD8WZHT6SF7XeB+jwYnk8Eh34mlvYcxsba4zg
        Ih32PbBnjz+p4cxGRkKuqUyxxV6lyTM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-447-9xvBA4ymNIWdznl-s2iwIw-1; Wed, 28 Apr 2021 12:57:12 -0400
X-MC-Unique: 9xvBA4ymNIWdznl-s2iwIw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 37432C7400
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 16:57:11 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-113-229.rdu2.redhat.com [10.10.113.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E9DCC5F9A6
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 16:57:10 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 0/3] xfs: set aside allocation btree blocks from block reservation
Date:   Wed, 28 Apr 2021 12:57:07 -0400
Message-Id: <20210428165710.385872-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

v5:
- Tweak allocbt counter init logic to filter out rmapbt root block.
v4: https://lore.kernel.org/linux-xfs/20210423131050.141140-1-bfoster@redhat.com/
- Fix up perag res logic to not skip pagf init on partial res failure.
- Split up set aside patch into separate counter mechanism and set aside
  policy patches.
- Drop unnecessary ->m_has_agresv flag as pagf's are always initialized
  on filesystems with active reservations.
v3: https://lore.kernel.org/linux-xfs/20210318161707.723742-1-bfoster@redhat.com/
- Use a mount flag for easy detection of active perag reservation.
- Filter rmapbt blocks from allocbt block accounting.
v2: https://lore.kernel.org/linux-xfs/20210222152108.896178-1-bfoster@redhat.com/
- Use an atomic counter instead of a percpu counter.
v1: https://lore.kernel.org/linux-xfs/20210217132339.651020-1-bfoster@redhat.com/

Brian Foster (3):
  xfs: unconditionally read all AGFs on mounts with perag reservation
  xfs: introduce in-core global counter of allocbt blocks
  xfs: set aside allocation btree blocks from block reservation

 fs/xfs/libxfs/xfs_ag_resv.c     | 34 ++++++++++++++++++++++-----------
 fs/xfs/libxfs/xfs_alloc.c       | 14 ++++++++++++++
 fs/xfs/libxfs/xfs_alloc_btree.c |  2 ++
 fs/xfs/xfs_mount.c              | 15 ++++++++++++++-
 fs/xfs/xfs_mount.h              |  6 ++++++
 5 files changed, 59 insertions(+), 12 deletions(-)

-- 
2.26.3

