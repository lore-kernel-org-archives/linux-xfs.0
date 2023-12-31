Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30FB0C127
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qW6JbiY+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE671C433C8;
	Sun, 31 Dec 2023 22:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704060248;
	bh=oyZBK2ymtUZ90PwTLJ10/Z6/sSn6oGhKWlLkjkn+qtw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qW6JbiY+bFEQYLteFB6pXW4aJ6vrlBrAQ6GSjeUupPxIMk/CxMY7swoJ9eO+o9cxB
	 cRmubz8hpRbRU5QoVCWQTD6LPZdYbm4fdMnkw5A8Y99rJeb4D1t6we29oZR3ql8r/i
	 ZihJW5k7ymMwc+Bxt8NpQuXrKxJCl02poVooD19v1WADizsbSvEVtD7sCf4op2T8Tw
	 7TxPo8yFOT8MkqFaLMU7m/lo6JhLkyFWJz2qGT2oi5zpDOnbrWWRMcTgyu6BDtr/bI
	 +qOY2cUZJw43fVYAzGh4AjIStRTWr2yVJMuNLSyFSOzZnWKUxMc2vowpHB5yDnv5D+
	 J5HJDxstHehxw==
Date: Sun, 31 Dec 2023 14:04:07 -0800
Subject: [PATCH 1/3] xfs_scrub: fix author and spdx headers on scrub/ files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404989107.1791307.8796926188438152942.stgit@frogsfrogsfrogs>
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

Fix the spdx tags to match current practice, and update the author
contact information.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/common.c         |    4 ++--
 scrub/common.h         |    4 ++--
 scrub/counter.c        |    4 ++--
 scrub/counter.h        |    4 ++--
 scrub/descr.c          |    2 +-
 scrub/descr.h          |    2 +-
 scrub/disk.c           |    4 ++--
 scrub/disk.h           |    4 ++--
 scrub/filemap.c        |    4 ++--
 scrub/filemap.h        |    4 ++--
 scrub/fscounters.c     |    4 ++--
 scrub/fscounters.h     |    4 ++--
 scrub/inodes.c         |    4 ++--
 scrub/inodes.h         |    4 ++--
 scrub/phase1.c         |    4 ++--
 scrub/phase2.c         |    4 ++--
 scrub/phase3.c         |    4 ++--
 scrub/phase4.c         |    4 ++--
 scrub/phase5.c         |    4 ++--
 scrub/phase6.c         |    4 ++--
 scrub/phase7.c         |    4 ++--
 scrub/progress.c       |    4 ++--
 scrub/progress.h       |    4 ++--
 scrub/read_verify.c    |    4 ++--
 scrub/read_verify.h    |    4 ++--
 scrub/repair.c         |    4 ++--
 scrub/repair.h         |    4 ++--
 scrub/scrub.c          |    4 ++--
 scrub/scrub.h          |    4 ++--
 scrub/spacemap.c       |    4 ++--
 scrub/spacemap.h       |    4 ++--
 scrub/unicrash.c       |    4 ++--
 scrub/unicrash.h       |    4 ++--
 scrub/vfs.c            |    4 ++--
 scrub/vfs.h            |    4 ++--
 scrub/xfs_scrub.c      |    4 ++--
 scrub/xfs_scrub.h      |    4 ++--
 scrub/xfs_scrub_all.in |    4 ++--
 38 files changed, 74 insertions(+), 74 deletions(-)


diff --git a/scrub/common.c b/scrub/common.c
index 49a87f412c4..25a398c5fe4 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -1,7 +1,7 @@
-// SPDX-License-Identifier: GPL-2.0+
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (C) 2018 Oracle.  All Rights Reserved.
- * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #include "xfs.h"
 #include <pthread.h>
diff --git a/scrub/common.h b/scrub/common.h
index 13b5f309955..26ef7c861c6 100644
--- a/scrub/common.h
+++ b/scrub/common.h
@@ -1,7 +1,7 @@
-// SPDX-License-Identifier: GPL-2.0+
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (C) 2018 Oracle.  All Rights Reserved.
- * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #ifndef XFS_SCRUB_COMMON_H_
 #define XFS_SCRUB_COMMON_H_
diff --git a/scrub/counter.c b/scrub/counter.c
index 6d91eb6e015..b63ec721c34 100644
--- a/scrub/counter.c
+++ b/scrub/counter.c
@@ -1,7 +1,7 @@
-// SPDX-License-Identifier: GPL-2.0+
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (C) 2018 Oracle.  All Rights Reserved.
- * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #include "xfs.h"
 #include <stdint.h>
