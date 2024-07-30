Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5FC510E3
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722301359; cv=none; b=qWt0A0QWaFZxJsB2075dHsIvDSzXg6RROWOpRg0AGmsONHNSkAYFmEFeKvVzrsg4tcOYmJtNBq1BMAbeyhKWDaLr1YhfJgpzzdsAPY4ITA3rPQihDA2qiGJQSgHBcGGZrWxHPafOb3qM/WtJDp6ZU1Mvj4XUacoGp8NqD/sdSp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722301359; c=relaxed/simple;
	bh=mC5tTMBx+/9NW/KLOUpHCgKxj9sUFezGyVcCLb/Vixo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QAvJsLzpwdG+ZSkl9TuOt5gtVRmxMlGhIbSJMch7xBOw//VrtRzR4iKLFXazJgV2YAqoq/8A67MRQnHtNmeazYH658zmeqkaOI+3a/kiWxI9WKeq5vZ5pivrh+4rsnHQ5QBriiuQXNbtzj0/CXnFnBMzSEt0zdUi6h7xM45qNcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iESgWrMX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iESgWrMX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D2B1C32786;
	Tue, 30 Jul 2024 01:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722301359;
	bh=mC5tTMBx+/9NW/KLOUpHCgKxj9sUFezGyVcCLb/Vixo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=iESgWrMXE3eCEIi7zwotdMIUW2I7XSJz7IztsSeol0+1GiNLoPG6ZUigdPCvgrVNk
	 fx3bCF7UP8inDDhCZuORtpTIzssB4Bb6DSB8x7IIRnM4V2uijVjsNsZh7tgc4FkSPR
	 iJQ0nXX/ikmqD42yDDkhjUiRYXPTdtSOdXa+foxSsm8cf8T+N39P8Ncll+kUwzvip3
	 7n7aQt+il9zcw9e0q/HT3ZYb7p6lQAWdCBByiP1CtKFvkBTUhRgbg3mLct39vHm4PM
	 6G8im717Glio5xCaExgBlBiOQoPX0PPnogbhA/qNHQQBSfWMgVHlm7J3j0R3PX0tqE
	 YF5dlpjN8HuCw==
Date: Mon, 29 Jul 2024 18:02:38 -0700
Subject: [PATCH 6/9] xfs_scrub: clean up repair_item_difficulty a little
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229846440.1348067.13462314252802122017.stgit@frogsfrogsfrogs>
In-Reply-To: <172229846343.1348067.12285575950038094861.stgit@frogsfrogsfrogs>
References: <172229846343.1348067.12285575950038094861.stgit@frogsfrogsfrogs>
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

Document the flags handling in repair_item_difficulty.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/repair.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)


diff --git a/scrub/repair.c b/scrub/repair.c
index 5f13f3c7a..d4521f50c 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -340,6 +340,15 @@ repair_item_mustfix(
 	}
 }
 
+/*
+ * These scrub item states correspond to metadata that is inconsistent in some
+ * way and must be repaired.  If too many metadata objects share these states,
+ * this can make repairs difficult.
+ */
+#define HARDREPAIR_STATES	(SCRUB_ITEM_CORRUPT | \
+				 SCRUB_ITEM_XCORRUPT | \
+				 SCRUB_ITEM_XFAIL)
+
 /* Determine if primary or secondary metadata are inconsistent. */
 unsigned int
 repair_item_difficulty(
@@ -349,9 +358,10 @@ repair_item_difficulty(
 	unsigned int		ret = 0;
 
 	foreach_scrub_type(scrub_type) {
-		if (!(sri->sri_state[scrub_type] & (XFS_SCRUB_OFLAG_CORRUPT |
-						    XFS_SCRUB_OFLAG_XCORRUPT |
-						    XFS_SCRUB_OFLAG_XFAIL)))
+		unsigned int	state;
+
+		state = sri->sri_state[scrub_type] & HARDREPAIR_STATES;
+		if (!state)
 			continue;
 
 		switch (scrub_type) {

