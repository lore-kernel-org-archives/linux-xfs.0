Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD9A2773CA
	for <linux-xfs@vger.kernel.org>; Tue, 23 Sep 2025 17:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758647338; cv=none; b=IbKuWJget+qu7SEUAckSmN4U+dTkg/i7mKMwhxFD5fjObJ5yZuDs6XeFoBU/PUjlejsF+g0ADeIN/NqFwDo1V1NB/pxohvHQTs+eLkGJW8M2nQGn80tQfchV8GEE5noyg3uH26N78eUqvQU5Z+hCJqf+pdgVB8tMMaTECZrZ+jU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758647338; c=relaxed/simple;
	bh=qGooegrrY0Q8csqdNrzLTH8HXbNUKeEVd7NRuIjk3Nw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=RrM7VEMqV8xoGy8xSIyc1wJt0BQdCNc4jH89ANck4WnTcLlax5GHYq6CRwM1FT+ih4oP8tvSFKy8xjNAGpCKHnyagEf/UUwbXdzFNkyozSCf998VD2xd8w0FbQxbXIrpDVDADjV3UCt7CrzhADqQ4sGuPhbaUQ4JksRPP5gLr1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ITY96uI7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ITY96uI7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A3EDC116C6;
	Tue, 23 Sep 2025 17:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758647338;
	bh=qGooegrrY0Q8csqdNrzLTH8HXbNUKeEVd7NRuIjk3Nw=;
	h=Date:From:To:Cc:Subject:From;
	b=ITY96uI7N5Ro4GNhFlxkt/JdnBKVsW3WW9uDwenQA7UVFhEqcvkbUh7sGY42HIfPA
	 cWVjAGbFO6y4YA2tBJ+EBTJD3lKEgPfyW6eK8kVys2Z5MIwhGiY+piFb2z8U6F8nOP
	 mvpeuBHZtd6Y6uBOfvBEr61xSjxoq75lfMsTxAt82w5M0q2R6brD/DZ6qfn+r8M8Iu
	 5YkDKS4eJC8skGI8qOz1Gm3SQMtSqpaost1bqQodG5BHifPwDThi7GXHNkDSHceO03
	 gt2Hq852dqdq9Sq9FwQhhrrmT629fKLyqv4Zus57rBmSXBHtOp3YForiPmB1+5UpFZ
	 ed2u6bcoYtUDw==
Date: Tue, 23 Sep 2025 10:08:57 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH 1/2] mkfs: fix libxfs_iget return value sign inversion
Message-ID: <20250923170857.GS8096@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

libxfs functions return negative errno, so utilities must invert the
return values from such functions.  Caught by xfs/437.

Fixes: 8a4ea72724930c ("proto: add ability to populate a filesystem from a directory")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 mkfs/proto.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mkfs/proto.c b/mkfs/proto.c
index bfeeb5ac638185..2b29240db95f74 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -1425,7 +1425,7 @@ handle_hardlink(
 	if (dst_ino == 0)
 		return false;
 
-	error = libxfs_iget(mp, NULL, dst_ino, 0, &ip);
+	error = -libxfs_iget(mp, NULL, dst_ino, 0, &ip);
 	if (error)
 		fail(_("failed to get inode"), error);
 
