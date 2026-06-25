Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 898BA3E9F8E;
	Thu, 25 Jun 2026 16:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782406279; cv=none; b=Pxku67ZRhz1bbYby/FPLynIIzFK58VuWGq7szOwwxwrr/Hb69HezDkp8W6mP/uW05oz/Ps30Bqdj6erVE4YllpGhFl/wGAQWG0pSrYcn9WFWwILQFpU9s5ahZjN6bbmi3oJS0qeXhYQdVHmx+OEM8/oi6mBbf64mTVuijg+ET3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782406279; c=relaxed/simple;
	bh=PKK9zdoFdSWFkNJ6gbJpd0z5bpRmG8uGITV5YEiDmHg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JsAjKi5sux/wsBLhSE6pFsvbOROnbYc3Ie6uS64fgFQtbyfg0Y9G9UGag8PPqMnXT3lWCJYt9CrY3jRnT/sU7Uo9YJvgtuQ8tuFuT5Kwf1TZIQm/C9xfl9hwYEHLT3VjinU16uJ/+b48xjPg5pxpgvOoIufJ8OwSKkwKyvPmQqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a8Oj2tHB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a8Oj2tHB"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3571D1F000E9;
	Thu, 25 Jun 2026 16:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782406278;
	bh=CW5IPtloNDH0lbN+zzFrWtfPTzV9SPjE4PqmW1Y4Pro=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=a8Oj2tHBZAZtRP+O9AMhpNX1dyTb41jJbk1QbjiFSqhczYEYK5Z6JM/7AwR0Ng0+/
	 rHq01o3O/PwMNKSjbUYL1qBmzWoJoNrnhNV+BahYwEUYof5io+H4/JVLFS1eMXpjSO
	 pm7ieItJ7+xSgyOkD8T7T/f/6z5IMvXQTjp613TvHQaYnRPIfQUCSu+svixCxtqokm
	 JgrSi+3HpUkobcNQn8hdmtJ8ALAHCb64Gc6O9AaR1KoZRzfFIs++DRndca2NDAWg9u
	 oZFnq4elMIviIIgQXE2HjOM2hImEgXfdD8wC0voriPxgaCz1jEu1K9KoAo/nW8AV9Q
	 CuXpL83XIMCfA==
Date: Thu, 25 Jun 2026 09:51:17 -0700
Subject: [PATCH 2/2] xfs/21[67]: fix mkfs log concurrency detection
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@kernel.org, djwong@kernel.org
Cc: fstests@vger.kernel.org, hch@lst.de, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <178240619668.1665857.17134786745403757824.stgit@frogsfrogsfrogs>
In-Reply-To: <178240619625.1665857.3954516357764795627.stgit@frogsfrogsfrogs>
References: <178240619625.1665857.3954516357764795627.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

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
 common/xfs    |    6 ++++++
 tests/xfs/216 |    9 ++++-----
 tests/xfs/217 |    9 ++++-----
 3 files changed, 14 insertions(+), 10 deletions(-)


diff --git a/common/xfs b/common/xfs
index 88299acdd086be..81add2086866c8 100644
--- a/common/xfs
+++ b/common/xfs
@@ -64,6 +64,12 @@ _scratch_mkfs_xfs_opts()
 	echo "$MKFS_XFS_PROG $SCRATCH_OPTIONS $mkfs_opts"
 }
 
+# Figure out if the supplied mkfs.xfs options are supported.  A device or file
+# path must be specified as one of the options, though it will not be written.
+_mkfs_xfs_supported()
+{
+	$MKFS_XFS_PROG -f -N "$@"
+}
 
 _scratch_mkfs_xfs_supported()
 {
diff --git a/tests/xfs/216 b/tests/xfs/216
index 1749647c11f716..48657242e65daf 100755
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
index 23aae842d1fb61..34ac8dae8ef43f 100755
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

