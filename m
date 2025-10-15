Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1A2139579;
	Wed, 15 Oct 2025 16:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760546219; cv=none; b=llMliJqjctJy30QZaD7gWh7Wow7Mf7hFXO7YaD7ZGR5sG8HaLTlHWhp1fHoVPh4QGQQEvXFU45g+yprgjvtPbcUaUOQFwAs7PblKQCdEnw3Fe+8kOFqm2FnAo4fyQA4W/90u9VzEfCZZEnzKkrt6gqm7K1DDfREcCyToUxfoWHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760546219; c=relaxed/simple;
	bh=7VsSEK687cEvSUdYhYp9n1dbAvHsgy/mZT4BLxkM8FY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i/lboBuuxT6GGUDgGaJIvaf+vS7OerACfkTQXeJVt3wJPtPdQuiMAMaukc0NHzxbyp52kl4OKNPPy78bEdL70/WnD6oYJdjSN/jKFWqjGUejIZPw/AIwvJTzA0Vi6EgcUYzdyggFkXdTZCg9JfjiL/8FTnC64xGltRURb9zPY40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hd3pa3Tz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hd3pa3Tz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDE12C4CEF8;
	Wed, 15 Oct 2025 16:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760546218;
	bh=7VsSEK687cEvSUdYhYp9n1dbAvHsgy/mZT4BLxkM8FY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Hd3pa3TzeHA1tzEgYBZiVe9oRMquwW8eFTXL+ZuLeyUcmLdXnxpYXSqBwUHR0FQLZ
	 FXLoq9Ogp2YhfGFV/ohk/4Cr4QC4SSQJV6LZ9qrgQf5p1QT6QMzjjAHaPILZZsWnV2
	 UD8Y+u/2dd8XKW3O/AZDuP5haCBOc/c0xcmaAiKKG4rZ1eNsT1ayuW7/iIoQ95mLWO
	 1ZkTukEr7bwilepLKJOw7QKrfVPfuB22BngljjGq8GpS1YcDu9Vxg9ris0nANeYnod
	 wx6zhv+YQVyQYQZxTk4/LnJOB4imnnutNMh3Mt7XCisBrBbwSxizWWUTGE0xMBHsLk
	 iIh0523Uc5uEQ==
Date: Wed, 15 Oct 2025 09:36:58 -0700
Subject: [PATCH 1/8] generic/427: try to ensure there's some free space before
 we do the aio test
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <176054617913.2391029.5774423816009069866.stgit@frogsfrogsfrogs>
In-Reply-To: <176054617853.2391029.10911105763476647916.stgit@frogsfrogsfrogs>
References: <176054617853.2391029.10911105763476647916.stgit@frogsfrogsfrogs>
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

