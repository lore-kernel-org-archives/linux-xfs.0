Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E804E5A4D8
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 21:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710797437; cv=none; b=ReGhbwBX/m27QaCEgJ6yviJ0y4dW8l6DfpXEKEjlOeGroAoQLMkbn1//Eribno9AXbQQAaYQ15oaoR3+y0k4SnSBfX8eHLHONRr4CoQCW4BAVOmG94AVEVq29hl4G8alMU6TpJ0NeYsw27K2ELn8vI9PfmV4ZEMnrcNqXvTv2vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710797437; c=relaxed/simple;
	bh=UCHhkStYLy5HgnsYFzJaTmQ4BDCfxwCXiAKPazue0mg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U6mykGb/KWvPiz+QvHL4OhaEQQ4hHKQ9h9J6knhJrC8cVDFu1Ru2x/bWJL99iZbem+iZJ9Nng47CPVLjFVZff7IXTbwTaaCghdBIOZdSRQYhuKrj9CiWfey4xcLKwTQg+CciaSSVQFwrTQu7liLpuD9l5W3aGuQ1bOt9OxGSsxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DPjJJcl3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DPjJJcl3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58686C433C7;
	Mon, 18 Mar 2024 21:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710797436;
	bh=UCHhkStYLy5HgnsYFzJaTmQ4BDCfxwCXiAKPazue0mg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DPjJJcl3a4l8RfEZNHyAdv9K1gmIR3nurACzAXz0ifQBtSQg+vDFVfsqj8CtnE/Kh
	 fyMUQZhS6fQRS2hyu6qF9/sldF34ke2hFWytf7ebsgxscIfMCxdlrhHCjs5vmJwCDt
	 hsZiAZ3/DjY2tK6QXX5fihWJ+l9T611ZIL+XRJeeLxH5ib3fg2MlPh3ZCj1dnQJEHV
	 XCodHGSNGhSDjd4tsnXXB4QT88mKduJv3XnFx+KIiEYJx8K9n/Sa+WyMksEqClr+FV
	 rJmkgHXAV16WqLpl5uqfGdFzMEReto/2ztZAAj0kolu/ptbwb581JTeAJvwqn4c4gS
	 gtAqTYRU2HbSA==
Date: Mon, 18 Mar 2024 14:30:35 -0700
Subject: [PATCH 2/4] xfs_scrub: fix threadcount estimates for phase 6
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171079733004.3790235.15832282031548480309.stgit@frogsfrogsfrogs>
In-Reply-To: <171079732970.3790235.16378128492758082769.stgit@frogsfrogsfrogs>
References: <171079732970.3790235.16378128492758082769.stgit@frogsfrogsfrogs>
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

