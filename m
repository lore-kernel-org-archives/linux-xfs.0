Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.227.135
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717698;
	b=L4IBwjvZvxi4JiRWsT2TYtrSdswUY6Jx8qRa8ztWtbd0izooOyIfj4Tg+6M9wrs+Ndmg
	 Oourxr0mpDtjS4/MxWTfTfXrqj0LvlMe7e8J5nwi4dU0G3k7+XfguS07zcU2PtS6sK02J
	 r4t8+zVetXZlG8OxUhuPOp0tkelJjfw60LCQBt950RAffQqJLIqayZbD2uJqmQD1lAIPc
	 avlmBPYhikhypsRL8I0GAaZSPaHCBaScUrfOebRPsSGkz4lBdtu7hMw2+wQ+SThKdsfj6
	 4ihAOjY3JtY4a4U6yIsiJ2OOm6gCxKRKJ90K9tswhsx5apNyCnwcOYmLMk2ENYNV5dA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717698;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=CAccl21Ta2xKfCvErWmXwQUaoiGO2p8CkPuu5f18Boc=;
	b=Vs1TtMLYOs4VALOtSmQT7Nj/skDAKevA+I5n92ildJ5G90CL2vr5W6R1gMfh9t3qQmjk
	 qwiPu0JLM1Zq1xcC1pnAmlWt40hhupwMHOJ03neczXV/z64XHfGO+W3pft82dtFNRVoPz
	 rI8NA2f+1Lssxgs4mStwekK/SwTSp4xQpDz7qQO4Z8omnmjsiWJNV0LaQgCorSkLp8b5m
	 jSXElelmQUG8it8N5nl3OgZfa3gKEKBsehAbdXZFVqdRhWpWLhfwUNR2z93njrCp1Et2y
	 4kZWS8UIQCwJVd5hSXWZEUZUl5xDf9IWgaBczWMWyNnZ/ZBljTXpsLAwJOn4PICegvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cGZYm3UA;
	arc=none smtp.remote-ip=74.125.227.135
Received: from mail-pj2-f7.google.com (mail-pj2-f7.google.com [74.125.227.135])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA200606A324
	for <linux-xfs@vger.kernel.org>; Tue,  3 Nov 2026 14:54:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AA200606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cGZYm3UA
Received: by mail-pj2-f7.google.com with SMTP id 98e67ed59e1d1-3ac63aee1ecso1194999a91.0
        for <linux-xfs@vger.kernel.org>; Tue, 03 Nov 2026 06:54:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793717697; x=1794322497; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CAccl21Ta2xKfCvErWmXwQUaoiGO2p8CkPuu5f18Boc=;
        b=cGZYm3UAYTYHGi7MmhOTUyo7jEpJXrjWzTcmNeYCa8209WrAgS27vxUMTaZ88QM9gg
         J8snYVgRixOJsTkFQ4vno+yBbCMM1/ELfSy1YOnR2qZ8B+rOk30XTLqZYnyzWL4oUbNQ
         mfQUPI3I507wi4G3DYeK3TSNw6rD9YHM/G4Zsu5hwa90aMJjmfe8KHxddYQ2kepvM7bg
         e1mv/gh57+WAAnqtoYoveCwh16chExgRVL7mvEqtI/3TZ/Ks5g5oH8UNAMAc9CYYJ6AS
         Wcz4GBhWQQGuNXEn3IdjtEMw8ZOsaJx0Cpdy0OUSYRPacvmrCNX13p5iIi83zMbcivm7
         pieg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793717697; x=1794322497;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CAccl21Ta2xKfCvErWmXwQUaoiGO2p8CkPuu5f18Boc=;
        b=N2La6gZo+/Xtoh6EMF5THiICGn5i2CgyxIb3rLkGZPZqpeQjKxB+4Fkl80GcNLn5rz
         t+agGXdhzvbiANQZtQ7lbxKvuw+08dg1QqeB3ZxMCNvzgjATcClXV9qbg7TmMOyWw00d
         QlvgeldsTOeUr7TuuTSSKp0d6VsxrENxvyrxIIUzivIJ6KtJfVF3uQqJlOyUhPOIJ/ep
         tuIMSt7L7HCrXewFSn7d4oQ8sN2xqRbdpk92Z+odJWZAjfU7PhWS490un1J6p4LsDZUO
         JIaNnCvsQtKtdpPVDaNwvQNaPVy2GprsYDxBro2QzNZSy6XBMfxoHjyxo1T6DGu8ljmz
         RkkQ==
X-Forwarded-Encrypted: i=1; AKwUvByqE/4TdUu5sQ0no+L/mHErgKEofo4bE2Dy0XQZttM0vY59srNJ5Q1785gG9tLuh6PWzJOzaD1RfUQ=@vger.kernel.org
X-Gm-Message-State: APuU4Z9qLBPjk1zEroSTrcsdfhbIbUX1Ia8IU9lmJY1UOKZ/DmIjEM/z
	pDNcUr4frP1G+vF/rgUSsaIdGdvtago35qf80UQSAOClJd6UpD1D+K2U
