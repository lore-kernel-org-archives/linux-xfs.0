Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ECDE271839;
	Wed, 12 Feb 2025 03:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739331385; cv=none; b=kZTNB7CbRVPucp8sSOOK9/5w2JfYjwfwauGpBwAKgoudLleG0JbXuj4tDJr8hT3xhFCwURdVUVhamx1eOdTJPeOOXKXQG8g4N5HihvsHE0lxayhjcCOfpTs/FzMqXl1dcek2YvNZhB3YUcX+17UP0QynrqoTYYuKeWaaKVOQ0gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739331385; c=relaxed/simple;
	bh=FT/SqX5SFqZaM9Qkhejdf97ayHiJt25PkU2l0MytvYI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UaPDV3GBtDuJa24MyxvW7NeiJIV33RrgYl3pDpBj8ZOJTOV2kwCgpYciEWYhtzkEwO2LtffLrp9wj69CFTOmfXPgh5A0D4H/E8ivgdnvETiaFtgt5Al3+5aJhYMjn1aL0hGbSm20c0N7eZE2YH4+wnPwC1T6fagNXlmLE29GwuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VlSTVqkQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VlSTVqkQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F96C4CEDF;
	Wed, 12 Feb 2025 03:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739331385;
	bh=FT/SqX5SFqZaM9Qkhejdf97ayHiJt25PkU2l0MytvYI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VlSTVqkQS5nsKEsaPEqJ4WzM7hn++xg1z05gINDpZYx7Mgh6VvPGZcFCfAneXu2nD
	 8z6V80S1PzVQmtV41ed5Cn0cBuEYVokN/r4aPd3J6y9ZuPHcAaQHQFgfAdVdZL/F0+
	 y7pXQHJcYKXAxbfOkQZ0ubp59/yGe5xkAcVV+06KBnygyIbE+mqe2FsEbbb+gr+F4+
	 C706ZMkb2jCaL/udhCBw98EoBj1wEY4fT2Io/ZxguhTP88P+nkCu0JShEQ/AWBiZYH
	 oi3Qgs3eO3ZxgPM17IFccGpzTIf0PgFQNuuiAvoemw0Q+ICYXaGe6XXG8+UYdgK0w1
	 kQi1xRCGwjV9g==
Date: Tue, 11 Feb 2025 19:36:24 -0800
Subject: [PATCH 22/34] generic/650: revert SOAK DURATION changes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: dchinner@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173933094692.1758477.17192795201455141457.stgit@frogsfrogsfrogs>
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

Prior to commit 8973af00ec21, in the absence of an explicit
SOAK_DURATION, this test would run 2500 fsstress operations each of ten
times through the loop body.  On the author's machines, this kept the
runtime to about 30s total.  Oddly, this was changed to 30s per loop
body with no specific justification in the middle of an fsstress process
management change.

On the author's machine, this explodes the runtime from ~30s to 420s.
Put things back the way they were.

Cc: <fstests@vger.kernel.org> # v2024.12.08
Fixes: 8973af00ec212f ("fstests: cleanup fsstress process management")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 tests/generic/650 |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/tests/generic/650 b/tests/generic/650
index 60f86fdf518961..2e051b73156842 100755
--- a/tests/generic/650
+++ b/tests/generic/650
@@ -68,11 +68,11 @@ test "$nr_cpus" -gt 1024 && nr_cpus="$nr_hotplug_cpus"
 fsstress_args+=(-p $nr_cpus)
 if [ -n "$SOAK_DURATION" ]; then
 	test "$SOAK_DURATION" -lt 10 && SOAK_DURATION=10
+	fsstress_args+=(--duration="$((SOAK_DURATION / 10))")
 else
-	# run for 30s per iteration max
-	SOAK_DURATION=300
+	# run for 3s per iteration max for a default runtime of ~30s.
+	fsstress_args+=(--duration=3)
 fi
-fsstress_args+=(--duration="$((SOAK_DURATION / 10))")
 
 nr_ops=$((2500 * TIME_FACTOR))
 fsstress_args+=(-n $nr_ops)

