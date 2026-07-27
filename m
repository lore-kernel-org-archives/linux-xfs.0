Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71040233723;
	Mon, 27 Jul 2026 05:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785129921; cv=none; b=WNJlmPHlZhwtp9D0PZpcYt085G9QXLSoaYoA/YlO6lHwVD8cYnjFOJA5/qsKnknNh4n5B8X/U0KMP1wK/R0iojel3fnA5dReh9Cbd6mDpMLKbmJUrugnVIuzlR2sKctah2E2n4JtDxt/aNQEMEz0PwXxJmcqpR1qg9GEheBaEx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785129921; c=relaxed/simple;
	bh=+pnD+f+C85MEapbwXCo1cNj38dZv5Wqg7X7teK33KAM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g/2O9w15QknH3rRgxo9j5MDhJhTeXPG29UZj6CT5PqNRHnaFQQMH/wKysyFzmGelzKdxf7F9SVLWfoLyTkuaGbJlp9QfocJhC1Kw36RAmq3XgtFoNicqRBnXZfHoWlRPrfrRS/ySnkt0C1rvUqWkUZiegsM6fQC7XS3TwVglaZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fRpfI4Xg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fRpfI4Xg"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 190A71F000E9;
	Mon, 27 Jul 2026 05:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785129920;
	bh=OZkVlxGUu4t6bjfBrWtf5EV62GCWRr3mJRKjC8E755s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=fRpfI4Xg/Qj7/qoVvVRFevaVseclNV2LgQ4SpjpbySvcPo3VGG+GVc1KqcwPuSq3E
	 M/HilZPQPtpaexEMi4lQHBCb3EVrYI1dGERLcVI+wCJEYW9CtDnvTR0U1ToilQNyFS
	 iXpx96aAGK6VoVf6pufoKTbZbDNwciFteemUsUUv+6QzQLXvFfYqGfx5dTc/vXmCVC
	 9xmKlew133e45p6eQmwlAzXo1MjvqWayD2v3L1KN8Rw53JTIttpK8cRWrFouGhvF3g
	 6eqQlghRQAIXQx80guveCqKiEQAsfz5znJcEy3FN3/ysdbqwoo6Ql4Cg1jltt0o3Z4
	 kZ+hdm/zKvBuQ==
Date: Sun, 26 Jul 2026 22:25:19 -0700
Subject: [PATCH 04/10] xfs: load next_agino from the correct xfarray in
 xrep_iunlink_relink_prev
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178512389681.1495075.6487399026686955990.stgit@frogsfrogsfrogs>
In-Reply-To: <178512389537.1495075.1621818931849629575.stgit@frogsfrogsfrogs>
References: <178512389537.1495075.1621818931849629575.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM notices that xrep_iunlink_relink_prev has the comment "set the
forward pointer..." but then loads the value from the xfarray that
stores pointers to the previous inode in the unlinked list.  That's
wrong, so fix the variable access.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: ab97f4b1c03075 ("xfs: repair AGI unlinked inode bucket lists")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/agheader_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 39468b8fa9863d..5204eab09c6450 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -1619,7 +1619,7 @@ xrep_iunlink_relink_prev(
 		want_rele = true;
 
 		/* Set the forward pointer since this just came off disk. */
-		error = xfarray_load(ragi->iunlink_prev, agino, &next_agino);
+		error = xfarray_load(ragi->iunlink_next, agino, &next_agino);
 		if (error)
 			goto out_rele;
 

