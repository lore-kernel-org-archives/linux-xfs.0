Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3255B1BD032;
	Wed, 19 Feb 2025 00:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926674; cv=none; b=FbzXXMMSrpmZRh8W52nZ92nrFn5M7+gtI6ML2Hh0pvM0/vIWSOGqNVAEtSy0wD/+08Y7d0re0u8CSRx0Omb8Z/kDytxcoviZdiOt6IB4ZQsds5P+qJk6rEJJmOKQmdtCkGnhEtqdytT+6iRkQ+IBCTkaj4gMni5nrGgulVNlNc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926674; c=relaxed/simple;
	bh=BzCPVhmCynIFvMrGyXomsqViWIdLcJ2A4v2qde3RPA8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=brtjNwh7y/FBcIZSvO4eS2NGB96b2oJa7UqJHKtLFpYt3hZ/E2x7VzUA73hqcNcTqFT8p66fZPNW1T2F1/Qn8rn20guZ7XmeedIJeNJ8X1Do3O748lMloR+Kq5OXUA+DBHEAmEhsQESBpHjBSGgHTBIbHDUjhPsHL9eS5lVjdsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G40ZtAG6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G40ZtAG6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 963FCC4CEE2;
	Wed, 19 Feb 2025 00:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926673;
	bh=BzCPVhmCynIFvMrGyXomsqViWIdLcJ2A4v2qde3RPA8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=G40ZtAG6apsfhq4VEZs66jZAbWNCWilxLJLdlRlzl/tVhm26+pVeiWuA6sdcnQkzl
	 scWPKi/oRX0DZ9qcwZ01tMgMN8mmJV01oZu7TXVVgryJ/kEQA+xzdvxWEKQg5wzftK
	 m1BinnejX1tvZrT9EsXtwbIf4BHyVGZh46YfIOGbaX1cuh2Vb9HdFzv6gbd/bnU0RW
	 /rtXDsi3VGjDhI30SmydEavURRWwTYBsGIt/AUQIHCxAi60eRcuPR8w5S/ASPqJ0WO
	 p6+iV+igU6JAeIunC2FcZxBO8PFyQykl7nwT0ZKqQiH9B+7hiemGuis8rdnnAxLzk/
	 Pb+vEIaHEWfsQ==
Date: Tue, 18 Feb 2025 16:57:53 -0800
Subject: [PATCH 01/15] common/populate: refactor caching of metadumps to a
 helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992589198.4079457.6813508569185087856.stgit@frogsfrogsfrogs>
In-Reply-To: <173992589108.4079457.2534756062525120761.stgit@frogsfrogsfrogs>
References: <173992589108.4079457.2534756062525120761.stgit@frogsfrogsfrogs>
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
index 7690f269df8e79..627e8ca49694e7 100644
--- a/common/populate
+++ b/common/populate
@@ -1064,6 +1064,31 @@ _scratch_populate_restore_cached() {
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
@@ -1087,26 +1112,20 @@ _scratch_populate_cached() {
 
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

