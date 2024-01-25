Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41469130E25;
	Thu, 25 Jan 2024 19:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706209549; cv=none; b=NjI56CzrrqrNlGilwuHfGRQ2kdhGkGaBikapEKQ572GcfK6VOxcYbC5WcRFWkh5Xa7IBy5Ogodkczq3iuC5hP9w3MNih9ozwwAI3QMZ8Mvkn6FyjWVpcEfd2A/Y+SZ6iofuT4NoBUHzvi5Qfik2d53qKHvBG8nY2Xc+ObYpLWWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706209549; c=relaxed/simple;
	bh=XrdHFp1d6U1J9PVsu0/jiWqxSkzmBrGOy8c/7VH3fjM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pMpXO1DJpUG3JzKJ5Z1cZcyQ1s+qgQUZ6SXY5zdXR3CKjo3QW4rCTZ7fhXQdcnlmIq1mUzh21v8MEmet0ujWVIixPUm48ApheugQ/o5YQzoISbyImDoYP8a9JXs5LGHUbbhq4AqjHRQF+tDAApzev0x1cCAWcczyMjrHdaaWaWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HdnK9FcV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HdnK9FcV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 943BBC433C7;
	Thu, 25 Jan 2024 19:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706209548;
	bh=XrdHFp1d6U1J9PVsu0/jiWqxSkzmBrGOy8c/7VH3fjM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HdnK9FcVstq3UvKd6p8+5VJrG7vJsvTyIx7qUldBWDjKTsWN99wrmYNvB5ol+nSCO
	 rIutk7ljGb88RCkLjZgbbo2izZ46cmOShgo/L141LX//umHugxgvsVSDcOlx4bsD1C
	 /5iZ9XBgogLKVSgtHY4XM6Xj71qQbfms4foorx7D3UT6getxz/lWKHQA53tdtmXVfc
	 Twk2Qxb3va1MnoCV9JiEkSiVjCgSJTC/otOoMIaNsXNOH5KLPrq7zMWs8KKfYxM/we
	 IJgnb8WC1Mkzfvd5PLARkcBpmNuokzcYYkmpwa72lWLKBz6O0YJTbn1Z5cq+Ni3Zkp
	 2TF7aD6YccwQw==
Date: Thu, 25 Jan 2024 11:05:48 -0800
Subject: [PATCH 07/10] xfs/503: test metadump obfuscation, not progressbars
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170620924464.3283496.16784489077157560763.stgit@frogsfrogsfrogs>
In-Reply-To: <170620924356.3283496.1996184171093691313.stgit@frogsfrogsfrogs>
References: <170620924356.3283496.1996184171093691313.stgit@frogsfrogsfrogs>
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

The -g switch to xfs_metadump turns on progress reporting, but nothing
in this test actually checks that it works.

The -o switch turns off obfuscation, which is much more critical to
support teams.

Change this test to check -o and -ao instead of -g or -ag.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/503     |   10 +++++-----
 tests/xfs/503.out |    4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)


diff --git a/tests/xfs/503 b/tests/xfs/503
index ff6b344a9c..79bbbdd26d 100755
--- a/tests/xfs/503
+++ b/tests/xfs/503
@@ -47,16 +47,16 @@ metadump_file=$testdir/scratch.md
 copy_file=$testdir/copy.img
 
 echo "metadump and mdrestore"
-_verify_metadumps '-a -o'
+_verify_metadumps
 
 echo "metadump a and mdrestore"
 _verify_metadumps '-a'
 
-echo "metadump g and mdrestore"
-_verify_metadumps '-g' >> $seqres.full
+echo "metadump o and mdrestore"
+_verify_metadumps '-o'
 
-echo "metadump ag and mdrestore"
-_verify_metadumps '-a -g' >> $seqres.full
+echo "metadump ao and mdrestore"
+_verify_metadumps '-a -o'
 
 echo copy
 $XFS_COPY_PROG $SCRATCH_DEV $copy_file >> $seqres.full
diff --git a/tests/xfs/503.out b/tests/xfs/503.out
index 496f2516e4..5e7488456d 100644
--- a/tests/xfs/503.out
+++ b/tests/xfs/503.out
@@ -2,7 +2,7 @@ QA output created by 503
 Format and populate
 metadump and mdrestore
 metadump a and mdrestore
-metadump g and mdrestore
-metadump ag and mdrestore
+metadump o and mdrestore
+metadump ao and mdrestore
 copy
 recopy

