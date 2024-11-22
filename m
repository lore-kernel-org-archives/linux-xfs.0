Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975D722339;
	Fri, 22 Nov 2024 16:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732294384; cv=none; b=Qbdo3cZmHyod2U4+Swglff5+FMRgIkj0Wx0SsGMcikTOaDdDKQW5CWRUCQy/Z2sSzQLt9eEIaiNQYZUFeyhVcphpJC0Jd1AVCl36tLMo139aVQcB8rRcLnYR8FB9ywbZASTzzec4L410VWB8WDFLY3OKfz+jn0Ix57bRKYgbGbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732294384; c=relaxed/simple;
	bh=gExprrLIh6QkDIw05PgeX5U6Q/m9Rxofjk2IItTszR8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nwjJ6wi17yV9UqtiP4yo9ALrMCaUOLeFO5NuPMjZ0xmMHFLX3GCg+tXYqRo9M1E1m6m0KxUmdrLSj+GMJuOmW/psqGYczC/FfHHHiT6PH0+r7q8z8HzsXoW+DUCjpeJ4jsEfz0IzFVDb3oamfUDGzBNIoByi7chnlYcw+2Wuibo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DSm87hm9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DSm87hm9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 230B4C4CECE;
	Fri, 22 Nov 2024 16:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732294384;
	bh=gExprrLIh6QkDIw05PgeX5U6Q/m9Rxofjk2IItTszR8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DSm87hm9vvEJHLFbaHSVJu7dgVbNdxGdl4zudq4cZtOjzrWg35ZaOEI88/99+MZHA
	 JRNWj/7xbxgkIEANtVI0GSON6LtSyTEIksGs2dUMElQqCt1ewDWORPRGLg4iZtNm4z
	 SKp7a2r2/d/jdR+QDYzUqKglgZVO0yBIliJGq+KeOUUK4vHJwUWRwabae7ukuy7Mft
	 uvfIfUGSrL2jhlj4lsuzvg2B4EvZc1B1VR3tH78EcHUHxXIdsOZDyebFaL4vdw9r3V
	 jsBET+ECLpn3w/U8XJx18d3OcgMIUl7HK7kaizmaWL5QDsOMALXrF28g0dtqjdJBp8
	 rGL2f8f00OdCw==
Date: Fri, 22 Nov 2024 08:53:03 -0800
Subject: [PATCH 10/17] xfs/163: skip test if we can't shrink due to enospc
 issues
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173229420163.358248.12881809744914882048.stgit@frogsfrogsfrogs>
In-Reply-To: <173229419991.358248.8516467437316874374.stgit@frogsfrogsfrogs>
References: <173229419991.358248.8516467437316874374.stgit@frogsfrogsfrogs>
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

