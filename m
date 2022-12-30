Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04F83C3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:34:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235655AbiLaAeV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:34:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235739AbiLaAeU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:34:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A665F1EAC0
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:34:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D03EB81DCC
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:34:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0845AC433D2;
        Sat, 31 Dec 2022 00:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446856;
        bh=gHkUpoL5ErM6WSK2LzdXFjgpnYxQD8zL3JsPsj1902k=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=rtLUYo4zmM9+0xMqZmqYVvYptnpgk+fmSf9LkAnbvApqVTOAe2JiP0i0LHehMaeXT
         SzDA/TsvPLgFGMGeG7iVaInMh8bI2ZQPk7lxOL/Cvc63EFTFfiOeL2oYqlvm8v5ZrJ
         9wlLfncWlyNDVdP3LWxZOpzdkZNAIQcFXmQb53hBL7W9XnAsY+p4JCEak4FiTgxAAb
         5C0NduU+h5RqvtqDHM+8ttILAl1Jc8ynhQDtFv5+NJ1BAfjEbEhRHgB/RZkHs1DdsJ
         DPECLE1OY2kW+NFTfD91Gmwt6pYsqYNcq1XLxmvJ8ZkL6pFEIobEUgxYLF/Z8PJYdd
         spKZv9kTE/uKw==
Subject: [PATCH 2/8] xfs_scrub: add missing copyrights and spdx headers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:31 -0800
Message-ID: <167243871124.717702.7783784861015870036.stgit@magnolia>
In-Reply-To: <167243871097.717702.15336500890922415647.stgit@magnolia>
References: <167243871097.717702.15336500890922415647.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add missing license and copyright information to the systemd control
files in this directory.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/xfs_scrub@.service.in      |    5 +++++
 scrub/xfs_scrub_all.cron.in      |    5 +++++
 scrub/xfs_scrub_all.service.in   |    5 +++++
 scrub/xfs_scrub_all.timer        |    5 +++++
 scrub/xfs_scrub_fail             |    5 +++++
 scrub/xfs_scrub_fail@.service.in |    5 +++++
 6 files changed, 30 insertions(+)


diff --git a/scrub/xfs_scrub@.service.in b/scrub/xfs_scrub@.service.in
index 6fb3f6ea2e9..c8662fc85a6 100644
--- a/scrub/xfs_scrub@.service.in
+++ b/scrub/xfs_scrub@.service.in
@@ -1,3 +1,8 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (C) 2018 Oracle.  All Rights Reserved.
+# Author: Darrick J. Wong <djwong@kernel.org>
+
 [Unit]
 Description=Online XFS Metadata Check for %I
 OnFailure=xfs_scrub_fail@%i.service
diff --git a/scrub/xfs_scrub_all.cron.in b/scrub/xfs_scrub_all.cron.in
index 3dea9296077..0ef97cc0ca8 100644
--- a/scrub/xfs_scrub_all.cron.in
+++ b/scrub/xfs_scrub_all.cron.in
@@ -1 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (C) 2018 Oracle.  All Rights Reserved.
+# Author: Darrick J. Wong <djwong@kernel.org>
+#
 10 3 * * 0 root test -e /run/systemd/system || @sbindir@/xfs_scrub_all
diff --git a/scrub/xfs_scrub_all.service.in b/scrub/xfs_scrub_all.service.in
index b1b80da40a3..b874eb6f757 100644
--- a/scrub/xfs_scrub_all.service.in
+++ b/scrub/xfs_scrub_all.service.in
@@ -1,3 +1,8 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (C) 2018 Oracle.  All Rights Reserved.
+# Author: Darrick J. Wong <djwong@kernel.org>
+
 [Unit]
 Description=Online XFS Metadata Check for All Filesystems
 ConditionACPower=true
diff --git a/scrub/xfs_scrub_all.timer b/scrub/xfs_scrub_all.timer
index 2e4a33b1666..1aef11e18f9 100644
--- a/scrub/xfs_scrub_all.timer
+++ b/scrub/xfs_scrub_all.timer
@@ -1,3 +1,8 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (C) 2018 Oracle.  All Rights Reserved.
+# Author: Darrick J. Wong <djwong@kernel.org>
+
 [Unit]
 Description=Periodic XFS Online Metadata Check for All Filesystems
 
diff --git a/scrub/xfs_scrub_fail b/scrub/xfs_scrub_fail
index 36dd50e9653..8ada5dbbe06 100755
--- a/scrub/xfs_scrub_fail
+++ b/scrub/xfs_scrub_fail
@@ -1,5 +1,10 @@
 #!/bin/bash
 
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (C) 2018 Oracle.  All Rights Reserved.
+# Author: Darrick J. Wong <djwong@kernel.org>
+
 # Email logs of failed xfs_scrub unit runs
 
 mailer=/usr/sbin/sendmail
diff --git a/scrub/xfs_scrub_fail@.service.in b/scrub/xfs_scrub_fail@.service.in
index 8d106e9ba4b..ac0cb2e283b 100644
--- a/scrub/xfs_scrub_fail@.service.in
+++ b/scrub/xfs_scrub_fail@.service.in
@@ -1,3 +1,8 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (C) 2018 Oracle.  All Rights Reserved.
+# Author: Darrick J. Wong <djwong@kernel.org>
+
 [Unit]
 Description=Online XFS Metadata Check Failure Reporting for %I
 Documentation=man:xfs_scrub(8)

