Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252C225A343
	for <linux-xfs@vger.kernel.org>; Wed, 12 Nov 2025 15:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762960784; cv=none; b=FKnMQhARfE/dBimCwYAEJOCMOnj2LF6FBsMMSHY9n4UulXIJ8rbkp2PAf0185daDsAHW+OwqLaDyAWrit5CzYkqc55pLWbySJa8hpir4Hd5O0pfbPFFX+UBkhxjW/Mbr0l8a27UCtJkTlZbWqmrkuKKyVeLIrSnL1z7I8hS6s48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762960784; c=relaxed/simple;
	bh=fqEy+pE/Aufn6bwm56+9xmvqrGfTA1BRdzo2pLhdxbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kZrPhnL1flHg0wgMt22XaiPGym/GlDBL0rO9l3JeZGyIZWSjO0tg3ahHQTDlpYpgAIxuh8XvRZb2Zq+ExJSp2W2fu/ZDHOOZ2Gop+ADh+zo0WDasudopWnrnGmyUknpojRTRH44kycfN9ETLcHy9wCfxpT/gqdMaE881tJQhYdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=bdClNvd2; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="bdClNvd2"
Received: from localhost.intra.ispras.ru (unknown [10.10.3.121])
	by mail.ispras.ru (Postfix) with ESMTP id 235284078526;
	Wed, 12 Nov 2025 15:19:33 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 235284078526
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1762960773;
	bh=NfCkb3RwxDj6rwiq9vrpdBQrmtd2kbdgs6YeT6ZqT0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bdClNvd2QmLPiy3+HblXJgFhXHbcRZVEnCNI6qXIvG1ZxZIMGa6WCxttrIbZTElnQ
	 AqfRHwQWM3crfEnIjfnzupA/qmA0JxMqo7lnu/Qo7upWdRSTb28vAqVZCTh8yrw8JQ
	 0vJOm04IyLgPymVb561rHCS45Ml4EcEm3aRtuylo=
From: Alexander Monakov <amonakov@ispras.ru>
To: "Darrick J . Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs_db: use push_cur_and_set_type more
Date: Wed, 12 Nov 2025 18:19:32 +0300
Message-ID: <20251112151932.12141-3-amonakov@ispras.ru>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20251112151932.12141-1-amonakov@ispras.ru>
References: <20251112151932.12141-1-amonakov@ispras.ru>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since push_cur unsets cur_typ, 'ls' and 'rdump' with paths relative to
current address do not work with a mysterious diagnostic (claiming that
the supplied name is not a directory). Use push_cur_and_set_type
instead.

Signed-off-by: Alexander Monakov <amonakov@ispras.ru>
---
 db/namei.c | 2 +-
 db/rdump.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/db/namei.c b/db/namei.c
index 1d9581c3..4149503c 100644
--- a/db/namei.c
+++ b/db/namei.c
@@ -629,7 +629,7 @@ ls_f(
 	}
 
 	for (c = optind; c < argc; c++) {
-		push_cur();
+		push_cur_and_set_type();
 
 		error = path_walk(rootino, argv[c]);
 		if (error)
diff --git a/db/rdump.c b/db/rdump.c
index 73295dbe..146f829b 100644
--- a/db/rdump.c
+++ b/db/rdump.c
@@ -980,7 +980,7 @@ rdump_f(
 			len--;
 		argv[i][len] = 0;
 
-		push_cur();
+		push_cur_and_set_type();
 		ret = rdump_path(mp, argv[i], &destdir);
 		pop_cur();
 
-- 
2.51.0

