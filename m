Received: from proxima.stupidest.org (proxima.stupidest.org [35.163.12.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45DCC3C9EE4
	for <linux-xfs@vger.kernel.org>; Sun, 30 Aug 2026 17:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.163.12.83
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788112177; cv=none; b=e7TySOcQ/fTnr7KTLIaujSBhEFeWdkf7z6h4nMzmq3JRorDNHh08W0tPLNeGOtStjBzflU6wA6MZRZMiG0X/NEmwVOL9trXd9RU5Fn54Q1aoDnR7kont6gUlWHy3wSyfqIUd6Lw0NVDq0zciW3tZ3QcDQ893uq6fNxNtcSXjz90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788112177; c=relaxed/simple;
	bh=EXsGqXduNgbvLe3Cbok7DyUDPCAxv9WOOkxyQnLlXWo=;
	h=To:Message-ID:In-Reply-To:References:From:Date:Subject; b=XcumYHZZE3SGFn5sA41Jps4vu8pSXySN069g+4st6AukdNqthQqJyG/vyFgPOXbqfkpg2NH42L7tdhnmAKYbL/049881KXfqeyztffAHb7ayPi9t5fYcDqDtKZW00kmi4/Fnj2jlVrL0kEq7bbcweN9vqvWPiYHrP2/I4y3SnUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=f00f.org; spf=pass smtp.mailfrom=f00f.org; dkim=pass (2048-bit key) header.d=f00f.org header.i=@f00f.org header.b=gGxRz/jd; arc=none smtp.client-ip=35.163.12.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=f00f.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=f00f.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=f00f.org header.i=@f00f.org header.b="gGxRz/jd"
Received: from aether.stupidest.org (unknown [10.0.1.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by proxima.stupidest.org (Postfix) with ESMTPS id 4hY04T4vTVz6m0
	for <linux-xfs@vger.kernel.org>; Sun, 30 Aug 2026 17:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=f00f.org; s=m2016a;
	t=1788112169; bh=xH3wKyBXnbkERTEUV5zbrg7nvjyhpvzhLljntlJssdw=;
	h=To:Message-ID:In-Reply-To:References:From:Date:Subject;
	b=gGxRz/jde7zB5FS7sGwWUn6/GoUI5f+AIXX4GNTZTXTv53rLl+sN67Ppqqp5Tkdd4
	 I4XQeox1N4xAZTZngKIsnxF2xnw7WfqNU1NIKIPwjriSn2/LEq6KD+k/+pMaRIAl7j
	 SRz2YTGh2NXlecAZRa/tGvUSR281fowXNlVavE9BS45kd/oaMawhBH1DHHeVb3RNxK
	 vPeRfH+AfepiOTxVZAB8vgLEj9S4PxsThuco/LGlSbzOBK8ujfQahLBapECUNbp7vq
	 FCE0+38kgfJRsoPIIyaHoVIrm42v4QBy0ILsRsJZ71Gk6qrrygJCixL233T5Tlzosm
	 ukNO4OB4kfXdw==
Received: from stupidest.org (unknown [172.31.255.110])
	by aether.stupidest.org (Postfix) with SMTP id 4hY04S14BCz9KQbD
	for <linux-xfs@vger.kernel.org>; Sun, 30 Aug 2026 10:49:28 -0700 (PDT)
Received: by stupidest.org (sSMTP sendmail emulation); Sun, 30 Aug 2026 10:49:28 -0700
To: linux-xfs@vger.kernel.org
Message-ID: <2515991ccb3bc1707f3e06137d5ec87298098ce3.1788110147.git.cw@f00f.org>
In-Reply-To: <cover.1788110147.git.cw@f00f.org>
References: <cover.1788110147.git.cw@f00f.org>
From: Chris Wedgwood <cw@f00f.org>
Date: Wed, 26 Aug 2026 22:08:46 -0700
Subject: [PATCH 4/9] libxlog: rename xfs_log_recover.c to logscan.c
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

This file is xfs_logprint's log scanner and the code repair uses to find
and zero a log: xlog_get_bp(), xlog_bread(), xlog_find_tail() and
friends.  It is userspace code with no kernel counterpart, and it does
not perform recovery.

The kernel has its own fs/xfs/xfs_log_recover.c which does, and which a
later patch brings into this directory.  Give the userspace scanner a
name that says what it is, so the kernel file can keep the name it has
upstream.

Pure rename; no code change.
---
 libxlog/Makefile                         | 2 +-
 libxlog/{xfs_log_recover.c => logscan.c} | 0
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename libxlog/{xfs_log_recover.c => logscan.c} (100%)

diff --git a/libxlog/Makefile b/libxlog/Makefile
index b0f5ef15..49a67165 100644
--- a/libxlog/Makefile
+++ b/libxlog/Makefile
@@ -12,7 +12,7 @@ LT_AGE = 0
 # we need a static build even if --disable-static is specified
 LTLDFLAGS += -static
 
-CFILES = xfs_log_recover.c util.c
+CFILES = logscan.c util.c
 
 # don't want to link xfs_repair with a debug libxlog.
 DEBUG = -DNDEBUG
diff --git a/libxlog/xfs_log_recover.c b/libxlog/logscan.c
similarity index 100%
rename from libxlog/xfs_log_recover.c
rename to libxlog/logscan.c
-- 
2.47.3

