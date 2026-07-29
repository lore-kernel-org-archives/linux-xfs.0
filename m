Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA6E4457B0
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 10:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785319598; cv=none; b=DIilzaG4wwG2nokXkD80VJx2VBLufJ/1WWraJGYjvpa6OkoujxWoY/cmQzz/kNcMnbflH3jz5XqmlydnYvOgK32RzMkWfkLuD6XPl2bIsedqbX4SLf9TWCxUP6M+nNVO8+BNjwqLByA7frIQo4hddVZPT809xJGYKdOvZx6MIWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785319598; c=relaxed/simple;
	bh=QTJrurmQAGy0VyhuEjNTg6N+BwJOYNAcK+d0WkSHwBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cFkdXWAxgwelpswY/SY18nAgebfQ5yUZbA5VNiA03adtAg0/XNs//WrwKdps8w2OEytN2KjVtYUZu2DD5g25W/zGazUOFLmj3s5QoPve6g4u5Tzgaf31qFV7dpuCDInDFASgOqdZwBOdVJske4uFz3Ye22ct+585dy7V/2IxxMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mXqamG4J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mXqamG4J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C54031F00A3D;
	Wed, 29 Jul 2026 10:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785319597;
	bh=PetFRr39qH3rKFLwi8HLfV1npmbFH7ri7h4tZylt2Vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mXqamG4JWI9llCNHzviU80JchXUyrOktTANTF/e8B9BwUWBAHAemT1ieCGnvnRdXZ
	 Au5GSYy59wjEBiAPnoZGDzFu9XW+nrvY7AchW1WeHIDUMUeX6G3nh4eZuoXS1hbbqa
	 qNvgUXHhnCOOkyI9/2iJ6gRpyVPNFMZrtKhqDIDPT1PS+i8iNpxH3BtDi2ex/hBgkD
	 ml/JKklX5MHE+8si31bss2iUg3v6NnrwBbSNpXlfRrwr0kJqyoiFoWzKvjmWf8MqEZ
	 j/Y1v9PZBe6h2AGWPhjPd31Fwi0wn13vfCl7nfJGKAXv1p4zCxoOlNR/13R2K5EccC
	 Ac1CNMP8Le0+w==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 02/33] xfs: fix isize update in xfs_iomap_write_unwritten to track conversion progress
Date: Wed, 29 Jul 2026 20:01:46 +1000
Message-ID: <20260729100629.1943710-3-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260729100629.1943710-1-dgc@kernel.org>
References: <20260729100629.1943710-1-dgc@kernel.org>
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

