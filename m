Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535907ED;
	Mon,  1 Jan 2024 01:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OR4LtUq3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC36C433C7;
	Mon,  1 Jan 2024 01:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070805;
	bh=aatZZfEshMVICDl/LR2THfmIvimPMuKO3zsT1Z6FkzE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OR4LtUq3oAvhnrvQsNQRbX1a7eSeXoh+loqEFM92OVfu72RAI5NHRITrziVqpY3d8
	 cQXEoUoz4NwssuCTuvOAVGxoLBJUDxOR1ePfVITuad9HuoAS2zAgFGKsxzpGpqnMiM
	 T9dHH3OQOIanmU0fjPzPWs6+Un82vbLXHO5Uc4Bzh2KftGfx5mkCwAWCjxZyYIA0b5
	 poGDbZ12eR+jyiuiv9xxgyE3/pgrgsP85ApiFVq2LKg2MygIQUqzlKlGrd7BPOzX+d
	 v9KSJjvZKWUERcQgW30oNMZd0VcgkVvJ/FScp0j9CRcGUElsv5i87T0AdYx52VpbHv
	 7us0BKLkX1+3w==
Date: Sun, 31 Dec 2023 17:00:04 +9900
Subject: [PATCH 09/13] xfs: skip tests if formatting small filesystem fails
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405031352.1826914.14947870409708728287.stgit@frogsfrogsfrogs>
In-Reply-To: <170405031226.1826914.14340556896857027512.stgit@frogsfrogsfrogs>
References: <170405031226.1826914.14340556896857027512.stgit@frogsfrogsfrogs>
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

There are a few tests that try to exercise XFS functionality with an
unusually small (< 500MB) filesystem.  Formatting can fail if the test
configuration also specifies a very large realtime device because mkfs
hits ENOSPC when allocating the realtime metadata.  The test proceeds
anyway (which causes an immediate mount failure) so we might as well
skip these.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/104 |    1 +
 tests/xfs/291 |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/104 b/tests/xfs/104
index d16f46d8e4..c3d1d18a58 100755
--- a/tests/xfs/104
+++ b/tests/xfs/104
@@ -16,6 +16,7 @@ _create_scratch()
 {
 	echo "*** mkfs"
 	_scratch_mkfs_xfs $@ | tee -a $seqres.full | _filter_mkfs 2>$tmp.mkfs
+	test "${PIPESTATUS[0]}" -eq 0 || _notrun "formatting small scratch fs failed"
 	. $tmp.mkfs
 
 	echo "*** mount"
diff --git a/tests/xfs/291 b/tests/xfs/291
index 600dcb2eba..70e5f51cee 100755
--- a/tests/xfs/291
+++ b/tests/xfs/291
@@ -18,7 +18,8 @@ _require_command "$XFS_MDRESTORE_PROG" "xfs_mdrestore"
 # real QA test starts here
 _require_scratch
 logblks=$(_scratch_find_xfs_min_logblocks -n size=16k -d size=133m)
-_scratch_mkfs_xfs -n size=16k -l size=${logblks}b -d size=133m >> $seqres.full 2>&1
+_scratch_mkfs_xfs -n size=16k -l size=${logblks}b -d size=133m >> $seqres.full 2>&1 || \
+	_notrun "formatting small scratch fs failed"
 _scratch_mount
 
 # First we cause very badly fragmented freespace, then

