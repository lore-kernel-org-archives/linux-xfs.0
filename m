Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F2123C380
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881182; cv=none; b=Yc4obRK/24qYzu63T40FwfzahibNcHmtrMazya+qoKyHYkiXlhLcOwqqnORFdoAnSoNy766cn0u2EI6jyztsebbxIelA3gTW2rTNs1YkzyCdzUjOWnft+No45rkg+rFyFH6XsL2Q0lZcd9Xf8OH5Zk/DgyJvEOQ5TP+9NL6Piak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881182; c=relaxed/simple;
	bh=kgMaJkhQXV+UgnPz12rEaL1HWzP7AemNSeOdsWVPcms=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tigc1979psessa32euIjYKbtxwQ9j1cGBy6qMFmYu93mpXvu7V/TVo0mNHYXA9fI1QuDbRJpYOY6hXlpMbKvV2Xl736o1DygDKBSbj1ft/2gcPRFmzOb8tnKLj/a6mBQAx/JCp8feeUy+z6WYYVAZyG8WHWMIle3BSPq2g6lmuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nc9kf4Bo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nc9kf4Bo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F5F3C4CEDD;
	Thu,  6 Feb 2025 22:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881182;
	bh=kgMaJkhQXV+UgnPz12rEaL1HWzP7AemNSeOdsWVPcms=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nc9kf4Bo1wQbp9HEl7UB8GlHeY8ESIOPav9ruvMT/XsRP/pLWBSpFUhKmTd68Skpf
	 UFe5TEerSXicJh3jW6EiywIhlSFlwvgRw8VwRcOA0RPymeZ1j/FJ1tVj8Kin8DpyMp
	 0YtWaQnEdDKOSr+UNFFlz3Szvu9VH9xshC/DPU8nfe/MnVeeDtBtwsJRCWKGm3Bx9i
	 wxzR7IV7rHhLVv6CcCSIyhP5uXrqbOpKprrT1b728gTQ6OiFGJhL1PFcdKUpvyXkNr
	 bfs31rnbnFpsTbO1N/+6HQfdZYVzbaaEiVIu4mbCC6diMiBocoCCaVu9aPOC0cqyB3
	 BLOQS1rfLy7Uw==
Date: Thu, 06 Feb 2025 14:33:01 -0800
Subject: [PATCH 09/17] xfs_scrub: actually iterate all the bulkstat records
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888086198.2738568.10758609523199339681.stgit@frogsfrogsfrogs>
In-Reply-To: <173888086034.2738568.15125078367450007162.stgit@frogsfrogsfrogs>
References: <173888086034.2738568.15125078367450007162.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

In scan_ag_bulkstat, we have a for loop that iterates all the
xfs_bulkstat records in breq->bulkstat.  The loop condition test should
test against the array length, not the number of bits set in an
unrelated data structure.  If ocount > xi_alloccount then we miss some
inodes; if ocount < xi_alloccount then we've walked off the end of the
array.

Cc: <linux-xfs@vger.kernel.org> # v5.18.0
Fixes: 245c72a6eeb720 ("xfs_scrub: balance inode chunk scan across CPUs")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/inodes.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)


diff --git a/scrub/inodes.c b/scrub/inodes.c
index 8bdfa0b35d6172..4d8b137a698004 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -216,7 +216,7 @@ scan_ag_bulkstat(
 	struct xfs_inumbers_req	*ireq = ichunk_to_inumbers(ichunk);
 	struct xfs_bulkstat_req	*breq = ichunk_to_bulkstat(ichunk);
 	struct scan_inodes	*si = ichunk->si;
-	struct xfs_bulkstat	*bs;
+	struct xfs_bulkstat	*bs = &breq->bulkstat[0];
 	struct xfs_inumbers	*inumbers = &ireq->inumbers[0];
 	uint64_t		last_ino = 0;
 	int			i;
@@ -231,8 +231,7 @@ scan_ag_bulkstat(
 	bulkstat_for_inumbers(ctx, &dsc_inumbers, inumbers, breq);
 
 	/* Iterate all the inodes. */
-	bs = &breq->bulkstat[0];
-	for (i = 0; !si->aborted && i < inumbers->xi_alloccount; i++, bs++) {
+	for (i = 0; !si->aborted && i < breq->hdr.ocount; i++, bs++) {
 		uint64_t	scan_ino = bs->bs_ino;
 
 		/* ensure forward progress if we retried */

