Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D5922339;
	Wed, 13 Nov 2024 01:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731461820; cv=none; b=hGnLZZQXH1SW2zKlbAI4i46uq5TIcwO/wDyZA+PiLefDQBGHxtFpsOXOEuhsO7UErOXL+ixmtCuL05kQ3z/23Wy6xr9P2U2eQdE3OSxEBKhbj7KovoGBc0w+i1G9USrPgETiQRWB0InP9+BjN0rvHtNkEiaMfyJaLaRFsM+cv4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731461820; c=relaxed/simple;
	bh=B5x//9Yga+V5I8YL0cuFp6K9+sqAou/XWkunOZKqWvo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=atlOThPXr1tnAQ64hQIKnIsdPDXxbqf3arzudGCeNMKehy8zlBwKIrjRLezPkwNvufkXJ/6f6+Epwaz+E1BD/ZU4MiUG0E8bUHfssSFkx4pPTDu0KBK2pJ4G+CbRRS2T8YbxG+RhEC7b7EbWxTNP+RR3WraEovuxapiAxSe9ps8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e5k+UkPF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e5k+UkPF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2371CC4CECD;
	Wed, 13 Nov 2024 01:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731461819;
	bh=B5x//9Yga+V5I8YL0cuFp6K9+sqAou/XWkunOZKqWvo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=e5k+UkPF24LjxsH37CXwcvH3c2M3aUGmqHQx5Ngc13HANwqNHpewqRMm1g9VR//gR
	 1Dc1NKHk7V0KQkIfETlwoByEh5Zz0fgMto9PK+pYqkLjxVqObXh8SdZVvcZD4QGJ8K
	 5QGcbkT3OMTZrRgYWAkIqi4ph2vjx73BnSNUQFZCpzAExvU2NRv6D1HsyrElJJqG5m
	 4sLYzmZFRY4ulSdzVp9QFJlFuVc0ZbXFAgIKC/u2KLjLBhdiq+6Sm55BIybjZ1AC+6
	 KjDFGr23dSQo6tO+tpxjtnqDsurdhwKhvDCK4lff0tdbBlbtyIR+z5Ad+aSPv7jB+O
	 vKpCRuDdHm72Q==
Date: Tue, 12 Nov 2024 17:36:58 -0800
Subject: [PATCH 1/3] xfs/273: check thoroughness of the mappings
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173146178829.156441.9898313568693484387.stgit@frogsfrogsfrogs>
In-Reply-To: <173146178810.156441.10482148782980062018.stgit@frogsfrogsfrogs>
References: <173146178810.156441.10482148782980062018.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Enhance this test to make sure that there are no gaps in the fsmap
records, and (especially) that they we report all the way to the end of
the device.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/273 |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)


diff --git a/tests/xfs/273 b/tests/xfs/273
index d7fb80c4033429..9f11540a77603d 100755
--- a/tests/xfs/273
+++ b/tests/xfs/273
@@ -24,6 +24,8 @@ _require_scratch
 _require_populate_commands
 _require_xfs_io_command "fsmap"
 
+_fixed_by_kernel_commit XXXXXXXXXXXXXX "xfs: fix off-by-one error in fsmap"
+
 rm -f "$seqres.full"
 
 echo "Format and mount"
@@ -37,6 +39,51 @@ cat $TEST_DIR/a $TEST_DIR/b >> $seqres.full
 
 diff -uw $TEST_DIR/a $TEST_DIR/b
 
+# Do we have mappings for every sector on the device?
+ddev_fsblocks=$(_xfs_statfs_field "$SCRATCH_MNT" geom.datablocks)
+rtdev_fsblocks=$(_xfs_statfs_field "$SCRATCH_MNT" geom.rtblocks)
+fsblock_bytes=$(_xfs_statfs_field "$SCRATCH_MNT" geom.bsize)
+
+ddev_daddrs=$((ddev_fsblocks * fsblock_bytes / 512))
+rtdev_daddrs=$((rtdev_fsblocks * fsblock_bytes / 512))
+
+ddev_devno=$(stat -c '%t:%T' $SCRATCH_DEV)
+if [ "$USE_EXTERNAL" = "yes" ] && [ -n "$SCRATCH_RTDEV" ]; then
+	rtdev_devno=$(stat -c '%t:%T' $SCRATCH_RTDEV)
+fi
+
+$XFS_IO_PROG -c 'fsmap -m -n 65536' $SCRATCH_MNT | awk -F ',' \
+	-v data_devno=$ddev_devno \
+	-v rt_devno=$rtdev_devno \
+	-v data_daddrs=$ddev_daddrs \
+	-v rt_daddrs=$rtdev_daddrs \
+'BEGIN {
+	next_daddr[data_devno] = 0;
+	next_daddr[rt_devno] = 0;
+}
+{
+	if ($1 == "EXT")
+		next
+	devno = sprintf("%x:%x", $2, $3);
+	if (devno != data_devno && devno != rt_devno)
+		next
+
+	if (next_daddr[devno] < $4)
+		printf("%sh: expected daddr %d, saw \"%s\"\n", devno,
+				next_daddr[devno], $0);
+		n = $5 + 1;
+		if (n > next_daddr[devno])
+		       next_daddr[devno] = n;
+}
+END {
+	if (data_daddrs != next_daddr[data_devno])
+		printf("%sh: fsmap stops at %d, expected %d\n",
+				data_devno, next_daddr[data_devno], data_daddrs);
+	if (rt_devno != "" && rt_daddrs != next_daddr[rt_devno])
+		printf("%sh: fsmap stops at %d, expected %d\n",
+				rt_devno, next_daddr[rt_devno], rt_daddrs);
+}'
+
 # success, all done
 status=0
 exit

