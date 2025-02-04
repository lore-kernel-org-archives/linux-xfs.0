Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3CE425A62C;
	Tue,  4 Feb 2025 21:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738704295; cv=none; b=MSqDsQ/QxAHvDbzQrHfhkjJDi6KqxuJytMeEeSTtO/uqA1O3r/Pjm53I8nRjkbw09s0H1y8y38t3PD+bvWTEvq+ayDNwFxxctnJvCRtcVc5Ugw0+jZ8Gn+aI5H6esxld1gutNWwlmgMlcdWLIZEDE/YLDi8JxQnnZnJTw6N4kto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738704295; c=relaxed/simple;
	bh=4HjplVCgeYQi5ocD2+1OZjGtXMoEEzYoCoWp4ZPkwQI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pScAbZ4SctyHkMYUJPlEC44ID/cB51MuOYTzdLZFLipGBQZoJniL7A+Mnlabem0G4DoqLlgxFTC4qUTKHq3tg3oMpf3zlpLgxXllIoKnf2amXeMJ+1vpeUY+ZjnwmIm3ce51q00pjtg8KOQPyBVg94wBauqhPSq0yH28Ngr5ruY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q7Ra2XTj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q7Ra2XTj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA22EC4CEDF;
	Tue,  4 Feb 2025 21:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738704294;
	bh=4HjplVCgeYQi5ocD2+1OZjGtXMoEEzYoCoWp4ZPkwQI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Q7Ra2XTjjIEklrVq4dLgFLRp4EAHbT8D9rlBTggMh+BjaBnuT3NSf228vxogodAIk
	 3ftmeViTjK0caTZZOGWqQD1+nvGno9Nx32Mgp4JIwFViNSnrs3haCUrCVFzXuuc6kQ
	 Gs+wPENTlkTfUv49pymih/wzpMB+MZ2KtsOSu/j6hzg3xFzIPRvLF4uRXWTsJPuAo0
	 vS2Sy9Sc4iD6hGgHZJCy8keaLubj90cEr3xu7CM0fY/SjiHsN3Ybwqs6RfbQuI6wDc
	 wSnoAJCBdqF0IawAwzQS4NVTSJz4Pxgz06muZ4CYCcSD9aSksEUbBGzJKOmTjnj6Rl
	 27l7uk0hIwQ/w==
Date: Tue, 04 Feb 2025 13:24:54 -0800
Subject: [PATCH 10/34] generic/759,760: skip test if we can't set up a
 hugepage for IO
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: joannelkoong@gmail.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173870406261.546134.13417439080603539599.stgit@frogsfrogsfrogs>
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

On an arm64 VM with 64k base pages and a paltry 8G of RAM, this test
will frequently fail like this:

>  QA output created by 759
>  fsx -N 10000 -l 500000 -h
> -fsx -N 10000 -o 8192 -l 500000 -h
> -fsx -N 10000 -o 128000 -l 500000 -h
> +Seed set to 1
> +madvise collapse for buf: Cannot allocate memory
> +init_hugepages_buf failed for good_buf: Cannot allocate memory

This system has a 512MB hugepage size, which means that there's a good
chance that memory is so fragmented that we won't be able to create a
huge page (in 1/16th the available DRAM).  Create a _run_hugepage_fsx
helper that will detect this situation at the start of the test and skip
it, having refactored run_fsx into a properly namespaced version that
won't exit the test on failure.

Cc: <fstests@vger.kernel.org> # v2025.02.02
Cc: joannelkoong@gmail.com
Fixes: 627289232371e3 ("generic: add tests for read/writes from hugepages-backed buffers")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/rc         |   34 ++++++++++++++++++++++++++++++----
 ltp/fsx.c         |    6 ++++--
 tests/generic/759 |    6 +++---
 tests/generic/760 |    6 +++---
 4 files changed, 40 insertions(+), 12 deletions(-)


diff --git a/common/rc b/common/rc
index b7736173e6e839..4005db776309f3 100644
--- a/common/rc
+++ b/common/rc
@@ -4982,20 +4982,46 @@ _require_hugepage_fsx()
 		_notrun "fsx binary does not support MADV_COLLAPSE"
 }
 
