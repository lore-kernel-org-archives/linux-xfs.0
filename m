Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EAE8DDAD;
	Wed,  7 Feb 2024 02:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707272326; cv=none; b=u1LOyt6pXS4MWwqg1UsPa8vYg3quv3N/Mmc9JVAfreHc2JUnOr6k4yCm6p2Bg1+nqyYLh+YYafK5kaeCDGQHQ7uCgp8y4FwS1lMYzHYsBeieFM/D/YZMV1uqHT+7PRUa9/jt9bFae7lFx5aHkZYzEmv87wV+ILYfvzgHQYQjeBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707272326; c=relaxed/simple;
	bh=TJ5FeDirYnRdm5/usk5qnsXnux3D16SRIp1x05YuE90=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b+XenuGKUin70Z3Qng6zzWPcjkg9+NicObTo3sfD742A8mYJSEl6KuA3a581mbYkkBwTaqmWSlkzQ2RHSYqKCJD02l/9threJbdpClNgFmSXC25Vs3jhPLy/AANZ4UtyNbpFCnS7XXADR1m2ghykI3mNSQNmUlutUmFnsOt9Z2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VDGb5viY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VDGb5viY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4687C433F1;
	Wed,  7 Feb 2024 02:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707272325;
	bh=TJ5FeDirYnRdm5/usk5qnsXnux3D16SRIp1x05YuE90=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=VDGb5viYxjpfjyH/G8z5HcYKpVTHNOw8WSriEhUECjWNHMDalK4DoFK2Z7Z6oNuQm
	 lB3kT6gzOeWDyf1WXtCluk7RaONoZdpehpB8rZclkE5JQAe+bHwYDaqFJRyNO5IWIt
	 tmoDkUHNi4NlhFRf0/DwNKKOw8gfZkCCk2KQjoDwkyXnDmbX7/FLw2BV3EhfIDcl+K
	 K9S3HujZkRXh9MKpB45chG4gx75HvF6A+rMYktVaPULxbcP5FCppytvT+hoMYb8YR5
	 AO6WlaoP53DbN6ZNLsiGqrrbJotyCip6HEkakNY35avFNdkTfY5ZE7UxwAVBUtTQIV
	 iXP9o+mVpf/uw==
Subject: [PATCH 02/10] common/xfs: simplify maximum metadump format detection
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
 linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date: Tue, 06 Feb 2024 18:18:45 -0800
Message-ID: <170727232530.3726171.13484518243714744011.stgit@frogsfrogsfrogs>
In-Reply-To: <170727231361.3726171.14834727104549554832.stgit@frogsfrogsfrogs>
References: <170727231361.3726171.14834727104549554832.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

xfs_metadump (aka the wrapper around xfs_db -c metadump) advertises the
-v switch to turn on v2 format in its help screen.  There's no need to
fire up xfs_db on the scratch device which will load the AGs and take
much longer.

While we're at it, reduce the amount of boilerplate in the test files by
changing the function to emit the max version supported.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Zorro Lang <zlang@kernel.org>
---
 common/xfs    |   10 +++++++---
 tests/xfs/129 |    3 +--
 tests/xfs/234 |    3 +--
 tests/xfs/253 |    3 +--
 tests/xfs/291 |    3 +--
 tests/xfs/432 |    3 +--
 tests/xfs/503 |    3 +--
 tests/xfs/605 |    3 +--
 8 files changed, 14 insertions(+), 17 deletions(-)


diff --git a/common/xfs b/common/xfs
index 11cfd79562..248ccefda3 100644
--- a/common/xfs
+++ b/common/xfs
@@ -713,10 +713,14 @@ _xfs_mdrestore() {
 	$XFS_MDRESTORE_PROG $options "${metadump}" "${device}"
 }
 
-_scratch_metadump_v2_supported()
+# What is the maximum metadump file format supported by xfs_metadump?
+_xfs_metadump_max_version()
 {
-	$XFS_DB_PROG -c "help metadump" $SCRATCH_DEV | \
-		grep -q "Metadump version to be used"
+	if $XFS_METADUMP_PROG --help 2>&1 | grep -q -- '-v version'; then
+		echo 2
+	else
+		echo 1
+	fi
 }
 
 # Snapshot the metadata on the scratch device
