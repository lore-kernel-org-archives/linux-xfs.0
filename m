Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A6F334692;
	Tue, 16 Dec 2025 18:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765909797; cv=none; b=EdFCt6SJc3FffZrUHGVPiGjWIvXknQ0Ky9OmVZx9n3ZNUtaGQVxtndrjvSIa+1wMCQ7NLq0yqbjrcACnWxE9JzcuADCsFIY7pFWlCaJIUDSk2QhWfbjLGylq809dzb2Bl5MDjW7Q0xdpEGqEjQyKlQaYgEdIgXfNl4wlKFKz2/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765909797; c=relaxed/simple;
	bh=C2kpIORsZRV6tdd2EnJC8r441dzUXpzD3XkFlV7Xpd4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TC6gxWnRnmbX6gzUmRplb0Yx0V4yujk78DBXtm28T+CL/cv7r2bPnj+unh1Oik5IGsOFy/9ukF+h/CH6Pr5zN/vqpJSuzZqwRQapVx8DowzvQJFnpKBfgW0gRjQsFKEpod+eudeG7AZCA7Ll5IJvA5+cYpaSiDFf8NnQyPyNwvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m1BeKq7s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m1BeKq7s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 213A8C4CEF1;
	Tue, 16 Dec 2025 18:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765909797;
	bh=C2kpIORsZRV6tdd2EnJC8r441dzUXpzD3XkFlV7Xpd4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=m1BeKq7srCgLh8oDBWqwGGL0M74D5oAkG3tvakeTvzyN7R9sC9570Pa9sImm+36lm
	 NSSFLhWl3qaisNsg39gOvTX8oGWaG7o+sJ7IOq9BwwtuuVX+1V/n7hb69rJXLNnZ2Q
	 ekiHnCfpXx8gJkL4L31/1HaTbA3A5eq0zMN1bFfstkB1bMuOlC3NL8Ot/ua0t6SQpq
	 g/PPXycQRlObEaQO2f0LiQeROIh9GFpOexY18OUPROIGnrv2KHbpOJHwWDr2MGC8pu
	 XLxZKmLDNrQLWcYC7fHR+8IVnqEYJfRRzMtSK5BR1zjtGCj1JoyiHXG8lwnkfCgitP
	 7nSeDknf/vq8w==
Date: Tue, 16 Dec 2025 10:29:56 -0800
Subject: [PATCH 3/3] xfs/649: fix various problems
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
 fstests@vger.kernel.org
Message-ID: <176590971773.3745129.6098946861687047333.stgit@frogsfrogsfrogs>
In-Reply-To: <176590971706.3745129.3551344923809888340.stgit@frogsfrogsfrogs>
References: <176590971706.3745129.3551344923809888340.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Fix a couple of problems with this new test:

First, the comment for the $attr_size_bytes check says that the maximum
size of a single xattr value is 64k.  This is true, but the check
triggers the warning even when the size is exactly 64k.

Second, the test fails to format with 32k and 64k fsblock size
filesystems because the scsi_debug device size is 128M, and that's not
large enough for the minimum log size.  Raise that to 320M.

Cc: <fstests@vger.kernel.org> # v2025.12.09
Fixes: 5760b2105985bf ("xfs: test case for handling io errors when reading extended attributes")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/649 |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)


diff --git a/tests/xfs/649 b/tests/xfs/649
index f7b559f72fe913..56277c62932e16 100755
--- a/tests/xfs/649
+++ b/tests/xfs/649
@@ -48,14 +48,15 @@ _require_attrs user
 # If SELinux is enabled common/config sets a default context, which breaks this test.
 export SELINUX_MOUNT_OPTIONS=""
 
-scsi_debug_dev=$(_get_scsi_debug_dev)
+# need at least 320m to format with 32/64k fsblock size
+scsi_debug_dev=$(_get_scsi_debug_dev 512 512 0 321)
 scsi_debug_opt_noerror=0
 scsi_debug_opt_error=${scsi_debug_opt_error:=2}
 test -b $scsi_debug_dev || _notrun "Failed to initialize scsi debug device"
 echo "SCSI debug device $scsi_debug_dev" >>$seqres.full
 
 SCRATCH_DEV=$scsi_debug_dev
-_scratch_mkfs >> $seqres.full
+_scratch_mkfs >> $seqres.full || _notrun "could not format filesystem"
 _scratch_mount
 
 block_size=$(_get_file_block_size $SCRATCH_MNT)
@@ -77,7 +78,7 @@ test_attr()
 	# The maximum size for a single value is ATTR_MAX_VALUELEN (64*1024)
 	# If we wanted to test a larger range of extent combinations the test
 	# would need to use multiple values.
-	[[ $attr_size_bytes -ge 65536 ]] && echo "Test would need to be modified to support > 64k values for $attr_blocks blocks".
+	[[ $attr_size_bytes -gt 65536 ]] && echo "Test would need to be modified to support > 64k values for $attr_blocks blocks".
 
 	echo $scsi_debug_opt_noerror > /sys/module/scsi_debug/parameters/opts
 

