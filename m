Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794447442;
	b=uDjou3kqfdt+aaFijzWr1kYDgeTS7nhfxZJSbQ6Q15VfYrPSZYuJ6zbQkijDPzLMqjRe
	 CdvTDBrAsf0mZrdIoCFbQZiVuNz9uguI0zuQn2axzO8Tgvr+Eaum+uFipKBXN8hPg3+uV
	 6q/8fKO9nn7BJbnO+oLMMCHUfpU1A89SrIBi/HvOf1aOGYSoSWwfls9ZEI7Bykaa/a+yR
	 dVk2oEN7V7vLGkEAFOqaXsKSKrET1EkdmCeMFWwSPcFDpeho/U7r4iE3FYgEwPIbFwTnT
	 Bfq+165C/Ch7wbql0YJA5hZrH5HddYQwF80rwgEi+EdkDWBGBlJ0nunbQ8vr0BlVZ8w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794447442;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=48kOiK8VKo8J9UJL5JkDVMhCHeeWO1B0PM7xwbVqSBg=;
	b=1HCKfcsUuL5sapgJK94JkGMNt53NYSdbee9yh4Y56NrWso27CNCx9MbQ7zWNSNTv3DOb
	 i6wMnx2dX/w52fGd5/tJNCbudRjsvGpG4Odz4Ld2SwpDzOpTLxS8UQJVdCi/5pue0QUf4
	 J26VNUvFZrMkINx9cWZ2kkxxUFtZIs6rZNlVpwGDGa58ZnswkYqYXE41pNSBGsBANezCX
	 DbHDlK54Rpb9nc492z+h4r5hsfiWSj8fDBWEHoJq/cZL2n/Dt6LJviqYbCi1MPurdi6sE
	 vFMNOL26TiHQUGRvMigHbrOcp5svnU0C6YqjTT251FK/nNF80GdRlZRUyMHd7BA1zUQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GmgYRNLq;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10CB2606A321;
	Thu, 12 Nov 2026 01:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GmgYRNLq
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794447441;
	b=k3rKjELEO00jMPTPqM0Cexpz2+bzcnGj5fb6+qO+uOF4y2jbH6nTZYdSteKtLh41MiVm
	 xvO6hf/NqDUAL2RYT+sl9yGeOL8Ps3TIRC4fpYoPXNnC31Xw7IU+2+FytPNq0aVrYIeE6
	 hxCuIGEdjB5fAMSVNiuYimdykzkJJk3F9ksbLNFCpxIxc31iqSvNpPD7Lu2Qul9SRYmFF
	 hFts93EcCVG+M1kUSJKbXLQMbjPK4aPfAcJnT3x7a8kXsk7KJpi8t479lGUamkwxIGfn3
	 n2JZd8pLnGu7Ysld4F6+a0N525Lck9ay1pgMmWO49TAI3T+Lgc9fQSI3f/KCLOqRDXg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794447441;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=48kOiK8VKo8J9UJL5JkDVMhCHeeWO1B0PM7xwbVqSBg=;
	b=2Q7GJMnwyISRQyyTOeSMCCy1qU+2qEjqeRXc7nSimwmx7N10kXAJRfTs15qOE2G7Qx+m
	 qQtMGSOjwYANqFDptwnwCwS8AXwAjtAwiJL+Y7+dIVsr/wHiZIC1pASkBfOo043oH5+3H
	 3iD2EHzMFLnD4QIZ/i/eFhpESk0iewcpf+hHDOERTmSQVzpE7Wiywpo/UEG4a4MRomDdZ
	 PDoZRWyZq3TeGz6mbWuAHIZVeBlzaLbEkV26D9VK4xV40sXRFBOlgxWA3srqf/02BobfW
	 B2KaaXK65s1WWbNub/ZkSD95GkRUaYZKHvlHXuoUcnf5uRUlc0dbTIqIKbJjvho+x2g==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id E01A11F00A05;
	Thu, 12 Nov 2026 01:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794447441;
	bh=48kOiK8VKo8J9UJL5JkDVMhCHeeWO1B0PM7xwbVqSBg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=GmgYRNLqSlIOVADTJWy/e3tbSWeMWaZNc/wOB23xA4/vcFtt1CBcYV/+ULGhcB4sY
	 aug7ONuy8dR/tbYe87RlGbG47eahlM4B1z0TmPTzwtPNaABJ5T3slitaN5tOdB038M
	 EnACSR2jACHL3ZwjWYAj33lWB6e2nTSbEhWnKaEt8saCvzmUr6nUGrueUKzr/hNFDF
	 3FCDiP/odeeNFGjWkDo8k3JUyUV/bnFcf4BwvJARnSi5QaQ3QLq5XQNQbnjleRZfnk
	 g220iqcRvUd2zq1mimIlk/QVF+F968oDIqpNcjh4ihkK6nvAkGMEDitDPKi733q+N9
	 XXTW7sPYAeAJQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 609B4491BB;
	Thu, 12 Nov 2026 01:37:20 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Thu, 12 Nov 2026 10:37:17 +0900
