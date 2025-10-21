Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1934634D90E;
	Tue, 21 Oct 2025 18:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761072031; cv=none; b=OsKtsmwuoq+BAsuexKeM72JoBsC8wzmqu2nmed9vZneotqTLvunqdw/BD1LdwbrXgbH0LrjJuvmVWKlEVnPNxtjLSx9XHbIqQiXDGI6HSz2NrvE3cXm+5QcnqxAs0I9r3QLqpbJGFbwl4ZrhQVy4wp56CpaGBl3Rv2RYC8XmQNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761072031; c=relaxed/simple;
	bh=giKUnhTKO9bynREaln0qCxyy81VQo9AoMz81lc4rG5k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UkuhKTULeDNh6tMZ9Ea3slAZ2z0BRR7+zI2FyalBS4661UWNG9X6FNawPUhrELRkCyQwAWyLodXRervTEuwVf4i+uP+6jlHYvKhXoslBzVDwXv1Brqdd5PXHTJjvlMjLsMWk6lcbhJAS9ATx3TOCLBr9+QQp67O0kXAiAzZRc3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Emq6QiqK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Emq6QiqK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7AF4C4CEF1;
	Tue, 21 Oct 2025 18:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761072031;
	bh=giKUnhTKO9bynREaln0qCxyy81VQo9AoMz81lc4rG5k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Emq6QiqKk9KMECAmSF7+SKQK86HDlyRmFGhKxPmdgj3S6/Ghz8UA40HnYnlco/YDJ
	 nOYmxwRahirl7KRhfN3IoYa2gj4ZNryLvv3CITgvnHqcYm6+J2QLkQL/a5iVTP7zeb
	 L6fIPD74ZhSmbAbUhPz3lFdgnhy9nYvBMiLv9r2mTVUSSmdvt/QtebBTVapUN8/qCl
	 cCmUvG2jtbCASDr3or/a2DyVXspLtoPd0Sc7YrMQL/WWEgZVpzaMYvA+3rlZh8abH6
	 AQdee3cO68O55xPfxEjl3nByJ3xDjENiAdAA6im6NOiKu1ZSMfQc0Lf6bNyDs+Mkud
	 1qKjKYZ2ebySA==
Date: Tue, 21 Oct 2025 11:40:30 -0700
Subject: [PATCH 05/11] generic/772: actually check for file_getattr special
 file support
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <176107188760.4163693.9360276768392352557.stgit@frogsfrogsfrogs>
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

On XFS in 6.17, this test fails with:

 --- /run/fstests/bin/tests/generic/772.out	2025-10-06 08:27:10.834318149 -0700
 +++ /var/tmp/fstests/generic/772.out.bad	2025-10-08 18:00:34.713388178 -0700
 @@ -9,29 +9,34 @@ Can not get fsxattr on ./foo: Invalid ar
  Can not set fsxattr on ./foo: Invalid argument
  Initial attributes state
  ----------------- SCRATCH_MNT/prj
 ------------------ ./fifo
 ------------------ ./chardev
 ------------------ ./blockdev
 ------------------ ./socket
 ------------------ ./foo
 ------------------ ./symlink
 +Can not get fsxattr on ./fifo: Inappropriate ioctl for device
 +Can not get fsxattr on ./chardev: Inappropriate ioctl for device
 +Can not get fsxattr on ./blockdev: Inappropriate ioctl for device
 +Can not get fsxattr on ./socket: Inappropriate ioctl for device

This is a result of XFS' file_getattr implementation rejecting special
files prior to 6.18.  Therefore, skip this new test on old kernels.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 tests/generic/772 |    3 +++
 tests/xfs/648     |    3 +++
 2 files changed, 6 insertions(+)


diff --git a/tests/generic/772 b/tests/generic/772
index cc1a1bb5bf655c..e68a6724654450 100755
--- a/tests/generic/772
+++ b/tests/generic/772
@@ -43,6 +43,9 @@ touch $projectdir/bar
 ln -s $projectdir/bar $projectdir/broken-symlink
 rm -f $projectdir/bar
 
+file_attr --get $projectdir ./fifo &>/dev/null || \
+	_notrun "file_getattr not supported on $FSTYP"
+
 echo "Error codes"
 # wrong AT_ flags
 file_attr --get --invalid-at $projectdir ./foo
diff --git a/tests/xfs/648 b/tests/xfs/648
index 215c809887b609..e3c2fbe00b666a 100755
--- a/tests/xfs/648
+++ b/tests/xfs/648
@@ -47,6 +47,9 @@ touch $projectdir/bar
 ln -s $projectdir/bar $projectdir/broken-symlink
 rm -f $projectdir/bar
 
+$here/src/file_attr --get $projectdir ./fifo &>/dev/null || \
+	_notrun "file_getattr not supported on $FSTYP"
+
 $XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
 	-c "project -sp $projectdir $id" $SCRATCH_DEV | filter_quota
 $XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \

