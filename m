Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F3811A6815
	for <linux-xfs@vger.kernel.org>; Fri, 10 Apr 2026 06:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775801906; cv=none; b=Woh5h0oWcAHLiv3SPIw+WPlsIlaqfYZQeoVb1V5Sjk2WVMIxl7SB2ulCArkjko3C69fcyURDoH8muDbhjY1aAGJ9noTAGn1NXQoMjyMhM1h2eJj60C3e37CMUohHXsb7zjKcpUeX8IQh5x+7TJ8GDVEVIOg3pOAgmsqww4IoX4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775801906; c=relaxed/simple;
	bh=FlY5P2zPl3Pg6opz7xs5ZPG4OHnVF3xyxG8PKysq0C4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BdVmqVZeVTiifTQYYpe5m6noMpgEhG0qN1LMGei4cmk9OuE1zg+27R0sDmOOdRGoPX7klqGwbgLqALEXRikkRfpbN505xXssbzpZ/+8uWfVs8lIVXowAv89PuqE0/Cgq0JwXwTspedQAeHiGCTFcVv6yCgnpzoWfdqd5H6uZADY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lqtu2/DG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lqtu2/DG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B667CC19421;
	Fri, 10 Apr 2026 06:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775801905;
	bh=FlY5P2zPl3Pg6opz7xs5ZPG4OHnVF3xyxG8PKysq0C4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Lqtu2/DG59iwsQkOobrDxVpxr7GrbC4hQuI0vSXab1BtDAKntT8a0jEHFg0RFgm7M
	 efGRIdTu7otCKK1RdbtJciL0ZwvBCKjk2AVBZcTIUTbwcJLDcIu0CvqBeY39oQhdMQ
	 deyfIhpekmw+cjiW4EKqA17E5bORvipFbxkVPclOrXDafS3BlBQbNB0Pu8a2Uugg8V
	 cMQ62V88/7plAYpVRtUTxWK7toXP4r5wzkR/wYg06Yl+XcQKhRYAyw08OALP6rvCPg
	 NGIOQd+5bI/4u1IG4JqsG/CJm3eTKDbXIqri5Loq4UyIMdKZESUFO6iZJLChw/NnDA
	 kZP288VvPA8FA==
Date: Thu, 09 Apr 2026 23:18:25 -0700
Subject: [PATCH 04/21] xfs_scrub: report truncated devices as media errors
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <177577385105.2090237.2334652471185607902.stgit@frogsfrogsfrogs>
In-Reply-To: <177577384929.2090237.10369276062302001541.stgit@frogsfrogsfrogs>
References: <177577384929.2090237.10369276062302001541.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

If we encounter a zero-length read of an xfs device but don't hit any
actual media errors, we won't report the truncated device.  Fix that.
Also fix the mistake that flushing the verify-pools of the log/rt
devices doesn't actually cause scrub to abort.

Cc: <linux-xfs@vger.kernel.org> # v6.13.0
Fixes: a6e089903f2f58 ("xfs_scrub: tread zero-length read verify as an IO error")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/phase6.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)


diff --git a/scrub/phase6.c b/scrub/phase6.c
index abf6f9713f1a4d..590e5d23e6b267 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -782,9 +782,13 @@ phase6_func(
 	 * If the verify flush didn't work or we found no bad blocks, we're
 	 * done!  No errors detected.
 	 */
-	if (ret || ret2 || ret3)
+	if (ret || ret2 || ret3) {
+		ret |= ret2 | ret3; /* caller only cares about non-zero/zero */
 		goto out_rbad;
-	if (bitmap_empty(vs.d_bad) && bitmap_empty(vs.r_bad))
+	}
+	if (bitmap_empty(vs.d_bad) && !vs.d_trunc &&
+	    bitmap_empty(vs.r_bad) && !vs.r_trunc &&
+	    !vs.l_trunc)
 		goto out_rbad;
 
 	/* Scan the whole dir tree to see what matches the bad extents. */