-run_fsx()
+_run_fsx()
 {
-	echo fsx $@
+	echo "fsx $*"
 	local args=`echo $@ | sed -e "s/ BSIZE / $bsize /g" -e "s/ PSIZE / $psize /g"`
 	set -- $here/ltp/fsx $args $FSX_AVOID $TEST_DIR/junk
 	echo "$@" >>$seqres.full
 	rm -f $TEST_DIR/junk
 	"$@" 2>&1 | tee -a $seqres.full >$tmp.fsx
-	if [ ${PIPESTATUS[0]} -ne 0 ]; then
+	local res=${PIPESTATUS[0]}
+	if [ $res -ne 0 ]; then
 		cat $tmp.fsx
 		rm -f $tmp.fsx
-		exit 1
+		return $res
 	fi
 	rm -f $tmp.fsx
+	return 0
+}
+
+# Run fsx with -h(ugepage buffers).  If we can't set up a hugepage then skip
+# the test, but if any other error occurs then exit the test.
+_run_hugepage_fsx() {
+	_run_fsx "$@" -h &> $tmp.hugepage_fsx
+	local res=$?
+	if [ $res -eq 103 ]; then
+		# According to the MADV_COLLAPSE manpage, these three errors
+		# can happen if the kernel could not collapse a collection of
+		# pages into a single huge page.
+		grep -q -E ' for hugebuf: (Cannot allocate memory|Device or resource busy|Resource temporarily unavailable)' $tmp.hugepage_fsx && \
+			_notrun "Could not set up huge page for test"
+	fi
+	cat $tmp.hugepage_fsx
+	rm -f $tmp.hugepage_fsx
+	test $res -ne 0 && exit 1
+	return 0
+}
+
+# run fsx or exit the test
+run_fsx()
+{
+	_run_fsx || exit 1
 }
 
 _require_statx()
diff --git a/ltp/fsx.c b/ltp/fsx.c
index cf9502a74c17a7..d1b0f245582b31 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -2974,13 +2974,15 @@ init_hugepages_buf(unsigned len, int hugepage_size, int alignment, long *buf_siz
 
 	ret = posix_memalign(&buf, hugepage_size, size);
 	if (ret) {
-		prterr("posix_memalign for buf");
+		/* common/rc greps this error message */
+		prterr("posix_memalign for hugebuf");
 		return NULL;
 	}
 	memset(buf, '\0', size);
 	ret = madvise(buf, size, MADV_COLLAPSE);
 	if (ret) {
-		prterr("madvise collapse for buf");
+		/* common/rc greps this error message */
+		prterr("madvise collapse for hugebuf");
 		free(buf);
 		return NULL;
 	}
diff --git a/tests/generic/759 b/tests/generic/759
index a7dec155056abc..49c02214559a55 100755
--- a/tests/generic/759
+++ b/tests/generic/759
@@ -15,9 +15,9 @@ _require_test
 _require_thp
 _require_hugepage_fsx
 
-run_fsx -N 10000            -l 500000 -h
-run_fsx -N 10000  -o 8192   -l 500000 -h
-run_fsx -N 10000  -o 128000 -l 500000 -h
+_run_hugepage_fsx -N 10000            -l 500000
+_run_hugepage_fsx -N 10000  -o 8192   -l 500000
+_run_hugepage_fsx -N 10000  -o 128000 -l 500000
 
 status=0
 exit
diff --git a/tests/generic/760 b/tests/generic/760
index 4781a8d1eec4ec..f270636e56a377 100755
--- a/tests/generic/760
+++ b/tests/generic/760
@@ -19,9 +19,9 @@ _require_hugepage_fsx
 psize=`$here/src/feature -s`
 bsize=`$here/src/min_dio_alignment $TEST_DIR $TEST_DEV`
 
-run_fsx -N 10000            -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W -h
-run_fsx -N 10000  -o 8192   -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W -h
-run_fsx -N 10000  -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W -h
+_run_hugepage_fsx -N 10000            -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
+_run_hugepage_fsx -N 10000  -o 8192   -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
+_run_hugepage_fsx -N 10000  -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
 
 status=0
 exit

