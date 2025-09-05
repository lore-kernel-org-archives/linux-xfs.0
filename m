Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFCE331D74A
	for <linux-xfs@vger.kernel.org>; Fri,  5 Sep 2025 15:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757087863; cv=none; b=R+ZcCIo0AZfqm7uNpR9FlekNpKmcqegKUwQRcM4inW4Hf0/f7wgMikBtw7qd4RePFLTTlWh+WflQiHM5FQS10TwZAa88hOhsK35tFGxmWZPD/HNKqz3m/LWhQ02CKjdahIGmLxzNfew0xqFb717VgnHBAfAUFXoGO/sTF/4AubY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757087863; c=relaxed/simple;
	bh=bri3Ks00vfq+wK4Xjs05RqsnWWF9bXREgKXOp/orG8k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iA2lrWm6DiUAR0CmqK/0QnJzdTpWOLv3xCq2TvVUJbSPASaB3umXOniJrC7MiMf2ZWou3w9e/pv28b0R7GqTNjM1/3OEEqRMvHwq2SB5lVy20GniRJHvK242IuzWx6eFtAH29+3iHrVIf9D3FsGk4cZqW+uu3I5h7fHIHSP+j14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V5BRbiAE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V5BRbiAE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29556C4CEF1;
	Fri,  5 Sep 2025 15:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757087863;
	bh=bri3Ks00vfq+wK4Xjs05RqsnWWF9bXREgKXOp/orG8k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=V5BRbiAEKhhpHMJFsscEzX/20tdVnrNUhgw91nPOx0NaFo9Kc5uMcJT/fF2p1mUfG
	 bcDAhBZwnF5B00JkCTqCBjkufjxoIPfpHYcT7WGRJ3yGlJ//BOtlCq4ceDSlDXxfx+
	 BQie7CSEzzE4+2HSIv2HkFoecKK+8KCeUTNwbFoitwmtj7vEa79H23PPPpzNa6LTHD
	 GrwQe2of9VyU+ysGhM5+D0x38by7B9Omf2Im6F1ws+Vk2xuLS5Q6G+4+BLZrxY6gtZ
	 VxVzwlSUE1KPFFzFJdoUYWsiZdOkxH/dak3gYt6uQOJx8Em5z1W1k/t+sTsRp5QNuq
	 IvfL/moT9nlkg==
Date: Fri, 05 Sep 2025 08:57:42 -0700
Subject: [PATCH 9/9] xfs: use deferred reaping for data device cow extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <175708765246.3402543.16473175184767250765.stgit@frogsfrogsfrogs>
In-Reply-To: <175708765008.3402543.1267087240583066803.stgit@frogsfrogsfrogs>
References: <175708765008.3402543.1267087240583066803.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
 

