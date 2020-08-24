Return-Path: <SRS0=BK4F=CC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFA2EC433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 15:26:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A35B92074D
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 15:26:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mYU+Wo1z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbgHXPQB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Aug 2020 11:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726697AbgHXPG5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Aug 2020 11:06:57 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D83E8C06179A;
        Mon, 24 Aug 2020 07:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=rtPWePEP2e2MrA1B6+d56D/W6SCtPdzXjGVhB68Hm9E=; b=mYU+Wo1zHLWgAf8PtstxsMTzeM
        l89zOmYzJ4RAebFtunciW1qLOccTUYbRyCdTC0HFhRUaFysVsGgifHdVuV+nAICugexygDYupVHqV
        Pgx88p5wQgJt3gvzhQmSRhuRsWVxpyeb3EOAahpwBmkUxMJssYiXiFutGNnBlHme91mw0lrufX/dt
        bx5Jm4KquFZu8cyiMXr7xv+0CHqsS7c/CnzDPyx3OGlyMbSVg+plp6m2GJXAthNPGuz3oVbU9HsFS
        C9b1dq1AShibohWaSk/lWESu2oP6BM+zNJFGDBsrG1QOBj4Tc/Kwcp9qKnijfzIHWXVdM+9wKdOXa
        ZIB2/1BA==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kADsO-0002lr-Li; Mon, 24 Aug 2020 14:55:12 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/9] THP iomap patches for 5.10
Date:   Mon, 24 Aug 2020 15:55:01 +0100
Message-Id: <20200824145511.10500-1-willy@infradead.org>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

These patches are carefully plucked from the THP series.  I would like
them to hit 5.10 to make the THP patchset merge easier.  Some of these
are just generic improvements that make sense on their own terms, but
the overall intent is to support THPs in iomap.

I'll send another patch series later today which are the changes to
iomap which don't pay their own way until we actually have THPs in the
page cache.  I would like those to be reviewed with an eye to merging
them into 5.11.

Matthew Wilcox (Oracle) (9):
  iomap: Fix misplaced page flushing
  fs: Introduce i_blocks_per_page
  iomap: Use kzalloc to allocate iomap_page
  iomap: Use bitmap ops to set uptodate bits
  iomap: Support arbitrarily many blocks per page
  iomap: Convert read_count to byte count
  iomap: Convert write_count to byte count
  iomap: Convert iomap_write_end types
  iomap: Change calling convention for zeroing

 fs/dax.c                |  13 ++--
 fs/iomap/buffered-io.c  | 145 ++++++++++++++++------------------------
 fs/jfs/jfs_metapage.c   |   2 +-
 fs/xfs/xfs_aops.c       |   2 +-
 include/linux/dax.h     |   3 +-
 include/linux/pagemap.h |  16 +++++
 6 files changed, 83 insertions(+), 98 deletions(-)

-- 
2.28.0

