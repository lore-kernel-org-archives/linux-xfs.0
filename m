Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C953C6379F
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Feb 2023 01:46:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231934AbjBOBqv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Feb 2023 20:46:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233681AbjBOBqu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Feb 2023 20:46:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4958A34F58;
        Tue, 14 Feb 2023 17:46:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE261619A0;
        Wed, 15 Feb 2023 01:46:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1283AC433EF;
        Wed, 15 Feb 2023 01:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676425607;
        bh=RFr3g/4qCyyNGldPY3NR4ztey60BtZk5Sq9d54comoI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QzTu75VvR6I0udTDvPb7c4GNMPv+WT45MQdrP4CX9T86eQB116l8loQRRhX6K5peK
         Cy7ZJrzMIiCM98dJugPBtg6nRvM1YjfhUllIA6x2AdYtRM2sGKK2UCvXroZLZgqfCG
         BQM7JD/VIDsuLKG4SGtO7+s7gpIErhAbq0lRLGNjPiismHAXkg2LvcbFCP51EE6mUK
         /pGteC5nfYldhI4ueMkxuB/19F3VtJHqOIbeUdpWpT8qvxvYfNxM3S16oN7RqhpX6V
         g11CIpvp3F95fWpdWimtq5YwKcbEZ+huqZrwz4BGkAHklsyEIjbRxtapgWFgdUhGhd
         x/2cvyryZ988g==
Subject: [PATCH 12/14] report: record xfs-specific information about a test
 run
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        leah.rumancik@gmail.com, quwenruo.btrfs@gmx.com, tytso@mit.edu
Date:   Tue, 14 Feb 2023 17:46:46 -0800
Message-ID: <167642560660.2118945.465092435286091827.stgit@magnolia>
In-Reply-To: <167642553879.2118945.15448815976865210889.stgit@magnolia>
References: <167642553879.2118945.15448815976865210889.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Report various XFS-specific information about a test run.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/report |    2 ++
 common/xfs    |   10 ++++++++++
 2 files changed, 12 insertions(+)


diff --git a/common/report b/common/report
index 90d4f980d1..d538fc38a9 100644
--- a/common/report
+++ b/common/report
@@ -58,6 +58,8 @@ __generate_report_vars() {
 
 	__generate_blockdev_report_vars "TEST_DEV"
 	__generate_blockdev_report_vars "SCRATCH_DEV"
+
+	test "$FSTYP" = "xfs" && __generate_xfs_report_vars
 }
 
 #
diff --git a/common/xfs b/common/xfs
index 97c049e2ca..ea8f54e03b 100644
--- a/common/xfs
+++ b/common/xfs
@@ -2,6 +2,16 @@
 # XFS specific common functions.
 #
 
+__generate_xfs_report_vars() {
+	__generate_blockdev_report_vars TEST_RTDEV
+	__generate_blockdev_report_vars TEST_LOGDEV
+	__generate_blockdev_report_vars SCRATCH_RTDEV
+	__generate_blockdev_report_vars SCRATCH_LOGDEV
+
+	REPORT_VARS["XFS_ALWAYS_COW"]="$(cat /sys/fs/xfs/debug/always_cow 2>/dev/null)"
+	REPORT_VARS["XFS_LARP"]="$(cat /sys/fs/xfs/debug/larp 2>/dev/null)"
+}
+
 _setup_large_xfs_fs()
 {
 	fs_size=$1

