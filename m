Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1150329C328;
	Thu, 27 Aug 2026 05:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787808796; cv=none; b=jJJQtiJ/pAkqxD02wKPCxbzlS8rY5XG4oSTgRsZ1ibtTP5tjXzv+fRyKZ8MQFKZbAjGa5c0HvEpkHBYZ5FLlqqVAZx9Xqo2aI4utvqYGlA/Wzzghw9d3tj55pIQXCn8QfDO3Ekia8rsJXsWuReIdbN4Uw1X12E5Bj/VaBXES5wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787808796; c=relaxed/simple;
	bh=IWJnDWsGSzyN8PPlO/0SFI7MtX5MVJUQ8+ds2F0NTXg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h/70b4tg2f6A90AYUSKuYZfA13Wgt8CczIwMiyCz+dW5KCOSOhSrtfqGIsbfCDf4rv5E2E8XkvtMxuWtVztz0+ti8jtyANRXJAgWSxhgy7sG97bTDHcQ/RLf1cT2/tAf7UqeqApMxIxtFvKWtO3qqHcqKGXet3RGi9PY/jlhQZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oYNJcc6N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oYNJcc6N"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id DCDA71F000E9;
	Thu, 27 Aug 2026 05:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787808795;
	bh=5xjNxCmKT3Fk+xQQCE0g9SxK19EpigDm/+zpna0m0n4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=oYNJcc6NvwKTUDs8XPCyNIyPRL221jKR6Xd51CbYLqcURo6VcIqGfxNY5EShDnJfu
	 49EeBnXZZMIFwVcywzP2EhVPnnUcnRayM/H/sOkwCQtTOdtwVTTZn+VPQPCssh5mrE
	 CV8MEbFKPNXwM779s7HiLksDDXNmHO1DyboKcebcaKEVo73eFQ4+K93XLXFRdpGvPj
	 JVG+2boi2M2JfkWEdnR7conRA9zuThJtWritjWL3o5Jonouw2uNSY1rgS0sS2Z+2mI
	 1ZGfQjWRguMk/lyjdO7AUl/uS56UrLd7MuE4oXt1MZprguupfNSh4VMV2Wq5DBf8ia
	 ka1oXHKLRJJqg==
Date: Wed, 26 Aug 2026 22:33:14 -0700
Subject: [PATCH 3/7] xfs: check healthmon outbuffer space correctly
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178780640646.3528467.762348909259873415.stgit@frogsfrogsfrogs>
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

LOLLM notices that the outbuf space check in xfs_healthmon_format_pop
isn't quite correct -- it checks that there's enough space to write a
xfs_healthmon_event object, but the outbuffer is supposed to contain
xfs_health_monitor_event objects.  Fix this by adding a helper, and
refactoring all three outbuf size checks to use it.

Cc: <stable@vger.kernel.org> # v7.0
Fixes: b3a289a2a9397b ("xfs: create event queuing, formatting, and discovery infrastructure")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/xfs_healthmon.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
index ef2538a1ea6994..d0e0ecc6fc0c8f 100644
--- a/fs/xfs/xfs_healthmon.c
+++ b/fs/xfs/xfs_healthmon.c
@@ -758,6 +758,13 @@ static const unsigned int type_map[] = {
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
@@ -824,10 +831,10 @@ xfs_healthmon_format_v0(
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
@@ -910,7 +917,11 @@ xfs_healthmon_format_pop(
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

