Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06327F9;
	Mon,  1 Jan 2024 00:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="djlH5oof"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70683C433C7;
	Mon,  1 Jan 2024 00:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070382;
	bh=2Rc2nLnzg8//0iSKEFqfSst3P2h/y98MDXd5+yGNIdk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=djlH5oofdWNexzL41j2OiYRZ/QVdmUVBTxeSoAGV6t6YxVKtEFIGDXMBfzElk6/30
	 lAvwF8py4nroE37Dn5TRqUs80SYDKcy8sYZHWj8opPa00sY0ZF3vbC58Qaq+2oHwYT
	 HsS6YJkU9v4/v/4oEIVhrTpixvqOZhtYcy++kVzJb4JW5dENw12aDnWFEagN5/cjwZ
	 aPBbLCXSzNB8lAqY2hh8dfHTqwbQ9RQTUZZdUiDuoYuJri7ZPu4wviH1c8J/LRW6qf
	 AXhqUdSoIxPIBg2EI4hOq3lY54xIEk9YbhBX3aLHlFlRX4L6esLYA2MgLYb/cBQIBW
	 vvGmicH+ePeZg==
Date: Sun, 31 Dec 2023 16:53:02 +9900
Subject: [PATCH 01/17] common/populate: refactor caching of metadumps to a
 helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405030350.1826350.18345503384695892303.stgit@frogsfrogsfrogs>
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

Hoist out of _scratch_populate_cached all the code that we use to save a
metadump of the populated filesystem.  We're going to make this more
involved for XFS in the next few patches so that we can take advantage
of the new support for external devices in metadump/mdrestore.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/populate |   37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)


diff --git a/common/populate b/common/populate
index 83cd0eb5db..72c88e0651 100644
--- a/common/populate
+++ b/common/populate
@@ -1047,6 +1047,31 @@ _scratch_populate_restore_cached() {
 	return 1
 }
 
+# Take a metadump of the scratch filesystem and cache it for later.
+_scratch_populate_save_metadump()
+{
+	local metadump_file="$1"
+
+	case "${FSTYP}" in
+	"xfs")
+		local logdev=none
+		[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
+			logdev=$SCRATCH_LOGDEV
+
+		_xfs_metadump "$metadump_file" "$SCRATCH_DEV" "$logdev" \
+				compress
+		res=$?
+		;;
+	"ext2"|"ext3"|"ext4")
+		_ext4_metadump "${SCRATCH_DEV}" "${metadump_file}" compress
+		res=$?
+		;;
+	*)
+		_fail "Don't know how to save a ${FSTYP} filesystem."
+	esac
+	return $res
+}
+
 # Populate a scratch FS from scratch or from a cached image.
 _scratch_populate_cached() {
 	local meta_descr="$(_scratch_populate_cache_tag "$@")"
@@ -1070,26 +1095,20 @@ _scratch_populate_cached() {
 
 	# Oh well, just create one from scratch
 	_scratch_mkfs
-	echo "${meta_descr}" > "${populate_metadump_descr}"
 	case "${FSTYP}" in
 	"xfs")
 		_scratch_xfs_populate $@
 		_scratch_xfs_populate_check
-
-		local logdev=none
-		[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
-			logdev=$SCRATCH_LOGDEV
-
-		_xfs_metadump "$POPULATE_METADUMP" "$SCRATCH_DEV" "$logdev" \
-			compress
 		;;
 	"ext2"|"ext3"|"ext4")
 		_scratch_ext4_populate $@
 		_scratch_ext4_populate_check
-		_ext4_metadump "${SCRATCH_DEV}" "${POPULATE_METADUMP}" compress
 		;;
 	*)
 		_fail "Don't know how to populate a ${FSTYP} filesystem."
 		;;
 	esac
+
+	_scratch_populate_save_metadump "${POPULATE_METADUMP}" && \
+			echo "${meta_descr}" > "${populate_metadump_descr}"
 }

