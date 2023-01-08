Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27088C54EBE
	for <linux-xfs@archiver.kernel.org>; Sun,  8 Jan 2023 19:41:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233381AbjAHTlb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 8 Jan 2023 14:41:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233192AbjAHTla (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Jan 2023 14:41:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D664BAE7C
        for <linux-xfs@vger.kernel.org>; Sun,  8 Jan 2023 11:40:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673206842;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=RnHdpHKPjRbgtteLZNatBvGeLtifDpTNmLxdoQh5COI=;
        b=jFSJjzEZOuKsL4xMqS2BWz/Oqe6DArYl0GSRzLcjPaWD8Pdz3NYTMg7U8qi9oTltN+JT68
        YbD3lkW0AGOzu1Zj3OQSIhIrbBB6AOPKVRiGsRYkZ1s4IQyThgaRPenhv4K5809fj0WdCj
        txdckJAPL7GQcQvd/VDUbJSJj7Qv0PI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-323-FF6jQcO5NGGDMftbRaivlQ-1; Sun, 08 Jan 2023 14:40:38 -0500
X-MC-Unique: FF6jQcO5NGGDMftbRaivlQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0185F3C02B59;
        Sun,  8 Jan 2023 19:40:38 +0000 (UTC)
Received: from pasta.redhat.com (ovpn-192-3.brq.redhat.com [10.40.192.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CE474492B06;
        Sun,  8 Jan 2023 19:40:35 +0000 (UTC)
From:   Andreas Gruenbacher <agruenba@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <willy@infradead.org>
Cc:     Andreas Gruenbacher <agruenba@redhat.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, cluster-devel@redhat.com
Subject: [RFC v6 00/10] Turn iomap_page_ops into iomap_folio_ops
Date:   Sun,  8 Jan 2023 20:40:24 +0100
Message-Id: <20230108194034.1444764-1-agruenba@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Here's an updated version of this patch queue.  Changes since v5 [*]:

* A new iomap-internal __iomap_get_folio() helper was added.

* The previous iomap-internal iomap_put_folio() helper was renamed to
  __iomap_put_folio() to mirror __iomap_get_folio().

* The comment describing struct iomap_folio_ops was still referring to
  pages instead of folios in two places.

Is this good enough for iomap-for-next now, please?

Thanks,
Andreas

[*] https://lore.kernel.org/linux-xfs/20221231150919.659533-1-agruenba@redhat.com/

Andreas Gruenbacher (10):
  iomap: Add __iomap_put_folio helper
  iomap/gfs2: Unlock and put folio in page_done handler
  iomap: Rename page_done handler to put_folio
  iomap: Add iomap_get_folio helper
  iomap/gfs2: Get page in page_prepare handler
  iomap: Add __iomap_get_folio helper
  iomap: Rename page_prepare handler to get_folio
  iomap/xfs: Eliminate the iomap_valid handler
  iomap: Rename page_ops to folio_ops
  xfs: Make xfs_iomap_folio_ops static

 fs/gfs2/bmap.c         |  38 ++++++++++-----
 fs/iomap/buffered-io.c | 105 +++++++++++++++++++++++------------------
 fs/xfs/xfs_iomap.c     |  41 +++++++++++-----
 include/linux/iomap.h  |  50 +++++++++-----------
 4 files changed, 134 insertions(+), 100 deletions(-)

-- 
2.38.1

