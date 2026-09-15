Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83CA3378D9A;
	Tue, 15 Sep 2026 05:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789450689; cv=none; b=qmQFCuuupR/dO9mLfewdUGnzIHtzqpdozAvs2v6GZCDbcabN3zU5QQiy0KjfHaD0oRVVFqZ7TNQWVJQ0pYgZEUdaaLx6WleEz/lpa32reYfSLGocv1oavcwPyfqd9Z9XGy+F2BEZVhY9DWnF+NsY1bhSEM7mAydEJDSWyhDO3fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789450689; c=relaxed/simple;
	bh=Qm86tfnqwV52xpSL4VEwLOjCZ8F0LHV9ZoTXRinNpC4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pfpIIDIJVJ4aNHGlclwDhFauIdu8icxR/XDEi7bJL+MtaS/GlNYbJsdC7nigR0h0tNpyrnYHt5MnEyy/TljpngCUcDURTHOhwzSaJltI2gKo/gBu6lCHmdyB+7JwmiHb5O1vaHIoUGwvC159tcDYc1B6kTZujlQM1G/M4fRfGO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YQq011eH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YQq011eH"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 212561F000FF;
	Tue, 15 Sep 2026 05:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789450688;
	bh=n0rGnbu6o9Br/mhgBthj8RB3+pCQZPR4VrO9beROccQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=YQq011eHkrdFmhWHoSfw8tVLQxSAo1q72yvj7bx4qp2pSytGj3DLyiLoH3GQ+VovS
	 gK7KjmxZKzt8o2jOH7BL1Xr7U4Jwt2+rjeT6dy/EmcOZbTl/XTfB3tx/zjYV8brMSE
	 GIVYiU90cZOidJA5YoNdQGqNTIoXfzYg9OQTFErJlYn1j82+vmrs2LsnJ+y+d8a2h6
	 xyf9YDusyltUQzJeYMk4tvNgqKLFbUWBfOim56izqlwtuO9WISlcDlDPXgobPYrwl1
	 TP3qzvgj9kgwmLfU7dMxA1dHYE1kMVEDusiuTsfh0oE9EjRLPRhBPZmBlYepfTwF2n
	 ZoC1bINjs+9DQ==
Date: Mon, 14 Sep 2026 22:38:07 -0700
Subject: [PATCH 06/11] xfs: don't merge different file IO error types
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178945048627.3061055.646177261017605740.stgit@frogsfrogsfrogs>
In-Reply-To: <178945048435.3061055.16384804993810925544.stgit@frogsfrogsfrogs>
References: <178945048435.3061055.16384804993810925544.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that we can accidentally merge file range health
monitoring events even if they have different errors.  We shouldn't do
that.

Cc: <stable@vger.kernel.org> # v7.0
Fixes: dfa8bad3a8796c ("xfs: convey file I/O errors to the health monitor")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/xfs_healthmon.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
index c3749675ef1921..2bdd747f1ead24 100644
--- a/fs/xfs/xfs_healthmon.c
+++ b/fs/xfs/xfs_healthmon.c
@@ -247,7 +247,9 @@ xfs_healthmon_merge_events(
 	case XFS_HEALTHMON_DIOWRITE:
 	case XFS_HEALTHMON_DATALOST:
 		/* logically adjacent file ranges can merge */
-		if (existing->fino != new->fino || existing->fgen != new->fgen)
+		if (existing->fino != new->fino ||
+		    existing->fgen != new->fgen ||
+		    existing->error != new->error)
 			return false;
 
 		if (existing->fpos + existing->flen == new->fpos) {

