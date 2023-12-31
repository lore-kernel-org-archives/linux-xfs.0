Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF2CBE4A
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NdsH3wKs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 236ECC433C7;
	Sun, 31 Dec 2023 22:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704060279;
	bh=dm+rALLPYbaoZrbdnWxb8UBvwiV5J9g27q1lVp461eg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NdsH3wKs0Gc9g67s2b8PNJGb7kAr6q5pvmkLtHk6zwy8T7uk779P3i6atD5ASmJio
	 fRu9oYC/azddLP1n4LRKzpSn7W9ABa3bZlLDzL5Jre6ReCM1jM3f1JYc092qzWMEKC
	 IFX38ZU1y8ue6O5IpfxaTfN9z5d70t5kInAK/2RzTPi7RnklKYiqHFonuV6tkaRzV8
	 317+VVtl/mn8Ks3TgJE9iIK2rGie1QuGmoS94IWq2BDtycEeMDlG1SDKapZNR/dUtj
	 n0RBj/SEMHNaSj8bwQs7ZQcH8lXsdOgqGQAjegRikaO34jfrlzu32v5XBJWOL83No5
	 DoRZtMCXCFZ9g==
Date: Sun, 31 Dec 2023 14:04:38 -0800
Subject: [PATCH 3/3] xfs_scrub: update copyright years for scrub/ files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404989135.1791307.8914004017674892036.stgit@frogsfrogsfrogs>
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

Update the copyright years in the scrub/ source code files.  This isn't
required, but it's helpful to remind myself just how long it's taken to
develop this feature.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/Makefile         |    2 +-
 scrub/common.c         |    2 +-
 scrub/common.h         |    2 +-
 scrub/counter.c        |    2 +-
 scrub/counter.h        |    2 +-
 scrub/descr.c          |    2 +-
 scrub/descr.h          |    2 +-
 scrub/disk.c           |    2 +-
 scrub/disk.h           |    2 +-
 scrub/filemap.c        |    2 +-
 scrub/filemap.h        |    2 +-
 scrub/fscounters.c     |    2 +-
 scrub/fscounters.h     |    2 +-
 scrub/inodes.c         |    2 +-
 scrub/inodes.h         |    2 +-
 scrub/phase1.c         |    2 +-
 scrub/phase2.c         |    2 +-
 scrub/phase3.c         |    2 +-
 scrub/phase4.c         |    2 +-
 scrub/phase5.c         |    2 +-
 scrub/phase6.c         |    2 +-
 scrub/phase7.c         |    2 +-
 scrub/progress.c       |    2 +-
 scrub/progress.h       |    2 +-
 scrub/read_verify.c    |    2 +-
 scrub/read_verify.h    |    2 +-
 scrub/repair.c         |    2 +-
 scrub/repair.h         |    2 +-
 scrub/scrub.c          |    2 +-
 scrub/scrub.h          |    2 +-
 scrub/spacemap.c       |    2 +-
 scrub/spacemap.h       |    2 +-
 scrub/unicrash.c       |    2 +-
 scrub/unicrash.h       |    2 +-
 scrub/vfs.c            |    2 +-
 scrub/vfs.h            |    2 +-
 scrub/xfs_scrub.c      |    2 +-
 scrub/xfs_scrub.h      |    2 +-
 scrub/xfs_scrub_all.in |    2 +-
 39 files changed, 39 insertions(+), 39 deletions(-)


diff --git a/scrub/Makefile b/scrub/Makefile
index 4ad54717833..24af9716120 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-# Copyright (C) 2018 Oracle.  All Rights Reserved.
+# Copyright (C) 2018-2024 Oracle.  All Rights Reserved.
 #
 
 TOPDIR = ..
