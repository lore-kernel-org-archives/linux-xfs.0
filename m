Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792787492;
	b=HOgzHuun6otN+5r9+UsONSgdQ0vnNzqb5X/r8L+jF5yl5QDbKxQ2D2+JgcfXy7oMzTcY
	 w060Fy245oRDx9m5cozR8D33IWEes51Di2iMVv53BS3i6qhTFvcoSYpu9830rntLXBWc5
	 qUT2DxNNY4oMeY39s/aNIVHwHWwWrcBC3fot3ztaYnSl4EsAQuwZy3KX0vPsVAMNHTeJf
	 +c2AJAAyEUZYjKArG69LoDm2UXqn42sKpX/4pW3vZOJUuzjZXXjc/8jvQwVIhPvtoS5jA
	 nfpsRzMoCOQp/J4GWVyYVPHoAvnu5IDtUBvB6/NQYx/73Ek88OEkWm/lmoraNDHg2sA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792787492;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=qgZzv4+qirlBrpUvWvXWovN179Bvr7/PUowNAdUnu4A=;
	b=KUpDyffBCF7EZCw48SnbaUCxKsw3bUHOf1igTYJaleg7TXJBcWJ0owKJwyVSIiiYdfpO
	 sQjWztXtkmi9ZBOkPokWzy3zJnigM1PhquevWwEOewJ3tiNP3+WsjN0Epss0yRexAkzg/
	 /9Lw4nSfKYVbiheCjuOFqxb73BeH8rAOkTK9/wvS8nWhnvtKxBmHwQfjRggPb1o7aNCHL
	 +yDhy0O6lddEu9gYqMpWOSu5/OcYpJmw/DH2md7q+3JFLvg7mXQmsDFIeoDoNkfVhp9y6
	 s0f60YjQa9y0p0MS7nm24PwhdShJFVQ0w5vMPNr+EUNag91Zg95jNUcYBynSeQBJtHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZAlDHhCE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ADAC606A31D;
	Fri, 23 Oct 2026 20:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZAlDHhCE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 551581F01829;
	Fri, 23 Oct 2026 20:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792787492;
	bh=qgZzv4+qirlBrpUvWvXWovN179Bvr7/PUowNAdUnu4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZAlDHhCE34TnHp0udAEJenbOYEBvZ2Wls5OqqoaGwd3UWo38LvgpOYuvsNp+rNPce
	 mMMOoy3MfmHEZyqazn9XTFO96D+8HWthY3ZjrPWNC6RDh0cnV/3mSmGU8mdKbZbnRX
	 jNkl6BtNkfaJka5JL5suTKnaY5WnWCr3oASbOZgdEe1Ipc1uolBfyN5WEvzGzupJ5u
	 S0cZzuVwvBNeX2u40A7ez/7XGjxajkfTvnEzyQ83ScnzEmrWWw9eJKiKEK/augYodD
	 NF+wiN8bUWhi/yRyKdOvAksYXyf5gWL3uGJOUCKQ3OuFLiIKh2a7hN2Ikwd+7RA0Er
	 nEjoEGpNbVOvg==
From: Zorro Lang <zlang@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	Anand Suveer Jain <asj@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v2 2/6] fstests: consolidate _require_fs_sysfs and _require_fs_sysfs_dev_attr
Date: Sat, 24 Oct 2026 04:31:10 +0800
Message-ID: <20261023203114.1655019-3-zlang@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261023203114.1655019-1-zlang@kernel.org>
References: <20261023203114.1655019-1-zlang@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is heavy overlap between _require_fs_sysfs and
_require_fs_sysfs_dev_attr, and their ambiguous names make it
difficult to tell them apart.

Teach _require_fs_sysfs_dev_attr to default to $TEST_DEV when only
an attribute is given, remove _has_fs_sysfs and _require_fs_sysfs,
and update their callers.

Signed-off-by: Zorro Lang <zlang@kernel.org>
---
 common/rc       | 44 +++++++++++++++-----------------------------
 common/xfs      |  4 ++--
 tests/btrfs/253 |  4 ++--
 tests/btrfs/285 |  2 +-
 tests/xfs/006   |  2 +-
 tests/xfs/177   |  2 +-
 tests/xfs/264   |  6 +++---
 7 files changed, 25 insertions(+), 39 deletions(-)

diff --git a/common/rc b/common/rc
index 43c95930..bcecaaeb 100644
--- a/common/rc
+++ b/common/rc
@@ -5545,43 +5545,29 @@ _has_fs_sysfs_dev_attr()
 }
 
 # Require the existence of a sysfs entry at /sys/fs/$FSTYP/$DEV/$ATTR
-# All arguments are necessary, and in this order:
+#
+# If only one argument is given, it is taken as the attribute under
+# $TEST_DEV.  Otherwise the arguments are, in this order:
 #  - dev: device name, e.g. $SCRATCH_DEV
 #  - attr: path name under /sys/fs/$FSTYP/$dev
 #
-# Usage example:
+# Usage examples:
+#   _require_fs_sysfs_dev_attr error/fail_at_unmount
 #   _require_fs_sysfs_dev_attr /dev/mapper/scratch-dev error/fail_at_unmount
 _require_fs_sysfs_dev_attr()
 {
-	_has_fs_sysfs_dev_attr "$@" && return
-
-	local dev=$1
-	local attr=$2
-	local dname=$(_fs_sysfs_dname $dev)
-
-	_notrun "This test requires /sys/fs/${FSTYP}/${dname}/${attr}"
-}
+	local dev attr
 
