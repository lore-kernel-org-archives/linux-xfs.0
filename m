Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0277EC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Mar 2021 16:18:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C270164F3B
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Mar 2021 16:18:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbhCRQRi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Mar 2021 12:17:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49643 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232016AbhCRQRL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Mar 2021 12:17:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616084231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=sezvUerGmB166P2gSimUqGITT13hHZWdObxWprcfVgQ=;
        b=bFh+Da2HxFJx69qDxk84migdvGchLrIaJ+sLhUiVNB5c8+O/QPKkwPiuY+CdTKLM3809k3
        J1ZHajEgzRlWsgbqU9rMuom8jF1501Lz/7jGM6jIRbGgov9bLbW8syTJ643tG9gu0SFYpF
        I+TKT/7lCRH9lcF2/BrY9OOTOzFsFTc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-500-9DCPLXdqOsy_Y8srP7baEQ-1; Thu, 18 Mar 2021 12:17:09 -0400
X-MC-Unique: 9DCPLXdqOsy_Y8srP7baEQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E87F1007474
        for <linux-xfs@vger.kernel.org>; Thu, 18 Mar 2021 16:17:08 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-112-124.rdu2.redhat.com [10.10.112.124])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D303B60CD7
        for <linux-xfs@vger.kernel.org>; Thu, 18 Mar 2021 16:17:07 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 0/2] xfs: set aside allocation btree blocks from block reservation
Date:   Thu, 18 Mar 2021 12:17:05 -0400
Message-Id: <20210318161707.723742-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This is v3 of the allocbt block set aside fixup. The primary change in
v3 is to filter out rmapbt blocks from the usage accounting. rmapbt
blocks live in free space similar to allocbt blocks, but are managed
appropriately via perag reservation and so should not be set aside from
reservation requests.

Brian

v3:
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
2.26.2

