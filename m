Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 958382AD2C
	for <linux-xfs@vger.kernel.org>; Fri, 20 Feb 2026 01:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771549216; cv=none; b=YFmJpam4G/su4twGMLWKjJ3tI5Ws7w29UUfA3lz18rBGK4+aY6Z4UdRqa4o3Y1tKA57xR7mfZCManhMecbJVDdKfKYwaTdF8zANZ0k3fKDyIyWgUWxWASh4e9kVZZOSYJMMAiZAea6/zHWbR4Hr+2LqFRCVuAGvK48AdatGLzeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771549216; c=relaxed/simple;
	bh=lGyrxP0WYnRrK4WmH+6g5NG/GLg+wWMjY56SaVUqbKo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D+pKo+V3fgrJLE5wKXgLfUSVhTKV7ULriu3yqd+PEWNvdl4i5PlBf3oEb9s3p/5zEPL/7hb7hrLQZZiXyvipH7PXN+++AbM2AqEd9+TSNEu9y7v3DAAbgWoRQQPN3qgsxlSIlzqRBX3/V2Q6YCNunRriu9Nz/a01enmX1kqsIao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OM7qB7Kr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OM7qB7Kr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16039C4CEF7;
	Fri, 20 Feb 2026 01:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771549216;
	bh=lGyrxP0WYnRrK4WmH+6g5NG/GLg+wWMjY56SaVUqbKo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OM7qB7KraFHK2GAOQqXHYTrkdicgR9rRbmYTsCjuvLt5ATG+YohbFIYuQ6CeObiWn
	 nkqUKwNp8dS7eESk4pD129m1VqjoywuFU2VuEtjfivyCEHWiDa5M31kj4pyfJLzKyZ
	 CiOgUVIWirS6q14T396elmIW/ulLHJE16aS1ui6GhJG5Ui/aWg6emMDiHwTn1Q0C7z
	 zLIBeJsT5eMfQOLDMHOKg2iaUzoRNK2m01jXMb/K8LZjc03TgU2AHeL+3U9TkCPh7K
	 mj585n8Rq8sHj2gAq0CHPK1ZN7Kbi5zV7bIYwaGPTTYIpd+RVLIMNhWeC+qJ/lwXhC
	 /N1YzV6TTUybA==
Date: Thu, 19 Feb 2026 17:00:15 -0800
Subject: [PATCH 1/6] xfs: fix copy-paste error in previous fix
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: clm@meta.com, cmaiolino@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177154903684.1351708.1551447591877933027.stgit@frogsfrogsfrogs>
In-Reply-To: <177154903631.1351708.2643960160835435965.stgit@frogsfrogsfrogs>
References: <177154903631.1351708.2643960160835435965.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Chris Mason noticed that there is a copy-paste error in a recent change
to xrep_dir_teardown that nulls out pointers after freeing the
resources.

Fixes: ba408d299a3bb3c ("xfs: only call xf{array,blob}_destroy if we have a valid pointer")
Link: https://lore.kernel.org/linux-xfs/20260205194211.2307232-1-clm@meta.com/
Reported-by: Chris Mason <clm@meta.com>
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/scrub/dir_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index f105e49f654bd1..6166d9dee90f13 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -177,7 +177,7 @@ xrep_dir_teardown(
 	rd->dir_names = NULL;
 	if (rd->dir_entries)
 		xfarray_destroy(rd->dir_entries);
-	rd->dir_names = NULL;
+	rd->dir_entries = NULL;
 }
 
 /* Set up for a directory repair. */

