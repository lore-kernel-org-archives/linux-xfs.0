Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C792C4A68B0;
	Tue, 13 Oct 2026 06:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871656; cv=none; b=qbYBvMSrDVxKcXPUTJ2ZIgZQsFeG2RSVXGssajGyAW8yd85NAL/FpuTikZbecupywfM42kqngcd6528PsY8PfdZrFtb2gWHOTW9lzsoJrJOZoYfoxnZY8Fe9kebuEptzXfkcMg9xptA3NO5IVJChBYGPjZT4iXKxEbNSSdZgf0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871656; c=relaxed/simple;
	bh=NmvLkxaVGX6DHBr31r62ZbeQ8Lpd+xa4sX6Zm6d/o5E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K6ZS6laYYnBKxXQgObtON08JhLAwGYRze/x8Yr0xTpp+OMZEPZpoo0WTXrOZPVlqY7rPCceV4H/uQoIHkz7yq3daHT3Y5lAGP22NePsUNHv4jRcnwAj8W8WUDRdySt82DV9eVrj0qQhdxx+U/zlkHTeQUwW5l2D6qyLcJ57NaNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uk8L5/Du; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uk8L5/Du"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B2DB91F000FF;
	Tue, 13 Oct 2026 06:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871653;
	bh=LyNLLZhgZIW7lanugMW3bZunIcg+s43aA8pHZELbLqQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=Uk8L5/DuIqpRGYeaaFhiRfGQW2L4/SZqYOdH9X21Yzwwzw4CJmfL2A+/p/bPVtZzs
	 8nyZGgx8/ydHVoYO4BnHdPpH0/AtciaRlvYq0+Sh9Ard0noPBdmWdpTCbl1jOEj6lz
	 37ka41CVGA6Jre0H9FrTovdk0HNXd/TTNNPgwcGXUp63/WLondRYzAYysS7gDIP95l
	 cSPheApumvza/FlRRSJbWe5+BWO2xVW/sRiQ6CG7TzObyAHNQzEo+5MkVMh9JkPoQ6
	 tYU9+OuCgrAX4zMQwp2Y336rSKHmmR7FXqMbvh+qc4IMADjV2hpiJliGubce2FHq8w
	 vJ4nZf3U/lt6Q==
Date: Mon, 12 Oct 2026 23:07:33 -0700
Subject: [PATCH 09/12] xfs: clear set[ug]id mode bits when zapping attr fork
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179186107333.1898400.13944973882659448309.stgit@frogsfrogsfrogs>
In-Reply-To: <179186107061.1898400.3978552773417541744.stgit@frogsfrogsfrogs>
References: <179186107061.1898400.3978552773417541744.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM observes that zapping a file's attr fork could result in ACLs
being removed from the file.  Because we have no idea what we're
deleting, we should clear the setuid and setgid bits in addition to the
access mode bits so that nobody can access the file.

Cc: <stable@vger.kernel.org> # v6.8
Fixes: e744cef2060559 ("xfs: zap broken inode forks")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/inode_repair.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 4b719ad64ace8c..25e71e7d472f36 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1313,7 +1313,12 @@ xrep_dinode_zap_afork(
 	 */
 	if (dip->di_format != XFS_DINODE_FMT_BTREE)
 		dip->di_forkoff = 0;
-	dip->di_mode = cpu_to_be16(mode & ~0777);
+
+	/*
+	 * Zapping the attr fork could remove ACLs, so we clear suid/sgid and
+	 * all access mode bits.
+	 */
+	dip->di_mode = cpu_to_be16(mode & ~(S_ISUID | S_ISGID | 0777));
 	dip->di_uid = 0;
 	dip->di_gid = 0;
 }

