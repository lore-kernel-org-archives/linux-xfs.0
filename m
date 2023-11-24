Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A863BB2A
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 23:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MQqrcTTP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28B0EC433C7;
	Fri, 24 Nov 2023 23:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700870178;
	bh=NRifYg+hJnogh2vy8+ZZc6Rvp3MUcvJT/6GXWziJefw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MQqrcTTPTEaBCTRASO1Ka5BmkaAzxQGOlxW/JnMTnWrACdneKoD1Z0FoICg6fGhQL
	 3/16xGP8rY0w9FcIVUjP1ftjh2XO4ezZwRE9NrPRWp+auL+aeFnNV5OU0A8plBg7Mg
	 EJEqtBt7KJ3oitisDmdYC3W1vXk+mesweOjSfaXBecH3JHVtuw4al8KQL1F8l0C/sE
	 huaMB1U8sKPOjZvzwMuYJAydudwN3HRgJyjQL9mDp6zzlmnnTp3HJJ6RZOY1LRTQy3
	 d1cWHmQn5L/l+d5Gc2ov6fXadY7bz/FczPnXMO1+/5ecR9dsteUuMXMXQp5ZvNrrQh
	 fcAyzFfDihrWQ==
Date: Fri, 24 Nov 2023 15:56:17 -0800
Subject: [PATCH 2/5] xfs: check dquot resource timers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170086928823.2771741.7062657907919448653.stgit@frogsfrogsfrogs>
In-Reply-To: <170086928781.2771741.1842650188784688715.stgit@frogsfrogsfrogs>
References: <170086928781.2771741.1842650188784688715.stgit@frogsfrogsfrogs>
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

For each dquot resource, ensure either (a) the resource usage is over
the soft limit and there is a nonzero timer; or (b) usage is at or under
the soft limit and the timer is unset.  (a) is redundant with the dquot
buffer verifier, but (b) isn't checked anywhere.

Found by fuzzing xfs/426 and noticing that diskdq.btimer = add didn't
trip any kind of warning for having a timer set even with no limits.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/quota.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)


diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index 59350cd7a325b..49835d2840b4a 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -117,6 +117,23 @@ xchk_quota_item_bmap(
 	return 0;
 }
 
+/* Complain if a quota timer is incorrectly set. */
+static inline void
+xchk_quota_item_timer(
+	struct xfs_scrub		*sc,
+	xfs_fileoff_t			offset,
+	const struct xfs_dquot_res	*res)
+{
+	if ((res->softlimit && res->count > res->softlimit) ||
+	    (res->hardlimit && res->count > res->hardlimit)) {
+		if (!res->timer)
+			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
+	} else {
+		if (res->timer)
+			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
+	}
+}
+
 /* Scrub the fields in an individual quota item. */
 STATIC int
 xchk_quota_item(
@@ -224,6 +241,10 @@ xchk_quota_item(
 	    dq->q_rtb.count > dq->q_rtb.hardlimit)
 		xchk_fblock_set_warning(sc, XFS_DATA_FORK, offset);
 
+	xchk_quota_item_timer(sc, offset, &dq->q_blk);
+	xchk_quota_item_timer(sc, offset, &dq->q_ino);
+	xchk_quota_item_timer(sc, offset, &dq->q_rtb);
+
 out:
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		return -ECANCELED;

