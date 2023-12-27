Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26B0E7ED;
	Mon,  1 Jan 2024 00:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d0zhdxmH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95742C433C7;
	Mon,  1 Jan 2024 00:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070241;
	bh=uBUxT52TGiW08mXmtf7JvDkpoElO+sQ4NJECcdU7ghI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=d0zhdxmHGZghBP7CC+3oKr7vBpaqPk7+PhcXlCgPKC4g3cLLpQ9pJ6WxqsHT4yL2m
	 H2mVGNa7/2kIXj52UJW09Rw83xdZktORZiemVv8++RkuDkdhLXlyqJrZWzicRYxKmi
	 qEkc4J1JLhq+BXO0E3S2ngjcOd3Mo4M7+DUNU8JJ0HCdO2IRX63+aZH1NLHv2cGdxa
	 gzj31KhXz3UOnkW0j5hgcNWflkqML1Asu+aNQSVSf2otwcmNxd3GTjI6Zm2vqW/ZZy
	 DJ+3zFVDMtnyuDo6oVW8eSd2OXMe1Ib0TD0RNkj0lSMRBvpRVbJmJre3j/ocoGSwCW
	 uqPh4kSrk+X8Q==
Date: Sun, 31 Dec 2023 16:50:41 +9900
Subject: [PATCH 03/11] xfs/{030,033,178}: forcibly disable metadata directory
 trees
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405029889.1826032.5600296612089676416.stgit@frogsfrogsfrogs>
In-Reply-To: <170405029843.1826032.12205800164831698648.stgit@frogsfrogsfrogs>
References: <170405029843.1826032.12205800164831698648.stgit@frogsfrogsfrogs>
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

The golden output for thests tests encode the xfs_repair output when we
fuzz various parts of the filesystem.  With metadata directory trees
enabled, however, the golden output changes dramatically to reflect
reconstruction of the metadata directory tree.

To avoid regressions, add a helper to force metadata directories off via
MKFS_OPTIONS.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/xfs    |   13 +++++++++++++
 tests/xfs/030 |    1 +
 tests/xfs/033 |    1 +
 tests/xfs/178 |    1 +
 4 files changed, 16 insertions(+)


diff --git a/common/xfs b/common/xfs
index 48643b7c18..007c8704ce 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1871,3 +1871,16 @@ _scratch_xfs_find_metafile()
 	echo "${selector}"
 	return 0
 }
+
+# Force metadata directories off.
+_scratch_xfs_force_no_metadir()
+{
+	if echo "$MKFS_OPTIONS" | grep -q 'metadir='; then
+		MKFS_OPTIONS="$(echo "$MKFS_OPTIONS" | sed -e 's/metadir=\([01]\)/metadir=0/g')"
+		return
+	fi
+
+	if grep -q 'metadir=' $MKFS_XFS_PROG; then
+		MKFS_OPTIONS="-m metadir=0 $MKFS_OPTIONS"
+	fi
+}
diff --git a/tests/xfs/030 b/tests/xfs/030
index 201a901579..a62ea4fab3 100755
--- a/tests/xfs/030
+++ b/tests/xfs/030
@@ -50,6 +50,7 @@ _supported_fs xfs
 
 _require_scratch
 _require_no_large_scratch_dev
+_scratch_xfs_force_no_metadir
 
 DSIZE="-dsize=100m,agcount=6"
 
diff --git a/tests/xfs/033 b/tests/xfs/033
index ef5dc4fa36..e886c15082 100755
--- a/tests/xfs/033
+++ b/tests/xfs/033
@@ -53,6 +53,7 @@ _supported_fs xfs
 
 _require_scratch
 _require_no_large_scratch_dev
+_scratch_xfs_force_no_metadir
 
 # devzero blows away 512byte blocks, so make 512byte inodes (at least)
 _scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs >/dev/null
diff --git a/tests/xfs/178 b/tests/xfs/178
index fee1e92bf3..4e39cc364c 100755
--- a/tests/xfs/178
+++ b/tests/xfs/178
@@ -52,6 +52,7 @@ _supported_fs xfs
 #             fix filesystem, new mkfs.xfs will be fine.
 
 _require_scratch
+_scratch_xfs_force_no_metadir
 _scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs
 test "${PIPESTATUS[0]}" -eq 0 || _fail "mkfs failed!"
 

