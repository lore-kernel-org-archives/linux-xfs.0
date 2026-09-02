Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6781E155757;
	Wed,  2 Sep 2026 05:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788327737; cv=none; b=Azqr1thWJREBO6HLvyZkOHl4aUKeF4G9Z7uqM/Cxdu7FljwWeFgp4MnPGMaXED4RhVbCtv9hroVyh4fhr1Espd4hWdBHQY9Cs3AXQGpDPe29Squy6Qi5sJi1wclWnb++WJnBllgyCt3QZEP7yPovp7BgCd5VoUiArAmcybLeLKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788327737; c=relaxed/simple;
	bh=MuUMfjVw0YQDp22UeVoiCL3kvKsXW0nEL0YeZlWgptQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LyadYBXWbFZgJQGUcU9Mg2rXv34peTFJPHJVU6MrMymEkN5lWGQxHiGIScH0bwX8Zhcew6NuLyTK84p8qsmf2sqdX5KMaJPd6nvg4zbdotVN04AlpouWXr6fawJXDn+ExbcOn/l4e4DM9zSlYSSufjQ0wwSWWNAftYpP7QLk4gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c437hZL2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c437hZL2"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E09D21F000E9;
	Wed,  2 Sep 2026 05:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788327736;
	bh=MMVtrMNx7oKQD9PsYGOHp/fbkdtEK5WZw2qsP4E3lhE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=c437hZL272EWaGtsoHzrleR8F475IYEc8wo8yOydvYLF+Hv6KU7ilTNjXdjoPpp+2
	 M9Mx057ZRkhEg/zYuBArNycC+r/eUoayRCEDyCGxLiucUtKQQiRRsCsKCWmLsnZv2f
	 SQkc3u6WnLEVMY5GXm0TDMqx18R0rH9GVVs779VKLIUrUDqGLZphyI4qeqmcHKJqYe
	 gc4BKGqD9UlKKPuk5SV1y9OgcczduCUS+xpPT8R2GoEtCGGAMlTAC+h+MwH/9/yPVH
	 OP/ezgeAIY1F06ix972i67UdNFFBi+NSMA0vNf5laKbHDR55+earvk9XUHnLDwONa+
	 JKX18P0oghQ3g==
Date: Tue, 01 Sep 2026 22:42:15 -0700
Subject: [PATCH 2/6] xfs: fix short ifork reaping computation in
 xreap_bmapi_binval
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, hch@lst.de, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178832749052.3506928.14635066427910794988.stgit@frogsfrogsfrogs>
In-Reply-To: <178832748977.3506928.16933046913052359243.stgit@frogsfrogsfrogs>
References: <178832748977.3506928.16933046913052359243.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM got really confused about the update to imap->br_blockcount in
xreap_bmapi_binval if xreap_inc_binval returns false.  The intent of
this code is that we shorten the imap to whatever length of space we
invalidated so that the next iteration through the loop will start
wherever we left off.  Unfortunately, the calculation sets br_blockcount
to the amount of *unfinished* work, which means that we pointlessly
re-scan blocks that we already reaped.  This is benign, but we should
fix the computation anyway.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: 5befb047b9f4de ("xfs: add the ability to reap entire inode forks")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/reap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index 496c6eab555e91..f698b9be3dd1df 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -1399,7 +1399,7 @@ xreap_bmapi_binval(
 			 * far we've gotten.
 			 */
 			if (!xreap_inc_binval(rs)) {
-				imap->br_blockcount = agbno_next - bno;
+				imap->br_blockcount = bno - agbno;
 				goto out;
 			}
 		}