-# Test for the existence of a sysfs entry at /sys/fs/$FSTYP/DEV/$ATTR
-#
-# Only one argument is needed:
-#  - attr: path name under /sys/fs/$FSTYP/DEV
-#
-# Usage example:
-#   _has_fs_sysfs error/fail_at_unmount
-_has_fs_sysfs()
-{
-	_has_fs_sysfs_dev_attr $TEST_DEV "$@"
-}
-
-# Require the existence of a sysfs entry at /sys/fs/$FSTYP/DEV/$ATTR
-_require_fs_sysfs()
-{
-	_has_fs_sysfs "$@" && return
-
-	local attr=$1
-	local dname=$(_short_dev $TEST_DEV)
+	if [ $# -eq 1 ];then
+		dev=$TEST_DEV
+		attr=$1
+	else
+		dev=$1
+		attr=$2
+	fi
+	_has_fs_sysfs_dev_attr "$dev" "$attr" && return
 
+	local dname=$(_fs_sysfs_dname $dev)
 	_notrun "This test requires /sys/fs/${FSTYP}/${dname}/${attr}"
 }
 
diff --git a/common/xfs b/common/xfs
index 8bd144e3..cb0f6e0b 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1226,13 +1226,13 @@ _xfs_prepare_for_eio_shutdown()
 	_add_dmesg_filter "Internal error"
 
 	# Don't retry any writes during the (presumably) post-shutdown unmount
-	_has_fs_sysfs "$ctlfile" && _set_fs_sysfs_dev_attr $dev "$ctlfile" 1
+	_has_fs_sysfs_dev_attr $dev "$ctlfile" && _set_fs_sysfs_dev_attr $dev "$ctlfile" 1
 
 	# Disable retry of metadata writes that fail with EIO
 	for ctl in max_retries retry_timeout_seconds; do
 		ctlfile="error/metadata/EIO/$ctl"
 
-		_has_fs_sysfs "$ctlfile" && _set_fs_sysfs_dev_attr $dev "$ctlfile" 0
+		_has_fs_sysfs_dev_attr $dev "$ctlfile" && _set_fs_sysfs_dev_attr $dev "$ctlfile" 0
 	done
 }
 
diff --git a/tests/btrfs/253 b/tests/btrfs/253
index d8b58f49..5843643d 100755
--- a/tests/btrfs/253
+++ b/tests/btrfs/253
@@ -90,8 +90,8 @@ _scratch_mkfs_sized $((10 * 1024 * 1024 * 1024)) >> $seqres.full 2>&1
 _scratch_mount >> $seqres.full 2>&1
 
 # Check if there is sufficient sysfs support.
-_require_fs_sysfs allocation/metadata/chunk_size
-_require_fs_sysfs allocation/metadata/force_chunk_alloc
+_require_fs_sysfs_dev_attr allocation/metadata/chunk_size
+_require_fs_sysfs_dev_attr allocation/metadata/force_chunk_alloc
 
 # Get free space.
 free_space  FREE_SPACE_MB
diff --git a/tests/btrfs/285 b/tests/btrfs/285
index 5ceb69d4..6a1eb236 100755
--- a/tests/btrfs/285
+++ b/tests/btrfs/285
@@ -16,7 +16,7 @@ sysfs_size_classes() {
 
 _require_scratch
 _require_btrfs_fs_sysfs
-_require_fs_sysfs allocation/data/size_classes
+_require_fs_sysfs_dev_attr allocation/data/size_classes
 
 f="$SCRATCH_MNT/f"
 small=$((16 * 1024))
diff --git a/tests/xfs/006 b/tests/xfs/006
index e03ade1d..443e2db2 100755
--- a/tests/xfs/006
+++ b/tests/xfs/006
@@ -25,7 +25,7 @@ _cleanup()
 
 _require_scratch
 _require_dm_target error
-_require_fs_sysfs error/fail_at_unmount
+_require_fs_sysfs_dev_attr error/fail_at_unmount
 
 _scratch_mkfs > $seqres.full 2>&1
 _dmerror_init
diff --git a/tests/xfs/177 b/tests/xfs/177
index 38b68a7d..e9b4661d 100755
--- a/tests/xfs/177
+++ b/tests/xfs/177
@@ -48,7 +48,7 @@ _require_scratch
 
 # We require /sys/fs/xfs/$device/stats/stats to monitor per-filesystem inode
 # cache usage.
-_require_fs_sysfs stats/stats
+_require_fs_sysfs_dev_attr stats/stats
 
 count_xfs_inode_objs() {
 	_get_fs_sysfs_dev_attr $SCRATCH_DEV stats/stats | awk '/vnodes/ {print $2}'
diff --git a/tests/xfs/264 b/tests/xfs/264
index c8a2f714..0820eecd 100755
--- a/tests/xfs/264
+++ b/tests/xfs/264
@@ -24,9 +24,9 @@ _cleanup()
 
 _require_scratch
 _require_dm_target error
-_require_fs_sysfs error/fail_at_unmount
-_require_fs_sysfs error/metadata/EIO/max_retries
-_require_fs_sysfs error/metadata/EIO/retry_timeout_seconds
+_require_fs_sysfs_dev_attr error/fail_at_unmount
+_require_fs_sysfs_dev_attr error/metadata/EIO/max_retries
+_require_fs_sysfs_dev_attr error/metadata/EIO/retry_timeout_seconds
 
 _scratch_mkfs >> $seqres.full 2>&1
 _dmerror_init
-- 
2.55.0

