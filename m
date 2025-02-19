Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B90446B8;
	Wed, 19 Feb 2025 00:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926611; cv=none; b=CuJsFEBiOAo85OeQhuKBXagD9R0CQBrEyVoWQ13+6BB4D4SQyjyyBTgaIEqRQ/Z3KGSrYLnTrt3A7atPlnBTgV9BaikQiqiKsiDo6zkI7/qJK4+jHAe/91SdrC6hUF9eTEZ+QujjLdyv+iCnD0HCuntynUlfbKyK5pkplf1rxPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926611; c=relaxed/simple;
	bh=Fn6m47+4MBP2UqZ0b3J7lvUdMU3TbV3RFpkStVslaMo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hMkOvDUPvhpbBlkKyIEdt1RxKzz/btofysaIik/P3+rGS3EcMXJtOoemUjWlWnL9QOaXKMxDqO3brP4eksAOAP58KpVgiEA15DzyP74QdmEeDWdI7WvMixZuKDsvIgRxkhv1hwIM+PC8o4KVok/MwlthRWtYhpfVjrUDDeblVOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=agUNJ/6/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="agUNJ/6/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A4DC4CEE2;
	Wed, 19 Feb 2025 00:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926611;
	bh=Fn6m47+4MBP2UqZ0b3J7lvUdMU3TbV3RFpkStVslaMo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=agUNJ/6/JzDIlUQPyCRj10vKuPp1qrNwmDqq7WbSKha7Ryl5oP8qCO9YhyQvZYDuE
	 6PIOViBe1q5AHhHuS4gO6qX9OWGbgzOreGYGQ+nKUbmTMH4lWe08+UR5XzFkibJ3HV
	 pxrhe36EThqZ+mFsEuOT+Bxk3/CJCFGZg8me0foIohAzFBR5Dfo0gu2I2sz2/J078w
	 tHYear41Hp2bDmWEmn4eJ5aSxwNFm7SmR2UqtCTZRXfbUILviVwBXvKm78eq9D/Y8y
	 HusFTms/cecuqViwin/+qxbYEAAVTft7Mpv60Zmcy6fe4mP+IRm7WXbvBc/zJsdBiI
	 yPUPzmVrlSMfQ==
Date: Tue, 18 Feb 2025 16:56:50 -0800
Subject: [PATCH 1/4] xfs/019: reduce _fail calls in test
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992588668.4079248.2147316255223418497.stgit@frogsfrogsfrogs>
In-Reply-To: <173992588634.4079248.2264341183528984054.stgit@frogsfrogsfrogs>
References: <173992588634.4079248.2264341183528984054.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Replace some _fail calls in this test with softer variants: First,
_scratch_mount does _try_scratch_mount || _fail so it can go away.

Replace the rest of them with echoes because that's sufficient to fail
the test without omitting further check.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/019 |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)


diff --git a/tests/xfs/019 b/tests/xfs/019
index fdd965aa908f2b..b30116560c7c40 100755
--- a/tests/xfs/019
+++ b/tests/xfs/019
@@ -106,22 +106,21 @@ _verify_fs()
 
 	echo "*** mount FS"
 	_full " mount"
-	_try_scratch_mount >>$seqfull 2>&1 \
-		|| _fail "mount failed"
+	_scratch_mount >>$seqfull 2>&1
 
 	echo "*** verify FS"
 	(cd $SCRATCH_MNT ; find . | LC_COLLATE=POSIX sort \
 		| grep -v ".use_space" \
 		| xargs $here/src/lstat64 | _filter_stat)
 	diff -q $SCRATCH_MNT/bigfile $tempfile.2 \
-		|| _fail "bigfile corrupted"
+		|| echo "bigfile corrupted"
 	diff -q $SCRATCH_MNT/symlink $tempfile.2 \
-		|| _fail "symlink broken"
+		|| echo "symlink broken"
 
 	echo "*** unmount FS"
 	_full "umount"
 	_scratch_unmount >>$seqfull 2>&1 \
-		|| _fail "umount failed"
+		|| echo "umount failed"
 }
 
 #_verify_fs 1

