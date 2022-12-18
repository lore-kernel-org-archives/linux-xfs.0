Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 222B1C4332F
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Dec 2022 22:11:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbiLRWLw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Dec 2022 17:11:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiLRWLv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Dec 2022 17:11:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D5510D0
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 14:11:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671401461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hSKP4WbWgB/zC73JeMrFU10HKsrDmKDAGSlTQQONUe8=;
        b=UgopPT87m07YoeKFW2odRO4oxEyNBPolEhKbaycfw9pivs47HTYub9ofQG7PJp9JcSrKCE
        Po3/tehQFsm37w5Y7TkUtMMYtXaZHrFqhTNCJDa7UPJ0BPQWx91N5rXw++SVtCnW8QiDP4
        6wXjbjIvQyz6gB7UxqS8lrLyV3Vvqmc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-568-IZQb1PUaPhueqY7O5d6ozw-1; Sun, 18 Dec 2022 17:10:57 -0500
X-MC-Unique: IZQb1PUaPhueqY7O5d6ozw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4E6A21C068C6;
        Sun, 18 Dec 2022 22:10:57 +0000 (UTC)
Received: from pasta.redhat.com (ovpn-192-22.brq.redhat.com [10.40.192.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2F1AC2166B26;
        Sun, 18 Dec 2022 22:10:55 +0000 (UTC)
From:   Andreas Gruenbacher <agruenba@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <willy@infradead.org>
Cc:     Andreas Gruenbacher <agruenba@redhat.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, cluster-devel@redhat.com
Subject: [RFC v4 0/7] Turn iomap_page_ops into iomap_folio_ops
Date:   Sun, 18 Dec 2022 23:10:47 +0100
Message-Id: <20221218221054.3946886-1-agruenba@redhat.com>
In-Reply-To: <20221216150626.670312-1-agruenba@redhat.com>
References: <20221216150626.670312-1-agruenba@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Here's an updated version that changes iomap_folio_prepare() to return
an ERR_PTR() instead of NULL when the folio cannot be obtained as
suggested by Matthew Wilcox.

Thanks,
Andreas

Andreas Gruenbacher (7):
  fs: Add folio_may_straddle_isize helper
  iomap: Add iomap_folio_done helper
  iomap/gfs2: Unlock and put folio in page_done handler
  iomap: Add iomap_folio_prepare helper
  iomap/gfs2: Get page in page_prepare handler
  iomap/xfs: Eliminate the iomap_valid handler
  iomap: Rename page_ops to folio_ops

 fs/buffer.c            |  5 +--
 fs/ext4/inode.c        | 13 +++---
 fs/gfs2/bmap.c         | 43 ++++++++++++------
 fs/iomap/buffered-io.c | 98 ++++++++++++++++++++++--------------------
 fs/xfs/xfs_iomap.c     | 42 ++++++++++++------
 include/linux/iomap.h  | 46 +++++++-------------
 include/linux/mm.h     |  2 +
 mm/truncate.c          | 35 +++++++++++++++
 8 files changed, 172 insertions(+), 112 deletions(-)

-- 
2.38.1

