Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96042FBE1
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CS1A6oQf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05FCFC433C7;
	Sun, 31 Dec 2023 21:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059763;
	bh=p64KpcigM9if05gLOHitPzr5PqARFA7vcetQz767JG4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CS1A6oQfoaSkp/HvpJZ2TGO7t6BtAe2hKEFvxLNlbK9zub+JNv6/ttLSzSJLnnweO
	 g8EKOZ/tcepHQZiUAii+gVwQgclvnBzAUri9/xmDJZNnZuv/q+QId/P/pnSRewpiyG
	 Hvv/YQIB4rBsjS92Z+wkMhRU5eL3+3edBNQ8SIcTGyKXjoeWyVBBO45bVjpprMjeas
	 FW7xM/nneLOOBosPBrq+MhMWRVxSl0m/rLAslLQ9PjZho+l5/oAvJzSHxIJGYVXAJ4
	 PnHE6sKXJrtyBrlRF01j8ZiXDXn74QjHXaHuAXSR7YSpZbb7LWRq0PM1N95gvEA551
	 HVCo3nWtVwMoQ==
Date: Sun, 31 Dec 2023 13:56:02 -0800
Subject: [PATCH 44/44] xfs: enable realtime reflink
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404852287.1766284.966275252347175997.stgit@frogsfrogsfrogs>
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

Enable reflink for realtime devices, sort of.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_super.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index fbfd2963b2e2c..bf0c0ce9a54b9 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1728,14 +1728,27 @@ xfs_fs_fill_super(
 "EXPERIMENTAL realtime allocation group feature in use. Use at your own risk!");
 
 	if (xfs_has_reflink(mp)) {
-		if (mp->m_sb.sb_rblocks) {
+		/*
+		 * Reflink doesn't support rt extent sizes larger than a single
+		 * block because we would have to perform unshare-around for
+		 * rtext-unaligned write requests.
+		 */
+		if (xfs_has_realtime(mp) && mp->m_sb.sb_rextsize != 1) {
 			xfs_alert(mp,
-	"reflink not compatible with realtime device!");
+	"reflink not compatible with realtime extent size %u!",
+					mp->m_sb.sb_rextsize);
 			error = -EINVAL;
 			goto out_filestream_unmount;
 		}
 
-		if (xfs_globals.always_cow) {
+		/*
+		 * always-cow mode is not supported on filesystems with rt
+		 * extent sizes larger than a single block because we'd have
+		 * to perform write-around for unaligned writes because remap
+		 * requests must be aligned to an rt extent.
+		 */
+		if (xfs_globals.always_cow &&
+		    (!xfs_has_realtime(mp) || mp->m_sb.sb_rextsize == 1)) {
 			xfs_info(mp, "using DEBUG-only always_cow mode.");
 			mp->m_always_cow = true;
 		}

