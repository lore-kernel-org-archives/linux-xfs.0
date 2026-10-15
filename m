Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F7E43BDC2;
	Thu, 15 Oct 2026 04:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792037282; cv=none; b=fP7K7aZsLpwyjUvfI6OvO4IRcZ/Hy+eJ/ODxWs923vaFEm2M1Iz/0/5xuZeE0v51yPjcpuK2+ND0DATUvMySln6nqigm6a150gVs8BOFUswS+6/WhzQ9PME4QqRL5sDcL53oqIvVymPTEaoCjCUYzO6WGqBeyHiW5uSBZhrK+bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792037282; c=relaxed/simple;
	bh=5YMcUgmHuwZ09iRYdxUe+lH9zpyUBdXx1A6AMXut68I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=j/gMp55MRdtrHWFwGksM+ic8vC2Cis/Q1vQtEW3F43dvk1/Dh1SfJ1/XS1p9/tctzA29NCzpr6Jkt/mfeQTkL+PDeuHZsH00Ue72ez9W7rRnpddfGT1w162bO/j+AgarIIGUFIGPDtAYzMPW9tAhEO1idGrAjV88Lgkw0AfUm+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jys4+AdL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jys4+AdL"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 03858C4AF11;
	Thu, 15 Oct 2026 04:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1792037282;
	bh=5YMcUgmHuwZ09iRYdxUe+lH9zpyUBdXx1A6AMXut68I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Jys4+AdLgNli27mEwyal1Nqz6zEfrqoCA0N0HckAEDJsyIbXUROK1IeNEW8cRZKoc
	 mFaacnbNNk4MS/KxKWwNQwkgsBTBctZceRXgFimEpOOo7DCQ50AyfC3GnJuVvm+tEi
	 fvMg+CZXB8nTXzkEisV28/PBI1fX7jygLrcwvtKwIWWq//Kb0G60ZAJh7F5Nq5GMgS
	 WvYQktJgSfyMRFE8ERlil8Uk08BQf1NF0wWihsuMlXKlW+GSL8nK7rwRfFRDMq1Emq
	 PyyNOm9Wr6rkNo0N719Ijbd0UUGjWVt+GT8JRYqpNw26uqBsVT+5PizIYsFh8wnmwl
	 kGusDvPpNu2vw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDB2CCC6B35;
	Thu, 15 Oct 2026 04:08:01 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Thu, 15 Oct 2026 13:08:03 +0900
Subject: [PATCH v3 4/9] xfs: clamp a pNFS LAYOUTCOMMIT extent before
 computing its end
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-xfs-pnfs-batch-v3-4-54fc7b2e467d@samsung.com>
References: <20261015-xfs-pnfs-batch-v3-0-54fc7b2e467d@samsung.com>
In-Reply-To: <20261015-xfs-pnfs-batch-v3-0-54fc7b2e467d@samsung.com>
To: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, 
 Dave Chinner <dgc@kernel.org>, Chuck Lever <cel@kernel.org>, 
 Jeff Layton <jlayton@kernel.org>, Dai Ngo <Dai.Ngo@oracle.com>, 
 Sergey Bashirov <sergeybashirov@gmail.com>, 
 Andrey Albershteyn <aalbersh@kernel.org>, linux-nfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
 Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792037279; l=1903;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=nP9RMvT+2/zi+VUBuU+Zdw9BhC8rbBfOGbPtZzbzLCE=;
 b=La7YdO6HQ29YYGK2deefgEYqYjXWO93FBIe/kNxCnQaF3rPsrAYUHGCejz6CPD7zRsQgWtmQG
 g08sI+bXZ5DB4lbDCflXjIj1Xnrwp6Ui5w9uG4HhltMncWKnZ+yz8Rr
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com

From: Daejun Park <daejun7.park@samsung.com>

xfs_fs_commit_blocks() clamps the end of each committed extent to the
file size, but computes the end as offset + length first. A length
from the client can make that sum wrap around, and the loop then
passes the client's length, unclamped, to xfs_iomap_write_unwritten().
The range wraps there as well, and xfs_bmapi_write() maps nothing.
Before the previous two patches, that failed an assertion on XFS_DEBUG
kernels, which is a BUG with XFS_ASSERT_FATAL, and otherwise returned
-ENOSR, which nfsd warns about as a non-standard errno. With
XFS_BMAPI_CONVERT_ONLY, the LAYOUTCOMMIT fails with -EIO and converts
nothing, even when every block up to the size is allocated.

With pynfs as the client and an RW layout for the first 64 KiB of a
2 MiB sparse file, a LAYOUTCOMMIT of 2^64 - 4 KiB at 4 KiB got
NFS4ERR_IO, "nfsd: non-standard errno: -63" and a WARNING, or the
assertion on XFS_DEBUG. With the previous two patches, it gets
NFS4ERR_IO and the laid-out range stays unwritten.

Clamp the length to what is left below the size before adding it to
the offset. The extent then ends at the size, its allocated part is
converted, and the LAYOUTCOMMIT gets NFS4ERR_IO at the hole after it.

Fixes: 527851124d10 ("xfs: implement pNFS export operations")
Cc: stable@vger.kernel.org
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_pnfs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 7ff83274a5..19eb18e129 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -328,9 +328,7 @@ xfs_fs_commit_blocks(
 		if (start > size)
 			continue;
 
-		end = start + maps[i].length;
-		if (end > size)
-			end = size;
+		end = start + min_t(u64, maps[i].length, size - start);
 
 		length = end - start;
 		if (!length)

-- 
2.43.0


