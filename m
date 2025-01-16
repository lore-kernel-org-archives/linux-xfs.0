Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD3F1F3FD5;
	Thu, 16 Jan 2025 23:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737070521; cv=none; b=LOcLOs+TGsg1+tfu+AjD2Ei3nGs1gmIO4DOlO7Vs/Es8KxYPkRQTig7OGTCTckC6Dg1QW5qGMEPibioeaBZHQtBx5S53WpepQ2b24sbeUKHtT6mDVF95qaw/PRNCUmAaUfoX9KT7/Iz9S6Hv1MPM0gZoTv+ZHgbKbbnZTpOiSoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737070521; c=relaxed/simple;
	bh=gRf4MxVnHddUnc4UV+EqKuTeS7NKEjOCvLesxG8DCRA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qjcVyAz91FAAqc0GPsjNuxsUmA6syOYdKgsUkSJeXNeJ0TWrf6JyaIzhlNNw6jrS20KvNWlahLbfHOfkALLNuIyQxAGBo16U13oy6Qi4L074yDKx84mN/tOmvMEFhAeyn13gyhLSIoKQFqnYts2tQBvVoOgNqWDZd1pPXCghrxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N+5P48vq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N+5P48vq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4F5AC4CED6;
	Thu, 16 Jan 2025 23:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737070520;
	bh=gRf4MxVnHddUnc4UV+EqKuTeS7NKEjOCvLesxG8DCRA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=N+5P48vqB4iKL/Othh7lJ7OdFkLRb5kBdRiskE9fXmE9Uj4kgmuX8p7YVfHsr+hlT
	 Hl9TIKa0VJ+TWjQ+K+l8arPoyuK0s22/sQRIhphT7/vRGss0VQsLb++G+k7XpGjWOE
	 1tIFapQHZJuKcCCdo+SsWo7GeattY0U0WEU71tLq0M5swb/wRCTJIldqiLP8YBK4Hn
	 kilNyxGazUs2xp7FcevySxQF3ho59R6izyItSkKieprU7SlRsZS+DNItSQhdnm1BIs
	 iigeuK/4nrC4X2V0AQEzxRwoGi0CRiP18FYsZ8nUfO10vphm+3AhDVsweCXSUzBZz1
	 wBfAFSFTEfq2A==
Date: Thu, 16 Jan 2025 15:35:20 -0800
Subject: [PATCH 01/14] common/populate: refactor caching of metadumps to a
 helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706976078.1928798.12300798830762503667.stgit@frogsfrogsfrogs>
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

Hoist out of _scratch_populate_cached all the code that we use to save a
metadump of the populated filesystem.  We're going to make this more
involved for XFS in the next few patches so that we can take advantage
of the new support for external devices in metadump/mdrestore.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/populate |   37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)


diff --git a/common/populate b/common/populate
index 4cf9c0691956a3..4cc4415697ac78 100644
--- a/common/populate
+++ b/common/populate
@@ -1051,6 +1051,31 @@ _scratch_populate_restore_cached() {
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
+				compress -a -o
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
@@ -1074,26 +1099,20 @@ _scratch_populate_cached() {
 
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
-			compress -a -o
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

