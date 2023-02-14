Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88E81C61DA4
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Feb 2023 05:51:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbjBNFvY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Feb 2023 00:51:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231173AbjBNFvW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Feb 2023 00:51:22 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA431C5AF
        for <linux-xfs@vger.kernel.org>; Mon, 13 Feb 2023 21:51:20 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id b5so15958451plz.5
        for <linux-xfs@vger.kernel.org>; Mon, 13 Feb 2023 21:51:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TbSERSy/PBqC/ToxpRcHrmAej4xMlZuBPr9LcR+dPRY=;
        b=hBEf9Tmn9cESbfGcdQUCwbEoTy88i+UHeOdHDrOxKPHeI6dL5dUWZst1VvdMZTTNOt
         OPKoAacfW9Peqhr5GtvytNZLrqKj7Go3IYMdmqEnlkq0GbyZlhlC9nZKvdyi1VPiEoiK
         goQT7Zoc++/CLOB5xzdQtYsUmtMA8SrXBelxjBOlBuzW5QuojVRyBraMsmrdOlvctrPU
         UAcpGs/IOGGjbpcNm49wsZxqCV/1x2qi6dGZU736i02f0y9vED3lqywFkn2MLlV1b7c7
         qewjO2O0lsfwx1fHdhiaqncPP59MJf3Fe57lFKoKg0iH0cVgHcqzSdryNn+qcQIYveAE
         G8Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TbSERSy/PBqC/ToxpRcHrmAej4xMlZuBPr9LcR+dPRY=;
        b=IRuYuuvwI79Zvg2tiAgMkwP16d3ugo5goSqcfJUG5h5KQlB9+2CEyBMZV1/Xe4X3CD
         wco8Muwr9Kn11lzjQCu+CjLtmkp1+OQIeJ9sdC95McIaDmE1tWlA0B5sQqSR0baiRIhY
         O6hMUmcWazQ5QNQ32Mmsi+z9LfqhmlQbSBHi/7Fh7la3SonF6fEET+aembPAgAV38JYI
         LKlBEQq0eM99SEj5elzmrpO3jBjKh4L0cVLM9kb43DZwaqwxXVy0LTNXDZreScnhPjs3
         d39v8tzdJ5bK9uiWASuAhtfMkT/qsmW5agY6XeUBri5J9bkE6TtdKxScAgwJcR+CFjz3
         l8Cg==
X-Gm-Message-State: AO0yUKUfvIHQia1t5h56KvZHPrFnNE80wQF2+bKpjOUy5h4yUtHUbvVU
        N+VlKQC4EMf7mLP5c5Dd0OJKcaP6Nh/+W8R1
X-Google-Smtp-Source: AK7set+S1yg2yIVk4HLlpxdE1Bus4sMYyW1t8NDoLnzvcXs3PU/E/ZcnI1cCBMtrzjqbumpGoh1Qng==
X-Received: by 2002:a05:6a21:3284:b0:c0:c429:cbbd with SMTP id yt4-20020a056a21328400b000c0c429cbbdmr1409710pzb.6.1676353880030;
        Mon, 13 Feb 2023 21:51:20 -0800 (PST)
Received: from dread.disaster.area (pa49-181-4-128.pa.nsw.optusnet.com.au. [49.181.4.128])
        by smtp.gmail.com with ESMTPSA id e24-20020a62aa18000000b005a8dc935ec1sm396153pff.62.2023.02.13.21.51.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 21:51:19 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pRoDk-00F5yJ-ID; Tue, 14 Feb 2023 16:51:16 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pRoDk-00HNdN-1h;
        Tue, 14 Feb 2023 16:51:16 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/3] xfs: failed delalloc conversion results in bad extent lists
Date:   Tue, 14 Feb 2023 16:51:13 +1100
Message-Id: <20230214055114.4141947-3-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230214055114.4141947-1-david@fromorbit.com>
References: <20230214055114.4141947-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

If we fail delayed allocation conversion because we cannot allocate
blocks, we end up in the situation where the inode extent list is
effectively corrupt and unresolvable. Whilst we have dirty data in
memory that we cannot allocate space for, we cannot write that data
back to disk. Unmounting a filesystem in this state results in data
loss.

In situations where we end up with a corrupt extent list in memory,
we can also be asked to convert a delayed region that does not have
a delalloc extent backing it. This should be considered a
corruption, too, not a "try again later" error.

