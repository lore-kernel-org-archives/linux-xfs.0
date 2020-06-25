Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB964C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 11:32:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A8E3207BB
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 11:32:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Zx7Sk3eW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404348AbgFYLcD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Jun 2020 07:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404307AbgFYLcD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jun 2020 07:32:03 -0400
Received: from casper.infradead.org (unknown [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E7EC0613ED;
        Thu, 25 Jun 2020 04:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=PjLLzO5wQx4wfZk2ZFJ+pm83Fj4QCXS9gP5VY0PaHDw=; b=Zx7Sk3eWFBCqBBKuXfyhQVg1oF
        p7gH6cmsdzHqccPJNmpdxOgl+sgwG0t124w9Vt1rfWolBA8f6Ma7ukSQDNLgDtr5kv7v3vguaCOj7
        kZfbKlZwEdbKzBVFjTfJDEkeCUS+jYZDRuHHzovsz5avw4TB0coAvIshYYCJ41AacBH2Cz5Y16fZ/
        RDSekd4aMUBtGb1n5EvPDhfgVarHL3+GKCEVe1bjV8w/eYepzlb94jTN99YTCRWSK3BPHVyNJTWtj
        IgYlgl5RfI1xFiri9/L9YNG6SDSIDLiigCypddZG9gE845s3O1Gd6rXSm+S4Q9SNyV9IVM5Pqc/r8
        9pJ3FfIw==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1joQ6W-0001zL-Ff; Thu, 25 Jun 2020 11:31:40 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-xfs@vger.kernel.org, dm-devel@redhat.com,
        Mikulas Patocka <mpatocka@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>
Subject: [PATCH 0/6] Overhaul memalloc_no*
Date:   Thu, 25 Jun 2020 12:31:16 +0100
Message-Id: <20200625113122.7540-1-willy@infradead.org>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I want a memalloc_nowait like we have memalloc_noio and memalloc_nofs
for an upcoming patch series, and Jens also wants it for non-blocking
io_uring.  It turns out we already have dm-bufio which could benefit
from memalloc_nowait, so it may as well go into the tree now.

The biggest problem is that we're basically out of PF_ flags, so we need
to find somewhere else to store the PF_MEMALLOC_NOWAIT flag.  It turns
out the PF_ flags are really supposed to be used for flags which are
accessed from other tasks, and the MEMALLOC flags are only going to
be used by this task.  So shuffling everything around frees up some PF
flags and generally makes the world a better place.

Patch series also available from
http://git.infradead.org/users/willy/linux.git/shortlog/refs/heads/memalloc

Matthew Wilcox (Oracle) (6):
  mm: Replace PF_MEMALLOC_NOIO with memalloc_noio
  mm: Add become_kswapd and restore_kswapd
  xfs: Convert to memalloc_nofs_save
  mm: Replace PF_MEMALLOC_NOFS with memalloc_nofs
  mm: Replace PF_MEMALLOC_NOIO with memalloc_nocma
  mm: Add memalloc_nowait

 drivers/block/loop.c           |  3 +-
 drivers/md/dm-bufio.c          | 30 ++++--------
 drivers/md/dm-zoned-metadata.c |  5 +-
 fs/iomap/buffered-io.c         |  2 +-
 fs/xfs/kmem.c                  |  2 +-
 fs/xfs/libxfs/xfs_btree.c      | 14 +++---
 fs/xfs/xfs_aops.c              |  4 +-
 fs/xfs/xfs_buf.c               |  2 +-
 fs/xfs/xfs_linux.h             |  6 ---
 fs/xfs/xfs_trans.c             | 14 +++---
 fs/xfs/xfs_trans.h             |  2 +-
 include/linux/sched.h          |  7 +--
 include/linux/sched/mm.h       | 84 ++++++++++++++++++++++++++--------
 kernel/sys.c                   |  8 ++--
 mm/vmscan.c                    | 16 +------
 15 files changed, 105 insertions(+), 94 deletions(-)

-- 
2.27.0

