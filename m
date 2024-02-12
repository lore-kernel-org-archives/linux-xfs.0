Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22164EB28
	for <linux-xfs@vger.kernel.org>; Mon, 12 Feb 2024 23:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707779305; cv=none; b=S7NTcvEP1Q/cI6RmAOyUQaaT9Sc7viP0HJxbBRDWu4vG6wjrE8g3VD10HofavsGluQV+bAjBjGzcNf8rwFRg2E3agyd3yS9BhGwJwl0yPycEFovhKxcmSORky25830zHepvtgj5UFkNTvXt3y9fZDNsKNcClrZb49cjli+gYFJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707779305; c=relaxed/simple;
	bh=/tqP4XDomUc7zMBgwBAF/Yn5eIxi31DO7AUXKmdO4QA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rNeqUisifaRYmo40kf2z+K3VuxoUiCftwHWV1ucf9SKGmugujs5nodASvUyd/CYKRztn8MEt8KXHvT/2sc1UBondQVZaubXdVG2fCUusk69Rw5VKLlVs2C+pbiRB5RY2NfE8R+WxAR8KmipeNd02TU7F3oA1W1UJAzK/PA70h+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=IFfLmAX9; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="IFfLmAX9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Content-Transfer-Encoding:MIME-Version
	:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=0KwfwssfOo86EHwwfQ+tRVg8kow0TnkfExCbFr5fgOk=; b=IFfLmAX95igYxBXgUywFUyK/u4
	Rx8ecZ/OreUH5JujW+kfhIGzxx2tkdqDuzH7kNMk7RlIdoZBwrtZYGHgQsvHo59egYQpz0Y/sV8w3
	qStZswJLLNL59tY22vrNcbq8ZdIp6volZd9Z+qKqpHRVhltHtyAMR40yXVbCOgxRHHP1ud4Zx/FkB
	lLTF77n7w1ybaQRGOISZsW+x7UnWsa3uSvyU1CCXaAPGcKXhFPiVqzUWuFVw4OfXe//nbY2+KoglG
	Wi6Bc/f76tZY75voQXo01rrPL0RHC4YqH6bPoFL+73/MPIQTb0LkjKFdFU9QJmg/SZoN46rJQOyMK
	mvDihQvg==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <bage@debian.org>)
	id 1rZfPM-0020sx-Up; Mon, 12 Feb 2024 23:08:16 +0000
From: Bastian Germann <bage@debian.org>
To: linux-xfs@vger.kernel.org
Cc: Bastian Germann <bage@debian.org>,
	Emanuele Rocca <ema@debian.org>
Subject: [PATCH] debian: Increase build verbosity, add terse support
Date: Tue, 13 Feb 2024 00:07:55 +0100
Message-ID: <20240212230813.10122-1-bage@debian.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <Zco4xFPmGJQshw7n@ariel>
References: <Zco4xFPmGJQshw7n@ariel>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Debian-User: bage

Section 4.9 of the Debian Policy reads:

"The package build should be as verbose as reasonably possible,
except where the terse tag is included in DEB_BUILD_OPTIONS".

Implement such behavior for xfsprogs by passing V=1 to make by default.

Link: https://www.debian.org/doc/debian-policy/ch-source.html#main-building-script-debian-rules
Link: https://bugs.debian.org/1063774
Reported-by: Emanuele Rocca <ema@debian.org>
Signed-off-by: Bastian Germann <bage@debian.org>
---
 debian/rules | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/debian/rules b/debian/rules
index 57baad62..7e4b83e2 100755
--- a/debian/rules
+++ b/debian/rules
@@ -7,6 +7,10 @@ ifneq (,$(filter parallel=%,$(DEB_BUILD_OPTIONS)))
     PMAKEFLAGS += -j$(NUMJOBS)
 endif
 
+ifeq (,$(filter terse,$(DEB_BUILD_OPTIONS)))
+    PMAKEFLAGS += V=1
+endif
+
 package = xfsprogs
 develop = xfslibs-dev
 bootpkg = xfsprogs-udeb
-- 
2.43.0

