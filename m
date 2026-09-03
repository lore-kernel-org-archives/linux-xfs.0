Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE81B274B46;
	Thu,  3 Sep 2026 05:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788414593; cv=none; b=GuSpGtkDCi+JkCCa2zlKJMHvcjd3VB6oAPcZEKKqnVV5ejHtxgi0aLf4jS+/9K/YyYWuk40XKph3Q9+99/3zA+nYOFMMWFmLlMHFpOndKONxt8UuQyY0QISWBs1A+hEL0rdVzCbHDOOL1tDH6mh2d0Z1IoBe6odcAGczuJVNOuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788414593; c=relaxed/simple;
	bh=rPPOs8u4XytoxM5tcx7WhPtdGWiQyGD16F9RQ5Eeqnk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NHKcN0Jx0CuNgPqhos+rQz0izTPRw0ahYNv43wiBqxYJLYbspGh5IQtvfMU7B4XJtV3/OpnXp7uAOSj+npcn62zkHLQHdBMvuwLUx/hYu0vuJmvBk/77n4dIEklCqIX8e5i/TlgsRp4s1vmwet1PsKUO9jve8M6C7xTxBLZoe6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PZIea2Bm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PZIea2Bm"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 60EB31F000E9;
	Thu,  3 Sep 2026 05:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788414592;
	bh=8j0aP5zKhZral47ld72z4I4Ol4mpWs8Pih4oQD8ILOg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PZIea2Bm3icKwxqF4dyCG7FBO4dNWtjofxrXieo12JcZxO1MM3jFqQjwVi9j656gI
	 tIjF3wiavStZ603EWxKDeHjEvuxAfh1SYbXWOh334GUhNe+cbhEg+kNrWtc32I9VKx
	 onf+im4GRqpJXmHhstkQwRjiQw+D27syWUyjtby4+U/R5VVqVGwHt+owxaZYnRYSzc
	 Ed+vlL5j68obpVjQhTHvnk4FavUznp0vYYXFW00gmSC2jwXiL8rnEgBrENcBu9I1jG
	 u7bB7v8O44qZ6SrEsBZwDh7kx+mp8+TeGERSfP+edzDZmfFIb6zlBeYg2RI5tTz3K7
	 anFB694UjHZYg==
Date: Wed, 2 Sep 2026 22:49:52 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH v1.1 3/5] xfs: compute dquot checksum after resetting dd_lsn
 in repair
Message-ID: <20260903054952.GV1933798@frogsfrogsfrogs>
References: <178832750681.3508131.6009513367948627110.stgit@frogsfrogsfrogs>
 <178832750773.3508131.8667220003399042973.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178832750773.3508131.8667220003399042973.stgit@frogsfrogsfrogs>

From: Darrick J. Wong <djwong@kernel.org>

LOLLM complains that xrep_quota_block updates dd_lsn after calculating
the crc of the ondisk dquot.  That's clearly broken, so fix that.

Cc: <stable@vger.kernel.org> # v6.8
Fixes: a5b91555403e3a ("xfs: repair quotas")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/quota_repair.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/quota_repair.c b/fs/xfs/scrub/quota_repair.c
index ca3ac6728339d1..5c22bb6ccffa4e 100644
--- a/fs/xfs/scrub/quota_repair.c
+++ b/fs/xfs/scrub/quota_repair.c
@@ -363,11 +363,18 @@ xrep_quota_block(
 				ddq->d_rtbcount, &ddq->d_rtbtimer,
 				defq->rtb.time);
 
+		/*
+		 * This transaction operates on raw disk buffers, so we don't
+		 * have a dquot log item to assign the LSN for us.  Instead,
+		 * set it to zero so that log recovery will always replay any
+		 * logged dquot item atop this buffer.
+		 */
+		dqblk->dd_lsn = 0;
+
 		/* We only support v5 filesystems so always set these. */
 		uuid_copy(&dqblk->dd_uuid, &sc->mp->m_sb.sb_meta_uuid);
 		xfs_update_cksum((char *)dqblk, sizeof(struct xfs_dqblk),
 				 XFS_DQUOT_CRC_OFF);
-		dqblk->dd_lsn = 0;
 	}
 	switch (dqtype) {
 	case XFS_DQTYPE_USER:
