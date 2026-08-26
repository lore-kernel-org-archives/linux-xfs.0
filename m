Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6609395D86;
	Wed, 26 Aug 2026 18:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787769017; cv=none; b=N869ZjipEaox/tWxhqGuKFJ8RbGNoQuGLEf4jvGf+ZHmqTxgl3Mk/2mb5Aej0KgoijnJnd/p8opsffgAAFAEoQovXYW9hKousnhnt5NfCM5750Si3lY5m31rYIbvHZ4VbV6pbRh5zupQHk45VYhNsAgzYmWFztXEukOU6FLzBTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787769017; c=relaxed/simple;
	bh=9kYHmzW24r6VQfLz2yMF11ZnyjdXETJ7JWMXfZTBWqw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=l4r5luHs5WOB8np5YkCSxa4+QYQHaHwOW5ibVKnvz4svQccbfaAFnKq72wwAtqBRU8a+ObhLbPMIFbkGvisYZ0Z0A5xbAKwwvUzMgTOEeqOimt2vRptDxaiTjXJfPHAZjopshNuhU72ybU1qTlYfWbMkBfhQ5tx0V/FCebX2hCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pgi8GGUR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pgi8GGUR"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 979D51F000E9;
	Wed, 26 Aug 2026 18:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787769002;
	bh=J6OwREE5OAmeCyl19TMcZnxwNxzy/gvfrj4EDSv50Ko=;
	h=Date:From:To:Cc:Subject;
	b=Pgi8GGURT5gNpFwV7bY+y57oPdNCqIZu1Eu3iBLo3bTOwoyYTZ2o5okralf6b6bmi
	 89oM69h/lqZYWbnxfQtMnBtXkArZmwkWalh85UDjHQAG9O8mpzufasctjniVWRwhic
	 fXY+CN5PypqfAdMu8tDwQjBA6M3jqW9sW4dfoSPxiYyuovfzsYe+V/TrveRBEcDQGH
	 ONx5l247HJn6xwGwZ5LcX6q+g50q+EY8/mkTU6GO5eCiCTJz/YHj1usqCG8/UWHc94
	 dpQ9WtGRNoK18Be4AU516kXkCjqocHThj7dBc3awIMUqqWVte2DBPKCFjFRWcpB/N2
	 b3LL7OZ4kE6qA==
Date: Wed, 26 Aug 2026 11:30:01 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@kernel.org>
Cc: fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>,
	Hans.Holmberg@wdc.com
Subject: [PATCH] xfs/837: set rtinherit on the root directory programmatically
Message-ID: <20260826183001.GV839663@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

I patched mkfs to enable metadir by default, but then this test
regressed on the "-m metadir=0 -d rtinherit=1..." configuration.  Upon
digging into the test results, I observed that the scratch filesystem
actually had metadir enabled despite the intended configuration.  That
in turn revealed that _scratch_mkfs was failing because -d rtinherit was
being respecified, so it did that obnoxious thing it does and reformats
with only the caller's mkfs options.

As a result, the scratch filesystem is configured incorrectly -- metadir
is enabled when we don't want it to be, so we pick the wrong output file
and fail.

Instead of passing -drtinherit and potentially conflicting with the test
configuration options, let's use _xfs_force_bdev to set rtinherit
programmatically.

Cc: <Hans.Holmberg@wdc.com>
Cc: <fstests@vger.kernel.org> # v2025.06.22
Fixes: e225772353e212 ("xfs: add mount test for read only rt devices")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/837 |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tests/xfs/837 b/tests/xfs/837
index 2fe195a009f10f..33ec37ae3dbde3 100755
--- a/tests/xfs/837
+++ b/tests/xfs/837
@@ -35,7 +35,11 @@ fi
 
 _register_cleanup "_cleanup_setrw"
 
-_scratch_mkfs "-d rtinherit" > /dev/null 2>&1
+_scratch_mkfs > /dev/null 2>&1
+
+_scratch_mount
+_xfs_force_bdev realtime $SCRATCH_MNT
+_scratch_unmount
 
 # Select appropriate output file
 features=""
