Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF454C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Dec 2022 21:07:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbiLTVH2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Dec 2022 16:07:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiLTVH1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Dec 2022 16:07:27 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D5CD1DF0F
        for <linux-xfs@vger.kernel.org>; Tue, 20 Dec 2022 13:07:27 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id 7so4106444pga.1
        for <linux-xfs@vger.kernel.org>; Tue, 20 Dec 2022 13:07:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=mjrn1Qfw3bhXdZSXQPdFQ3DY4RPGm3eEdpI9xqMRHxM=;
        b=oRf2CE7tCxo+WD1aChjhPMcYAA3aXKF/pOkq4tzIenyZZVcNXmEWWrh6VPFBFYe9GF
         vIP67l1umXuv35r5hlX7/FUvRohh77QVqSlt50YpUc5et3q2wevGnJoepXCcPX+jbsgG
         6kZ2gEekDrug4TXV5lfVVhX6qtdUBpGdMdLj+Snp+bluVNHk2IvNhqVTU4dgMiIkNi9m
         8V3CIr404+g1geSlbuo8WO6aMof7fm3LpVQX9yzH88Mk9ycF41fFZc1HqYnwqAxECYbD
         RH+7rpnu8IQo0Cq5kjMSbOs72y8wyFEZRYnr8EFZUqnDQGOhnDQcl/af0QeLzdBx/rfH
         NgqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mjrn1Qfw3bhXdZSXQPdFQ3DY4RPGm3eEdpI9xqMRHxM=;
        b=iG38gHLSDYo7EC5yGvneaPneWj136Bsvkfe7tIRrrKskZB2lLld6TkeCXe0jrOhdzL
         iRPVMzppaa2TtDlZiJ1M8VtsZwz+JywWepsdIVeS0nMfdsnJo68nKcIUpl2shvByKfqg
         dcavAg0a3lvZS3zPLXJw7JAhJmNcwivRFQGADfsnScjUOQrzM5f4OXfNMP5gYl4WGs+c
         62wgE9+EFIyQwzEmjgFVWLCB6x+SaTuogbz2AxjW5Oe1ubIFvYDeBmy/mjaLmLrXLPDS
         qQQt8I0RRkUlYAduAQiFmlW8TiWkr/iohkBkgOlyo7+vA17w0YWDyd1sHo6dREcm1Lmu
         P49Q==
X-Gm-Message-State: ANoB5pkPtkHYLDkpKMdnHc/c+D686ifmZG3Nw9fzPuRW0iT5xlIwevmb
        W01m6kbzWh+JE/JBx2rRL8V7bUenAz3rgk3k
X-Google-Smtp-Source: AA0mqf7Ct7ltLANoMmUdts68wgzs8pc520m3i5ga/2mjyqytI447ebbVlg//Uy5SZeDpwtCllu0RHg==
X-Received: by 2002:a05:6a00:324b:b0:574:3cde:385a with SMTP id bn11-20020a056a00324b00b005743cde385amr42801082pfb.32.1671570446371;
        Tue, 20 Dec 2022 13:07:26 -0800 (PST)
Received: from dread.disaster.area (pa49-181-138-158.pa.nsw.optusnet.com.au. [49.181.138.158])
        by smtp.gmail.com with ESMTPSA id t13-20020a62d14d000000b00578199ea5afsm9078354pfl.9.2022.12.20.13.07.25
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 13:07:26 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1p7jpb-00Aqa3-6Y
        for linux-xfs@vger.kernel.org; Wed, 21 Dec 2022 08:07:23 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1p7jpb-00EVPt-0k
        for linux-xfs@vger.kernel.org;
        Wed, 21 Dec 2022 08:07:23 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: don't use BMBT btree split workers for IO completion
Date:   Wed, 21 Dec 2022 08:07:23 +1100
Message-Id: <20221220210723.3457348-1-david@fromorbit.com>
X-Mailer: git-send-email 2.38.1
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
index 4c16c8c31fcb..6b084b3cac83 100644
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
2.38.1

