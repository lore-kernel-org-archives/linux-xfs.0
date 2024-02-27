Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8794F1F2;
	Tue, 27 Feb 2024 04:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709008822; cv=none; b=kFnn2t6dmE6hwu8fA/A0b96+Bvl6UcheJrrvVxZJZvVCrk/cTlxSxJywepOaxJ9Yb5gJ/TDzl4h3fyOqBmmB7G2YQFuDecx+8kOUg1wkmVO8TKaT3R6um8e5tumowo29cAzqR/ivjtRmg3Uy24J+NSO9It7ar5iUq/D2ImJpsp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709008822; c=relaxed/simple;
	bh=gh27Pzf7dE7+lEXjdVtsyqFVT0HebT7CruYVsqhW3gA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F84jOOrY6oYorSZPqr1KWRoIJ8Dy01fFd79xs9Es5/MtECV8PBCStyZ9wk5YnyIClyEZyC/tcUL3ZzwZzP3gM2+KfOjPVVKo0Xo76+dXPK2B1l7bbCutcY2BfFf2NbSfT8p8IX6UXLNKSC4KvUkg7eEFGqQCGP6Q8SU2SypFeVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y/bmuqNz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y/bmuqNz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B46C43390;
	Tue, 27 Feb 2024 04:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709008821;
	bh=gh27Pzf7dE7+lEXjdVtsyqFVT0HebT7CruYVsqhW3gA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y/bmuqNzT6v02yfNpR1n1l+Htyj8qCrKdnIB0Iw2uW/76tUTblZIluBh73+wS9KP0
	 jr3hPjr/MUG63BorkXyWRt5IDzCCPbcZEZtJ3FcC/axoS3TBl1KrLZ96OjhnXy678v
	 BvYpWs32+EYkYWiRZKC2UcWeU+iZDP+Xvcfhvp03andGO1uESHKLfNSSE1Phcy0GQQ
	 LULMVG8A4R3tnqd8yrY5czRwx43L1xsVpbXKmMwayuhVaRMGpDcQ6qJc0oKfSSvLAq
	 Njf2yPUGethsVNSU/ObSNyQGrVbbMsh5/zhzfQgUy6/Z1lEUAbPvV/XygzzZ/iPLeu
	 ceKgHK9K+MhQQ==
Date: Mon, 26 Feb 2024 20:40:21 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com
Cc: linux-xfs@vger.kernel.org, guan@eryu.me, fstests@vger.kernel.org
Subject: [PATCH v1.1 1/8] generic/604: try to make race occur reliably
Message-ID: <20240227044021.GT616564@frogsfrogsfrogs>
References: <170899915207.896550.7285890351450610430.stgit@frogsfrogsfrogs>
 <170899915233.896550.17140520436176386775.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170899915233.896550.17140520436176386775.stgit@frogsfrogsfrogs>

This test will occasionaly fail like so:

  --- /tmp/fstests/tests/generic/604.out	2024-02-03 12:08:52.349924277 -0800
  +++ /var/tmp/fstests/generic/604.out.bad	2024-02-05 04:35:55.020000000 -0800
  @@ -1,2 +1,5 @@
   QA output created by 604
  -Silence is golden
  +mount: /opt: /dev/sda4 already mounted on /opt.
  +       dmesg(1) may have more information after failed mount system call.
  +mount -o usrquota,grpquota,prjquota, /dev/sda4 /opt failed
  +(see /var/tmp/fstests/generic/604.full for details)

As far as I can tell, the cause of this seems to be _scratch_mount
getting forked and exec'd before the backgrounded umount process has a
chance to enter the kernel.  When this occurs, the mount() system call
will return -EBUSY because this isn't an attempt to make a bind mount.
Slow things down slightly by stalling the mount by 10ms.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
v1.1: indent commit message, fix busted comment
---
 tests/generic/604 |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tests/generic/604 b/tests/generic/604
index cc6a4b214f..00da56dd70 100755
--- a/tests/generic/604
+++ b/tests/generic/604
@@ -24,10 +24,12 @@ _scratch_mount
 for i in $(seq 0 500); do
 	$XFS_IO_PROG -f -c "pwrite 0 4K" $SCRATCH_MNT/$i >/dev/null
 done
-# For overlayfs, avoid unmouting the base fs after _scratch_mount
-# tries to mount the base fs
+# For overlayfs, avoid unmouting the base fs after _scratch_mount tries to
+# mount the base fs.  Delay the mount attempt by a small amount in the hope
+# that the mount() call will try to lock s_umount /after/ umount has already
+# taken it.
 $UMOUNT_PROG $SCRATCH_MNT &
-_scratch_mount
+sleep 0.01s ; _scratch_mount
 wait
 
 echo "Silence is golden"
