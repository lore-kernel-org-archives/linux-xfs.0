Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED6C3C6FD1F
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:26:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbjCPT0O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbjCPT0N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:26:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2FAABDD22
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 12:26:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37761620F9
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 19:26:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92A53C433D2;
        Thu, 16 Mar 2023 19:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678994770;
        bh=kh8noAaNt2RzSwuZOW2CBf/JKZXoFZdjWaPXA2gWetI=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=Rjpt/BptgIISVBXlNIabSEOdTE+k3q7pdOGvE5LRC4jI7+oVNj9UseE9dEcCCpAc1
         uI+ez8WmTtB+11kRpUBv+HuvdDXWlgHsr4umTPeGNBv+Ba/AI/mZvB+CDkJ1KLqOX4
         7WnRK10yK3r8VwdkMJUYwRZHM+4YQpdZ3uU/8TCKWj3yqZTF7I8fCp9zs8LQh7KUBV
         3EyJLew4sb1qByTUuXyLlY/f0BjCBs0HnATTBOf/OpAnRHD9NQpssi+JqX7yKGTko7
         rDwY+c0wDVbbdREhilmyr3F5yYvXu/IGmDYz55ak+TbtKTwbgphqjybozSOb0TzFSb
         DYyhvFzfXaCaQ==
Date:   Thu, 16 Mar 2023 12:26:10 -0700
Subject: [PATCH 1/9] libxfs: initialize the slab cache for parent defer items
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167899415390.16278.7244343000757925685.stgit@frogsfrogsfrogs>
In-Reply-To: <167899415375.16278.9528475200288521209.stgit@frogsfrogsfrogs>
References: <167899415375.16278.9528475200288521209.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Initialize the slab cache for parent defer items.  We'll need this in an
upcoming patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/libxfs.h |    1 +
 libxfs/init.c    |    3 +++
 2 files changed, 4 insertions(+)


diff --git a/include/libxfs.h b/include/libxfs.h
index b28781d19..cc57e8887 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -78,6 +78,7 @@ struct iomap;
 #include "xfs_refcount_btree.h"
 #include "xfs_refcount.h"
 #include "xfs_btree_staging.h"
+#include "xfs_parent.h"
 
 #ifndef ARRAY_SIZE
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
diff --git a/libxfs/init.c b/libxfs/init.c
index fda36ba0f..59cd547d6 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -258,6 +258,8 @@ init_caches(void)
 			"xfs_extfree_item");
 	xfs_trans_cache = kmem_cache_init(
 			sizeof(struct xfs_trans), "xfs_trans");
+	xfs_parent_intent_cache = kmem_cache_init(
+			sizeof(struct xfs_parent_defer), "xfs_parent_defer");
 }
 
 static int
@@ -275,6 +277,7 @@ destroy_caches(void)
 	xfs_btree_destroy_cur_caches();
 	leaked += kmem_cache_destroy(xfs_extfree_item_cache);
 	leaked += kmem_cache_destroy(xfs_trans_cache);
+	leaked += kmem_cache_destroy(xfs_parent_intent_cache);
 
 	return leaked;
 }

