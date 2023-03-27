Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C6F1C76195
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Mar 2023 17:45:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbjC0Rph (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Mar 2023 13:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbjC0Rpf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Mar 2023 13:45:35 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5830D199F;
        Mon, 27 Mar 2023 10:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=aQoxK5bb3Ohj4wJwxB+pr91NWfdUFrQCSHmRCFwcTDI=; b=pL1HS0Vi5KNmMOvGFuFYKGyM7r
        RsRG6kESDdHW3rUE914SVA3v4+ORiCdJhgEXpKzxb0r1OYeOb9YL04JZ5P75ET62PLuGsFK8ikaUs
        YkCjV5/EQJXciHGuL7KFMg/ObjTqn45UygqJCJ5p+X0r5zOCqwI5uwL0kkvZM0gB7P7+B3rze6n8G
        hrXufeB7Jmfac8IZYbZOWf02r4k4kJ5iXnR/fzuocp26M94/gyQJVF8NQqzWlZRsP7LazJrIXH8Y4
        Mxn9B7y/NJSjReinYvyK+0zEtOaWQdqcdCNB6ZJfId/4ogXaniqasz0+V30rRHPOz8q895SBprFkM
        q/Hp9rEA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pgquI-007bGS-7C; Mon, 27 Mar 2023 17:45:22 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-xfs@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v2 0/3] Prevent ->map_pages from sleeping
Date:   Mon, 27 Mar 2023 18:45:12 +0100
Message-Id: <20230327174515.1811532-1-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In preparation for a larger patch series which will handle (some, easy)
page faults protected only by RCU, change the two filesystems which have
sleeping locks to not take them and hold the RCU lock around calls to
->map_page to prevent other filesystems from adding sleeping locks.

v2:
 - Add tags from David Howells
 - Go into more detail about the locking in the XFS patch

Matthew Wilcox (Oracle) (3):
  xfs: Remove xfs_filemap_map_pages() wrapper
  afs: Split afs_pagecache_valid() out of afs_validate()
  mm: Hold the RCU read lock over calls to ->map_pages

 Documentation/filesystems/locking.rst |  4 ++--
 fs/afs/file.c                         | 14 ++------------
 fs/afs/inode.c                        | 27 +++++++++++++++++++--------
 fs/afs/internal.h                     |  1 +
 fs/xfs/xfs_file.c                     | 17 +----------------
 mm/memory.c                           | 11 ++++++++---
 6 files changed, 33 insertions(+), 41 deletions(-)

-- 
2.39.2

