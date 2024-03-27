Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 332CA21101;
	Wed, 27 Mar 2024 02:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711507411; cv=none; b=K4bnMdp6j0lru7YnG0qMv0zKYD8Nm9pOddQOzy4cGi1h2B4KXoQsPX8GRgSGtcFQ++iDffB2N/TcxUxE7kW40/9boWfTb/pzFd+VAWiWOiVvdFjPb3rRV/GV8hZSKiTB0rMgetagXHWPkEU92rPIpRKZknwM2vNJa5oCdOpordA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711507411; c=relaxed/simple;
	bh=zh+hQx0zNK6lt/xfZu/rv0SxyEJHegiH5ipJTeXXtb4=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gx9ZaKySN8hcRgu+KtPPkmF+LgSmsiun11OtChPxYBDd7n0m9GghFvRxNe8sUlrF63JTrnkl+V3w6Plf3A5uKwJuFRMP+6ZVVnm5BLAg6YvfmTO+rZ6oo9EK0t9NpY2sQRHBXqXNTBuIJfBTmOVr05Mt/P7I7wLW2tcmMpaKXMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EcEWhOQe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EcEWhOQe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C56C433C7;
	Wed, 27 Mar 2024 02:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711507410;
	bh=zh+hQx0zNK6lt/xfZu/rv0SxyEJHegiH5ipJTeXXtb4=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=EcEWhOQe0YfgcLh3jwJ5GmOtUcFTMX/2AaN3PFPyyyOZJFspBBTnDNg89fpnI430S
	 GWA+IaU9y7X3y1M8lXRi8s0QuZqsvXRxKte6okqOlwzUa1IpTh1QMzcLgsR4WtwS2Q
	 dGkEbeyGZrF109/O2ihfOHPTI9GctZTW0PByBpVAjtESj4cXvRnsEnv8Q5JCUpIGfS
	 AjMSCqYslMeJQQFhKDqAMtLsE94KGQvE/lg5ZzyEL007ccgEuDCVWcsd+5UFDOqiwV
	 3q8/2KAA85rQvSXKU10BRmdEQgik+EPCXLVaijmRGg4JQTrYHWPuiOq21sbc+PfWjh
	 NAtyNVFDudbNQ==
Subject: [PATCH 2/4] xfs/176: fix stupid failure
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, guan@eryu.me
Date: Tue, 26 Mar 2024 19:43:30 -0700
Message-ID: <171150741023.3286541.16393057569793003518.stgit@frogsfrogsfrogs>
In-Reply-To: <171150739778.3286541.16038231600708193472.stgit@frogsfrogsfrogs>
References: <171150739778.3286541.16038231600708193472.stgit@frogsfrogsfrogs>
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

Create the $SCRATCH_MNT/urk directory before we fill the filesystem so
that its creation won't fail and result in find spraying ENOENT errors
all over the golden output.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/176 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/xfs/176 b/tests/xfs/176
index 5231b888ba..49f7492c03 100755
--- a/tests/xfs/176
+++ b/tests/xfs/176
@@ -51,7 +51,7 @@ _scratch_mount
 _xfs_force_bdev data $SCRATCH_MNT
 old_dblocks=$($XFS_IO_PROG -c 'statfs' $SCRATCH_MNT | grep geom.datablocks)
 
-mkdir $SCRATCH_MNT/save/
+mkdir $SCRATCH_MNT/save/ $SCRATCH_MNT/urk/
 sino=$(stat -c '%i' $SCRATCH_MNT/save)
 
 _consume_freesp()

