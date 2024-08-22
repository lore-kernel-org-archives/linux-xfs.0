Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F97B17E006
	for <linux-xfs@vger.kernel.org>; Thu, 22 Aug 2024 23:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371158; cv=none; b=DdwavGGKylnFsI44sqm3MQVkA7u6+bI3tmQPjCpt3qkIfkME9Ln2akWPrx8cl4yk6HN1Jvv3iRq4tzWuVtjai24chi54wJ/kkgMcOlY/gUlm47btrsRDwwimyfZEmxQr8WM9ae15guqW54aG7bhX5MBAPir3y3GNVv/tiMW7ztg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371158; c=relaxed/simple;
	bh=5WwgPFYIRHb84m1oEVgwekJWBC0347vAB2EpZAcX8wM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J3L10vycNwNgg1hOHGEwhXyW9groLFGA6vzn06xo5kuV2OpacagMEg9htGvhCQvfZiuCK9dke9hshbDQIuKEyvCogFOdUryo9aAJ7GquBb/YGYqycI0D8PoDLJCLq9GHV4f2GMHiZWJcRNhc2hm0GzruhWsrS2gHEuVJIOaS6TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h6PLvlDp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h6PLvlDp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E70F3C32782;
	Thu, 22 Aug 2024 23:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371158;
	bh=5WwgPFYIRHb84m1oEVgwekJWBC0347vAB2EpZAcX8wM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=h6PLvlDpqmd8O+hKPEKXBZxeplloIXgxYeQPai/h7Lc3GOtQs3N7AoVYEalDjO5Z8
	 QVsiesRbBMFmq6Y6zakzVN1gSo/WRvHauVbqGcoavG/pRXEmtivdY4CS6XBADaJeE3
	 FVdsJ3mN1+vorkpKwfA2A4lF4RYObUdVenKawiUwCAvEV+r3kpPw96f3uW5SxSUacx
	 tkZgKah+ZheBKDwytgArAiOVaAlXszpHJhxpJJ0RULTD1VuvVodOU7k/I+3+udPSZh
	 3PdA/t+rN4DM5Ux0n+LHRBI0FShmTRmx27IQcXSuINuNx32wGmWltAQVh9ByJsF6eC
	 Gz3UVYNMhOxEQ==
Date: Thu, 22 Aug 2024 16:59:17 -0700
Subject: [PATCH 2/9] xfs: fix folio dirtying for XFILE_ALLOC callers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: willy@infradead.org, Christoph Hellwig <hch@lst.de>, hch@lst.de,
 linux-xfs@vger.kernel.org
Message-ID: <172437083785.56860.5451255060419862713.stgit@frogsfrogsfrogs>
In-Reply-To: <172437083728.56860.10056307551249098606.stgit@frogsfrogsfrogs>
References: <172437083728.56860.10056307551249098606.stgit@frogsfrogsfrogs>
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

willy pointed out that folio_mark_dirty is the correct function to use
to mark an xfile folio dirty because it calls out to the mapping's aops
to mark it dirty.  For tmpfs this likely doesn't matter much since it
currently uses nop_dirty_folio, but let's use the abstractions properly.

Reported-by: willy@infradead.org
Fixes: 6907e3c00a40 ("xfs: add file_{get,put}_folio")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/xfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
index d848222f802ba..9b5d98fe1f8ab 100644
--- a/fs/xfs/scrub/xfile.c
+++ b/fs/xfs/scrub/xfile.c
@@ -293,7 +293,7 @@ xfile_get_folio(
 	 * (potentially last) reference in xfile_put_folio.
 	 */
 	if (flags & XFILE_ALLOC)
-		folio_set_dirty(folio);
+		folio_mark_dirty(folio);
 	return folio;
 }
 

