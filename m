Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0B33914E8
	for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2026 05:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782885015; cv=none; b=lNPQTuLeQLm0vest8OksNYy9zUyIcA35mJbs860scdVveKIsGfj/7kqS7olEyP9k35VHL6mwSs10T++0pMESM8S8tSWq15jSMXeH5jfOskWLBvZUcYErxa/DIaMCMB5mK9LGo6WIkmSY4tp8AtsKg9kcvA9/pSNCTTp7opzYeRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782885015; c=relaxed/simple;
	bh=1Ave0Hd4lY8wPKxxFKGQQeJzsfesxcArc3cctl9DiBM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CSe9mZ+DUepgNK177mGqq1d0/Q3Nwn7dbKkOInfgWRaaigQeRz2WAvwGBlQBVxxvm86BhQBxNGR8FuB3/Ma31B5tJOrwETrdM8yLwMalOJqgjoA45k0bgOMD+SrR6GrE33/m9goAu8QxDyeWIoq0cCpf4wUUGip6NubgTbQPT1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IbBVUA2S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IbBVUA2S"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C56531F00A3A;
	Wed,  1 Jul 2026 05:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782885013;
	bh=kWmzCHdTwbOvqv/HZvbPUaZHEPNI0HUE9SBlwWKRLU4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=IbBVUA2SmWZSmORw4MTAnfAqXdsulNFfNI4hvdhACiDR1zJodyuOt99t8kpbuxS6a
	 6JkF/fU0KgHaZ8ps/imMBEanRb0Pld1WyCXMvKuh8acRt+OpyVhJuN33DMhz7vbS21
	 2UCZBnv4X8LoCr4geg8+RZeKcZUCOfvjzFEUG2ogUOFmtsDfFAjwLGt+YD8lVujtF4
	 TA8Vaa7sMsd0Sf8sV6SeVRBEuuJOuXJl3XUi26ma+IlaMehjiwHOyZEHn9i66G2qjw
	 fyfKGCVMJlKx92EBEUo5Kt4VxaYQm+bg1cWBtU73FmtCsqgaLXm4SHB+pAWeREINVn
	 KGM3UCjcmZh5w==
Date: Tue, 30 Jun 2026 22:50:13 -0700
Subject: [PATCH 3/3] mkfs: PQUOTA shouldn't conflict with GQNOENFORCE
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178288493239.702844.13839738743400440296.stgit@frogsfrogsfrogs>
In-Reply-To: <178288493170.702844.13763176151607587444.stgit@frogsfrogsfrogs>
References: <178288493170.702844.13763176151607587444.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Codex points out that project quota isn't incompatible with
non-enforcing group quota in the kernel, so those shouldn't be
incompatible in mkfs either.

Furthermore, project and group quotas are never incompatible on QUOTABIT
and V5 filesystems, so this is clearly a fat-finger error.

Cc: <linux-xfs@vger.kernel.org> # v6.13.0
Fixes: 525f826429a868 ("mkfs: add quota flags when setting up filesystem")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 3da11c664255b1..a4864c37a8821b 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -976,7 +976,7 @@ static struct opt_params mopts = {
 		  .defaultval = 1,
 		},
 		{ .index = M_PQUOTA,
-		  .conflicts = { { &mopts, M_GQNOENFORCE },
+		  .conflicts = { { &mopts, M_PQNOENFORCE },
 				 { NULL, LAST_CONFLICT } },
 		  .minval = 0,
 		  .maxval = 1,

