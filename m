Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EAC8199931
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jun 2026 04:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780376316; cv=none; b=Om/sJ3XGVoNNOdoRUhGWzL3GkM6QOBq0YGlKfS6XJs/DDcxhMKehk2BQS2rsUY6pi+Ll0kb/DJJyPXXYMQh4RApifvQuIjqhZyyS7rtJBXZra6zbzyJxuCNS38hRRfj304dVcETNIM3/I2tUuN4fauwq1KFzWdFKGabZlkJ/C+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780376316; c=relaxed/simple;
	bh=Pqr1L9Nqpg5VQMlXjW4kONKvWvFxhAt3pUv93mtje00=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JQUlci5QsQZl6rpc6kHWd03LQuSbM6nzY6sMl8huMNWYM4QTFrKfOoqO5DhemknlSrMhEKj28FJy+UviIahySkSeqMb95shSm3wBpTJ3znD4bLZEfAgWIgk533xk4q+dsdKtTvwcZCP/L7Bsozo0AJ67NsGQicCQ3GOlGspXlWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e++vQuwt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e++vQuwt"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 965581F00893;
	Tue,  2 Jun 2026 04:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780376315;
	bh=1fPcArWXjVNa7kCK4F0R3tnKeIBuqnRjOfmFbge3np8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=e++vQuwt813tHgmn+j+gLzqE0QG2W5lPP6GsXe3tjtxrrPGba1z65HtMIgj2hEHWv
	 J081Ng77CaVKLHqrPtHG4UYxbEphyz2f2rSfIdZgJ0HJK6oe4a2Wnca2STMlMMeUTH
	 gVu1xjCoYxqYgIzZxYTGYSc3SvJP1vlnmdh1+xMZN+mx/BUKcWJ4a9KDtZ/UsteheL
	 aJDgudtrxBNL8NGM2QKjVA3mCSJI2iHL3HAOfFZxGf3+Tj/3QlKDQX6hH6KYzAZSzb
	 ztdulHRKX32aEO7Op8FaqAYPaYHN4yJ5KmzD2tZPrvCjZvgIHFmg7grZcbcVcKO7XO
	 awFZ2zKon6w8A==
Date: Mon, 01 Jun 2026 21:58:35 -0700
Subject: [PATCH 2/7] xfs_healer: recommend offline fsck for XCORRUPT repairs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178037627080.588879.10740056483979935139.stgit@frogsfrogsfrogs>
In-Reply-To: <178037627011.588879.6129023788062831734.stgit@frogsfrogsfrogs>
References: <178037627011.588879.6129023788062831734.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

If the kernel thinks the repair succeeded but the re-scrub cannot
complete the cross-referencing checks, we should recommend an offline
repair instead of reporting the repair as completely successful or
unnecessary.  Codex noticed the omitted flag check here.

Cc: <linux-xfs@vger.kernel.org> # v7.0.0
Fixes: 6f0f35a87c8797 ("xfs_healer: enable repairing filesystems")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 healer/fsrepair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/healer/fsrepair.c b/healer/fsrepair.c
index 002e5e78fcf22e..3f9bd39de9cec6 100644
--- a/healer/fsrepair.c
+++ b/healer/fsrepair.c
@@ -23,7 +23,7 @@ static enum repair_outcome from_repair_oflags(uint32_t oflags)
 	if (oflags & (XFS_SCRUB_OFLAG_CORRUPT | XFS_SCRUB_OFLAG_INCOMPLETE))
 		return REPAIR_FAILED;
 
-	if (oflags & XFS_SCRUB_OFLAG_XFAIL)
+	if (oflags & (XFS_SCRUB_OFLAG_XFAIL | XFS_SCRUB_OFLAG_XCORRUPT))
 		return REPAIR_PROBABLY_OK;
 
 	if (oflags & XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED)

