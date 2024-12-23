Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 552B218E35D
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992125; cv=none; b=YR4Fmgj9U37rYcXeJpQCeAAPC4en0RulHD4F85ZpULsA7IN4qkvhvt3opslzpVDyKHW6ue+Lrg20CoCOS2DSmQgMsEb7+LQlyRuf/GUsYymnULgSSXA+yz35SHYVsAHsADrfRJ9zLUeX7ZufpZTogtOHl5ahtmqI728qm5swdmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992125; c=relaxed/simple;
	bh=gMPeFSFPCZ17WWx6t+YrZViWdxp318pla22Wr1hqrsg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AJBt79A1mwTFdBCwKg7moe4CEJ2OkibQgwAss248GsQ4R/azGjd8baFyiygjEUjlKyDzEMKmL7RUXntZLTHfzZDe/DGK+zb2Al/Waq7MIc5Mu0piKfHFUNw5zaREpYXNB7Q45d/BDVuwUasyFY00TMfox99zmextihl8fF9gbZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WgRXK6Rv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WgRXK6Rv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29073C4CED3;
	Mon, 23 Dec 2024 22:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992125;
	bh=gMPeFSFPCZ17WWx6t+YrZViWdxp318pla22Wr1hqrsg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WgRXK6RvycRcajzXpggMcwh1oKfzzin43fCsBQ1T99bANBLDDnYT57736sIdq/nMG
	 saHPOdk/JbmD+oKSfCrbYVNX9f4+1hjLGBcxiXgc3QXf3b24LwKEuLWFPyASE5oIX2
	 rKGodxGXD5SV1HRVhaU++B/ngYxaUikGFmVu4snB6mHHFbb47pWIGjRyJyUyxLq2WA
	 fqjqTFfIAQ4ET/T2RLSKki39GUq4QSCl38RQ2TSidGkyuY1tmIeJ9+xq9HQWXFcl24
	 JnaAdRFJbKe02vvm7U+jlFluPAyvS+v/lMCKJ0kwnhlMYzPIwFBwHWEJd7dD3rpEZs
	 83WLw6Ot2Rthg==
Date: Mon, 23 Dec 2024 14:15:24 -0800
Subject: [PATCH 14/51] xfs_repair: adjust rtbitmap/rtsummary word updates to
 handle big endian values
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498944018.2297565.13178926036856431152.stgit@frogsfrogsfrogs>
In-Reply-To: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
References: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

