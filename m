Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB8F388379;
	Thu, 24 Sep 2026 06:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790229798; cv=none; b=biFztDgGX07A0yUMfiWZJFmAtd446hiYC3zOITF7i3H63CTMaNUVoG0v+7ZsIPGoxs5RJnM2VUOGRrYnqgluGs1f4ZUszZgg1GQlwJ47VC91On+DOlcA6k81h4WzqCCgBFc3QVb7IvB9g3wNdZmPxSW9mbPdMT6M3ToP3QTb8/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790229798; c=relaxed/simple;
	bh=CVc2ZN/8gUe6mfwlgbx0pGlggpoveNKAuukR7cETk7I=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=V7Te7b2TDS+/nH9NO01w0rf98dtjCFcEv9kGzyPLot4yEKv7NLCGTYXHhntK/3rNz3pJGD8EdLqRBGZmpZS2sNAsINF7MuJovY4v4OnzUY8bfyQ5kHDHRPEgJAZVcNx94Uw7e99TM0LdAr7Tz8scWxuDH15l7QucKmWNpLtIcyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YiUDfJkz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YiUDfJkz"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id DEF541F00893;
	Thu, 24 Sep 2026 06:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790229796;
	bh=NiKagCKFf7UtHLLMSvYsFjI6GWPVcFpSJjIISlscCRk=;
	h=Date:From:To:Cc:Subject;
	b=YiUDfJkzXufG63XSvdO1tb6t7O9iqqhGILJpQqFb2HqoZ8iCBWC8kSU2CbLzwfrN9
	 gRB0fKHE/iKBEshgCeKcxofS7bznii/j6RxWb/X1GaZyc7hj8j0iAYJlFyJ/fjZwnW
	 DXqrKdxwHfWmJuxrQ30qeicof281jnUnyfssMNWwlKYISy8Pzt6W6tjFWsFLi1/DVi
	 qCNVjQd2jkt6H7nNqIwMukzg/T0XtUfpTeDMeMz/vj+91LkqZGw3y24RaYgb0bDu96
	 At7G7TID5rXLt+2k/NZxOCdl3TZh8dFpVmCxnygi5KvRn3T1EbOAigiDvbrZwKvotB
	 ntuoIFeM1Mv0A==
Date: Wed, 23 Sep 2026 23:03:15 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@kernel.org>
Cc: fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] generic/{349,350,351}: fix scsi_debug parameter quoting
 issues
Message-ID: <20260924060315.GF6253@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

Commit a90ba59dca447d reworked the argument handling code inside
_get_scsi_debug_dev to put all the remaining arguments (after we extract
the first four arguments) inside an array that gets passed to modprobe:

	opts+=("$@")

This code takes every command line argument and copies them into the
array verbatim.  Contrast this to what it did before (excerpted):

	opts="...dev_size_mb=$size $@"
	echo "scsi_debug options $opts" >> $seqres.full
	modprobe scsi_debug $opts

The old code put all the arguments into a string, then passed the string
unquoted to modprobe, which means that any spaces in the parameters
given to _get_scsi_debug_dev become argument separators in the modprobe
call.  Put more simply, passing "foo=1 bar=1" to _get_scsi_debug_dev
results in "foo=1" "bar=1" being passed to modprobe.

Now we no longer do that, which causes these three tests to fail with:

	scsi_debug: `1 lbpws10=1' invalid for parameter `lbpws'

because we're effectively passing lbpws="1 lbpws10=1" to scsi_debug.
Fix this by removing the quoting from the three tests.

Cc: <fstests@vger.kernel.org> # v2026.09.22
Fixes: a90ba59dca447d ("common/scsi_debug: don't slow down I/O")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/generic/349 |    2 +-
 tests/generic/350 |    2 +-
 tests/generic/351 |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tests/generic/349 b/tests/generic/349
index 72fbda412ea41c..0d019d4ab46170 100755
--- a/tests/generic/349
+++ b/tests/generic/349
@@ -20,7 +20,7 @@ _require_scsi_debug
 _require_xfs_io_command "fzero"
 
 echo "Create and format"
-dev=$(_get_scsi_debug_dev 512 512 0 4 "lbpws=1 lbpws10=1")
+dev=$(_get_scsi_debug_dev 512 512 0 4 lbpws=1 lbpws10=1)
 _pwrite_byte 0x62 0 4m $dev >> $seqres.full
 
 echo "Zero range"
diff --git a/tests/generic/350 b/tests/generic/350
index 6079a8d5032303..7dcdda03a613ff 100755
--- a/tests/generic/350
+++ b/tests/generic/350
@@ -20,7 +20,7 @@ _require_scsi_debug
 _require_xfs_io_command "fpunch"
 
 echo "Create and format"
-dev=$(_get_scsi_debug_dev 512 512 0 4 "lbpws=1 lbpws10=1")
+dev=$(_get_scsi_debug_dev 512 512 0 4 lbpws=1 lbpws10=1)
 _pwrite_byte 0x62 0 4m $dev >> $seqres.full
 
 echo "Zero punch"
diff --git a/tests/generic/351 b/tests/generic/351
index e73b70e4d7957e..374ea1afe46d76 100755
--- a/tests/generic/351
+++ b/tests/generic/351
@@ -27,7 +27,7 @@ _require_xfs_io_command "fzero"
 _require_xfs_io_command "fpunch"
 
 echo "Create and format"
-dev=$(_get_scsi_debug_dev 4096 4096 0 4 "lbpws=1 lbpws10=1")
+dev=$(_get_scsi_debug_dev 4096 4096 0 4 lbpws=1 lbpws10=1)
 _pwrite_byte 0x62 0 4m $dev >> $seqres.full
 $XFS_IO_PROG -c "fsync" $dev
 
@@ -70,7 +70,7 @@ echo "Destroy device"
 _put_scsi_debug_dev
 
 echo "Create w/o unmap or writesame and format"
-dev=$(_get_scsi_debug_dev 512 512 0 4 "lbpws=0 lbpws10=0 lbpu=0 write_same_length=0 unmap_max_blocks=0")
+dev=$(_get_scsi_debug_dev 512 512 0 4 lbpws=0 lbpws10=0 lbpu=0 write_same_length=0 unmap_max_blocks=0)
 _pwrite_byte 0x62 0 4m $dev >> $seqres.full
 $XFS_IO_PROG -c "fsync" $dev
 
