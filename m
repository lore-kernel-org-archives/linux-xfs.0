Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B7E23ABA1
	for <linux-xfs@vger.kernel.org>; Fri, 19 Dec 2025 09:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766135823; cv=none; b=t91Tav1aZxj4Ax6pNfjWjQhwYa4q8TFztUc4Euko4trDIPVRbFQ62qmPnCfG6s8EnBe0d6+Qe9RHNHOzj9H/S2QFYAJQlOPNYX+XPmKwodeAVrEvYSTshnmnBfcyTRfublN5mMHPw7/jk7xzr9s8w5kmbXefWPa2yHnJ2NBnOE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766135823; c=relaxed/simple;
	bh=91SIQIPdHhmqbQak2n20UiSXXVlkl8Q6FSIHssnLkqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YmG1lN2ExrrTiEd3u1JtFLFxgK22zrmGi9+Dvlyfstg4dAKtIVHmXWPb+CWUvsCiQXe2rOzHYYkib+s1WjXBBaTmz0T2V36MTMtCYKY5fERqHWK0oLL5FxSCTa1UqvfNEzxLJwPog8ITG7U5f9h/ACoqfjQpGIciXeQYQttNNjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bVM5VZN+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bVM5VZN+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EBC5C16AAE;
	Fri, 19 Dec 2025 09:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766135822;
	bh=91SIQIPdHhmqbQak2n20UiSXXVlkl8Q6FSIHssnLkqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bVM5VZN+Km1V+muVJs7QslKbEuiro8cRtq0sYqJeCxfCSj63OzfK/X+jC0RDsk5JM
	 TZK1GJJrLuAfgVXZBTl9zIkrtWDssitppEZ7WCZvAU2xDnYoGkFQmc8rH63cmI9ukJ
	 BaxQ/tc88gQodcA7E2tNzVn/tHpvymSY/CUsBdR7Tne+DsRd39Vu8j8qWa7qWDaF5P
	 I7seqprsdUtr+xdMtLKCPCcZOqoQK7l8r7dI5sU1GoOCYwcwQQa7PYbX3Vxs+IJih1
	 myGngfVxyun45/ufht0f6LfCQXbaPVJogu/dPV7cjMTKcwMYUiVPHNEdersBBkPhJJ
	 evYRZQNKWKq1w==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-xfs@vger.kernel.org,
	Andrey Albershteyn <aalbersh@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 2/3] mkfs: use cached report zone
Date: Fri, 19 Dec 2025 18:12:31 +0900
Message-ID: <20251219091232.529097-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251219091232.529097-1-dlemoal@kernel.org>
References: <20251219091232.529097-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use BLKREPORTZONEV2 ioctl with the BLK_ZONE_REP_CACHED flag set to
speed up zone reports. If this fails, fallback to the legacy
BLKREPORTZONE ioctl() which is slower as it uses the device to get the
zone report.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
[hch: split out BLKREPORTZONEV2 and BLK_ZONE_REP_CACHED definition into
another patch]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mkfs/xfs_mkfs.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index bc6a28b63c24..7088823b3f54 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2623,8 +2623,13 @@ _("Failed to allocate memory for zone reporting.\n"));
 		memset(rep, 0, rep_size);
 		rep->sector = sector;
 		rep->nr_zones = ZONES_PER_IOCTL;
+		rep->flags = BLK_ZONE_REP_CACHED;
 
-		ret = ioctl(fd, BLKREPORTZONE, rep);
+		ret = ioctl(fd, BLKREPORTZONEV2, rep);
+		if (ret == -ENOTTY) {
+			rep->flags = 0;
+			ret = ioctl(fd, BLKREPORTZONE, rep);
+		}
 		if (ret) {
 			fprintf(stderr,
 _("ioctl(BLKREPORTZONE) failed: %d!\n"), -errno);
-- 
2.52.0

