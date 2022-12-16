Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC62AC3DA71
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Dec 2022 15:07:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbiLPPHo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Dec 2022 10:07:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231324AbiLPPHW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Dec 2022 10:07:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4614526C1
        for <linux-xfs@vger.kernel.org>; Fri, 16 Dec 2022 07:06:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671203193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=+u0GILR+K9NlvYK7wKkYXg0kWtYj9HkTrgQnClsscW4=;
        b=f/p9KJBclcmdUvu+l3Xx+lE3EqW//npgfk9vK8MdMhhX58DLUPE1qb4FZ+9BJL+Ddbef+j
        3gM0hXGDRBj9EJOvREfEiK5fvZ9AzAAVGmNe7Qs+XoW8/SgrBraX6W0wiS6YlDz+PFkmbA
        Sm/aJlAqQbVL+FY3Yb5LraNj2qbTDXU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-59-vjJE4hp5Pemote4bu_3TBQ-1; Fri, 16 Dec 2022 10:06:30 -0500
X-MC-Unique: vjJE4hp5Pemote4bu_3TBQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7301C101A521;
        Fri, 16 Dec 2022 15:06:29 +0000 (UTC)
Received: from pasta.redhat.com (ovpn-192-182.brq.redhat.com [10.40.192.182])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 31F5414171C0;
        Fri, 16 Dec 2022 15:06:26 +0000 (UTC)
From:   Andreas Gruenbacher <agruenba@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <willy@infradead.org>
Cc:     Andreas Gruenbacher <agruenba@redhat.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, cluster-devel@redhat.com
Subject: [RFC v3 0/7] Turn iomap_page_ops into iomap_folio_ops
Date:   Fri, 16 Dec 2022 16:06:19 +0100
Message-Id: <20221216150626.670312-1-agruenba@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an updated proposal for changing the iomap page_ops operations
to make them more flexible so that they better suite the filesystem
needs.  It closes a race on gfs2 and cleans up the recent iomap changes
merged in the following upstream commit:

87be949912ee ("Merge tag 'xfs-6.2-merge-8' of git://git.kernel.org/pub/scm/fs/xfs/xfs-linux")

The first patch introduces a folio_may_straddle_isize() helper as a
replacement for pagecache_isize_extended() when we have a locked folio.
This still needs independent verification, but it looks like a
worthwhile improvement to me.  I've left it in this patch queue for now,
but I can moved out of the way if prefered.

Any thoughts?

Thanks,
Andreas

Andreas Gruenbacher (7):
  fs: Add folio_may_straddle_isize helper
  iomap: Add iomap_folio_done helper
  iomap/gfs2: Unlock and put folio in page_done handler
  iomap: Add iomap_folio_prepare helper
  iomap: Get page in page_prepare handler
  iomap/xfs: Eliminate the iomap_valid handler
  iomap: Rename page_ops to folio_ops

 fs/buffer.c            |  5 +--
 fs/ext4/inode.c        | 13 +++---
 fs/gfs2/bmap.c         | 43 +++++++++++++------
 fs/iomap/buffered-io.c | 95 +++++++++++++++++++++---------------------
 fs/xfs/xfs_iomap.c     | 42 +++++++++++++------
 include/linux/iomap.h  | 46 +++++++-------------
 include/linux/mm.h     |  2 +
 mm/truncate.c          | 35 ++++++++++++++++
 8 files changed, 169 insertions(+), 112 deletions(-)

-- 
2.38.1

