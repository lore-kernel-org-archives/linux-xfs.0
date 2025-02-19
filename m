Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CF51A314B;
	Wed, 19 Feb 2025 00:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926627; cv=none; b=P9xAhz6f8Ps3+fUBznpdpYhrwIEz3VUft5IMuv96iHuxYZVlXvW4jfzgecUt+9w6aeNz3wn7GbB1H2hpwps3tr26s0bs4zXrKvmI6Lb198F5/mXZhiPwEClF5rG+BVKFKuAS8G5CjGDSVCWiuZiY/DorxtY/Bk4eJJoyIU0S9QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926627; c=relaxed/simple;
	bh=LHquGFAFQUJ8oBvRHWUMN6CBdR16IwHK2ynGgKjOhHQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mB3JUmlpb6T/AFcGkfw6xbfVUKnDW100Y80gjx0pPkWue+J4DTiLs4xDdPhkGMEZfwrRD5403At0OGATIANr1RMtDMxXqzzijp2w5mzz3uPq8EFh0+Efk0xMlYLKViySVL+cKBY7iCrBtF7jXC+4us7f0u3M68z7Ys5lXSdxToA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gobAUoe1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gobAUoe1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C18EFC4CEE2;
	Wed, 19 Feb 2025 00:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926626;
	bh=LHquGFAFQUJ8oBvRHWUMN6CBdR16IwHK2ynGgKjOhHQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gobAUoe10TrphumdVjE6mZFl2tt75GCcFLx3JsD5lLCyBnSF0+QrMdRA7Cln44C+T
	 RSBN0neJ0Rkmi5cDffZbkqGodpNVys2nHvF4VQCVO53kIVaJteoTsZm2f3Uwzj+CIM
	 rVkqgU83u3ZbGJ3LxhU2ZI9C1UrIWacLCv8JnGjD1kUFp/Y/s1Kl0fdpHgCTqysmOh
	 yAg8Fnr0Jv5BNoDFXf0qQLYLpXxg+Qn2QxL0fnudvGggO7KfgKXEV/m1Kg3/writMA
	 hFmCtZZyN2BysjpL5rfI0pjIWzo6stmUOrlFkPobqHBoUqeRs80kjIDZJ0weoq9thM
	 ORbF70gO7jk7A==
Date: Tue, 18 Feb 2025 16:57:06 -0800
Subject: [PATCH 2/4] xfs/019: test reserved file support
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992588687.4079248.1375034459997008677.stgit@frogsfrogsfrogs>
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

Test creating files with preallocated blocks but a file size of zero,
since mkfs' protofile parser supports creating such things.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/019     |    5 +++++
 tests/xfs/019.out |    5 +++++
 2 files changed, 10 insertions(+)


diff --git a/tests/xfs/019 b/tests/xfs/019
index b30116560c7c40..5804ef228bd9d2 100755
--- a/tests/xfs/019
+++ b/tests/xfs/019
@@ -82,6 +82,7 @@ pipe p--670 0 0
 symlink l--123 0 0 bigfile
 : a file we actually read
 bigfile ---666 3 0 $tempfile.2
+rsvfile r--666 3 0 1234567
 : done
 $
 EOF
@@ -117,6 +118,10 @@ _verify_fs()
 	diff -q $SCRATCH_MNT/symlink $tempfile.2 \
 		|| echo "symlink broken"
 
+	rsvblocks=$(stat -c '%b' $SCRATCH_MNT/rsvfile)
+	test $rsvblocks -gt 0 \
+		|| echo "rsvfile broken"
+
 	echo "*** unmount FS"
 	_full "umount"
 	_scratch_unmount >>$seqfull 2>&1 \
diff --git a/tests/xfs/019.out b/tests/xfs/019.out
index 9db157f9b413b9..9fd3b577e1ab94 100644
--- a/tests/xfs/019.out
+++ b/tests/xfs/019.out
@@ -69,6 +69,11 @@ Device: <DEVICE> Inode: <INODE> Links: 1
  Mode: (0670/frw-rwx---) Uid: (0) Gid: (0)
 Device: <DEVICE> Inode: <INODE> Links: 1 
 
+ File: "./rsvfile"
+ Size: 0 Filetype: Regular File
+ Mode: (0666/-rw-rw-rw-) Uid: (3) Gid: (0)
+Device: <DEVICE> Inode: <INODE> Links: 1 
+
  File: "./setgid"
  Size: 5 Filetype: Regular File
  Mode: (2666/-rw-rwsrw-) Uid: (0) Gid: (0)

