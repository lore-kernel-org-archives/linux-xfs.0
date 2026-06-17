Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9A73CB911;
	Wed, 17 Jun 2026 11:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781695259; cv=none; b=JYn4PeSKcWtuTFSi+AO8QQdp9YFcAGhELFW1vFU6dEZnewNLxs6/X5AGVMAUmcLjcXaCYVgfF0MO/zbazFyxM7ZJdrAQ6LDeec++L4e4f1HOeP1PDyjGOc5QV0gIQOxtT0LupWesV3wU7SGTjlhwnkR+PyMIaDz172WAiezbIdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781695259; c=relaxed/simple;
	bh=VJurfG4toGajb4n5Qqe6G4JDDM745tu9pj9m7voQBpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pt/KJXaa6q5/X7rlpujtA3zOanOz/v8Cl974DEv8zl96tQmC3xLiSsd2sE901VopmtPzDdDL8D96jN4hcuOQARKwuDr6BrqG8Iw59+DB6NhhY62FaD6f7nzRkI60gGP9mwNcPRMVlXWtV4heFrr0DFeyioPFiJsPLoZi/NwfevY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lv26D56m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lv26D56m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90BE01F000E9;
	Wed, 17 Jun 2026 11:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781695256;
	bh=H/ifHRev1KZt7zJcATaDa76vriuxBeCWHVdvTL8hqTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lv26D56moyfzDjRSXP1h969cV8AgvYZ9N6st5AgvVoCbI7grJ+nuu2E96cZpLkujJ
	 fCfjAoeLGwcg2Up76V7nMIxDz8uXtv1f+uvfbgEFI4NiZBJRpKSCXB+691y1wO+/he
	 IlpoZKSO7qQSouDyMJev/ycppfktDcR34RxiPRQ/sahCYrYZIs2gYs6aao44sMmeFR
	 D3MaO1JSIGWwZ2/0wiSf0M2PUx7tpXGw2a7r7bGmA+bxRiexde2llQri+ukVrmGiks
	 /CMxwH+duzWuwQ4e2YqAJh32OFRp1KYM3egdns98DgBG84DsIChKcmPKSGsyTJgIaZ
	 6pYRzqZ7vt8mg==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	zlang@redhat.com,
	hch@infradead.org,
	djwong@kernel.org
Subject: [PATCH v7 03/11] fstests: add FSNOTIFYWAIT_PROG
Date: Wed, 17 Jun 2026 19:20:30 +0800
Message-ID: <4cfac83869d90a41ab6a1c01ad2b13ad95430f4c.1781694879.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1781694879.git.asj@kernel.org>
References: <cover.1781694879.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Define `FSNOTIFYWAIT_PROG` for an upcoming test case that uses `fsnotifywait`.

Signed-off-by: Anand Jain <asj@kernel.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/common/config b/common/config
index d5299d5b926f..5661fa0ec310 100644
--- a/common/config
+++ b/common/config
@@ -242,6 +242,7 @@ export BTRFS_MAP_LOGICAL_PROG=$(type -P btrfs-map-logical)
 export PARTED_PROG="$(type -P parted)"
 export XFS_PROPERTY_PROG="$(type -P xfs_property)"
 export FSCRYPTCTL_PROG="$(type -P fscryptctl)"
+export FSNOTIFYWAIT_PROG="$(type -P fsnotifywait)"
 
 # udev wait functions.
 #
-- 
2.43.0

