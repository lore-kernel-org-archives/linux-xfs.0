Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D431DED47;
	Wed, 12 Feb 2025 03:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739331119; cv=none; b=Bf1EG/BdCO5yMCZHyD1vAPhdVj3MMDIfSxK7WISzgClK5wAjxIJa3G9CA3BYUJ5tHUt3PQdQbcmZcBxrx1SrQlkmTRb9Ps2QMXScP56wfGSzAQksT6j7+8zZecOEpBpZ79Y1DsX22z2Mjqn2aXkYX2PjGGeElTRTvKuUsfImGGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739331119; c=relaxed/simple;
	bh=VRYUeiK787KhKsh1XLRh/asd5CV/XWYXisoWT61ASg8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uu7fVVy5AVrGHoLS76H213BCMmj3uT8u8SRQLGKapH695tan/E8KbP1QbF3yEqsk/X7OGcQC+0p4PponeKBQ3ICwyE00CKlBW/zlivWakRpWTrZ7YAIVvfLeOnKg9hS/fjLtE8qr5WvdUzebhU0PE+GJN4dxZ9hLgVx1TTjICL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EyDuIhSa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EyDuIhSa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39ED1C4CEE4;
	Wed, 12 Feb 2025 03:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739331119;
	bh=VRYUeiK787KhKsh1XLRh/asd5CV/XWYXisoWT61ASg8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EyDuIhSaMW5bARusGV3PSW9ZGRvoRvFhpJ7e++nu1OhKdEUrrv0PRLZMfdb4TlnGV
	 3XeSZcstTiszLD4pRVPF+xAqcL0tWtoZK8VrjcLJLZZKcUCa0SJUhintzbIllAIIG1
	 VtxXx672act4ckpdg3fTNXFWeYfXxprtjpTMX774Cubyinq7gVJVh8CzehGDJ7/EEp
	 EIH1sxzPKCKb25H4nb5M4/S9YznTtnIe3p6XPWejOy1hC1exfSgbOoVRZs5ZT+uZKo
	 lXpUcPI7scFS8W4vEfGOBTz/URgOrlcMnzVWdhHnG6byIlfMv11MQJYVTkQp003yHJ
	 pD4eAnqc7xSQw==
Date: Tue, 11 Feb 2025 19:31:58 -0800
Subject: [PATCH 05/34] fuzzy: do not set _FSSTRESS_PID when exercising fsx
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: dchinner@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173933094431.1758477.9322338790981462887.stgit@frogsfrogsfrogs>
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

If we're not running fsstress as the scrub exerciser, don't set
_FSSTRESS_PID because the _kill_fsstress call in the cleanup function
will think that it has to wait for a nonexistant fsstress process.
This fixes the problem of xfs/565 runtime increasing from 30s to 800s
because it tries to kill a nonexistent "565.fsstress" process and then
waits for the fsx loop control process, which hasn't been sent any
signals.

Cc: <fstests@vger.kernel.org> # v2024.12.08
Fixes: 8973af00ec212f ("fstests: cleanup fsstress process management")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 common/fuzzy |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)


diff --git a/common/fuzzy b/common/fuzzy
index 534e91dedbbb43..0a2d91542b561e 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -1392,7 +1392,11 @@ _scratch_xfs_stress_scrub() {
 
 	"__stress_scrub_${exerciser}_loop" "$end" "$runningfile" \
 			"$remount_period" "$stress_tgt" &
-	_FSSTRESS_PID=$!
+	# The loop is a background process, so _FSSTRESS_PID is set in that
+	# child.  Unfortunately, this process doesn't know about it.  Therefore
+	# we need to set _FSSTRESS_PID ourselves so that cleanup tries to kill
+	# fsstress.
+	test "${exerciser}" = "fsstress" && _FSSTRESS_PID=$!
 
 	if [ -n "$freeze" ]; then
 		__stress_scrub_freeze_loop "$end" "$runningfile" &

