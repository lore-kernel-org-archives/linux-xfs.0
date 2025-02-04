Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C7E25A62C;
	Tue,  4 Feb 2025 21:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738704279; cv=none; b=mpbKIrsPR7Do8So+vtDWGRUFaMrBjN98LRKZE6ffVYUzFKUvdlwA06fIV3RS3vVnRdw3UKiQ9fLjgS73oa6WMQqTCVzZKmw5yM6melVNJsDxhzVRe/zJLTYtOD0eHe01nZRGvOUs5dUGVNAwHIcwwlyyxxeGgE+u9Ku9TaHoz+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738704279; c=relaxed/simple;
	bh=o4Of/TxPwP7SvPDyS7EdxG+c4czZOUxh+TvEBh8lrXo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qnbv0KPDbKoiQV0ggoTJSho/CSDsha0lrghp11S7o24Dx8oBwRKyrxum+6o2324Q7ajkQv+b/VFYSsFjGBFvOzOlgMnzQvtPTAD8IsC7BZqnRVuypUu8mxH02DEjlkEvpowSiZ0251uiAJz4t7OFMpKegZi9rK8SYScNFACbvEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jf47yrhl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jf47yrhl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13E71C4CEDF;
	Tue,  4 Feb 2025 21:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738704279;
	bh=o4Of/TxPwP7SvPDyS7EdxG+c4czZOUxh+TvEBh8lrXo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jf47yrhl2tROaIKjPZpQsr/8Csw0pv9hjm7RtwbakEg5zR80G6/yqRZE0twJYjAG8
	 w4ErgR5f4DYni+OQ8v/0h7rnBRN/gQvi0/REpBctzJjtodg4kjEno94P1V2t+pSRx8
	 CzCtrnuKcDfFCssHtNiH6MMHcmLBxZkvfsoPhz8+ORr2iqEEsY1ky/lK8aJWpS2X4o
	 9S5eJlN33vjpL6ghl0Fbv3RDS24pYKHIcgQ9IDKtyNkvuCzfT8m7KSd7Gc/laKv62O
	 qM23LSsLuMEI+n/gO38DaGm433CiDiFgNy06Hn6ptRmv51h6qX78OKv0v0rFdLvF1m
	 TQpZqwaru5TFg==
Date: Tue, 04 Feb 2025 13:24:38 -0800
Subject: [PATCH 09/34] generic/759,760: fix MADV_COLLAPSE detection and
 inclusion
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: joannelkoong@gmail.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173870406245.546134.16199144509178485405.stgit@frogsfrogsfrogs>
In-Reply-To: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
References: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
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

