Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA31C1362
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LzeJ5kK5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B8B0C433C8;
	Mon,  1 Jan 2024 00:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704069348;
	bh=ZjgH1f6Qu2iiyICfPQHqawq48sY/7vzT1fk96VC//+E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LzeJ5kK5tI42eK1Ge6sDtEc8ZY06J0S6qdbxr46XaGwo/E8zrdY/mGVgmom120STu
	 QPZpmaHa+LcYAfWwwzX2kU3ZUG394meeNfKq/4x/4zEcDpLf9PkaN3MdgqR2CrW4Pn
	 JLpazxbu0ykl8sYpmbm5c3fM3Gv61nCQq9O2+GvlJqrsiuci2PEynxpe6IGYrUJXxi
	 Q2GIHpCyN0qsXf9m2ktL5Q/U+SMw5d6OR9zlRj27UB0LoOKMc+GD1PatDr/24Y7NWx
	 2ja53E0LVnqCjsNU9OJp0AHLuU0hmJ3jSZermNzggey3ModfABxQZMyliBuMXzRzwV
	 aZchbz1NwTuCg==
Date: Sun, 31 Dec 2023 16:35:47 +9900
Subject: [PATCH 37/42] xfs_repair: allow realtime files to have the reflink
 flag set
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405017621.1817107.12602990400083753927.stgit@frogsfrogsfrogs>
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

Now that we allow reflink on the realtime volume, allow that combination
of inode flags if the feature's enabled.  Note that we now allow inodes
to have rtinherit even if there's no realtime volume, since the kernel
has never restricted that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dinode.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index f0c0ba4da4e..2b254b29c4a 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -3199,7 +3199,8 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 		}
 
 		if ((flags2 & XFS_DIFLAG2_REFLINK) &&
-		    (flags & (XFS_DIFLAG_REALTIME | XFS_DIFLAG_RTINHERIT))) {
+		    !xfs_has_rtreflink(mp) &&
+		    (flags & XFS_DIFLAG_REALTIME)) {
 			if (!uncertain) {
 				do_warn(
 	_("Cannot have a reflinked realtime inode %" PRIu64 "\n"),
@@ -3231,7 +3232,8 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 		}
 
 		if ((flags2 & XFS_DIFLAG2_COWEXTSIZE) &&
-		    (flags & (XFS_DIFLAG_REALTIME | XFS_DIFLAG_RTINHERIT))) {
+		    !xfs_has_rtreflink(mp) &&
+		    (flags & XFS_DIFLAG_REALTIME)) {
 			if (!uncertain) {
 				do_warn(
 	_("Cannot have CoW extent size hint on a realtime inode %" PRIu64 "\n"),