diff --git a/scrub/counter.h b/scrub/counter.h
index 01b65056a2e..77e380cc611 100644
--- a/scrub/counter.h
+++ b/scrub/counter.h
@@ -1,7 +1,7 @@
-// SPDX-License-Identifier: GPL-2.0+
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (C) 2018 Oracle.  All Rights Reserved.
- * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #ifndef XFS_SCRUB_COUNTER_H_
 #define XFS_SCRUB_COUNTER_H_
diff --git a/scrub/descr.c b/scrub/descr.c
index e694d01d7b7..bf0c5717a11 100644
--- a/scrub/descr.c
+++ b/scrub/descr.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (C) 2019 Oracle.  All Rights Reserved.
- * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #include "xfs.h"
 #include <assert.h>
diff --git a/scrub/descr.h b/scrub/descr.h
index f1899b67206..0f5d9067e5d 100644
--- a/scrub/descr.h
+++ b/scrub/descr.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * Copyright (C) 2019 Oracle.  All Rights Reserved.
- * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #ifndef XFS_SCRUB_DESCR_H_
 #define XFS_SCRUB_DESCR_H_
diff --git a/scrub/disk.c b/scrub/disk.c
index a1ef798a025..740a7ac962f 100644
--- a/scrub/disk.c
+++ b/scrub/disk.c
@@ -1,7 +1,7 @@
-// SPDX-License-Identifier: GPL-2.0+
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (C) 2018 Oracle.  All Rights Reserved.
- * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #include "xfs.h"
 #include <stdint.h>
diff --git a/scrub/disk.h b/scrub/disk.h
index 36bfb8263d1..1f6c73aee3d 100644
--- a/scrub/disk.h
+++ b/scrub/disk.h
@@ -1,7 +1,7 @@
-// SPDX-License-Identifier: GPL-2.0+
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (C) 2018 Oracle.  All Rights Reserved.
- * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #ifndef XFS_SCRUB_DISK_H_
 #define XFS_SCRUB_DISK_H_
diff --git a/scrub/filemap.c b/scrub/filemap.c
index d4905ace659..c1e520299ed 100644
--- a/scrub/filemap.c
+++ b/scrub/filemap.c
@@ -1,7 +1,7 @@
-// SPDX-License-Identifier: GPL-2.0+
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (C) 2018 Oracle.  All Rights Reserved.
- * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #include "xfs.h"
 #include <stdint.h>
diff --git a/scrub/filemap.h b/scrub/filemap.h
index 133e860bb82..d123537aaff 100644
--- a/scrub/filemap.h
+++ b/scrub/filemap.h
@@ -1,7 +1,7 @@
-// SPDX-License-Identifier: GPL-2.0+
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (C) 2018 Oracle.  All Rights Reserved.
- * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #ifndef XFS_SCRUB_FILEMAP_H_
 #define XFS_SCRUB_FILEMAP_H_
diff --git a/scrub/fscounters.c b/scrub/fscounters.c
index 3ceae3715dc..6df0533a0b7 100644
--- a/scrub/fscounters.c
+++ b/scrub/fscounters.c
@@ -1,7 +1,7 @@
-// SPDX-License-Identifier: GPL-2.0+
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (C) 2018 Oracle.  All Rights Reserved.
- * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #include "xfs.h"
 #include <stdint.h>
diff --git a/scrub/fscounters.h b/scrub/fscounters.h
index 13bd9967f00..fb0923afe70 100644
--- a/scrub/fscounters.h
+++ b/scrub/fscounters.h
@@ -1,7 +1,7 @@
-// SPDX-License-Identifier: GPL-2.0+
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (C) 2018 Oracle.  All Rights Reserved.
- * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #ifndef XFS_SCRUB_FSCOUNTERS_H_
 #define XFS_SCRUB_FSCOUNTERS_H_
diff --git a/scrub/inodes.c b/scrub/inodes.c
index 78f0914b8d9..d937915312d 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -1,7 +1,7 @@
-// SPDX-License-Identifier: GPL-2.0+
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (C) 2018 Oracle.  All Rights Reserved.
- * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #include "xfs.h"
 #include <stdint.h>
diff --git a/scrub/inodes.h b/scrub/inodes.h
index f03180458ab..40e1291d15e 100644
--- a/scrub/inodes.h
+++ b/scrub/inodes.h
@@ -1,7 +1,7 @@
-// SPDX-License-Identifier: GPL-2.0+
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (C) 2018 Oracle.  All Rights Reserved.
- * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #ifndef XFS_SCRUB_INODES_H_
 #define XFS_SCRUB_INODES_H_
