Return-Path: <SRS0=BK4F=CC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A164CC433E1
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 15:24:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F0392074D
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 15:24:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="O4ub1tEV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbgHXPXq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Aug 2020 11:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727836AbgHXPR4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Aug 2020 11:17:56 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1DFEC061799;
        Mon, 24 Aug 2020 08:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=vg63jAHJfG2SzXwAA4F8u4EABDJK8kFbtsgiuvgE/iE=; b=O4ub1tEVsA9kU09ZzyqjnYqLiE
        qd3Ogz447N5q6xe5QqJS6PetMeBFjPO8xP+KShjzwd1fzVYDV5AxzmXJ2pZNJbaMyNX8vto74+uEK
        cf0Fy7D0KkJe38ALG6R99zIFxNQHnKdG1FCEXgGVfyoKHrHt/oBmeVmO5rmIFU1WDzmck7Qzjz7ZB
        hLDNe1ccAKsDBIq3z5d08YmyqEnWEC7g+OhGVVrKgshg9aSK0pVTV+OrnwCM7ssLztd7swOuJ/3HT
        Rgx+o/1FRjyEKjjwSGvGeEvWOt8uyfl3atffNAhwVuMon7a8+hOuLJBonyWCRmc/BdzF7+QOwogOm
        Hg7OajcA==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kAEDW-0004CN-5w; Mon, 24 Aug 2020 15:17:02 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-block@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 00/11] iomap/fs/block patches for 5.11
Date:   Mon, 24 Aug 2020 16:16:49 +0100
Message-Id: <20200824151700.16097-1-willy@infradead.org>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

As promised earlier [1], here are the patches which I would like to
merge into 5.11 to support THPs.  They depend on that earlier series.
If there's anything in here that you'd like to see pulled out and added
to that earlier series, let me know.

There are a couple of pieces in here which aren't exactly part of
iomap, but I think make sense to take through the iomap tree.

[1] https://lore.kernel.org/linux-fsdevel/20200824145511.10500-1-willy@infradead.org/

Matthew Wilcox (Oracle) (11):
  fs: Make page_mkwrite_check_truncate thp-aware
  mm: Support THPs in zero_user_segments
  mm: Zero the head page, not the tail page
  block: Add bio_for_each_thp_segment_all
  iomap: Support THPs in iomap_adjust_read_range
  iomap: Support THPs in invalidatepage
  iomap: Support THPs in read paths
  iomap: Change iomap_write_begin calling convention
  iomap: Support THPs in write paths
  iomap: Inline data shouldn't see THPs
  iomap: Handle tail pages in iomap_page_mkwrite

 fs/iomap/buffered-io.c  | 178 ++++++++++++++++++++++++----------------
 include/linux/bio.h     |  13 +++
 include/linux/bvec.h    |  27 ++++++
 include/linux/highmem.h |  15 +++-
 include/linux/pagemap.h |  10 +--
 mm/highmem.c            |  62 +++++++++++++-
 mm/shmem.c              |   7 ++
 mm/truncate.c           |   7 ++
 8 files changed, 236 insertions(+), 83 deletions(-)

-- 
2.28.0

