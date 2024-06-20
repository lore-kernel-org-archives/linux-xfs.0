Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D7A58AA7;
	Thu, 20 Jun 2024 20:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718916922; cv=none; b=BHO7pj41If5AyicG3xyHuznzbit+phVjlB+uYntJ1ThjSrIbu8NEN2hiES8DVmOE+PrVe33TLvm+p7/hVE87zCCUfxw39p5s+gtzkYn4jxMECcLdMYXU3vTdfEamor8AC6/K2iM4SbY/lQPqNpjlKjkx3oLVT2V+fwgxoRO9tRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718916922; c=relaxed/simple;
	bh=NuDg+uNB45SMQOjJb0Ggs+biP0t1Q403Zcw4v3eRa3E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V9yITzIyrHK2SyPruwjKBUx8V7bjH8o+lzNXIoWVEBee/38tPrXVXLJmvPAXdBhBhDZoYnR9dwA42igQhXF/h1coTyG5sajsOag0lBVlLrQEe/+OoMpEXYGNQf2hCFEUxNtHUdRIJ/ZS0PXpmpM5lEHmwtulxL6f/6Gl4Ny6/SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lT8JBc5R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lT8JBc5R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C44C2BD10;
	Thu, 20 Jun 2024 20:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718916922;
	bh=NuDg+uNB45SMQOjJb0Ggs+biP0t1Q403Zcw4v3eRa3E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lT8JBc5R/bH+X1rK9jerZrWs56BPQDANGKo26QMatSbqHREFjnVGGlQBDm8vaZl/Z
	 OX8BwkgflAkuv65yB+Ja/FRpdnIgQrzzIf4bFnzFXY0IoKwJZgFEFafnQ1xUbUviUD
	 ohXM1cyEPgYSzBo13u+EIBSHUkAP8e6aJ3ASPWROKSvVE0zBRIOHljb990ILv848Hb
	 0lZRkDlPES6W00i5gK2YWqkJSP93qaJL2POD24MHbMbGck+ckqhK2M7nG7pq6F5Yx+
	 BbSbpKyzZGRXul5aH7RYOrb36PVb444nybQrOJ9vUQLAZfavjMTQQ1vETAV31JcN1r
	 qFcaulGEcqiEw==
Date: Thu, 20 Jun 2024 13:55:21 -0700
Subject: [PATCH 05/11] generic/717: remove obsolete check
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <171891669189.3034840.13099936847804900490.stgit@frogsfrogsfrogs>
In-Reply-To: <171891669099.3034840.18163174628307465231.stgit@frogsfrogsfrogs>
References: <171891669099.3034840.18163174628307465231.stgit@frogsfrogsfrogs>
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

The final version of the EXCHANGERANGE ioctl has dropped the flag that
enforced that the two files being operated upon were exactly the same
length as was specified in the ioctl parameters.  Remove this check
since it's now defunct.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 tests/generic/717     |    5 -----
 tests/generic/717.out |    2 --
 2 files changed, 7 deletions(-)


diff --git a/tests/generic/717 b/tests/generic/717
index ffabe2eaa1..7bc917e555 100755
--- a/tests/generic/717
+++ b/tests/generic/717
@@ -77,11 +77,6 @@ $XFS_IO_PROG -c "exchangerange -d 0 -s $(( blksz * nrblks )) -l 37 $dir/b" $dir/
 echo file2 unaligned EOF to file1 nowhere near EOF
 $XFS_IO_PROG -c "exchangerange -s 0 -d $(( blksz * nrblks )) -l 37 $dir/b" $dir/a
 
-echo Files of unequal length
-_pwrite_byte 0x58 $((blksz * nrblks)) $((blksz * 2)) $dir/a >> $seqres.full
-_pwrite_byte 0x59 $((blksz * nrblks)) $blksz $dir/b >> $seqres.full
-$XFS_IO_PROG -c "exchangerange $dir/b" $dir/a
-
 echo Files on different filesystems
 _pwrite_byte 0x58 0 $((blksz * nrblks)) $SCRATCH_MNT/c >> $seqres.full
 $XFS_IO_PROG -c "exchangerange $SCRATCH_MNT/c" $dir/a
diff --git a/tests/generic/717.out b/tests/generic/717.out
index 85137bf412..e2c630d6d9 100644
--- a/tests/generic/717.out
+++ b/tests/generic/717.out
@@ -23,8 +23,6 @@ file1 unaligned EOF to file2 nowhere near EOF
 exchangerange: Invalid argument
 file2 unaligned EOF to file1 nowhere near EOF
 exchangerange: Invalid argument
-Files of unequal length
-exchangerange: Bad address
 Files on different filesystems
 exchangerange: Invalid cross-device link
 Files on different mounts

