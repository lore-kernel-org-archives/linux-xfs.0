Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 036433815DE;
	Mon, 13 Apr 2026 17:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776102655; cv=none; b=GofmKN50dJuthzzB4aKx1ZOFK6BX+a0LE1RNJ7m6fFYL+b3lSJQm8taDqv+Fy8syXxqA7e/BA8ZhRoCjX0HBfXvLhHJhmi0ZddPjRSnKgU3ulUkXKvvEsJxt2GbDqp7pNwkOmx1PL8yBdxa6SA54kO/YdW6eILpM4mqih0tc/90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776102655; c=relaxed/simple;
	bh=KQjvJzFRCZjOMo4KJtpPBY9MGvDcd6LUhh//DvofAYU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DL63JaoEFRSTcU/L91ODr7XH3H+q6MchRyQg5OfLE96QxqnqR4SZZfk6HfWe3Mvrm4m8+az1NFRRmJPeUiMsXuhacQXJHs0n0ViedPRS6eZAZMgY4ZMhgQ1EzUheBTfPxu1Y/uWq9fDvaPj50DzrG8nG14+IyHlXxIbCURDt2SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AQo/npwf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AQo/npwf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A40DC2BCAF;
	Mon, 13 Apr 2026 17:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776102654;
	bh=KQjvJzFRCZjOMo4KJtpPBY9MGvDcd6LUhh//DvofAYU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AQo/npwfbSfq9FWRWpIkMB/l01HatFl0kuyUg0xuNWs6mThceDK/dq4c6Z1YbNVPZ
	 UfYMdCLXN6k7L3+urt3F7px52/FAOfwXwU7/wo+oMRgZ5a/0UtFxaS7HxXRDid8Cay
	 vSqUWTTbxKO07nQNoIaIwwha/I1IvqYkBVrcPydQzeqVJgdbFDGfvuSCynSXftdmAW
	 mMwkosKwSXd46ZyP8zHWuTD/nfSfLcD01SFzbvV6T7oxT3vOoTdQ3VRh5Tg7dSLR+c
	 pC1gyYxAVYNM1jKj4XXZ5xKyiliNmJ75enc0Yke/Y+utX/sB0/y7xJIK+Qt1otaVJC
	 cEj8tfJ1U+zaw==
Date: Mon, 13 Apr 2026 10:50:54 -0700
Subject: [PATCH 1/1] xfs/841: actually compare the new filesystem contents to
 the proto dir
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <177610262227.115281.16238274168034903377.stgit@frogsfrogsfrogs>
In-Reply-To: <177610262208.115281.12661076175365005191.stgit@frogsfrogsfrogs>
References: <177610262208.115281.12661076175365005191.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

We should confirm that the directory tree was correctly copied into the
new filesystem, not just that the image files all have the same
checksum.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/841 |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/841 b/tests/xfs/841
index ddb1b3bea10492..175e709c701abc 100755
--- a/tests/xfs/841
+++ b/tests/xfs/841
@@ -16,15 +16,19 @@ _begin_fstest auto quick mkfs
 IMG_SIZE="512M"
 IMG_FILE="$TEST_DIR/xfs_reproducible_test.img"
 PROTO_DIR="$TEST_DIR/proto"
+MNT_DIR="$TEST_DIR/mnt"
 
 # Fixed values for reproducibility
 FIXED_UUID="12345678-1234-1234-1234-123456789abc"
 FIXED_EPOCH="1234567890"
 
+rm -r -f "$MNT_DIR"
+mkdir -p "$MNT_DIR"
+
 _cleanup() {
 	cd /
 	command -v _kill_fsstress &>/dev/null && _kill_fsstress
-	rm -r -f $tmp.* "$PROTO_DIR" "$IMG_FILE"
+	rm -r -f $tmp.* "$PROTO_DIR" "$MNT_DIR" "$IMG_FILE"
 }
 
 # Check if mkfs.xfs supports required options
@@ -149,6 +153,22 @@ _run_iteration()
 	echo $hash
 }
 
+_test_iteration()
+{
+	local iteration=$1
+
+	echo "Iteration $iteration: Checking directory tree" >> $seqres.full
+	if ! _mount "$IMG_FILE" "$MNT_DIR"; then
+		echo "Failed to mount filesystem during iteration $iteration"
+		return
+	fi
+
+	diff -Naur --no-dereference "$PROTO_DIR" "$MNT_DIR" 2>/dev/null | \
+		grep -v -E '(special file|fifo|socket) while'
+
+	_unmount "$MNT_DIR"
+}
+
 # Create the prototype directory with various file types
 _create_proto_dir
 
@@ -157,12 +177,15 @@ echo "Test: XFS reproducible filesystem image creation"
 # Run three iterations
 hash1=$(_run_iteration 1)
 [ -z "$hash1" ] && _fail "Iteration 1 failed"
+_test_iteration 1
 
 hash2=$(_run_iteration 2)
 [ -z "$hash2" ] && _fail "Iteration 2 failed"
+_test_iteration 2
 
 hash3=$(_run_iteration 3)
 [ -z "$hash3" ] && _fail "Iteration 3 failed"
+_test_iteration 3
 
 # Verify all hashes match
 if [ "$hash1" = "$hash2" ] && [ "$hash2" = "$hash3" ]; then

