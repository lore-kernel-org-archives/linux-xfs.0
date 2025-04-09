Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6B325E476;
	Wed,  9 Apr 2025 15:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744211735; cv=none; b=I7fT8UqEecDPEXbYp2nwN6v1xFwnVP4zw5mHOqxNNbuQVtPf/hjZ3uRfUpAB734WRXypdIcavnFiL1lC5SA6CRQYVfqWfnAeGGB8xtu8TDfBve0Si/jzTRXzAFGcPBCCtc83RaSU1F7IULjihpfBvAbPcAEpZuPnI8q2B+2/veU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744211735; c=relaxed/simple;
	bh=CtP4nZg2z5mXoM0MEtCEqqVxn3MlVqgUSmDbEqb0ke8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=O4oiQOBhy3bACsWx98GUOMQ0piKZhRJHJM3yDPzMW8AA7SE4bhmmHPZMFSSkyCJWOxlCZc/oryedJrG0Gn4eRu92sEvL5wiNYZ3S4QStm2Ed8PPsCTLFoU2HtJijcfwFAMsNDX/hFLGPYO1zTZoq1uQyQt9J2fcQSczuqsZWF2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m1PQpqpP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m1PQpqpP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4D0C4CEE2;
	Wed,  9 Apr 2025 15:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744211735;
	bh=CtP4nZg2z5mXoM0MEtCEqqVxn3MlVqgUSmDbEqb0ke8=;
	h=Date:From:To:Cc:Subject:From;
	b=m1PQpqpPG2NFO3ndcsVTdVjVqj/AZQRpbxFWSZT0ARKjkJvguC1hUBQVrW2+KUVwD
	 fh/znBfNqOH0q5NhQXGqDnZVda3C5jyXSMv+W2aTVt2lIFE5MMwN6zhdosI2yGtUyn
	 CsU6Afn9bjfmpJ5Xp63H7JYZk/gMhS0HjGhuuwyHpKVYU1cLzA3Ut6oSBijDnEnn0K
	 Mq51EqTql9hFL2yMOpDxcDmASx7iLSRHppNFyg8tY3Be2Oe6ZykrorEZvhbjWR2kSv
	 VRZCLMkqdVC5JA0dz8OygDFTdWn3/jEJMGiT9u3VrqxCMsa2TI4ohSXcebzEDaUshV
	 b6mkrA3bNSMCw==
Date: Wed, 9 Apr 2025 08:15:34 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs/792: skip test if rextsize isn't congruent with
 operation length
Message-ID: <20250409151534.GI6274@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

This test writes 64k chunks and encodes the file content hash in the
golden output.  Don't run it if the file allocation unit isn't congruent
with 64k.  Fixes extsize=28k configurations.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/792 |    1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/xfs/792 b/tests/xfs/792
index 6c7b2db1135625..b1436a113a152a 100755
--- a/tests/xfs/792
+++ b/tests/xfs/792
@@ -30,6 +30,7 @@ _require_xfs_io_error_injection "bmap_finish_one"
 
 _scratch_mkfs >> $seqres.full
 _scratch_mount
+_require_congruent_file_oplen $SCRATCH_MNT 65536
 
 # Create original file
 _pwrite_byte 0x58 0 1m $SCRATCH_MNT/a >> $seqres.full
