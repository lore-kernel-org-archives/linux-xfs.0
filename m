Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062D8385D99;
	Tue, 25 Aug 2026 05:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787636190; cv=none; b=OMl2rJp1XlH55GBmiujC1PxeLa/sLdKagA3wQXLE3sV4yfFvuZ5ygQG2NjwdNb6afnymRZ/aFUSjoHHcsX9MhNWW+hOVisqMnFsMOQSvHm5fi7N1poi9NeJ8VcIjIK8W4Km9Ytf31XIDP+sCN/NRpihHYDFijJ08E8meOATW/fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787636190; c=relaxed/simple;
	bh=cBcgfm1PoufvtPRBUwZj8JQcfEsC4PhNT69WYMOlm0s=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U3iiivnBRr/ikFM8LFSbiELkG4K15fyl5jCJw3bu9kzkYsv8f48zTVWZhUNPSt2i8mmkiVuCcVsErj51PGbXSD4HsCrmvmW+XDXiNUa9q656IBs4sgkJ9KhFKaYChiDCQ4c7gVdBKCDWGuaVTxgx8penBJIOGfFqvZGJUKhscog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KBOzdPEf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KBOzdPEf"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8FB4B1F000E9;
	Tue, 25 Aug 2026 05:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787636188;
	bh=47ejAXxuoA+KqaDHei6yN9sb9KGczVNI6YPQ8fSbNsw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=KBOzdPEftrwRNxEmHJ2evHWUgI9TCRBKvexgk/Cg52t9aXHZi8Q/Gohdt9C35gEgo
	 0nZ9BW8KQOPrQHzFcblfod2UWWDMqNvJ01XEiSU3U+8LHKsVI/2RGhBexbJ9NKRpNt
	 8Pv+LAGO5tG3DhkwMccpViDhOZBGUmusN/ndVzrwOFtoHq56z/fNDt45gDBlSw/9xF
	 vkSigAwqk9IgFDUTkFT+XX72maP2245GoIMVE/h9XPacCYImmgsNtmHo2OC42CKU8G
	 28Tt3tstTlYMbWIok38zhSqTO6uH8DmVSS/MAlhKUJDCKpaPZSg9xO5gnADugzCtyk
	 kZhiWKjXAw2Yw==
Date: Mon, 24 Aug 2026 22:36:28 -0700
Subject: [PATCH 2/5] xfs: check healthmon outbuffer space correctly
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178760941123.944364.14413050986149192404.stgit@frogsfrogsfrogs>
In-Reply-To: <178760941052.944364.16602293998794359025.stgit@frogsfrogsfrogs>
References: <178760941052.944364.16602293998794359025.stgit@frogsfrogsfrogs>
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
 fs/xfs/xfs_healthmon.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
index 166ef0d5864486..a2ae15a262a510 100644
--- a/fs/xfs/xfs_healthmon.c
+++ b/fs/xfs/xfs_healthmon.c
@@ -739,6 +739,12 @@ static const unsigned int type_map[] = {
 	[XFS_HEALTHMON_DATALOST]	= XFS_HEALTH_MONITOR_TYPE_DATALOST,
 };
 
+static inline bool
+xfs_healthmon_check_outbuffer_space(const struct xfs_healthmon *hm)
+{
+	return hm->bufhead + sizeof(struct xfs_health_monitor_event) <= hm->bufsize;
+}
+
 /* Render event as a V0 structure */
 STATIC int
 xfs_healthmon_format_v0(
@@ -805,10 +811,10 @@ xfs_healthmon_format_v0(
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
@@ -891,7 +897,11 @@ xfs_healthmon_format_pop(
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

