Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B0CD25A62C;
	Tue,  4 Feb 2025 21:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738704217; cv=none; b=abB1o952lmIOxfOK/XRX1L8ABq+z9L1CK8mmMBEfwfSf8Bb8/FiCdUBRV85KAa8DtjzxV4Me+vqDUKU7ravTfHfnXc/91/zUjCS+VPzKo+49W8qThPdezpHmgOdDyheopEa/MZJTK5mJCKnMX5P2cZnt9btlL2ocWIWk/GLeCIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738704217; c=relaxed/simple;
	bh=VRYUeiK787KhKsh1XLRh/asd5CV/XWYXisoWT61ASg8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VaEH0jR5jeCgg28rvYA+44mLHr6X1NPalUXKPPBpY08xtQ8X+wC2Nx27RfA8fcNimL1N5ILSZE8YsWnuepEPag3s4WGoPcPfZSe3Aj+NnwIxQm76VgQ+aSoccOAp6trGyJ2J94s02vA1XO5qtnwPP1kR4B1qAV2GmkBMIEsT8tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iSDFiXj9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iSDFiXj9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76489C4CEDF;
	Tue,  4 Feb 2025 21:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738704216;
	bh=VRYUeiK787KhKsh1XLRh/asd5CV/XWYXisoWT61ASg8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=iSDFiXj90C/ljSdblnZ7EUnM4lghL7j5UtecmALnuQHDglYGxaHNUWF+1NTya47Ac
	 H/utkOKr/Box1AhleLMUpoqxMkBM/moD8KOfRvblhh2NeELpBfllzTArhHUp3lWNWV
	 sPpiJuYA5Deq8W4d/ZqMFK7wLMUwRoKOwAUjk5xvizFeYNT+DdcjgFPb7l+ahuX/Tx
	 DGtEqIQgGfo2JViEhCN/0QfgD2bYq8f61BsyKQS+VoccvkLQ5MvnOuPUKwW0XncLj8
	 QcDNcIbxwFwZIH5RmbTA8IUDL6lLemO2/KSVybWEdkPsrYs2YWGPfpgUgFdPosbcjt
	 zrCDxIbZMRkIg==
Date: Tue, 04 Feb 2025 13:23:36 -0800
Subject: [PATCH 05/34] fuzzy: do not set _FSSTRESS_PID when exercising fsx
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: dchinner@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173870406184.546134.9073986926028160277.stgit@frogsfrogsfrogs>
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