diff --git a/tests/xfs/129 b/tests/xfs/129
index 8a817b416c..cdac2349df 100755
--- a/tests/xfs/129
+++ b/tests/xfs/129
@@ -106,8 +106,7 @@ verify_metadump_v2()
 
 _scratch_mkfs >/dev/null 2>&1
 
-max_md_version=1
-_scratch_metadump_v2_supported && max_md_version=2
+max_md_version=$(_xfs_metadump_max_version)
 
 _scratch_mount
 
diff --git a/tests/xfs/234 b/tests/xfs/234
index c9bdb674ab..f4f8af6d3a 100755
--- a/tests/xfs/234
+++ b/tests/xfs/234
@@ -106,8 +106,7 @@ verify_metadump_v2()
 
 _scratch_mkfs >/dev/null 2>&1
 
-max_md_version=1
-_scratch_metadump_v2_supported && max_md_version=2
+max_md_version=$(_xfs_metadump_max_version)
 
 _scratch_mount
 
diff --git a/tests/xfs/253 b/tests/xfs/253
index 8e18ddb83a..3b567999d8 100755
--- a/tests/xfs/253
+++ b/tests/xfs/253
@@ -233,8 +233,7 @@ cd $here
 
 _scratch_unmount
 
-max_md_version=1
-_scratch_metadump_v2_supported && max_md_version=2
+max_md_version=$(_xfs_metadump_max_version)
 
 verify_metadump_v1 $max_md_version
 
diff --git a/tests/xfs/291 b/tests/xfs/291
index 33193eb78e..1433140821 100755
--- a/tests/xfs/291
+++ b/tests/xfs/291
@@ -92,8 +92,7 @@ _scratch_xfs_check >> $seqres.full 2>&1 || _fail "xfs_check failed"
 
 # Yes they can!  Now...
 # Can xfs_metadump cope with this monster?
-max_md_version=1
-_scratch_metadump_v2_supported && max_md_version=2
+max_md_version=$(_xfs_metadump_max_version)
 
 for md_version in $(seq 1 $max_md_version); do
 	version=""
diff --git a/tests/xfs/432 b/tests/xfs/432
index a215d3ce2e..7e402aa88f 100755
--- a/tests/xfs/432
+++ b/tests/xfs/432
@@ -87,8 +87,7 @@ echo "qualifying extent: $extlen blocks" >> $seqres.full
 test -n "$extlen" || _notrun "could not create dir extent > 1000 blocks"
 
 echo "Try to metadump, restore and check restored metadump image"
-max_md_version=1
-_scratch_metadump_v2_supported && max_md_version=2
+max_md_version=$(_xfs_metadump_max_version)
 
 for md_version in $(seq 1 $max_md_version); do
 	version=""
diff --git a/tests/xfs/503 b/tests/xfs/503
index a1479eb613..8643c3d483 100755
--- a/tests/xfs/503
+++ b/tests/xfs/503
@@ -54,8 +54,7 @@ check_restored_metadump_image()
 	_destroy_loop_device $loop_dev
 }
 
-max_md_version=1
-_scratch_metadump_v2_supported && max_md_version=2
+max_md_version=$(_xfs_metadump_max_version)
 
 echo "metadump and mdrestore"
 for md_version in $(seq 1 $max_md_version); do
diff --git a/tests/xfs/605 b/tests/xfs/605
index 5cbf5d2550..f2cd7aba98 100755
--- a/tests/xfs/605
+++ b/tests/xfs/605
@@ -44,8 +44,7 @@ testfile=${SCRATCH_MNT}/testfile
 echo "Format filesystem on scratch device"
 _scratch_mkfs >> $seqres.full 2>&1
 
-max_md_version=1
-_scratch_metadump_v2_supported && max_md_version=2
+max_md_version=$(_xfs_metadump_max_version)
 
 external_log=0
 if [[ $USE_EXTERNAL = yes && -n "$SCRATCH_LOGDEV" ]]; then

