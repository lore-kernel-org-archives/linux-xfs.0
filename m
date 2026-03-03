Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD851B4224
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 00:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772496917; cv=none; b=YdzwmCHQ6pqiRFzycKKsMh1rGaBGqthNgCLXG3Mdo0PpbLB210os26vc62Eikwy66HUshwgAEU+ODMfeuLBxK3EWesg1ET9SIU+GxHgIGHMBA9bJMRzWWtCK3zNbxQpHPRta8fBFabaF2neRmLHI/6aTRa9fu6fQ0BTnbUR4U5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772496917; c=relaxed/simple;
	bh=jyiQxv/VJ9m58SogDdLXQVr+NmV6Upp87DwV1OmClGY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SL8HjXKO93/g+lZ9v3IAEw0csPXSTzOW/T/l0a3W6uQ069An6gjLphMo1WthjeriYsxzKhhn7zTF+nlWPgWie6KJmHu6xv3J+CHl7B5w/DRcuFBjKuiqWxvdKeKGn5gq9qHttGpK0Xs4mgz/s4Ir46g3bl3x5L4a/E5vWetWd0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ov9pfYTP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ov9pfYTP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B2DEC19423;
	Tue,  3 Mar 2026 00:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772496917;
	bh=jyiQxv/VJ9m58SogDdLXQVr+NmV6Upp87DwV1OmClGY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ov9pfYTPYl80wG0RudYKetZheVDN0O26wMs9b8kYSGCAdy32olbXC+WQcstEbBMi5
	 LE3v4KxEX8+RQrzL+QtSsMIizSuS0M9B5025QRc4FZFkwbeoUT4UawfUQy+uNXYicv
	 JXIxwtIkJVKpaFi4PNmpozVkWnjqjk38WfZz0kuEFRZU2WdeTWK5eDrY6QC7lxvBVN
	 oyNiAyx6gKOtl529LmlZJ3wrb+Dpe9GgGrTdlVXJ3pdjJ1hFjYbTTuEn5IKneo+qAe
	 1MgkWAlhaaIrOkLYrzRg9RYa01tQAoBby7lOuiAVOeO9SFKrpvuXRn15Kf2gmv2n3m
	 AN9BViw4mt+9g==
Date: Mon, 02 Mar 2026 16:15:16 -0800
Subject: [PATCH 12/36] xfs: move struct xfs_log_iovec to xfs_log_priv.h
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177249637996.457970.5988457332713577268.stgit@frogsfrogsfrogs>
In-Reply-To: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
References: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 027410591418bded6ba6051151d88fc6fb8a7614

This structure is now only used by the core logging and CIL code.

Also remove the unused typedef.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 include/kmem.h            |    2 ++
 libxfs/xfs_log_format.h   |    7 -------
 libxlog/xfs_log_recover.c |    4 ++--
 3 files changed, 4 insertions(+), 9 deletions(-)


diff --git a/include/kmem.h b/include/kmem.h
index 66f8b1fbea8fdf..d66310ececec80 100644
--- a/include/kmem.h
+++ b/include/kmem.h
@@ -60,6 +60,8 @@ static inline void *kmalloc(size_t size, gfp_t flags)
 
 #define kzalloc(size, gfp)	kvmalloc((size), (gfp) | __GFP_ZERO)
 #define kvzalloc(size, gfp)	kzalloc((size), (gfp))
+#define kmalloc_array(n, size, gfp)	kvmalloc((n) * (size), (gfp))
+#define kcalloc(n, size, gfp)	kmalloc_array((n), (size), (gfp) | __GFP_ZERO)
 
 static inline void kfree(const void *ptr)
 {
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 908e7060428ccb..3f5a24dda90701 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -184,13 +184,6 @@ struct xlog_rec_header {
 #define XLOG_REC_SIZE_OTHER	offsetofend(struct xlog_rec_header, h_size)
 #endif /* __i386__ */
 
-/* not an on-disk structure, but needed by log recovery in userspace */
-struct xfs_log_iovec {
-	void		*i_addr;	/* beginning address of region */
-	int		i_len;		/* length in bytes of region */
-	uint		i_type;		/* type of region */
-};
-
 /*
  * Transaction Header definitions.
  *
diff --git a/libxlog/xfs_log_recover.c b/libxlog/xfs_log_recover.c
index 65e3c782d59674..af72b97d150b75 100644
--- a/libxlog/xfs_log_recover.c
+++ b/libxlog/xfs_log_recover.c
@@ -1112,8 +1112,8 @@ xlog_recover_add_to_trans(
 		}
 
 		item->ri_total = in_f->ilf_size;
-		item->ri_buf = kzalloc(
-			item->ri_total * sizeof(struct xfs_log_iovec), 0);
+		item->ri_buf = kcalloc(item->ri_total, sizeof(*item->ri_buf),
+				0);
 	}
 	ASSERT(item->ri_total > item->ri_cnt);
 	/* Description region is ri_buf[0] */

