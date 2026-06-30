Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DDC186334
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 01:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782781392; cv=none; b=jR4ufL0q07n7lCTshGPR2/X+yUX2AP/jCl56eY+3m/wWotTuGDGi4GMG1tYUmRi0JFmxmUL0lDym7jPL0XF4yuL8g30eRPBtAOeg8yHu4nVzGDejc5sW5+zuPu6H5+K8rLZDPb3njEXNp5vJXooMrS/hozYCIzlUt0zrTW/kcD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782781392; c=relaxed/simple;
	bh=DsE3xr6BqX2XSR4ZpBkUXA6QmZi5XJJ+uofpDo/FgiA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PvR1yehkopCD9W+FSzR17KknrOaN8UAQVC1gZ21lmRZLY0jw9XsZQcz4xVsDJ69UOs0+pqwo6ygP1fO6qHRPh02JqM7rhGdQALmRp0avQs/wKwRWFo+vEd/Bf73YmC+OMCIquoKXNRZIvnPEq7qqQx3r+E1UtTfgWd1UpDsFGxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kb7QPv+v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kb7QPv+v"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 11AB21F000E9;
	Tue, 30 Jun 2026 01:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782781391;
	bh=Lzf4Dc54BkAZycJvLR+QUTuOL5uF1TbwQK9U+025ZiY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=kb7QPv+vg9meYZArN1x8V7NHeV1ba4EZWyzHLB782+Mq2cJ4IbWKSxt3c/dit91Xo
	 87grNB3jBjtYiD6LuReukNQPlZJ9CfXVhWHCMlLQJuL27Ym98kwAxERfUU4vNyJ42C
	 VVdpqaic9rM3pMVat32p8d2Lc2thCOvgiQ5sLnGVU/z7fQf3/aaU+SmXXGOWCTM9pg
	 81hYagRgoFg4FNGabLdi+4L9gJlgZ2E6Rydtu0S/pNlyqVv95YhkBdn2NpulrnYPdP
	 qpMw7q7HWLIUfOrnrzgG/JsocKHdijTdac+xynzjkOhNB2l6xXp39R7FYdb/hUT3Ll
	 XZZgLtJEXXKAQ==
Date: Mon, 29 Jun 2026 18:03:10 -0700
Subject: [PATCH 2/6] mkfs: fix PATH_MAX check
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178278129843.858323.3368571818285079629.stgit@frogsfrogsfrogs>
In-Reply-To: <178278129779.858323.3184159030321473775.stgit@frogsfrogsfrogs>
References: <178278129779.858323.3184159030321473775.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Per the snprintf manpage, the correct means to check snprintf for an
insufficiently large buffer is to check if its return value is >= @size,
not > @size.  Codex found this.

Cc: <linux-xfs@vger.kernel.org> # v6.17.0
Fixes: 8a4ea72724930c ("proto: add ability to populate a filesystem from a directory")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 mkfs/proto.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/mkfs/proto.c b/mkfs/proto.c
index a460aebd95ae1e..e167cba1d8d3ec 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -1674,7 +1674,7 @@ handle_direntry(
 	/* Ensure we're within the limits of PATH_MAX. */
 	size_t avail = PATH_MAX - path_len;
 	size_t wrote = snprintf(path_buf + path_len, avail, "/%s", entry->d_name);
-	if (wrote > avail)
+	if (wrote >= avail)
 		fail(path_buf, ENAMETOOLONG);
 
 	/*

