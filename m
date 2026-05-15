Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9140A3C3422
	for <linux-xfs@vger.kernel.org>; Fri, 15 May 2026 10:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778840642; cv=none; b=irYEKbq1vA00N4SApNXS1B/hJbfte4eZO2Y0lsp+vgEd8+HfharW5tV2ilm/2DdtKAaPvxqdGWLQ588OFBaiXrXz8+ZjjY3CVZ/uD5tCY1PlQXmSjCjcxfEkOiKUL/P2Jd0tDGhgn2lsZEBG7+tR1gcNBv6RX+1jnULFK/CRVsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778840642; c=relaxed/simple;
	bh=QKNm12va21foHgm8AofUmuvpmHCVfLb5owRa/+cuBYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HUj96VM5X9IKjR5teVE4J3509yG66ieKJ+WOgEl05o3bRtuloB72Hha3fvkI7D42LtGsbDuj3tp4bSVfKa9wttbL8z/JYkwvvrtEO9hv4W71pqtfEhIrvKLy97mDwehE+wFPALuuezfAC78AN8BSrl2fvZV7cDKpzxgoQCpcFIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mLTPMju5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mLTPMju5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B304C2BCB7;
	Fri, 15 May 2026 10:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778840642;
	bh=QKNm12va21foHgm8AofUmuvpmHCVfLb5owRa/+cuBYQ=;
	h=From:To:Cc:Subject:Date:From;
	b=mLTPMju5aJosYTcWBeAzCr6elZ7E+mlEcZnL+Pt5amy9FjIYBhoKVWLkNMmkdgkkc
	 dq2Lkna2cOgeu+ukMVCbq6rzmFffyNGngb3HOsYVy7Zecqjy4fLsMaEK6GpXnTHO25
	 7Xi8aT+B/he6YOKBP0BUZ519Spvso/o9VSYrb2aGkno59L9LVZs2gGE5nt7E9F7AlE
	 ElD6XOLyqSblGzQvkJqJU2Gtjdw9KDtRDDXAd/ZltMpVAyTUYUwJYAAjXNMuMPE6H+
	 Sho3i2s1yZc8Dqqc0nnD3GODHeZCXZUlXIr6pf21GDuofhdxls0pNe5ygovqu1182b
	 /5nYr06jYsOIw==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: djwong@kernel.org,
	ailiop@suse.com,
	linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH] libfrog: add missing HAVE_LISTMOUNT flag
Date: Fri, 15 May 2026 12:23:56 +0200
Message-ID: <20260515102357.90358-1-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

New stubs are wrapped with HAVE_LISTMOUNT, but this flag is not
added if HAVE_LISTMOUNT is set.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 libfrog/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libfrog/Makefile b/libfrog/Makefile
index 22668212f22b..6ada83407e48 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -97,6 +97,7 @@ CFLAGS += -DHAVE_CLOSE_RANGE
 endif
 
 ifeq ($(HAVE_LISTMOUNT),yes)
+CFLAGS += -DHAVE_LISTMOUNT
 CFILES += statmount.c
 HFILES += statmount.h
 endif
-- 
2.51.2

