Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FCC123C4F3;
	Wed,  9 Sep 2026 06:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788933784; cv=none; b=hz/CxAw+D0wfM2W8m8mWRpwibip+hyHYdpoqNnofhj1PPBEiK94tP8JnrB/oCXRJ3QmqBELtNTdFs91u6+IXh2Dy6CTmVII2I+VkhmM4sSEWXxI5dtrHJg9ROmA5gOCPi9ZwFOrcTll2ljUFUSEacZz4MxXLVL/jJf6SiBE8AWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788933784; c=relaxed/simple;
	bh=2MVrFZHK6kW1mkiwdodzVcnDKkjH0pDbnD+ouAL6gc4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TAAzyjqf3BhBZP0fR/3EPtTray9FYIvP6qe8BpQglZp6fEu/JdYnvPTHDGlAnFpYA2Ij8XI3OasPS3nhs9d30DYWTgxgitjF33RRwEcgJy3WG5cYraUTF9u6bE1OoRGIlqo5qNtiy+mM4DrfremexhPlqB9EMNTElWwfPZVITac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CFQ6jV/g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CFQ6jV/g"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 68BE31F00A3D;
	Wed,  9 Sep 2026 06:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788933782;
	bh=UTdTU+gtoXg94bIhp44lNEFePRmx3UylopforKJJcUM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=CFQ6jV/gSweqxMiFFVE77lMlfQzQl2na/hADHUdIx7+UJ053WW7ndLHl2UQxJA7wW
	 QAQXFYR2Z6W2k1cLEv7t19nT2TFF5QvvZIAg1zwTGGZ6FUw4ARepk3PNfuSwTZVv21
	 VroP7JjqC30zQppC8eMaDFnU4JbfSG3kKVOFML6dWpIHJx+nJFn9wIRVorlS+C0uDo
	 aMsQpk6Pnouq9CNNB5S9zJVfhI1tVG1q1N02v4RahYnK+kruWImoL+adxCK1o7+RUP
	 F9DLgfGAOqQwdaiIl8Gguhubm+3LUs1/FnHXDwhCD//qkFR3eOkQz+TaVM0nmTe2qV
	 2arzhYg7w54jg==
Date: Tue, 08 Sep 2026 23:03:02 -0700
Subject: [PATCH 1/6] xfs: snapshot scrub stats when rendering them
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, cem@kernel.org, djwong@kernel.org
Cc: cmaiolino@redhat.com, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178892936205.4057682.11929830543923107453.stgit@frogsfrogsfrogs>
In-Reply-To: <178892936145.4057682.2272084577851638021.stgit@frogsfrogsfrogs>
References: <178892936145.4057682.2272084577851638021.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM complains about concurrency problems in the scrub stats code
because xchk_stats_format doesn't synchronize in any way with updates.
These stats are only reported through debugfs so I don't think it really
matters, but I guess I exist to make bots happy now.

Note: We snapshot the entire stats object with a spinlock so that we
don't have to worry about users seeing slightly weird numbers (e.g.
invocations has incremented but none of the outcomes have been yet) if
we race with xchk_stats_merge_one.  This isn't a hot path.

Cc: <stable@vger.kernel.org> # v6.6
Fixes: d7a74cad8f4513 ("xfs: track usage statistics of online fsck")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/scrub/stats.c |   32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/scrub/stats.c b/fs/xfs/scrub/stats.c
index 76f2515188d1b1..f3f1fbfb6d9955 100644
--- a/fs/xfs/scrub/stats.c
+++ b/fs/xfs/scrub/stats.c
@@ -99,25 +99,31 @@ xchk_stats_format(
 	int			ret = 0;
 
 	for (i = 0; i < XFS_SCRUB_TYPE_NR; i++, css++) {
+		struct xchk_scrub_stats	fss;
+
 		if (!name_map[i])
 			continue;
 
+		spin_lock(&css->css_lock);
+		memcpy(&fss, css, offsetof(struct xchk_scrub_stats, css_lock));
+		spin_unlock(&css->css_lock);
+
 		ret = scnprintf(buf, remaining,
  "%s %u %u %u %u %u %u %u %u %u %llu %u %u %llu\n",
 				name_map[i],
-				(unsigned int)css->invocations,
-				(unsigned int)css->clean,
-				(unsigned int)css->corrupt,
-				(unsigned int)css->preen,
-				(unsigned int)css->xfail,
-				(unsigned int)css->xcorrupt,
-				(unsigned int)css->incomplete,
-				(unsigned int)css->warning,
-				(unsigned int)css->retries,
-				(unsigned long long)css->checktime_us,
-				(unsigned int)css->repair_invocations,
-				(unsigned int)css->repair_success,
-				(unsigned long long)css->repairtime_us);
+				(unsigned int)fss.invocations,
+				(unsigned int)fss.clean,
+				(unsigned int)fss.corrupt,
+				(unsigned int)fss.preen,
+				(unsigned int)fss.xfail,
+				(unsigned int)fss.xcorrupt,
+				(unsigned int)fss.incomplete,
+				(unsigned int)fss.warning,
+				(unsigned int)fss.retries,
+				(unsigned long long)fss.checktime_us,
+				(unsigned int)fss.repair_invocations,
+				(unsigned int)fss.repair_success,
+				(unsigned long long)fss.repairtime_us);
 		if (ret <= 0)
 			break;
 

