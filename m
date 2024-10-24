Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40AD41CDA36;
	Thu, 24 Oct 2024 11:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729769009; cv=none; b=WBBTvjhm4ok/7UP5jzJdV+bz2YDCeVkWUcP3ttvsUvd1dhfqBfPS++4Sf5G7HkbrkvtEXAe/FH/DJANnYMIKcyhS4MsPvwxXtLMRNGrPZHq4/6HvhBGzskvarDBsyGu+65WiEkZU+jKarNF5RnIMBYgABOwq58TD5o7SxAh/xi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729769009; c=relaxed/simple;
	bh=K8ZPDUBljMXSzirkFRhVR6nXpRAqCEN01KtJeoQX3PE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IlZEOlu38jRNJqJ3/r4gBZfXWIAW8tYhTfjzlgWLzFz1DhWDGY+W7JS0/hX2wxzTsxDLL4mHF9XsvWnI+kdana7R9wr7N6vAbZCVsOYLi21vgrdkUQvrLDS0bclvkBrjCUAxZ3ESPmE7O2exApNU2DoyMUNSrFYbOmZR6UMM5mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=pankajraghav.com; arc=none smtp.client-ip=80.241.56.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Received: from smtp102.mailbox.org (smtp102.mailbox.org [10.196.197.102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4XZ3SW3QFJz9t1s;
	Thu, 24 Oct 2024 13:23:23 +0200 (CEST)
From: Pankaj Raghav <p.raghav@samsung.com>
To: fstests@vger.kernel.org,
	zlang@redhat.com
Cc: linux-xfs@vger.kernel.org,
	gost.dev@samsung.com,
	mcgrof@kernel.org,
	p.raghav@samsung.com,
	kernel@pankajraghav.com,
	david@fromorbit.com,
	djwong@kernel.org
Subject: [PATCH 1/2] generic/219: use filesystem blocksize while calculating the file size
Date: Thu, 24 Oct 2024 13:23:10 +0200
Message-ID: <20241024112311.615360-2-p.raghav@samsung.com>
In-Reply-To: <20241024112311.615360-1-p.raghav@samsung.com>
References: <20241024112311.615360-1-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

generic/219 was failing for XFS with 32k and 64k blocksize. Even though
we do only 48k IO, XFS will allocate blocks rounded to the nearest
blocksize.

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 tests/generic/219 | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/tests/generic/219 b/tests/generic/219
index 940b902e..d72aa745 100755
--- a/tests/generic/219
+++ b/tests/generic/219
@@ -49,12 +49,24 @@ check_usage()
 	fi
 }
 
+_round_up_to_fs_blksz()
+{
+	local n=$1
+	local bs=$(_get_file_block_size "$SCRATCH_MNT")
+	local bs_kb=$(( bs >> 10 ))
+
+	echo $(( (n + bs_kb - 1) & ~(bs_kb - 1) ))
+}
+
 test_accounting()
 {
-	echo "### some controlled buffered, direct and mmapd IO (type=$type)"
-	echo "--- initiating parallel IO..." >>$seqres.full
 	# Small ios here because ext3 will account for indirect blocks too ...
 	# 48k will fit w/o indirect for 4k blocks (default blocksize)
+	io_sz=$(_round_up_to_fs_blksz 48)
+	sz=$(( io_sz * 3 ))
+
+	echo "### some controlled buffered, direct and mmapd IO (type=$type)"
+	echo "--- initiating parallel IO..." >>$seqres.full
 	$XFS_IO_PROG -c 'pwrite 0 48k' -c 'fsync' \
 					$SCRATCH_MNT/buffer >>$seqres.full 2>&1 &
 	$XFS_IO_PROG -c 'pwrite 0 48k' -d \
@@ -73,7 +85,7 @@ test_accounting()
 	else
 		id=$qa_group
 	fi
-	repquota -$type $SCRATCH_MNT | grep "^$id" | check_usage 144 3
+	repquota -$type $SCRATCH_MNT | grep "^$id" | check_usage $sz 3
 }
 
 
-- 
2.44.1

