Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2AC019D093;
	Wed, 15 Oct 2025 16:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760546281; cv=none; b=U8YQRN/GTiAaO3KVIro1nQHIch2GIb3veOPvDAxhK/hsNMvcFIoEzeh5wBT2SEbl2UMxpIWbO7FX4Riky6FEqx13hhC05vsv9uVuM7++zIBTNPqvPHBx5GoT33jE5E2cyzKU48+xLBse+WmV12ghGs8YJXvEeQ/G5lvWTlwRJJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760546281; c=relaxed/simple;
	bh=TYOBnG0CK9shxknh8g8hG1zLWa7O7QdISrjo6OR/Pt8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l/gkRA+hgB38QPDa1X1Qof7HCY61yeOS53HC65vFNNC0s8FDHnsrJv6uhOr+ycsQ5yLQ7dC6NW+wyxUiB+m7mllw0DwR5kfIluHq0/ECj0UvEHk6tvxxgFxCXQ/WvMTHNHlZp2602PWpuXSt5myshAibLjHH+iiuur+ARukJThk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DL7nLkz2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DL7nLkz2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B29DC4CEF9;
	Wed, 15 Oct 2025 16:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760546281;
	bh=TYOBnG0CK9shxknh8g8hG1zLWa7O7QdISrjo6OR/Pt8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DL7nLkz2plsXfPWFvlhiDhjBU/bsvVgE4eNUaPfHyN2mI6OpwAOfZ6p1GeRXPu/Kx
	 wdrj0tE/Vw5fUUgVjWF+m/9SdHFZ7rUhNVbSCSY6mqG/3+UaqC2RaKRkp0kt6OXxUy
	 EeQ26YL5PXvQIsq3MtGvBHdwkBmeR2A6nyAFsKoU+6OITshYIqPIj+ogImgEGZEb5v
	 UA91inSpkRUIERMEzVUpXw7+lo41n2rAvijsy/JxRbb3tAgp6rLT9jbK/mOZ1RlZn8
	 s9XLgWNcssUbRghOeIgLXoCwQnlir/S4/hWycF3b9pKEiWTft4wOxp+jHwbrIj816D
	 f4dyLEiDmrIwQ==
Date: Wed, 15 Oct 2025 09:38:01 -0700
Subject: [PATCH 5/8] generic/772: actually check for file_getattr special file
 support
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <176054617988.2391029.18130416327249525205.stgit@frogsfrogsfrogs>
In-Reply-To: <176054617853.2391029.10911105763476647916.stgit@frogsfrogsfrogs>
References: <176054617853.2391029.10911105763476647916.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

On XFS in 6.17, this test fails with:

 --- /run/fstests/bin/tests/generic/772.out	2025-10-06 08:27:10.834318149 -0700
 +++ /var/tmp/fstests/generic/772.out.bad	2025-10-08 18:00:34.713388178 -0700
 @@ -9,29 +9,34 @@ Can not get fsxattr on ./foo: Invalid ar
  Can not set fsxattr on ./foo: Invalid argument
  Initial attributes state
  ----------------- SCRATCH_MNT/prj
 ------------------ ./fifo
 ------------------ ./chardev
 ------------------ ./blockdev
 ------------------ ./socket
 ------------------ ./foo
 ------------------ ./symlink
 +Can not get fsxattr on ./fifo: Inappropriate ioctl for device
 +Can not get fsxattr on ./chardev: Inappropriate ioctl for device
 +Can not get fsxattr on ./blockdev: Inappropriate ioctl for device
 +Can not get fsxattr on ./socket: Inappropriate ioctl for device

This is a result of XFS' file_getattr implementation rejecting special
files prior to 6.18.  Therefore, skip this new test on old kernels.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/generic/772 |    3 +++
 tests/xfs/648     |    3 +++
 2 files changed, 6 insertions(+)


diff --git a/tests/generic/772 b/tests/generic/772
index cc1a1bb5bf655c..e68a6724654450 100755
--- a/tests/generic/772
+++ b/tests/generic/772
@@ -43,6 +43,9 @@ touch $projectdir/bar
 ln -s $projectdir/bar $projectdir/broken-symlink
 rm -f $projectdir/bar
 
+file_attr --get $projectdir ./fifo &>/dev/null || \
+	_notrun "file_getattr not supported on $FSTYP"
+
 echo "Error codes"
 # wrong AT_ flags
 file_attr --get --invalid-at $projectdir ./foo
diff --git a/tests/xfs/648 b/tests/xfs/648
index 215c809887b609..e3c2fbe00b666a 100755
--- a/tests/xfs/648
+++ b/tests/xfs/648
@@ -47,6 +47,9 @@ touch $projectdir/bar
 ln -s $projectdir/bar $projectdir/broken-symlink
 rm -f $projectdir/bar
 
+$here/src/file_attr --get $projectdir ./fifo &>/dev/null || \
+	_notrun "file_getattr not supported on $FSTYP"
+
 $XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
 	-c "project -sp $projectdir $id" $SCRATCH_DEV | filter_quota
 $XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \

