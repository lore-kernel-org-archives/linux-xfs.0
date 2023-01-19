Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89ECCC38159
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Jan 2023 01:03:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbjASBDq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:03:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbjASBDj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 20:03:39 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9027683E3
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 17:03:37 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id x2-20020a17090a46c200b002295ca9855aso4310645pjg.2
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 17:03:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=+6gVjkzmNjEO3nIdPd4J20Mo3oB+PB4+uPPKuNKj4Ds=;
        b=n+I5w9PV5IIyyZTYu1FNUe3uUeb41HSPhkqkvlwyYIJcevjONW/cH9Wh886DjjuK3Q
         7i9dxwDFb6hSlSYtY7eRg8d2YBcyxX3hXIS73dOKFeU80XWE+FE2NEGl0U4QYzXIAe/b
         F3Dni+byT76wK9t7d+gWcgnSFbBrhw8GP6GL2JndWm5SnWg+p7yMXYav4GZh65s3pU38
         LxV5aHBD9iV+tYINFPc2J7Y/0xD99ReYFhFNLFQjOmezqtd3A/OIivMkkBlul4BYRrsJ
         5KGQ8w35yFQFCq8sOo6VLKOdEulzIJhDnvl4/2mE0EnNKdEAtd+VOQHTW44ejBHdUIjz
         4KyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+6gVjkzmNjEO3nIdPd4J20Mo3oB+PB4+uPPKuNKj4Ds=;
        b=xBVUWPO3lJEcYXQ74HUGGlHZYSIsAaK7hBnH28SQmnlq/VLOvvc5Viwu8gvqUG+rJF
         lNFGALwKxHpmWSqXPM0GU7lEjhHtVlu/XYOHEkn6GEYywsSNbHpqi6+TXZvwYbAKNDJP
         Hb5X0a6heUEByLuSpb9U14SwOyBDV59qESXhcT4cnKmKSBwiialV8qqelJD9CoeHq5rm
         41LgT0XFhf94oxFRhiI/Pryx7pBfWyDGumak8RMR/bY6pMRBijNy2iYyJ3m4S/uScf9K
         t75ZYTQjw2Oj9f4ijFfnd5FZe9ek5Jy52HMhoA03KOhdODvNrj4Sxs7l8bRxzShMgJl2
         ucbQ==
X-Gm-Message-State: AFqh2kpoSTw7HtnFQdJXrDRLbQYhFKGjHE6sqT8igU+u78fZiDM08tYX
        njtjgcKOpUfp1ut6bFmqQ6+aYp0FztAM6RDo
X-Google-Smtp-Source: AMrXdXui3mkm7z211Tmwy3cv8oMdK4Zx7tg7JtbDIUT80Ty3ZzPx7sam8wSa9qMLEcqU/CcOlihs9g==
X-Received: by 2002:a17:902:cf08:b0:192:c125:ac2f with SMTP id i8-20020a170902cf0800b00192c125ac2fmr10160100plg.8.1674090217360;
        Wed, 18 Jan 2023 17:03:37 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id s7-20020a170902988700b0017ec1b1bf9fsm23612279plp.217.2023.01.18.17.03.36
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 17:03:36 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pIJL4-004l03-BU
        for linux-xfs@vger.kernel.org; Thu, 19 Jan 2023 12:03:34 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pIJL4-008Jr5-0s
        for linux-xfs@vger.kernel.org;
        Thu, 19 Jan 2023 12:03:34 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: don't use BMBT btree split workers for IO completion
Date:   Thu, 19 Jan 2023 12:03:34 +1100
Message-Id: <20230119010334.1982938-1-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

When we split a BMBT due to record insertion, we offload it to a
worker thread because we can be deep in the stack when we try to
allocate a new block for the BMBT. Allocation can use several
kilobytes of stack (full memory reclaim, swap and/or IO path can
end up on the stack during allocation) and we can already be several
kilobytes deep in the stack when we need to split the BMBT.

A recent workload demonstrated a deadlock in this BMBT split
offload. It requires several things to happen at once:

1. two inodes need a BMBT split at the same time, one must be
unwritten extent conversion from IO completion, the other must be
from extent allocation.

2. there must be a no available xfs_alloc_wq worker threads
available in the worker pool.

3. There must be sustained severe memory shortages such that new
kworker threads cannot be allocated to the xfs_alloc_wq pool for
both threads that need split work to be run

4. The split work from the unwritten extent conversion must run
first.

5. when the BMBT block allocation runs from the split work, it must
loop over all AGs and not be able to either trylock an AGF
successfully, or each AGF is is able to lock has no space available
for a single block allocation.

6. The BMBT allocation must then attempt to lock the AGF that the
second task queued to the rescuer thread already has locked before
it finds an AGF it can allocate from.

At this point, we have an ABBA deadlock between tasks queued on the
xfs_alloc_wq rescuer thread and a locked AGF. i.e. The queued task
holding the AGF lock can't be run by the rescuer thread until the
task the rescuer thread is runing gets the AGF lock....

This is a highly improbably series of events, but there it is.

There's a couple of ways to fix this, but the easiest way to ensure
that we only punt tasks with a locked AGF that holds enough space
for the BMBT block allocations to the worker thread.

This works for unwritten extent conversion in IO completion (which
doesn't have a locked AGF and space reservations) because we have
tight control over the IO completion stack. It is typically only 6
functions deep when xfs_btree_split() is called because we've
already offloaded the IO completion work to a worker thread and
hence we don't need to worry about stack overruns here.

The other place we can be called for a BMBT split without a
preceeding allocation is __xfs_bunmapi() when punching out the
center of an existing extent. We don't remove extents in the IO
path, so these operations don't tend to be called with a lot of
stack consumed. Hence we don't really need to ship the split off to
a worker thread in these cases, either.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_btree.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 35f574421670..da8c769887fd 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -2913,9 +2913,22 @@ xfs_btree_split_worker(
 }
 
 /*
- * BMBT split requests often come in with little stack to work on. Push
+ * BMBT split requests often come in with little stack to work on so we push
  * them off to a worker thread so there is lots of stack to use. For the other
  * btree types, just call directly to avoid the context switch overhead here.
+ *
+ * Care must be taken here - the work queue rescuer thread introduces potential
+ * AGF <> worker queue deadlocks if the BMBT block allocation has to lock new
+ * AGFs to allocate blocks. A task being run by the rescuer could attempt to
+ * lock an AGF that is already locked by a task queued to run by the rescuer,
+ * resulting in an ABBA deadlock as the rescuer cannot run the lock holder to
+ * release it until the current thread it is running gains the lock.
+ *
+ * To avoid this issue, we only ever queue BMBT splits that don't have an AGF
+ * already locked to allocate from. The only place that doesn't hold an AGF
+ * locked is unwritten extent conversion at IO completion, but that has already
+ * been offloaded to a worker thread and hence has no stack consumption issues
+ * we have to worry about.
  */
 STATIC int					/* error */
 xfs_btree_split(
@@ -2929,7 +2942,8 @@ xfs_btree_split(
 	struct xfs_btree_split_args	args;
 	DECLARE_COMPLETION_ONSTACK(done);
 
-	if (cur->bc_btnum != XFS_BTNUM_BMAP)
+	if (cur->bc_btnum != XFS_BTNUM_BMAP ||
+	    cur->bc_tp->t_firstblock == NULLFSBLOCK)
 		return __xfs_btree_split(cur, level, ptrp, key, curp, stat);
 
 	args.cur = cur;
-- 
2.39.0

