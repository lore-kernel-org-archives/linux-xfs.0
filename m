Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E89EDC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Apr 2022 14:12:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1448257AbiDVOPZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Apr 2022 10:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443862AbiDVOPY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Apr 2022 10:15:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9041B5A5B1
        for <linux-xfs@vger.kernel.org>; Fri, 22 Apr 2022 07:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650636749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=b4vVy2X/vSkmkisOYCtbR9YKcPHrgPRgzrCQb4ctjhU=;
        b=M0F8t95EZ3rqjgFz4bePjZASSk/m9Q2CLapoR4Az71Rq8T1V+W9FXg+DYfP1En55wuhgnt
        rLuwue2BtgIY4Ujn2HrU9xqv30aYSJTDljUJv8IWnas40h0YudOYNx4jnsObSHcw7iko5R
        4NDivGiVmGvIufxCxEtXrSXfwZboDKY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-336-2iM9K-EDMJi8v9NTYgS1Aw-1; Fri, 22 Apr 2022 10:12:27 -0400
X-MC-Unique: 2iM9K-EDMJi8v9NTYgS1Aw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B6DCD83397A
        for <linux-xfs@vger.kernel.org>; Fri, 22 Apr 2022 14:12:26 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9C8BA41636B
        for <linux-xfs@vger.kernel.org>; Fri, 22 Apr 2022 14:12:26 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: fix soft lockup via spinning in filestream ag selection loop
Date:   Fri, 22 Apr 2022 10:12:26 -0400
Message-Id: <20220422141226.1831426-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The filestream AG selection loop uses pagf data to aid in AG
selection, which depends on pagf initialization. If the in-core
structure is not initialized, the caller invokes the AGF read path
to do so and carries on. If another task enters the loop and finds
a pagf init already in progress, the AGF read returns -EAGAIN and
the task continues the loop. This does not increment the current ag
index, however, which means the task spins on the current AGF buffer
until unlocked.

If the AGF read I/O submitted by the initial task happens to be
delayed for whatever reason, this results in soft lockup warnings
via the spinning task. This is reproduced by xfs/170. To avoid this
problem, fix the AGF trylock failure path to properly iterate to the
next AG. If a task iterates all AGs without making progress, the
trylock behavior is dropped in favor of blocking locks and thus a
soft lockup is no longer possible.

Fixes: f48e2df8a877ca1c ("xfs: make xfs_*read_agf return EAGAIN to ALLOC_FLAG_TRYLOCK callers")
Signed-off-by: Brian Foster <bfoster@redhat.com>
---

I included the Fixes: tag because this looks like a regression in said
commit, but I've not explicitly verified.

Brian

 fs/xfs/xfs_filestream.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 6a3ce0f6dc9e..be9bcf8a1f99 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -128,11 +128,12 @@ xfs_filestream_pick_ag(
 		if (!pag->pagf_init) {
 			err = xfs_alloc_pagf_init(mp, NULL, ag, trylock);
 			if (err) {
-				xfs_perag_put(pag);
-				if (err != -EAGAIN)
+				if (err != -EAGAIN) {
+					xfs_perag_put(pag);
 					return err;
+				}
 				/* Couldn't lock the AGF, skip this AG. */
-				continue;
+				goto next_ag;
 			}
 		}
 
-- 
2.34.1

