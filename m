Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384C91A8F7B;
	Wed, 20 May 2026 19:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779303674; cv=none; b=t9ixLKWucHGJbwvQFbULI/plS0mqszGU1lyIrsxWS7EbrUyUPHt93KygjcptFASxS6CAcaXZAPh/9ac8EEfUE9uqbqhUGLFsTCo346/A/eJxPhl5eT1vNdOgyg4GAttWKlXVtybU+Ovkgs77CXyIEvVzKVLg8BByQ24guQOQaDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779303674; c=relaxed/simple;
	bh=0JCTltW5TAlYHhA9eyunDDclyuA8a/98HPjAuhYl/s8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sHXTaMsmRYKOGHSPSD/OmBC1sspwjoeVs82DmVKM+Q5/+G/pVv2snRi3YlDmsY788/buaw+MCSCv6WHYoNb9Xx5PMQbnsWHpXaTtY/hWMCaboZV/Yf9d60SsgN3/zEb5XoRtx8qQYqAI6jB9vy9IpkpUDbEGXtPbgfwm87L5XWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WJqbqs2X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WJqbqs2X"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C5F0E1F000E9;
	Wed, 20 May 2026 19:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779303672;
	bh=4+VVGvuyBcp1llZ3R46cjwoUXNVFuY7GgRgEwV1yoxg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WJqbqs2XzWkCpZNHWNla+/rg8PTahSVHtbPKZIe9Ap1XHdMwH+naxl+dMrOOduHoW
	 BBCNCftcfTXwcGd3fN7rJb8Ejov3OE0VuF5kNTTaq7bcJsBKuJYIR/gpMnuaZ+MXtd
	 a0KbXReCIhF+gB+96AlzGYjSDOUsQPcLzAo+d3x0dddKQJ162dP+FhfeCSXKdHkFzY
	 7+IFDdhzAFxFQ15S0vrS39Z42k9kswiAD3oCpA2NYqUrp35/2mkcWwKNQx2aMWUUBv
	 dTKced1CrTo+CZGrSBuC5qOkWFLPoI6rV81/JPDQjznRRJIvfEW04wYqIvmsJS4xYN
	 joksrczkky3pQ==
Date: Wed, 20 May 2026 12:01:12 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org, xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH 2/2] xfs/21[67]: fix mkfs log concurrency detection
Message-ID: <20260520190112.GE9544@frogsfrogsfrogs>
References: <20260520185202.GD9544@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520185202.GD9544@frogsfrogsfrogs>

From: Darrick J. Wong <djwong@kernel.org>

Both of these tests use _scratch_mkfs_xfs_supports_concurrency to detect
if they should be adding -lconcurrency=0 to the mkfs options that are
used to format a loop device.

However, this doesn't work in practice because of three factors: 1) the
scratch device could have an external log set up; 2) the loop device
does /not/ have an external log device; and 3) -lconcurrency isn't
compatible with -llogdev.

Fix this by creating a more general mkfs option detection helper and use
that once we have the loop device set up.

Cc: <fstests@vger.kernel.org> # v2026.05.17
Fixes: ffc8bad17e5b2f ("xfs/21{6,7} Use default -l concurrency=0 on mkfs.xfs that supports it")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/xfs    |   15 +++++++++++++++
 tests/xfs/216 |    9 ++++-----
 tests/xfs/217 |    9 ++++-----
 3 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/common/xfs b/common/xfs
index 88299acdd086be..232d40fd5e01b1 100644
--- a/common/xfs
+++ b/common/xfs
@@ -64,6 +64,21 @@ _scratch_mkfs_xfs_opts()
 	echo "$MKFS_XFS_PROG $SCRATCH_OPTIONS $mkfs_opts"
 }
 
+_mkfs_xfs_supported()
+{
+	local mkfs_opts=$*
+
+	$MKFS_XFS_PROG -f -N $MKFS_OPTIONS $mkfs_opts
+	local mkfs_status=$?
+
+	# a mkfs failure may be caused by conflicts between $MKFS_OPTIONS and
+	# $mkfs_opts, try again without $MKFS_OPTIONS
+	if [ $mkfs_status -ne 0 -a -n "$mkfs_opts" ]; then
+		$MKFS_XFS_PROG -f -N $mkfs_opts
+		mkfs_status=$?
+	fi
+	return $mkfs_status
+}
 
 _scratch_mkfs_xfs_supported()
 {
diff --git a/tests/xfs/216 b/tests/xfs/216
index e3be9f3fe39ee0..bd98ee4dbfe960 100755
--- a/tests/xfs/216
+++ b/tests/xfs/216
@@ -22,11 +22,6 @@ _cleanup()
 
 _require_scratch
 _scratch_mkfs_xfs >/dev/null 2>&1
-if _scratch_mkfs_xfs_supports_concurrency -l >> $seqres.full 2>&1; then
-	loop_mkfs_opts="-l concurrency=0"
-else
-	loop_mkfs_opts=""
-fi
 _scratch_mount
 
 _require_loop
@@ -76,6 +71,10 @@ mkdir $LOOP_MNT
 
 loop_dev=$(_create_loop_device $LOOP_IMG)
 
+if _mkfs_xfs_supported $loop_mkfs_opts -l concurrency=0 $loop_dev &>> $seqres.full; then
+	loop_mkfs_opts="$loop_mkfs_opts -l concurrency=0"
+fi
+
 # walk over standard sizes (up to 256GB)
 _do_mkfs 1 2 4 8 16 32 64 128 256
 
diff --git a/tests/xfs/217 b/tests/xfs/217
index 5b210627b5ed18..5ba0b2198eb84f 100755
--- a/tests/xfs/217
+++ b/tests/xfs/217
@@ -21,11 +21,6 @@ _cleanup()
 
 _require_scratch
 _scratch_mkfs_xfs >/dev/null 2>&1
-if _scratch_mkfs_xfs_supports_concurrency -l >> $seqres.full 2>&1; then
-	loop_mkfs_opts="-l concurrency=0 -d concurrency=0"
-else
-	loop_mkfs_opts=""
-fi
 _scratch_mount
 # 16T mkfs requires a bit over 2G free
 _require_fs_space $SCRATCH_MNT 2202000
@@ -63,6 +58,10 @@ fi
 
 loop_dev=$(_create_loop_device $LOOP_IMG)
 
+if _mkfs_xfs_supported $loop_mkfs_opts -l concurrency=0 -d concurrency=0 $loop_dev &>> $seqres.full; then
+	loop_mkfs_opts="$loop_mkfs_opts -l concurrency=0 -d concurrency=0"
+fi
+
 #
 # walk over "new" sizes supported by recent xfsprogs.
 # Note that the last test is for 16TB-1GB as 32bit platforms only support
