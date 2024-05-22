Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB121E498
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716348067; cv=none; b=D3Pi6pygiEkU7blmR0XzA8Gsrp3bURuKpgzw7MtAouv6UHjgrjIkqMDpeRlxbi+6GyQ2BiRYCGM4PRqsJoS/o0JMTooNs6KZ6KWS1v8c0mMjmD2DY+BAhL1vlbWP4PtO6/aVvzGu4VCNGRCvsDno+d3+5wnnZNGfI08C+f3kRTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716348067; c=relaxed/simple;
	bh=7u7O72OLgUxnzyjzAhUNcjp0IUqymFin15CRh6GGS6Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vA3y0Bwp22nGPztGOprk3vNBq2X3VNdQG8N0LacND2UlP6u5r2kHJYPC/8eLz1yqwku7XFsztw9I7MuBF2Zj77rI1g/RSW8czJPpnNZ5Me5zqY6mbDJyncLedmR8n/lLivW0GNHgxytuKcspuBndQaXQZFPVQllqH3pNk2/vHOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f9wWAVop; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f9wWAVop"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98615C2BD11;
	Wed, 22 May 2024 03:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716348067;
	bh=7u7O72OLgUxnzyjzAhUNcjp0IUqymFin15CRh6GGS6Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=f9wWAVopCMwAyi/4RSlgYyQzSjjwaEFF1Xo3YiNxfyjdJ0TuqYjp2tmtAoKqlhqsD
	 85mjaBH88tDIf6e7TdgSGkLUITwczCG6UvFRbhL0qpJzrMfewy/ctqS7lTfOirys1s
	 wLZ2I4blb0sS9camAIAZ5MGbLEyD/Hr4ihXmDfTKGq7TCD5/9apqgyvDx/XX0y4Ny0
	 hHWk7tn2gcWciiYH0aTzVX1EQ2tJihxL/XurRFrd0OsRui8dmbxltpuGC0a1rR8RWm
	 4tews5ovw4alzCV7o+e/w39cPiJpRgWhI8IQpDhftXH6GD6eZP2JpyPZwS+RlojWHC
	 5jeYlPeIl6Jpw==
Date: Tue, 21 May 2024 20:21:07 -0700
Subject: [PATCH 1/1] xfs_repair: check num before bplist[num]
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634535088.2483183.10391462553150482336.stgit@frogsfrogsfrogs>
In-Reply-To: <171634535073.2483183.1359823514229331918.stgit@frogsfrogsfrogs>
References: <171634535073.2483183.1359823514229331918.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

smatch complained about checking an array index before indexing the
array, so fix that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/prefetch.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/repair/prefetch.c b/repair/prefetch.c
index de36c5fe2..22efd54bf 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -494,7 +494,7 @@ pf_batch_read(
 						args->last_bno_read, &fsbno);
 			max_fsbno = fsbno + pf_max_fsbs;
 		}
-		while (bplist[num] && num < MAX_BUFS && fsbno < max_fsbno) {
+		while (num < MAX_BUFS && bplist[num] && fsbno < max_fsbno) {
 			/*
 			 * Discontiguous buffers need special handling, so stop
 			 * gathering new buffers and process the list and this

