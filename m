Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007577EE;
	Mon,  1 Jan 2024 00:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vszl8nv+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C65EAC433C8;
	Mon,  1 Jan 2024 00:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070413;
	bh=yRAYRi0EUX+qqBBfQYRD/fyQl7iv+0V5Flu3HuygC4I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Vszl8nv+74bud63cSE8+Z3o5cvcrzpOgehjEWfSiMfxzur/LQXa/9JIS7I7yFBrl5
	 KuTV2/SKZoRNZmAxNh7kjVA15MVf/nz8dQ8A3wD32+fPxSkNdU4GIpEKW4ggbQqe92
	 KP9kKahJMvJaLHD/PxRebNG+ORYY1OSsEX+57vl6155SS4ibwUgzgQy+mxlZ0ztxmo
	 OoI2GgJPoyXL/I8mXKMgSAhNxiFpEY8cI4wYuD5beD+95EDFg715uSDDmRA4rKdW7h
	 vKMYi3ALwKEjklROtgBu6ZVqQTwZvdosZr9t1nHfdC4C/vCMLITX8976XvrH5svU62
	 5ED9GnMRetLAw==
Date: Sun, 31 Dec 2023 16:53:33 +9900
Subject: [PATCH 03/17] common/ext4: reformat external logs during mdrestore
 operations
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405030376.1826350.13665269303629955348.stgit@frogsfrogsfrogs>
In-Reply-To: <170405030327.1826350.709349465573559319.stgit@frogsfrogsfrogs>
References: <170405030327.1826350.709349465573559319.stgit@frogsfrogsfrogs>
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

The e2image file format doesn't support the capture of external log
devices, which means that mdrestore ought to reformat the external log
to get the restored filesystem to work again.  The common/populate code
could already do this, so push it to the common ext4 helper.

While we're at it, fix the uncareful usage of SCRATCH_LOGDEV in the
populate code.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/ext4     |   17 ++++++++++++++++-
 common/populate |   16 ++--------------
 2 files changed, 18 insertions(+), 15 deletions(-)


diff --git a/common/ext4 b/common/ext4
index 3dcbfe17c9..5171b8df68 100644
--- a/common/ext4
+++ b/common/ext4
@@ -134,7 +134,8 @@ _ext4_mdrestore()
 {
 	local metadump="$1"
 	local device="$2"
-	shift; shift
+	local logdev="$3"
+	shift; shift; shift
 	local options="$@"
 
 	# If we're configured for compressed dumps and there isn't already an
@@ -148,6 +149,20 @@ _ext4_mdrestore()
 	test -r "$metadump" || return 1
 
 	$E2IMAGE_PROG $options -r "${metadump}" "${SCRATCH_DEV}"
+	res=$?
+	test $res -ne 0 && return $res
+
+	# ext4 cannot e2image external logs, so we have to reformat the log
+	# device to match the restored fs
+	if [ "${logdev}" != "none" ]; then
+		local fsuuid="$($DUMPE2FS_PROG -h "${SCRATCH_DEV}" 2>/dev/null | \
+				grep 'Journal UUID:' | \
+				sed -e 's/Journal UUID:[[:space:]]*//g')"
+		$MKFS_EXT4_PROG -O journal_dev "${logdev}" \
+				-F -U "${fsuuid}"
+		res=$?
+	fi
+	return $res
 }
 
 # this test requires the ext4 kernel support crc feature on scratch device
diff --git a/common/populate b/common/populate
index 92a3c5e354..450b024bfc 100644
--- a/common/populate
+++ b/common/populate
@@ -1021,20 +1021,8 @@ _scratch_populate_restore_cached() {
 		return $?
 		;;
 	"ext2"|"ext3"|"ext4")
-		_ext4_mdrestore "${metadump}" "${SCRATCH_DEV}"
-		ret=$?
-		test $ret -ne 0 && return $ret
-
-		# ext4 cannot e2image external logs, so we have to reformat
-		# the scratch device to match the restored fs
-		if [ -n "${SCRATCH_LOGDEV}" ]; then
-			local fsuuid="$($DUMPE2FS_PROG -h "${SCRATCH_DEV}" 2>/dev/null | \
-					grep 'Journal UUID:' | \
-					sed -e 's/Journal UUID:[[:space:]]*//g')"
-			$MKFS_EXT4_PROG -O journal_dev "${SCRATCH_LOGDEV}" \
-					-F -U "${fsuuid}"
-		fi
-		return 0
+		_ext4_mdrestore "${metadump}" "${SCRATCH_DEV}" "${logdev}"
+		return $?
 		;;
 	esac
 	return 1

