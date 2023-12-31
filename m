Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F405C127
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pHYXELNJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0CD0C433C7;
	Sun, 31 Dec 2023 22:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063093;
	bh=SrhB8mugVbQ9zJLM+XmpW4BJaKtrVJXwze2/bTcCVBA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pHYXELNJ/myiwgWY+1JmxcTF1cAm5IoYBsIiXMWymGt4YpHky946dIWevxmOvJmSY
	 ap5jSNQ3gcnJ0xKdyodGfEkU1FWN0fSXIyJRMXfWbQETFrzfyj9DKXW1Ajr0/XPy0W
	 zVCsxtj+StJF3mpqBvuauX2nfImzkOzxM02hT7JWsyimrcRaFZvrgTHA7h53qgIWoJ
	 NOzaJzIm84qcf6dEwIklBSngniIPmQMv4V5qD6BBSC5MC0KaXXVbUZLnZ5/DN5PNOR
	 GdX/31FXZOiuKZP9PYzpzcaZE8wZzG06aViWxDPmHFawVvI6Q23sPrwhzIftHvF3Yg
	 auPiXt3lRHV6A==
Date: Sun, 31 Dec 2023 14:51:33 -0800
Subject: [PATCH 4/7] xfs_scrub: don't close stdout when closing the progress
 bar
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405001510.1798998.11376037821302305142.stgit@frogsfrogsfrogs>
In-Reply-To: <170405001452.1798998.1713163893791596567.stgit@frogsfrogsfrogs>
References: <170405001452.1798998.1713163893791596567.stgit@frogsfrogsfrogs>
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

When we're tearing down the progress bar file stream, check that it's
not an alias of stdout before closing it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/xfs_scrub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 23b2e03865b..70c2d163f72 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -878,7 +878,7 @@ main(
 	if (ctx.runtime_errors)
 		ret |= SCRUB_RET_OPERROR;
 	phase_end(&all_pi, 0);
-	if (progress_fp)
+	if (progress_fp && fileno(progress_fp) != 1)
 		fclose(progress_fp);
 	unicrash_unload();
 

