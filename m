Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C73E7271839;
	Wed, 12 Feb 2025 03:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739331182; cv=none; b=MjMHW76pdJE1ctO0vMP736129FPwTv6LKh4V4bCfOuekmYzYs7JlMUDlyV+xVdVqppPCs2ujPlxD/hcio33SBWoGmh/777ZgW+lsAcMzKUzE/zsANXxYGSlkj9wYlOeXXi67XD7prb91FhVur/ck847FaUcdZMsDyo3TMmxsRsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739331182; c=relaxed/simple;
	bh=o4Of/TxPwP7SvPDyS7EdxG+c4czZOUxh+TvEBh8lrXo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oqxT6fp952dWPOw85HG6q8E8fCWVGRVCqwte4zrZ2NE26riRpEiFB08Brxkd5+OMQez3/NNS0/iSqDFBagkpxOtejyj4zgizlnlEtKBY0u59AQqde0fBbKWOOtIFB13dQbayhV4v47Fhg+9rPh6pO7oTkmPZzllzb7lrMZUcFQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gS1QKmZf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gS1QKmZf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D18C4CEDF;
	Wed, 12 Feb 2025 03:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739331182;
	bh=o4Of/TxPwP7SvPDyS7EdxG+c4czZOUxh+TvEBh8lrXo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gS1QKmZf8ZoVM2rUgQIOAiEQs9h+2rjAuaCd8LSJEZ2GOFbPMxkYqZgEKcH2gqDbz
	 ChlTavtVOF+noVT37NyssdxAgLAi89bnBVBX1wpl3v98gLKl8OwIyZos6Hpx7DZdpl
	 rv2OcNStz90Mu+nolj4+mUVNOdmbjbXHwC5EZkrojOEyZaH9nFGRZomdrTxiaUvjD0
	 7Aj2IQz5upCrIisb/SiqF2HiJzRDQJ2QXb/vTpLAWn1WFDsG1s/HXUNfy6scwd3ZDt
	 EEvd4lZAVHpe0GOzxlITVAydump99okqABr0ysAdezCcjhnsT3an4SgG4x0MmPTjyE
	 6euXzm7vuTGNg==
Date: Tue, 11 Feb 2025 19:33:01 -0800
Subject: [PATCH 09/34] generic/759,760: fix MADV_COLLAPSE detection and
 inclusion
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: joannelkoong@gmail.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173933094492.1758477.14479485917819478634.stgit@frogsfrogsfrogs>
In-Reply-To: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
References: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

On systems with "old" C libraries such as glibc 2.36 in Debian 12, the
MADV_COLLAPSE flag might not be defined in any of the header files
pulled in by sys/mman.h, which means that the fsx binary might not get
built with any of the MADV_COLLAPSE code.  If the kernel supports THP,
the test will fail with:

>  QA output created by 760
>  fsx -N 10000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W -h
> -fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W -h
> -fsx -N 10000 -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W -h
> +mapped writes DISABLED
> +MADV_COLLAPSE not supported. Can't support -h

Fix both tests to detect fsx binaries that don't support MADV_COLLAPSE,
then fix fsx.c to include the mman.h from the kernel headers (aka
linux/mman.h) so that we can actually test IOs to and from THPs if the
kernel is newer than the rest of userspace.

Cc: <fstests@vger.kernel.org> # v2025.02.02
Cc: joannelkoong@gmail.com
Fixes: 627289232371e3 ("generic: add tests for read/writes from hugepages-backed buffers")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/rc         |    5 +++++
 ltp/fsx.c         |    1 +
 tests/generic/759 |    1 +
 tests/generic/760 |    1 +
 4 files changed, 8 insertions(+)


diff --git a/common/rc b/common/rc
index 07646927bad523..b7736173e6e839 100644
--- a/common/rc
+++ b/common/rc
@@ -4976,6 +4976,11 @@ _get_page_size()
 	echo $(getconf PAGE_SIZE)
 }
 
+_require_hugepage_fsx()
+{
+	$here/ltp/fsx -N 0 -h $TEST_DIR 2>&1 | grep -q 'MADV_COLLAPSE not supported' && \
+		_notrun "fsx binary does not support MADV_COLLAPSE"
+}
 
 run_fsx()
 {
diff --git a/ltp/fsx.c b/ltp/fsx.c
index 634c496ffe9317..cf9502a74c17a7 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -20,6 +20,7 @@
 #include <strings.h>
 #include <sys/file.h>
 #include <sys/mman.h>
+#include <linux/mman.h>
 #include <sys/uio.h>
 #include <stdbool.h>
 #ifdef HAVE_ERR_H
diff --git a/tests/generic/759 b/tests/generic/759
index 6c74478aa8a0e0..a7dec155056abc 100755
--- a/tests/generic/759
+++ b/tests/generic/759
@@ -13,6 +13,7 @@ _begin_fstest rw auto quick
 
 _require_test
 _require_thp
+_require_hugepage_fsx
 
 run_fsx -N 10000            -l 500000 -h
 run_fsx -N 10000  -o 8192   -l 500000 -h
diff --git a/tests/generic/760 b/tests/generic/760
index c71a196222ad3b..4781a8d1eec4ec 100755
--- a/tests/generic/760
+++ b/tests/generic/760
@@ -14,6 +14,7 @@ _begin_fstest rw auto quick
 _require_test
 _require_odirect
 _require_thp
+_require_hugepage_fsx
 
 psize=`$here/src/feature -s`
 bsize=`$here/src/min_dio_alignment $TEST_DIR $TEST_DEV`

