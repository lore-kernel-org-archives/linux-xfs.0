Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7156725A62C;
	Tue,  4 Feb 2025 21:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738704483; cv=none; b=XUrvUHAFXO0TbvUWJiHNw5TsPge7Hoc1La21sOfJOfFwwF2hJnLcZQi0cbNgQB365dEKizMaXEkdbcegePCupzf4F/m581gajpEBhTtcoRxPiwhe6K1NQhoOw97x90ATZensgcOgKWZ0VcN07tCiqnyBIUZUed8DwkSsRJTlRVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738704483; c=relaxed/simple;
	bh=gp1onK8uvfEuThJc4YpVSq1SKLm9J/oDr1p28llFw9U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i97NPbeOWGluNCKa4ehPwTkfdcb+UJygHrqKjDE/3DaLO5Mg85Y8/3756m0hJSoTmSkbQRsPxFRiQ+WwX6Im+AYfDTT7y68tw2fCgW0G5150MgMwNPfPx/OgfuS6TsRPGgaQGbCTlxlWLyJp9B5oAyU4wRLbD/7R9JAmnS+NnPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=koTR3jK9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="koTR3jK9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46816C4CEDF;
	Tue,  4 Feb 2025 21:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738704483;
	bh=gp1onK8uvfEuThJc4YpVSq1SKLm9J/oDr1p28llFw9U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=koTR3jK9pMfkZdkiB5WetBG2Hfm39sEr2WeYcYG4g3KlRZcxk0I/upmoO8YoD0u8R
	 C/fukTr0Gaq7TXUs86SxnxaXS9zLctPK9fE2F8pH0doa/H/vMAYwBDpn6YRjuuK5I5
	 7Gi+XGaMh0mKZYcI+seLFIMX0HaQbFONQcryp1AdhOBgBEjj6RjbaUMfp1HI61EXmV
	 dhvsa+L37f6efDpiPL9zHq1y4PodWR/m/qR5vL/23XpWxmpdxRLEBCQfFVK1JBYFSm
	 pS4s6tpp4WmjFHwK6TFsCWEIsyHbfP1PajaOpv3enVlHV79bq+e86ppHj72llqJnIY
	 RHnHUHkQBnZOg==
Date: Tue, 04 Feb 2025 13:28:02 -0800
Subject: [PATCH 22/34] generic/650: revert SOAK DURATION changes
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173870406442.546134.7449017953421049612.stgit@frogsfrogsfrogs>
In-Reply-To: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
References: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
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

