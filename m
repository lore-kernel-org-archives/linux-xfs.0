Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781F24E0B82;
	Fri, 18 Sep 2026 11:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789730169; cv=none; b=NfRXMth19pKRHvRdsMRQjLqnGiUqj2yEynC8SLHVDJCEaw/cmGN8vY6aH1RhhVoVsKmPrDOGBBWuR2UiBzrkH80Zz4jK0JCGIU5ccsqljdWGzkYq3su5D1IqPP6obuW8g0vbMM51tcJEmEVxJklaxzCS5SIkrmxE1k/jLP5kf/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789730169; c=relaxed/simple;
	bh=iZBmDz3Sv67MAW+UD9i/oqwH8WTJDT8+YCS1y4L9QB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MAGeIsy4wqnPwrA3DnIDeGQxhuR0NfcIOPBPjBzf+XA9HB6RuIA/KpNz3SYYimXIjvyFzFPT3nV8JL64FzTHMg1NHeynGS8wuTpBlbKVeX1a9lxHZFPdscnQsZtTP2Byx5Z09TEYRBoMJwsFW5n6ErXklgpZ4Td9+bZnPt9Mh1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EXSiXWCb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EXSiXWCb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06CB71F000FF;
	Fri, 18 Sep 2026 11:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789730165;
	bh=B6LynSTm43VxBrGeNfUSbV9r/RlWcb4DP+IF4QhqBeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EXSiXWCbShihhYqQ3vawQ93po8jHB5w6aqmJrCpTz6GXEyuaBS3CRWMh4mH0REjTJ
	 5Wra4f0cBtb4sYpL4hzv068eB7vT3nzmargEtXBQ5Zff2C0xh2bgaZGU4DEe30EOiE
	 5wgfklWLG0k1cUeODkreOJ4XWERUccDr1mu248jgm63GkwktQsB+rn7MrrqayP0xvw
	 260VkiJDO8pKck0GAc3hDRYEsgT9U04PXYkDZvFWZBb4tXHvomsXl+ns709wDh/iRy
	 vdNcuVXqe4NnBmijXERo3du+KfjudvmUzZPPXMLZZXDXIYdU1mWyIWE4Vro2VxdXF7
	 AWz5OS+VKw2vQ==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: djwong@kernel.org,
	ebiggers@kernel.org,
	hch@lst.de,
	Carlos Maiolino <cem@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	david@fromorbit.com
Subject: [PATCH v16 05/21] fsverity: don't allow setting DAX file attribute on fsverity files
Date: Fri, 18 Sep 2026 13:15:17 +0200
Message-ID: <20260918111539.1003439-6-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260918111539.1003439-1-aalbersh@kernel.org>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When fsverity is enabled on the file, with FS_IOC_ENABLE_VERITY ioctl(),
it checks if file has DAX enabled and fails if that's true. However, the
opposite case is not checked.

Note, that the only other filesystem supporting DAX and fsverity is
ext4, and ext4 does check for this case.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/file_attr.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/file_attr.c b/fs/file_attr.c
index bfb00d256dd5..391edd1d0ce3 100644
--- a/fs/file_attr.c
+++ b/fs/file_attr.c
@@ -235,10 +235,15 @@ static int fileattr_set_prepare(struct inode *inode,
 	/*
 	 * It is only valid to set the DAX flag on regular files and
 	 * directories on filesystems.
+	 *
+	 * DAX and fsverity are incompatible.
 	 */
-	if ((fa->fsx_xflags & FS_XFLAG_DAX) &&
-	    !(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)))
-		return -EINVAL;
+	if (fa->fsx_xflags & FS_XFLAG_DAX) {
+		if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)))
+			return -EINVAL;
+		if (old_ma->fsx_xflags & FS_XFLAG_VERITY)
+			return -EINVAL;
+	}
 
 	/* Extent size hints of zero turn off the flags. */
 	if (fa->fsx_extsize == 0)
-- 
2.54.0

