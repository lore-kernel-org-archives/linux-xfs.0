Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D977BE47
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b3h9DCfz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97A7CC433C8;
	Sun, 31 Dec 2023 21:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059465;
	bh=ac7R9HhmFrwmG4ZLfYO90F2cm7LUO8fAaDCY7PoL/r4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=b3h9DCfztNdWEYIkQbSZHbbmaMMs70ki8kXl47QhgaQoYPTkSXVfKxJFmO8fNiCzV
	 2H+284yjIIOlUlNYSIvkYzlIso1YiUjUEQaMu6EdpEypxnXcpQY1EQBju4FZ/Eb+J2
	 pkpmGq6lv/rd0IJC31LxUpkkPe4qJlR9dzkIiR6k7i3tOSZOR1zdFjaRXXZMEFQq12
	 HZXPu8eliPbxsvlZhCjNkepv7lbv6hEKrNW7EkkitY1qBgYoPeZ5h7yumIDf2zsF1U
	 cmwNSMjurU+ZhBxJXl9UXNY2DdMwuyXVZ8BX/juwMgbee2CL5JIjLLIvriD/7eT2Ya
	 QftRcIN5vLw4w==
Date: Sun, 31 Dec 2023 13:51:05 -0800
Subject: [PATCH 25/44] xfs: enable extent size hints for CoW operations
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404851984.1766284.14375473929572405267.stgit@frogsfrogsfrogs>
In-Reply-To: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
References: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
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

Wire up the copy-on-write extent size hint for realtime files, and
connect it to the rt allocator so that we avoid fragmentation on rt
filesystems.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c |    8 +++++++-
 fs/xfs/xfs_bmap_util.c   |    5 ++++-
 2 files changed, 11 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 316b574b34b8a..41354bdbbc90f 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6407,7 +6407,13 @@ xfs_get_cowextsz_hint(
 	a = 0;
 	if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
 		a = ip->i_cowextsize;
-	b = xfs_get_extsz_hint(ip);
+	if (XFS_IS_REALTIME_INODE(ip)) {
+		b = 0;
+		if (ip->i_diflags & XFS_DIFLAG_EXTSIZE)
+			b = ip->i_extsize;
+	} else {
+		b = xfs_get_extsz_hint(ip);
+	}
 
 	a = max(a, b);
 	if (a == 0)
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index a7a99177bbf8b..60992f8e86adf 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -138,7 +138,10 @@ xfs_bmap_rtalloc(
 	bool			ignore_locality = false;
 	int			error;
 
-	align = xfs_get_extsz_hint(ap->ip);
+	if (ap->flags & XFS_BMAPI_COWFORK)
+		align = xfs_get_cowextsz_hint(ap->ip);
+	else
+		align = xfs_get_extsz_hint(ap->ip);
 retry:
 	prod = xfs_extlen_to_rtxlen(mp, align);
 	error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,

