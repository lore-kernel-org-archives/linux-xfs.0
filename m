Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C1C184
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610249; cv=none; b=S+KZr92iuvkJzgNFiytZPu5rFRvCGhdHLRBiUTWVZgbZmAV5Gs+78KDyQDXp8GLsBYaj9JjND4/v5m2F3TELtAN6PFsYMZy1se1DTfknj15j5bpFTPlQ9G9yb+Z6B8rNStq8ooUEivcRDFdVX3bElrXCcGnTT6YHWYEk7v4lmYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610249; c=relaxed/simple;
	bh=pxQNf8k3zSL8OO4iJj6by4h7lLBmFy5Pv4ogleYh0bs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k0URXJ5vfsHu7CYQIdzTKb5xyaF8ofJVNMZYwIdqNzWqOB0BytLaw20Dw2FxDWVszFJ/g9nEI9UQPLpPyAk/32ZlHCqgNn8KGiOCvW2ooREkGMmlgVrl9iXrezrhhAxc+LmyK7LXJpThBDOg/AY20g7VGgzPzmj5HT+zEWGQppM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uEk7pKCG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uEk7pKCG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C114C4CEC6;
	Fri, 11 Oct 2024 01:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610249;
	bh=pxQNf8k3zSL8OO4iJj6by4h7lLBmFy5Pv4ogleYh0bs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uEk7pKCGyugnK/2H7zaWsEGiAvOfPq3oi7mXJZGLeTSTlkIZLskWqVdYHAyMPX1bl
	 VnQQZru9wbZgVinAg+nWuT8JxNvgOo6Xi/o7d41fGw/bBzOlSLedzBF1Pg5G1b3EfZ
	 scdi5V32Y54lQMh8p+D9jQQQMQTB4PrI+PC0yZJAW8rf6uaB3WIHTPgvxTX3CKRX5z
	 9RYaamqOuZNV+tRpceAKqZ8LxKDyw/KMplYaptHNIhkzwJJ6a2EhDdVXiNXmnnnC+x
	 WQHd2yils5xeucF3twDPq7f0VFvqG7QgiXF19eIEao56Mv6+PLdGcQ2AJkdjLJSxoE
	 HnaarZZYcYMkg==
Date: Thu, 10 Oct 2024 18:30:49 -0700
Subject: [PATCH 24/43] xfs_db: metadump metadir rt bitmap and summary files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860655735.4184637.17017456039967884603.stgit@frogsfrogsfrogs>
In-Reply-To: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
References: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
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
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
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

