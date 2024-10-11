Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8AE317C60;
	Fri, 11 Oct 2024 01:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610890; cv=none; b=TYz5b8u6b0rbY2BNALzmPhLaesEL+p7XI1d7imATXK0qOrnWAhaJRNCcgbAZdNCUVcZ2odVWIXPR7laVk8sO2sMjt4iIqCVYtyDmgQ/4F1/1TGY1wNOvcnXc4SFvmKj/4Nly7xCgVWSjuBVmbpCQZRTRRobPUbVoCPLQ+FUCz6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610890; c=relaxed/simple;
	bh=zHeNgZzuCsgt2JT82tkIEUf25wDeR1pjrOeBQMkdgnk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AHOk7uEnafMYCaLyRIRLiLWYvOiKXVPbERw3NZV0mJz9XOthFmwRUKWFoJ46BWiodEtvEBv2gfg4SEnTaQseH9voHOJ2A9HZak4nIbJIOdT1ZPKM3Yd+dfdGY3UPbnP/DE8ywUc13ees57+DfNNLOG0AjT5MtgAX2/RHq1t4u7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qk0P79MZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qk0P79MZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96454C4CEC5;
	Fri, 11 Oct 2024 01:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610890;
	bh=zHeNgZzuCsgt2JT82tkIEUf25wDeR1pjrOeBQMkdgnk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qk0P79MZ9jVQUURcTRmPplImXK2xI3TtQ64uKVWsyhvrKbMNu70+Mn20tS+DOereD
	 ck65siNQ+AXEtLtmxP6rWpEYJYScux/mcMnHL1wRhOFOxsQsZef9wzqPN1qszZvCLz
	 63aVqX80Fw3eisJZf71HTz/Z2orrRa5nbW9XR3X0UO84bO0sslOKURLP2AczDhgBCz
	 8HDULOHuWChH1Ox1/APUeDL+kjDVXNfWGYazLtAKW0LgQnI56/94zAklfJ7HGoGUT+
	 xB9gZAhbw1M4/BerWU0ObebqUf1rQmR8KlqVgHqkrRa1HrPgDhDGbYE0CCH8HA+NgT
	 b9KRrscK4/5Kg==
Date: Thu, 10 Oct 2024 18:41:30 -0700
Subject: [PATCH 02/16] common/{fuzzy,populate}: use _scratch_xfs_mdrestore
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, fstests@vger.kernel.org
Message-ID: <172860658552.4188964.2373195912801336436.stgit@frogsfrogsfrogs>
In-Reply-To: <172860658506.4188964.2073353321745959286.stgit@frogsfrogsfrogs>
References: <172860658506.4188964.2073353321745959286.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Port the fuzzing and populated filesystem cache code to use this helper
to pick up external log devices for the scratch filesystem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy    |    2 +-
 common/populate |   15 ++-------------
 2 files changed, 3 insertions(+), 14 deletions(-)


diff --git a/common/fuzzy b/common/fuzzy
index 14d6cb104aaf57..73e5cd2a544455 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -306,7 +306,7 @@ __scratch_xfs_fuzz_unmount()
 __scratch_xfs_fuzz_mdrestore()
 {
 	__scratch_xfs_fuzz_unmount
-	_xfs_mdrestore "${POPULATE_METADUMP}" "${SCRATCH_DEV}" || \
+	_scratch_xfs_mdrestore "${POPULATE_METADUMP}" || \
 		_fail "${POPULATE_METADUMP}: Could not find metadump to restore?"
 }
 
diff --git a/common/populate b/common/populate
index 82f526dcf9e2d5..94ee7af9ba1c95 100644
--- a/common/populate
+++ b/common/populate
@@ -1017,19 +1017,8 @@ _scratch_populate_restore_cached() {
 
 	case "${FSTYP}" in
 	"xfs")
-		_xfs_mdrestore "${metadump}" "${SCRATCH_DEV}"
-		res=$?
-		test $res -ne 0 && return $res
-
-		# Cached images should have been unmounted cleanly, so if
-		# there's an external log we need to wipe it and run repair to
-		# format it to match this filesystem.
-		if [ -n "${SCRATCH_LOGDEV}" ]; then
-			$WIPEFS_PROG -a "${SCRATCH_LOGDEV}"
-			_scratch_xfs_repair
-			res=$?
-		fi
-		return $res
+		_scratch_xfs_mdrestore "${metadump}"
+		return $?
 		;;
 	"ext2"|"ext3"|"ext4")
 		_ext4_mdrestore "${metadump}" "${SCRATCH_DEV}"

