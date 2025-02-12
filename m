Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC87A271839;
	Wed, 12 Feb 2025 03:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739331416; cv=none; b=g8PvQCMI/TdOsuQcdUOnPHFvCZbYS5me1YV2afe/kS6x+hzq1yrUGXC9qx2f+ptIDPansumg48YTMZ/MHOHQlc8MsTugyG8Hsgl8aJ57BGTr6NU5Mu6S/r7wgAtVv+Bp9aOJyPvFQyj26pAZkv9F83OpoBvcQDRHjqxTr6JtuWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739331416; c=relaxed/simple;
	bh=WpIc94suubpjHJnKhOBBYOECB/pFawGd8zkbzqiJeu8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MeN+Slh7OyCQPebx4DJXD+s71lyXD/edUdlLz3D4ICY+203kXL2q+hepYfcf1wFhvfcI+/zCTuOghG9kJVEQ9D+TDzFMMqkV/k38EY4X4wYf35AaJeuXQG8PQDMQ9BNjejLWyp/Co0rSppuGZP98CafouKmejeMaYCHfRYhT0Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NiiacOJR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NiiacOJR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F149C4CEDF;
	Wed, 12 Feb 2025 03:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739331416;
	bh=WpIc94suubpjHJnKhOBBYOECB/pFawGd8zkbzqiJeu8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NiiacOJRsOzXk6LKK472VjtYhrMTJBSs8wSybU2FvkYcg5s7Bss67vtHHJGIBVMk2
	 FL9pex3RuzlndNFzLZZcUaN29kG5FJbxhO+pvny5XSvpWUVJUlD8yow0jOjZWIKa1y
	 7wkcP8wjhzoN4GMbuvAbWEhi93xuQLl/+CgNfJ/h6Ss+fD3/ObWy8gV6nma9+JcIBG
	 2EEGm1JMoy+JvkAkm++Unq8tD14mHyvio1fqyTcbU879rqZJxvZOn74vXRXRGu+Ar5
	 mHrzuG+jzl4ikUSNANwqEc9Gk6a7fdKqSLTldwcBF7kf3O0RBhzUNVgUXm2xjc0C53
	 0p/1eG1HkzPrQ==
Date: Tue, 11 Feb 2025 19:36:56 -0800
Subject: [PATCH 24/34] fuzzy: stop __stress_scrub_fsx_loop if fsx fails
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: dchinner@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173933094723.1758477.8183602439525227610.stgit@frogsfrogsfrogs>
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

Stop the fsx scrub stress loop if fsx returns a nonzero error code.

Cc: <fstests@vger.kernel.org> # v2023.01.15
Fixes: a2056ca8917bc8 ("fuzzy: enhance scrub stress testing to use fsx")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
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

