Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D157B665
	for <linux-xfs@vger.kernel.org>; Thu, 28 Aug 2025 14:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756391414; cv=none; b=aVVkYIyCCnGem18AYDr7rSHdo4C+Kn7iBt+UGEhVb4LBt0h4vRRJEh1XmJjsNS0onHr5mY4Qefm6fq87+sk+RlHrLgJuLhS12xCHSuyqJM3MD1paTFJ8CEvHeQb6/pg9SlnGQYxn0VN55AmXcknwCJCnOg2yWHArEopQ3AvaMaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756391414; c=relaxed/simple;
	bh=a09TfBohgq57ioZli068/UJ1D1NqVT89Skdfpb3ROxM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c/T5nfuJ5XmoQlFaEkF7Es3HfwGeaBzYuOIkgBtcLCuHtKJeFjNuslMTYSQGPRMg100zyKBAVRuwRySVyWUVL793TIcLnl8IgzL+PoLvpD+LJJbFd2b/55qkxEKUaLQEMS3E9+X78VYcyWXqhBz2Mg69CqNdCPpH7hbivolEOVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZKQnyf5U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZKQnyf5U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B49D5C4CEEB;
	Thu, 28 Aug 2025 14:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756391413;
	bh=a09TfBohgq57ioZli068/UJ1D1NqVT89Skdfpb3ROxM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZKQnyf5UuCaSj30niOwIgUGeXbfVyJFelF4li6f/0/4yrBNZHoIq/BXeh9Ojc9n3X
	 h6/RH1ztjr1kw95uMJGkfzVTS68bdbeNhg0r2Q3VXGqzYbkuPFSOOWkDc0jDW//Ed8
	 zJvsPB7PxehcN1+U2Dx8XcZfEzm4TouUziUk6E3sr5/w+zTGTbcISqUdl3Ie4NxSGG
	 ljVgjMzCZS/DkEFTIEKTxPMX4zrc8P/ZnRcc7Nu8UoUQeWPEapb+0guVWNWVuKj22N
	 E3zEBDJ+we4zVecTpiosY4YL/4hnnaPSEE0JqofXFU8RxqhbeVTl6PAcpuUn7i8MfS
	 il+5LLBYulyZg==
Date: Thu, 28 Aug 2025 07:30:13 -0700
Subject: [PATCH 9/9] xfs: use deferred reaping for data device cow extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <175639126626.761138.4174062470780044970.stgit@frogsfrogsfrogs>
In-Reply-To: <175639126389.761138.3915752172201973808.stgit@frogsfrogsfrogs>
References: <175639126389.761138.3915752172201973808.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Don't roll the whole transaction after every extent, that's rather
inefficient.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/reap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index 82910188111dd7..07f5bb8a642124 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -445,7 +445,7 @@ xreap_agextent_iter(
 			 */
 			xfs_refcount_free_cow_extent(sc->tp, false, fsbno,
 					*aglenp);
-			xreap_force_defer_finish(rs);
+			xreap_inc_defer(rs);
 			return 0;
 		}
 
@@ -486,7 +486,7 @@ xreap_agextent_iter(
 		if (error)
 			return error;
 
-		xreap_force_defer_finish(rs);
+		xreap_inc_defer(rs);
 		return 0;
 	}
 

