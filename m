Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C9836A37F;
	Thu, 13 Aug 2026 05:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786598669; cv=none; b=kvudU/eszGuejn+kJxIvraonoMWdzW7rgjxPAAv+1zsTlvEw9loZWTuGQ0xqoDBPEC3dWQtPRxZOoqDQCqSN0fTNNDLi8zhGZquwPFDFfGag+8cYDBCMzIlpsR8U/PRm3JaLdFWuhtEyUGDkyGIJXSIw4sm4ZyXYr3GjX0Wtstc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786598669; c=relaxed/simple;
	bh=MuUMfjVw0YQDp22UeVoiCL3kvKsXW0nEL0YeZlWgptQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JUvB8W/AXCye2RKn6Tj16CJNfeUfkq7JWjSiHGRr+lEfqijq1ipLQyvnOHqKf2QLkqGlz95pglxaKM4idyfEHnDvf5tZhWqhidfAUdpJXftcn4D9Sy62sPFLB4zrFEcE5xbIMarQzRPJJsJ7A3R15vMmNW4QhxvC8vQ7/xbGncU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZVB/tqZ1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZVB/tqZ1"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 543711F00A3A;
	Thu, 13 Aug 2026 05:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786598663;
	bh=MMVtrMNx7oKQD9PsYGOHp/fbkdtEK5WZw2qsP4E3lhE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=ZVB/tqZ1X31Jz+b6/nk/KLWo6tsPImCPABvQPZgSwKLnwgB5XOb2edvhDTp9tBEyu
	 iO6cpXM715moNxiTz0pWgJraeqkJAcpP0m3Vb74cML8rfhZUd9ouG/Ec381+wA7FUU
	 5mvOkDvoHNfJJFwOyqkIVtaU+vSfZV6DxwFtuun/YW0q/sGiNpLEzZe1hJlXVR4346
	 tJlLCbotNgl77XOdU69Uj5F92eUEeOzKOK8zgPVdWrDb47h0uwQ0kYfvp2ebD+hTs1
	 4fPjPWzhbFxsjbJGBFIMXmtoTgH7tIAquDbEq+5AlhpL2Dl4txFvh0Vf/9GU1OuEf5
	 VcIYX97OpiS5Q==
Date: Wed, 12 Aug 2026 22:24:23 -0700
Subject: [PATCH 2/6] xfs: fix short ifork reaping computation in
 xreap_bmapi_binval
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178659861506.833642.8031350177292777466.stgit@frogsfrogsfrogs>
In-Reply-To: <178659861428.833642.7987162774335580459.stgit@frogsfrogsfrogs>
References: <178659861428.833642.7987162774335580459.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM got really confused about the update to imap->br_blockcount in
xreap_bmapi_binval if xreap_inc_binval returns false.  The intent of
this code is that we shorten the imap to whatever length of space we
invalidated so that the next iteration through the loop will start
wherever we left off.  Unfortunately, the calculation sets br_blockcount
to the amount of *unfinished* work, which means that we pointlessly
re-scan blocks that we already reaped.  This is benign, but we should
fix the computation anyway.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: 5befb047b9f4de ("xfs: add the ability to reap entire inode forks")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/reap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index 496c6eab555e91..f698b9be3dd1df 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -1399,7 +1399,7 @@ xreap_bmapi_binval(
 			 * far we've gotten.
 			 */
 			if (!xreap_inc_binval(rs)) {
-				imap->br_blockcount = agbno_next - bno;
+				imap->br_blockcount = bno - agbno;
 				goto out;
 			}
 		}

