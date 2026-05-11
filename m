Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A85636F40C;
	Mon, 11 May 2026 11:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778498381; cv=none; b=WcA7KlWR/zI2z6yV+q992ucl1WvwpvWgk7pa8edKWNBcr4aO+wB22yRhdOzJ/dIp/aMniJyAon1t9qCOGY0DqUWL3+X83oyFXhWBtVYnZ9xqr8qosFhD83LyKwi0GkqkfH+cAREBTTdvUyV+JIHWKgfgASGQWMDPnEiGu5O6Ah0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778498381; c=relaxed/simple;
	bh=qIajBd+EV8EdUBwYEvFMx/LoVcxBHusd3j5toUgFQ78=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GM3zrzjCCaq2WKh/wnzfYGO01KafKKKOR4jq0CmLre7eCKcUFkvdDFyBS3Ysuizkc0AX6Ehv3uQqTh5zG82hhkFZ6gLi55ndfsJLNMTj3CfwJ71z6th6hOMJ9uwCMUUiQUR3vWEm54w4HN6x/d0iX0N/UzubYajSe7KSjsvITCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=pankajraghav.com; arc=none smtp.client-ip=80.241.56.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Received: from smtp202.mailbox.org (smtp202.mailbox.org [10.196.197.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4gDcgg6xYXz9tTM;
	Mon, 11 May 2026 13:19:27 +0200 (CEST)
From: Pankaj Raghav <p.raghav@samsung.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org,
	Andres Freund <andres@anarazel.de>,
	Jeff Layton <jlayton@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org,
	hch@lst.de,
	linux-kernel@vger.kernel.org (open list),
	pankaj.raghav@linux.dev,
	Jan Kara <jack@suse.cz>,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [PATCH] fs: fix forced iversion increment on lazytime timestamp updates
Date: Mon, 11 May 2026 13:19:18 +0200
Message-ID: <20260511111918.1793689-1-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When updating timestamps with lazytime enabled, if only I_DIRTY_TIME is
set (pure lazytime update), inode_maybe_inc_iversion() should not be
forced to increment i_version. The force parameter should only be true
when actual data or metadata changes require an iversion bump.

The current code uses "!!dirty" which evaluates to true whenever dirty
has any bits set, including the I_DIRTY_TIME bit alone. This forces an
iversion increment on every lazytime timestamp update, which then sets
I_DIRTY_SYNC, triggering expensive log flushes on subsequent fdatasync
calls. Andres reported this issue when he noticed a perf regression[1].

Fix this by using "dirty != I_DIRTY_TIME" as the force parameter. This
passes false for pure lazytime updates (allowing the I_VERSION_QUERIED
optimization to work), while still forcing the increment when dirty
contains other flags indicating real changes that require iversion
updates.

[1] https://lore.kernel.org/linux-xfs/7ys6erh3nnyeerv2nybyfvp7dmaknuxrlxv74wx56ocdothkc6@ekfiadtkfn2r/

Fixes: 85c871a02b03 ("fs: add support for non-blocking timestamp updates")
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 fs/inode.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/inode.c b/fs/inode.c
index 6a3cbc7dcd28..62c579a0cf7d 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2124,7 +2124,13 @@ static int inode_update_cmtime(struct inode *inode, unsigned int flags)
 			    inode_iversion_need_inc(inode))
 				return -EAGAIN;
 		} else {
-			if (inode_maybe_inc_iversion(inode, !!dirty))
+			/*
+			 * Don't force iversion increment for pure lazytime
+			 * updates (I_DIRTY_TIME only), let I_VERSION_QUERIED
+			 * dictate whether the increment is needed.
+			 */
+			if (inode_maybe_inc_iversion(inode,
+						     dirty != I_DIRTY_TIME))
 				dirty |= I_DIRTY_SYNC;
 		}
 	}

base-commit: 4cd074ae20bbcc293bbbce9163abe99d68ae6ae0
-- 
2.51.2

