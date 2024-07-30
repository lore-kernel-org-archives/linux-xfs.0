Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D937E1
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299653; cv=none; b=bu/pVRqSvqqJXp/wSllD6Jsp1a6DBnccfnUoO+ZPv0aip/YCVFUEeTlyzgncVbhzz+9dWCXlaTChG1he5als1me68TcJa25+J4SGz5NjqsqhCjLG7cj6r0VVHgzMnRAnVQHpHv62XCoTD/Bn3I7vqxjnSZGE8nHeUZPld7mmPLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299653; c=relaxed/simple;
	bh=e+jyJHB91Ei9XwyBxYXS+DW/sdx5sQYGiqOg2egX7wY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ve7K7FY4Z9R7TA5QykJ891t1EtoRZQnAOfQUA808O/G1pSesVF60cnOzXICB4uNfKr7+5cll9DMRKT9QPveQTlnbV/YnsicLD/nRf3q+5t9gOIsZtcm2nP2FJWbz2JG4GAEv5Hj2vjzT2oTY5r3nwWnyMoPW52iBuNAVaPWgV1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F70I1neD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F70I1neD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C90A1C32786;
	Tue, 30 Jul 2024 00:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299652;
	bh=e+jyJHB91Ei9XwyBxYXS+DW/sdx5sQYGiqOg2egX7wY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=F70I1neDSOKEsiAKfA6g5nAw7XJ2lP+UabrIXOcLqIXeWrZQxqNsyEdJzoaMdxnC5
	 QTPlpaeu391XFhWZlMmWu4vEkwDS04mUu19XnU+z/DcjQnhrfEM+MwlsZTN3rvasaE
	 K2upprCDMoPcyyM3kWvTG46vAraYD7PvepwmexR2dCGR134casOtHXJqy03cPeMSpI
	 AzAqYHBr8vc0EpIOL2CaOPnwQmj2zNZL4TXkMKeeIPSuwx0pTsgp5F9+vKmsYQxOYP
	 Xk8ebeBlkL9HI+YerwqIR+Q8iwNGS7EhFSusOE0UHMV7vqd996P2tPf4aO0o/2XRJ5
	 x0lai5BVdWwcg==
Date: Mon, 29 Jul 2024 17:34:12 -0700
Subject: [PATCH 040/115] xfs: stop the steal (of data blocks for RT indirect
 blocks)
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
 Chandan Babu R <chandanbabu@kernel.org>, linux-xfs@vger.kernel.org
Message-ID: <172229843005.1338752.10819291299210130711.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: bd1753d8c42b6bd5d9a81c81d1ce6e3affe3a59f

When xfs_bmap_del_extent_delay has to split an indirect block it tries
to steal blocks from the the part that gets unmapped to increase the
indirect block reservation that now needs to cover for two extents
instead of one.

This works perfectly fine on the data device, where the data and
indirect blocks come from the same pool.  It has no chance of working
when the inode sits on the RT device.  To support re-enabling delalloc
for inodes on the RT device, make this behavior conditional on not
being for rt extents.

Note that split of delalloc extents should only happen on writeback
failure, as for other kinds of hole punching we first write back all
data and thus convert the delalloc reservations covering the hole to
a real allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_bmap.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 7b18477e0..81dccf275 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -4977,9 +4977,14 @@ xfs_bmap_del_extent_delay(
 		/*
 		 * Steal as many blocks as we can to try and satisfy the worst
 		 * case indlen for both new extents.
+		 *
+		 * However, we can't just steal reservations from the data
+		 * blocks if this is an RT inodes as the data and metadata
+		 * blocks come from different pools.  We'll have to live with
+		 * under-filled indirect reservation in this case.
 		 */
 		da_new = got_indlen + new_indlen;
-		if (da_new > da_old) {
+		if (da_new > da_old && !isrt) {
 			stolen = XFS_FILBLKS_MIN(da_new - da_old,
 						 del->br_blockcount);
 			da_old += stolen;

