Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3904BC13D
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610000; cv=none; b=OOershFhB7V/8Ip/Ve3fRgbsWGeKnTQ0hvT+ARRigCyVcb1loE4Hdzi08LP8xmMFlVWwIGMNXdBNz3Rm/L0vlpZAjwlmvHLmOe2w/7hHULj/3dkRcEo0tvQeoPGejVg7yNOH59pRqeZ/vP+X8GXxCACe0K56edO/PpFLF41EPfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610000; c=relaxed/simple;
	bh=thX8YgN5+n/npXLmJjLOSNMSXl+a8JYeHgH6ojdL4JE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DXF6SLHEoEZxF39y3tOPGg8g1itacFixWS9jG3S/aCyOyB2+me2ZATCNnR39Br3TZpWoUADZtdyggWFd/8pEKm8J5ttaswbkNkl3PlAQdfNiBGW9GgHOYe3cj+141r8xb4DizvRG9YOBPnKwbFCqRNpe5UOqgZZDadzbPnbfZ7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ItOgfgtb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ItOgfgtb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADBE1C4CEC5;
	Fri, 11 Oct 2024 01:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609999;
	bh=thX8YgN5+n/npXLmJjLOSNMSXl+a8JYeHgH6ojdL4JE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ItOgfgtb4DWEX0ozb5KanBIwn/yW5vFLik4UYrn2z3S9ElAPpFWqYt09nqo5aHiWu
	 6bmZTPDLdr5v+/UEOQqdJEJ+/cGVXU+iBac33oiICWoUnh7oKmfnJFlvwFtD7C4hAn
	 EIYML/Y8kIVnoKBd14MtIf17Z7qCuIrTAcqQQX7d//+B5FaucbwG68nmSeI39a6PEb
	 qP5zJ85uu74j3k6Yga5C3vufToj8GZcWOwDv7DtB4No4CKJSRjaFR2aF7oO+KQEp8i
	 EQCZtyRll3tSnhhSDZAcYEI2EDW5hgAEKYzSYNxoHS+ibTu7UDk9b54R+Bq77zQCXW
	 j8XOPR6fYXVQw==
Date: Thu, 10 Oct 2024 18:26:39 -0700
Subject: [PATCH 08/43] xfs_repair: adjust rtbitmap/rtsummary word updates to
 handle big endian values
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860655488.4184637.6959568108673377453.stgit@frogsfrogsfrogs>
In-Reply-To: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
References: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
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

With rtgroups, the rt bitmap and summary file words are defined to be
be32 values.  Adjust repair to handle the endianness correctly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/rt.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)


diff --git a/repair/rt.c b/repair/rt.c
index 711891a724b076..65d6a713f379d2 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -24,7 +24,10 @@ set_rtword(
 	union xfs_rtword_raw	*word,
 	xfs_rtword_t		value)
 {
-	word->old = value;
+	if (xfs_has_rtgroups(mp))
+		word->rtg = cpu_to_be32(value);
+	else
+		word->old = value;
 }
 
 static inline void
@@ -35,7 +38,10 @@ inc_sumcount(
 {
 	union xfs_suminfo_raw	*p = info + index;
 
-	p->old++;
+	if (xfs_has_rtgroups(mp))
+		be32_add_cpu(&p->rtg, 1);
+	else
+		p->old++;
 }
 
 /*

