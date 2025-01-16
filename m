Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501D81F55FF;
	Thu, 16 Jan 2025 23:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737070568; cv=none; b=d9Zb5rlpNF62SCQAWgTRImqvsQjYqC/LLeir2uN7UhFl0kMCOJG6/UCKXj/xqXvCqnq4/UCj5MotZvNwpqHX7GrlITN32+HEVVUNBqqax50invE7aQ+lMSynvCmYFu1eC52UwsXIlyHGpN3slmHCnxXq0ql2rrB9K92AAP/BnPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737070568; c=relaxed/simple;
	bh=sQN5jC6hMqKGwXcUtJCu4yR8YznzXedjrsTFwcWnhh8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FCC74fyVFeCtSa2NCaUE7VZCXX3kWhVRCXv9exTzLv5ss2wjg5fhs57eBuHmWP9SDDLb1mTQPb5PjbcrnAs+Q2v56YgX2iQdlJQEl9zW114pvDphCk0AFnu5W0+mP0IqzCFQPApCcDQ2vdVHlvJer1b1mrfHiYF3sYDEQy/z6/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cL2gkpFJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cL2gkpFJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEBDBC4CED6;
	Thu, 16 Jan 2025 23:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737070567;
	bh=sQN5jC6hMqKGwXcUtJCu4yR8YznzXedjrsTFwcWnhh8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cL2gkpFJ+uryP+Qmz0pqD88ae68fZIUCS3jjpCL90qy6ALX+6zCvzaOdFFYHqDmLI
	 qXNlTQyv9pxz/vfMeB7QoyG6gpTwmpNhEWLjiWiC/4q8t1HeOBtcyT1ZQtpTx1a2z5
	 erg8DKxW+DsyxbThDmqjKr/pNJmQQagbKqyUxwiEp9TIZmjdLplbusNKqhaZmdASX9
	 bqS1sSKitxq0Me4tpu9mOZaxEJRRA5R8BB4dKLQkfXpnSAoxAIDuzXMhynLvD/gtpW
	 uObJytyx0DuMpB/8BWulHkAe6nw+8dRGTnorRPb38nqJ0C7gKjT5PDcNfSF23yaV+z
	 JSC0MZfO2GpGg==
Date: Thu, 16 Jan 2025 15:36:07 -0800
Subject: [PATCH 04/14] common/ext4: reformat external logs during mdrestore
 operations
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706976124.1928798.14068806212309421064.stgit@frogsfrogsfrogs>
In-Reply-To: <173706976044.1928798.958381010294853384.stgit@frogsfrogsfrogs>
References: <173706976044.1928798.958381010294853384.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/ext4     |   17 ++++++++++++++++-
 common/populate |   18 +++++-------------
 2 files changed, 21 insertions(+), 14 deletions(-)


diff --git a/common/ext4 b/common/ext4
index 13921bb8165a4d..e1b336d3d20cba 100644
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
index 814f28a41c9bea..65fbd19b30e4e1 100644
--- a/common/populate
+++ b/common/populate
@@ -1021,20 +1021,12 @@ _scratch_populate_restore_cached() {
 		return $?
 		;;
 	"ext2"|"ext3"|"ext4")
-		_ext4_mdrestore "${metadump}" "${SCRATCH_DEV}"
-		ret=$?
-		test $ret -ne 0 && return $ret
+		local logdev=none
+		[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
+			logdev=$SCRATCH_LOGDEV
 
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

