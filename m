Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A6A3C43461
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Apr 2021 14:12:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 012A161184
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Apr 2021 14:12:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233828AbhDIOM2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Apr 2021 10:12:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54291 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232395AbhDIOM1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Apr 2021 10:12:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617977534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=TgegjzEbx7XPMdmvWqsl8GqM1iD8hTokw8OO68odl7k=;
        b=chN5s0PWXd62ru6PHCjcsNG2FiIIE9SZMBGUEaISeQfs7sXWLpoeJSav6DO7PEYpNGXgo0
        l2kXZopsI/VIaubgyOY8naOJ8ZDGjshYEcILjJYBZ+VE3cuy5yGp8Nw5ov6bTc27PBMnh5
        67QnHS4bKtHv4BA3L2jCrjCG26kQEFI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-163-MFTwDSBcNuCP-qhO6J8m-Q-1; Fri, 09 Apr 2021 10:12:12 -0400
X-MC-Unique: MFTwDSBcNuCP-qhO6J8m-Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1C78F84B9A1
        for <linux-xfs@vger.kernel.org>; Fri,  9 Apr 2021 14:12:11 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-112-117.rdu2.redhat.com [10.10.112.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D31AD6064B
        for <linux-xfs@vger.kernel.org>; Fri,  9 Apr 2021 14:12:10 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 0/5] xfs: ioend batching log reservation deadlock
Date:   Fri,  9 Apr 2021 10:12:05 -0400
Message-Id: <20210409141210.1000155-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

v2:
- Added iomap patch to remove unused ioend->io_private.
- Moved done label in xfs_end_ioend().
v1: https://lore.kernel.org/linux-xfs/20210405145903.629152-1-bfoster@redhat.com/
RFD: https://lore.kernel.org/linux-xfs/YF4AOto30pC%2F0FYW@bfoster/

Brian Foster (5):
  xfs: drop submit side trans alloc for append ioends
  xfs: open code ioend needs workqueue helper
  xfs: drop unused ioend private merge and setfilesize code
  xfs: drop unnecessary setfilesize helper
  iomap: remove unused private field from ioend

 fs/iomap/buffered-io.c |   7 +--
 fs/xfs/xfs_aops.c      | 129 +++++------------------------------------
 include/linux/iomap.h  |   5 +-
 3 files changed, 17 insertions(+), 124 deletions(-)

-- 
2.26.3

