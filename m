Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F119D1F3FC0;
	Thu, 16 Jan 2025 23:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737070460; cv=none; b=eJDBO/+d3P3fn/iQSLmAi2/4+aDhhW3q7WA1ZwRmvBGezr9+9susqp5V7mJ3K2CNRS1JhwcZs/nlim+eqCWHEoETJ1YKmGwnFmTMM0kg+X0bt4uYTk8F31Q3i8xJmGySi7fSqSCtd5hU1nfOfmuWY35l/2/qM9S5hoU8cP7CInY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737070460; c=relaxed/simple;
	bh=3QbeNl/V+p/fnJ42oucvesTX9fQDE5vnBewFl9gkrBg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CMjpkfOnNH9OeZEYcHIGrM1YCzvccpzrbzvKgBXJLwpo//8IXalC2jesxeCPXfNBwoBv1FIcwAgM0uNoN+n0UCfl1PiuCLs7YMyFg3p3BU3hoJ7sFcOmfkEM8cgdDWupu2w7qAGA8rD2TfTkVuSXPlnqH/g4w4GaXQsTYn5YTno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sJBbv1a3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sJBbv1a3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76D17C4CED6;
	Thu, 16 Jan 2025 23:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737070458;
	bh=3QbeNl/V+p/fnJ42oucvesTX9fQDE5vnBewFl9gkrBg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sJBbv1a3KUUJC//R3raJaS2G4P3+EU/30RuD0JJ4K0CUZFeOf+TT16sZDdNKOASxI
	 /yM0CkNsWq9y5tKCYi05CMAz9gbgvXJdfYuDo7rLz3cM7sI+mgr53LygVxnYz7BLfp
	 RhDE851nyfjA/xCpad9Naf8sDHY7YuyYvmTvzp21DRQIXg5cbqa/KNGl7h5COSPXnh
	 iYcxppZ/ApkwdlPnAfHlLAM0Ko2chTGq8i/Yb6mSASyC2NarWldLCH1jzNgnn/vE+e
	 cBYf/ompPUHpKHT+HRfPcpgezFz1rIMJLtnZ1kjcoomRz3IpX5VNZ+wqco/b/J9P21
	 wxGdoT2JFComA==
Date: Thu, 16 Jan 2025 15:34:17 -0800
Subject: [PATCH 09/11] xfs/122: disable this test for any codebase that knows
 about metadir
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706975304.1928284.3391584079916474820.stgit@frogsfrogsfrogs>
In-Reply-To: <173706975151.1928284.10657631623674241763.stgit@frogsfrogsfrogs>
References: <173706975151.1928284.10657631623674241763.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

All of the ondisk structure size checks from this test were copied to
the build time checks in xfs_ondisk.h.  This means that the kernel and
xfsprogs build processes check the structure sizes, which means that
fstests no longer needs to do that.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/122 |    6 ++++++
 1 file changed, 6 insertions(+)


diff --git a/tests/xfs/122 b/tests/xfs/122
index a968948841de14..e96ef2fe93042b 100755
--- a/tests/xfs/122
+++ b/tests/xfs/122
@@ -15,6 +15,12 @@ _begin_fstest other auto quick clone realtime
 
 _require_command "$INDENT_PROG" indent
 
+# We ported all the ondisk size checks to xfs_ondisk.h in both the kernel and
+# xfsprogs libxfs when we added the metadir feature.  If mkfs supports metadir
+# then we don't have to run this test anymore.
+$MKFS_XFS_PROG --help 2>&1 | grep -q metadir && \
+	_notrun "struct size checks moved to libxfs/xfs_ondisk.h"
+
 # Starting in Linux 6.1, the EFI log formats were adjusted away from using
 # single-element arrays as flex arrays.
 _wants_kernel_commit 03a7485cd701 \

