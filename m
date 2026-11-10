Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794337474;
	b=REkzp9+OfrfyKWJFNcIgNw/JNm4FCQyNNdz45XrnjP+elmasOoluffQZ2/cg6dJaF0AN
	 Ry2Ok1NTJz7KO5YOH+7lG9ZMebQQo6QCa68Yun2I8+bMuSOV+2Lz949e/zvSuNQULyjn9
	 2eew+Lht90mpAsJcjaQRE0j6pqecc8VuU4FaRf3RjYr3aR67ZmP4rjiySD9swQHTFY0BE
	 0ISfuGRBe+MuofOZPXJtJF/rVKekRwtrsNjcNFyKGlWTx7JNOxQhQlihRZVqVWq7jxa32
	 n/BRG5tTa6wsxqEhP4ygOI8IJfOORoqROYNNUMfgq7f8Kg6YBkbzfmjmdWbujv4Fwdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794337474;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Dp5MWdGSJiANHCQJvA4KJu18Utk/FmwGUTwVrNB23T0=;
	b=duA+/CeS017x5lISLnRGEnwoT+7QLubl6f8Bt1dfuinzejtQum2WdWwdGUXWqThtMRuX
	 OMi0RqfNTVKrykEbeGlK/NMkdYbKHftSvuhsJVsPnNOGUvxphwAH64qofzJWKFszEjCsT
	 DsNnWgZFDZkjGG+fmFhJYEJ+PfjJgwKAXzkqWCTEO+TyHNN/OJTU7smBRYzMhQUPk+0SM
	 7GJuqbdXtlmNzdEW5S4Ye6KaW/qYW4AKrjg6QhT4tLCqMbS4apZWkIFY8FHljszQb1jGF
	 1G5/anBKI3yOvKCkiuoSFrghyBB8kaBrkJMzcXV/bsxr50YeOOI5sMJurzA6iOKoXKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Lt0nGYGn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF57606A334;
	Tue, 10 Nov 2026 19:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Lt0nGYGn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9E831F008BC;
	Tue, 10 Nov 2026 19:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794337474;
	bh=Dp5MWdGSJiANHCQJvA4KJu18Utk/FmwGUTwVrNB23T0=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=Lt0nGYGnRRR5cYelyO+kHlhf6KpFDusje+an8TEncEc9gBYFZyJJj+qyZlYPBrEKh
	 2CZgWoe927KMGJBkwEJ8yNKbYrFO76SaZabE3bKNzxxK4v3RJt0fE32T4OlyQ++6MI
	 lXCpxUhWzF+En4I0vkwxPjPIikic0RIWh+vKNEbGUjh/bw1SVEDsP1+9dqO//1kMI1
	 drFO9X5tN+Eo9XyCen8eyAfUTJrvLw9Trvmvd6Iel/FBqQgfgIPyBPKXDa6qahU5sd
	 rvOBxMVvJfOHcB5VglEbx+dR6G3el3CdIHJTmbUc2z+nJW4tFSWo49t6Rb2ea27P9/
	 jXCr4gNCehsrA==
From: Chris Mason <mason@kernel.org>
To: mason@kernel.org,
	tytso@mit.edu,
	cem@kernel.org,
	david@fromorbit.com,
	jack@suse.cz,
	djwong@kernel.org,
	josef@toxicpanda.com,
	hch@lst.de,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	tz2294@columbia.edu,
	brauner@kernel.org
Subject: [PATCH v7 07/11] xfs: test for reflink after the dio write checks
Date: Tue, 10 Nov 2026 14:04:25 -0500
Message-ID: <20261110190417.32650-9-mason@kernel.org>
In-Reply-To: <20261110190417.32650-1-mason@kernel.org>
References: <20261110190417.32650-1-mason@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

A direct write that is not block aligned can expose stale disk contents
on XFS if it races with the first clone of the file.

xfs_file_dio_write_unaligned() falls back to buffered I/O if the file is
reflinked, and tests for that right after it takes the iolock. But
xfs_file_write_checks() runs after the test and can drop the iolock, for
example if S_NOSEC is not set. A clone can run in that gap:

    direct write                        clone
    ============                        =====
    takes the iolock shared
    sees that the file is not reflinked
    drops the iolock
                                        shares the blocks
    takes the iolock exclusive
    writes a part of a new COW block
    maps the whole block into the file
      /* the rest was never written */

The fix used here is to move the test after xfs_file_write_checks().

Fixes: ed1128c2d0c8 ("xfs: reduce exclusive locking on unaligned dio")
Signed-off-by: Chris Mason <mason@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---

Notes:
    v6->v7:
    - No change.

 fs/xfs/xfs_file.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 8ee88910b487..d888470d092a 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -877,9 +877,15 @@ xfs_file_dio_write_unaligned(
 	if (ret)
 		return ret;
 
+	ret = xfs_file_write_checks(iocb, from, &iolock, NULL);
+	if (ret)
+		goto out_unlock;
+
 	/*
 	 * We can't properly handle unaligned direct I/O to reflink files yet,
-	 * as we can't unshare a partial block.
+	 * as we can't unshare a partial block.  xfs_file_write_checks() can
+	 * drop the iolock and take it again, and the file can be reflinked in
+	 * between, so test for that only now.
 	 */
 	if (xfs_is_cow_inode(ip)) {
 		trace_xfs_reflink_bounce_dio_write(iocb, from);
@@ -887,10 +893,6 @@ xfs_file_dio_write_unaligned(
 		goto out_unlock;
 	}
 
-	ret = xfs_file_write_checks(iocb, from, &iolock, NULL);
-	if (ret)
-		goto out_unlock;
-
 	/*
 	 * If we are doing exclusive unaligned I/O, this must be the only I/O
 	 * in-flight.  Otherwise we risk data corruption due to unwritten extent
-- 
2.55.0

