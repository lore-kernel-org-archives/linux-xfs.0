Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0564282F15;
	Thu,  2 Jul 2026 03:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782964525; cv=none; b=Xx7b4ObrWSHW/oAagJdMigZHVHfmJUPFnLC0C/E77jeXvFOmi8ngq4lzt99wq00/r+ueOXdSS/FV3wt+P+tlroAFe+kJsZfF81t4uXIUEOkPUOXkBoIIbxVgczI+zpmXDWKnVohV0TKqNQohE3p7XH1bCtTnDiKC/hm6UIqTCOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782964525; c=relaxed/simple;
	bh=ucNR4M5ZbTnvNLNhq1WwbHsaP8ygeHPKxx/JfYt13M8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=oGxxmn2H+t6VIKJ3QCkFt7wpl82x4tCD12QfZshBaw+UramzT62ZuEx/eOHEax/XnMGKkrUwc9ONmOAMiNs4MYUi2FsPYRpGQnSXSyPCbBh+wJRzEiW50RhAEqYm34pVYBI1hM+AHXme/eRHlagctNtrwb8YdoQx0kUUd1HFggk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A/YzlJqR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A/YzlJqR"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 79F131F000E9;
	Thu,  2 Jul 2026 03:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782964524;
	bh=sX+WhOJ6FojWDnDiRQc70BjwQdY8SsB2D/aANT8Ogmc=;
	h=Date:From:To:Cc:Subject;
	b=A/YzlJqRcfptC5WbRVdztZGNF+Oo0+s38SexiBjjCBy0wl8RO85ViqS2NXM3AcjIs
	 OB5vcD6BdEpHaUVtVq+eLEIS8gn7Yq2G1dadEX7PYU51qBwevzOcMem3QF17/LTQHy
	 S2xoTimHhINQ5lWmPcsHh3DEOmsSDIIhtEJPTI7Glfp38HzBISvUZesKIsAI8qB4Sk
	 Zey4m2edepkaAkd4o2Rqo8jB54mw+64kUH29bfBX2K1Y6V971m3VjOURIWiG3ScRIe
	 DcLM3KjcftCeIM8Xy0+mfERxGjVfWUr8cFjc1jXX3Z+KCBHMoDGZUtRjA3SLlozaaB
	 oV5kTHwxFWtKw==
Date: Wed, 1 Jul 2026 20:55:23 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs/656: rearrange directio pread/pwrite for zoned
 filesystems
Message-ID: <20260702035523.GA9381@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

On zoned filesystems, a write failure shuts down the filesystem, which
makes this test fail with:

 --- /run/fstests/bin/tests/xfs/656.out	2026-03-13 16:19:08.152939212 -0700
 +++ /run/fstests/logs/xfs/656.out.bad	2026-06-30 18:16:43.847849604 -0700
 @@ -1,10 +1,9 @@
  QA output created by 656
  Format and mount
  pwrite: Input/output error
 -pread: Input/output error
 +stat: Input/output error
  pread: Input/output error
  fsync: Input/output error
  VICTIM pos NUM len NUM: directio_write: Input/output error
 -VICTIM pos NUM len NUM: directio_read: Input/output error
  VICTIM pos NUM len NUM: buffered_read: Input/output error
  VICTIM pos NUM len NUM: buffered_write: Input/output error

Reorder the directio pread and pwrite to avoid this unnecessary failure.
Note that we cycle the mount between the direct and buffered io tests,
which is why we only need to fix the directio test.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/656     |    2 +-
 tests/xfs/656.out |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tests/xfs/656 b/tests/xfs/656
index 3a867692502134..df91bbdacea222 100755
--- a/tests/xfs/656
+++ b/tests/xfs/656
@@ -65,8 +65,8 @@ $XFS_IO_PROG -c 'healthmon -c -v' $SCRATCH_MNT >> $tmp.healthmon &
 healer_pid=$!
 sleep 1	# wait for program to start up
 _dmerror_load_error_table
-$XFS_IO_PROG -d -c 'pwrite -b 256k 12k 16k' $testfile >> $seqres.full
 $XFS_IO_PROG -d -c 'pread -b 256k 10g 16k' $testfile >> $seqres.full
+$XFS_IO_PROG -d -c 'pwrite -b 256k 12k 16k' $testfile >> $seqres.full
 _dmerror_load_working_table
 
 _dmerror_unmount
diff --git a/tests/xfs/656.out b/tests/xfs/656.out
index 83b2f5948a772b..4d6633060acdd0 100644
--- a/tests/xfs/656.out
+++ b/tests/xfs/656.out
@@ -1,10 +1,10 @@
 QA output created by 656
 Format and mount
+pread: Input/output error
 pwrite: Input/output error
 pread: Input/output error
-pread: Input/output error
 fsync: Input/output error
-VICTIM pos NUM len NUM: directio_write: Input/output error
 VICTIM pos NUM len NUM: directio_read: Input/output error
+VICTIM pos NUM len NUM: directio_write: Input/output error
 VICTIM pos NUM len NUM: buffered_read: Input/output error
 VICTIM pos NUM len NUM: buffered_write: Input/output error
