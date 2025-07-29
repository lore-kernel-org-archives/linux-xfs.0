Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2821F956;
	Tue, 29 Jul 2025 20:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753819806; cv=none; b=PDmaeMiLXPeHUdAgCVhQSAEzM0zhwrfMhpDEkTb9yzxO5I3MwoK4q9U+0bNuKMv0bhezZ5+RToINLi7JFbdta0hWMtLFg3PzRdstBoir25Zv486bcMjrMJh2rF5qwN+Y+07riLGdZl/m2YsazbCBnTNR9a6069aKBtgB3/sRY58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753819806; c=relaxed/simple;
	bh=/1FzX0dBfAi/RWYdYBLB5YlRM0sEY73pcpIxW1Js3dA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c9jSa8+0yw4PjXR5F4QURJnrn1rPr/oSWA5t9erAPR/8Gz5jrgu9lHLa+5PgRhCeQy2IGURpr8L+LkypB3aGzAFCxO7qc14BjHaHuapCr8q2Ey0TjbptLa6GFie6RbIPBMmnMaw3bzeF85LuVIhkO13oNb+T4DEFHbWxg331XnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W1Oc8XiV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W1Oc8XiV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85F4BC4CEEF;
	Tue, 29 Jul 2025 20:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753819804;
	bh=/1FzX0dBfAi/RWYdYBLB5YlRM0sEY73pcpIxW1Js3dA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=W1Oc8XiVgEsY6yLfI/Z0fIRE6xsysqUc6wMDlzSSthlkJD/bujACqtK4d6arFql6L
	 KgNbnrQsScjr7k/dvpwfA4C6AiaeFxB9ERVdKFCvnF93DzdMjGrM44j8wpn21jVX3Y
	 3OmvLgPuQPtuEGuNgKy9oZz8eRpU61BX0uDz81QtDOca7xFkz/lpE134Kt3HozDBjr
	 yCeFeIY3eAIyI49j38KvUl/Zc9/rKm85Q1NfRooxYYs0XQUOjbM95l1K4ez4DvC2mh
	 kpMQ0XCM8zVRDB5MJ6U4DAK0hXrS7TmyvAtCFYvgbnmyhI/x4aWRKfw7wf+jFnMnDL
	 G99WRHUrnE6yg==
Date: Tue, 29 Jul 2025 13:10:04 -0700
Subject: [PATCH 7/7] common: fix _require_xfs_io_command pwrite -A for various
 blocksizes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <175381958029.3020742.354788781592227856.stgit@frogsfrogsfrogs>
In-Reply-To: <175381957865.3020742.6707679007956321815.stgit@frogsfrogsfrogs>
References: <175381957865.3020742.6707679007956321815.stgit@frogsfrogsfrogs>
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
---
 common/rc |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)


diff --git a/common/rc b/common/rc
index 96578d152dafb9..177e7748f4bb89 100644
--- a/common/rc
+++ b/common/rc
@@ -3027,16 +3027,24 @@ _require_xfs_io_command()
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

