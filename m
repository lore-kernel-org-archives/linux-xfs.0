Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640227C083
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 23:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713395664; cv=none; b=tVMq6sq2iQkr+Gs5qxo+Au4nbJyxqxEQoJ/TPaLVqLyf28abZIvGeZN2wLmgqkPfyNDwa+ZYXlsK/SUqY02PFQQmWrd+4yMQ5iVxbh+SrXjL40VnAlgQU/552CYKv6J5SFbdq3gt9tTS8m7SdWuT4JlBr6+XQkFGBQIRaYmqWoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713395664; c=relaxed/simple;
	bh=Ofps2Qi4ZjI0rMK7wZwOyKRuxvZ3GjGvTs9Ive8i1E0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tba0gWlCebDfy8ipFPBW32SdLG3qHWfZ2BD+JqIFf7CZmDokqhjNB3HunokTYxJKT/GqUcEI4XfnLdc9zxIostk76l1XJqtj01iGjcuTlfpLNIL3QOboOBYyPx2o2ivNUYXg5l+isyiZ4DCEmBS2WwLDIugqWlaAj0z9qOoBLEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jWwKK9gQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jWwKK9gQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5856C072AA;
	Wed, 17 Apr 2024 23:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713395663;
	bh=Ofps2Qi4ZjI0rMK7wZwOyKRuxvZ3GjGvTs9Ive8i1E0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jWwKK9gQaYqVF4eQmxsZnkbpDqL6AFYQht0Xoe0nJc7Z9Ltr4vzgOLu6yhYHyei2j
	 fnFhdaawIRw/4x9hesv0oWARp5VnTgwxybbi8pIclxLI6thRCXQ3qSr2Mn7uZNDKhE
	 ilcpKMJrRZKuIctvo7d/+HjCiec0F0aqbqI3BKopr39i6jiaI8Atxta0I9NjgunqF/
	 57KfMbT/epSUzGSyAqYnDNZ4vFyvpMT4kCohYKpE2FDGU9V/XRiz/YfWeYWmQuRLjr
	 sGiD7HYOHlR02kUlyBoCNI/I/lb/F0GjxXFlUZ4xDBk048w0G8wIkX2mqIocFPY3Zf
	 98cQw4ZsMjIOA==
Date: Wed, 17 Apr 2024 16:14:23 -0700
Subject: [PATCH 1/4] xfs: drop the scrub file's iolock when transaction
 allocation fails
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@infradead.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171339555978.2000000.9920658450385469752.stgit@frogsfrogsfrogs>
In-Reply-To: <171339555949.2000000.17126642990842191341.stgit@frogsfrogsfrogs>
References: <171339555949.2000000.17126642990842191341.stgit@frogsfrogsfrogs>
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

If the transaction allocation in the !orphanage_available case of
xrep_nlinks_repair_inode fails, we need to drop the IOLOCK of the file
being scrubbed before exiting.

Found by fuzzing u3.sfdir3.list[1].name = zeroes in xfs/1546.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/nlinks_repair.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/nlinks_repair.c b/fs/xfs/scrub/nlinks_repair.c
index 78d0f650fe897..b3e707f47b7b5 100644
--- a/fs/xfs/scrub/nlinks_repair.c
+++ b/fs/xfs/scrub/nlinks_repair.c
@@ -138,8 +138,10 @@ xrep_nlinks_repair_inode(
 
 		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_link, 0, 0, 0,
 				&sc->tp);
-		if (error)
+		if (error) {
+			xchk_iunlock(sc, XFS_IOLOCK_EXCL);
 			return error;
+		}
 
 		xchk_ilock(sc, XFS_ILOCK_EXCL);
 		xfs_trans_ijoin(sc->tp, ip, 0);

