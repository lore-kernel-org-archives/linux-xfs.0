Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB31737E5F6
	for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2026 21:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784238543; cv=none; b=mcRpF9CMGh/SkhQTMpikCwzr8zTWeQXJrqii4RYtDpvofCJZ163swWRpG+Oo7fbBXtcxDmFTlrRrBTC5trHaYuOdAhsvvOccm0Hgtx922JDQM0LNIGeIzabmUGIfvzUS7USX/W4Ri309ENqeq/47d4rKXiQwgjD1vquxXe4TizY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784238543; c=relaxed/simple;
	bh=oxgBT6jnCfW3cN29wj0+Vco9YlalVUouMQNF8iGngQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QkJ8P3V/vl1FHpERn+cUm6xoNgHpN2fmDQsEzYT8alNW3y84XnJ05m7z8N3iN1YEdZWMrhUKhI7OE3ubwv2YGPmS4M7eQRGYH7srwHAENKTdsM58WTKE4PonL5joTlWxrM8+HF5o7dU0nGTZr+Hqwcx+oZjJH8BOjPepKUtr8Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Sxgoszcm; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sxgoszcm"
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-495b250b01cso2897360b6e.0
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2026 14:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784238540; x=1784843340; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8dbiTWyAvyzhjhMzm3QqENoOfy7lwaLOmpHzU1Y/lIU=;
        b=SxgoszcmsWUy7QzSVWf+RytyTHUbjjb4nyiBAKX7EIWRQ9Xo2l+laR4vAT3PTpa3P3
         1hDORwgl4QcwbpH7ur5sUnOR6rrNBo/O/k9S44uDUdHmCJ21cJs5MqKY1B6wOLIuQBPK
         CThdj3H2pkKa3xhkuT3k84ydgPEzoGRIIY5a1CdGFtdzu3N1DblHU5+TB+ZLpjgx2S6x
         He8dhze6MWEE6+iF5dVqDFm3O1nPMF4cpX1qqqyV9HwPJdH5YW7urf8kaSzJJFGmwlo7
         WG30BciRpTwPkq10Njiac6TCCT9DoWn91Tti5WHzIiA8DgdlGOqG5qRxhqEtjGykxowT
         3Tpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784238540; x=1784843340;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8dbiTWyAvyzhjhMzm3QqENoOfy7lwaLOmpHzU1Y/lIU=;
        b=oZQdjLiIIY9XYyF+ioBwZvUH8j1kjeQgFwshxxH237QYy4G/Wblv4ZZL8w2hKJawVD
         /JcnWN3M0OswLxE1/EJlOwOnZz04ZRAfA5VsFs+fBtwhuSIaNs+rtgYFzBAyCMlSYRWE
         tQ5WG7Wj+EHp1/0QsDnBnxk2S7dAot0rXZsSpoV4wFOI+espfb3bR0o2WJLgpkEA9IUl
         raeWml8A63U8RwUKWpvSaOFVsZjr2VdRkcLyHr1TXfoxW36uXlN0iPm074kYHBd8Xq+X
         heNzj+Eh7LhG9sHeVUcopSizujP2Hlb2hDI3Od8pyT+rIyCRurTbEboSHO3UUf2niOqe
         B9MQ==
X-Forwarded-Encrypted: i=1; AHgh+RoLBUAs7q7k43owHcY57C65XQg0Jo5FHzi+dfaVJP8JrC3lCezE66Q7L/RhncrRDdyuzgXKOPsSxWk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzzay6LgfgY04+2gPIvptF2HfAeBcvtvaPmFwHdIsJ5zvonqzWl
	o0oi7za0heZhK14zjvg60+2OIb16t0uFMcsaU1LJg+mv7vE/B0pLFvsgUMfQzmbF
X-Gm-Gg: AfdE7cmOhPVNCNAZxtma3hXhQS5ZHFHhFA3nMcNxqVUeydXNeYQT6IiiKpchNZA8CBo
	meNKGEhlC/w5c1C88oII487wtY4IM6TwjvqCguodPBcre/jk66D+sejLRE0DPNz4ShAuPV6rcjc
	TTmqhz3X6oAmRkUmyHymN1/IrBndBK8d+spciS15FQkBOCI1XdJq83eZ3kCj/L1vu84Nc0TUAgC
	ulkIRi8nKByyqWBzmUMbYh36nZQkDZDiH/SZFNG/5BvuMaGoyPvtjXRffJRaxdzbAq8zbujDNeb
	BxBE+hvF9xd7xLHLu+AYPm8V3LVGphZBKgZ2LqAXIuDR6iY0DbZl6spsGGUc9zhSmtvnWqE0txE
	kODM2qivLiseauCNhfpHEPjF7nTa+YDpP0pzXkKwVcIO7X3L+MFGafgimgJeLrmSvkgep2Vv/Mg
	==
X-Received: by 2002:a05:6808:14ce:b0:497:d3d6:6a56 with SMTP id 5614622812f47-4a4c8321febmr1054181b6e.0.1784238540652;
        Thu, 16 Jul 2026 14:49:00 -0700 (PDT)
Received: from fedora ([189.146.106.138])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4a1b02e8e5asm20590547b6e.14.2026.07.16.14.48.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2026 14:48:59 -0700 (PDT)
From: Cihan Karadag <cihan.cihan@gmail.com>
To: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Cc: Cihan Karadag <cihan.cihan@gmail.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] xfs: use kmalloc_objs() instead of kmalloc() in xfs_da_grow_inode_int
Date: Thu, 16 Jul 2026 15:48:12 -0600
Message-ID: <20260716214827.21188-1-cihan.cihan@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert open-coded kmalloc() multiplication to the modern kmalloc_objs()
interface to improve type safety and prevent potential integer
overflows.

No functional changes are intended.

Signed-off-by: Cihan Karadag <cihan.cihan@gmail.com>
---
Changes since v1:
- Use kmalloc_objs() instead of kmalloc_array(), per Darrick's suggestion.

 fs/xfs/libxfs/xfs_da_btree.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 9debb95d86fa0..f190c088591bc 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -2354,8 +2354,7 @@ xfs_da_grow_inode_int(
 		 * If we didn't get it and the block might work if fragmented,
 		 * try without the CONTIG flag.  Loop until we get it all.
 		 */
-		mapp = kmalloc(sizeof(*mapp) * count,
-				GFP_KERNEL | __GFP_NOFAIL);
+		mapp = kmalloc_objs(*mapp, count, GFP_KERNEL | __GFP_NOFAIL);
 		for (b = *bno, mapi = 0; b < *bno + count; ) {
 			c = (int)(*bno + count - b);
 			nmap = min(XFS_BMAP_MAX_NMAP, c);
-- 
2.54.0

