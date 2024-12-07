Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE420196
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733530383; cv=none; b=Xu9ms4YDht1fmG7kp5faoU5x8fgt/fXt4CDVV9qH7IwEdWXC32vuta76SY6Le3SebFe+KPMMXV4px/2f+98H/sYGIzhOgxK6BkqpcctFLdq5roAmnnkaORmF6dZ8fmjDhZ1AaEldfCmqzPzIe1/+ZB6bVWLm92diyqbzpWVupLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733530383; c=relaxed/simple;
	bh=9+vNyjRfu6Nk6M1rPu75Kfi4fOpRTaQAMpMfodyKZqc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UF2uBR+V20hVferW0nm03YKFDJ/Wxe1UvqaqSHdYrmi/dEexgmctELyP0GHMaTJkO5rF2b5TDkh0Rcz1db5nRXpWiDEF+ctv5bV+0Y9NL5kZdwRMnx3Xyzdj8Us3SNjJdQWUaIL4CYox3E7udXCfI1k7U1WEvwc1aVvuipR8BVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O3pVkIPU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O3pVkIPU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42A50C4CED1;
	Sat,  7 Dec 2024 00:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733530383;
	bh=9+vNyjRfu6Nk6M1rPu75Kfi4fOpRTaQAMpMfodyKZqc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=O3pVkIPUfcym4SfO5jz6niXZXVbTsSHMZrtLBgObpza7j+8sK8vPDY/ictMiNu34W
	 79Ol8YMcw7J5BZuxxtmzTtieoc6RWFhjPdfkX+7ibYUvNegtqfWVzGRZidAC3W31zR
	 417vkn59iPAp2ABETlQgFyOKHcQ5e812fzhYGXmcHCX63KNiU9wziOHVyw+QSzgHsE
	 EO/7lOJagIaDUoZe6CDNsqyFBRdrBQosbxGQkEOY43DVUq2rwzommv2v9OqatGeNQM
	 s7j20Wl0qTOzwpDosGcRGbeQ6pjDBo7k9HXf/Y2FKbVk0GjPfjHwuW227gt2rQ51dY
	 ls3cgGCv1lQmA==
Date: Fri, 06 Dec 2024 16:13:02 -0800
Subject: [PATCH 31/50] xfs_db: metadump metadir rt bitmap and summary files
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352752419.126362.2851932707470416639.stgit@frogsfrogsfrogs>
In-Reply-To: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Don't skip dumping the data fork for regular files that are marked as
metadata inodes.  This catches rtbitmap and summary inodes on rtgroup
enabled file systems where their inode numbers aren't recorded in the
superblock.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 db/metadump.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)


diff --git a/db/metadump.c b/db/metadump.c
index 144ebfbfe2a90e..8eb4b8eb69e45c 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2072,7 +2072,11 @@ process_bmbt_reclist(
 	xfs_agblock_t		agbno;
 	int			rval = 1;
 
-	if (btype == TYP_DATA)
+	/*
+	 * Ignore regular file data except for metadata inodes, where it is by
+	 * definition metadata.
+	 */
+	if (btype == TYP_DATA && !is_metadata_ino(dip))
 		return 1;
 
 	convert_extent(&rp[numrecs - 1], &o, &s, &c, &f);

