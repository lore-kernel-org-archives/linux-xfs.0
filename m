Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398181E7C3B
	for <linux-xfs@vger.kernel.org>; Mon, 18 Nov 2024 23:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731971259; cv=none; b=m1yVnxuLYZs1ca5gKvt7QwLUxu5c7M5T9BxsZuT6S5Ap/JBcHIcsxXyYbAkXTgTxlS7eeb9NyOdNeLRQL/hNxjshf1xe/nTDopDBccYdnV+kBx266DANDfaF5O07zcIBU/9Hf0J4Vse+GIsH3R/hBHwnHFYvm5rBe49NKoUFNRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731971259; c=relaxed/simple;
	bh=c9AUpHCYY+9okRcWvd+LnLPTyK+qs3XJxUZgIDEzvOU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DSN0CE8OQ7nMB3+h8iwUAehEBljc07cNN8FsBe9iCoJAY7GbLSksyUStoniJyiJpmusjfAwDeFklt22HBSHI8ENdEjAA2tlXHdGuMgx0qx/ZDefMJqgjRQqFNCzIIPbDsOEACm3q43KC/lblnpZAdq9bnWYWqiQhaXyvBVlBpj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F5erkKTm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F5erkKTm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15E4EC4CECC;
	Mon, 18 Nov 2024 23:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731971259;
	bh=c9AUpHCYY+9okRcWvd+LnLPTyK+qs3XJxUZgIDEzvOU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=F5erkKTmfgFy44R3YoWLfteouTyd/FXMucmliTtL1cL5f9/pXeahRNoXlNDHRna1R
	 zyKa3RNN6WCxhfHvdipTu5Hvj8f0xtQg0jrzjVLaymepUPgLZTxAd+ZEaK9M3GLzON
	 G5iatRNVrQVHyYzGGxKztKguTvVxmz3sX6Gzh/UhC3gkneumwYwDUO2mBg2YY9VSHQ
	 b5Et5zcbFFS//L7kHDCR8ihzWmGLo3owUhbHQhivfWTQulWRfh/JZOHN3xazld4UIR
	 LTUa1Y8J5wNwvzV93cHs8Gk0VISBcjdVNMXo0NMXSJzyNrqW2Qlo10NbmHLDzIiq6Z
	 Sk8vIa7gdvHxg==
Date: Mon, 18 Nov 2024 15:07:38 -0800
Subject: [PATCH 1/2] xfs_repair: fix crasher in pf_queuing_worker
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173197107024.920975.1049694801707645008.stgit@frogsfrogsfrogs>
In-Reply-To: <173197107006.920975.13789855653344370340.stgit@frogsfrogsfrogs>
References: <173197107006.920975.13789855653344370340.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Don't walk off the end of the inode records when we're skipping inodes
for prefetching.  The skip loop doesn't make sense to me -- why we
ignore the first N inodes but don't care what number they are makes
little sense to me.  But let's fix xfs/155 to crash less, eh?

Cc: <linux-xfs@vger.kernel.org> # v2.10.0
Fixes: 2556c98bd9e6b2 ("Perform true sequential bulk read prefetching in xfs_repair Merge of master-melb:xfs-cmds:29147a by kenmcd.")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/prefetch.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/repair/prefetch.c b/repair/prefetch.c
index 998797e3696bac..0772ecef9d73eb 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -764,6 +764,8 @@ pf_queuing_worker(
 			irec = next_ino_rec(irec);
 			num_inos += XFS_INODES_PER_CHUNK;
 		}
+		if (!irec)
+			break;
 
 		if (args->dirs_only && cur_irec->ino_isa_dir == 0)
 			continue;

