Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B3634404B;
	Fri,  9 Oct 2026 06:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791526694; cv=none; b=lyUyuiT2RfW5byg5ns7gBJLg8WOWFU1RtsKOvyIUqEJCPc94nzZ+F6SsurF34QvXqTx6dB9Kqajhrjyaqp9hgSI9oucCG3Cv9MxOmSjRLYK361pi3HWRuhMTu80Buy4NrsAQIWIu6kkUUNEKhNYKDGtpnLZiVSLe6E+wYqZFDHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791526694; c=relaxed/simple;
	bh=GAiff/gy9VVn+86aZv4W2D7W8C2gELB3oO/IVajcuBU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=km8PVhcrpAtx8GlRUiyhaT9AE4Kcd3Fvo8R3mL42fRH3uhSqSth1KVsgh/teWhC3SowUb4HU+MdPcStfTRAo6rGdjzKvQ3eHgEA9Ab/qaJzjJPU+OMYYO6r1oxIxM3Pte0VlnonDnhCpMoSVx3e9ZRwV2ue/OJdVhBwKR87Hl+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RxIM6R0W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RxIM6R0W"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5EE091F00898;
	Fri,  9 Oct 2026 06:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791526693;
	bh=1983ktvh6/z1NTrpEceZ1PKR0rKCPieBDURZu04yUQc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=RxIM6R0WxLw3bodzQzUO8ynYvh8WiylzAtxkJOlevvNuG/eSIBeumoPbVPkweW237
	 ESF/7Vlkd1EOVD8P/9qgyzJfXSLD22EvACm7lZM2lhthfhjEp6aDM92FMV1U1EjiC9
	 66LIt9hSfobrKMf77ak7XxNGH9kHeEOaj3qNGUhBflXMC80SipglkESmHdEc2ZlVOl
	 cAhm75/zDRZlwxHikqZg8fgL424GrtLYK44ivIPnkBzm5rWG0Ws6zkVqBL3UKAzP0N
	 iw9FJGG6S3iYpv68u1F0Gf/vsLxZc4k9V7Bi4ZfnLcshir8UdszvcHbH+gTlagjvA2
	 uPBCEKJhIcuiA==
Date: Thu, 08 Oct 2026 23:18:12 -0700
Subject: [PATCH 13/13] xfs: complain loudly when dirtree checker finds broken
 links
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179151614902.3163896.7168931003277489322.stgit@frogsfrogsfrogs>
In-Reply-To: <179151614535.3163896.2744921556354655977.stgit@frogsfrogsfrogs>
References: <179151614535.3163896.2744921556354655977.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM observed that the directory tree walk code bails out if it finds
broken parent pointers along the way.  However, it flattens the return
code to zero, which means that we can end up in the repair code having
not completed the scan.  We should never proceed with a repair in this
state, so let's mark the scrub incomplete and exit.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: 928b721a11789a ("xfs: teach online scrub to find directory tree structure problems")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/dirtree.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/dirtree.c b/fs/xfs/scrub/dirtree.c
index 887383d2e94104..11a9dea03d87ea 100644
--- a/fs/xfs/scrub/dirtree.c
+++ b/fs/xfs/scrub/dirtree.c
@@ -860,7 +860,8 @@ xchk_dirtree_find_paths_to_root(
 				 * A parent pointer of @sc->ip is bad, don't
 				 * bother continuing.
 				 */
-				break;
+				xchk_set_incomplete(sc);
+				return error;
 			}
 			if (error == -ESTALE) {
 				/* This had better be an invalidation. */
@@ -981,6 +982,7 @@ xchk_dirtree(
 		 * parent pointers are corrupt; this scan cannot be completed
 		 * without full information.
 		 */
+		xchk_set_incomplete(sc);
 		xchk_ip_xref_set_corrupt(sc, sc->ip);
 		error = 0;
 		goto out_scanlock;

