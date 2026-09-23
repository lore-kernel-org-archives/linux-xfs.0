Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59DC5224B13;
	Wed, 23 Sep 2026 06:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790143340; cv=none; b=LoH9w7Th2TnnSqAI2TTVWgtJsOGKDb2rfrdt5HWvhhZMAk1yUISc1DrCo9jbrzIxetobAcNRumkINm7++J3s8XYQihD46zyQgVB3IMjXv8pS+OeU4X1ji1OtVurpykTM2DOfU+5yxAvDwNEiIbCTHT6tujkMg8WrFC2GBd+lbPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790143340; c=relaxed/simple;
	bh=m6RZ6M29FZSepIlY0FK5Yb8orogPJyjZNO/+mjLJiA0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UZJp02oX7M9pmiVo+//+ylH6yRVBqSlnYKh7v0ECpOfYqBO2tM8tFl9wJYEkxCj/1OA2Z27Q9YqLEoNN3pKbcC2QO+ZkguBr6kefRD1DVWW6IT7iS+6eVfXblbG39yMfMj6+mtdY9wUJAqjPkiUtwz72va0y4oQRHtmXRhpkIjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bInfKBtJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bInfKBtJ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E9A5B1F000FF;
	Wed, 23 Sep 2026 06:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790143339;
	bh=NA2LOO3CYAw5Q54VXgt5Rr8enYtilpRSzZKj8hDiDUU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=bInfKBtJA4Ik66NE9Yb9sSKuAtcHFPpxw4BtAxDy6lYfkw2DO+aKxOLEsxjAqXS8a
	 hMvxOOxxFkf4wrDxOoi0i2Jniddd0ReEq0+X3ZPsaj/CgUWhWzmqrEu7edgwJvYG9T
	 4GTSC3JMO2pYDW4yy2AKQIyQvw6TiTLDvsCH9kVzgZliK14VJ9lkeV9+uatgxEgV9j
	 VArep7FDyDmxaC3xTbHB+0j75RvqWvJab7wcafQMlawJY+bNfdAcdK38BNdxPhYkko
	 t8qcLRO8GU94a5VHgKX2HYoHKVZg7jgIMcqZwt2Sz7w1lPbUhjnor7r/ObNAlcMLxs
	 hjh3EseN0OI0Q==
Date: Tue, 22 Sep 2026 23:02:18 -0700
Subject: [PATCH 06/12] xfs: fix integer overflow problem when setting large
 free areas
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179014159671.1875436.8939376627577757057.stgit@frogsfrogsfrogs>
In-Reply-To: <179014159469.1875436.5857342164999236687.stgit@frogsfrogsfrogs>
References: <179014159469.1875436.5857342164999236687.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM points out that the min_t comparison in xrep_rtbitmap_mark_free
operates on a 64-bit bitmap word offset quantity and a 32-bit
words-per-block ratio.  Unfortunately, I should have done the comparison
with the (64-bit) xrep_wordoff_t type, but used the 32-bit word count
type.  Oops.

Cc: <stable@vger.kernel.org> # v6.14
Fixes: 8defee8dff2b20 ("xfs: online repair of realtime bitmaps for a realtime group")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/rtbitmap_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/rtbitmap_repair.c b/fs/xfs/scrub/rtbitmap_repair.c
index 442a17bf972029..f63aaaff783d50 100644
--- a/fs/xfs/scrub/rtbitmap_repair.c
+++ b/fs/xfs/scrub/rtbitmap_repair.c
@@ -276,7 +276,7 @@ xrep_rtbitmap_mark_free(
 		xrep_wordoff_t	rem;
 		xrep_wordcnt_t	wordcnt;
 
-		wordcnt = min_t(xrep_wordcnt_t, nextwordoff - wordoff,
+		wordcnt = min_t(xrep_wordoff_t, nextwordoff - wordoff,
 				bufwsize);
 
 		/*

