Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B1CA2D5926
	for <linux-xfs@vger.kernel.org>; Wed, 17 Dec 2025 05:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765949901; cv=none; b=fTeqolAPdYo2Susa5exYgb06GrGEsOc+/O+icuMMGSS0pEwT/KnTm7GjhSeyD5wNqKIRAvW+dBckfUNyRB7PypU5QEmKulssgBKnXni1egzpyPRrkIf3i+2B6fG9qL1CPNkiHT6HAEswyU5DEzj0NX8Yg+cLh95YRrMj6urr5qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765949901; c=relaxed/simple;
	bh=uBXtNvDEQrh/RBX/fWyCzO/8vNyfoNXA5nsXtCrdy0k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ozYEnnjylCDKweLYWF7Z/NZGz18106l/67+pu/R/l0Aup2X6PZc8En6wspgA/J2JehBJbRlV/PCXXnr7FtpLZOxJ67ZbEFAAIhfzmUSIep2IQqg5fTVXGfSI/v/Ag4pPapq+3VOUFRP4rmgzVhtO+8tSyc9xCVnyHBNPNkOENgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j7vG124B; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j7vG124B"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7b9387df58cso8282190b3a.3
        for <linux-xfs@vger.kernel.org>; Tue, 16 Dec 2025 21:38:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765949899; x=1766554699; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tgAEvSX0xTTF7eQmZHO7SlXhGOQKi/ETxcWiSywsWNU=;
        b=j7vG124B8HBN2K/Lf11dea7yNivXwtiBxs2BdPQL9cPFZAIiZc8ijumfI7Onxwp+3K
         WT0MLw/JfrVXFKlwfNBcD5W0IP5MYcpHBFyteWPEJ1c+SFgmRtI3GmHrjfcRT3iBxFwg
         7SCOAptAtdofD3KQmOobriQIc1CMCS62f5oztByQy3zy/aFwGljXMzka6VzZefKjHDUx
         dFxXVkxo81oQkpflRe+++1mL7HZJFMHxb2q/wuPBzhuw5f3unt/Bx6f5YK92H9dkq/9D
         0aV5uTpU8T9YfAKfB4bE4yciWQGVUMicw9+9HGNwqruZBSIeQHfRV52l9mBC+VlMxHuK
         p7vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765949899; x=1766554699;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tgAEvSX0xTTF7eQmZHO7SlXhGOQKi/ETxcWiSywsWNU=;
        b=lIeQ4I8uEu+Y2i1P93tuDXypZaQtxmJfRfqX9PCoFlSaNNsF9XUa+/DIpEwGtmisur
         BQuAeBdbPl9VU90IvSIHqBgYxmerUvVyxM7AiDNVx5lc9+4iwQUDGGVpT095PxbmBnK/
         XSwQErMt9PGTUvh9vrNqwesWaBsghCs8JYXIWW/cbDcH+CAbE4k9hkTn66xScBI8xegJ
         +WI/ksrpvyD7AASGkNlwccZyW8x76grmW2QmRfjtfTkzVwcCyO4vyDGQKW93Im+dMPeo
         u86UAtggnPY/ODTHgWaA1pAbo4TbBIFKqu9jPt+UIsXcPYDpsNKd56dye8pE/5tqwHu+
         TYVA==
X-Gm-Message-State: AOJu0YzRC/f4clnGzS7tdg9ZVfwhSM7/kdua0PcIT7Ng1mGJ1B3j9G3r
	Os4JgyOmuoaFaL50gT+cyd3NXHtlU9v/KrYCMHZ4E42HYUIKkTHJcTAQzUhRgQ==
X-Gm-Gg: AY/fxX6FmCE2sxiy0fkNce6lo33LyzjGg9Vjq5TPrYJibVl1eeYkUlcsWh11CeqB4D0
	owldAlmYPh2u/zC33PiT3woHg0O/VgrKA2t9CZKWxtkgfg3XZBjl5KegTvE+P791KFe71MlhwDj
	0n3YA3Y8QQou68PWm29DRCTwDtQJY875thXJ4L9f9rrz1QMovrKzffHt/hauNG0WANS7M0kp6ly
	x3JtVCYyYW2QnSMaPcyk2odVmdt78Rg+iXd2NjyviVe82fuKMUkRzhMipLPjKcAgosp0A4NHrqC
	6DDcwdabt+c7zkhLDn4wrLLFPWXuj+0vNhw98RyEw4rwJ8jyzm8ufU0RiWaT27Zh7HTImYwb1aM
	bRUrPBunQq9jdhL74gNpjoPIWe8GAqa7DSEYJ5qRBt+r3bUiEEzdYLN+ZzdKFNDtpCQqhyuPRUZ
	5RZ6G/32BSXi99fmoDwFG2sr0kcUOUPOivvEYPD4AV/lqNRC3Otgilfo24pQ8VIMRvXae3aw==
X-Google-Smtp-Source: AGHT+IFN6uOVeNeVnZe8OmyiTgzZuJnXSmLJt1o4yHNSHbCuh2WWfE03oCVY3agn14iswOsFDtRKEA==
X-Received: by 2002:a05:6a00:9094:b0:7e8:450c:61ab with SMTP id d2e1a72fcca58-7f669c8b7a6mr13760677b3a.66.1765949898947;
        Tue, 16 Dec 2025 21:38:18 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com.com ([49.207.205.246])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7fcbc1c43b0sm1332806b3a.64.2025.12.16.21.38.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Dec 2025 21:38:18 -0800 (PST)
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: ritesh.list@gmail.com,
	ojaswin@linux.ibm.com,
	djwong@kernel.org,
	hch@infradead.org,
	nirjhar.roy.lists@gmail.com
Subject: [PATCH v1] xfs: Fix the return value of xfs_rtcopy_summary()
Date: Wed, 17 Dec 2025 11:07:42 +0530
Message-ID: <d4209ce013895f53809467ec6728e7a68dfe0438.1765949786.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs_rtcopy_summary() should return the appropriate error code
instead of always returning 0. The caller of this function which is
xfs_growfs_rt_bmblock() is already handling the error.

Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
---
 fs/xfs/xfs_rtalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 6907e871fa15..bc88b965e909 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -126,7 +126,7 @@ xfs_rtcopy_summary(
 	error = 0;
 out:
 	xfs_rtbuf_cache_relse(oargs);
-	return 0;
+	return error;
 }
 /*
  * Mark an extent specified by start and len allocated.
-- 
2.43.5

