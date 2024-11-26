Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A56E7462;
	Tue, 26 Nov 2024 01:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732584142; cv=none; b=j+uCrcAlOntO1JmtkB3TAaJBMjjEpOYnxLOvt2gtehAwu2Q+9H3L6PsWnS+U2ngzOuTH7cYozHLO+EVDTWbQ4+mN7MC4gnwpboj+QM0ZCAGIXlKhGChUnNxoRMmGGxcct2rwGDO553He2P9Y+n3FkGOGIbo8jIDg3NXQNs3zXuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732584142; c=relaxed/simple;
	bh=gExprrLIh6QkDIw05PgeX5U6Q/m9Rxofjk2IItTszR8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mQeUkNsTuRWYxWNuDs2GIcJ77HBCMDis/OFJ70OzG3zMkbDoVC5hUgTYheey4ScT1cs9a7EeWAhriaP4Pas3482eixBWwPn10K+sDjAjULZU0l4bPOLr+3ObJ3TC17pJ7vPldpvoQfEgAcrnQOBBy+XoJSj7sOEJxHoWvZrUccs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R/A9EZEo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R/A9EZEo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEE39C4CECE;
	Tue, 26 Nov 2024 01:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732584142;
	bh=gExprrLIh6QkDIw05PgeX5U6Q/m9Rxofjk2IItTszR8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=R/A9EZEoy2nDxYfOg3r8jc2dM24OWEQ/s2YbU3R5B7LFNNKoqxjBqlogvDzM4CJlS
	 Qq31HKr8SPuagDqm1TUrBe+lvzyEBAmTY6qZq+6EsNibUPk6d5iaueklULp7o+2qpN
	 i3T0PDz0MJJzFgCcImZ+Ib/irfB/Xdf/EaKFLjYD29lJrU6Pa+PWSsWCKVvdoQelUc
	 uWy22Yf/SInQiA5ybNAt6ni9QRKZQmWGCJ0CNN8Pdd6+/MeEfB6KJQRyJGRgpFLQC4
	 N6azger0akoh9OCGzDVy0/sJvJl8eXbN2fPsC1yZvD4MA2uqIUYU3BIoYwcKvHpiiw
	 L76chCsXtONOw==
Date: Mon, 25 Nov 2024 17:22:21 -0800
Subject: [PATCH 07/16] xfs/163: skip test if we can't shrink due to enospc
 issues
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173258395178.4031902.13169152131264583585.stgit@frogsfrogsfrogs>
In-Reply-To: <173258395050.4031902.8257740212723106524.stgit@frogsfrogsfrogs>
References: <173258395050.4031902.8257740212723106524.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

If this test fails due to insufficient space, skip this test.  This can
happen if a realtime volume is enabled on the filesystem and we cannot
shrink due to the rtbitmap.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/163 |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/163 b/tests/xfs/163
index 2bd94060222f96..75c3113dc2fd03 100755
--- a/tests/xfs/163
+++ b/tests/xfs/163
@@ -17,13 +17,20 @@ _begin_fstest auto quick growfs shrinkfs
 
 test_shrink()
 {
-	$XFS_GROWFS_PROG -D"$1" $SCRATCH_MNT >> $seqres.full 2>&1
+	$XFS_GROWFS_PROG -D"$1" $SCRATCH_MNT &> $tmp.growfs
 	ret=$?
 
 	_scratch_unmount
 	_check_scratch_fs
 	_scratch_mount
 
+	# If we couldn't shrink the filesystem due to lack of space, we're
+	# done with this test.
+	[ $1 -ne $dblocks ] && \
+		grep -q 'No space left on device' $tmp.growfs && \
+		_notrun "Could not shrink due to lack of space"
+	cat $tmp.growfs >> $seqres.full
+
 	$XFS_INFO_PROG $SCRATCH_MNT 2>&1 | _filter_mkfs 2>$tmp.growfs >/dev/null
 	. $tmp.growfs
 	[ $ret -eq 0 -a $1 -eq $dblocks ]

