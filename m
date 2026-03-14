Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF062AE8D
	for <linux-xfs@vger.kernel.org>; Sun, 15 Mar 2026 00:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773532848; cv=none; b=cMjCKUGd6JFDxu1KT8ld9qz0PIShG9hEBoQ8Qnfqr2XaqANThU/nQvRSm0NGsjDGWS7UarkFKjkyscGOByTLtDOiKC2cCD5LAUsAZnRstsywisvMyUjWVWLOPqp5DlOcKS5lj/uNB4pcWzZCyHB7tT+ZvxUo0XxQhWgbDkn6ums=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773532848; c=relaxed/simple;
	bh=E7RilIPf46rxu01UAX0WlqbLV1SnFoHBi+AJJ0NlLbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f8DuiJr3gphaOMeaVRaARnT61yKkGH3wxmI//r1XRyJNRT/Ox7uStRwzQLC/GNF50lJTzL4UIcliZjQ+EZq45xJtU3ZnUFFu/DKMRDdVNXVQ839zG8H14jjP4eRIdOGVrj/7sOnWDc59IFk3727tj+gGj1fyZ3kDnKI+o2EoKUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g+jRy8dF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g+jRy8dF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E23D0C116C6;
	Sun, 15 Mar 2026 00:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773532848;
	bh=E7RilIPf46rxu01UAX0WlqbLV1SnFoHBi+AJJ0NlLbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g+jRy8dFfLDR4k7gq+eDZ9Yi95WiV6ZS2sh7u4GFPE/hQ3BZYzlDGIq4NW9ZlIosj
	 bHwLf5BV6iwY2utd1Cx8U+a0srXqQ1N1+4VN+fouajfj6qHb0Oi0cwBkM3OEB+h1YI
	 Bzhh9QevwkNkgBHrjDtSE02Ly81WuyMJ9xYqs+5HanxWgnY7Za6RdmRrAjS+rfA132
	 2dCsmX+csHk2IZkJoyhEAjfcdtIMYxaXBA561WEgUQb81hoevJ3tFda4eeq7F3ShD1
	 Sqp8kRJj2vfpmbIUCS4Rxn1iBXkfZ7lAT6gCNcPuyBviTg43awmtrG9GhsEYBn0cO1
	 5Q7Eomp8e+WYg==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Hans Holmberg <hans.holmberg@wdc.com>
Subject: [PATCH 2/3] xfs: improve xfs_zoned_show_stats()
Date: Sun, 15 Mar 2026 08:55:07 +0900
Message-ID: <20260314235508.183984-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260314235508.183984-1-dlemoal@kernel.org>
References: <20260314235508.183984-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Improve the information displayed by /proc/self/mountstats by adding the
total number of zones (RT groups) together with the number of free
zones, and by also showing the number of open zones and the maximum
number of open zones before listing the open zones.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 fs/xfs/xfs_zone_info.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_zone_info.c b/fs/xfs/xfs_zone_info.c
index 53eabbc3334c..85613799edde 100644
--- a/fs/xfs/xfs_zone_info.c
+++ b/fs/xfs/xfs_zone_info.c
@@ -89,10 +89,12 @@ xfs_zoned_show_stats(
 		!list_empty_careful(&zi->zi_reclaim_reservations));
 	seq_printf(m, "\tRT GC required: %d\n",
 		xfs_zoned_need_gc(mp));
+	seq_printf(m, "\tfree zones: %d / %u\n",
+		   atomic_read(&zi->zi_nr_free_zones), mp->m_sb.sb_rgcount);
 
-	seq_printf(m, "\tfree zones: %d\n", atomic_read(&zi->zi_nr_free_zones));
-	seq_puts(m, "\topen zones:\n");
 	spin_lock(&zi->zi_open_zones_lock);
+	seq_printf(m, "\topen zones: %u / %u\n",
+		   zi->zi_nr_open_zones, mp->m_max_open_zones);
 	list_for_each_entry(oz, &zi->zi_open_zones, oz_entry)
 		xfs_show_open_zone(m, oz);
 	if (zi->zi_open_gc_zone) {
-- 
2.53.0

