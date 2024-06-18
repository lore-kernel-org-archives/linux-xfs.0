Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBBA4EEA5;
	Tue, 18 Jun 2024 00:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718671668; cv=none; b=AZxj8VDwxiPX/iIprgUHIK+z0Kf/o0dY0yvotHLHC6lCoQHjrUv3tLFsw/Dg9UdDUZs1JK00igCMCOZM1ZEiTlC7M3Ehr8Qg0U9dVJsAcDn6V043GSL3cm4GlGBjbRuQCjkcvWZ1hJqNtiIEVNbwR/n5zYn8Nty//gXqqOoiPZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718671668; c=relaxed/simple;
	bh=2OzCVDM1pd8yg0t/scKdigkMce1yBY1X6EplPmmVspA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F9jLwJiK8XhOcZimnhGIyHJnxRFMpK/+gwAPc9kA1nDbslgMlP+3Yn+7ApJDWAX2uSTu/oC+CAevTcl/p0UmP9h00icSmlLRa9xCUj+C++dVv64s/f23cX7+n6QD+jbFoYxTHxxhUFNc7UdCa7lEoTHGtXYp6bIGfDfYOQawD/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eMFxvL3i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eMFxvL3i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A1BC2BD10;
	Tue, 18 Jun 2024 00:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718671668;
	bh=2OzCVDM1pd8yg0t/scKdigkMce1yBY1X6EplPmmVspA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eMFxvL3iNs7iyhgHp3BOtbXEJ174kNW1clzOVGjm6KX1i9iq5OvGCHSOLwu2b2hnj
	 9vinSqgWVRdJOzqtvHoOX2Yaou9vcLfYV1inGo+Y54fz24/OJ37vZK5yYgIvk6Pdoc
	 3MipiEb52feB3PHaHE9Q9kvDkyKmj9cR4bnIdsxtGtwoWe3NKr+2BRjlRfUYCuvzyU
	 HbsRpWNaattDj52Uc5hCODnWCm2YF93JLQyapmfx4cjaelfGbHUFF4Q8Amt9eVSEug
	 uqGcHPktFwUoRiMaQpCmO3RYPeIDSgWqsgFuUX5gqGOosn55Yx7x/10yQ/KjcLY20J
	 9xfZRbkFJ/w/Q==
Date: Mon, 17 Jun 2024 17:47:48 -0700
Subject: [PATCH 04/10] generic/717: remove obsolete check
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, guan@eryu.me, linux-xfs@vger.kernel.org
Message-ID: <171867145359.793463.11533521582429286273.stgit@frogsfrogsfrogs>
In-Reply-To: <171867145284.793463.16426642605476089750.stgit@frogsfrogsfrogs>
References: <171867145284.793463.16426642605476089750.stgit@frogsfrogsfrogs>
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

The latest draft of the EXCHANGERANGE ioctl has dropped the flag that
enforced that the two files being operated upon were exactly the same
length as was specified in the ioctl parameters.  Remove this check
since it's now defunct.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
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

