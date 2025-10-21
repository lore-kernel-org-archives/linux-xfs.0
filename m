Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 897D334D93A;
	Tue, 21 Oct 2025 18:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761072078; cv=none; b=Xsh+qeva+hS9FnfoH5XRQ+cItMPa/trGYo/gPLj69x/A1GpdSFWViJRacbtvZ1VJBvbCAEWQcBTdVvJguPVbpZz8lmEjzF/NJjQyZadV55OY0AiPudDnPmVQ99wjy+oLp0E+QBoO7O/sdAE19lB3R7J5bjXiLTH3s3XFRknqRaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761072078; c=relaxed/simple;
	bh=2Aq3lKpbjeaVvWBYJsLGtU4TewHPqNvSyVr1EC6Ax5U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ai6arag+xHGZhdnB7dZwMF1x6tNhU1RC72AZAUfvMYFHtxTuBiagq8qmJUr6DNlK6fG8WMIqNy9iTl7VH2cRqTK/NfbSqdmrLcCgCI00SDqQcrsYYKulhkJMAIWxye5QpjDhvapGYScyDLbL+z5SpZNaRLIdDAu2X2w9BZnmBRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X1/IGviW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X1/IGviW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 114BCC4CEF7;
	Tue, 21 Oct 2025 18:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761072078;
	bh=2Aq3lKpbjeaVvWBYJsLGtU4TewHPqNvSyVr1EC6Ax5U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=X1/IGviWwMrcINAes5/x4SzomG9uLRt7h92eTEte9Xes8chjcEbPhHQl6ofOGZ4x+
	 hwY5WMSy5hHgZ3Aj1IGBvfmAWzQkSAOb7Zv3ruODdo+TbtGCV7K7q52cCaybXGq/ZN
	 6UoxcFz/MQmQJ5ngfY9gJgEapKqF6fTBy+THgTCInajA+8+KUBnhp4NUN6jui08VRi
	 HAtHfi+Bp+J4Xr+OEMzZKer010ekBxaqOEmXt0uPQitMgUoXces+ApSQpljw+ZDDWD
	 rg0uP+H4FLzG+H1p7EfK+oKiTXRJcFoNHPyANr/rVquIRFvvQ/lQoKuLrYJzedT7sP
	 c3Pw39gulr1QQ==
Date: Tue, 21 Oct 2025 11:41:17 -0700
Subject: [PATCH 08/11] common: fix _require_xfs_io_command pwrite -A for
 various blocksizes
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, hch@lst.de, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <176107188814.4163693.2206784378117778323.stgit@frogsfrogsfrogs>
In-Reply-To: <176107188615.4163693.708102333699699249.stgit@frogsfrogsfrogs>
References: <176107188615.4163693.708102333699699249.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

In this predicate, we should test an atomic write of the minimum
supported size, not just 4k.  This fixes a problem where none of the
atomic write tests actually run on a 32k-fsblock xfs because you can't
do a sub-fsblock atomic write.

Cc: <fstests@vger.kernel.org> # v2025.04.13
Fixes: d90ee3b6496346 ("generic: add a test for atomic writes")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 common/rc |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)


diff --git a/common/rc b/common/rc
index 2e06e375c2cff2..462f433197a3c2 100644
--- a/common/rc
+++ b/common/rc
@@ -3030,16 +3030,24 @@ _require_xfs_io_command()
 	"pwrite")
 		# -N (RWF_NOWAIT) only works with direct vectored I/O writes
 		local pwrite_opts=" "
+		local write_size="4k"
 		if [ "$param" == "-N" ]; then
 			opts+=" -d"
-			pwrite_opts+="-V 1 -b 4k"
+			pwrite_opts+="-V 1 -b $write_size"
 		fi
 		if [ "$param" == "-A" ]; then
 			opts+=" -d"
-			pwrite_opts+="-V 1 -b 4k"
+			# try to write the minimum supported atomic write size
+			write_size="$($XFS_IO_PROG -f -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile 2>/dev/null | \
+				grep atomic_write_unit_min | \
+				grep -o '[0-9]\+')"
+			if [ -z "$write_size" ] || [ "$write_size" = "0" ]; then
+				write_size="0 --not-supported"
+			fi
+			pwrite_opts+="-V 1 -b $write_size"
 		fi
 		testio=`$XFS_IO_PROG -f $opts -c \
-		        "pwrite $pwrite_opts $param 0 4k" $testfile 2>&1`
+		        "pwrite $pwrite_opts $param 0 $write_size" $testfile 2>&1`
 		param_checked="$pwrite_opts $param"
 		;;
 	"scrub"|"repair")

