Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB0E2045B8;
	Tue,  4 Feb 2025 21:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738704515; cv=none; b=QA3MxkUychaCvXRank4D37j7O8XOfXHMIRiYzqN16Pl8mUOa+PFUHsQQ+tokkwPCtEywazjwVUxRdSD+RmU9GnNspN9eGX2B+rTaxpj/wI50w5XrjVjRXDwQce9QCyChtFHCBoDB/+EOqBUNGXvExp0rPSZNSmSizbdjAX0mFP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738704515; c=relaxed/simple;
	bh=HOL5reByZJOj4D0msi9sSrVrWxlb6wZxTnsSNtv9GHg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qLl5aZh8mSt7nMtRFolriSIGx8cj9CamrP7ZNaMF9mqvMEU3Cbj9oEEDT+HmgwV3lLWYe/BOkfAA32/Qbcsqj5EEkgrLwoBaP/I32i+/U8m2hI+f/07l6Rewl9qUwdyNroRxHLUWPHvC6q0lrHCEgaaVZG256YY4NSzNA5g1qyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eYDnZQM4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eYDnZQM4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 899E4C4CEDF;
	Tue,  4 Feb 2025 21:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738704514;
	bh=HOL5reByZJOj4D0msi9sSrVrWxlb6wZxTnsSNtv9GHg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eYDnZQM45Y+qi0znV4LukKc0lsfKu6PSVNhDmex5R+uWtvjnb4AW1bHPo7fZCCrUW
	 7Es93IhA2Lu8/pP9CXA5Zl+Zx0qGtQwY1tP+pkr9mWUd/cgH+TfqkgNWYzmJVFTii7
	 N1ZfSko7mLUzemjQfhoZP2aSwiocajGlcRmxX4V+Wqe5UtStYEpAoX8wgE2QzdJBtV
	 89g9a++UO66425a5dLKwNH+NuETPZdEM6dkCzfWcjVwQ+t4sEAoizp3rqxkTyYHpM1
	 FQzF2xvVUHqQXpB4r8bleoO7BXzs3WSIYtMT5Uy2cL+cRHe1QXCubxSm6NxAfMK2rM
	 I1uoSGLu1s7pw==
Date: Tue, 04 Feb 2025 13:28:34 -0800
Subject: [PATCH 24/34] fuzzy: stop __stress_scrub_fsx_loop if fsx fails
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173870406473.546134.15374973350883945437.stgit@frogsfrogsfrogs>
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

Stop the fsx scrub stress loop if fsx returns a nonzero error code.

Cc: <fstests@vger.kernel.org> # v2023.01.15
Fixes: a2056ca8917bc8 ("fuzzy: enhance scrub stress testing to use fsx")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/fuzzy |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)


diff --git a/common/fuzzy b/common/fuzzy
index 6d390d4efbd3da..9d5f01fb087033 100644
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

