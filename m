Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBDBFF4FB
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 02:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709000405; cv=none; b=pqFHxF/fgVRbL7etv3rJ5dM8q28XehXLJbrhHS4qImIWO9cRzwo9UpQ5DxO1BSGi5f9iQMbUZKsTim18CGWwCDPYhOkHKo+VVyMdAnSQMnywopZQ3clI3bTpPmch4v+NcsIQMnl0zDnaiNANcO0H1ivJSFRUhYoEZVzxn/oeHbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709000405; c=relaxed/simple;
	bh=59KO599Wx3wVXz9WifSnkYRFZ/tZ5+V/isPhCD3xmI8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UczlYAk0Yk1nFX/tiiZFdmrqJrXuEvBj1W5EzmeNHP2nz6gykODpoqPM8mLBDRIOtlObQ5ES1WpZrL50ZTNeWRht8HNoKTSbDgaoGRyAkDgW+g/DnVMoUHO9mpwX7AANCZG8VfV15wIrXroB90QGVOdh8X05xvdd/Cw/Z+NvUok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eQJyakOr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eQJyakOr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93EDDC433C7;
	Tue, 27 Feb 2024 02:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709000405;
	bh=59KO599Wx3wVXz9WifSnkYRFZ/tZ5+V/isPhCD3xmI8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eQJyakOrOfclRukH6FE7D/kSJ/FbukO0/Xx1W6zNPXvPyKrfmoFN3egaaujNhImsn
	 hG4dic5n4QSA53p8LdTlzr1q9JFaKWshMAojXOlWUQj02dmgTtsNACgn9ppxGnpNNB
	 OKIPZ9QzFM6ATGvhPHgPneliXev6oTw3y+a8g16kHAxz9CyL/E9LXylXpohH9ssKD+
	 dBIlPHAMat2gcF192+CJcfnQsxjKPgIA7T0kt5UsWykPYtJjYfUPboFRbr15ojjEXo
	 9puOoTkAYLH3miMemzneuawtC+7qeMKVrccwRYZFO+vGBVh4AeP02qOfeQZE6KfhAA
	 D3OqePcEhUmdg==
Date: Mon, 26 Feb 2024 18:20:05 -0800
Subject: [PATCH 3/6] xfs: declare xfs_file.c symbols in xfs_file.h
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170900011182.938068.18381389908075575352.stgit@frogsfrogsfrogs>
In-Reply-To: <170900011118.938068.16371783443726140795.stgit@frogsfrogsfrogs>
References: <170900011118.938068.16371783443726140795.stgit@frogsfrogsfrogs>
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

Move the two public symbols in xfs_file.c to xfs_file.h.  We're about to
add more public symbols in that source file, so let's finally create the
header file.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c  |    1 +
 fs/xfs/xfs_file.h  |   12 ++++++++++++
 fs/xfs/xfs_ioctl.c |    1 +
 fs/xfs/xfs_iops.c  |    1 +
 fs/xfs/xfs_iops.h  |    3 ---
 5 files changed, 15 insertions(+), 3 deletions(-)
 create mode 100644 fs/xfs/xfs_file.h


diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 40b778415f5fc..9961d4b5efbe6 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -24,6 +24,7 @@
 #include "xfs_pnfs.h"
 #include "xfs_iomap.h"
 #include "xfs_reflink.h"
+#include "xfs_file.h"
 
 #include <linux/dax.h>
 #include <linux/falloc.h>
diff --git a/fs/xfs/xfs_file.h b/fs/xfs/xfs_file.h
new file mode 100644
index 0000000000000..7d39e3eca56dc
--- /dev/null
+++ b/fs/xfs/xfs_file.h
@@ -0,0 +1,12 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+#ifndef __XFS_FILE_H__
+#define __XFS_FILE_H__
+
+extern const struct file_operations xfs_file_operations;
+extern const struct file_operations xfs_dir_file_operations;
+
+#endif /* __XFS_FILE_H__ */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index f02b6e558af58..1360a551118dd 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -39,6 +39,7 @@
 #include "xfs_ioctl.h"
 #include "xfs_xattr.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_file.h"
 
 #include <linux/mount.h>
 #include <linux/namei.h>
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index a0d77f5f512e2..11382c499c92c 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -25,6 +25,7 @@
 #include "xfs_error.h"
 #include "xfs_ioctl.h"
 #include "xfs_xattr.h"
+#include "xfs_file.h"
 
 #include <linux/posix_acl.h>
 #include <linux/security.h>
diff --git a/fs/xfs/xfs_iops.h b/fs/xfs/xfs_iops.h
index 8a38c3e2ed0e8..3c1a2605ffd2b 100644
--- a/fs/xfs/xfs_iops.h
+++ b/fs/xfs/xfs_iops.h
@@ -8,9 +8,6 @@
 
 struct xfs_inode;
 
-extern const struct file_operations xfs_file_operations;
-extern const struct file_operations xfs_dir_file_operations;
-
 extern ssize_t xfs_vn_listxattr(struct dentry *, char *data, size_t size);
 
 int xfs_vn_setattr_size(struct mnt_idmap *idmap,