diff --git a/scrub/phase1.c b/scrub/phase1.c
index 2daf5c7bb38..9e838fad91f 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -1,7 +1,7 @@
-// SPDX-License-Identifier: GPL-2.0+
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (C) 2018 Oracle.  All Rights Reserved.
- * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #include "xfs.h"
 #include <unistd.h>
diff --git a/scrub/phase2.c b/scrub/phase2.c
index 8f82e2a6c04..48c9f589f7c 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -1,7 +1,7 @@
-// SPDX-License-Identifier: GPL-2.0+
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (C) 2018 Oracle.  All Rights Reserved.
- * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #include "xfs.h"
 #include <stdint.h>
diff --git a/scrub/phase3.c b/scrub/phase3.c
index 65e903f23d2..98742e0b72f 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -1,7 +1,7 @@
-// SPDX-License-Identifier: GPL-2.0+
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (C) 2018 Oracle.  All Rights Reserved.
- * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #include "xfs.h"
 #include <stdint.h>
diff --git a/scrub/phase4.c b/scrub/phase4.c
index ecd56056ca2..a67abd76a17 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -1,7 +1,7 @@
-// SPDX-License-Identifier: GPL-2.0+
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (C) 2018 Oracle.  All Rights Reserved.
- * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #include "xfs.h"
 #include <stdint.h>
diff --git a/scrub/phase5.c b/scrub/phase5.c
index 31405709657..4cf56ee591a 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -1,7 +1,7 @@
-// SPDX-License-Identifier: GPL-2.0+
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (C) 2018 Oracle.  All Rights Reserved.
- * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #include "xfs.h"
 #include <stdint.h>
diff --git a/scrub/phase6.c b/scrub/phase6.c
index afdb16b689c..e2de20c63c4 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -1,7 +1,7 @@
-// SPDX-License-Identifier: GPL-2.0+
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (C) 2018 Oracle.  All Rights Reserved.
- * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #include "xfs.h"
 #include <stdint.h>
diff --git a/scrub/phase7.c b/scrub/phase7.c
index 8d8034c36af..fe928d79eae 100644
--- a/scrub/phase7.c
+++ b/scrub/phase7.c
@@ -1,7 +1,7 @@
-// SPDX-License-Identifier: GPL-2.0+
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (C) 2018 Oracle.  All Rights Reserved.
- * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #include "xfs.h"
 #include <stdint.h>
diff --git a/scrub/progress.c b/scrub/progress.c
index a3d096f98e2..ffbf3ef3676 100644
--- a/scrub/progress.c
+++ b/scrub/progress.c
@@ -1,7 +1,7 @@
-// SPDX-License-Identifier: GPL-2.0+
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (C) 2018 Oracle.  All Rights Reserved.
- * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #include "xfs.h"
 #include <dirent.h>
diff --git a/scrub/progress.h b/scrub/progress.h
index c1a115cbe80..561695e2ac2 100644
--- a/scrub/progress.h
+++ b/scrub/progress.h
@@ -1,7 +1,7 @@
-// SPDX-License-Identifier: GPL-2.0+
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (C) 2018 Oracle.  All Rights Reserved.
- * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #ifndef XFS_SCRUB_PROGRESS_H_
 #define XFS_SCRUB_PROGRESS_H_
diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index be30f2688f9..435f54e2a84 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -1,7 +1,7 @@
-// SPDX-License-Identifier: GPL-2.0+
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (C) 2018 Oracle.  All Rights Reserved.
- * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #include "xfs.h"
 #include <stdint.h>
diff --git a/scrub/read_verify.h b/scrub/read_verify.h
index 650c46d447b..66f098954b6 100644
--- a/scrub/read_verify.h
+++ b/scrub/read_verify.h
@@ -1,7 +1,7 @@
-// SPDX-License-Identifier: GPL-2.0+
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (C) 2018 Oracle.  All Rights Reserved.
- * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #ifndef XFS_SCRUB_READ_VERIFY_H_
 #define XFS_SCRUB_READ_VERIFY_H_
diff --git a/scrub/repair.c b/scrub/repair.c
index 5fc5ab836c7..107aa25a016 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -1,7 +1,7 @@
-// SPDX-License-Identifier: GPL-2.0+
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (C) 2018 Oracle.  All Rights Reserved.
- * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #include "xfs.h"
 #include <stdint.h>
diff --git a/scrub/repair.h b/scrub/repair.h
index 102e5779c70..b67c1ac95e6 100644
--- a/scrub/repair.h
+++ b/scrub/repair.h
@@ -1,7 +1,7 @@
-/* SPDX-License-Identifier: GPL-2.0+ */
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * Copyright (C) 2018 Oracle.  All Rights Reserved.
- * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #ifndef XFS_SCRUB_REPAIR_H_
 #define XFS_SCRUB_REPAIR_H_
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 1469058bd23..376dc1a1625 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -1,7 +1,7 @@
-// SPDX-License-Identifier: GPL-2.0+
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (C) 2018 Oracle.  All Rights Reserved.
- * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #include "xfs.h"
 #include <stdint.h>
