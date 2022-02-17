Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B53EEC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Feb 2022 17:25:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240196AbiBQRZh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Feb 2022 12:25:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239214AbiBQRZg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Feb 2022 12:25:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 842082B1677
        for <linux-xfs@vger.kernel.org>; Thu, 17 Feb 2022 09:25:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645118721;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=LH9KZrKC0S8UbJ2Gof3yIKl7k+sQs5C5CWtZnNwEUhk=;
        b=Qwlp9uAcNJ6cMrEP7LiSUrUzqsLyMyXNJWwptxKoEuZWFxM8ZZhlNZ79HyCsahCTr3cIZA
        ybP8bb6j4Ny/q0DW3N6xQ5ImpWKe+jwN2IsnBTgSeFMAUfpKnGOvMC3H6N7I+GGjUh8Ef4
        zeppMh65+Jw3iwWYLi7FofuTmNERC+A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-343-vmbpT6jwOx2ZpNQOT_IyWA-1; Thu, 17 Feb 2022 12:25:20 -0500
X-MC-Unique: vmbpT6jwOx2ZpNQOT_IyWA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 74F1F801ADB
        for <linux-xfs@vger.kernel.org>; Thu, 17 Feb 2022 17:25:19 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.110])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F32A2DE6F
        for <linux-xfs@vger.kernel.org>; Thu, 17 Feb 2022 17:25:19 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH RFC 0/4] xfs: track and skip realloc of busy inodes
Date:   Thu, 17 Feb 2022 12:25:14 -0500
Message-Id: <20220217172518.3842951-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This RFC cleans up some of the previous experimentation I was doing and
turns it into more of a usable prototype. The first couple of patches
are pretty straightforward. Patch 1 is a variant of the previously
posted patch to stamp inodes with a grace period at destroy time. Patch
2 tags inodes with still pending grace periods as busy in the radix
tree. Patch 3 is a quick hack to allow the inode selection algorithms to
fall back to chunk allocation and retry. Patch 4 updates the finobt
selection algorithms to filter records with busy inodes and fall back to
chunk allocation until a usable record is found.

The current status of this work is that it should be functionally
effective in terms of preventing allocation of busy inodes. This can be
measured by lack of RCU stalls, also identified by the tracepoint added
in patch 1 (this should probably assert or warn in the new inode
allocation recycle case since the goal is for that to never happen).
Performance is significantly improved from previous tests with only
patch 1, but still reduced from mainline. However, reduced performance
is to be expected because mainline unsafely reuses inodes rather
aggressively. Therefore, the goal is for something that
preserves/maintains closer to pure inode allocation performance.

I expect that the allocation algorithm can be adapted further to provide
incremental improvements in performance. The first and most obvious step
is to defer freeing of inode chunks to the background to mitigate
repetitive finobt search failure -> new chunk allocation retry sequences
that may be seen with the current prototype. Other improvements may be
possible to make the search algorithm itself more effective. I'm sending
this as a prototype for early feedback and thoughts on approach,
prospective improvements, etc. Thoughts, reviews, flames appreciated.

Brian

Brian Foster (4):
  xfs: require an rcu grace period before inode recycle
  xfs: tag reclaimable inodes with pending RCU grace periods as busy
  xfs: crude chunk allocation retry mechanism
  xfs: skip busy inodes on finobt inode allocation

 fs/xfs/libxfs/xfs_ialloc.c | 99 +++++++++++++++++++++++++++++++++++---
 fs/xfs/xfs_icache.c        | 55 +++++++++++++++++----
 fs/xfs/xfs_inode.h         |  3 +-
 fs/xfs/xfs_trace.h         |  8 ++-
 4 files changed, 146 insertions(+), 19 deletions(-)

-- 
2.31.1

