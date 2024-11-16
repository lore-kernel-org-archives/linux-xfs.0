Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E80C919306F;
	Sat, 16 Nov 2024 19:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731784084; cv=none; b=mVsWZ0wJlnNI0Oa0qtUDRmkFaaDD4QoT3emoRTDJixylr72dvJBCmZWLa23DLMpuS//kSNJXKcNQZDpvNuvdldXYAL0WZWvC68yIPP0IdzZXjD5x/axucVi8ulkgqcEtEqBhK9R8loV3QL/wtRqbJXAHYrd4S/VlaCike6yg+qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731784084; c=relaxed/simple;
	bh=w3rJ00GC+6ol5by0IWnf4bDDfDamd7ILQOdlYKQu4Vk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=k/vaMQeN4WVTPXKtjuOmouU7KsLvU3BNzKY5Xk6ol9/tKSx9053HoABmiDA7lYU1dPRgGNPH9Sx/VJPGdG0MjWD3Ghhg2RCaUZZe44bP1pmkJQly9GBaEEPnDRe97Ssa+NKzZrdVw7FHuEEXLcAxi91OkTlYbxJFwtitxkV9X44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZVC+WmyQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZVC+WmyQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEE80C4CEC3;
	Sat, 16 Nov 2024 19:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731784083;
	bh=w3rJ00GC+6ol5by0IWnf4bDDfDamd7ILQOdlYKQu4Vk=;
	h=From:To:Cc:Subject:Date:From;
	b=ZVC+WmyQeuodc9/WYTLXBlu1lBL8U9fhZVKvCJ8M3UVeKSSWqB1lBmZcv53i7m/l4
	 r7oU4cOPLn/M7ViX1mfue3ljaUtExv0eWRjDsByjQIhS/4thSnDhLq0qdp/uH0yxYm
	 7TjqksdYreZ3W6Q2r183wSN70P3pTQXuB0eAY/ySiX+kUHchgfUB0KiZvhWHOxx6Sm
	 4jX3yAQP7EjQmdNUxkrY8Gi6DA262oqSRleRJuHCSau3KckGHdLaHDxdMYPGMp0vu6
	 xA6sjkpFVbDYF+1OzJDSGcFc/b/gt+mhBIqoaGxvzm2gYdBlUoMZEqKuJIKxQ1BlcI
	 IzoFIQBONxO0Q==
From: Zorro Lang <zlang@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 0/2] fstests: fix test issue of xfs/157
Date: Sun, 17 Nov 2024 03:07:58 +0800
Message-ID: <20241116190800.1870975-1-zlang@kernel.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs/157 started to fail since 2f7e1b8a6f09 ("xfs/157,xfs/547,xfs/548: switch to
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
only keep the "-L label" option. That's why this test never failed before. To fix
this failure, this patchset does:

The [PATCH 1/2] helps _scratch_mkfs_sized to support extra argument, then the
extra argument can be sent to _scratch_mkfs, which will try to "protect"
the extra argument from being dropped.

The [PATCH 2/2] invokes the new _scratch_mkfs_sized in xfs/157 to fix the
test failure of it.

Thanks,
Zorro
