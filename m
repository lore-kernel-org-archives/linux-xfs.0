Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714C238E8CB;
	Wed,  2 Sep 2026 05:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788328080; cv=none; b=OgLykUyrIzOA0WvNPJR11g2ufVZdUgPaqvX6IB3ff0deFAwRvtrVcXN7Ih5ZrfBEM/56mm5NUvi5Er+Q2FXJh1a5wrhFPdoejDNVbWuyfA+h+wZchuaBtB+MJUkqQsdVL6KGoFmBsSlHoWRDd2y+LxipRwiw34RK/8s7RzvHkNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788328080; c=relaxed/simple;
	bh=HQlkNy7YQtKy4+QpDEjzVEj8yrg+yxLF2+fGrxAft5M=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FLd9lpNOOxINnQ2bZV9mtZBkevLumXtQEEW2jpno9doFE6JZbzgDy0Oq4kHrZLQvJLOeIXZJtM5ky22Dr8a3qmnhPH/DoZWHi1f5ztqYbHZS7fw6pGk2UpJ7B7YuA9umSFiU9lAISzvmvQE7QwarCvQXHQodQ2xzI7ZbpRbr8SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QZXCxB5x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QZXCxB5x"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4D8751F000E9;
	Wed,  2 Sep 2026 05:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788328079;
	bh=gwrZYkTsNq5Dp0L6rLK4wZ8qC87AjruH/U6sRyYEQHk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=QZXCxB5xs6qy12hFi6aSqVGjY9XTECo8lTXNht5c82Cas8UJvpTVwKGLGmp9+8SNs
	 wizR0IcGdqc4a1ip+aV8SWaoTQ9CFuyu9VcujguC6m/7T0nzN3iNQKaDJ3+2LRo0uC
	 qn59jVtu9blpc5a7Py3jOUV7+5PfHI1D/o2byyhCZvdXYe+hm0BvmAHqjy/I8R8WlY
	 C1CIy4s6ZzroRkxOz5POjTGJnX3LmudQFrfzlebT6pol89VR51NjFIzrvZBlqm0k2d
	 yWfmyGC+CBk+msL5e/I/sZG/FZaLSfGHx8gZKXl6ajG6QOVEy06xhSDwfzPttQmIwN
	 6k39yV699zjzA==
Date: Tue, 01 Sep 2026 22:47:59 -0700
Subject: [PATCH 6/8] xfs: bump lost_prev_errors if we lose even the healthmon
 lost event
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, hch@lst.de, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178832750393.3507776.15064687739113236738.stgit@frogsfrogsfrogs>
In-Reply-To: <178832750217.3507776.15975397025387963886.stgit@frogsfrogsfrogs>
References: <178832750217.3507776.15975397025387963886.stgit@frogsfrogsfrogs>
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
index cc06a34c2ebeef..7c1906c4596703 100644
--- a/fs/xfs/xfs_healthmon.c
+++ b/fs/xfs/xfs_healthmon.c
@@ -326,8 +326,10 @@ xfs_healthmon_clear_lost_prev(
 	if (hm->events < XFS_HEALTHMON_MAX_EVENTS)
 		event = kmemdup(&lost_event, sizeof(struct xfs_healthmon_event),
 				GFP_NOFS);
-	if (!event)
+	if (!event) {
+		xfs_healthmon_bump_lost(hm);
 		return -ENOMEM;
+	}
 
 	__xfs_healthmon_insert(hm, INSERT_TAIL, event);
 cleared:

