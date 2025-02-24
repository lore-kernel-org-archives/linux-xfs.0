Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695D116CD1D
	for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2025 19:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740424064; cv=none; b=OjFtlDrJum/GDnaoXUAIajIkzQR+mbRJ/DAjv+ynv8h4rrGOzNB6813wijH3bk1cwRzI46NqtOwHjgPvccDjUsquaulAq6doxt3dRA8uxv5YsjpVs2KcXJH0gE2T/OqqbYeXf4BEH+9lueReUlhKprFCgQZ8RQlaLUVCjVqN3ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740424064; c=relaxed/simple;
	bh=1GbE7yTHmiFpCumOEExXegjE2U4CIMZ5DqPDCfhIhcM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p4Q4iLZELU9Eljwz1qWcj4PUPH1w2rEdRhRuEcjS0TrZq8lvVKGDL2rzucqHa6W8oiDBLufSGy+Hp2YMvA47ZcN7W2c08BsXlaWWDDEreM+kXLsnq0tU1mghiTI3Vwdem78Tdkh0ttCBP66VYFvrpcR6by2nOw1+FvRj+buu+Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CDjIMpUQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CDjIMpUQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCA09C4CED6;
	Mon, 24 Feb 2025 19:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740424062;
	bh=1GbE7yTHmiFpCumOEExXegjE2U4CIMZ5DqPDCfhIhcM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CDjIMpUQ8gle/GWbM1fYYGSK2A4TxICXKMllt09uHyVFnOZmew7EHZWJbDBmGo1pz
	 Y45X8iaxxzqgn/IUkcyJxQRRzCVBhxUPR/Zb6wnaILyiY6UPN9114Zu5pbPitSAQtJ
	 2DiQSfrjLfflpDkFK7MnPHn4eauVq1EdsKd1wGjMX97GBKucrRKhwR4wAD94/rP1tO
	 BQKy1pB2Vof/yR+tOG/d2IEX1p0Qyw1tBSpre9OolRWBzowfwC5PSqOMq6H/MX8qdr
	 YEnl9uw2JHRVqxTQEE3bMD62diaP7wGOCu493Bp56Z6YMty/dvhow5pQiXBgZ7h2+H
	 iIYmPO/kKa0NA==
Date: Mon, 24 Feb 2025 11:07:42 -0800
Subject: [PATCH 2/3] xfs_scrub: don't warn about zero width joiner control
 characters
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <174042401309.1205942.12498812873396538376.stgit@frogsfrogsfrogs>
In-Reply-To: <174042401261.1205942.2400336290900827299.stgit@frogsfrogsfrogs>
References: <174042401261.1205942.2400336290900827299.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The Unicode code point for "zero width joiners" (aka 0x200D) is used to
hint to renderers that a sequence of simple code points should be
combined into a more complex rendering.  This is how compound emoji such
as "wounded heart" are composed out of "heart" and "bandaid"; and how
complex glyphs are rendered in Malayam.

Emoji in filenames are a supported usecase, so stop warning about the
mere existence of ZWJ.  We already warn about ZWJ that are used to
produce confusingly rendered names in a single namespace, so we're not
losing any robustness here.

Cc: <linux-xfs@vger.kernel.org> # v6.10.0
Fixes: d43362c78e3e37 ("xfs_scrub: store bad flags with the name entry")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/unicrash.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)


diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index 143060b569f27c..b83bef644b6dce 100644
--- a/scrub/unicrash.c
+++ b/scrub/unicrash.c
@@ -508,8 +508,14 @@ name_entry_examine(
 		if (is_nonrendering(uchr))
 			ret |= UNICRASH_INVISIBLE;
 
-		/* control characters */
-		if (u_iscntrl(uchr))
+		/*
+		 * Warn about control characters in filenames except for zero
+		 * width joiners because those are used to construct compound
+		 * emoji and glyphs in various languages.  ZWJ is already
+		 * covered by UNICRASH_INVISIBLE, so we can detect its use in
+		 * confusing names.
+		 */
+		if (uchr != 0x200D && u_iscntrl(uchr))
 			ret |= UNICRASH_CONTROL_CHAR;
 
 		switch (u_charDirection(uchr)) {

