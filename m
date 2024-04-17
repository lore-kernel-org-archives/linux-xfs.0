Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3E01E484
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713389940; cv=none; b=oeI8K4XpRpHT4Yea3OVGXkY3ULtTfrCqMCCV70VJhAUT2qdcJ76zrnXiIWbuihRNp38O/WYhzhThmV3fwMfKEsRVxqxjGPnhNIpbBpnwQbX+ST3QhBr1FI0M8mM155UCNB4sJqlRbD7Ndzro9bs6gC5wpVELLqWcPMC+ljzBJOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713389940; c=relaxed/simple;
	bh=3FbraAUw+JFV+Ch1xHnK0M3aQaSYbFAiSsvrCtk8+ms=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R13UaPxkd8xeSELGrIk0S0ICfPKa6R/etR88/SvggRFFZnGDdXxk+bsYwUoE9sHyesRpRqoGg1v5gxCrydYld+DYtSi3nr0if8/H87uKQH/ePZ5DJHTNHtL7ED/zbxaEAYV9NhRn6mzL53GXfOSw1rqRiIvsM5ObAe/hbMkCWOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JpNwTv8m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JpNwTv8m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED36C072AA;
	Wed, 17 Apr 2024 21:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713389940;
	bh=3FbraAUw+JFV+Ch1xHnK0M3aQaSYbFAiSsvrCtk8+ms=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JpNwTv8mC5gU1Pnw/OicROuFJJbqiu2lVDgD33o4+qnPV8mUxH8eNn5YBm7S/EEtq
	 SkSEcyYM6+jTQ2mQT47lv3APu9mhQgjRGpkxEYyZghacxdNivouz8xp6oEiq8ij59i
	 /j7QsMp8F6WZ7nzDqhpLmtjp4LUXImP8NovxGjKUL4tB4vWENY1fQzxhdK5p3dJNLu
	 8O4r8brSVYsMgpj0pTdSYvDIBzywjfuqDWOaal3QabRQGqGeasoq4QUa3712RjsIJk
	 UxitnF+5Qk6xAiKauIJqECnthZ6BfN6UiWmFkUz4yt63GOekX5IlfviEigZPqFj4d/
	 mVDNssqb0nPiw==
Date: Wed, 17 Apr 2024 14:38:59 -0700
Subject: [PATCH 66/67] xfs: reset XFS_ATTR_INCOMPLETE filter on node removal
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>, Christoph Hellwig <hch@lst.de>,
 Chandan Babu R <chandanbabu@kernel.org>,
 Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171338843330.1853449.13688612601247401355.stgit@frogsfrogsfrogs>
In-Reply-To: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
References: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Andrey Albershteyn <aalbersh@redhat.com>

Source kernel commit: 82ef1a5356572219f41f9123ca047259a77bd67b

In XFS_DAS_NODE_REMOVE_ATTR case, xfs_attr_mode_remove_attr() sets
filter to XFS_ATTR_INCOMPLETE. The filter is then reset in
xfs_attr_complete_op() if XFS_DA_OP_REPLACE operation is performed.

The filter is not reset though if XFS just removes the attribute
(args->value == NULL) with xfs_attr_defer_remove(). attr code goes
to XFS_DAS_DONE state.

Fix this by always resetting XFS_ATTR_INCOMPLETE filter. The replace
operation already resets this filter in anyway and others are
completed at this step hence don't need it.

Fixes: fdaf1bb3cafc ("xfs: ATTR_REPLACE algorithm with LARP enabled needs rework")
Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_attr.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 1419846bd..630065f1a 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -419,10 +419,10 @@ xfs_attr_complete_op(
 	bool			do_replace = args->op_flags & XFS_DA_OP_REPLACE;
 
 	args->op_flags &= ~XFS_DA_OP_REPLACE;
-	if (do_replace) {
-		args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
+	args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
+	if (do_replace)
 		return replace_state;
-	}
+
 	return XFS_DAS_DONE;
 }
 

