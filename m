Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845BB7DA95;
	Wed, 19 Feb 2025 01:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926830; cv=none; b=O6URUbWI8kz05fpwPPILnw40gKAFtSFav7s9dpYzCpr+QO5S8hUFQ35J0YIf7ftWtWwIXsLyIr5UjfxsJnPuzetxSkRctm8zNOPDwPg2to64q05FNlSVCSxq1dTFLyWLqUIYl5uHVhP0icar+JTMGXlxFsX3XBNJvee914t9Zos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926830; c=relaxed/simple;
	bh=y2ABjItUbd32HXtlfAm1Ea3pYTAv4cHjPK7axHPk1jU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V6PIEidPsTlkfaN+ubQHjkT7QsiHP46a44jCu1uhbYH//DP8sNXCV6XlbNoDOYvyzQZJILtZAWjVFBWNNxG6gKgHBjuFWrVlfq2AVMUBW6OxMhC/sdPuH5DhbR9R9ztWMOVhB4gncFFKdS9+AYvWxEMDJHOE19B956TQTNfxS4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tNRtw0tX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tNRtw0tX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3321C4CEE2;
	Wed, 19 Feb 2025 01:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926830;
	bh=y2ABjItUbd32HXtlfAm1Ea3pYTAv4cHjPK7axHPk1jU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tNRtw0tXp2d5bDsBcKqYxmSSWRci3LbNLGBB3pTFvC4kVp/X7k9NZGhLolxJaz56E
	 aLHd4FnVWVttapT+XLOJgtAFwUzpyOQjbR1aIuS283UVruJqkePY1Y8i4S7UgT4xct
	 8dIISlIhl1pLzdM5FaiyyvFVREL5RNS26GJywBIjIFBQil6wPXnGfDLCR12WC/1YzE
	 S1HpP5eSsbJ9wxC05mZTNqr6Fr1Nu56Wx7q1+F2wA0UZXzsu/XJzTgUR70x7sVaIxu
	 pd6oP0CaLK6R4Eg3vMHZyUHWh4SX3PdHAFdry0dXRXIqpFspIMMghcRyR8uArem81V
	 gXdxdGLoh3Hbw==
Date: Tue, 18 Feb 2025 17:00:29 -0800
Subject: [PATCH 11/15] xfs/449: update test to know about xfs_db -R
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992589382.4079457.3244666731390058048.stgit@frogsfrogsfrogs>
In-Reply-To: <173992589108.4079457.2534756062525120761.stgit@frogsfrogsfrogs>
References: <173992589108.4079457.2534756062525120761.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The realtime groups feature added a -R flag to xfs_db so that users can
pass in the realtime device.  Since we've now modified the
_scratch_xfs_db to use this facility, we can update the test to do exact
comparisons of the xfs_db info command against the mkfs output.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/449 |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/449 b/tests/xfs/449
index 3d528e03a483fb..a739df50e319c5 100755
--- a/tests/xfs/449
+++ b/tests/xfs/449
@@ -30,7 +30,11 @@ echo DB >> $seqres.full
 cat $tmp.dbinfo >> $seqres.full
 # xfs_db doesn't take a rtdev argument, so it reports "realtime=external".
 # mkfs does, so make a quick substitution
-diff -u <(cat $tmp.mkfs | sed -e 's/realtime =\/.*extsz=/realtime =external               extsz=/g') $tmp.dbinfo
+if $XFS_DB_PROG --help 2>&1 | grep -q -- '-R rtdev'; then
+	diff -u $tmp.mkfs $tmp.dbinfo
+else
+	diff -u <(cat $tmp.mkfs | sed -e 's/realtime =\/.*extsz=/realtime =external               extsz=/g') $tmp.dbinfo
+fi
 
 _scratch_mount
 

