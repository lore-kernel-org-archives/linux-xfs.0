Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77C02BE053
	for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2026 11:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773661562; cv=none; b=Nf514Vkpius/Bd33mfi4qw5ZRttVD6J5PPBZ5xZE5ZJfTc/4TaV0DHTCcnwHOBRTYqxdVOU4cv0pohTYHBiSmMRFO5RMc3pNIOWIgD2cHs1uSxcoNYhJYYTqDFSGk8eqKMVTXin2czcCM469cMGNd/mdMFhLh+Wtx8ilsr3O8Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773661562; c=relaxed/simple;
	bh=0pWMksXUHth/xiVz2KECSQnrXYwHGDGA3Tgbc0Hcb80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EXLVVwNbw6jhTOXgGSaIzvMNXPv5vqaNOOXqXX6taIkYVfQmfWcCRqcEmU97FptyYqhcGOTOxZoEwfc3DfrHOXfTKQJcWoDv8Evqptz5r5CwT3e2vHADxaZsOf0V4MqMHXah105doxCfG39nAv0GRw4yeXgyJmpDCFJJWBKVYL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hd0SPElP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hd0SPElP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0F02C2BCAF;
	Mon, 16 Mar 2026 11:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773661562;
	bh=0pWMksXUHth/xiVz2KECSQnrXYwHGDGA3Tgbc0Hcb80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hd0SPElP1cDut6w8d527IoTsZ87+FhiVTI+ARz7/IRACtbeCRHBNmJCl65cXKmoJy
	 2ZJoYo4Uyp/67D2SladdF35qT32p9RH+2Xx24iO7ToEiHlMRpzsoQrMLq43/y1axQg
	 irwwupf7Aa4SOFpBFYAT9to7iCMyM2xWa7pZA5V/ZqTHaY7DHN8oVrXhD/XisWKJtD
	 Lj3vKh3AAMDyLAqarnio90I42feXR9N0/YQiHMA2uW8G0aA2xkrDqReSpf9pgVD4wa
	 zk9ZgxihLbqiFwTYkWCOj+jhX32wWacpagWYRg7Zx6cQbwrMP0zWElkwPG0dmSy/s3
	 6cTxfwUrI2qGA==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Hans Holmberg <hans.holmberg@wdc.com>
Subject: [PATCH v2 1/4] xfs: avoid unnecessary open zone check in xfs_select_zone_nowait()
Date: Mon, 16 Mar 2026 20:40:17 +0900
Message-ID: <20260316114020.753228-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260316114020.753228-1-dlemoal@kernel.org>
References: <20260316114020.753228-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When xfs_select_zone_nowait() is called with pack_tight equal to true,
the function xfs_select_open_zone_mru() is called if no open zone is
returned by xfs_select_open_zone_lru(), that is, when oz is NULL. The
open zone pointer return of xfs_select_zone_nowait() is then checked,
but this check is outside of the "if (pack_tight)" that trigered the
call to xfs_select_open_zone_mru(). In other word, this check is
unnecessarily done even when pack_tight is false.

Move the check for the return value of the call to
xfs_select_open_zone_mru() inside the if that controls the call to this
function, so that we do not uselessly test again the value of oz when
pack_tight is false.

No functional changes.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 fs/xfs/xfs_zone_alloc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 7d712d5a5ce0..8435ccb018dc 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -675,10 +675,11 @@ xfs_select_zone_nowait(
 	if (oz)
 		goto out_unlock;
 
-	if (pack_tight)
+	if (pack_tight) {
 		oz = xfs_select_open_zone_mru(zi, write_hint);
-	if (oz)
-		goto out_unlock;
+		if (oz)
+			goto out_unlock;
+	}
 
 	/*
 	 * See if we can open a new zone and use that so that data for different
-- 
2.53.0

