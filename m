Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1737C43460
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Apr 2021 13:31:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C16CE6128E
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Apr 2021 13:31:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241773AbhDLNb2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Apr 2021 09:31:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60145 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241897AbhDLNbW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Apr 2021 09:31:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618234264;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=XEWWmD0ungC6TgjggK7gXVOBlVpum9aDYbbxHHubWls=;
        b=hCS/b5TSDJTqxKGIKpVAsfhwQD/zqGcvaLjgB+AhByo/CEZNd16JgEAbWMFzJh3eB3gwGI
        /9aPKMERxZP3yqo5BIpCIJN7RWdA8OEtB5qA5cG2m5G1dMNJQFpuIEE7zdEex0pcn9rJIr
        ghYnMEBxbvtFgWU+MVrXSbBFv9LWubE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-183-etCjjOFpNRyGH5eMmUX1Ng-1; Mon, 12 Apr 2021 09:31:01 -0400
X-MC-Unique: etCjjOFpNRyGH5eMmUX1Ng-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8B49A8189E3
        for <linux-xfs@vger.kernel.org>; Mon, 12 Apr 2021 13:31:00 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-112-117.rdu2.redhat.com [10.10.112.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 439415C1BB
        for <linux-xfs@vger.kernel.org>; Mon, 12 Apr 2021 13:31:00 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 REPOST 0/2] xfs: set aside allocation btree blocks from block reservation
Date:   Mon, 12 Apr 2021 09:30:57 -0400
Message-Id: <20210412133059.1186634-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

There's been a decent amount of discussion on v3 of the series but
AFAIA, nothing that has materialized into changes to these two patches.
This is just a repost of v3 to bump the series.

Brian

v3: https://lore.kernel.org/linux-xfs/20210318161707.723742-1-bfoster@redhat.com/
- Use a mount flag for easy detection of active perag reservation.
- Filter rmapbt blocks from allocbt block accounting.
v2: https://lore.kernel.org/linux-xfs/20210222152108.896178-1-bfoster@redhat.com/
- Use an atomic counter instead of a percpu counter.
v1: https://lore.kernel.org/linux-xfs/20210217132339.651020-1-bfoster@redhat.com/

Brian Foster (2):
  xfs: set a mount flag when perag reservation is active
  xfs: set aside allocation btree blocks from block reservation

 fs/xfs/libxfs/xfs_ag_resv.c     | 24 ++++++++++++++----------
 fs/xfs/libxfs/xfs_alloc.c       | 12 ++++++++++++
 fs/xfs/libxfs/xfs_alloc_btree.c |  2 ++
 fs/xfs/xfs_mount.c              | 18 +++++++++++++++++-
 fs/xfs/xfs_mount.h              |  7 +++++++
 5 files changed, 52 insertions(+), 11 deletions(-)

-- 
2.26.3

