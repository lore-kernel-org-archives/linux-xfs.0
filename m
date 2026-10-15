Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1384928FFF6;
	Thu, 15 Oct 2026 03:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792035159; cv=none; b=IBltahzdLG/T5oZczciV7+rw1GePQkrE1ERJQoUzEDbF1bPANMHRHr8GsXrZLL5EajgKHOXDz7tbs90XnJVZnbcAhNQ20pQgcQSNHmZ/4MtcV2MjmlZ8ICtJrd1wjQXnmuqmXI8eH8+6WGpw7ueKfhGGATFJ1KyDAN307Qy0Bmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792035159; c=relaxed/simple;
	bh=nRJZ3dkyKBEpBUHJJL1j7Z7erRGfgPhPE9ACnYCVDJM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=r1CjnX4myK6h/lA2/Z29CxFmfYYXOogQDWI1EDJBuCAxPfqqYJ62Z+qMEytXzrgTemaqodUBSmW+lKNUU7mlf2n5jIe5VyNiHMrwPcNXur0h/hPGp7e3aA0nlRFKXNyAuRXyCpR5gEG1Oao6yn9mQpAo9CGr9TN493mb38Lr590=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mcp896Yd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mcp896Yd"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 900F01F000C4;
	Thu, 15 Oct 2026 03:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792035157;
	bh=6vWO7zX9/PIs5rECsXCsy/M6g/YuYjUx4r9ne1NEc0o=;
	h=Date:From:To:Cc:Subject;
	b=Mcp896YdWy/x5nPQcsRYM2E7DTXZIBAXZAMzH2FNCe06Lm5C1KkFv8HoAgTAvY5ig
	 aBqmTvTPgTnSpb/IzAE1lfP17k8zQmIHMjIAWZqZ2bugAm+KCWNEUncmjcw3Mowx5a
	 jdfSpFHFVJYVTjtSOFWTmSbTk1wLQK7M7SY/i1A50XRQuUQqU+qPg7H8xSX+M+eMKr
	 cOh1/0v3hcsK+iqApza5ohu1CbB9GC/8w7+FhbXN5e6dVGXYXtj3W9EAc1dpyxQKmt
	 kOT/09/wlSjNTW2iQI/HWM1WI4kirVtF+6XvjeY4NGnhGmfS+1NEyoPoxHfj7E8yPA
	 LB4Haxp4sgJdw==
Date: Wed, 14 Oct 2026 20:32:36 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@kernel.org>
Cc: fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>,
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH] generic/805: mask unmount failures on cleanup
Message-ID: <20261015033236.GV6253@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

On (what's left of) my NFS-booted QA fleet I get test "failures" like
this:

 --- a/generic/805.out	2026-09-22 13:33:18.326820071 -0700
 +++ b/generic/805.out.bad	2026-10-14 18:58:34.438866321 -0700
 @@ -1,2 +1,4 @@
  QA output created by 805
  Silence is golden
 +umount.nfs: remote share not in 'host:dir' format
 +umount.nfs: /mnt/s: not mounted

This is caused by the _unmount call in _cleanup getting cranky about the
scratch mount not being mounted despite the -q flag.  I think this is
because umount(8) detects the underlying fs as NFS and delegates
entirely to umount.nfs, and that program whines.

So fix the test by redirecting the output.  We've already decided if the
test passes or not before we get to cleanup.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 tests/generic/805 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/generic/805 b/tests/generic/805
index 401829c4c6fcdf..fa454310137a29 100755
--- a/tests/generic/805
+++ b/tests/generic/805
@@ -25,7 +25,7 @@ _cleanup()
 {
 	xfs_freeze -u $SCRATCH_MNT 2>/dev/null
 	$DMSETUP_PROG resume $lvdev >> $seqres.full 2>&1
-	_unmount -q $SCRATCH_MNT
+	_unmount -q $SCRATCH_MNT &>> $seqres.full
 	_dmsetup_remove $node
 	cd /
 	rm -f $tmp.*
