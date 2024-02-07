Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7FBFBE9;
	Wed,  7 Feb 2024 02:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707272354; cv=none; b=qJ80vSIdT5wi4JQfbWy+O+hhypvYwHFzf7sa0StAdr4pxWLK+i7+n87IHMPHTkiYvvAKGgGkixGTCUik2WcOawX9L52VIIp5QFp9Dw4aXjG98wCJqRH9l+Nh7Mp2BA4MZAER76QAglkrihSPImdf7c8tKKfvFvS0R87NNoeOYtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707272354; c=relaxed/simple;
	bh=hmfvZMG8kVPbA5v7sUSUoQ3wTAvS9cmUq87RVw+eUJA=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WI/XccGV/JfXGpDgLw35wPVHFh3cdxEs38CF0EZA9Jjwrs6LAmQRdf5IYVyO99WWR0gmOM9U4shYRxFp0kjPnwrfr0pHO6HNn7gygCJzHh9rS+kVMXRDkFHSN13zXLQIwZeFSaNC6cKIdVuc0h/dCNLrW1rTRVHbT4rnfkJR8lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iP5gq5pP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iP5gq5pP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FB6FC433C7;
	Wed,  7 Feb 2024 02:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707272354;
	bh=hmfvZMG8kVPbA5v7sUSUoQ3wTAvS9cmUq87RVw+eUJA=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=iP5gq5pPlwFSbkf8XKUb3LmK18jw0us1IWuc3G3qJIw5y1UbFd4h7IDuCAkVWbMRi
	 kOcwHhGcTuGgmFRSRMAibQCZYD2xE30Kk1oggXQg25Kw/7WkX52og4zFdOasXSBCgv
	 aNyD8PigB/auy0GhPe8lK2BHbKXqsQ+RD1yUHaguDSINuofoq9QiV8IwU5BuZVADlb
	 9d8LcmSSJaiCRHdHMAUN3ENCaeKurKGgXleyjq97UATaYLCEkCp7hSQuWFAIkBYch2
	 jTNfPiiBLAHRx1k5RrAvUL8A7mEdwubMIs9oqK3s+oY+YrxpnDI7ROVHfXl1RJg0ZE
	 9eAprhOo6DOaw==
Subject: [PATCH 07/10] xfs/503: test metadump obfuscation, not progressbars
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
 linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date: Tue, 06 Feb 2024 18:19:13 -0800
Message-ID: <170727235379.3726171.14857033108645144507.stgit@frogsfrogsfrogs>
In-Reply-To: <170727231361.3726171.14834727104549554832.stgit@frogsfrogsfrogs>
References: <170727231361.3726171.14834727104549554832.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Zorro Lang <zlang@kernel.org>
---
 tests/xfs/503     |   10 +++++-----
 tests/xfs/503.out |    4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)


diff --git a/tests/xfs/503 b/tests/xfs/503
index 854cc74bbe..07d243bc06 100755
--- a/tests/xfs/503
+++ b/tests/xfs/503
@@ -47,16 +47,16 @@ metadump_file=$testdir/scratch.md
 copy_file=$testdir/copy.img
 
 echo "metadump and mdrestore"
-_xfs_verify_metadumps '-a -o'
+_xfs_verify_metadumps
 
 echo "metadump a and mdrestore"
 _xfs_verify_metadumps '-a'
 
-echo "metadump g and mdrestore"
-_xfs_verify_metadumps '-g' >> $seqres.full
+echo "metadump o and mdrestore"
+_xfs_verify_metadumps '-o'
 
-echo "metadump ag and mdrestore"
-_xfs_verify_metadumps '-a -g' >> $seqres.full
+echo "metadump ao and mdrestore"
+_xfs_verify_metadumps '-a -o'
 
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

