Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39DD1F91F6
	for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2026 00:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787098493; cv=none; b=OQH72RRKbBWU55sYFWGEn/EJuwLIr9aYFcmWf88ZCuwT73SpPjy5mgzoD6Zy1rkKvTGHF7Vtu9xYJBn+qh46kg3tP8u69xHx1Dg3PiIgJAEZrJ7eX5Ohcj30YbVg127UV7HuC7yCZJUJlX3y3xpWG1MHoZ6CNjcXhFNkc0MVgjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787098493; c=relaxed/simple;
	bh=QTJrurmQAGy0VyhuEjNTg6N+BwJOYNAcK+d0WkSHwBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M4Dn2ghc1PZqgk/IwD5ZbZ6yQTOhK7DgszVagh6B49qgZR/LymLDAwVLyLpQyIQhM+wBHdzdUxom2dLAYcM508SIyOZKNPnPRT1377XQJBHp+Ox7gPKEIr6t6tmztYZE85sD8CG0Eb1Xm+JH7r9QKjsoxIlCx8s9vA+qaSZmPBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TII4JUMq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TII4JUMq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C5B1F00A3E;
	Wed, 19 Aug 2026 00:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787098491;
	bh=PetFRr39qH3rKFLwi8HLfV1npmbFH7ri7h4tZylt2Vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TII4JUMqoMwY/WNcaJKQhhPvGZaLpLnG4ZJx76+zBmQKKFLiGLuiO5P6XvoBuyHDn
	 mhjGq7zxhc3yNE1XzN6sBRq51SsoyD92hPd+Jq/BwdnuvIywJvXeCb0CzHpf1GvqoU
	 SLEJx7F56FmjNJo3ArSPzvhcrBQp7MuM979xeAea1jSaEYLuu+5Hzha4UbSiIDQzY/
	 FBSalWQsGNJBd3081JBIYyA6Ul2RSEhtspOaLcWfZ+sWrFtXkchIs4lHR9JAACLFL0
	 iy1K43zJr/5oxFgnMQaAUMsGq/pdXJs4I55G9kRnz3VgF3CqwkWRcmHnZboiLxsSKY
	 rJCYBZe7SyVlg==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 03/38] xfs: fix isize update in xfs_iomap_write_unwritten to track conversion progress
Date: Wed, 19 Aug 2026 10:12:06 +1000
Message-ID: <20260819001442.1451892-4-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260819001442.1451892-1-dgc@kernel.org>
References: <20260819001442.1451892-1-dgc@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs_iomap_write_unwritten() updates i_disk_size using the end of
the entire unwritten range (offset_fsb + count_fsb) rather than the
end of the extent that was actually converted in each iteration
(imap.br_startoff + imap.br_blockcount).

If the conversion requires multiple iterations and a crash occurs
partway through, recovery would replay the first transaction which
set i_disk_size to the end of the full range. This exposes
unwritten extents to userspace reads as zeroes rather than the
data that was written, because those extents have not yet been
converted from unwritten to written state.

Fix this by computing i_size from the extent that was actually
converted (imap), so i_disk_size advances incrementally as each
extent is converted. On crash, recovery only exposes data in
extents that have been both written and converted.

Fixes: 84803fb78237 ("xfs: log file size updates as part of unwritten extent conversion")
Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_iomap.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 225c3de88d03..1437ea93563c 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -682,11 +682,15 @@ xfs_iomap_write_unwritten(
 			goto error_on_bmapi_transaction;
 
 		/*
-		 * Log the updated inode size as we go.  We have to be careful
-		 * to only log it up to the actual write offset if it is
-		 * halfway into a block.
+		 * Update the inode size to reflect the extent that was
+		 * converted in this iteration. We must not advance isize
+		 * beyond the extent we just converted, otherwise a crash
+		 * before the next conversion exposes unwritten extents
+		 * (zeroes) to userspace instead of the written data.
+		 * Clamp to the byte-level write end in case the converted
+		 * extent extends past the write boundary.
 		 */
-		i_size = XFS_FSB_TO_B(mp, offset_fsb + count_fsb);
+		i_size = XFS_FSB_TO_B(mp, imap.br_startoff + imap.br_blockcount);
 		if (i_size > offset + count)
 			i_size = offset + count;
 		if (update_isize && i_size > i_size_read(inode))
-- 
2.55.0

