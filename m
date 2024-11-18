Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E285E1E7643;
	Mon, 18 Nov 2024 23:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731970978; cv=none; b=qd1aDD0EpTe7CPi8VVOtiVFZ/m5/E+vxzYg2H50HO+7cHbobt/OI8R2ZGEbgP4Y9PU7FYOnK4Bwd31FULRKRshP2zqZka+sdA/2BVm4oiB6hZv4PBf7sYIE/kJgP4IyvXwqdHj6emboUOwPt9LLv2b5p2aNGZHgjm27MyL5ujs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731970978; c=relaxed/simple;
	bh=G+fQ8zAEbRNmHhLF948ul0JBfTLHgc9HOvlgGXrhgrk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HESxa8x8rwT0cRefV0lMrUoTtWzTgQ8EmmhgpZYcF5RzuzAE7nFJv6HwRcTr8UdE/2c0ERXT99C1p4bCP3wOkHP/cT3KcLwivt54FnXuK/9YpVfBTfzQ+qQb8Twcg0xfPgHWFGTZXzB7A+uKXcmStO7UrLtv0jdcV1Wb1nKqjz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cx/hNUSY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cx/hNUSY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79F11C4CECC;
	Mon, 18 Nov 2024 23:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731970977;
	bh=G+fQ8zAEbRNmHhLF948ul0JBfTLHgc9HOvlgGXrhgrk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Cx/hNUSYz9XGrTgG2VuBIgyNihvBCXJjDLWrGfIdylHd4VbgH7yoMVuOt3z4XDNAb
	 foR+TtJBAgFmUXxEUgZUCsOQRqQBdD/LCB+mFwsNMzFBsSXUcZMF3FtbfQtOilR1Nd
	 6vqjjCBaAhPGlwICUYmd622LW/oBMiXeBU6CD3tRjKTPXAX5XlaJJ8j/OlK8UTG2LH
	 X0JBRhR90BzmwZOx3LR1zzJCeisbeYDFYFuS/MqRUtYK0AOj6rRBj/CDBazHMddiZi
	 p3Lfeme/98K2GhWscJIcRRgn/cZypITuXRQ588E16dBmrQjjP7E0i4lcGpMddKpUV6
	 gsOy4odmSW3sw==
Date: Mon, 18 Nov 2024 15:02:57 -0800
Subject: [PATCH 06/12] xfs/163: skip test if we can't shrink due to enospc
 issues
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173197064517.904310.3981739368234759783.stgit@frogsfrogsfrogs>
In-Reply-To: <173197064408.904310.6784273927814845381.stgit@frogsfrogsfrogs>
References: <173197064408.904310.6784273927814845381.stgit@frogsfrogsfrogs>
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
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

