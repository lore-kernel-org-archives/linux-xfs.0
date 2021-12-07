Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2742C433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Dec 2021 18:35:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbhLGSjV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Dec 2021 13:39:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235941AbhLGSjV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Dec 2021 13:39:21 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15CFBC061574
        for <linux-xfs@vger.kernel.org>; Tue,  7 Dec 2021 10:35:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BBC46CE1D8D
        for <linux-xfs@vger.kernel.org>; Tue,  7 Dec 2021 18:35:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB6AFC341C1;
        Tue,  7 Dec 2021 18:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638902146;
        bh=hldabsEcT8AN+Sc4qoPXSKlWRk4Cf1nV5jGi2bmGovk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=W5N9ekoo4J2ZVnonj/g6RpQNC7wbzcqim+G+oC+07mGwkECn0ym/UBmrdYW8TP5N9
         QICppS2J/kE8WhLUEh1C4e1Hm+IvGaBBKfe/7dM0TkLRsKlyenGz4vNNDzVRCDhaMg
         d8egvtG1T3o3kgmAIkzRjhqDrV8TLRDkVZU+dVaLki0oDjX0KMfMGmj1cDz8oA6ED6
         fozszlS1eT8YdSOF53jU9+7unkbPS+VIynie7zBcEJgjddutGfOFVTkzlX2ZkFMraI
         bhM176N86YiOSmYaD4w2+UcRAe2+stHOOAPrAr1MVexZbV6FNnSVQ5+7mReg7+UJeM
         Kva/yJZxBI4Ow==
Subject: [PATCH 1/2] xfs: remove all COW fork extents when remounting readonly
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        wen.gang.wang@oracle.com
Date:   Tue, 07 Dec 2021 10:35:45 -0800
Message-ID: <163890214556.3375879.16529642634341350231.stgit@magnolia>
In-Reply-To: <163890213974.3375879.451653865403812137.stgit@magnolia>
References: <163890213974.3375879.451653865403812137.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

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
---
 fs/xfs/xfs_super.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index e21459f9923a..0c07a4aef3b9 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1765,7 +1765,10 @@ static int
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
@@ -1773,8 +1776,13 @@ xfs_remount_ro(
 	 */
 	xfs_blockgc_stop(mp);
 
-	/* Get rid of any leftover CoW reservations... */
-	error = xfs_blockgc_free_space(mp, NULL);
+	/*
+	 * Clean out all remaining COW staging extents.  This extra step is
+	 * done synchronously because the background blockgc worker could have
+	 * raced with a reader thread and failed to grab an IOLOCK.  In that
+	 * case, the inode could still have post-eof and COW blocks.
+	 */
+	error = xfs_blockgc_free_space(mp, &icw);
 	if (error) {
 		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 		return error;

