Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F050E233954;
	Wed,  2 Sep 2026 05:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788328065; cv=none; b=LgzpP4s74SrCXjhlDPHSHs69JBQjQBS9jO4ffxinh8eaXHNs/wP8ltuo8LZhrsfEiH1yxISKsqTS0hyhFigFGuk6yti2XHiQKsPQsLzSKJc3mKwzmkZWF6Ifyi2A8Ya9624UgmX5TODK5ASPFbzmx47s0rrrQbp4cXLUQAnIu2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788328065; c=relaxed/simple;
	bh=av3wRSkd8AExY0d7Ti3QNX0okifxFxRM/+Nalky4lok=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TV3sImSd8IjuYjw6oX+HZmRt70jImUqZlGPPZdGLkDBj/TASlOD+N3iMEfvCv4t0Zvl3k/BajJUK77VLODSgXFqaRC7q/SQhkCeXOSGrpyPPx0W5pLoYcDBWnTZU+aEwTTU7v27Ydk0cUpQkJ2l4IX06DITsQhdQvZzSirtcNQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dkAdWXgB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dkAdWXgB"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id CBD6B1F000E9;
	Wed,  2 Sep 2026 05:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788328063;
	bh=ch9lreGMlxqTospRlVNUk8uOY9n9EFKmSSckIED5Xjo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=dkAdWXgBVJfI6XXV2nt0sHxn9PdZK3tBnVRDsmZg9E5nNkytParjYhqAveG3tjcyt
	 0+QqCVSAvkqOIcgvbAtMrWUAIKlx2Exc8c+GlJRPVyLc6BzWvC4XWrV2DR5OCtL2Ys
	 liHGKzB1yuxt5GT2UZ3cPInejo4DOKqzFjs8dS3g2KDsoLHkWM2m5ag9CyhpRDKzis
	 2SdrACmqIxFzeJ1TWNt9Jm6aVnFSo+UvGwVU0FLTXEd13CE6VPQuPWi4sNsgfhFKGX
	 PHBXFBjfycva68LLxJevdX9mvDG6BQpiPMlkwhBjQXhBj6p86T/mc2lkgZh/0W+6oA
	 RmPJwFBejB8ag==
Date: Tue, 01 Sep 2026 22:47:43 -0700
Subject: [PATCH 5/8] xfs: check healthmon outbuffer space correctly
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, hch@lst.de, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178832750372.3507776.3521647111227881221.stgit@frogsfrogsfrogs>
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

LOLLM notices that the outbuf space check in xfs_healthmon_format_pop
isn't quite correct -- it checks that there's enough space to write a
xfs_healthmon_event object, but the outbuffer is supposed to contain
xfs_health_monitor_event objects.  Fix this by adding a helper, and
refactoring all three outbuf size checks to use it.

Cc: <stable@vger.kernel.org> # v7.0
Fixes: b3a289a2a9397b ("xfs: create event queuing, formatting, and discovery infrastructure")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_healthmon.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
index 5b7ae194a6e602..cc06a34c2ebeef 100644
--- a/fs/xfs/xfs_healthmon.c
+++ b/fs/xfs/xfs_healthmon.c
@@ -735,6 +735,13 @@ static const unsigned int type_map[] = {
 	[XFS_HEALTHMON_DATALOST]	= XFS_HEALTH_MONITOR_TYPE_DATALOST,
 };
 
+static inline bool
+xfs_healthmon_check_outbuffer_space(const struct xfs_healthmon *hm)
+{
+	return hm->bufhead + sizeof(struct xfs_health_monitor_event) <=
+		hm->bufsize;
+}
+
 /* Render event as a V0 structure */
 STATIC int
 xfs_healthmon_format_v0(
@@ -801,10 +808,10 @@ xfs_healthmon_format_v0(
 		break;
 	}
 
-	ASSERT(hm->bufhead + sizeof(hme) <= hm->bufsize);
+	ASSERT(xfs_healthmon_check_outbuffer_space(hm));
 
 	/* copy formatted object to the outbuf */
-	if (hm->bufhead + sizeof(hme) <= hm->bufsize) {
+	if (xfs_healthmon_check_outbuffer_space(hm)) {
 		memcpy(hm->buffer + hm->bufhead, &hme, sizeof(hme));
 		hm->bufhead += sizeof(hme);
 	}
@@ -887,7 +894,11 @@ xfs_healthmon_format_pop(
 {
 	struct xfs_healthmon_event *event;
 
-	if (hm->bufhead + sizeof(*event) > hm->bufsize)
+	/*
+	 * Don't bother if there's not enough space to format even one event in
+	 * the outbuffer.
+	 */
+	if (!xfs_healthmon_check_outbuffer_space(hm))
 		return NULL;
 
 	mutex_lock(&hm->lock);

