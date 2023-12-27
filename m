Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E411370
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hOrUQSMg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47DDC433C7;
	Mon,  1 Jan 2024 00:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704069238;
	bh=H2k4WpSDyYe/KlIMMFWqsWiEVBE8xBW29x+IshJ7pgY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hOrUQSMgvdWKrPg4AYu9TXU4HBiVDEowwEY8zlVrEFWdcqKTZQshGtbSJbdimSy/z
	 ZZpnlRuKF0fJtLyaHVSs04RvGrQ2jjHsA75Vjq47IEaocuIEb9akuvHrXlE1sbj9MG
	 g2eeuTzn0hFJj8ttv2ph1ZzCL+qS7TArNq2EY5tvALkY4Jx5dQWULUMU70ftpE/tdY
	 IvF9QweFOQgZNCyFwhli1Yd58HqEjr1CpYxIx1nhyGbT2ChpLSiYWcGyGcKQupGQwN
	 hdhU9LD3NCjctz90U65XTR/58H2sw2wE7nou4GeGnjOsG0xt+N17EOHjmlt3WRba4u
	 H16O7f7keWGAA==
Date: Sun, 31 Dec 2023 16:33:58 +9900
Subject: [PATCH 30/42] xfs_repair: allow CoW staging extents in the realtime
 rmap records
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405017526.1817107.5191304566872191050.stgit@frogsfrogsfrogs>
In-Reply-To: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
References: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
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

Don't flag the rt rmap btree as having errors if there are CoW staging
extent records in it and the filesystem supports.  As far as reporting
leftover staging extents, we'll report them when we scan the rt refcount
btree, in a future patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/scan.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)


diff --git a/repair/scan.c b/repair/scan.c
index ba634af8bb1..f04afff60ef 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -1416,9 +1416,20 @@ _("invalid length %llu in record %u of %s\n"),
 			continue;
 		}
 
-		/* We only store file data and superblocks in the rtrmap. */
-		if (XFS_RMAP_NON_INODE_OWNER(owner) &&
-		    owner != XFS_RMAP_OWN_FS) {
+		/*
+		 * We only store file data, COW data, and superblocks in the
+		 * rtrmap.
+		 */
+		if (owner == XFS_RMAP_OWN_COW) {
+			if (!xfs_has_reflink(mp)) {
+				do_warn(
+_("invalid CoW staging extent in record %u of %s\n"),
+						i, name);
+				suspect++;
+				continue;
+			}
+		} else if (XFS_RMAP_NON_INODE_OWNER(owner) &&
+			   owner != XFS_RMAP_OWN_FS) {
 			do_warn(
 _("invalid owner %lld in record %u of %s\n"),
 				(long long int)owner, i, name);

