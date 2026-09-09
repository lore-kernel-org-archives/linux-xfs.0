Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F036338AC7B;
	Wed,  9 Sep 2026 06:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788933908; cv=none; b=JwmXDkYi0FUjqCHWJbmD/wVTKLIhYXWoxUMfUyHXBSLh6hB8wdMwDVQ1ZZDu1DFNjJkRQ++6QgaZNZVgzDS/1E29gs0Xwa5+BBivU7+XP1uy1c7jINsWAjVAt1XGZf06ZUUwwZjLFbnA4vvqJjr1dUqxVq6YOt2JQ13X3dz9Jpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788933908; c=relaxed/simple;
	bh=UafqX1mbi0WlP7Jfzcur0X/IZu6xE9PDbsdNwMyV3HM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ip6Igq3+Dkm3eTWxNskAiKitHsfRMU5ACPka8jpNg67oC6AKTdcXh/3Rzznt4VaQruMn6KGRW6s6P5H7+UDZyaYwmKQD+rgajCzl7PZztSp9kDTZWQNWvXlh0qV2aIsnrVEb5+KDqbkatSDIE48qyZK0HydNN+X44NxA95IW0vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U4R/x92u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U4R/x92u"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7ACC91F00A3A;
	Wed,  9 Sep 2026 06:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788933906;
	bh=4KHeLpCYHllrsnZCOZp8PW4spteWy5Cgd9AOhUQGj+k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=U4R/x92u4yvxCAT5atvPrQ5zQVbpGkeAkBjNbYDoHcDToJap+ga3h05C7EKm1v24K
	 uecyQt4FtEln3aBOQVGvIRsPWVLeOYIhi/CszOL7eJ65JGeH9OKso5BKktiw08WUiC
	 stIr2dbj8TItyA6E98NsVIWaByEA4h4bYJDYYDuREHjY0vYjsOUUpPFe2TdYfiA1C3
	 XHwB65sfrF+wcU46Nva7wIx4DgZQSRqDOV1kI2iDtIGH674UCe6jGp2sI2GzcEFX/F
	 iM83dh99R/r2C9q33WXL0nt1vwQSYKLhFzNdJOyTGV8NMZhkc5q8Mdz4+uOJ2MMjJ/
	 nuOL71F5ZM9yw==
Date: Tue, 08 Sep 2026 23:05:06 -0700
Subject: [PATCH 3/7] xfs: fix rtrmap cross-referencing elision logic
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178892936685.4057962.15653638717743353287.stgit@frogsfrogsfrogs>
In-Reply-To: <178892936573.4057962.16225191041041958394.stgit@frogsfrogsfrogs>
References: <178892936573.4057962.16225191041041958394.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM points out that xchk_bmap_xref_rmap_cow skips the cross-reference
if the data-section rmapbt cursor is not present.  However, this is
broken for realtime file data fork scanning, because they will have an
rtrmapbt cursor and not an rmapbt cursor.  Fix the behavior by removing
the cursor checks because xchk_bmap_get_rmap already accounts for that.

Cc: <stable@vger.kernel.org> # v6.14
Fixes: 037a44d8277adf ("xfs: cross-reference the realtime rmapbt")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/bmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 401c278725d216..3b0f1dbd9147ac 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -274,7 +274,7 @@ xchk_bmap_xref_rmap_cow(
 	unsigned long long	rmap_end;
 	uint64_t		owner = XFS_RMAP_OWN_COW;
 
-	if (!info->sc->sa.rmap_cur || xchk_skip_xref(info->sc->sm))
+	if (xchk_skip_xref(info->sc->sm))
 		return;
 
 	/* Find the rmap record for this irec. */

