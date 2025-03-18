Received: from mail.cyberchaos.dev (mail.cyberchaos.dev [195.39.247.168])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43D53FC3
	for <linux-xfs@vger.kernel.org>; Tue, 18 Mar 2025 10:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.39.247.168
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742292163; cv=none; b=Y9EK6M+lvGf+YrA/JiUI4unK5bVFM77J9VwhN0lkfIpLRpN4xa6JhBZxcppG6DqKAJHitpAGUlwnWtDw3oddcmHuJf+KtGCRxdGRA2auBnEYBfGx9LZ4OUAS8wrH83BCMuuUN3ykTYD/thqtHXRV30qpu8bk0+5mDyi3Fplcl1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742292163; c=relaxed/simple;
	bh=suR8CTJZBQD5WucTmBeOUTTxF/cmePt+mIn5ghhHprY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=E/iWhwF00TUcjmbzx/nCGbQpvf9lXD/CACSzhLXvC1BFE/PbLNS0NEy7G41/YF51erIheHuWNYa5PmPH0V/jKrq4Jc0UNTOLRLlLc9PlucbKndJQA/Lbeo8NQzL3GtB2cC7YHkAm9UaUAzDUbmvRlB2oNJTSHyff7l/rvMNTQZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yuka.dev; spf=pass smtp.mailfrom=yuka.dev; dkim=pass (1024-bit key) header.d=yuka.dev header.i=@yuka.dev header.b=N1bIHFTN; arc=none smtp.client-ip=195.39.247.168
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yuka.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yuka.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yuka.dev header.i=@yuka.dev header.b="N1bIHFTN"
From: Yureka Lilian <yuka@yuka.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yuka.dev; s=mail;
	t=1742291685; bh=rEjRaYeLjkiML6kAX+4JVGTLZ+oWgsdAewR/JtVKPuY=;
	h=From:To:Cc:Subject:Date;
	b=N1bIHFTNIlOw6n95jq0lvOg5cyyFAuTp3tQ6Iu6S66B7PQYr3j3vGq9E9PLCoLn3H
	 UoMy05VeWpzOBr6csF5FdnzWF7zU4SBfis+Yi4jvlkEM2YOlAKpT6wVoXfyCbYvea+
	 LgFcoHMrW4UuGRCLQ5XtatSgNYn9Z1Vz6jcVYm8k=
To: linux-xfs@vger.kernel.org
Cc: Yureka Lilian <yuka@yuka.dev>
Subject: [PATCH] mkfs: fix build on 32-bit platforms
Date: Tue, 18 Mar 2025 10:53:35 +0100
Message-ID: <20250318095410.198438-1-yuka@yuka.dev>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fixes "proto.c:1136:1: error: conflicting types for 'filesize'; have 'off_t(int)' {aka 'long long int(int)'}"

Fixes: 73fb78e5
Signed-off-by: Yureka Lilian <yuka@yuka.dev>
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

