Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78023522F;
	Tue, 26 Nov 2024 01:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732584126; cv=none; b=aBtzjG0I3NF37qzkP5+l9NAP3taiPZTlWO8KBLvLVk+GIn3OZOojVeP6vUA3hMh4Oi3fH9Sw+X6xRFRbDOmOA9yzOzcwaXvP5bXDwzFli14S+tF7KiOSCOJIlCALSOo9/gssfzz4IJ3uHFh0CFkm9OHCzrn56mm48OPzZTXemMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732584126; c=relaxed/simple;
	bh=jtDg7rV60EHbv2fundEmPAeiRtCpunRCaDZWcIOnfxo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PHJoo2ImfT/mCWDWgMvGoqwQA9e7N6ZbqfgCRAZrDfnDtVB9PdF7UStZqJGuQgeKrH6iS9lrkK1IMQ0XFDhqj/PmG0DXZ28e2UmQumnEwzeT2BYYrBeR3niWGOe4Gz/r15VMwrXFiagBlLtTqF1U9eQcUx/z1c1LGiQhnLmPhCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dd2tuEV9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dd2tuEV9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D4B0C4CECE;
	Tue, 26 Nov 2024 01:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732584126;
	bh=jtDg7rV60EHbv2fundEmPAeiRtCpunRCaDZWcIOnfxo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dd2tuEV929Or10j5T8+ow51V5kI3Qtd3YNXkeXyCuzuKLgxZMtPf+havcML2H+P4F
	 HrmIO+5c6iYzh6FO3WthaQ8fAWnMTDAR3BMn3f/n3z9z075G781rfMjieKT+LMDzlC
	 Nj6n1YYi6XfbuaQliutvvnYWc8rQ9fg8Ch/tmzVV4wATJP3evXTltrCpruKscwxvs0
	 aW0ZU9DicaO0CI63UIs92R+TbQ1Xgyo5ysMld4vf+YYzNixBuJKyak3G5dxFn+YODh
	 6QaApF0sa6PDL2vgE7dHltxXwG9IcrZvW5bzUnP84sZorU4hQfFy/cUwhtyTkzvwSa
	 raRekUDpW38Rw==
Date: Mon, 25 Nov 2024 17:22:05 -0800
Subject: [PATCH 06/16] generic/562: handle ENOSPC while cloning gracefully
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173258395162.4031902.7701863569170725350.stgit@frogsfrogsfrogs>
In-Reply-To: <173258395050.4031902.8257740212723106524.stgit@frogsfrogsfrogs>
References: <173258395050.4031902.8257740212723106524.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

This test creates a couple of patterned files on a tiny filesystem,
fragments the free space, clones one patterned file to the other, and
checks that the entire file was cloned.

However, this test doesn't work on a 64k fsblock filesystem because
we've used up all the free space reservation for the rmapbt, and that
causes the FICLONE to error out with ENOSPC partway through.  Hence we
need to detect the ENOSPC and _notrun the test.

That said, it turns out that XFS has been silently dropping error codes
if we managed to make some progress cloning extents.  That's ok if the
operation has REMAP_FILE_CAN_SHORTEN like copy_file_range does, but
FICLONE/FICLONERANGE do not permit partial results, so the dropped error
codes is actually an error.

Therefore, this testcase now becomes a regression test for the patch to
fix that.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/generic/562 |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)


diff --git a/tests/generic/562 b/tests/generic/562
index 91360c4154a6a2..36bd02911c96b8 100755
--- a/tests/generic/562
+++ b/tests/generic/562
@@ -15,6 +15,9 @@ _begin_fstest auto clone punch
 . ./common/filter
 . ./common/reflink
 
+test "$FSTYP" = "xfs" && \
+	_fixed_by_kernel_commit XXXXXXXXXX "xfs: don't drop errno values when we fail to ficlone the entire range"
+
 _require_scratch_reflink
 _require_test_program "punch-alternating"
 _require_xfs_io_command "fpunch"
@@ -48,8 +51,11 @@ while true; do
 done
 
 # Now clone file bar into file foo. This is supposed to succeed and not fail
-# with ENOSPC for example.
-_reflink $SCRATCH_MNT/bar $SCRATCH_MNT/foo >>$seqres.full
+# with ENOSPC for example.  However, XFS will sometimes run out of space.
+_reflink $SCRATCH_MNT/bar $SCRATCH_MNT/foo >>$seqres.full 2> $tmp.err
+cat $tmp.err
+test "$FSTYP" = "xfs" && grep -q 'No space left on device' $tmp.err && \
+	_notrun "ran out of space while cloning"
 
 # Unmount and mount the filesystem again to verify the operation was durably
 # persisted.

