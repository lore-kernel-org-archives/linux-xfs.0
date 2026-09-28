Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647613A5435;
	Mon, 28 Sep 2026 06:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790576276; cv=none; b=cxITXQicgu5atONKqe5dhk/FmrRmpF4LN+BR/pddVtDHCXpOq1r3MhoonPqhkp4Pudz829Y53g8Sok8T2Du5SM33UShOJ7QiwGV2Bmar73aNa10AMZbxm6U/ToF9bR8bg4FgqMvxlORTX82aCl0m6v6j4q6yd15gSJkko3s7nGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790576276; c=relaxed/simple;
	bh=tHgbq9vkMFzyV7+ijn8Lzn6XeAmcLeAGtcpbomZ6HyU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fXYYb73O8oSc5jU1Ri65scCxxr0C41BtHuvWPbl/zpbiw8n3wLSwVmD749UXToFlFReptxkmpQlTJ9+un5yg28WG+oPAvxFFw4i0H47fe0kPcfpzMJ3ijAM+Z2sMTrnwoHHau5rZjOoJahR1p4M9uD8Gta5C2DZ5OHwryntISnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hSw2NgnU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hSw2NgnU"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id EBDAF1F000FF;
	Mon, 28 Sep 2026 06:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790576275;
	bh=rq6BP9XBEWW+Um1RkppYNupHV8Hj1Ij33UOWHpQ7Hrc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=hSw2NgnUEgPRHWTGaSldDOfz5aejhK40ChU9u+j0wVfhR0eCZBn6yRx2jEmYSEOua
	 /9HbdMr0C5Ue8Fvc9zFYt8v7SJ6VikVWxldJY8PjmciwfOWIJHwoA/whHdK5S5wXO9
	 qTjKHg9xqgWkzzKwxPTfIwi12QJBT+2NfsZ7reM98Ufi1K5L9uv4BrNwV+40w1bJJ1
	 dKC/CZHxbPPStOLzeuMM3NXqwdEub40BPSdDOUEE8g11XSREuP7SgrF38af5QHO4yc
	 7KXjd9UcbR2JUKKa336pLXztNvzq3kX6TvKLN8E4vm6E3dMtLS8lAV/tb7QZLLaeCZ
	 SOqys/kZV+USw==
Date: Sun, 27 Sep 2026 23:17:54 -0700
Subject: [PATCH 08/12] xfs: assign an owner to scrub_stats_fops
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179057612767.479634.10381622374817940867.stgit@frogsfrogsfrogs>
In-Reply-To: <179057612523.479634.11102922479483109602.stgit@frogsfrogsfrogs>
References: <179057612523.479634.11102922479483109602.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM complains that file_operations structs for debugfs files are
supposed to have an owner set so that the module can't get unloaded if
someone's sitting on a debugfs file long after unmount/rmmod.  Fix that.

Cc: <stable@vger.kernel.org> # v6.6
Fixes: d7a74cad8f4513 ("xfs: track usage statistics of online fsck")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/stats.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/fs/xfs/scrub/stats.c b/fs/xfs/scrub/stats.c
index da2a40a91156f4..6934d76cfd156b 100644
--- a/fs/xfs/scrub/stats.c
+++ b/fs/xfs/scrub/stats.c
@@ -301,6 +301,7 @@ xchk_scrub_stats_read(
 }
 
 static const struct file_operations scrub_stats_fops = {
+	.owner			= THIS_MODULE,
 	.open			= simple_open,
 	.read			= xchk_scrub_stats_read,
 };
@@ -328,6 +329,7 @@ xchk_clear_scrub_stats_write(
 }
 
 static const struct file_operations clear_scrub_stats_fops = {
+	.owner			= THIS_MODULE,
 	.open			= simple_open,
 	.write			= xchk_clear_scrub_stats_write,
 };

