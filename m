Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B4457314
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423173; cv=none; b=touH7AL02A2cPnysjIbjFxvUkMkk9MspSs7S+y2ArtDCo0I51+mtMZbX7BL72jl4YZhP5jRqj4X3vlGXnhAztcrbZLevIDJUIsfZewZZE7duaplgIpE+3PzoVr8vo7QgKRzFRgiOEQqolbucgVkutws8pOYtriR6KOqijvdPZwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423173; c=relaxed/simple;
	bh=eyoBejKVFmja7C3f7CTvIOGGs0Dbcte4qo0L0M+mjyA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=enEMJhkL47UpWeuYgOSyHuAw2BETJq8RRY0WbJRR4l92C+WOTomFa1j/g2D+ZT+6Y7wlsUv7pPbFH++uEfJwLJqZxCbztVJnjyTejGur7bki/WN7vCGLBvDZAApwv5knaoROkn/4D5Q2DgVHYwg3HxntCtFWDmXrJEijs7MiqBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PJpeOGGT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PJpeOGGT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C958EC433F1;
	Tue, 26 Mar 2024 03:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711423172;
	bh=eyoBejKVFmja7C3f7CTvIOGGs0Dbcte4qo0L0M+mjyA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PJpeOGGTWjA3b6hM3vgikDsimfWg3Yj0dJBgHE+gwB47f4iRfyXX7Xq2oX+4SJj2v
	 dWjV8I4t13+MbUUXqzGElclhgFPzLBoAI6UVqo0UuCs0aG9xVQ0XydQKhXlihM7F5Q
	 06m8t35oAZi1nwD86stXrreQ59/hnWWLk6PSNOrt6kycPFSCmE70pYjb5iEQlmqwF9
	 W6N2yQXwZ9Pk1k1o1USxKzQfZGuMcIPp7/TBXfeVfmKNBfVCEsrTbea32qW0fzBoec
	 JPZp13iSwVfHrZ6lo+yBo+OtBnsJiVbwHZTjEom0f6+TYTC1SVDsY1wtwzD9lgQk2X
	 sepAwbW5WXz3A==
Date: Mon, 25 Mar 2024 20:19:32 -0700
Subject: [PATCH 64/67] xfs: use the op name in
 trace_xlog_intent_recovery_failed
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171142127880.2212320.14920612127648338200.stgit@frogsfrogsfrogs>
In-Reply-To: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
References: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
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
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
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
 

