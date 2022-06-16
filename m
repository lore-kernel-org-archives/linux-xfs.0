Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 342A1CCA47E
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jun 2022 18:28:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbiFPS2j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jun 2022 14:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377864AbiFPS2a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jun 2022 14:28:30 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 350FF434BB
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jun 2022 11:28:29 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id o17so1917813pla.6
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jun 2022 11:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sOovqm/O9TKlCrVFxANRWwr9a3gGovrCZyHMHGUzYIQ=;
        b=jyybrq9LEWJf9CB5xbIu9mTfhgtpSm8apVpcbbRNm4mYd0Y/lPXzcEU0AnGWb0Yzwy
         G6ruSe4grKU/tLBe3UOjkL3MmQaLqQGQE0S5/+GuV3/1VV7UAF+DymEaw5gnNnhtDRE0
         06jMQkAb6lAbOoqXzAqvjKPem3dLEffNXDSrwYdi86s5cyi6Yg9Z3L9F9uK69OZNGxWQ
         z3VjFeiVGtYywpLnqNkjc7ozvbCP8UEKZ1OBMKus4h6idPvgUO0ZPt+xQvcKyIe5O8bu
         Z/5Pb2cEavXc0uKylO3OeFH8lMRf9g4i08acEg5y9alNXucrjOh2TUan5O0O9x02cwnm
         /fmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sOovqm/O9TKlCrVFxANRWwr9a3gGovrCZyHMHGUzYIQ=;
        b=KWBdPthBgjVS894r4qfuq4iDeKC6DEbf/Dv771dFVNmRiHwqdzsxoj8CQlnmTPvinP
         wR4r4pLt2iXwKioH3/XJAVCG14NWX4tt/0RVND3yJ49jb2EYNjze//FioBWy/EiY5zcQ
         /JVqR7NckL08pKyez+lWTlmBtLKvLGsHpXmKve/BccDO2Lo44EPYojwQrYb4AxnjCGwq
         c/PvSfR7a3f7tV+w59LDO09u4JQyd5RV6wbWt3OpK4WV5aid1CsO/1JceC4zwXdyb5Mu
         qTEUiATIiJhBvOmIuKQggTCODcIaFpie3biGNIVTt1k8n//w+GLFsacbKk3mZhURb1f9
         yIrA==
X-Gm-Message-State: AJIora8ajA4t6QYA9BvSAgrZ83mbD8GrEc5ufUUHpAv7WZdBOtuQAR+S
        ttzsmfhLBnFzD1vF9Dqe8U8lWnTxEuwapA==
X-Google-Smtp-Source: AGRyM1vI7accbfJ44LLf3SzjhHplMZkt9hq9ZWsspZwAZscOcZCRv+5R5hE6wdvMXrMMqCNV5e45tg==
X-Received: by 2002:a17:90b:38c1:b0:1ea:8403:9305 with SMTP id nn1-20020a17090b38c100b001ea84039305mr6307911pjb.11.1655404108101;
        Thu, 16 Jun 2022 11:28:28 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2cd:202:fd57:7edc:385a:c1be])
        by smtp.gmail.com with ESMTPSA id fs20-20020a17090af29400b001ea75a02805sm4131511pjb.52.2022.06.16.11.28.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 11:28:27 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     mcgrof@kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE v2 4/8] xfs: remove all COW fork extents when remounting readonly
Date:   Thu, 16 Jun 2022 11:27:45 -0700
Message-Id: <20220616182749.1200971-5-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
In-Reply-To: <20220616182749.1200971-1-leah.rumancik@gmail.com>
References: <20220616182749.1200971-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 089558bc7ba785c03815a49c89e28ad9b8de51f9 ]

As part of multiple customer escalations due to file data corruption
after copy on write operations, I wrote some fstests that use fsstress
to hammer on COW to shake things loose.  Regrettably, I caught some
filesystem shutdowns due to incorrect rmap operations with the following
loop:

mount <filesystem>				# (0)
fsstress <run only readonly ops> &		# (1)
while true; do
	fsstress <run all ops>
	mount -o remount,ro			# (2)
	fsstress <run only readonly ops>
	mount -o remount,rw			# (3)
done

When (2) happens, notice that (1) is still running.  xfs_remount_ro will
call xfs_blockgc_stop to walk the inode cache to free all the COW
extents, but the blockgc mechanism races with (1)'s reader threads to
take IOLOCKs and loses, which means that it doesn't clean them all out.
Call such a file (A).

When (3) happens, xfs_remount_rw calls xfs_reflink_recover_cow, which
walks the ondisk refcount btree and frees any COW extent that it finds.
This function does not check the inode cache, which means that incore
COW forks of inode (A) is now inconsistent with the ondisk metadata.  If
one of those former COW extents are allocated and mapped into another
file (B) and someone triggers a COW to the stale reservation in (A), A's
dirty data will be written into (B) and once that's done, those blocks
will be transferred to (A)'s data fork without bumping the refcount.

The results are catastrophic -- file (B) and the refcount btree are now
corrupt.  Solve this race by forcing the xfs_blockgc_free_space to run
synchronously, which causes xfs_icwalk to return to inodes that were
skipped because the blockgc code couldn't take the IOLOCK.  This is safe
to do here because the VFS has already prohibited new writer threads.

Fixes: 10ddf64e420f ("xfs: remove leftover CoW reservations when remounting ro")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_super.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 170fee98c45c..23673703618a 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1768,7 +1768,10 @@ static int
 xfs_remount_ro(
 	struct xfs_mount	*mp)
 {
-	int error;
+	struct xfs_icwalk	icw = {
+		.icw_flags	= XFS_ICWALK_FLAG_SYNC,
+	};
+	int			error;
 
 	/*
 	 * Cancel background eofb scanning so it cannot race with the final
@@ -1776,8 +1779,13 @@ xfs_remount_ro(
 	 */
 	xfs_blockgc_stop(mp);
 
-	/* Get rid of any leftover CoW reservations... */
-	error = xfs_blockgc_free_space(mp, NULL);
+	/*
+	 * Clear out all remaining COW staging extents and speculative post-EOF
+	 * preallocations so that we don't leave inodes requiring inactivation
+	 * cleanups during reclaim on a read-only mount.  We must process every
+	 * cached inode, so this requires a synchronous cache scan.
+	 */
+	error = xfs_blockgc_free_space(mp, &icw);
 	if (error) {
 		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 		return error;
-- 
2.36.1.476.g0c4daa206d-goog

