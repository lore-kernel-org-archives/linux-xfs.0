Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126A18BE0
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 02:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710295785; cv=none; b=XhCHw49c/iJs/M3DkS4KLqanj5tJSCdSavOAQclLq5RJn4607LhIrmOKaP1hMGm8cLkFa1QxFHkz0ok86ZgoVN8K09Qt3SHq3dyOB/v15ltkCJK/lLSwwVV400sdLZqNdcHJL7sIJImctAEaVP+uLYmzOdAAJy0EQFaLbvYcRcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710295785; c=relaxed/simple;
	bh=o1OPfqbOZ6qyIWwmKA1HqM9B9YODhaG1xzZVwTdKj2A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T5TJB8lj/j82aV+ALD86dpVd7yQRzXR3cUTfZAncK62xeTEATzOqBZ1O8dehSxU7UD2nTBCt8voKX9X0nuM+y9E8KhacjoZF9QdfUz/3QaTCzG6jvcZbspJBOtfrn9ABjeRHAtnCQtxdEjW5D3W3YZkkpxPy7hIJiNIQzOBA1Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rEb+avum; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rEb+avum"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D55BC433C7;
	Wed, 13 Mar 2024 02:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710295783;
	bh=o1OPfqbOZ6qyIWwmKA1HqM9B9YODhaG1xzZVwTdKj2A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rEb+avum9jyUel8KVXVkcROrzJZupznsoDmz2YdE9zA6wXtZM8IbnrulP6n7oJiWg
	 eiTqoySdoVbe4UxaM7bn59t9ymI8E2jMcWZlDk3E3rSMdJhtxLZavzqxo9TYLp3lFK
	 5ZZTRMG+QDcncUeyXdyiK7aFJOrfyYU0M4W+SRk3iUObZmzKUBdVE62zveQnQQ3Anb
	 0qSTncbZliXS3L7uzppZJ6TmTp4S0xRv0gRmLQkNid2apozAJzY4hw+WnhQojmqATW
	 NHhErWNU1PERvie/ATYGRK1fCT6KiNHEezZBPdZnBR9Gejrd0Q4niQSbvUVoJXlrCJ
	 2t4yC/6yxfR1A==
Date: Tue, 12 Mar 2024 19:09:43 -0700
Subject: [PATCH 64/67] xfs: use the op name in
 trace_xlog_intent_recovery_failed
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 linux-xfs@vger.kernel.org
Message-ID: <171029432118.2061787.3272883518379611998.stgit@frogsfrogsfrogs>
In-Reply-To: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
References: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
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

Source kernel commit: bcdfae6ee520b665385020fa3e47633a8af84f12

Instead of tracing the address of the recovery handler, use the name
in the defer op, similar to other defer ops related tracepoints.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_defer.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)


diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 5bdc8f5a258a..bf1d1e06a35b 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -915,8 +915,7 @@ xfs_defer_finish_recovery(
 	/* dfp is freed by recover_work and must not be accessed afterwards */
 	error = ops->recover_work(dfp, capture_list);
 	if (error)
-		trace_xlog_intent_recovery_failed(mp, error,
-				ops->recover_work);
+		trace_xlog_intent_recovery_failed(mp, ops, error);
 	return error;
 }
 

