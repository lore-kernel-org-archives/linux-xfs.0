Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431F5260578
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 05:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752556755; cv=none; b=XWe4rwHdIj40ceodGI2jZtNxF87/QG3AnohqR1nrdy48Vnr04z6xPkA1lSNFw+FRlO+kwGbon4f7U70FY0nbWeorQpeEVqLPkJVaEYM8uA7wt2F6MZAxEVTleI768ex0A8x2jm0HtwMVKFwGfVNHB38BwLGYYNFdp2rysP670g4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752556755; c=relaxed/simple;
	bh=p6bqhYTVwXP08+tlqPbuP50pIcrGpiQEP8E5nOvBl34=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YoV3TKwEOvBikUtlwL/PmTpXcahmQWdXZYTDNiTqL5cdae8/pubhVgEWfRSrlPeLxXiRZ8E28aGUJIiLaXPIG50R8ITgM7M2M6dVCq2JaVoayZbyW5tS89nRbYMU5LoPsR230mNKzLg5zPd+vVwf9eo1ng+aBMkT4r3RYbeviYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y106uaBc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y106uaBc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0BFDC4CEE3;
	Tue, 15 Jul 2025 05:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752556754;
	bh=p6bqhYTVwXP08+tlqPbuP50pIcrGpiQEP8E5nOvBl34=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Y106uaBcz3RC5NsupTcrJ7yaiq/0nm8sRuNCLm480Sdo1UipZCUWyEfPI/R8k4pHE
	 DiAmxJojIEq53x2jFzLKLWH+qeegfUbAd94ZAxRSj3OgGjkYOvZyylkkr4Ux24pI9V
	 UzLxg/1cnksnhTH3NYAqNZ4vQ6cUUXFSHq0mhcEXqpkgPLNuEALgaaKnaCGRuxgAGH
	 pkbQA9HfC6/4MEvsNHsYPS3QDlGOEgojtF3P+ANrl//71NnnCgXluNspARO+NwwR3v
	 bOIp4dAwge/bMdMJzWJ8/pTA88SWchMEBAiOhXu/fAlhloF0xhkrp+bYJmPL/HtiSb
	 QV1lXLdxcrSUw==
Date: Mon, 14 Jul 2025 22:19:14 -0700
Subject: [PATCH 5/7] mkfs: autodetect log stripe unit for external log devices
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: john.g.garry@oracle.com, catherine.hoang@oracle.com,
 john.g.garry@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <175255652546.1831001.9226314939908329303.stgit@frogsfrogsfrogs>
In-Reply-To: <175255652424.1831001.9800800142745344742.stgit@frogsfrogsfrogs>
References: <175255652424.1831001.9800800142745344742.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

If we're using an external log device and the caller doesn't give us a
lsunit, use the block device geometry (if present) to set it.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: John Garry <john.g.garry@oracle.com>
---
 mkfs/xfs_mkfs.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 8b946f3ef817da..b6de13cebc93ed 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3615,7 +3615,8 @@ _("log stripe unit (%d) must be a multiple of the block size (%d)\n"),
 	}
 
 	/*
-	 * check that log sunit is modulo fsblksize or default it to dsunit.
+	 * check that log sunit is modulo fsblksize; default it to dsunit for
+	 * an internal log; or the log device stripe unit if it's external.
 	 */
 	if (lsunit) {
 		/* convert from 512 byte blocks to fs blocks */
@@ -3624,6 +3625,10 @@ _("log stripe unit (%d) must be a multiple of the block size (%d)\n"),
 		   cfg->loginternal && cfg->dsunit) {
 		/* lsunit and dsunit now in fs blocks */
 		cfg->lsunit = cfg->dsunit;
+	} else if (cfg->sb_feat.log_version == 2 &&
+		   !cfg->loginternal) {
+		/* use the external log device properties */
+		cfg->lsunit = DTOBT(ft->log.sunit, cfg->blocklog);
 	}
 
 	if (cfg->sb_feat.log_version == 2 &&