These conversion failures result in the inode being sick and needing
repair, but we don't mark all the conditions that can lead to bmap
sickness being marked. Make sure that the error conditions that
indicate corruption are properly marked.

Further, if we trip over these corruptions conditions, we then have
to reclaim an inode that has unresolvable delayed allocation extents
attached to the inode. This generally happens at unmount and inode
inactivation will fire assert failures because we've left stray
delayed allocation extents behind on the inode. Hence we need to
ensure that we only trigger the stale delalloc extent checks if the
inode is fully healthy.

Even then, this may not be enough, because the inactivation code
assumes that there will be no stray delayed extents unless the
filesystem is shut down. If the inode is unhealthy, we need to
ensure we clean up delayed allocation extents within EOF because
the VFS has already tossed the data away. Hence there's no longer
any data over the delalloc extents to write back, so we need to also
toss the delayed allocation extents to ensure we release the space
reservation the delalloc extent holds. Failure to punch delalloc
extents in this case results in assert failures during unmount when
the delalloc block counter is torn down.

This all needs to be in place before the next patch which resolves a
bug in the iomap code that discards delalloc extents backing dirty
pages on writeback error without discarding the dirty data. Hence we
need to be able to handle delalloc extents in inode cleanup sanely,
rather than rely on incorrectly punching the delalloc extents on the
first writeback error that occurs.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 13 ++++++++++---
 fs/xfs/xfs_icache.c      |  4 +++-
 fs/xfs/xfs_inode.c       | 10 ++++++++++
 3 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 958e4bb2e51e..fb718a5825d5 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4553,8 +4553,12 @@ xfs_bmapi_convert_delalloc(
 		 * should only happen for the COW fork, where another thread
 		 * might have moved the extent to the data fork in the meantime.
 		 */
-		WARN_ON_ONCE(whichfork != XFS_COW_FORK);
-		error = -EAGAIN;
+		if (whichfork != XFS_COW_FORK) {
+			xfs_bmap_mark_sick(ip, whichfork);
+			error = -EFSCORRUPTED;
+		} else {
+			error = -EAGAIN;
+		}
 		goto out_trans_cancel;
 	}
 
@@ -4598,8 +4602,11 @@ xfs_bmapi_convert_delalloc(
 		bma.prev.br_startoff = NULLFILEOFF;
 
 	error = xfs_bmapi_allocate(&bma);
-	if (error)
+	if (error) {
+		if ((error == -EFSCORRUPTED) || (error == -EFSBADCRC))
+			xfs_bmap_mark_sick(ip, whichfork);
 		goto out_finish;
+	}
 
 	error = -ENOSPC;
 	if (WARN_ON_ONCE(bma.blkno == NULLFSBLOCK))
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index ddeaccc04aec..4354b6639dec 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -24,6 +24,7 @@
 #include "xfs_ialloc.h"
 #include "xfs_ag.h"
 #include "xfs_log_priv.h"
+#include "xfs_health.h"
 
 #include <linux/iversion.h>
 
@@ -1810,7 +1811,8 @@ xfs_inodegc_set_reclaimable(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_perag	*pag;
 
-	if (!xfs_is_shutdown(mp) && ip->i_delayed_blks) {
+	if (ip->i_delayed_blks && xfs_inode_is_healthy(ip) &&
+	    !xfs_is_shutdown(mp)) {
 		xfs_check_delalloc(ip, XFS_DATA_FORK);
 		xfs_check_delalloc(ip, XFS_COW_FORK);
 		ASSERT(0);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index d354ea2b74f9..06f1229ef628 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -37,6 +37,7 @@
 #include "xfs_reflink.h"
 #include "xfs_ag.h"
 #include "xfs_log_priv.h"
+#include "xfs_health.h"
 
 struct kmem_cache *xfs_inode_cache;
 
@@ -1738,6 +1739,15 @@ xfs_inactive(
 		if (xfs_can_free_eofblocks(ip, true))
 			xfs_free_eofblocks(ip);
 
+		/*
+		 * If the inode is sick, then it might have delalloc extents
+		 * within EOF that we were unable to convert. We have to punch
+		 * them out here to release the reservation as there is no
+		 * longer any data to write back into the delalloc range now.
+		 */
+		if (!xfs_inode_is_healthy(ip))
+			xfs_bmap_punch_delalloc_range(ip, 0,
+						i_size_read(VFS_I(ip)));
 		goto out;
 	}
 
-- 
2.39.0