diff --git a/scrub/common.c b/scrub/common.c
index 25a398c5fe4..283ac84e232 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * Copyright (C) 2018 Oracle.  All Rights Reserved.
+ * Copyright (C) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #include "xfs.h"
diff --git a/scrub/common.h b/scrub/common.h
index 26ef7c861c6..865c1caa446 100644
--- a/scrub/common.h
+++ b/scrub/common.h
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * Copyright (C) 2018 Oracle.  All Rights Reserved.
+ * Copyright (C) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #ifndef XFS_SCRUB_COMMON_H_
diff --git a/scrub/counter.c b/scrub/counter.c
index b63ec721c34..2ee357f3a76 100644
--- a/scrub/counter.c
+++ b/scrub/counter.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * Copyright (C) 2018 Oracle.  All Rights Reserved.
+ * Copyright (C) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #include "xfs.h"
diff --git a/scrub/counter.h b/scrub/counter.h
index 77e380cc611..102d8bd8227 100644
--- a/scrub/counter.h
+++ b/scrub/counter.h
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * Copyright (C) 2018 Oracle.  All Rights Reserved.
+ * Copyright (C) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #ifndef XFS_SCRUB_COUNTER_H_
diff --git a/scrub/descr.c b/scrub/descr.c
index bf0c5717a11..77d5378ec3f 100644
--- a/scrub/descr.c
+++ b/scrub/descr.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * Copyright (C) 2019 Oracle.  All Rights Reserved.
+ * Copyright (C) 2019-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #include "xfs.h"
diff --git a/scrub/descr.h b/scrub/descr.h
index 0f5d9067e5d..0a014f5404b 100644
--- a/scrub/descr.h
+++ b/scrub/descr.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
- * Copyright (C) 2019 Oracle.  All Rights Reserved.
+ * Copyright (C) 2019-2023 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #ifndef XFS_SCRUB_DESCR_H_
diff --git a/scrub/disk.c b/scrub/disk.c
index 740a7ac962f..addb964d72f 100644
--- a/scrub/disk.c
+++ b/scrub/disk.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * Copyright (C) 2018 Oracle.  All Rights Reserved.
+ * Copyright (C) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #include "xfs.h"
diff --git a/scrub/disk.h b/scrub/disk.h
index 1f6c73aee3d..73c73ab57fb 100644
--- a/scrub/disk.h
+++ b/scrub/disk.h
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * Copyright (C) 2018 Oracle.  All Rights Reserved.
+ * Copyright (C) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #ifndef XFS_SCRUB_DISK_H_
diff --git a/scrub/filemap.c b/scrub/filemap.c
index c1e520299ed..1fb69c38e3c 100644
--- a/scrub/filemap.c
+++ b/scrub/filemap.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * Copyright (C) 2018 Oracle.  All Rights Reserved.
+ * Copyright (C) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #include "xfs.h"
diff --git a/scrub/filemap.h b/scrub/filemap.h
index d123537aaff..062b42e597b 100644
--- a/scrub/filemap.h
+++ b/scrub/filemap.h
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * Copyright (C) 2018 Oracle.  All Rights Reserved.
+ * Copyright (C) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #ifndef XFS_SCRUB_FILEMAP_H_
diff --git a/scrub/fscounters.c b/scrub/fscounters.c
index 6df0533a0b7..098bf87465e 100644
--- a/scrub/fscounters.c
+++ b/scrub/fscounters.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * Copyright (C) 2018 Oracle.  All Rights Reserved.
+ * Copyright (C) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #include "xfs.h"
diff --git a/scrub/fscounters.h b/scrub/fscounters.h
index fb0923afe70..a3dd6883702 100644
--- a/scrub/fscounters.h
+++ b/scrub/fscounters.h
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * Copyright (C) 2018 Oracle.  All Rights Reserved.
+ * Copyright (C) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #ifndef XFS_SCRUB_FSCOUNTERS_H_
diff --git a/scrub/inodes.c b/scrub/inodes.c
index d937915312d..16c79cf495c 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * Copyright (C) 2018 Oracle.  All Rights Reserved.
+ * Copyright (C) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #include "xfs.h"
diff --git a/scrub/inodes.h b/scrub/inodes.h
index 40e1291d15e..9447fb56aa6 100644
--- a/scrub/inodes.h
+++ b/scrub/inodes.h
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * Copyright (C) 2018 Oracle.  All Rights Reserved.
+ * Copyright (C) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #ifndef XFS_SCRUB_INODES_H_
diff --git a/scrub/phase1.c b/scrub/phase1.c
index 9e838fad91f..48ca8313b05 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * Copyright (C) 2018 Oracle.  All Rights Reserved.
+ * Copyright (C) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #include "xfs.h"
diff --git a/scrub/phase2.c b/scrub/phase2.c
index 48c9f589f7c..6b88384171f 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * Copyright (C) 2018 Oracle.  All Rights Reserved.
+ * Copyright (C) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #include "xfs.h"
diff --git a/scrub/phase3.c b/scrub/phase3.c
index 98742e0b72f..4235c228c0e 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * Copyright (C) 2018 Oracle.  All Rights Reserved.
+ * Copyright (C) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #include "xfs.h"
diff --git a/scrub/phase4.c b/scrub/phase4.c
index a67abd76a17..1228c7cb654 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * Copyright (C) 2018 Oracle.  All Rights Reserved.
+ * Copyright (C) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #include "xfs.h"
diff --git a/scrub/phase5.c b/scrub/phase5.c
index 4cf56ee591a..7e0eaca9042 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * Copyright (C) 2018 Oracle.  All Rights Reserved.
+ * Copyright (C) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #include "xfs.h"
diff --git a/scrub/phase6.c b/scrub/phase6.c
index e2de20c63c4..33c3c8bde3c 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * Copyright (C) 2018 Oracle.  All Rights Reserved.
+ * Copyright (C) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #include "xfs.h"
diff --git a/scrub/phase7.c b/scrub/phase7.c
index fe928d79eae..2fd96053f6c 100644
--- a/scrub/phase7.c
+++ b/scrub/phase7.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * Copyright (C) 2018 Oracle.  All Rights Reserved.
+ * Copyright (C) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #include "xfs.h"
diff --git a/scrub/progress.c b/scrub/progress.c
index ffbf3ef3676..f1bbade0828 100644
--- a/scrub/progress.c
+++ b/scrub/progress.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * Copyright (C) 2018 Oracle.  All Rights Reserved.
+ * Copyright (C) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #include "xfs.h"
diff --git a/scrub/progress.h b/scrub/progress.h
index 561695e2ac2..796939adb81 100644
--- a/scrub/progress.h
+++ b/scrub/progress.h
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * Copyright (C) 2018 Oracle.  All Rights Reserved.
+ * Copyright (C) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #ifndef XFS_SCRUB_PROGRESS_H_
diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index 435f54e2a84..29d7939549f 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * Copyright (C) 2018 Oracle.  All Rights Reserved.
+ * Copyright (C) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #include "xfs.h"
diff --git a/scrub/read_verify.h b/scrub/read_verify.h
index 66f098954b6..9d34d839c97 100644
--- a/scrub/read_verify.h
+++ b/scrub/read_verify.h
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * Copyright (C) 2018 Oracle.  All Rights Reserved.
+ * Copyright (C) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #ifndef XFS_SCRUB_READ_VERIFY_H_
diff --git a/scrub/repair.c b/scrub/repair.c
index 107aa25a016..65b6dd89530 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * Copyright (C) 2018 Oracle.  All Rights Reserved.
+ * Copyright (C) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #include "xfs.h"
diff --git a/scrub/repair.h b/scrub/repair.h
index b67c1ac95e6..486617f1ce4 100644
--- a/scrub/repair.h
+++ b/scrub/repair.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
- * Copyright (C) 2018 Oracle.  All Rights Reserved.
+ * Copyright (C) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #ifndef XFS_SCRUB_REPAIR_H_
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 376dc1a1625..756f1915ab9 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * Copyright (C) 2018 Oracle.  All Rights Reserved.
+ * Copyright (C) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #include "xfs.h"
diff --git a/scrub/scrub.h b/scrub/scrub.h
index b3e2742a17b..f7e66bb614b 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * Copyright (C) 2018 Oracle.  All Rights Reserved.
+ * Copyright (C) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #ifndef XFS_SCRUB_SCRUB_H_
diff --git a/scrub/spacemap.c b/scrub/spacemap.c
index d0adae6780c..b6fd411816b 100644
--- a/scrub/spacemap.c
+++ b/scrub/spacemap.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * Copyright (C) 2018 Oracle.  All Rights Reserved.
+ * Copyright (C) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #include "xfs.h"
diff --git a/scrub/spacemap.h b/scrub/spacemap.h
index 787f4652fa2..51975341b16 100644
--- a/scrub/spacemap.h
+++ b/scrub/spacemap.h
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * Copyright (C) 2018 Oracle.  All Rights Reserved.
+ * Copyright (C) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #ifndef XFS_SCRUB_SPACEMAP_H_
diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index dd0ec22feab..dd30164354e 100644
--- a/scrub/unicrash.c
+++ b/scrub/unicrash.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * Copyright (C) 2018 Oracle.  All Rights Reserved.
+ * Copyright (C) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #include "xfs.h"
diff --git a/scrub/unicrash.h b/scrub/unicrash.h
index 6ac56e72176..3b6f40540aa 100644
--- a/scrub/unicrash.h
+++ b/scrub/unicrash.h
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * Copyright (C) 2018 Oracle.  All Rights Reserved.
+ * Copyright (C) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #ifndef XFS_SCRUB_UNICRASH_H_
diff --git a/scrub/vfs.c b/scrub/vfs.c
index 86e7910a1a6..9e459d6243f 100644
--- a/scrub/vfs.c
+++ b/scrub/vfs.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * Copyright (C) 2018 Oracle.  All Rights Reserved.
+ * Copyright (C) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #include "xfs.h"
diff --git a/scrub/vfs.h b/scrub/vfs.h
index 24e04531227..1ac41e5aac0 100644
--- a/scrub/vfs.h
+++ b/scrub/vfs.h
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * Copyright (C) 2018 Oracle.  All Rights Reserved.
+ * Copyright (C) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #ifndef XFS_SCRUB_VFS_H_
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 1c409690736..a1b67544391 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * Copyright (C) 2018 Oracle.  All Rights Reserved.
+ * Copyright (C) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #include "xfs.h"
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index 1c45f8753af..7aea79d9555 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * Copyright (C) 2018 Oracle.  All Rights Reserved.
+ * Copyright (C) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
 #ifndef XFS_SCRUB_XFS_SCRUB_H_
diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
index 6276e32f515..5042321a738 100644
--- a/scrub/xfs_scrub_all.in
+++ b/scrub/xfs_scrub_all.in
@@ -1,7 +1,7 @@
 #!/usr/bin/python3
 
 # SPDX-License-Identifier: GPL-2.0-or-later
-# Copyright (C) 2018 Oracle.  All rights reserved.
+# Copyright (C) 2018-2024 Oracle.  All rights reserved.
 #
 # Author: Darrick J. Wong <djwong@kernel.org>
 

