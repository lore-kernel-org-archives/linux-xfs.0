Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C979639;
	Thu, 20 Jun 2024 07:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718868193; cv=none; b=mf7CuX8V8iIhBWy+c+/8/5ceONLNdDXvf4IEDAOPfKKpuj35y9g+vSmMC7slkgQ591updNGgJdcke5DFfkvDZ1A+ELXHHzIrUS1IQgFTHt8ypHZ1tKIp6Ju0h95X2BTKMANwmNdJbAbuIc9PB1rnJ52I7QnySc3yfGBkfLloyAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718868193; c=relaxed/simple;
	bh=0ma2oqX0NP9lXg9rHL8ugGabNvow2PzRtfuVCnZwZCE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZiDtTjNQ+Ky9caiRXGS0mGFqAlfazz6kDxO1p60eh3SXbQYzdaXMXhqfG+utOTBtKOSwYHUDxBuxwsvg2Hqbjg9Y0ZGhfsNFreZpsJSO35QxTrsiPvtegxR1vtMNv5x4JmjlXU6Icd6I9l5uZzyYHWItcJLw4cA+ypF0mNTK6rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lTGvIFkB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lTGvIFkB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=rQP9FwY6FBoTIpqoeCebDTNtznxZ7hIMGnT453fV2pU=; b=lTGvIFkBNgWtQEakfYu9q0i1J8
	PMsBJ4M/jcr3pidw/uhz8cPniqqZpjMAvZCjy6L88dFP4IuBiD9Ln5WDU/LDuewFnX1DWMzarEvzK
	U+li2fz1AxmY9ImA0K+NuLptT7v8tGjh3uA7Dhd3yOBhIvxNNs2K1nQ52hSY26/W/FMabgVkW19J1
	bQZsDliz52Q/Jl6f9bryl8DNKpXGSNLNHhcWF8FWeGo4pXDIamyCI1KYMVkV9nj+zsSMcMiCKCetx
	fnEV6LIB4oXGHI/0llRt6wyRBbXcWogGznPMUmFnL9fhQkw3iJWQPYMu0md9TC6Ms0yNFfp9uaNaU
	Pb/yNUgA==;
Received: from 2a02-8389-2341-5b80-3a9c-dc0d-9615-f1ed.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:3a9c:dc0d:9615:f1ed] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKC8V-00000003xj4-1u1g;
	Thu, 20 Jun 2024 07:23:11 +0000
From: Christoph Hellwig <hch@lst.de>
To: zlang@kernel.org
Cc: djwong@kernel.org,
	dchinner@redhat.com,
	linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH] xfs/011: support byte-based grant heads are stored in bytes now
Date: Thu, 20 Jun 2024 09:23:09 +0200
Message-ID: <20240620072309.533010-1-hch@lst.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

New kernels where reservation grant track the actual reservation space
consumed in bytes instead of LSNs in cycle/block tuples export different
sysfs files for this information.

Adapt the test to detect which version is exported, and simply check
for a near-zero reservation space consumption for the byte based version.

Based on work from Dave Chinner.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/011 | 67 +++++++++++++++++++++++++++++++++------------------
 1 file changed, 44 insertions(+), 23 deletions(-)

diff --git a/tests/xfs/011 b/tests/xfs/011
index ed44d074b..ef2366adf 100755
--- a/tests/xfs/011
+++ b/tests/xfs/011
@@ -11,7 +11,18 @@
 . ./common/preamble
 _begin_fstest auto freeze log metadata quick
 
-# Import common functions.
+# real QA test starts here
+_supported_fs xfs
+
+_require_scratch
+_require_freeze
+_require_xfs_sysfs $(_short_dev $TEST_DEV)/log
+_require_command "$KILLALL_PROG" killall
+
+. ./common/filter
+
+devname=`_short_dev $SCRATCH_DEV`
+attrprefix="/sys/fs/xfs/$devname/log"
 
 # Override the default cleanup function.
 _cleanup()
@@ -24,27 +35,29 @@ _cleanup()
 	rm -f $tmp.*
 }
 
-# Use the information exported by XFS to sysfs to determine whether the log has
-# active reservations after a filesystem freeze.
-_check_scratch_log_state()
+_check_scratch_log_state_new()
 {
-	devname=`_short_dev $SCRATCH_DEV`
-	attrpath="/sys/fs/xfs/$devname/log"
-
-	# freeze the fs to ensure data is synced and the log is flushed. this
-	# means no outstanding transactions, and thus no outstanding log
-	# reservations, should exist
-	xfs_freeze -f $SCRATCH_MNT
+	# The grant heads record reservations in bytes.  For complex reasons
+	# beyond the scope fo this test, these aren't going to be exactly zero
+	# for frozen filesystems. Hence just check the value is between 0 and
+	# the maximum iclog size (256kB).
+	for attr in "reserve_grant_head_bytes" "write_grant_head_bytes"; do
+		space=`cat $attrprefix/$attr`
+		_within_tolerance $space 1024 0 $((256 * 1024))
+	done
+}
 
+_check_scratch_log_state_old()
+{
 	# the log head is exported in basic blocks and the log grant heads in
 	# bytes. convert the log head to bytes for precise comparison
-	log_head_cycle=`awk -F : '{ print $1 }' $attrpath/log_head_lsn`
-	log_head_bytes=`awk -F : '{ print $2 }' $attrpath/log_head_lsn`
+	log_head_cycle=`awk -F : '{ print $1 }' $attrprefix/log_head_lsn`
+	log_head_bytes=`awk -F : '{ print $2 }' $attrprefix/log_head_lsn`
 	log_head_bytes=$((log_head_bytes * 512))
 
 	for attr in "reserve_grant_head" "write_grant_head"; do
-		cycle=`cat $attrpath/$attr | awk -F : '{ print $1 }'`
-		bytes=`cat $attrpath/$attr | awk -F : '{ print $2 }'`
+		cycle=`cat $attrprefix/$attr | awk -F : '{ print $1 }'`
+		bytes=`cat $attrprefix/$attr | awk -F : '{ print $2 }'`
 
 		if [ $cycle != $log_head_cycle ] ||
 		   [ $bytes != $log_head_bytes ]
@@ -54,17 +67,25 @@ _check_scratch_log_state()
 				"possible leak detected."
 		fi
 	done
-
-	xfs_freeze -u $SCRATCH_MNT
 }
 
-# real QA test starts here
-_supported_fs xfs
+# Use the information exported by XFS to sysfs to determine whether the log has
+# active reservations after a filesystem freeze.
+_check_scratch_log_state()
+{
+	# freeze the fs to ensure data is synced and the log is flushed. this
+	# means no outstanding transactions, and thus no outstanding log
+	# reservations, should exist
+	xfs_freeze -f $SCRATCH_MNT
 
-_require_scratch
-_require_freeze
-_require_xfs_sysfs $(_short_dev $TEST_DEV)/log
-_require_command "$KILLALL_PROG" killall
+	if [ -f "${attrprefix}/reserve_grant_head_bytes" ]; then
+	    _check_scratch_log_state_new
+	else
+	    _check_scratch_log_state_old
+	fi
+
+	xfs_freeze -u $SCRATCH_MNT
+}
 
 echo "Silence is golden."
 
-- 
2.43.0

