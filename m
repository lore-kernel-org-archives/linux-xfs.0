Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365013E95A8;
	Wed, 21 Jan 2026 06:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768977640; cv=none; b=lr4RZU7QNbvrLcmX10a6lYyuQRgKWsZwI/KEoft5XXPkmqIDkramrUSyb8nJrraZ4jGKj6fUiqgffmHB0V/zOlc7lqDPrb/+E8frd3upq5r9N2jnG9C1jcldTpqWo6EKRMo0dKC20UV1wwCKp+H7w2vS4LNl+FrCV0VVaKNswOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768977640; c=relaxed/simple;
	bh=d/6/iYinb7sAPhU0dvqqknJM8zpV2fa2/H4wUNnso/4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JNA3voCQf0kjDa1Mezi9Q8T9gR2n16attT2k+Rif5ZRpnnn3CIjNnXhbmMwyYWPHBst+o3jnGv3Mo5l0vV9gRfJt0rucEPyUkXZ4ADBF8GsLjrDbo0XkNKfOESxmu07l72tX46rmMkgdnG2wrs7XHncpbda7RTI+nwxz+ABkwtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eHJOdCBi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eHJOdCBi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E61C116D0;
	Wed, 21 Jan 2026 06:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768977639;
	bh=d/6/iYinb7sAPhU0dvqqknJM8zpV2fa2/H4wUNnso/4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eHJOdCBii1WnbAQlBClp1bMSlqV+btHnwfGJ1+LUo0JMADIc/a/Bl4hIdxo2DF20x
	 Lu+mC+78j5blM6CZRYROoz+pMvdAVn2VHCOD+ZgvpDLawdZl4hxVwox15KB4ltJpUJ
	 wuS13d6MfVwilB8ur80H34nudw5mGzPclHPHaeJ/AvlKKaiosI1M+QgvED1Mek3HXU
	 e9vFzDqvlQnu/dhTxlU39rz+g3enh/Y9TGtrFQKYp1yb+VODmcRu+sWDsUErm79xjs
	 nHapFxbX217tqisR8WOXRG6bWSGxh0iOxatrGgSfjskw7Xglh0mBInmJ1twN68H0/i
	 kU/98ITXaJ7kA==
Date: Tue, 20 Jan 2026 22:40:39 -0800
Subject: [PATCH 2/4] xfs: only call xf{array,blob}_destroy if we have a valid
 pointer
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: r772577952@gmail.com, stable@vger.kernel.org, r772577952@gmail.com,
 hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <176897723586.207608.15038929489815852871.stgit@frogsfrogsfrogs>
In-Reply-To: <176897723519.207608.4983293162799232099.stgit@frogsfrogsfrogs>
References: <176897723519.207608.4983293162799232099.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Only call the xfarray and xfblob destructor if we have a valid pointer,
and be sure to null out that pointer afterwards.  Note that this patch
fixes a large number of commits, most of which were merged between 6.9
and 6.10.

Cc: r772577952@gmail.com
Cc: <stable@vger.kernel.org> # v6.12
Fixes: ab97f4b1c03075 ("xfs: repair AGI unlinked inode bucket lists")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/agheader_repair.c |    8 ++++++--
 fs/xfs/scrub/attr_repair.c     |    6 ++++--
 fs/xfs/scrub/dir_repair.c      |    8 ++++++--
 fs/xfs/scrub/dirtree.c         |    8 ++++++--
 fs/xfs/scrub/nlinks.c          |    3 ++-
 5 files changed, 24 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 8d7762cf5daffd..07fc028302dc40 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -837,8 +837,12 @@ xrep_agi_buf_cleanup(
 {
 	struct xrep_agi	*ragi = buf;
 
-	xfarray_destroy(ragi->iunlink_prev);
-	xfarray_destroy(ragi->iunlink_next);
+	if (ragi->iunlink_prev)
+		xfarray_destroy(ragi->iunlink_prev);
+	ragi->iunlink_prev = NULL;
+	if (ragi->iunlink_next)
+		xfarray_destroy(ragi->iunlink_next);
+	ragi->iunlink_next = NULL;
 	xagino_bitmap_destroy(&ragi->iunlink_bmp);
 }
 
diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
index 73684ce9b81bc5..ceae6eaf894535 100644
--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -1516,8 +1516,10 @@ xrep_xattr_teardown(
 		xfblob_destroy(rx->pptr_names);
 	if (rx->pptr_recs)
 		xfarray_destroy(rx->pptr_recs);
-	xfblob_destroy(rx->xattr_blobs);
-	xfarray_destroy(rx->xattr_records);
+	if (rx->xattr_blobs)
+		xfblob_destroy(rx->xattr_blobs);
+	if (rx->xattr_records)
+		xfarray_destroy(rx->xattr_records);
 	mutex_destroy(&rx->lock);
 	kfree(rx);
 }
diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index 50e0af4bdaa63a..ca841e445e2d9d 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -172,8 +172,12 @@ xrep_dir_teardown(
 	struct xrep_dir		*rd = sc->buf;
 
 	xrep_findparent_scan_teardown(&rd->pscan);
-	xfblob_destroy(rd->dir_names);
-	xfarray_destroy(rd->dir_entries);
+	if (rd->dir_names)
+		xfblob_destroy(rd->dir_names);
+	rd->dir_names = NULL;
+	if (rd->dir_entries)
+		xfarray_destroy(rd->dir_entries);
+	rd->dir_names = NULL;
 }
 
 /* Set up for a directory repair. */
diff --git a/fs/xfs/scrub/dirtree.c b/fs/xfs/scrub/dirtree.c
index 7f8ad41e3ec20e..4064d3f3dca09b 100644
--- a/fs/xfs/scrub/dirtree.c
+++ b/fs/xfs/scrub/dirtree.c
@@ -81,8 +81,12 @@ xchk_dirtree_buf_cleanup(
 		kfree(path);
 	}
 
-	xfblob_destroy(dl->path_names);
-	xfarray_destroy(dl->path_steps);
+	if (dl->path_names)
+		xfblob_destroy(dl->path_names);
+	dl->path_names = NULL;
+	if (dl->path_steps)
+		xfarray_destroy(dl->path_steps);
+	dl->path_steps = NULL;
 	mutex_destroy(&dl->lock);
 }
 
diff --git a/fs/xfs/scrub/nlinks.c b/fs/xfs/scrub/nlinks.c
index c71b065ccb4c45..d1ac39d7867a21 100644
--- a/fs/xfs/scrub/nlinks.c
+++ b/fs/xfs/scrub/nlinks.c
@@ -971,7 +971,8 @@ xchk_nlinks_teardown_scan(
 
 	xfs_dir_hook_del(xnc->sc->mp, &xnc->dhook);
 
-	xfarray_destroy(xnc->nlinks);
+	if (xnc->nlinks)
+		xfarray_destroy(xnc->nlinks);
 	xnc->nlinks = NULL;
 
 	xchk_iscan_teardown(&xnc->collect_iscan);

