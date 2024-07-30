Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57BA10E3
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722301563; cv=none; b=ilDPy3yBUcJ8a9vLVL8Hu3JVpk6R14Y0PhVKYZ5ZEvZ7LUeN/+ViZbJZZCbhRyGZTiWqI+MiI9Jg2CMN1M/mLPlJZ+5EV91RDV2Z1NZVxH8BfzUemI1lTWaC50zXQPIJo/kQwOjEkw/hHwyE6HWEe4UljEm1kpQZ6CbFHajqtLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722301563; c=relaxed/simple;
	bh=R4CY6a2ZyyDFRcuYkRRgw7GLMPxTN2gVjmTEgt5FKvM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=erJvviZDfm1UxjTCK1za/7DZKnh0S1lh3bHuiUuj3r+cIc0NdMJnr482f4dkRQRsyJ+QflFMqmwOcy+mw4Z9q7o6pXgfo1YSsMaXIy2REZ9JWUGBNmoEcLWNjo91Y7+UOb9FkBBdHP6BbJzgeK2Nvbvsyzt2f4HkNtBbCkKnY5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c3FUK9bz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c3FUK9bz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD3F5C32786;
	Tue, 30 Jul 2024 01:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722301563;
	bh=R4CY6a2ZyyDFRcuYkRRgw7GLMPxTN2gVjmTEgt5FKvM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=c3FUK9bzTPRURuVSk6fn60MjjkYnGNXSIW8DAUgbmji909y3ntYASyYVEbRSXF/4C
	 sJTVnynbW+lCALh0k55DxQuIZyKbFyhWs37s42cu60JAkHkPgLeY9dmUNl1klyrGN4
	 l9MGCNzi4pmpzewAihr7g2u5z7ghDjaVn0Hh8LetK//1LDzBA2M1I/pqx+fZRSa0H2
	 FsDMJdxR++ni3PCBFTj89KPQdJb4ZNcrIZ5sbXLSAs7qEjDiI/KcUjLNia33mQ032U
	 No6pd9zABjVLvAOtMnmXVonR6tgfa2rm8MqO4iZb3g6LZFwb7FyhNCVqoH3B/9fKmR
	 5uuuRlC1P/tCw==
Date: Mon, 29 Jul 2024 18:06:03 -0700
Subject: [PATCH 01/13] xfs_scrub: use proper UChar string iterators
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229847546.1348850.8998764683709347135.stgit@frogsfrogsfrogs>
In-Reply-To: <172229847517.1348850.11238185324580578408.stgit@frogsfrogsfrogs>
References: <172229847517.1348850.11238185324580578408.stgit@frogsfrogsfrogs>
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

For code that wants to examine a UChar string, use libicu's string
iterators to walk UChar strings, instead of the open-coded U16_NEXT*
macros that perform no typechecking.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/unicrash.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)


diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index dd3016435..02a1b94ef 100644
--- a/scrub/unicrash.c
+++ b/scrub/unicrash.c
@@ -330,13 +330,12 @@ name_entry_examine(
 	struct name_entry	*entry,
 	unsigned int		*badflags)
 {
+	UCharIterator		uiter;
 	UChar32			uchr;
-	int32_t			i;
 	uint8_t			mask = 0;
 
-	for (i = 0; i < entry->normstrlen;) {
-		U16_NEXT_UNSAFE(entry->normstr, i, uchr);
-
+	uiter_setString(&uiter, entry->normstr, entry->normstrlen);
+	while ((uchr = uiter_next32(&uiter)) != U_SENTINEL) {
 		/* zero width character sequences */
 		switch (uchr) {
 		case 0x200B:	/* zero width space */

