Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF7D347C7;
	Thu, 31 Oct 2024 19:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730403355; cv=none; b=c63yO2l+wmGu1CCh+mk4qGopBLISmmhf3EpsvrNuhAKOAypAxqd+vxHFIPb3woxEVKWk5MFbjuG9wM9UUFCz2pGTsBhX+SewIZ80+sy0qQcMOZbt36+OCPQnFD4ohZ7SIfTkOXUH0S6JbYhLLsHjJdoi00ciSDAlB4oquGifkOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730403355; c=relaxed/simple;
	bh=3jIF5En1Q97Q4cjqBHX/ztJEx4TUApIJqSoCZcobDBI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=p+UOZd4q/Nv91/ZHzKYa1dVKklJ+pCe32xJHFPyCz+INuinwii8ufoNSrNELXc9R+orzdOEp7NhLt0yWHe5eNSH35bc4Ma7xzdN8nxFGA9e1+FmigP/umG8W/Rq1pKjlgzkSR+/WBvKq5iUFbDfRSJqY3LvNU4alj8RcK/MonDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KHdFXYKC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KHdFXYKC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78B1EC4CEC3;
	Thu, 31 Oct 2024 19:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730403355;
	bh=3jIF5En1Q97Q4cjqBHX/ztJEx4TUApIJqSoCZcobDBI=;
	h=From:To:Cc:Subject:Date:From;
	b=KHdFXYKCvPhaflgFjOUaMTRw7Rla8JxzteE/Pwe3uLtZyu31vyyUF2TfL78lve259
	 650aV+mo3qh0dgOaI4b9JfhisMzHITalxxN5l+dQLzxQJwgAvg/5dDqb0tVWzkuzJ3
	 KwNgOGBy1/K1nruShm2CEkLpXqn6zFjLOwqL73nJszRViaxmpaL8KpsX5fT9ZPcIEW
	 tWbvWsyPYEpkRAenMA0TGHSuab7ReuuMj/sFu7SBnvgfdPcMaU8kb3IoUgStJ/PZVW
	 inUD7jjj86QUmhm+Cvf0OwBg/tGEuXE4cvW2uP4AldlzNeXOdu9V0LE08/CkAHIn0H
	 +bplHYZK/nSlA==
From: Zorro Lang <zlang@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH] xfs/157: mkfs does not need a specific fssize
Date: Fri,  1 Nov 2024 03:35:52 +0800
Message-ID: <20241031193552.1171855-1-zlang@kernel.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The xfs/157 doesn't need to do a "sized" mkfs, the image file is
500MiB, don't need to do _scratch_mkfs_sized with a 500MiB fssize
argument, a general _scratch_mkfs is good enough.

Besides that, if we do:

  MKFS_OPTIONS="-L oldlabel $MKFS_OPTIONS" _scratch_mkfs_sized $fs_size

the _scratch_mkfs_sized trys to keep the $fs_size, when mkfs fails
with incompatible $MKFS_OPTIONS options, likes this:

  ** mkfs failed with extra mkfs options added to "-L oldlabel -m rmapbt=1" by test 157 **
  ** attempting to mkfs using only test 157 options: -d size=524288000 -b size=4096 **

But if we do:

  _scratch_mkfs -L oldlabel

the _scratch_mkfs trys to keep the "-L oldlabel", when mkfs fails
with incompatible $MKFS_OPTIONS options, likes this:

  ** mkfs failed with extra mkfs options added to "-m rmapbt=1" by test 157 **
  ** attempting to mkfs using only test 157 options: -L oldlabel **

that's actually what we need.

Signed-off-by: Zorro Lang <zlang@kernel.org>
---

This test started to fail since 2f7e1b8a6f09 ("xfs/157,xfs/547,xfs/548: switch to
using _scratch_mkfs_sized") was merged.

  FSTYP         -- xfs (non-debug)
  PLATFORM      -- Linux/x86_64
  MKFS_OPTIONS  -- -f -m rmapbt=1 /dev/sda3
  MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/sda3 /mnt/scratch

  xfs/157 7s ... - output mismatch (see /root/git/xfstests/results//xfs/157.out.bad)
      --- tests/xfs/157.out       2024-11-01 01:05:03.664543576 +0800
      +++ /root/git/xfstests/results//xfs/157.out.bad     2024-11-01 02:56:47.994007900 +0800
      @@ -6,10 +6,10 @@
       label = "oldlabel"
       label = "newlabel"
       S3: Check that setting with rtdev works
      -label = "oldlabel"
      +label = ""
       label = "newlabel"
       S4: Check that setting with rtdev + logdev works
      ...
      (Run 'diff -u /root/git/xfstests/tests/xfs/157.out /root/git/xfstests/results//xfs/157.out.bad'  to see the entire diff)
  Ran: xfs/157
  Failures: xfs/157
  Failed 1 of 1 tests

Before that change, the _scratch_mkfs can drop "rmapbt=1" option from $MKFS_OPTIONS,
only keep the "-L label" option. That's why this test never failed before.

Now it fails on xfs, if MKFS_OPTIONS contains "-m rmapbt=1", the reason as I
explained above.

Thanks,
Zorro

 tests/xfs/157 | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tests/xfs/157 b/tests/xfs/157
index 9b5badbae..459c6de7c 100755
--- a/tests/xfs/157
+++ b/tests/xfs/157
@@ -66,8 +66,7 @@ scenario() {
 }
 
 check_label() {
-	MKFS_OPTIONS="-L oldlabel $MKFS_OPTIONS" _scratch_mkfs_sized $fs_size \
-		>> $seqres.full
+	_scratch_mkfs -L oldlabel >> $seqres.full 2>&1
 	_scratch_xfs_db -c label
 	_scratch_xfs_admin -L newlabel "$@" >> $seqres.full
 	_scratch_xfs_db -c label
-- 
2.45.2

