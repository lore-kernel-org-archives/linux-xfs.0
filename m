Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 497B03E6DD9
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2026 09:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784020855; cv=none; b=TBEhf5r9viS9dqiMqPic3FymHyYTcMywFeX6DphqBlrZ5qKyXKOHZ4vyWMHIQvb1q/pFXx9tZ9AsHVL8N17GiftuUgoa9+FRF3Qrsdp7qr8xMNpoZ07R/yE0sl+mAh6URxsWAoAzmALLawPNKO1XCQ7q4kQo9diJuuhDhpA481M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784020855; c=relaxed/simple;
	bh=PcIih8A2q8QjOaOMBx9r3Uvk4QRm1v7fMl3IOoFq2GI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TiwT9gwQ3ZDsYr495VBoSPmniVUnGJup8ph1QFi+/qINtyShBnaLYe1sk4ocuQiu9eOwEo/oOnDI2cj6zylbGBf+LUmPvC5OLdEmJD85ueuEO+b+JauT4sGcjjp1qQY67Aqjq+Kt36mcxqCIkMQOXO3SRJowZdyrc+uhfeftYFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JFsfF8rC; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JFsfF8rC"
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7e9f829d75aso505188a34.0
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2026 02:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784020853; x=1784625653; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=lvC0cLqmFztIH/AT92uybh2U6x/cjf0UwESwZJaeBE4=;
        b=JFsfF8rCXyz4S8CTuxZI03BarKF+zhAhe4R4OL5gtygyqak1X8aOlz0Q7uB/IqrCy1
         wVQ/SeEk3yDN0EKrAK2bExbJ23WVFrqBI9esXEi3CSRR/omUU8acQgJid8ztduQKQMtJ
         aSrbDjCvBBHwnWu0wWBTe+H2IESQDAgNCEU7vN3qU3c8UvcYcpmsb3xNoGo1z6TLbLFj
         NJWs8DUXesdcHIpOlUdTAaVt5t89/GPj7fYkBJx5EsZFF8qIxxCpqb3ijnaVvN2tnvrW
         Q40hQ3HxDm+FlQKvLk+qF+0sIQfQsealCc2Wq30CPiYkvXXdPQNAN0uvSnYZgXDW/6Jm
         p/CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784020853; x=1784625653;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lvC0cLqmFztIH/AT92uybh2U6x/cjf0UwESwZJaeBE4=;
        b=bSAD1MABLRHzgz8KE/KwfICHciI/H4xf8NCjcbq3c9gS2UGSYNYMvIStQnqw9Z6aVI
         5JbQtiO8kTZJlzCv2Rws6eKFnvmAX1jmsrb0bTOxWMq/sskzHC1FPNmLl9WIATNQqBB7
         vXm56hvbdV4l4P2lLGt2P+qlffyTuH2gErjCA2TzTVaFg7tor2D7YpbtVxEr7rPKGaxw
         GueoyfHuh0l8tmwN9Ul68ni1QBUsC5SgEJPEgUl1swBe5nXIubQW1Cg2lifIdVaH6VDs
         i620yg45ecA/3lRlVvjXvvnhyY/oOOaGRWbF16S2I3ApDsu8QQc4Md6hBdjf1oGadd2o
         M45g==
X-Forwarded-Encrypted: i=1; AFNElJ/GvrPLNpbMFamsgS0Is9esiZunqdFUYX3PXXUmEM2KEJ7PrLO3LMkeZU8QKTU2qSWW3lGqxfG2TIo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxxXcqmAPKoQyEoIuIxkihx+1CcFqzXk2iAeRotYGajbuLj8RR6
	kdbePwn25Htb5n2F1PlNTg4sC7i8JGjadHEvzdd922RZgUCHtlg+s2sy
X-Gm-Gg: AfdE7cmJWnb2XB1SoMK+PoH3qULJ2uURmw0AicKC7k5YzmX53ve/ihkKzQvYp0Jih8B
	VyJouTcWVc5sIMiLkOGCqjVaRAacDOH67ttdsoTLy02ORx7ivb3SC6FG657vylph48XRbWNwi7D
	60/iI8O6Vrnuy+eel/MnbH1GAf7E/VY0SnO1jc5HxJGEe8vDB0Nj69QAqBwLvBHQ+41KcAqDsPf
	VJhnFhlRrn2gtQz/yYJLr6QgSuZvlRQWd8IzbrWLBBC32OCVUkCMPDSrTGmuHhgyQt0/+M4/64A
	PvD+M4QyeJ7ii+EWddjrVRV9z+fjxQB/+yLJMcn0/mdBYOoQzGAz7Nm0uyYlchTF3QctHFy5ax1
	mxBzoxJ3QZFb1Wh6Qj5r7VBV74TH0CPX7x5txui0RshBXsIqmjL2K+obVw/kp3/QESpT6+boWzB
	5rARvxTW1iq18LRL9IIA==
X-Received: by 2002:a05:6820:8186:b0:6a3:7f14:7d02 with SMTP id 006d021491bc7-6a39a6e4692mr7435351eaf.46.1784020852705;
        Tue, 14 Jul 2026 02:20:52 -0700 (PDT)
Received: from fedora ([187.142.231.66])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6a39af0e953sm6404022eaf.3.2026.07.14.02.20.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 02:20:51 -0700 (PDT)
From: Cihan Karadag <cihan.cihan@gmail.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: Cihan Karadag <cihan.cihan@gmail.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] xfs: use kmalloc_array() instead of kmalloc() in xfs_da_grow_inode_int
Date: Tue, 14 Jul 2026 03:17:24 -0600
Message-ID: <20260714091912.239557-1-cihan.cihan@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace the open-coded

	sizeof(*mapp) * count

multiplication with kmalloc_array(), based on kernel coding guidelines
against open-coded arithmetic in allocator arguments.

Signed-off-by: Cihan Karadag <cihan.cihan@gmail.com>
---
 fs/xfs/libxfs/xfs_da_btree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 9debb95d86fa0..99e4318ba75f2 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -2354,7 +2354,7 @@ xfs_da_grow_inode_int(
 		 * If we didn't get it and the block might work if fragmented,
 		 * try without the CONTIG flag.  Loop until we get it all.
 		 */
-		mapp = kmalloc(sizeof(*mapp) * count,
+		mapp = kmalloc_array(count, sizeof(*mapp),
 				GFP_KERNEL | __GFP_NOFAIL);
 		for (b = *bno, mapi = 0; b < *bno + count; ) {
 			c = (int)(*bno + count - b);
-- 
2.54.0

