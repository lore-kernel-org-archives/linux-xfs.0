Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD202253A1
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jun 2026 06:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780553218; cv=none; b=JZz7/NRuvzWFQpFDlf0MVV2vrBz/oaAU4G57AcpHeAI5O15mM5bDojqAcWEWdU2Ndfclh3MVHphB0pIyvtlvByrZ02rW9Nq18wwKW2c5oZ/Dej934g5P8HTQtfAdgZiduS4EbukwqIAMmyD0UmWCbimKrsTku8qGcJBPI73BlS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780553218; c=relaxed/simple;
	bh=EuQqjHdVUwamkGlDxAe6SwJgtWchqPq4IL9n3Mzxiq0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KKWxZrUqlcaC1/ezT1TKY/LZ8gdoKDExdJZi5QRqwAjTz0aUpnLa8uDErAuLG9jBOAiUqOp3MIiHbG+mwaSEqg826ooRqwEsR0ITfhk1XYv/lgLqlOnavhqsrzAFvC4vLb6RrN7+z/A7GmSFjWBFSXmYSQZlFdN+VqsWebtZ3MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T8CNcfCv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T8CNcfCv"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BD0521F00893;
	Thu,  4 Jun 2026 06:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780553216;
	bh=WN4gCr9cwNj5XsN+GOCfNr2o1yPDfPIuz2fxNn125Z8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=T8CNcfCvBnr4IWDW3wtkLq5G7spezDE31280LeHbzAxR33LS3yJ5+R9ugVn9Fo79L
	 iKhVpg7zvDGH0coJt2kiR2l7Tu53NTXvRKxWBs6bDG641XPaonmUTBs5EMT0RXEgum
	 W/BzqBtl1DzucbcS0eOZqZhArf750F98H3CefA0YFL4kQScT5y/eJnFjCUwL9pXWkA
	 FsVlctMhMieYqd+ovQSGe3wfwsRoE6b9MDkuPBqbuSr/QHqbk0xSWa64PIDOdJElFO
	 QiDpD8uHCGEE8a3/5x7fOo7FDhqgBtwhWmjm0AZ/FUiecU8J2I4y8wfk4pGkXPvI39
	 cT52fv+2Yw5iw==
Date: Wed, 03 Jun 2026 23:06:56 -0700
Subject: [PATCH 10/21] xfs_scrub: don't report media errors in specially-owned
 areas as file data
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178055303293.2608728.8048137726163765459.stgit@frogsfrogsfrogs>
In-Reply-To: <178055303007.2608728.11678159907532979668.stgit@frogsfrogsfrogs>
References: <178055303007.2608728.11678159907532979668.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

If a media error occurs for some disk space that has a "special" owner,
we mustn't try to walk parent pointers because special owners are not
files.  If it's an extent map, we shouldn't accidentally fall into
reporting that as file data loss.  This was, like the rest, found by
Codex.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/phase6.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/scrub/phase6.c b/scrub/phase6.c
index c273420d42ca14..cd9bb26bf88628 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -436,6 +436,8 @@ report_ioerr_fsmap(
 		} else {
 			str_corrupt(ctx, buf, _("media error in %s."), type);
 		}
+
+		return 0;
 	}
 
 	if (can_use_pptrs(ctx)) {
@@ -454,6 +456,8 @@ report_ioerr_fsmap(
 				attr ? _("extended attribute") :
 				       _("file data"));
 		str_corrupt(ctx, buf, _("media error in extent map"));
+
+		return 0;
 	}
 
 	/*

