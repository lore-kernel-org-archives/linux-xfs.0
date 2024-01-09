Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A1536AFD;
	Tue,  9 Jan 2024 10:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XcID1vEN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC119C433A6;
	Tue,  9 Jan 2024 10:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704795676;
	bh=u4HHZ3AFHL7gMnlhFkwiY14aNOdvq20liB4pGJr3ARw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XcID1vENcH4PU30xKUZSTh28ZGN+UYU3qDmH0EFAtIt222heWLkYfj7tp63bLF3uA
	 uMF2nQetoZquEh4BEBgfds3ag/jJCOabiGSr6mYZNR3663rO5o/V0pVex7h7OyMg3m
	 eDMdXwFE4KadaBEJOgNzPbdvBYk4t9X4Lr1D/QEegLLDneeOIbJjV7zRJdxKXWVpOZ
	 X9inart7nuT6TQWe/UrwaNu+QIV0UaOk5uoamH3lYf7oYubvJJW1JS6xzxrKcniyrQ
	 dlVfkKCfZYsSz9lrVVfV6VvnVqLZuANUF4EyZZTIXlFMDjUToPEUOmUoo7REjEsc7A
	 NCTyP/qND0axw==
From: Chandan Babu R <chandanbabu@kernel.org>
To: fstests@vger.kernel.org
Cc: Chandan Babu R <chandanbabu@kernel.org>,
	linux-xfs@vger.kernel.org,
	djwong@kernel.org,
	zlang@redhat.com
Subject: [PATCH V2 3/5] _scratch_xfs_mdrestore: Pass scratch log device when applicable
Date: Tue,  9 Jan 2024 15:50:45 +0530
Message-ID: <20240109102054.1668192-4-chandanbabu@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240109102054.1668192-1-chandanbabu@kernel.org>
References: <20240109102054.1668192-1-chandanbabu@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Metadump v2 supports dumping contents of an external log device. This commit
modifies _scratch_xfs_mdrestore() and _xfs_mdrestore() to be able to restore
metadump files which contain data from external log devices.

The callers of _scratch_xfs_mdrestore() must set the value of $SCRATCH_LOGDEV
only when all of the following conditions are met:
1. Metadump is in v2 format.
2. Metadump has contents dumped from an external log device.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 common/xfs | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/common/xfs b/common/xfs
index fc744489..070680d8 100644
--- a/common/xfs
+++ b/common/xfs
@@ -682,7 +682,8 @@ _xfs_metadump() {
 _xfs_mdrestore() {
 	local metadump="$1"
 	local device="$2"
-	shift; shift
+	local logdev="$3"
+	shift; shift; shift
 	local options="$@"
 
 	# If we're configured for compressed dumps and there isn't already an
@@ -695,6 +696,10 @@ _xfs_mdrestore() {
 	fi
 	test -r "$metadump" || return 1
 
+	if [ "$logdev" != "none" ]; then
+		options="$options -l $logdev"
+	fi
+
 	$XFS_MDRESTORE_PROG $options "${metadump}" "${device}"
 }
 
@@ -722,8 +727,18 @@ _scratch_xfs_mdrestore()
 {
 	local metadump=$1
 	shift
+	local logdev=none
+	local options="$@"
 
-	_xfs_mdrestore "$metadump" "$SCRATCH_DEV" "$@"
+	# $SCRATCH_LOGDEV should have a non-zero length value only when all of
+	# the following conditions are met.
+	# 1. Metadump is in v2 format.
+	# 2. Metadump has contents dumped from an external log device.
+	if [ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ]; then
+		logdev=$SCRATCH_LOGDEV
+	fi
+
+	_xfs_mdrestore "$metadump" "$SCRATCH_DEV" "$logdev" "$@"
 }
 
 # Do not use xfs_repair (offline fsck) to rebuild the filesystem
-- 
2.43.0