X-Gm-Gg: AYBFou0TSwQiJhj2+lNHMa1Jz+bWZTB+qX2OShe77EErX/cQdmzdfckdJpm6szAtcuc
	CzYBt/SX3FYWESYDMawyL8GL7HF+pSfF1CINPnNrWT5VJh878fD4KEdVIKR91S+AVCVMsJRBaAk
	i/nokGfyAHiefrAGU2SeF3opOMwNntXmAhLQ9wchQtGVoC4kh+MqRagYb/ohhtg4XVFUNIskqD2
	z7EhbYi/w9jLXeqUBE+XtxMo8EeDW1YKwTnebdbRo9ABnd3sNOnKoBed8Pl51nBLnumKezLEjc0
	ar0UYyKltPvIT/aJR/lOMq1YWgdxs1LMVaXMcF/zggTPZiLSp/Y156SO/0Xv+58rx7iSKiVrJfX
	xor7gZccpEAEWA+aAHD9yyS74RJHWcABiidQb1OCx3DED/HlfNP1zlk+vJDCjWUt0eN5wsWItxf
	7BJrriBLlhGkhEw3i2VPenulaGINerUplR36/FRfLWEB3ZwHoxs67DnJHz+smB/fZyW4ToUF2SI
	Fwxwkn86WFmf4la6OW3SeiLx+C1D7JQRil5C7y1cvsphZXvdAIqhMOw59OYbBG6nMyBmhEzPQAU
	VdiOGfQkIZbuED/yAp9xv4QwkNmlR4rmEgKKUbyaN1ZEjqHbqEOs5bFwHh17xy1DB5gEjm9zm1s
	pIJAi6lW43gkAPa/e3NO6CegP0Ma8GsrVcJ6SrRD69A+JwjSRaNKHeYJ5ZTuk8A==
X-Received: by 2002:a17:90b:1d05:b0:3ac:80dc:f40b with SMTP id 98e67ed59e1d1-3ae897f55cfmr9602071a91.33.1793717696954;
        Tue, 03 Nov 2026 06:54:56 -0800 (PST)
Received: from localhost (ec2-95-40-37-200.ap-east-1.compute.amazonaws.com. [95.40.37.200])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b07c9b0ec5sm4753310a91.16.2026.11.03.06.54.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 06:54:56 -0800 (PST)
From: jianyungao89@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Jianyun Gao <jianyungao89@gmail.com>,
	stable@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Dave Chinner <dgc@kernel.org>,
	Mykyta Yatsenko <mykyta.yatsenko5@gmail.com>,
	Yuzuki Ishiyama <ishiyama@hpc.is.uec.ac.jp>,
	linux-xfs@vger.kernel.org (open list:XFS FILESYSTEM)
Subject: [PATCH] xfs: fix misplaced unlikely() parenthesis in xfs_iformat_btree
Date: Tue,  3 Nov 2026 22:54:47 +0800
Message-Id: <20261103145451.23755-1-jianyungao89@gmail.com>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jianyun Gao <jianyungao89@gmail.com>

The two corruption checks (level == 0 || level > XFS_BM_MAXLEVELS) were
added to xfs_iformat_btree, but the closing parenthesis of unlikely() was
left after the previous condition, leaving the new level checks outside
the unlikely() annotation.  Although the boolean result is unaffected
(all conditions are OR'd), the misplaced paren loses the unlikely() hint
for the level checks and indicates the code was not written as intended.

Move the closing parenthesis to the end of the condition list and
update the comment to describe the level check.

Fixes: b3bf607d5852 ("xfs: check for obviously bad level values in the bmbt root")
Cc: <stable@vger.kernel.org>
Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
---
 fs/xfs/libxfs/xfs_inode_fork.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 486fe7ab8b61..48e1c83329ed 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -195,15 +195,16 @@ xfs_iformat_btree(
 	 * blow out if -- fork has less extents than can fit in
 	 * fork (fork shouldn't be a btree format), root btree
 	 * block has more records than can fit into the fork,
-	 * or the number of extents is greater than the number of
-	 * blocks.
+	 * the number of extents is greater than the number of
+	 * blocks, or the btree level is zero or exceeds the
+	 * maximum allowed depth.
 	 */
 	if (unlikely(ifp->if_nextents <= XFS_IFORK_MAXEXT(ip, whichfork) ||
 		     nrecs == 0 ||
 		     xfs_bmdr_space_calc(nrecs) >
 					XFS_DFORK_SIZE(dip, mp, whichfork) ||
-		     ifp->if_nextents > ip->i_nblocks) ||
-		     level == 0 || level > XFS_BM_MAXLEVELS(mp, whichfork)) {
+		     ifp->if_nextents > ip->i_nblocks ||
+		     level == 0 || level > XFS_BM_MAXLEVELS(mp, whichfork))) {
 		xfs_warn(mp, "corrupt inode %llu (btree).",
 					(unsigned long long)I_INO(ip));
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
-- 
2.34.1

