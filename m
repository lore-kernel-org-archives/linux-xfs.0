Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632C92E717B;
	Thu, 27 Aug 2026 05:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787808827; cv=none; b=nbuKLbbPOJjpxu007ad1deGJxRzVxxVfdhPnpl7sBi1QnW9TsEbFCEI4Rgw5hMkBYLDNb13UevkoyYIomMZcxn6GCEAyomdYKcH/nCwkr+JlWRMNJVEW5111KIkZ6oUbIrvjRGCi0wMqyaUOa6ux7Hy7/13wZNJv5DP/0cR4JHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787808827; c=relaxed/simple;
	bh=Nwmy4gP8cW+nohmWk3Z81ZgDec4qcKbKiHazP3nccNA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A2bnzj++Rxit8Vx0rzrAtVlxIhItpLV8p7wgz7fUSmc8+MeQ1hZtFGIXuOPi754ToWynawU5CfKux2Mqwb6lfdSOqeeLtFL6L/9E6NRNUXEZh4mvQwfMY0SVmc89rdRFIu5oqYiBhIFj0uwhRIGNNXdJl+TtlAst3y9pi3+vcvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fkX7YHoQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fkX7YHoQ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E45EB1F000E9;
	Thu, 27 Aug 2026 05:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787808826;
	bh=BULXmfk7VaJxA8h47XhPPvTrorzjGuQdgNwH2nViJK0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=fkX7YHoQCZlg99LWDjGqsn2tve23myKhEebZCslhBN+6j1/2xXSNXvPotmq37Wwvo
	 pU39RWlLZ+NH4+pf56VfzxO4aSLYIRbm+VSDLBoUC/XoJzFXbXgP8IGi8l7OVsh0TE
	 gCKQ66VNpFgSFB6zUzEJJeknotQFN4yltGc/3mGDandsUhPSWRMSh+tZ4ciP0TwpsU
	 vfeBw4qQPVWLMdktxkleH4o/H5aFFlALFikfmipSlD/RyINs2FblQ1guWxxaXyfsLQ
	 TMkXnDnCwYRsKwW6EZcFlHS/q/UF+ILmioOrmJBcDJJQRcNN0RaseE+Y07hzfhT+2u
	 9pHgMAubs4T7w==
Date: Wed, 26 Aug 2026 22:33:45 -0700
Subject: [PATCH 5/7] xfs: bump lost_prev_errors if we lose even the healthmon
 lost event
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178780640689.3528467.18000277895344892972.stgit@frogsfrogsfrogs>
In-Reply-To: <178780640541.3528467.13867917797753503580.stgit@frogsfrogsfrogs>
References: <178780640541.3528467.13867917797753503580.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM observes that we don't bump xfs_healthmon::lost_prev_event even if
we can't allocate or queue a LOST event, which means that events can
disappear silently when things are going very wrong.  Bump the counter
to avoid this problem.

Cc: <stable@vger.kernel.org> # v7.0
Fixes: b3a289a2a9397b ("xfs: create event queuing, formatting, and discovery infrastructure")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_healthmon.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
index 190779f2e13655..38b2ce1263b0cd 100644
--- a/fs/xfs/xfs_healthmon.c
+++ b/fs/xfs/xfs_healthmon.c
@@ -345,8 +345,10 @@ xfs_healthmon_clear_lost_prev(
 
 	if (hm->events < XFS_HEALTHMON_MAX_EVENTS)
 		event = xfs_healthmon_dup_event(&lost_event);
-	if (!event)
+	if (!event) {
+		xfs_healthmon_bump_lost(hm);
 		return -ENOMEM;
+	}
 
 	__xfs_healthmon_insert(hm, INSERT_TAIL, event);
 cleared:

