Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8281846B8;
	Wed, 19 Feb 2025 00:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926548; cv=none; b=Fi4sITOa8wI3tAlUnYIIZyB9qBRXlogFf16+Y4ZCC8MM74gC5E1h2TCVrnKnUF0UAIebmWiP5ex0L519fpkSZVsPJ/75fZnCiXNZJwFwWA0+r2AHnhy6umx7gHTekEWoBVIKRoLNKavIc3DydeJCiMJLhiCe5krMCcTzuvCmG0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926548; c=relaxed/simple;
	bh=3QbeNl/V+p/fnJ42oucvesTX9fQDE5vnBewFl9gkrBg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qH1Mt1InIJSOmICNUJ3E+bc0cpa0C9qyedpTL6K4gEKLlVAdkiW3qg9uT4wd3xo6Gz8OUhSIOhRX5chvzO36xrfdZO8DYytFJYGj/8MFyZdWgZOs4f19Qdxjo58LHh4/ocHwWVu/FTWCauFM3rujmZR6tofxV+RVqaqkR42mjlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q6hPZN5y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q6hPZN5y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 587D8C4CEE2;
	Wed, 19 Feb 2025 00:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926548;
	bh=3QbeNl/V+p/fnJ42oucvesTX9fQDE5vnBewFl9gkrBg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Q6hPZN5yLBybfmbOKIQmdXdcPu1aaVObz+w/+BW6mUqskMOp490GwhNG2w8jliibX
	 Itjnqt/nyBlAfUqjLHnAGcvyeyHU4txnO//pL1i3wwoY8+5GkGSNkVI6qZr/PwTtAN
	 rgXWLQFYfPI4nMRC6FEdkB/9g6wN1orj5AW1jeYKF/gXNkak9gfJwqPrQKC645HyeC
	 zercdjEAfxkh5claluHBAeRF8tLrhxRj1FNlNu/6PntGHMeYtBjGv9lvfXBC4maBMF
	 gnR6gzXCRuFYjZuiJLV1dGMxrJ/95PK3KmYvzY1cZYArLS58pF0okAGu+IbyHrEfrP
	 ccSv+Uz7kHKDQ==
Date: Tue, 18 Feb 2025 16:55:47 -0800
Subject: [PATCH 09/12] xfs/122: disable this test for any codebase that knows
 about metadir
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992588226.4078751.3774851302421682128.stgit@frogsfrogsfrogs>
In-Reply-To: <173992588005.4078751.14049444240868988139.stgit@frogsfrogsfrogs>
References: <173992588005.4078751.14049444240868988139.stgit@frogsfrogsfrogs>
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

