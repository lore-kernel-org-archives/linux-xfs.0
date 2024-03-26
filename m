Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71B0128387
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711422044; cv=none; b=mDoizzV7TD5I77LZBQ9T3zPRgg5+B3VmEqvqF3kTn2WRZckKuB8Y1RbQB/XLUSs/sJ6FGb9HcsQ9F6rqkFaRVoD+NGN4fAYeNkBRgUPs6F7XbzJ3bzSlxGqrfBG9bi5vlLIpbJ1zCCqZ7S9zQFBbVvRbcwIcg1wcW/Pqi9jeB6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711422044; c=relaxed/simple;
	bh=YQBk/sRLaLVUHFQVYoNoLp5PngggZjXI10WeDBElfAg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gh8AKwFPaGXESuNWd+oB5CpdUrchkaVH+46jpBbSAJzQjKeQHS/Q5BdRowkFZs4rghUDQFajt9FaBIGB7As1A+LaBla4EY6dHZGp/fd4C+rbVbGk6/RHLzN5TMm+nrAUFJL0DvEhM06Kn/NK94YdKsK6LOS+cugBBvj8p4kKh1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gf9DwkAx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gf9DwkAx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5AE2C43394;
	Tue, 26 Mar 2024 03:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711422044;
	bh=YQBk/sRLaLVUHFQVYoNoLp5PngggZjXI10WeDBElfAg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Gf9DwkAxpSEd64lO84LUK70aKziN+gSJ4pkEinF6b+zIcNOJ+IJV1ATPiOeVQnD+i
	 uTU8MYx8K6Rdi5qaCW1HSgKLemc+iPENo9wkeILcG0Ji1HbMum+ONHWD4QWFFPj+dk
	 hnSyWutr+qAn3Y37JtNgwvqj/rAFj9sDX81mWgBQhS0jdx02d1nHRelQUzjlT2fbGT
	 k5GCillosrSnY6eC8R8RY/VTFhDJthBjIhJz3anMJm0TYnwHbUIx+LdOvdVWFVqtkf
	 rIPCwRDcYIgIdfBgC4HGCF7TGiTFLaW3ccc2WBTd9i4+0tbvGWPE15h8lfTDfyC7eX
	 J+LbiSGuUr1bA==
Date: Mon, 25 Mar 2024 20:00:44 -0700
Subject: [PATCH 05/13] libxfs: use helpers to convert rt block numbers to rt
 extent numbers
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171142126381.2211955.13138464891043822755.stgit@frogsfrogsfrogs>
In-Reply-To: <171142126291.2211955.14829143192552278353.stgit@frogsfrogsfrogs>
References: <171142126291.2211955.14829143192552278353.stgit@frogsfrogsfrogs>
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

Now that we have helpers to do unit conversions of rt block numbers to
rt extent numbers, plug that into libxfs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/trans.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/libxfs/trans.c b/libxfs/trans.c
index a05111bf63c4..bd1186b24e62 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -19,6 +19,7 @@
 #include "xfs_sb.h"
 #include "xfs_defer.h"
 #include "xfs_trace.h"
+#include "xfs_rtbitmap.h"
 
 static void xfs_trans_free_items(struct xfs_trans *tp);
 STATIC struct xfs_trans *xfs_trans_dup(struct xfs_trans *tp);
@@ -1131,7 +1132,7 @@ libxfs_trans_alloc_inode(
 	int			error;
 
 	error = libxfs_trans_alloc(mp, resv, dblocks,
-			rblocks / mp->m_sb.sb_rextsize,
+			xfs_rtb_to_rtx(mp, rblocks),
 			force ? XFS_TRANS_RESERVE : 0, &tp);
 	if (error)
 		return error;

