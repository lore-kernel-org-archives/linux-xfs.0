Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4FFF3B1009;
	Wed,  8 Jul 2026 05:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783487021; cv=none; b=XVhiR2ygjmLOG9aCoNxFNdqaDbY303+CknFH31U4WIpIVh1NZkqWfa+KLZpifO68h+3AFtZiFwfGi6cwGZ91NvtG54n/nO7wm3Ru3YautW/vLuNMT1DDeC0w2YcZ7U6lIWTbWGYv1uA1N8VVOh03536JElCJxXQQWQBDieKHOQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783487021; c=relaxed/simple;
	bh=QHXUNSfpQcTmpJt6upSujzwZVJRjY2cWS0+fZBpq/zQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KVJLpQcRc0XmbTHyoIv8GJfW/IoAXm+gGhnYMwoxv1DiwBYIpbu2rHjJNqc3pwonzMOmXYQyeH8T1nAm8hDv7ITl72/R71ruJj4/PEC/4mjGOhwxqCwED/mzfKUOLNBhO4lBDnFO+eufyjsO9GTwNyOXiNRexMRaZnuMWQ7wslw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YWHmYGO8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YWHmYGO8"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 56C7C1F000E9;
	Wed,  8 Jul 2026 05:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783487020;
	bh=9lmtlHd30OexsM+BbBr33BKyqEniYqLQI00N1E9dtac=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=YWHmYGO8Q/GUc05CjyGOP1v/FS24mmVqlpUY1lNI5uYKzoP6CmOWr/WFYDPhJZNXz
	 pr8+Szev1HjrpLEXqtVabYTz43bI/5nBMmQu1vYz2Kz8z64zQKMk//BYWRvILs72hT
	 OOvcbrhMN0ahPtMKG3A3y1fnwF8YBrGZt8KBDPkYs29W9E3KCXcj1b9EAAVZWB4YKQ
	 N7KkGduJD8HHtn3gpbKBYGIBmqPxOYc8Xu93AjxeVzastB9neYFHLSdnksmGG7p9Hx
	 BFTgUWYbFHQKY6hUB1+YFTM224zkmP9kb2VWlHtL1puBuuw1nWvuPqxPKnzonYaLCq
	 BZZJhCPRJ/VwA==
Date: Tue, 07 Jul 2026 22:03:40 -0700
Subject: [PATCH 2/6] xfs: don't wrap around quota ids in dqiterate
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, hch@lst.de, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178346726130.1271589.15159357342663936453.stgit@frogsfrogsfrogs>
In-Reply-To: <178346726054.1271589.14164163317011378817.stgit@frogsfrogsfrogs>
References: <178346726054.1271589.14164163317011378817.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that q_id is an unsigned 32-bit variable.  If it happens
to be set to XFS_DQ_ID_MAX due to a filesystem that actually has a dquot
for ID_MAX, then this addition will truncate to zero and the iteration
starts over.  Fix this by casting to u64.

Cc: <stable@vger.kernel.org> # v6.8
Fixes: 21d7500929c8a0 ("xfs: improve dquot iteration for scrub")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/dqiterate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/dqiterate.c b/fs/xfs/scrub/dqiterate.c
index 10950e4bd4c3c0..079dc4e691a01a 100644
--- a/fs/xfs/scrub/dqiterate.c
+++ b/fs/xfs/scrub/dqiterate.c
@@ -205,7 +205,7 @@ xchk_dquot_iter(
 	if (error)
 		return error;
 
-	cursor->id = dq->q_id + 1;
+	cursor->id = (uint64_t)dq->q_id + 1;
 	*dqpp = dq;
 	return 1;
 }

