Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA30734D90E;
	Tue, 21 Oct 2025 18:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761071968; cv=none; b=o6mUspZQV9lRvTQWIg4rCnBA/wmLSfaMRcXx4DCkjVgRQ/YWV0WvIUzP145p0OCqVc/i9pyQzCset/oKiHgbgtQBUz3QSwuTd+q+kVuw66nBb11xBto/SnhxUjtoVcraNPVR83so+dxmNBLWoF0R7yo7NBBqD1yWuVgpwiNw1qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761071968; c=relaxed/simple;
	bh=gLsEmgz5dYNM/B/nKRtOMrLDJbNSibbWVz0H68qF31E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H6HFQ2N5UmSN+C1D/3frtFfOufB4TVfLwxw1xstA5bdrf8LG1FZ3IndlA8ZBG2pLA/aLpn/u03PRreTt0sCkekp+KCMUsk9JV0ceSDAqMsSLu2E6nXRK4PYbsHSUzE3SI5MhtrfgQBky3zJgi24KSkH1ubQQwBsifZZBPuO1RmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t83CTRFN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t83CTRFN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28280C4CEF1;
	Tue, 21 Oct 2025 18:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761071968;
	bh=gLsEmgz5dYNM/B/nKRtOMrLDJbNSibbWVz0H68qF31E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=t83CTRFNVinGS0UTfhv1fxm0SmOSvpu3WwQleHpDJFbqo4kGgEaiSnVK94WkKLf4B
	 1M+lzppSyOhd8a6sA3UqQrnRfhRz0mxGx8qBq89UBWKrinL3H8InLb6FNtDGWbl9Zu
	 XX3GDHQjQzLQwK50vGCdgvfwqwN1+oPW+vojLyc7Z3Ta2YcZkfEpH8De1lVjsmGT+d
	 u0USMY4E0HpPTxdSHFS5gF1h1riIb3I6wyu4DwCjYfCXQeyKJdzpNyACaBUfInF5CL
	 s84XWCtnycizB0OzphPflrMH7monFdKlY5sI9L5wPlBBLAqRhMvULNBaFWE1t9RShq
	 lGNuD5ah+cOCg==
Date: Tue, 21 Oct 2025 11:39:27 -0700
Subject: [PATCH 01/11] generic/427: try to ensure there's some free space
 before we do the aio test
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <176107188687.4163693.18089846524870076598.stgit@frogsfrogsfrogs>
In-Reply-To: <176107188615.4163693.708102333699699249.stgit@frogsfrogsfrogs>
References: <176107188615.4163693.708102333699699249.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

On a filesystem configured like this:
MKFS_OPTIONS="-m metadir=1,autofsck=1,uquota,gquota,pquota -d rtinherit=1 -r zoned=1"

This test fails like this:

 --- a/tests/generic/427.out      2025-04-30 16:20:44.584246582 -0700
 +++ b/tests/generic/427.out.bad        2025-07-14 10:47:07.605377287 -0700
 @@ -1,2 +1,2 @@
  QA output created by 427
 -Success, all done.
 +pwrite: No space left on device

The pwrite failure comes from the aio-dio-eof-race.c program because the
filesystem ran out of space.  There are no speculative posteof
preallocations on a zoned filesystem, so let's skip this test on those
setups.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 tests/generic/427 |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/tests/generic/427 b/tests/generic/427
index bddfdb8714e9a7..bb20d9f44a2b5a 100755
--- a/tests/generic/427
+++ b/tests/generic/427
@@ -28,6 +28,9 @@ _require_no_compress
 _scratch_mkfs_sized $((256 * 1024 * 1024)) >>$seqres.full 2>&1
 _scratch_mount
 
+# Zoned filesystems don't support speculative preallocations
+_require_inplace_writes $SCRATCH_MNT
+
 # try to write more bytes than filesystem size to fill the filesystem,
 # then remove all these data. If we still can find these stale data in
 # a file' eofblock, then it's a bug

