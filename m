Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792465727;
	b=W/8BCaN0l4sJTy29/AFfMGQbWiUIeCSgpYhPiVgg3A5HjFYlmrVstBys4RLIM5sEPB4o
	 kBDsNCD7Vd1Sy6eTXDm4jpwXCLs4vDVXlnstV0m1/Q6vl8lF/U8YCoypT5Sn7eHTGhoKF
	 7qYZWA5Yk8MNjZhDYUymsm/L6WmF66GBu4i8yrCE0gt8W4X76D7RjuUdJ94V3vOyQMUqQ
	 P47zPmijcEdlQgs+JrHOt7KdWy/+KUCJEGvSYiNwJNZZDn7H/PPwWzpBXy4Lqcynp8sG7
	 IEAfdvZOs/ipKGLJIhyaO4ATOl4cF6jmXZvGC8RyqRu93V9fbjKmeGimNWDqJqa2AqQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792465727;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=6+Bs338qJx1nAJsKlYXL4CgEzKR1n6taC//XXZTl8R4=;
	b=rUhTWAS9pinszO7sT6UL+sroJjjGXBienwsp+w4fzs9T8nRC3rbdXpf4AvtwhgSTd6lN
	 z5WP62Ek8DBuz65hoTebjMDU1wqexfTx9xT4sw3EqvBIHxkc4guthrXgLW2fiScqMH9c+
	 +ud5SaYs7dSuegwZNZso/AH6B7KlpcmJA+GznoQRR0lF/Pwnf2TKtVE6DP+8mKPsGDMKj
	 QaciPFLYwDI0UymVzz/4Y6lRgcdcVjJj63BIcWYFYRH16aXhA4IqgA6FGZjavULR3xVJY
	 1RQhk+bCf5l48yZb4swcqC9PM04VaEZ8IHi+R+RQcaF7ok9IRzQp7FKaijeP2+2IGYQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XlzCwkdF;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E25606A31A;
	Tue, 20 Oct 2026 03:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XlzCwkdF
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792465726;
	b=Tk39Kj+6XEVGAB2FPdTDnJ13b7LNbg3ESkAm7yYE1iRTOldzW3dZGVEQanTubmDbQWx9
	 G4qx+ZyKCKG9gmJPymw+vs3uCh4e3lxYPbKnm42PW5C1Nzia3W5ZZq6o4KTjZEpWg4Nqp
	 ylbr0n6+Ha0hX3ntuT42hDAK//am7h15JW+UfyQ9jvQ5xTcDRgzwRIuTx/pVSWa8ZwJpz
	 szqYuTXaj8et5nqKsiOsIbBdCW505MH5ddAWiA7AnTpkRMGzPrt0LlBviZZMnnXyQnBsr
	 XycOTxEko+OgwDrFsaAW7o7pyKZtd+HNluYVB8DzGomDLHnAfHnfTiDtkg4bgIQ3UwQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792465726;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=6+Bs338qJx1nAJsKlYXL4CgEzKR1n6taC//XXZTl8R4=;
	b=c+JIiH6Rz3vYJD3ntRyRdH4S1a3/cB8sFFjlsW9vfmrxy1QIH/h4k7wPCA8KVdsHJJ58
	 CLIoQPnoHBSKJTE+qkyzE6bXg4poQ/O8ouQviZ9VV+sDUpXyk/w7osBN+S18bcMcetFJO
	 9WXyEdchbYTLMDhhQHRKxuYP0cs3Br7oRE8GpoR1KyFUd/Znglqs/+bOqTHdGrCUwqNe9
	 B4fymTE0VNaxc2/NRi00IowopmbzKs5f8CpNaulJqytWOFezPfsC2ehB8II914e88h6m4
	 zFPgkLzWF/uoarbQ2HyYzT2N3B5hp/v747najdP2lUhZ53cPguDRkXeE0em9qSC1cFA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 85A3E1F000C8;
	Tue, 20 Oct 2026 03:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792465726;
	bh=6+Bs338qJx1nAJsKlYXL4CgEzKR1n6taC//XXZTl8R4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=XlzCwkdFoltpsYGrEZviecj5A/AuFT5EicIf081t6WKkbrXnrWzhyNBSDeJcS3rAT
	 MzLGt8KDPqRjMSSV2dKqWJdpD2Vgjg0RWkctBYqVo6Vn9LaBK4aPI7XO14Y2SP37mv
	 6L8kfOtvJ0/6DeUiCpd3tCj63q0ym4p475Fe+xezgxHSomYRfqnsur8x6LKbSKpa1M
	 rOeIEgXvzkaksCVgeLMid0MhJg7FbBSbVQc23tiYD5q3W08Uf8oRR3ao9lcyV9n+1I
	 4QCOEVdXZ/WT91xiiigMsVg9tlpi+mrxqagKiqgMTJGOmeAwD1fwVK9uPUikiD2l23
	 +DoqtIVdSULaA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id EBD4340747;
	Tue, 20 Oct 2026 03:08:44 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Tue, 20 Oct 2026 12:08:47 +0900
Subject: [PATCH v4 4/9] xfs: clamp a pNFS LAYOUTCOMMIT extent before
 computing its end
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261020-xfs-pnfs-batch-v4-4-9230fa2ca4a4@samsung.com>
References: <20261020-xfs-pnfs-batch-v4-0-9230fa2ca4a4@samsung.com>
In-Reply-To: <20261020-xfs-pnfs-batch-v4-0-9230fa2ca4a4@samsung.com>
To: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, 
 Dave Chinner <dgc@kernel.org>, Chuck Lever <cel@kernel.org>, 
 Jeff Layton <jlayton@kernel.org>, Dai Ngo <Dai.Ngo@oracle.com>, 
 Sergey Bashirov <sergeybashirov@gmail.com>, 
 Andrey Albershteyn <aalbersh@kernel.org>, linux-nfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
 Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792465723; l=1903;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=nP9RMvT+2/zi+VUBuU+Zdw9BhC8rbBfOGbPtZzbzLCE=;
 b=PJJKeYHGKbDmd5zcaR1gtO5Pp/W5Fe9pqLdUmfq0kmgYCQxZZDjBjbd1WgYu+I3lyocdVAQTZ
 2AcR4w6j/lVC5UUEGO+HyLgfse/9n1wSeXaHAd55oQ3xrGDyH4AraQN
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com
Content-Transfer-Encoding: 7bit

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


