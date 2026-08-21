Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27843F4854;
	Fri, 21 Aug 2026 05:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787289302; cv=none; b=heRehyWHCXgoEG1NN/r2OK6H7fqmBhlF/C481QS9mJ0/3tG2cy4Y0qdZItpI2+zGhWIb0ws35fO/ixih0HLceIvoxort6rgIeXTMRaII77QncEiEHyZGPyiN+dehqWz5TMp7olUJwyN4mG9ixCiSpOxjA6wlU73y95sobQE8les=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787289302; c=relaxed/simple;
	bh=u6qrcaA72qSGreRa1IzUyiVTjwTYIF5AuQ6//KDbTNk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=C3ibTov9JgdzvF1ehmxFep2SY3MqmrhDCCfUN5ibs2Q60rRuXLLNShpkCBjGHk8n19VZlmu3B8J3ai1JqIyHRbEbOwnzf0tvQAwuBH8x0OyyYXw2L6XiN43EnoL98X3jIHOXYjSpsSZjEmgfo3AUkrOUvDRkEbzp1VdlrIoLXdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=klBHuz/1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="klBHuz/1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=gRnyYFxGdzqMb3cozECaMT+YP08g/lEae9979B8JUSA=; b=klBHuz/1+uMERbj49nmRTJpGUl
	2eFtL7KORUYRxSfNVlxSxLl1fRVDX4um8K8CxxI6baZfsfKZ8ideFo2noiTnhOw+Uwypocu8lLRYC
	SiXy66KG1jnW8TcjVsLO9reZa/fLHqh0I2a8ui0fFDyebxSbZKyw1cTHHYjE5nL7MmrnaOcy2YbNa
	lihGr75skPRiZJXblYgj581V6INY8SRusoR8ZwRAxRb+z0lBgwlNajdLeI3lrGmIXp+E42krcYPY/
	DnjBRsI3xm0RtLjgfbkitzOwt0K9LDAaMJGUaDHbpQv5EwrEe4z4NlLxPVp6jye6vjWz0gPa0ZZgK
	Km8gAvcQ==;
Received: from [46.255.74.83] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wxHai-0000000CYPN-1ena;
	Fri, 21 Aug 2026 05:14:59 +0000
From: Christoph Hellwig <hch@lst.de>
To: zlang@kernel.org,
	djwong@kernel.org
Cc: linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH] xfs/649: don't override $SCRATCH_DEV
Date: Fri, 21 Aug 2026 07:14:52 +0200
Message-ID: <20260821051452.1818412-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs/649 operates on a scsi_debug device.  Don't try to shoe-horn it
into $SCRATCH_DEV a that causes problems for setups that don't test
a SCRATCH_DEV at all, or which use options for the scratch device that
don't apply to the scsi debug device.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/649 | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/tests/xfs/649 b/tests/xfs/649
index 56277c62932e..c2b4b637187f 100755
--- a/tests/xfs/649
+++ b/tests/xfs/649
@@ -41,7 +41,6 @@ _cleanup()
 . ./common/attr
 . ./common/scsi_debug
 
-_require_scratch_nocheck
 _require_scsi_debug "medium_error_start"
 _require_attrs user
 
@@ -55,9 +54,8 @@ scsi_debug_opt_error=${scsi_debug_opt_error:=2}
 test -b $scsi_debug_dev || _notrun "Failed to initialize scsi debug device"
 echo "SCSI debug device $scsi_debug_dev" >>$seqres.full
 
-SCRATCH_DEV=$scsi_debug_dev
-_scratch_mkfs >> $seqres.full || _notrun "could not format filesystem"
-_scratch_mount
+_mkfs_dev $scsi_debug_dev >> $seqres.full || _notrun "could not format filesystem"
+_mount -t xfs $scsi_debug_dev $SCRATCH_MNT
 
 block_size=$(_get_file_block_size $SCRATCH_MNT)
 inode_size=$(_xfs_get_inode_size $SCRATCH_MNT)
@@ -94,10 +92,12 @@ test_attr()
 	local start_blocks=($($XFS_IO_PROG -c "bmap -al" $testfile | awk 'match($3, /[0-9]+/, a) {print a[0]}'))
 	echo "Attribute fork extent(s) start at ${start_blocks[*]}" >> $seqres.full
 
-	_scratch_unmount
+	umount $scsi_debug_dev
 
 	echo "Dump inode $inode details with xfs_db" >> $seqres.full
-	_scratch_xfs_db -c "inode $inode" -c "print core.aformat core.naextents a" >> $seqres.full
+	$XFS_DB_PROG $scsi_debug_dev \
+		-c "inode $inode" -c "print core.aformat core.naextents a" \
+		>> $seqres.full
 
 	if [[ start_blocks[0] -ne 0 ]]; then
 		# Choose the block to error, currently only works with a single extent.
@@ -105,10 +105,11 @@ test_attr()
 	else
 		# Default to the inode daddr when no extents were found.
 		# Errors when getfattr(1) stats the inode and doesnt get to getfattr(2)
-		error_daddr=$(_scratch_xfs_db -c "inode $inode" -c "daddr" | awk '{print $4}')
+		error_daddr=$($XFS_DB_PROG $scsi_debug_dev \
+			-c "inode $inode" -c "daddr" | awk '{print $4}')
 	fi
 
-	_scratch_mount
+	_mount $scsi_debug_dev $SCRATCH_MNT
 
 	echo "Setup scsi_debug to error when reading attributes from block" \
 	     "$error_at_block at daddr $error_daddr" >> $seqres.full
-- 
2.53.0

