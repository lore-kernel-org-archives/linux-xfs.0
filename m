Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1198F1B95B
	for <linux-xfs@vger.kernel.org>; Tue,  1 Jul 2025 18:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751393280; cv=none; b=ZTXBQws3kp7NQmWlWRsR0nTirtbTO7C+dmbwQPE8ePPl+BbdrHW8riZUUhyjuy6Mo4c9chBwMxwn44qCeM6paZ0slnF14nzDCUXxuWN3j7hFmOLHH4TG1hVkFOA/cp1C20Wb8MXbt6plbHFGNtTBnI8EPCZLP+gb+PJ/uPrAImU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751393280; c=relaxed/simple;
	bh=g5XwFHOkjAgugXQBpI81e0oIFEGsIKvJXpKzkPmtBas=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NOJmraYUCQTmuLl9yHixjaJxW5W1wroQmAdqwFEdC4/RUF9b95uwaUpz8E4V1VWyI0ZgTo74wrRkAa2OZfNadkonFobXLzfc3fdnIjywdsXr8dtmjactFcyaPdhjaNzdVFr5Ta5tnbMeHiCprIkVqoxtEdziUzfPVKJW/sMpbWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QVtTFCOB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QVtTFCOB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D03B8C4CEEB;
	Tue,  1 Jul 2025 18:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751393279;
	bh=g5XwFHOkjAgugXQBpI81e0oIFEGsIKvJXpKzkPmtBas=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QVtTFCOBZ6NCF7tEWjeOASpsqeMTZ7KBsJf9IZmuP2/vfpQI8VlzxTZhUWOODDmb1
	 jj+mSPGreFPxPaX1gvibv6MYKAkTf45nAXf0JWFUoWChBrX7BBxoRWCuxapFrRAAQM
	 iyp1fMAbqHRAiXm57BInU1nLBlpssbZwlW1+w4MRNeqLiuR4JjgCy6MHRL0K8ZHYAo
	 NwaKzGXwObMhZYwOVcu3Xd+CrZeO+F53bQJ2mWTt0HfF4DQ5Ol77lakoJU6vqxzfWN
	 sxeemTaWxueN0JZnNcKRhs/oVz5Y2AFVIfhcEUW3cdxYwddHMmoJ1x6/y9OQ/QaTAF
	 ZPjXDHVHUltqA==
Date: Tue, 01 Jul 2025 11:07:59 -0700
Subject: [PATCH 4/7] mkfs: don't complain about overly large auto-detected log
 stripe units
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org, catherine.hoang@oracle.com,
 john.g.garry@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <175139303911.916168.9162067758209360548.stgit@frogsfrogsfrogs>
In-Reply-To: <175139303809.916168.13664699895415552120.stgit@frogsfrogsfrogs>
References: <175139303809.916168.13664699895415552120.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

If mkfs declines to apply what it thinks is an overly large data device
stripe unit to the log device, it should only log a message about that
if the lsunit parameter was actually supplied by the caller.  It should
not do that when the lsunit was autodetected from the block devices.

The cli parameters are zero-initialized in main and always have been.

Cc: <linux-xfs@vger.kernel.org> # v4.15.0
Fixes: 2f44b1b0e5adc4 ("mkfs: rework stripe calculations")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 812241c49a5494..8b946f3ef817da 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3629,7 +3629,7 @@ _("log stripe unit (%d) must be a multiple of the block size (%d)\n"),
 	if (cfg->sb_feat.log_version == 2 &&
 	    cfg->lsunit * cfg->blocksize > 256 * 1024) {
 		/* Warn only if specified on commandline */
-		if (cli->lsu || cli->lsunit != -1) {
+		if (cli->lsu || cli->lsunit) {
 			fprintf(stderr,
 _("log stripe unit (%d bytes) is too large (maximum is 256KiB)\n"
   "log stripe unit adjusted to 32KiB\n"),

