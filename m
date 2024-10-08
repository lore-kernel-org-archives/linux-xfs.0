Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F7634CF5
	for <linux-xfs@vger.kernel.org>; Tue,  8 Oct 2024 04:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728360429; cv=none; b=YkdIybG0ReIyreBqXBAMYOjDsTWrKbNDcZXFeRPuUxY+i+ALTsRS80gI0PFi111CUwBGaMXaBr4shjtjw23olUsZ1pmgchNwwTU5pJqomA+umB5pf6EBPaH0tYzhQEVZCzOuAPtg9pWSkQGjKTBif/8xJ7VSs4xZTj7VBON9Rmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728360429; c=relaxed/simple;
	bh=eJYoXGY8kAtPyrL1An+UhubefBNG28Qsa8vQK/FGuGk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=hJ4nxz2bpPKqR9eK1b771CzeaMX1PslqzplpJFviSkrzLffmNjJDd7Zlt9auPqaN1N1QpEkNikaspk2agHvh4IlNgZPvujw7nA3FxXK77Rr02tOUITHoSBELWXAGcQPrG/i++6PE8z8tM3RiHOGfr+3UBFMv9Fx0LghBQTh4U3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C6fyuS/K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C6fyuS/K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16DF4C4CEC7;
	Tue,  8 Oct 2024 04:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728360429;
	bh=eJYoXGY8kAtPyrL1An+UhubefBNG28Qsa8vQK/FGuGk=;
	h=Date:From:To:Cc:Subject:From;
	b=C6fyuS/KdNbThn5ukUkU73hEtlqzaCrNX/jz5jJ0ekxMRoExBhen6dpwGNlY1AwEf
	 5zGOVVfeVENkO7lwuwiFFynYbk9jkutFQ74Mg17NqS1/we2FRMbMIOOtQYAR9DpU2h
	 K+epooC9cVUdeGXSjopaQ8fnSMY75MT9NQwAtTHrhjwV+0iROE+hGw1qPC4GjXTk3N
	 lD4a8dAO2gc5dle04gweOs9F/fauvPe1Vme5q0GKSPc7tj8U/T5cTd/YR32pGZkhHs
	 qYNClGjzaSO2eW04I3tdTrEgKb0UxCi+8t1nYoLVidzhHWX50cp5JWp7ZjRQezdXiL
	 pPJMteznWT6PA==
Date: Mon, 7 Oct 2024 21:07:08 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: fix integer overflow in xrep_bmap
Message-ID: <20241008040708.GQ21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

The variable declaration in this function predates the merge of the
nrext64 (aka 64-bit extent counters) feature, which means that the
variable declaration type is insufficient to avoid an integer overflow.
Fix that by redeclaring the variable to be xfs_extnum_t.

Coverity-id: 1630958
Fixes: 8f71bede8efd ("xfs: repair inode fork block mapping data structures")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/bmap_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/bmap_repair.c b/fs/xfs/scrub/bmap_repair.c
index 49dc38acc66bf..4505f4829d53f 100644
--- a/fs/xfs/scrub/bmap_repair.c
+++ b/fs/xfs/scrub/bmap_repair.c
@@ -801,7 +801,7 @@ xrep_bmap(
 {
 	struct xrep_bmap	*rb;
 	char			*descr;
-	unsigned int		max_bmbt_recs;
+	xfs_extnum_t		max_bmbt_recs;
 	bool			large_extcount;
 	int			error = 0;
 
