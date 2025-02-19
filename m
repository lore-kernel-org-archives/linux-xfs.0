Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62808286292;
	Wed, 19 Feb 2025 01:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739927098; cv=none; b=OCsO04Sm7RFvmxYm2Qq+rBUc3Q5lfWUSoVCO+hLUSrl6pJZlVC4tYWzhkf9LfXhqGGR/UlzgdY4j9jzw0Ohpl3M5/TCd2lFSS4/JQJPyF5ZWzQyMDitPi/tLMKdPUl72izLCrpVdCuKepE763RzWEWdoJ0uukvrJiHcYGeqcZ5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739927098; c=relaxed/simple;
	bh=lzbQ0ox2eOEz4+fZ2wUFaKNbGzg099XkBo7eTUb9aaQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bctud+3kFa++egGAYV9aQe1yItAfx2iSRiTNKBL7xqH9I6t7+lhJnGqm5Y4nz21spn1Lt7Lp7ybXG+re1VVQyvBnOcJBxti6YxcpqDULOvBrs7LO+7hWi6hOQpMK4msms3I2On+655T9DUJvW4ieUgkq4WPSeEQGcO9qLCVq0lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NjWtutoj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NjWtutoj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D383EC4CEE2;
	Wed, 19 Feb 2025 01:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739927097;
	bh=lzbQ0ox2eOEz4+fZ2wUFaKNbGzg099XkBo7eTUb9aaQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NjWtutojUXv403EBq5UHJM4CNejeO5UYFfevXAxYbw1xNUlLZ+jKK3hHwhttBtgn3
	 NU3BnBZ0gXnPnuG5Hasckh9b+h5/Ceijg0YUrWb+0pmNrK0K0O1fQ7WCd5Z4HGdHVA
	 FSgfeAwHUQS0vl8YLGXj37fr/xVMC6z6hAnlXoUrn+qJ5LkcQImylCWxyrNotch9WR
	 /Z3YMK0nQTUwt2NQiEKHYSsJQw/cUAfX9U+sNmmoL++KuqDXS4ifC9uvTrQ8T7zmaQ
	 AdnwT6cbzaXho76tU91BugIz16qgraY+fMTEtMSPamq+PSkp0gDlIjidXGpu+GfefC
	 lQe6lU8RbMRlw==
Date: Tue, 18 Feb 2025 17:04:57 -0800
Subject: [PATCH 05/13] xfs: fix various problems with fsmap detecting the data
 device
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992591205.4080556.345335448207805708.stgit@frogsfrogsfrogs>
In-Reply-To: <173992591052.4080556.14368674525636291029.stgit@frogsfrogsfrogs>
References: <173992591052.4080556.14368674525636291029.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Various tests of realtime rmap functionality assumed that the data
device could be picked out from the GETFSMAP output by looking for
static fs metadata.  This is no longer true, since rtgroups filesystems
write a superblock header at the start of the rt device, so update these
tests.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/272 |    2 +-
 tests/xfs/276 |    2 +-
 tests/xfs/277 |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/tests/xfs/272 b/tests/xfs/272
index 3e3ceec512421d..1d0edf67600aa5 100755
--- a/tests/xfs/272
+++ b/tests/xfs/272
@@ -55,7 +55,7 @@ cat $TEST_DIR/bmap | while read ext offrange colon blockrange ag agrange total c
 done
 
 echo "Check device field of FS metadata and regular file"
-data_dev=$(grep 'static fs metadata' $TEST_DIR/fsmap | head -n 1 | awk '{print $2}')
+data_dev=$(grep 'inode btree' $TEST_DIR/fsmap | head -n 1 | awk '{print $2}')
 rt_dev=$(grep "${ino}[[:space:]]*[0-9]*\.\.[0-9]*" $TEST_DIR/fsmap | head -n 1 | awk '{print $2}')
 test "${data_dev}" = "${rt_dev}" || echo "data ${data_dev} realtime ${rt_dev}?"
 
diff --git a/tests/xfs/276 b/tests/xfs/276
index 69de69d86cda9c..b675e79b249a5b 100755
--- a/tests/xfs/276
+++ b/tests/xfs/276
@@ -59,7 +59,7 @@ cat $TEST_DIR/bmap | while read ext offrange colon blockrange ag agrange total c
 done
 
 echo "Check device field of FS metadata and realtime file"
-data_dev=$(grep 'static fs metadata' $TEST_DIR/fsmap | head -n 1 | awk '{print $2}')
+data_dev=$(grep 'inode btree' $TEST_DIR/fsmap | head -n 1 | awk '{print $2}')
 rt_dev=$(grep "${ino}[[:space:]]*[0-9]*\.\.[0-9]*[[:space:]]*[0-9]*$" $TEST_DIR/fsmap | head -n 1 | awk '{print $2}')
 test "${data_dev}" != "${rt_dev}" || echo "data ${data_dev} realtime ${rt_dev}?"
 
diff --git a/tests/xfs/277 b/tests/xfs/277
index 5cb44c33e81570..87423b96454fa4 100755
--- a/tests/xfs/277
+++ b/tests/xfs/277
@@ -36,7 +36,7 @@ $XFS_IO_PROG -c 'fsmap -v' $SCRATCH_MNT >> $seqres.full
 $XFS_IO_PROG -c 'fsmap -v' $SCRATCH_MNT | tr '[]()' '    ' > $TEST_DIR/fsmap
 
 echo "Check device field of FS metadata and journalling log"
-data_dev=$(grep 'static fs metadata' $TEST_DIR/fsmap | head -n 1 | awk '{print $2}')
+data_dev=$(grep 'inode btree' $TEST_DIR/fsmap | head -n 1 | awk '{print $2}')
 journal_dev=$(grep 'journalling log' $TEST_DIR/fsmap | head -n 1 | awk '{print $2}')
 test "${data_dev}" = "${journal_dev}" || echo "data ${data_dev} journal ${journal_dev}?"
 

