Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A09617996;
	Fri, 11 Oct 2024 01:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610875; cv=none; b=gYHoRUCDk/MeE0ABGqbHWzjlDZqBJKBTZ4lcHtZOTgY6bs7BhGLGAfWyVot501lfWAlYBy+QUT8q/Rn89UUTlMgaI7CQ6GOKVQwbGE2raBI6kbBOMiPK2fZbVvvGVEhiqvOmVRkyXm4gYVA3sXUrdWpOSNV7pm45HqDorNnCMNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610875; c=relaxed/simple;
	bh=T6Fq01nqQ+Vr2QikU9vgLJPpls4sx2S2IwZMmVGGoKY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qer+So5y2Sd8PefbQ6Y4Ha9vvvwrkGN3tmswegMZJKYndHq6hgUdeERA9VqoHY9H4KQw+iwjUkqAPFKCiCd4ved4z2LsN7GWBmw7Bqy3PFP8gxlOc9CDcaxuHSINxVxw6XzH/C6VYU37ox4lL00O54QQLlhfX/RLPeRkuOl+gBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ITdpdOL2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ITdpdOL2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD1DEC4CEC5;
	Fri, 11 Oct 2024 01:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610874;
	bh=T6Fq01nqQ+Vr2QikU9vgLJPpls4sx2S2IwZMmVGGoKY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ITdpdOL2Gg8EIAZkbGheeiE3imK2OUCdTR5XCTFjORlaKhTzVIiF5Oz8jPZz/MWWT
	 VjwJMti2CA3Yybk62TY8UdBxHCXYTGSLDq7SELjoD0KxqhLkphDJAABzVEC4Md5j/S
	 GMSe5vzXZZswsvBJJ2VupD3Qn14LHYJjOucuHLMOoTw2tV5/dP6pO6G/0rM3HsegYD
	 ryXIxfum3cFtUP/9VO7+lCpDwc2Dbsssv5v6jtTWTQlXxSAC3OTW5gifQxoqdPTOBd
	 EMrYhHr7pTDLsYm6NOjFoyZ8eFtAzsODnbYbb6Sany4FmL2D34heZwYDh7BTBaa25p
	 qTU5xTgmu0Law==
Date: Thu, 10 Oct 2024 18:41:14 -0700
Subject: [PATCH 01/16] common/populate: refactor caching of metadumps to a
 helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, fstests@vger.kernel.org
Message-ID: <172860658537.4188964.6014680692584448519.stgit@frogsfrogsfrogs>
In-Reply-To: <172860658506.4188964.2073353321745959286.stgit@frogsfrogsfrogs>
References: <172860658506.4188964.2073353321745959286.stgit@frogsfrogsfrogs>
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
index 88c8ba2b32767c..82f526dcf9e2d5 100644
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

