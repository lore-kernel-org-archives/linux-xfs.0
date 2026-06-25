Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 262E228504F
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2026 22:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782428133; cv=none; b=W8psNtRNCTp7c/WvJHVeqo0lKIzJa24+P6zigqeWE12zYid1bMRrSXJyze70IfLuynhjBX63XtR+OJLDBWD6bl9ALYZbtvPfMiokCXQuWdlh58cNotJzRC6Q/N7kIJLyT+mhL5XyTxYvSONc/544HfurO6VBgOOcoayGsVmjhyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782428133; c=relaxed/simple;
	bh=pNkgKHhSMH76ok8TUIxBfmvKJs6me9UqH1Y7EnPRmPI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lLTvaoR+y2WqpuHhhexCUOMCFYx00MJCI5UaUeMsCrkH/hhmBjZqyi/zeQz7Cxhdt7bNUF4Xkx7nSoW5pEs4MS/Oyr9HvCoVQCzxYFNd0XeF/2YWNBFP1o16y/LOvxjEoIjwDeE6WyJNshHVy/ET2SXB+gJYcFkBS8wF0JxrQa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EepmgtT4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EepmgtT4"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 667801F000E9;
	Thu, 25 Jun 2026 22:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782428131;
	bh=C/wTPNwEupBl72926Rs+g+FZMxIa81CsleLM6zRMe3g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=EepmgtT4FAFEAskoJ56IUdol3ehZQODrclK9NiJXRWJqT8vnvhwCjTYZgEm9jkIiz
	 S8jaji0CqCcOd/iWrZicFAcL1dYJ+TOCSkjZ4ut0B92xbfbZjaZ7Nkk+UnBUDXDafm
	 87g0h2cQD70tI9dipO0K07wqKDImebfA3mjYvLX2JFqNC/6WicgxgTRfiY3kkxtcZx
	 cBr2DQ3PuiZ52IxqoCE6F9GjuF/I9+rOKMZsaCUq6FZj9w7vSVc5Iunfy3/9n3KSY5
	 dRlSxCldFEifm1l3Wrg7NTOx5n8mNXLfQcKQcmtmRQEMzh7f0gv2ozzbU35BYQzReZ
	 b7rtkGLHLdPVQ==
Date: Thu, 25 Jun 2026 15:55:31 -0700
Subject: [PATCH 5/8] xfs_scrub: fix estimate of work items for phase 4
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178242801396.1981574.2199805727145890150.stgit@frogsfrogsfrogs>
In-Reply-To: <178242801268.1981574.8079691316092703702.stgit@frogsfrogsfrogs>
References: <178242801268.1981574.8079691316092703702.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Codex complains that the number of work items computed when estimating
the amount of work for phase 4 doesn't include the FSCOUNTERS and
QUOTACHECK items.  Add them back in.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/phase4.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/scrub/phase4.c b/scrub/phase4.c
index 6bd16c23939eb4..744fd92ab195f4 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -297,6 +297,10 @@ phase4_estimate(
 	need_fixing = action_list_length(ctx->fs_repair_list) +
 		      action_list_length(ctx->file_repair_list);
 
+	/* fscounters and quotacheck */
+	if (need_fixing)
+		need_fixing += 2;
+
 	*items = need_fixing;
 	*nr_threads = scrub_nproc(ctx) + 1;
 	*rshift = 0;