Subject: [PATCH 1/2] xfs/438: retry failed metadata writes again
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261112-xfs-438-dquot-retry-v1-1-73149b823246@samsung.com>
References: <20261112-xfs-438-dquot-retry-v1-0-73149b823246@samsung.com>
In-Reply-To: <20261112-xfs-438-dquot-retry-v1-0-73149b823246@samsung.com>
To: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org
Cc: "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>, 
 Brian Foster <bfoster@redhat.com>, Dave Chinner <dgc@kernel.org>, 
 linux-xfs@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794447436; l=2680;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=OBUGkimxrIsMu9LAjPKmqMotfyRv2/Jb4lKdfqxdUxA=;
 b=O7yMa1AHBoHyfBwnXp0F9FgRVKpxALdUSNQ7MUI3cqrBT+0WTFAecWuYEvaJzeith1G4Y92tt
 thBhwpnJVhzAEzGlUcx775GxhTgOfh8DR+eLYstW94fiuPjngonTaRJ
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com
Content-Transfer-Encoding: 7bit

From: Daejun Park <daejun7.park@samsung.com>

xfs/438 checks that a dquot buffer write that keeps failing does not
hang the unmount (kernel commit 373b0589dc8d). Commit eb2ad950ea90
moved the test to _scratch_mount. Since commit 1a49022fab9b,
_scratch_mount sets the metadata EIO retries to 0. XFS then shuts
down on the second failure, before the AIL can retry the write. The
test passes even with the bug.

Turn the retries back on after the mount. Fail the test if XFS has
shut down before the unmount.

Fixes: eb2ad950ea90 ("dmflakey: override SCRATCH_DEV in _init_flakey")
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
Tested on kernels with and without XFS_DEBUG. Patch 1 gives the same
results on both. With an internal log, v7.4-rc2 passes 3 of 3. A TEST
ONLY kernel that skips the resubmission of failed AIL items hangs at
unmount (1 of 1). Without patch 2, the new check fails in three cases:

- with the dm patch and a write cache (3 of 3)
- with an external log (1 of 1)
- with an rt device that has a write cache (from the code, not run)

In each, XFS shuts down on a log error before the unmount. Patch 2
passes in the first two cases.
---
 tests/xfs/438 | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/tests/xfs/438 b/tests/xfs/438
index 4cd0b26..e4850ff 100755
--- a/tests/xfs/438
+++ b/tests/xfs/438
@@ -95,6 +95,9 @@ _require_flakey_with_error_writes
 _require_user
 _require_xfs_quota
 _require_freeze
+_require_test_sysfs_dev_attr error/fail_at_unmount
+_require_test_sysfs_dev_attr error/metadata/EIO/max_retries
+_require_test_sysfs_dev_attr error/metadata/EIO/retry_timeout_seconds
 
 echo "Silence is golden"
 
@@ -117,6 +120,12 @@ sysctl -w fs.xfs.xfssyncd_centisecs=100 >> $seqres.full 2>&1
 _qmount_option "usrquota"
 _scratch_mount
 
+# _scratch_mount turns off the retries of failed metadata writes.
+# Go back to the kernel defaults, so that the failed dquot buffer
+# write is retried from the AIL until unmount. fail_at_unmount
+# stays on, so the unmount ends the retries on a fixed kernel.
+_reset_xfs_sysfs_error_handling $SCRATCH_DEV >> $seqres.full
+
 # We need to set the quota limitation twice, and inject the write error
 # after the second setting. If we try to inject the write error after
 # the first setting, the initialization of the dquota buffer will get
@@ -145,6 +154,10 @@ _scratch_sync
 # the completion of the retried write of dquota buffer
 sleep 2
 
+# The dquot buffer write must still be failing and retried here. A shut
+# down filesystem means that the test missed the hang it checks.
+stat $SCRATCH_MNT > /dev/null
+
 _scratch_unmount
 
 _cleanup_flakey

-- 
2.43.0


