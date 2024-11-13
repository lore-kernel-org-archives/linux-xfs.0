Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3044BBA34;
	Wed, 13 Nov 2024 01:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731461835; cv=none; b=We9y81VLWubQpZ6fpiXc8Hln/PnWXZp6VOjGFdJ+B/vKnGOg2oueYwPsCSbtun6gpIKDyh11vvbOCPGaL0bdiJQ+5fl4bVTZlrtnTKoPaM5mAlvxkXIMIQaRtmvUaKMv1ZcgIcSNRx4wtQMyAsD+KMGa3UZRN6/wB/DMGAF15E4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731461835; c=relaxed/simple;
	bh=akMV1VHwnVRUKKGYxllDugCek8hxaU4/UdAIbGLo08A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ciGryroOEa16jRN2GO18rzsJtiiaBf8qKo0rhz2NU+DLMQFH23qCaBPlRfV6gV11GA22itsggQ7xox7XmJ4Y2EDmtfHG7DBlVoQJIKwTRMM+ZjGKisZk3TNFez9FnSz2vX2EClApj5NcmH9lrnJ7eWceGYlb9d/nsH6655SaCN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EddWdiHD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EddWdiHD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C07E5C4CECD;
	Wed, 13 Nov 2024 01:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731461834;
	bh=akMV1VHwnVRUKKGYxllDugCek8hxaU4/UdAIbGLo08A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EddWdiHDTz6FEKfsSqaB3zZDwdUv6zSapd+O49TNjUT7ZTGcmuw2yvPJdjDYGw9YX
	 7BvUnroXtnqJGXPKQ1WawvVmr0bzTaubpx+ndXggY4cj2NVAzCnfEmH7NyCrr6HZQ8
	 E/PIDzpsXu6Z3/qa2XVtbQ7Z3YOGWhfDRaNJ6pb0VRB8+SITIozxhRcLLz98VPNyj7
	 Fm/bTbCm0epcVu7KqLYp9Ndy8ot35nTZDM+6rPNCLaAXVNz0/TxUxoGcdpHFA+YAnw
	 Oi1BYOJdAjrH3ofS7SSH1SvXR6ZR2vDU1+SptVPICbr+F4VBlqeUj8EE7q2xkB89m/
	 fYGbr3DoXlxGw==
Date: Tue, 12 Nov 2024 17:37:14 -0800
Subject: [PATCH 2/3] xfs/185: don't fail when rtfile is larger than rblocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <173146178844.156441.16410068994780353980.stgit@frogsfrogsfrogs>
In-Reply-To: <173146178810.156441.10482148782980062018.stgit@frogsfrogsfrogs>
References: <173146178810.156441.10482148782980062018.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

This test creates a 200MB rt volume on a file-backed loopdev.  However,
if the size of the loop file is not congruent with the rt extent size
(e.g.  28k) then the rt volume will not use all 200MB because we cannot
have partial rt extents.  Because of this rounding, we can end up with
an fsmap listing that covers fewer sectors than the bmap of the loop
file.

Fix the test to allow this case.

Cc: <fstests@vger.kernel.org> # v2022.05.01
Fixes: 410a2e3186a1e8 ("xfs: regresion test for fsmap problems with realtime")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/185 |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/tests/xfs/185 b/tests/xfs/185
index b14bcb9b791bb8..f3601a5292ef0b 100755
--- a/tests/xfs/185
+++ b/tests/xfs/185
@@ -156,7 +156,9 @@ fsmap() {
 
 # Check the fsmap output contains a record for the realtime device at a
 # physical offset higher than end of the data device and corresponding to the
-# beginning of the non-punched area.
+# beginning of the non-punched area.  The "found_end" check uses >= because
+# rtfile can be larger than the number of rtextents if the size of the rtfile
+# is not congruent with the rt extent size.
 fsmap | $AWK_PROG -v dev="$rtmajor:$rtminor" -v offset=$expected_offset -v end=$expected_end '
 BEGIN {
 	found_start = 0;
@@ -165,7 +167,7 @@ BEGIN {
 {
 	if ($1 == dev && $2 >= offset) {
 		found_start = 1;
-		if ($3 == end) {
+		if ($3 >= end) {
 			found_end = 1;
 		}
 	}

