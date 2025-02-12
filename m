Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 154FD271839;
	Wed, 12 Feb 2025 03:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739331448; cv=none; b=qoVaU5gkCbZitAFoqYytQCE8+zRcEgMPdvdebmQrd6UUaS+rU/CAGT78SSzkYq5TfFvfisJ/f6fwLIvjCgIbTClCX49Ql50r2rYGrA25/0CGSWeH8pbd2r5t6vEdEAj68z9SzOOXdd8PJ6ebFcZYWm1VPplSH0rjSxXBb4q4gDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739331448; c=relaxed/simple;
	bh=/n+89Yi0yNErhM0Pdz2no3Gqz1DpEt4s5ZOrbY70BPs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=urxKeifr4UPQKGaMynN30uTaCQNJPe8TfqgJpF3t3RyaURYVtSobVz/pbr+WKNSPkKM16DnjxMDDC8SpqLrb5vMF8b+lvdkb3tsbNYEtVpExrkRsvNoqwQUE1QyyRKahvCoQdrVmpUur1VYYQhwHLHtbFUn4qr9fEqKCjop1YFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u00wQBBp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u00wQBBp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D673CC4CEDF;
	Wed, 12 Feb 2025 03:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739331447;
	bh=/n+89Yi0yNErhM0Pdz2no3Gqz1DpEt4s5ZOrbY70BPs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=u00wQBBppp04V7O7SO/0q3TkjolPQwQ2sh774kBBtScTq4REHNAAy2n06MX8LljYG
	 4FvgcqxnyW+f4U4t9JKwmp4JLMQoleJeBRLAL37GrkD/lKxEtDzXosGRHVoLGMRIkh
	 Y5gEymr2AytY7Mh/M6xsDzNv4fsvUGJYimhiI1UkhAH0gdrec/As0gYXraNXX90Zni
	 EYkKspgJrbLL+MUnFSwTtEFeixXl7NIMOvv+49AbvuJwH4408FTZb4pU2uvqNTNP0J
	 wSIVJnUvMW3+kuX7sNNs2CK+Jm6R53JgJdJuj5C3mEMBDwsmaaf+O+w0PP9LKRIOwX
	 X1KnxeHrUF7pg==
Date: Tue, 11 Feb 2025 19:37:27 -0800
Subject: [PATCH 26/34] fuzzy: always stop the scrub fsstress loop on error
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: dchinner@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173933094751.1758477.7246574156968435728.stgit@frogsfrogsfrogs>
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

Always abort the non-remount scrub fsstress loop in
__stress_scrub_fsstress_loop if fsstress returns a nonzero exit code.

Cc: <fstests@vger.kernel.org> # v2023.01.15
Fixes: 20df87599f66d0 ("fuzzy: make scrub stress loop control more robust")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 common/fuzzy |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)


diff --git a/common/fuzzy b/common/fuzzy
index 41547add83121a..8afa4d35759f62 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -1012,6 +1012,7 @@ __stress_scrub_fsstress_loop() {
 	local remount_period="$3"
 	local stress_tgt="$4"
 	local focus=()
+	local res
 
 	case "$stress_tgt" in
 	"parent")
@@ -1143,7 +1144,9 @@ __stress_scrub_fsstress_loop() {
 		# Need to recheck running conditions if we cleared anything
 		__stress_scrub_clean_scratch && continue
 		_run_fsstress $args >> $seqres.full
-		echo "fsstress exits with $? at $(date)" >> $seqres.full
+		res=$?
+		echo "$mode fsstress exits with $res at $(date)" >> $seqres.full
+		[ "$res" -ne 0 ] && break;
 	done
 	rm -f "$runningfile"
 }

