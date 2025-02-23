Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2ADDCA64
	for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2025 14:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740320226; cv=none; b=pHOvY2pkIdlL2SdmW07X/deiA/e98Uwc6sPjW/VlJ6hZka/ywFR33nBB1j2oHbYKxrOrrZHXFBj75nkjwPe3gtdO/dqtdHogYMzgTqS29C9Ia+egvQsUWL0utvxYhz3eG12pMeGyRxXWbDi+KpDnS6e8miQqBFH4kj/iOxLkBes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740320226; c=relaxed/simple;
	bh=1XQVoPCHDhUY34NKxYcBkbXB9XH6zt2EREgrGcGWmtk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PiEKAPhk8ApvYV1vao5zz5oPy+ep/Cs5DM5J7Qmz7XB2geRmKEkRjA0ABrCLVHFBebXtBa73UvJOGEphyDCPWx1UHUK5OdabWyV2yrsuFKEIMBE6ZZC+MAFxLnI+enoNXMeaqHVBsHTb1/o1SaW++wkMDsRKI+jo4X45NZhbQZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=f0CxBK/H; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="f0CxBK/H"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Content-Transfer-Encoding:MIME-Version
	:Message-ID:Date:Subject:Cc:To:From:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=46nYVZi/+oErCX3FXgqrGJCCa+/4cB2dD26ZWQ1mK7g=; b=f0CxBK/HT4gaYH2iFFiXiW/H2a
	/cVtlw7c+Osy0MkWDiJkuJaS+Cj75sm9nSLQb5bRvwpzPkeCdU6Gis+QeCD2C0Dv0ARNpj/CB+G4h
	xu+wFbNdKKAZpUfO0I0vI2RNn6Ro+idgUVEeMLQQxPyLmZg6HfDuS1EwHd9rqHoY8LxD0e0pZrnOd
	BLexj30kFvhi58pQ9fkVfRRcO8yimZRcagvOFLb3CmhNPwrM9zropcoUT61JcxDIZJtLkR6Gk/WO0
	Zw+Rywiv+diyWNw+wTZYMglE96J+Hqvo7nHto/AKYuUt8B2Ok52bE98pwVa94vvBWRL5dXwQpZi1/
	HyVmclkw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <bage@debian.org>)
	id 1tmCn0-00H9DP-AW; Sun, 23 Feb 2025 14:17:02 +0000
From: Bastian Germann <bage@debian.org>
To: linux-xfs@vger.kernel.org
Cc: Bastian Germann <bage@debian.org>
Subject: [PATCH] mkfs: Correct filesize declaration
Date: Sun, 23 Feb 2025 15:16:54 +0100
Message-ID: <20250223141658.5257-1-bage@debian.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Debian-User: bage

The filesize() implementation was changed to return off_t.
Its declaration still has long. Fix the declaration.

Fixes: 73fb78e5ee8940 ("mkfs: support copying in large or sparse files")
Signed-off-by: Bastian Germann <bage@debian.org>
---
 mkfs/proto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mkfs/proto.c b/mkfs/proto.c
index 6dd3a200..981f5b11 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -20,7 +20,7 @@ static struct xfs_trans * getres(struct xfs_mount *mp, uint blocks);
 static void rsvfile(xfs_mount_t *mp, xfs_inode_t *ip, long long len);
 static int newregfile(char **pp, char **fname);
 static void rtinit(xfs_mount_t *mp);
-static long filesize(int fd);
+static off_t filesize(int fd);
 static int slashes_are_spaces;
 
 /*
-- 
2.48.1

