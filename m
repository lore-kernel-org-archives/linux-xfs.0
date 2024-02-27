Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BAC7EAF1;
	Tue, 27 Feb 2024 02:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708999248; cv=none; b=klgXp+z8pwNJgMpN7Pa1qxtq7D24CKcubexWyUnkeb4vKiuVeIGmxpxajGPdYx8oJE6IKQ3jaYsgqIXs1Ih0JR0CeGhPNKXb5/6tbXYjyIyjLE1hE0il84cVC8SGunmD0nY1YzhJJru7huqKM4+4ZF4BKTguGtYQh+rBmFGZSwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708999248; c=relaxed/simple;
	bh=2owk3JtNox36xuzddMGB20nlVUgICJzv8/Ftvol8Jc8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CoVDQOQfqLCk85cCXyd6UzaMMxwAuMSi1eLMEbg5sNOTSXAm1kgR76pLXyYGLTBTDgLVf75hP5RjkX1X14e7VARvYCUCYw0eLGHvtRrbQGVyq5WRvDQuxuGbky2+0FHSy3oZQgN4NY3w/PcQWmGJxM6axwQFzHWZT73PzaYjxVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rJI0Sxw3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rJI0Sxw3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ED8BC433F1;
	Tue, 27 Feb 2024 02:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708999248;
	bh=2owk3JtNox36xuzddMGB20nlVUgICJzv8/Ftvol8Jc8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rJI0Sxw3cmyf+GYxBpMiHEGpvI8kpzk4277xKSnH1FikA1I4lj6qL1EBazKYXHfOC
	 IeVRZBWihzkk/I0KeBbkHmAr1TNV0+r3ndDZMB7sToOrOlho9PFTcmKH2WmUAnUlRP
	 0mPzGdZYsCV/m7VBx1JlBWULwzMFRvAcP0VrBVqKt0Y5OMNj2tCKzDIKkt/EDy3BOq
	 SxwlIJuX2eXA24a6iiG26F0izFXD53J1DhAo7cZ6PIO0GUDJTCvThihqf+NF54O9mM
	 EYz7OdnREBXT3+YmVxStufHV+tPljlXGMtEGvgI/mQwdmZj+jpLbc5Jby1o6q7uxFy
	 FPzcoGpgiV9jA==
Date: Mon, 26 Feb 2024 18:00:47 -0800
Subject: [PATCH 1/8] generic/604: try to make race occur reliably
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: linux-xfs@vger.kernel.org, guan@eryu.me, fstests@vger.kernel.org
Message-ID: <170899915233.896550.17140520436176386775.stgit@frogsfrogsfrogs>
In-Reply-To: <170899915207.896550.7285890351450610430.stgit@frogsfrogsfrogs>
References: <170899915207.896550.7285890351450610430.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

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
 tests/generic/604 |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)


diff --git a/tests/generic/604 b/tests/generic/604
index cc6a4b214f..a0dcdcd58e 100755
--- a/tests/generic/604
+++ b/tests/generic/604
@@ -24,10 +24,11 @@ _scratch_mount
 for i in $(seq 0 500); do
 	$XFS_IO_PROG -f -c "pwrite 0 4K" $SCRATCH_MNT/$i >/dev/null
 done
-# For overlayfs, avoid unmouting the base fs after _scratch_mount
-# tries to mount the base fs
+# For overlayfs, avoid unmouting the base fs after _scratch_mount tries to
+# mount the base fs.  Delay the mount attempt by 0.1s in the hope that the
+# mount() call will try to lock s_umount /after/ umount has already taken it.
 $UMOUNT_PROG $SCRATCH_MNT &
-_scratch_mount
+sleep 0.01s ; _scratch_mount
 wait
 
 echo "Silence is golden"

