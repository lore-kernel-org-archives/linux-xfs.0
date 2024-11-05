Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED0121219E
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730844592; cv=none; b=oyefwS+rxKvjHG9om3R8oQTjW3jphSUMbtmdtM23rZ8LrypWXEft0EDKAvVnTK/XmvzTeHRf9YaVbQSGNypXuzYF9uleSz39z3liLYgDT4B/zR1Umle9qkuhhpMZudIGfOyoEh5dfRgiZdsXh6fbO5//ORiQ7xG+iAKB8CR3UZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730844592; c=relaxed/simple;
	bh=3o2OzYz4z6NdmYM5pKR+q3PpKSxN0KvhKLO+Jkwf3CE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EI3zcB9bd7Aj+Zx8bR5YL0xY3SXIXpI75eqnmrd4WpgXa/5CS1a+mhMNItQxSYqZ7KPTHLKgeF40LXB3M8CPAVtAJ4dDaJOSvWyIFDscT+ZQFc2rLbKSGIiHildvG+rrXmc5qvxeJIUSLRsmrnH9uO/RJnB8Uly90eVu7b638v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JZiY/MRn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JZiY/MRn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DABEC4CECF;
	Tue,  5 Nov 2024 22:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730844592;
	bh=3o2OzYz4z6NdmYM5pKR+q3PpKSxN0KvhKLO+Jkwf3CE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JZiY/MRnfn3QcioLxJsPs7fn3q4ywVvkGbmmWW3Zt7mqHP3NsG9m2IZdSPxip2Pkz
	 OQDXTMq0EpP8IHqn5EDYb66fNyaYCtqZBWQwMnff6BnY/ctEJQeOpcWYREGlz7uPKA
	 to4C+PXpiJajLrzYmd4Wr8uzUkQbKqcvrQuP8cPcRmG7JhA2y8x+tkUg/KSMfiBs+q
	 Vsyn171XHTRIuInBc1rk7tpefNtXKi0HTHdThFtPuwC/2ZljJ2h796zK5/jzxZl9a7
	 DxnZ8xFQmoQFFopSQGV26mQYizJIQRH+/c6Fw7Qk43CxHwy7Bq63AMQEWh1Zml4KKm
	 MB1UdLBWtMGLw==
Date: Tue, 05 Nov 2024 14:09:52 -0800
Subject: [PATCH 13/23] xfs: remove the unused xrep_bmap_walk_rmap trace point
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084394674.1868694.8440529560511480436.stgit@frogsfrogsfrogs>
In-Reply-To: <173084394391.1868694.10289808022146677978.stgit@frogsfrogsfrogs>
References: <173084394391.1868694.10289808022146677978.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/trace.h |    1 -
 1 file changed, 1 deletion(-)


diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index c886d5d0eb021a..5eff6186724d4a 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2020,7 +2020,6 @@ DEFINE_EVENT(xrep_rmap_class, name, \
 		 uint64_t owner, uint64_t offset, unsigned int flags), \
 	TP_ARGS(mp, agno, agbno, len, owner, offset, flags))
 DEFINE_REPAIR_RMAP_EVENT(xrep_ibt_walk_rmap);
-DEFINE_REPAIR_RMAP_EVENT(xrep_bmap_walk_rmap);
 
 TRACE_EVENT(xrep_abt_found,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,

