Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01E3246A1A;
	Thu, 16 Jan 2025 23:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737070145; cv=none; b=Xhj2H8rbc1tX1IJjLTu7wVxoSfkMWSGOk3BKp8Z/k+1aJX5iipiNLLr4bimZVsAtEjwylY+HMZtEdirz/lNbPB8mxtPGfMxvVT5b9SFjRsMXuaaVif+zrsGp2QbUCmNn6gDrAIqnJi3BVPTic/8TXQP8LiOL36RzSMqUC4+2opE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737070145; c=relaxed/simple;
	bh=iO0iI3hdF14/3TfhI+y5wOBx1ezEVL6+28e34+1KT1o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NiLZc92BsvxTSJifWceDl1B/NhHOV/ZqoZ9YFvkxQqN5fvx0q+DmTj8RFWGtUGCtlKF4c6ivllKFlZcvgs6nAQod7i+gFOqQOTePj+QSBO93efBiqWXyn/qDuWNCV9njRqecJiZf+NvQSXjjG6+Zd2p014abpvT1VrPPxWvDlYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FlKDS+PH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FlKDS+PH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED19C4CEE5;
	Thu, 16 Jan 2025 23:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737070145;
	bh=iO0iI3hdF14/3TfhI+y5wOBx1ezEVL6+28e34+1KT1o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FlKDS+PHN8nNbzZas/ZbMydyzVzffdDKf0AwDxWf00Swq3LtsmdhgroEzD2HAB1sY
	 ptiG+Bq8rSfNj8v5SOwKbN1co7rgA0Yv0y9dux3Mz3wSlmUCIPMRQ25ma6VkhxEnRU
	 WFdUPcnhSL0VzspEBRH2B9OIM3yfnsocywYD3pOv04xIiVwR9J0PPv36ITchg5BHxQ
	 9rGkDJ2RMLGUlNPdt5hzbYPaC6165GvAmYoGIJFxojN4jNPmfAENap+qJ/gbNS8cee
	 jrEb+o8tMGGaGWKrM01qPC9I1he+1vmE650EaGj+bLOzid+WsuwS3ISUp46gNQiybN
	 xcBS1UHCY//Iw==
Date: Thu, 16 Jan 2025 15:29:04 -0800
Subject: [PATCH 15/23] fuzzy: stop __stress_scrub_fsx_loop if fsx fails
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706974303.1927324.5257281389524141050.stgit@frogsfrogsfrogs>
In-Reply-To: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Stop the fsx scrub stress loop if fsx returns a nonzero error code.

Cc: <fstests@vger.kernel.org> # v2023.01.15
Fixes: a2056ca8917bc8 ("fuzzy: enhance scrub stress testing to use fsx")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/fuzzy |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)


diff --git a/common/fuzzy b/common/fuzzy
index 772ce7ddcff6d8..46771b1d117106 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -942,6 +942,7 @@ __stress_scrub_fsx_loop() {
 	local remount_period="$3"
 	local stress_tgt="$4"	# ignored
 	local focus=(-q -X)	# quiet, validate file contents
+	local res
 
 	# As of November 2022, 2 million fsx ops should be enough to keep
 	# any filesystem busy for a couple of hours.
@@ -993,7 +994,9 @@ __stress_scrub_fsx_loop() {
 		# Need to recheck running conditions if we cleared anything
 		__stress_scrub_clean_scratch && continue
 		$here/ltp/fsx $args >> $seqres.full
-		echo "fsx exits with $? at $(date)" >> $seqres.full
+		res=$?
+		echo "fsx exits with $res at $(date)" >> $seqres.full
+		test "$res" -ne 0 && break
 	done
 	rm -f "$runningfile"
 }

