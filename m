Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 207E1A92F
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 00:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713229162; cv=none; b=cUTzguqx7SiiGbC5sTQzWx+GIgXjMI4bD7E4YFd/iRTfzi4v0X4+byoc1p3osQq9l6JNj14KRKybrs7X8c+1uaZ1+j22wXBThhqkMTZlBGn6AsMM5WbvvJPRphEiMF7Wydftf4FK7qHAkPKsUj1vp1lmf+IPKK6x4Ys/GfW5g6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713229162; c=relaxed/simple;
	bh=63ypp4s9E6ZtKKetNihrqozc0oU5+Z4FKypCyeHyO7s=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EfBwvOTVjBozcThUNI2ur6ZDv3Mp8bHlem+QZszTP8cI/QP/qtV4Hq69oIvWxCwNb2GSL+XVlGkaVyxOLBK8c1bSLN3NXlPQJx+vf+7xyqlrAMjDZ0ph5O0XhtxkAVF/qndC0gS+P0fFtXPzxlkJqQ1d5c0xzPZ6EmNNPYL9F6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ous+LJx+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ous+LJx+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B8B6C113CC;
	Tue, 16 Apr 2024 00:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713229161;
	bh=63ypp4s9E6ZtKKetNihrqozc0oU5+Z4FKypCyeHyO7s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ous+LJx+EfW4/DCBYhG2eI36oT7HzJXic4Uj9AE1eSBo6GDtgi8hF5A/w2ZMXqm4G
	 TeWsLFPNhoSsLOaVEn7fLKNpTljUVqGfmzgpKwS9Mqyf7kicMMvBv+U8BJMuod2lgW
	 qjBn+9eF8uqQO64uy5TOYt01ALi0kHtIRsBrFZMxcQPKhpWfXJ9LrzVtqVbs9hpr1s
	 Fv/OzNnXCOX6KbXA1Q7BMCUcdm/PyjKjUCRvgK9CMIh1ebtwXqpL4r1WDPk9lxdL6/
	 luS+k7CLnJbPHw/AN3c0SFTgbivKriggI2p72kQzfi3joFOp8ZbSjMGpJBGgmosGyo
	 Ci4+n2mc0+fNA==
Date: Mon, 15 Apr 2024 17:59:21 -0700
Subject: [PATCH 3/5] xfs_scrub: fix threadcount estimates for phase 6
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: cmaiolino@redhat.com, linux-xfs@vger.kernel.org, hch@infradead.org
Message-ID: <171322881848.210882.8785564010758627318.stgit@frogsfrogsfrogs>
In-Reply-To: <171322881805.210882.5445286603045179895.stgit@frogsfrogsfrogs>
References: <171322881805.210882.5445286603045179895.stgit@frogsfrogsfrogs>
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

If a filesystem has a realtime device or an external log device, the
media scan can start up a separate readverify controller (and workqueue)
to handle that.  Each of those controllers can call progress_add, so we
need to bump up nr_threads so that the progress reports controller knows
to make its ptvar big enough to handle all these threads.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase6.c |   10 ++++++++++
 1 file changed, 10 insertions(+)


diff --git a/scrub/phase6.c b/scrub/phase6.c
index 99a32bc79620..393d9eaa83d8 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -743,7 +743,17 @@ phase6_estimate(
 
 	*items = cvt_off_fsb_to_b(&ctx->mnt,
 			(d_blocks - d_bfree) + (r_blocks - r_bfree));
+
+	/*
+	 * Each read-verify pool starts a thread pool, and each worker thread
+	 * can contribute to the progress counter.  Hence we need to set
+	 * nr_threads appropriately to handle that many threads.
+	 */
 	*nr_threads = disk_heads(ctx->datadev);
+	if (ctx->rtdev)
+		*nr_threads += disk_heads(ctx->rtdev);
+	if (ctx->logdev)
+		*nr_threads += disk_heads(ctx->logdev);
 	*rshift = 20;
 	return 0;
 }

