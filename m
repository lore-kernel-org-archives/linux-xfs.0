Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788DE271839;
	Wed, 12 Feb 2025 03:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739331526; cv=none; b=JoJD93RguOy/VmHQiz7lqVDwzV/KYMaIm8I2iy2E0ADYvsbGG5mmGgFdS00tkcZM5YJTR2Fz/OEa2cDfl8jXEZxdP5kRLFm+4PfZt44fzMiviJ6p8gf29heg0q3o+n0vgf5JN3q9P7VfYH9I3jRgWnDHYTG+28Xojy4GbJWtuw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739331526; c=relaxed/simple;
	bh=ULpbBe52ry67K5EfFU1S2pj23M5/Hyl/23q+Pfm2XgI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HgBH7H00L5d1Nf07rM7025yzvfIf/9ScYNv3pV5utlCXzUd+YqB1sWn9EwuBva0a/Xl1pYsLfTljDaWc+6OQsN2nhXnlHjhY95fTFC375LvTwnZnO7OcWD5K01o0GQmY9qz9I3wnhO7iigGtNZ4u0EAGqp+3pPvEXONZQY4bd6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gPrIMau6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gPrIMau6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4B71C4CEDF;
	Wed, 12 Feb 2025 03:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739331525;
	bh=ULpbBe52ry67K5EfFU1S2pj23M5/Hyl/23q+Pfm2XgI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gPrIMau6edsQ6Op88yTN2AN4oi4PaZCW3vtRzXfw6PiPxysS4Zihu4mA2pXgeqW++
	 2GYml9XzsliRQ5898iCFCM+qAsq3X7OpPOdPmnkSH4sxssirQ4/T5O2eSFxPinCpY9
	 PcprSjwhhb2l5dyLm9PLbhAr/T/HGaATOrcm5cd3t1o/xHRXhhJ0bKncSaOO1oI6Lw
	 +e/+MXo1tseHE8wviYfgFsD7JqTGDKxcs/H+Pt5jMUur/7255vxs8Y2Wc+H30M92KZ
	 a1ntUHkW1gEGo7igc4hNhfBOaCY2cIWrrbYBa4NO0eXa4ZYLmY/1R1+oJfrehZQLeL
	 Mx3AwHAs8LbUA==
Date: Tue, 11 Feb 2025 19:38:45 -0800
Subject: [PATCH 31/34] misc: don't put nr_cpus into the fsstress -n argument
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: dchinner@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173933094828.1758477.8612152730597674505.stgit@frogsfrogsfrogs>
In-Reply-To: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
References: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

fsstress -n is the number of fs operations per process, not the total
number of operations.  There's no need to factor nr_cpus into the -n
argument because that causes excess runtime as core count increases.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 tests/generic/476 |    2 +-
 tests/generic/642 |    2 +-
 tests/generic/750 |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/tests/generic/476 b/tests/generic/476
index 4537fcd77d2f07..13979127245c77 100755
--- a/tests/generic/476
+++ b/tests/generic/476
@@ -18,7 +18,7 @@ _scratch_mkfs > $seqres.full 2>&1
 _scratch_mount >> $seqres.full 2>&1
 
 nr_cpus=$((LOAD_FACTOR * 4))
-nr_ops=$((25000 * nr_cpus * TIME_FACTOR))
+nr_ops=$((25000 * TIME_FACTOR))
 fsstress_args=(-w -d $SCRATCH_MNT -n $nr_ops -p $nr_cpus)
 test -n "$SOAK_DURATION" && fsstress_args+=(--duration="$SOAK_DURATION")
 
diff --git a/tests/generic/642 b/tests/generic/642
index 4b92a9c181d49c..3c418aaa32bd23 100755
--- a/tests/generic/642
+++ b/tests/generic/642
@@ -20,7 +20,7 @@ _scratch_mkfs > $seqres.full 2>&1
 _scratch_mount >> $seqres.full 2>&1
 
 nr_cpus=$((LOAD_FACTOR * 4))
-nr_ops=$((70000 * nr_cpus * TIME_FACTOR))
+nr_ops=$((70000 * TIME_FACTOR))
 
 args=('-z' '-S' 'c')
 
diff --git a/tests/generic/750 b/tests/generic/750
index 5c54a5c7888f1d..a0828b50f3c7e4 100755
--- a/tests/generic/750
+++ b/tests/generic/750
@@ -37,7 +37,7 @@ _scratch_mkfs > $seqres.full 2>&1
 _scratch_mount >> $seqres.full 2>&1
 
 nr_cpus=$((LOAD_FACTOR * 4))
-nr_ops=$((25000 * nr_cpus * TIME_FACTOR))
+nr_ops=$((25000 * TIME_FACTOR))
 fsstress_args=(-w -d $SCRATCH_MNT -n $nr_ops -p $nr_cpus)
 test -n "$SOAK_DURATION" && fsstress_args+=(--duration="$SOAK_DURATION")
 

