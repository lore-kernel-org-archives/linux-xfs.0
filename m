Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A86E9C48BE5
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Jun 2021 13:16:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8359961164
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Jun 2021 13:16:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbhFUNTD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Jun 2021 09:19:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59071 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229663AbhFUNTC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Jun 2021 09:19:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624281407;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=19UQ3nD1fqb9evHmIF5pt8XVqyIPe8VkrZC70Sv6Lm4=;
        b=SSp0P9wUm3QSnZXFze7oIWJYhnZVZm+8xr90rx1tO56noC/Q/wHpO3D6crnba0q2jCi8pw
        D3m+GIOSBCQRS4NtoYiOuR4eTLccfpY3X2Iu1p6WIJJ0maMHe+2hoqKYuP/Z0RqVvwZkni
        ZVLF2sdHqJdrnFF+rrOCT3gJVT4W2/o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-515-nl21A4znM-SUZpd95_rOzA-1; Mon, 21 Jun 2021 09:16:46 -0400
X-MC-Unique: nl21A4znM-SUZpd95_rOzA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3A3A7800D62
        for <linux-xfs@vger.kernel.org>; Mon, 21 Jun 2021 13:16:45 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-112-50.rdu2.redhat.com [10.10.112.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EB9CA19C46
        for <linux-xfs@vger.kernel.org>; Mon, 21 Jun 2021 13:16:44 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 0/2] xfs: fix buffer use after free on unpin abort
Date:   Mon, 21 Jun 2021 09:16:42 -0400
Message-Id: <20210621131644.128177-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

v2:
- Split assert in patch 2.
v1: https://lore.kernel.org/linux-xfs/20210511135257.878743-1-bfoster@redhat.com/
- Rework patch 1 to hold conditionally in the abort case and document
  the underlying design flaw.
- Add patch 2 to remove some unused code.
rfc: https://lore.kernel.org/linux-xfs/20210503121816.561340-1-bfoster@redhat.com/

Brian Foster (2):
  xfs: hold buffer across unpin and potential shutdown processing
  xfs: remove dead stale buf unpin handling code

 fs/xfs/xfs_buf_item.c | 58 +++++++++++++++++--------------------------
 1 file changed, 23 insertions(+), 35 deletions(-)

-- 
2.26.3

