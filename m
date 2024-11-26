Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602CD79DC;
	Tue, 26 Nov 2024 01:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732584095; cv=none; b=K6WZKnJKaoQViAr9MRXZtQUAgJrIDDOmHHChAGnhtzS9YGYxpm5QMKNIa7Ne68/Z4GXMvXma9XHt4A0Ux9RimKtWJdY7gl041XppdwpeNdy+FFTlSFu7lJOCDYTp4H0IieQXM/sFr6F/OZZ+zDtgING4PNN3IYGpVrPcx37KxUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732584095; c=relaxed/simple;
	bh=lUHYxvGvDclHRINE9ZA+ym8oqLf7fyvuq6Cr21SiTbw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BoTxECJSCBNeHC4J2CAf11QEhvgaH4jMzAY8IxznVT3QE85GxqVseV3HlOwgewHtBkl6tRWqf2s5sFj7NAYgZBvHKNGPg8fhVDz4VWlqKl5jSQJmoZDF1igMZFiEjfdVCbVfLdH73tqCOJlfAHvOOorW9wXg9ZZACcPEuRagkRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F0C/gzvH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F0C/gzvH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AE92C4CECE;
	Tue, 26 Nov 2024 01:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732584095;
	bh=lUHYxvGvDclHRINE9ZA+ym8oqLf7fyvuq6Cr21SiTbw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=F0C/gzvHzfETkMv0mdFiyesvXVGOf81COkgkPPk49Bia5BzOJU9wUHKdjrL+v9Pvr
	 zBi1Uqx+wfghqUNY9Iz6j9evOHPOxcDd6fbGB5rlq8pp5/mU51dBtzI7TLF7pyhRDO
	 LbYH3/wcMAYKZaVWqPLDQ3k+cl5u4ecze9YENbXkTpUhD++x4KjLwaSDOQIVGHsm5C
	 TUV71eKQIYg0ULgrYk8lvQlZ2zchLY7WgPzaifw/qqbssrMLk78cN8bFlKHi3mbyPy
	 o8skKWZgfuIR0mqSDu8cNxAqcbqlFrLf/yvAGTvY5uSoLlJdFnK77Vgit9CQoyXnkt
	 kZudMQLVibsGw==
Date: Mon, 25 Nov 2024 17:21:34 -0800
Subject: [PATCH 04/16] xfs/508: fix test for 64k blocksize
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173258395132.4031902.17749497021307955659.stgit@frogsfrogsfrogs>
In-Reply-To: <173258395050.4031902.8257740212723106524.stgit@frogsfrogsfrogs>
References: <173258395050.4031902.8257740212723106524.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

It turns out that icreate transactions will try to reserve quite a bit
of space on a 64k fsblock filesystem -- enough to handle the worst case
parent directory expansion, a new inode chunk, and these days a parent
pointer as well.  This can work out to quite a bit of space:

fsblock		reservation
1k		172K
4k		368K
16k		1136K
64k		3650K

Unfortunately, this test sets its block quota limits at 1-2MB, so we
can't even create a child file.  Bump the limits up by 10x so that this
test will pass even if there's more metadata size creep in the future.

Fixes: f769a923f576df ("xfs: project quota ineritance flag test")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/508 |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/tests/xfs/508 b/tests/xfs/508
index ee1a0371db7d6d..1bd13e98c9f641 100755
--- a/tests/xfs/508
+++ b/tests/xfs/508
@@ -44,7 +44,7 @@ do_quota_nospc()
 	local exp=$2
 
 	echo "Write $file, expect $exp:" | _filter_scratch
-	$XFS_IO_PROG -t -f -c "pwrite 0 5m" $file 2>&1 >/dev/null | \
+	$XFS_IO_PROG -t -f -c "pwrite 0 50m" $file 2>&1 >/dev/null | \
 		_filter_xfs_io_error
 	rm -f $file
 }
@@ -56,7 +56,7 @@ _require_prjquota $SCRATCH_DEV
 
 mkdir $SCRATCH_MNT/dir
 $QUOTA_CMD -x -c 'project -s test' $SCRATCH_MNT >>$seqres.full 2>&1
-$QUOTA_CMD -x -c 'limit -p bsoft=1m bhard=2m test' $SCRATCH_MNT
+$QUOTA_CMD -x -c 'limit -p bsoft=10m bhard=20m test' $SCRATCH_MNT
 
 # test the Project inheritance bit is a directory only flag, and it's set on
 # directory by default. Expect no complain about "project inheritance flag is

