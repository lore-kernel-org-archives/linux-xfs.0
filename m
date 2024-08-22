Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805CF1D12E5;
	Thu, 22 Aug 2024 05:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724303141; cv=none; b=TG8aXRRQ8F0LlYdbEucy2gSLNV8yPYsaXTJay8MCO5Lvwk2RSjX2T/sf25XaH7pa8V9QCyuHbL5JQQ9o5R3pCndapT4U9Sio6Yj+ZV4I3pUuZw/kVNbnLmEyaTmiF4Fr0DSQVfiYGkhG2auZo817O4oz4XxM0FTbEdlmVSAq16U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724303141; c=relaxed/simple;
	bh=Q8Q7PkBg5ab+AVrC1AEzHW7YAzCknhWtNqlBQ06OAcc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KHxgUV6SjxnjIrgfOGReNK8GRC91yYXwQH0TCO0FvtsKFlPAG0bVuWwOFlolKnWHWWTpacNoK709tXXu5x1jiMigfzfooAptn8OXI4hWv2nzvphxohaDStwgzN5bZxvXNLufIrpLZxdIqZ3z4BWX2hqX0v/kd0rYkEjIdZhDN0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BTOzr8Cc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BTOzr8Cc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01B05C4AF09;
	Thu, 22 Aug 2024 05:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724303141;
	bh=Q8Q7PkBg5ab+AVrC1AEzHW7YAzCknhWtNqlBQ06OAcc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BTOzr8CcZIBPXTW1M0xzC5YcmKrMqg5aX0yvtCkdMSv5Pm/1+4fizpv9CBec44mCd
	 V/bBKf1fHsdAxpvlc8jMa1OwIesYba7lv0iXUI08NPoaxSJOYKF0GAMS/UKbjO4CFV
	 7KqkoBY6/TrHV/SRq/mSOerPQYkFmGuaJzvX0u1JhISUNcN4so3fgMvGElYISb8KZ6
	 n7D4JS1eLiJt+vw9FrBUWWbfDfwFY0kHOLip78Mq6Q2+PuQ5dRbErTnA2hf2HLcsJn
	 qjTX8B2jTlrQYV9wB8tX2yXzH2MeDMuEJt42hXJ3NycIW2sBpmkZnDysecQbVS+DmK
	 BHGQUhynvhEbA==
Date: Wed, 21 Aug 2024 22:05:40 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: kjell.m.randa@gmail.com, xfs <linux-xfs@vger.kernel.org>,
	fstests <fstests@vger.kernel.org>
Subject: [PATCH] xfs: add a test for v1 inodes with nonzero nlink and onlink
 fields
Message-ID: <20240822050540.GP865349@frogsfrogsfrogs>
References: <20240812224009.GD6051@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240812224009.GD6051@frogsfrogsfrogs>

From: Darrick J. Wong <djwong@kernel.org>

Add a regression test for XFS V1 inodes that have both nlink and onlink
fields set to 1.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/1890     |   39 +++++++++++++++++++++++++++++++++++++++
 tests/xfs/1890.out |    7 +++++++
 2 files changed, 46 insertions(+)
 create mode 100755 tests/xfs/1890
 create mode 100644 tests/xfs/1890.out

diff --git a/tests/xfs/1890 b/tests/xfs/1890
new file mode 100755
index 0000000000..c3813fca67
--- /dev/null
+++ b/tests/xfs/1890
@@ -0,0 +1,39 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1890
+#
+# Regression test for V1 inodes that have di_onlink and di_nlink set to 1.
+#
+. ./common/preamble
+_begin_fstest auto
+
+_fixed_by_kernel_commit XXXXXXXXXXXX \
+	"xfs: fix di_onlink checking for V1/V2 inodes",
+
+_require_scratch_nocheck	# we'll do our own checking
+_require_xfs_nocrc
+
+_scratch_mkfs -m crc=0 >> $seqres.full
+_scratch_xfs_db -x \
+	-c 'sb' \
+	-c 'addr rbmino' \
+	-c 'print core.nlinkv2 core.onlink' \
+	-c 'write -d core.version 1' \
+	-c 'write -d core.nlinkv1 1' \
+	-c 'print core.version core.nlinkv1'
+
+# repair doesn't flag this combination
+_scratch_xfs_repair -n &>> $seqres.full || echo "xfs_repair -n failed??"
+
+# Prior to kernel commit 40cb8613d612 ("xfs: check unused nlink fields in the
+# ondisk inode"), the kernel accepted V1 format inode where both the new and
+# old nlink fields are set to 1.  With that commit applied, it stopped
+# accepting that combination and will refuse to mount.  Hence we need the fix
+# mentioned above.
+_scratch_mount
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1890.out b/tests/xfs/1890.out
new file mode 100644
index 0000000000..166ae90286
--- /dev/null
+++ b/tests/xfs/1890.out
@@ -0,0 +1,7 @@
+QA output created by 1890
+core.nlinkv2 = 1
+core.onlink = 0
+core.version = 1
+core.nlinkv1 = 1
+core.version = 1
+core.nlinkv1 = 1
