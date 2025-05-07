Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03CD11DF24F;
	Wed,  7 May 2025 05:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746594785; cv=none; b=fvm43FMGnLDlyQQEwO7jfOnifgL7c+S5uxgUWPhzl9sI3xzFl3f/wQymZ/X2A0hRD/HFtIjdh0qe/t4NyudRB7wgKUZzvDkYcre6Ffo1oPb07kW0S8h8T7TSjJY6xjx6MvG/NbgL0oxlEVuge6BuwccMMchDhokRr12YRPRndMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746594785; c=relaxed/simple;
	bh=AYwdFmVQEM/Ih/v1xSnlQOcdAuy2Pc0JeMDhnCi75YU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jl6GM6liZPXlSEBrpWLuH29bZisiOIOb9l4FCoJrFPRWD1NOKQDnOeNwmuSbF/zCLpvAcRzNhH0+zqqmZzn6BIyP2+Gmqbu/bFqf1bAbbEHFSbv1MAVunZu29kSnlQ28mCKWMUtF9imdtfaDpmpDF3BQKlfk4HQg0vNtHfwohdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=h8Q920Sx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="h8Q920Sx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Gn6HkrlZ3i/MckA4i+zuB+ti9z8F3eFQgKuNUz4KcH0=; b=h8Q920SxAXtBIjfrVyO9MM7awd
	KakcMjhMxlVynWiJDrHMD+Uu2roJdytrNu11PrlZrT4aNOB7uqh42BKF1YfcD5Kk/ykM60suuv2Ce
	wq2Ty/rG4/5EFBTWACurp0xPRHNCHpIqF6khoQK2UL+87SguJ3485z0pP7VoWX+DupdC40n0oY+hy
	AhSaGZBgFrXItIJShO95C6KdQq1O+/Sw4vN5BTWxFWd/+b29dsZxBVVWq5JpBV5MblOU4CSuxX+kX
	OekvTGMMBKMEAnW2scHBijaYSA7JsW/+muyJfMJgPVuNQnPl/EoMG3x8XoCAmnedsOr+zAXlVErmt
	nADXKzDg==;
Received: from 2a02-8389-2341-5b80-3ba7-83fe-7065-4f0b.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:3ba7:83fe:7065:4f0b] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uCX5a-0000000EEr4-49Bu;
	Wed, 07 May 2025 05:13:03 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 04/15] xfs: add a zoned growfs test
Date: Wed,  7 May 2025 07:12:24 +0200
Message-ID: <20250507051249.3898395-5-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250507051249.3898395-1-hch@lst.de>
References: <20250507051249.3898395-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Zoned file systems require zone aligned RT volume sizes.  Because of
that xfs/596 won't work as-is.  Copy it and test two zone capacity
aligned values.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/4202     | 78 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/4202.out | 11 +++++++
 2 files changed, 89 insertions(+)
 create mode 100755 tests/xfs/4202
 create mode 100644 tests/xfs/4202.out

diff --git a/tests/xfs/4202 b/tests/xfs/4202
new file mode 100755
index 000000000000..461827a14522
--- /dev/null
+++ b/tests/xfs/4202
@@ -0,0 +1,78 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2000-2002 Silicon Graphics, Inc.  All Rights Reserved.
+# Copyright (c) 2024 Christoph Hellwig
+#
+# FS QA Test No. 4202
+#
+# growfs QA tests - repeatedly fill/grow the rt volume of the filesystem check
+# the filesystem contents after each operation.  This is the zoned equivalent of
+# xfs/596
+#
+. ./common/preamble
+_begin_fstest growfs ioctl auto zone
+
+_cleanup()
+{
+	rm -f $tmp.*
+}
+
+. ./common/filter
+. ./common/zoned
+
+_require_scratch
+_require_realtime
+_require_no_large_scratch_dev
+
+zone_capacity=$(_zone_capacity 0 $SCRATCH_RTDEV)
+
+fill_fs()
+{
+    if [ $# -ne 1 ]; then echo "Usage: fill_fs \"path\"" 1>&2 ; exit 1; fi
+    _do "Fill filesystem" \
+	"$here/src/fill2fs --verbose --dir=$1 --seed=0 --filesize=65536 --stddev=32768 --list=- >>$tmp.manifest"
+}
+
+_do_die_on_error=message_only
+rtsize=$zone_capacity
+echo -n "Make rt filesystem on SCRATCH_DEV and mount... "
+_scratch_mkfs_xfs -r size=${rtsize} | \
+	_filter_mkfs 2> "$tmp.mkfs" >> $seqres.full
+
+# for $dbsize
+. $tmp.mkfs
+
+_scratch_mount
+_require_xfs_scratch_zoned
+
+# We're growing the realtime device, so force new file creation there
+_xfs_force_bdev realtime $SCRATCH_MNT
+
+echo "done"
+
+#
+# Zone RT devices can only grow by entire zones.
+# Do that twice.  The high starting code looks weird, but is neededed
+# due to the automatically added OP
+#
+for size in $(( 6 * $zone_capacity )) $(( 7 * $zone_capacity )); do
+    grow_size=$(( $size / $dbsize ))
+    fill_fs $SCRATCH_MNT/fill_$size
+    _do "Grow filesystem" "xfs_growfs -R $grow_size $SCRATCH_MNT"
+    echo -n "Flush filesystem... "
+    _do "_scratch_unmount"
+    _do "_try_scratch_mount"
+    echo "done"
+    echo -n "Check files... "
+    if ! _do "$here/src/fill2fs_check $tmp.manifest"; then
+      echo "fail (see $seqres.full)"
+      _do "cat $tmp.manifest"
+      _do "ls -altrR $SCRATCH_MNT"
+      status=1 ; exit
+    fi
+    echo "done"
+done
+
+# success, all done
+echo "Growfs tests passed."
+status=0 ; exit
diff --git a/tests/xfs/4202.out b/tests/xfs/4202.out
new file mode 100644
index 000000000000..66cab6aba8e2
--- /dev/null
+++ b/tests/xfs/4202.out
@@ -0,0 +1,11 @@
+QA output created by 4202
+Make rt filesystem on SCRATCH_DEV and mount... done
+Fill filesystem... done
+Grow filesystem... done
+Flush filesystem... done
+Check files... done
+Fill filesystem... done
+Grow filesystem... done
+Flush filesystem... done
+Check files... done
+Growfs tests passed.
-- 
2.47.2

