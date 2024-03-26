Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CAD7128814
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423298; cv=none; b=CTln0vVCnLKZDKczAwF72R9rycGcowEtPoAzzNvefGQNF17HtW2pKdL12x+GfUyzaPgFxlWIiaC7/MWzoAqHV+oivqtVFbBIng7COLEmnyWbdfnMcVcg0rjfwBR9xGdvPWxaCZ7dZNIrN9bPZK4Lp2Wy0LwKwQUVhY/v1L8hvxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423298; c=relaxed/simple;
	bh=UCHhkStYLy5HgnsYFzJaTmQ4BDCfxwCXiAKPazue0mg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c6aeaFOu1TwlGPL8lAuNoddsQBpgIDUJlmf4XJ/eSaOo7c3ASPKKNolERPflFBNeI7wj+w6SbIrpqt4TLeTi7PK4jtlQTKirqkMSiDmlkT25OmWImS4eJ+eLzZ8r/LK2COTq9MDQz5kcFUKpaVOoP3BX8hsf17fpJruZhfvo+Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U4z4ATRA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U4z4ATRA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3115C433F1;
	Tue, 26 Mar 2024 03:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711423298;
	bh=UCHhkStYLy5HgnsYFzJaTmQ4BDCfxwCXiAKPazue0mg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=U4z4ATRAHhX3FDtibnqEzqquP29Az2lJNBuWimLa2vxvKSHPifB0PNNrBRqXq5etX
	 LZWEffQHnQ0s6PjmJYjsTM/cS0gylrE50nSVwk0hH6kXT3EsGxjig494bGjrWnOr7z
	 xRqQSqSOSTuc753oFBKo+tU/LyHylbUpk5BhpkKGIh5w5AYZlPuVfPaTqynWRAdoRI
	 gVhUh41cA8vu5Xrng8n3EMjxDzXK+2ffVJ228fvzR7H9qx2o9QvkmKVo4WHIgB1/N+
	 VdBJFwA7shWtfmknVsZ+xS9ptUnieftoJXCLD4cQlN915asMFKQ7FiAKGA6W4S1Cww
	 TZdtbVU2kuhnw==
Date: Mon, 25 Mar 2024 20:21:37 -0700
Subject: [PATCH 3/5] xfs_scrub: fix threadcount estimates for phase 6
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171142128608.2214086.995178391368862173.stgit@frogsfrogsfrogs>
In-Reply-To: <171142128559.2214086.13647333402538596.stgit@frogsfrogsfrogs>
References: <171142128559.2214086.13647333402538596.stgit@frogsfrogsfrogs>
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
 scrub/phase6.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/scrub/phase6.c b/scrub/phase6.c
index 99a32bc79620..98d6f08e4727 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -744,6 +744,10 @@ phase6_estimate(
 	*items = cvt_off_fsb_to_b(&ctx->mnt,
 			(d_blocks - d_bfree) + (r_blocks - r_bfree));
 	*nr_threads = disk_heads(ctx->datadev);
+	if (ctx->rtdev)
+		*nr_threads += disk_heads(ctx->rtdev);
+	if (ctx->logdev)
+		*nr_threads += disk_heads(ctx->logdev);
 	*rshift = 20;
 	return 0;
 }

