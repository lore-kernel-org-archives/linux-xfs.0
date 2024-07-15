Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A0D1E89C;
	Mon, 15 Jul 2024 06:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721024728; cv=none; b=OvJB+VabvEzfJfLOr5B2jm36m+yh6mvpa/dk31tY/BL57yBxQxP2Xhjjy4IuQ/AlatYWDJBG1v5+XOWnFxSiEMVs5KEI/Yz7VU7PxMdiClr8wKT4Rn6NWfEQ8gcf+m3vbSmattryT4VLtaDjVlBNs3G63nMnM5PYBdbkg4YTllc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721024728; c=relaxed/simple;
	bh=+pCwqgiNFuUnXehz3VilebT8WIrVelfpJ+Ig8jsTQME=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YL3pE6nzD/bowTVjRt5fxVcWBCrI83ae8+qi2S0DRDPuvvhCKPaf5Yfttvm+wP7EM9EPrf5t0Q5PqNFPme8dKNMWLhOKns6Bh5nTWdynV49oJZl07FeGrolETeyCv4kOfwOIo6Z5lr3ZE3X22D2uxjTM9vIdg1y61xqI2oJTAcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dQ/x7ozv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dQ/x7ozv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=OWMgVPPwrC8kIKown6+IJb8dnCXr8qe/RXfxfgalfiE=; b=dQ/x7ozv9Z9a1HKj9dPUhuR+W5
	Y461MfM2V3VczFqwL+sRcgLSOmgHl2TLXCtwUFHKObYQXclV4jksr52jRAty9CHO8RFCVwaCbiUys
	5GZY3pvsGgRv45Jt9aPTCUwqiDB7sxvwPp3FfEzf2HVeE8tfAm5qUBHRFdTq6X31UhTHntfQmUra4
	wdUww2RQp8q86LLvIvHA9Uo4vtBfBbGTLXzRHeg0fkb1WBkrQOq5oKq7SWoTxIc0O1xloU6bj9ZHo
	3Kmwo9CILx3jlkg1nEqlWC7nebVwZuAv8tNkneWe51JTC+RI5nvQhMaPs82HNWqkg9LbRaYNya6ZD
	D4p5aegg==;
Received: from 2a02-8389-2341-5b80-e5f3-ff26-c02d-471d.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:e5f3:ff26:c02d:471d] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sTF9I-000000061Ol-3bBt;
	Mon, 15 Jul 2024 06:25:25 +0000
From: Christoph Hellwig <hch@lst.de>
To: zlang@kernel.org
Cc: djwong@kernel.org,
	dchinner@redhat.com,
	linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH v2] xfs/011: support byte-based grant heads are stored in bytes now
Date: Mon, 15 Jul 2024 08:24:53 +0200
Message-ID: <20240715062522.593299-1-hch@lst.de>
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

Changes since v1:
 - rebased to latests xfstests for-next
 - improve a comment based on a mail from Dave Chinner

 tests/xfs/011 | 77 ++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 54 insertions(+), 23 deletions(-)

diff --git a/tests/xfs/011 b/tests/xfs/011
index f9303d594..df967f098 100755
--- a/tests/xfs/011
+++ b/tests/xfs/011
@@ -11,7 +11,15 @@
 . ./common/preamble
 _begin_fstest auto freeze log metadata quick
 
-# Import common functions.
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
@@ -24,27 +32,40 @@ _cleanup()
 	rm -f $tmp.*
 }
 
-# Use the information exported by XFS to sysfs to determine whether the log has
-# active reservations after a filesystem freeze.
-_check_scratch_log_state()
+#
+# The grant heads record reservations in bytes.
+#
+# The value is not exactly zero for complex reason.  In short: we must always
+# have space for at least one minimum sized log write between ailp->ail_head_lsn
+# and log->l_tail_lsn, and that is what is showing up in the grant head
+# reservation values.  We don't need to explicitly reserve it for the first
+# iclog write after mount, but we always end up with it being present after the
+# first checkpoint commits and the AIL returns the checkpoint's unused space
+# back to the grant head.
+#
+# Hence just check the value is between 0 and the maximum iclog size (256kB).
+#
+_check_scratch_log_state_new()
 {
-	devname=`_short_dev $SCRATCH_DEV`
-	attrpath="/sys/fs/xfs/$devname/log"
-
-	# freeze the fs to ensure data is synced and the log is flushed. this
-	# means no outstanding transactions, and thus no outstanding log
-	# reservations, should exist
-	xfs_freeze -f $SCRATCH_MNT
+	for attr in "reserve_grant_head_bytes" "write_grant_head_bytes"; do
+		space=`cat $attrprefix/$attr`
+		_within_tolerance $space 1024 0 $((256 * 1024))
+	done
+}
 
-	# the log head is exported in basic blocks and the log grant heads in
-	# bytes. convert the log head to bytes for precise comparison
-	log_head_cycle=`awk -F : '{ print $1 }' $attrpath/log_head_lsn`
-	log_head_bytes=`awk -F : '{ print $2 }' $attrpath/log_head_lsn`
+#
+# The log head is exported in basic blocks and the log grant heads in bytes.
+# Convert the log head to bytes for precise comparison.
+#
+_check_scratch_log_state_old()
+{
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
@@ -54,15 +75,25 @@ _check_scratch_log_state()
 				"possible leak detected."
 		fi
 	done
-
-	xfs_freeze -u $SCRATCH_MNT
 }
 
+# Use the information exported by XFS to sysfs to determine whether the log has
+# active reservations after a filesystem freeze.
+_check_scratch_log_state()
+{
+	# freeze the fs to ensure data is synced and the log is flushed. this
+	# means no outstanding transactions, and thus no outstanding log
+	# reservations, should exist
+	xfs_freeze -f $SCRATCH_MNT
+
+	if [ -f "${attrprefix}/reserve_grant_head_bytes" ]; then
+	    _check_scratch_log_state_new
+	else
+	    _check_scratch_log_state_old
+	fi
 
-_require_scratch
-_require_freeze
-_require_xfs_sysfs $(_short_dev $TEST_DEV)/log
-_require_command "$KILLALL_PROG" killall
+	xfs_freeze -u $SCRATCH_MNT
+}
 
 echo "Silence is golden."
 
-- 
2.43.0

