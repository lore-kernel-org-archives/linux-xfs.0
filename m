Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1397BC126
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ruWndsfY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C791C433C7;
	Sun, 31 Dec 2023 22:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704060263;
	bh=qh0TedoYzWVyatY0xPcvL7fb/Tvpkj88PEmEgvbtP2g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ruWndsfYyFVCrJ0+FGZ9Zohiqs6T3plbGxGqAxEkzL6x7rKMzMJuFppMXanBCMfYq
	 VIsBXvo6NR9rL/Xvsnxnd6sbs4ZimnSLdt6tetgmxqviAdfI7CDvgYQPazMHdImlnP
	 teUKLgiNQMclrxV87Ai/o4/w5B2X9tYakrvwBzOZFyDgBi7rPrPXfBxeAAPB+R23U0
	 FhhxWwtKfqfHKIkja1VNgdY2SkhyhfenskRDjFiKnIqZ2DndtPuWTIySRL6KDw6Shp
	 y1kxZvjdABm/x/BpPI99K76dgeE7odV4gJ0jH1YhSHmK7rkvhZZQvGWMQoHKlI8Lg5
	 c3pprIoeqWxMw==
Date: Sun, 31 Dec 2023 14:04:23 -0800
Subject: [PATCH 2/3] xfs_scrub: add missing license and copyright information
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404989121.1791307.11991700038288629059.stgit@frogsfrogsfrogs>
In-Reply-To: <170404989091.1791307.1449422318127974555.stgit@frogsfrogsfrogs>
References: <170404989091.1791307.1449422318127974555.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

These files are missing the required SPDX license and copyright
information.  Add them.

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
index 6fb3f6ea2e9..d878eeda4fd 100644
--- a/scrub/xfs_scrub@.service.in
+++ b/scrub/xfs_scrub@.service.in
@@ -1,3 +1,8 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (C) 2018-2024 Oracle.  All Rights Reserved.
+# Author: Darrick J. Wong <djwong@kernel.org>
+
 [Unit]
 Description=Online XFS Metadata Check for %I
 OnFailure=xfs_scrub_fail@%i.service
diff --git a/scrub/xfs_scrub_all.cron.in b/scrub/xfs_scrub_all.cron.in
index 3dea9296077..c4d36958e76 100644
--- a/scrub/xfs_scrub_all.cron.in
+++ b/scrub/xfs_scrub_all.cron.in
@@ -1 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (C) 2018-2024 Oracle.  All Rights Reserved.
+# Author: Darrick J. Wong <djwong@kernel.org>
+#
 10 3 * * 0 root test -e /run/systemd/system || @sbindir@/xfs_scrub_all
diff --git a/scrub/xfs_scrub_all.service.in b/scrub/xfs_scrub_all.service.in
index b1b80da40a3..4011ed271f9 100644
--- a/scrub/xfs_scrub_all.service.in
+++ b/scrub/xfs_scrub_all.service.in
@@ -1,3 +1,8 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (C) 2018-2024 Oracle.  All Rights Reserved.
+# Author: Darrick J. Wong <djwong@kernel.org>
+
 [Unit]
 Description=Online XFS Metadata Check for All Filesystems
 ConditionACPower=true
diff --git a/scrub/xfs_scrub_all.timer b/scrub/xfs_scrub_all.timer
index 2e4a33b1666..e6ba4215b43 100644
--- a/scrub/xfs_scrub_all.timer
+++ b/scrub/xfs_scrub_all.timer
@@ -1,3 +1,8 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (C) 2018-2024 Oracle.  All Rights Reserved.
+# Author: Darrick J. Wong <djwong@kernel.org>
+
 [Unit]
 Description=Periodic XFS Online Metadata Check for All Filesystems
 
diff --git a/scrub/xfs_scrub_fail b/scrub/xfs_scrub_fail
index 36dd50e9653..415efaa24d6 100755
--- a/scrub/xfs_scrub_fail
+++ b/scrub/xfs_scrub_fail
@@ -1,5 +1,10 @@
 #!/bin/bash
 
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (C) 2018-2024 Oracle.  All Rights Reserved.
+# Author: Darrick J. Wong <djwong@kernel.org>
+
 # Email logs of failed xfs_scrub unit runs
 
 mailer=/usr/sbin/sendmail
diff --git a/scrub/xfs_scrub_fail@.service.in b/scrub/xfs_scrub_fail@.service.in
index 8d106e9ba4b..187adc17f6d 100644
--- a/scrub/xfs_scrub_fail@.service.in
+++ b/scrub/xfs_scrub_fail@.service.in
@@ -1,3 +1,8 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (C) 2018-2024 Oracle.  All Rights Reserved.
+# Author: Darrick J. Wong <djwong@kernel.org>
+
 [Unit]
 Description=Online XFS Metadata Check Failure Reporting for %I
 Documentation=man:xfs_scrub(8)

