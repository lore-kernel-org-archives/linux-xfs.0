Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35260263F52;
	Tue, 16 Dec 2025 18:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765909766; cv=none; b=UqGwORgqVJJz+HacrgCvuxJwaWPHWz+F0VZ556cQ/dlMEq2IY8MVrnfF+9w+IBguC79CdDQ0FPLChciQXdHcNioj/9C/IPqhMkHwqNRumXSXH3eGIPSfIzwigKDtwqg5vFxVc55CN/waqJ7EEu/v4n0ByQJHTgxx2og4/xnYC0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765909766; c=relaxed/simple;
	bh=oGq+GQy1aLBpFfrkNzos3wTP9xWigzsGbNZE4gKDA3E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rMrxEFrvma91tY828KlZBDoI684MfODxZSLyJ8TnjjGmmWILkB0iRNHL8/x7gkxQGKBo1N9POGcvalNMu0Ojev4hbfE6j6JocsKYo5gjyhkObLG3XiDy1mMFPyHY+m58aC3xC048h+VICbsYaWhvms6W55WFLPydBMzwOBFtTnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HY1HkPAh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HY1HkPAh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA828C4CEF1;
	Tue, 16 Dec 2025 18:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765909765;
	bh=oGq+GQy1aLBpFfrkNzos3wTP9xWigzsGbNZE4gKDA3E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HY1HkPAhl9LSG87m9u57uYu5GgeaBGrCyyFxvxCP3vQECZlLk/w59fDHwbdOY+DGG
	 MHOfEWZrFruAU8Rjs9fd6nc587B7W4OX7Fv7yUHFPe+8UEZJngowug60XO1JsMqgMT
	 BgucQ40LBGZ4u6fpJbqhsboV9zyZqw8SmHFE6N+o531ptsmx5KGbmNlS3g4nseVRlk
	 MqracxZagb9WQ47xIj3BXuHjbWIRtNEwo3j5ZgZ7t9IWxWSncK3SwC5n7PoP1QcbME
	 qeFezuFEC5D4qEhDwHk9JQtN5pfMxktgKTKC0NftqGFjcfY03nFN+z9C+1t/hBCole
	 KHEF2gkDgrmsw==
Date: Tue, 16 Dec 2025 10:29:25 -0800
Subject: [PATCH 1/3] check: put temporary files in TMPDIR, not /tmp
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <176590971736.3745129.17863225958624907500.stgit@frogsfrogsfrogs>
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

Nowadays, systemd will auto-remove files from /tmp after 10 days.  If
you want to run a testcase for more than that duration (e.g.
SOAK_DURATION=14d) then the test will fail after the .out file is
deleted:

 xfs/286            _check_xfs_filesystem: filesystem on /dev/sda4 is inconsistent (r)
 (see /var/tmp/fstests/xfs/286.full for details)
 sed: can't read /tmp/2098.out: No such file or directory
 - output mismatch (see /var/tmp/fstests/xfs/286.out.bad)
 mv: cannot stat '/tmp/2098.out': No such file or directory
 diff: /var/tmp/fstests/xfs/286.out.bad: No such file or directory

This happens because systemd-tmpfiles garbage collects any file in /tmp
that becomes older than 10 days:

 $ cat /usr/lib/tmpfiles.d/tmp.conf
 #  This file is part of systemd.
 #
 #  systemd is free software; you can redistribute it and/or modify it
 #  under the terms of the GNU Lesser General Public License as published by
 #  the Free Software Foundation; either version 2.1 of the License, or
 #  (at your option) any later version.

 # See tmpfiles.d(5) for details.

 # Clear tmp directories separately, to make them easier to override
 q /tmp 1777 root root 10d
 q /var/tmp 1777 root root 30d

This is now the default in Debian 13 (D12 never deleted anything) which
is why I didn't notice this until I upgraded a couple of weeks ago.
Most people aren't going to be running a single testcase for more than
10 days so I'll go with the least invasive solution that I can think of.

Allow system administrators or fstests runners to set TMPDIR to a
directory that won't get purged, and make fstests follow that.  Fix up
generic/002 so that it doesn't use $tmp for paths on the test
filesystem.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 check             |    2 +-
 common/preamble   |    2 +-
 tests/generic/002 |   16 ++++++++--------
 3 files changed, 10 insertions(+), 10 deletions(-)


diff --git a/check b/check
index c897afbb419612..cd7a79347eac28 100755
--- a/check
+++ b/check
@@ -4,7 +4,7 @@
 #
 # Control script for QA
 #
-tmp=/tmp/$$
+tmp="${TMPDIR:-/tmp}/$$"
 status=0
 needwrap=true
 needsum=true
diff --git a/common/preamble b/common/preamble
index 51d03396c96864..1c1eb348a88114 100644
--- a/common/preamble
+++ b/common/preamble
@@ -47,7 +47,7 @@ _begin_fstest()
 	echo "QA output created by $seq"
 
 	here=`pwd`
-	tmp=/tmp/$$
+	tmp="${TMPDIR:-/tmp}/$$"
 	status=1	# failure is the default!
 
 	_register_cleanup _cleanup
diff --git a/tests/generic/002 b/tests/generic/002
index b202492b49a73c..6df57a7a1353c7 100755
--- a/tests/generic/002
+++ b/tests/generic/002
@@ -20,31 +20,31 @@ _require_hardlinks
 echo "Silence is goodness ..."
 
 # ensure target directory exists
-mkdir `dirname $TEST_DIR/$tmp` 2>/dev/null
+mkdir `dirname $TEST_DIR/tmp` 2>/dev/null
 
-touch $TEST_DIR/$tmp.1
+touch $TEST_DIR/tmp.1
 for l in 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
 do
-    ln $TEST_DIR/$tmp.1 $TEST_DIR/$tmp.$l
-    x=`$here/src/lstat64 $TEST_DIR/$tmp.1 | sed -n -e '/ Links: /s/.*Links: *//p'`
+    ln $TEST_DIR/tmp.1 $TEST_DIR/tmp.$l
+    x=`$here/src/lstat64 $TEST_DIR/tmp.1 | sed -n -e '/ Links: /s/.*Links: *//p'`
     if [ "$l" -ne $x ]
     then
 	echo "Arrgh, created link #$l and lstat64 looks like ..."
-	$here/src/lstat64 $TEST_DIR/$tmp.1
+	$here/src/lstat64 $TEST_DIR/tmp.1
 	status=1
     fi
 done
 
 for l in 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1
 do
-    x=`$here/src/lstat64 $TEST_DIR/$tmp.1 | sed -n -e '/ Links: /s/.*Links: *//p'`
+    x=`$here/src/lstat64 $TEST_DIR/tmp.1 | sed -n -e '/ Links: /s/.*Links: *//p'`
     if [ "$l" -ne $x ]
     then
 	echo "Arrgh, about to remove link #$l and lstat64 looks like ..."
-	$here/src/lstat64 $TEST_DIR/$tmp.1
+	$here/src/lstat64 $TEST_DIR/tmp.1
 	status=1
     fi
-    rm -f $TEST_DIR/$tmp.$l
+    rm -f $TEST_DIR/tmp.$l
 done
 
 # success, all done

