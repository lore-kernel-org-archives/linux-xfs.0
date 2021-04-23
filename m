Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 173EEC433B4
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Apr 2021 13:10:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD60161476
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Apr 2021 13:10:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242584AbhDWNLb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Apr 2021 09:11:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20457 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242322AbhDWNLa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Apr 2021 09:11:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619183453;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=NWMTX1YWdYomHbu9x/l5fLi0UluhCIVsivYKMoVeJFU=;
        b=hgcS5M2jPKgp0cGB+VHy2NOM5oxKUpMz18eiGlEcM/fCS/knS9ZYsDxjy8SyH7N/g75OEY
        weTpTOANzN/8gahKKwdtS7ihA/LQqTVLMVezMSRbSPpokCPc70tPj74Wy6OAOeN9XUTIEd
        r6PvcYpqQBU4hK89KrV5vL+ogG/PhKo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-Sa3UjErqP1SiSRXXHFrD6g-1; Fri, 23 Apr 2021 09:10:51 -0400
X-MC-Unique: Sa3UjErqP1SiSRXXHFrD6g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 10DB8343A0
        for <linux-xfs@vger.kernel.org>; Fri, 23 Apr 2021 13:10:51 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-112-25.rdu2.redhat.com [10.10.112.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C2F0A60854
        for <linux-xfs@vger.kernel.org>; Fri, 23 Apr 2021 13:10:50 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 0/3] xfs: set aside allocation btree blocks from block reservation
Date:   Fri, 23 Apr 2021 09:10:47 -0400
Message-Id: <20210423131050.141140-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here's v4 of the proposed allocbt block set aside fix. The patches have
been swizzled around a bit based on previous feedback to try and avoid
confusion over what bits are perag res related and not. This hopefully
facilitates analysis when it comes time to evaluate potential changes to
remove the current perag res mount time AG header scan behavior on which
this currently depends. Otherwise the actual code changes from v3 are
fairly light and documented in the changelog below. Thoughts, reviews,
flames appreciated.

Brian

v4:
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
 fs/xfs/libxfs/xfs_alloc.c       | 12 ++++++++++++
 fs/xfs/libxfs/xfs_alloc_btree.c |  2 ++
 fs/xfs/xfs_mount.c              | 15 ++++++++++++++-
 fs/xfs/xfs_mount.h              |  6 ++++++
 5 files changed, 57 insertions(+), 12 deletions(-)

-- 
2.26.3

