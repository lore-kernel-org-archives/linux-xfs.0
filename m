Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF4837CD45;
	Wed, 14 Oct 2026 03:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791949378; cv=none; b=edQDKAfpVXkaIdj4tFYqnhrutuiRahh0iRARNQnU3z25rapK7X6ih2BuMYF7hvY/Y0e7UKs77WAl7aBxWdZml/10oSyO4D8koXvSx3JDvnhqFhCNM7NE7dvpebxXnkUHDxVe77FbvncpqhmDuE56mWD3r5AMwzc7SeUpTGo8XhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791949378; c=relaxed/simple;
	bh=cVp2/NRNZhanr+zLEEEc9y/DdiLBdc1o4KpjxW1Nsc4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=DKPnj/NXehr/3OMezpZLmruriiKQM79BGBU5OyJW2OFBh+opVxmxMMtWadwUgvaBpqhjknJbG5/PBGCEcJY+gJVJ00TAJ6Del1AjEIZY95mJzYOAF6VXljxkBoDeSf/UqdQzokoayRjQur3mfQDNRXXxiqy45P3rt+BAhEXx2W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fydhNg1d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fydhNg1d"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 85FF5C2BCFC;
	Wed, 14 Oct 2026 03:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791949378;
	bh=cVp2/NRNZhanr+zLEEEc9y/DdiLBdc1o4KpjxW1Nsc4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=fydhNg1dwAaPVjKy1vQgvZY/3pVbv7O4gH+ZeD3QvHKglrLVFZx3MUzdgsBf3QZtB
	 4EQSxKDi2zFmtZ/PtYM0zkYed5TFH9tscVWyEEA30TyvIZ/14NrqqbXYHpEHt90gsn
	 NHT9q6sMlm6Jgl0xd6xGkmxKggq4+CohlVx7rDWQCyWsOVUu/N09bBSpNDK3YiAIJW
	 u+ab2AnrKjuEPM9Vij7dV4L06V5z2ZKco1wfHduqnTtwz+QLqDTvLQVrNhG7FeuL2p
	 iZQ/F5Q1Kpkjt8UieMN5Dp90ywdM5qibNfeW2mGI/2bCIKCL2SNVUlnIB9rMieEDGC
	 mOipwE1oG+joQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65556CC6B19;
	Wed, 14 Oct 2026 03:42:58 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Wed, 14 Oct 2026 12:42:59 +0900
Subject: [PATCH v2 2/2] xfs: clamp a pNFS LAYOUTCOMMIT extent before
 computing its end
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261014-xfs-pnfs-commit-hole-v2-2-d3a02a79ab6c@samsung.com>
References: <20261014-xfs-pnfs-commit-hole-v2-0-d3a02a79ab6c@samsung.com>
In-Reply-To: <20261014-xfs-pnfs-commit-hole-v2-0-d3a02a79ab6c@samsung.com>
To: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, 
 Dave Chinner <dgc@kernel.org>, Chuck Lever <cel@kernel.org>, 
 Jeff Layton <jlayton@kernel.org>, Dai Ngo <Dai.Ngo@oracle.com>, 
 Sergey Bashirov <sergeybashirov@gmail.com>, linux-nfs@vger.kernel.org, 
 Andrey Albershteyn <aalbersh@kernel.org>, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791949377; l=1616;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=fJwzYVZW1+G2yLF8tU13obG/LBvLEpaUVnDAw9h7wvA=;
 b=SeU3v3o9rANgHAnMjeGdIaXxNPrX7bqdy2VntgqZ32evza50GTKnhaJ0vW02SDchvukSMSpu/
 yVn0dDKgiW8DJpD0e2qqnptFkdhE7S5nUQr3JhL+3OQflJXPjTTur+b
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
xfs_bmapi_write() then fails an assertion on XFS_DEBUG kernels, which
is a BUG with XFS_ASSERT_FATAL, and otherwise returns -ENOSR, which
nfsd warns about as a non-standard errno.

With pynfs as the client and an RW layout for the first 64 KiB of a
2 MiB sparse file, a LAYOUTCOMMIT of 2^64 - 4 KiB at 4 KiB got
NFS4ERR_IO, "nfsd: non-standard errno: -63" and a WARNING, or the
assertion on XFS_DEBUG.

Clamp the length to what is left below the size before adding it to
the offset. With this and "xfs: refuse a pNFS LAYOUTCOMMIT of a range
without blocks", the extent ends at the size and gets NFS4ERR_IO at the
hole after the laid-out range, without a warning or an assertion.

Fixes: 527851124d10 ("xfs: implement pNFS export operations")
Cc: stable@vger.kernel.org
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
 fs/xfs/xfs_pnfs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 05c9660aea..d76873115c 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -312,9 +312,7 @@ xfs_fs_commit_blocks(
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


