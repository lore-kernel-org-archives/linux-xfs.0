Received: from forward204a.mail.yandex.net (forward204a.mail.yandex.net [178.154.239.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3943E273F9
	for <linux-xfs@vger.kernel.org>; Thu, 25 Dec 2025 14:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766674043; cv=none; b=H6TC7Bv4sY97rzSsobzU8GHPTOr5Cx32RXy3CSy1o2Xh/cfiIh/Oq8WwhbVp9lZ6qBxVOR3T85oQflGPejFMGLi+gstbqwkoACb0+E0dZ2VaBEbW0UaqClIScx5/Qj0h+AskxZebwc3FmUgC56shvOQJRLd5ahFsyZeoQKyZd8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766674043; c=relaxed/simple;
	bh=SYDc6CAqUmMxboeYXKwN/g2znb/9MA3oDHLZOGTjJns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OzkkbwBPSgFSExnlVc/Vl3fiWQcoti0FC6ZO3F1cLSr1wuP0VE/xjvgdUpbCwu2u1NaPspqT5DzNkVpikEj5Z42hz10r9rlYn04v31pWaRE30RQf3yBWPXmMBybHEcriN3zW/bhBCb0zpFFJncuNv6Z18BnwbSgpw6pLlrZNT2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=RBgYSQ8a; arc=none smtp.client-ip=178.154.239.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="RBgYSQ8a"
Received: from forward103a.mail.yandex.net (forward103a.mail.yandex.net [IPv6:2a02:6b8:c0e:500:1:45:d181:d103])
	by forward204a.mail.yandex.net (Yandex) with ESMTPS id B6A89834AF
	for <linux-xfs@vger.kernel.org>; Thu, 25 Dec 2025 17:41:56 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-67.vla.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-67.vla.yp-c.yandex.net [IPv6:2a02:6b8:c1d:6148:0:640:ada2:0])
	by forward103a.mail.yandex.net (Yandex) with ESMTPS id E7DFA80774;
	Thu, 25 Dec 2025 17:41:47 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-67.vla.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id jfeRmt9GvGk0-WmZAkhlB;
	Thu, 25 Dec 2025 17:41:47 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1766673707; bh=CsAO5WQYyiqwW0dGgbYImeqET/3od8Th0xGjKKeuS2k=;
	h=Message-ID:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=RBgYSQ8a8s6tf8HInN9uU33zp1r2xBZluJcePpYOCl2YxT6ErbhYyGdvPXNXbaZzc
	 Ad8CKReXb8aDy2yehTeFC8iKJFgRzChPzS6E09OGCsiBNeTrU2l/77g9/kDzlnmu3b
	 MX5hIWg5oTnmwewNcGKmdaA8bh+Rf0tAC2NN/Gf0=
Authentication-Results: mail-nwsmtp-smtp-production-main-67.vla.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH 2/2] xfs: add power-of-two check for allocsize mount option
Date: Thu, 25 Dec 2025 17:41:38 +0300
Message-ID: <20251225144138.150882-2-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251225144138.150882-1-dmantipov@yandex.ru>
References: <20251225144138.150882-1-dmantipov@yandex.ru>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since the value of 'allocsize' mount option is expected
to be a power-of-two, adjust 'xfs_fs_parse_param()' to
add extra 'is_power_of_2()' check to catch bogus values
may be accidentally passed via mount.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 fs/xfs/xfs_super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 433c27721b95..984b66d71469 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1396,7 +1396,7 @@ xfs_fs_parse_param(
 		return 0;
 	case Opt_allocsize:
 		v = memparse(param->string, &end);
-		if (*end != 0)
+		if (*end != 0 || !is_power_of_2(v))
 			return -EINVAL;
 		if (v > INT_MAX)
 			return -ERANGE;
-- 
2.52.0