diff --git a/scrub/scrub.h b/scrub/scrub.h
index 023069ee066..b3e2742a17b 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -1,7 +1,7 @@
-// SPDX-License-Identifier: GPL-2.0+
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (C) 2018 Oracle.  All Rights Reserved.
- * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #ifndef XFS_SCRUB_SCRUB_H_
 #define XFS_SCRUB_SCRUB_H_
diff --git a/scrub/spacemap.c b/scrub/spacemap.c
index 03440d3a854..d0adae6780c 100644
--- a/scrub/spacemap.c
+++ b/scrub/spacemap.c
@@ -1,7 +1,7 @@
-// SPDX-License-Identifier: GPL-2.0+
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (C) 2018 Oracle.  All Rights Reserved.
- * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #include "xfs.h"
 #include <stdint.h>
diff --git a/scrub/spacemap.h b/scrub/spacemap.h
index 8a6d1e36158..787f4652fa2 100644
--- a/scrub/spacemap.h
+++ b/scrub/spacemap.h
@@ -1,7 +1,7 @@
-// SPDX-License-Identifier: GPL-2.0+
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (C) 2018 Oracle.  All Rights Reserved.
- * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #ifndef XFS_SCRUB_SPACEMAP_H_
 #define XFS_SCRUB_SPACEMAP_H_
diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index 24d4ea58211..dd0ec22feab 100644
--- a/scrub/unicrash.c
+++ b/scrub/unicrash.c
@@ -1,7 +1,7 @@
-// SPDX-License-Identifier: GPL-2.0+
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (C) 2018 Oracle.  All Rights Reserved.
- * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #include "xfs.h"
 #include <stdint.h>
diff --git a/scrub/unicrash.h b/scrub/unicrash.h
index 755afaef18c..6ac56e72176 100644
--- a/scrub/unicrash.h
+++ b/scrub/unicrash.h
@@ -1,7 +1,7 @@
-// SPDX-License-Identifier: GPL-2.0+
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (C) 2018 Oracle.  All Rights Reserved.
- * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #ifndef XFS_SCRUB_UNICRASH_H_
 #define XFS_SCRUB_UNICRASH_H_
diff --git a/scrub/vfs.c b/scrub/vfs.c
index 3c1825a75e7..86e7910a1a6 100644
--- a/scrub/vfs.c
+++ b/scrub/vfs.c
@@ -1,7 +1,7 @@
-// SPDX-License-Identifier: GPL-2.0+
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (C) 2018 Oracle.  All Rights Reserved.
- * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #include "xfs.h"
 #include <stdint.h>
diff --git a/scrub/vfs.h b/scrub/vfs.h
index dc1099cf18d..24e04531227 100644
--- a/scrub/vfs.h
+++ b/scrub/vfs.h
@@ -1,7 +1,7 @@
-// SPDX-License-Identifier: GPL-2.0+
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (C) 2018 Oracle.  All Rights Reserved.
- * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #ifndef XFS_SCRUB_VFS_H_
 #define XFS_SCRUB_VFS_H_
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 597be59f9f9..1c409690736 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -1,7 +1,7 @@
-// SPDX-License-Identifier: GPL-2.0+
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (C) 2018 Oracle.  All Rights Reserved.
- * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #include "xfs.h"
 #include <pthread.h>
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index 0d6b9dad2c9..1c45f8753af 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -1,7 +1,7 @@
-// SPDX-License-Identifier: GPL-2.0+
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (C) 2018 Oracle.  All Rights Reserved.
- * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #ifndef XFS_SCRUB_XFS_SCRUB_H_
 #define XFS_SCRUB_XFS_SCRUB_H_
diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
index 5b76b49adab..6276e32f515 100644
--- a/scrub/xfs_scrub_all.in
+++ b/scrub/xfs_scrub_all.in
@@ -1,9 +1,9 @@
 #!/usr/bin/python3
 
-# SPDX-License-Identifier: GPL-2.0+
+# SPDX-License-Identifier: GPL-2.0-or-later
 # Copyright (C) 2018 Oracle.  All rights reserved.
 #
-# Author: Darrick J. Wong <darrick.wong@oracle.com>
+# Author: Darrick J. Wong <djwong@kernel.org>
 
 # Run online scrubbers in parallel, but avoid thrashing.
 

