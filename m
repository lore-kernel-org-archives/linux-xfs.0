Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5B518024
	for <linux-xfs@vger.kernel.org>; Wed,  3 Dec 2025 12:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764766033; cv=none; b=rNDj1PAh3CkjVcVYaTyNf4uVNzIWb7zcJa2fJTObqSXSv+T4TGiGl1ZUfQyuwCoTDY1DkTHRZcCrjOYx6NhLL7b9NwQ9dKyReTRqX7y+z0wiig6CpBxoJypOr3DckDRB/QRgtZs4qoeIoIAfSa6XGcEoFYKAz8tSKAhYq8G5rwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764766033; c=relaxed/simple;
	bh=PybDchmV0+NBWWqgRCqcZMbN6n9jgrzv3bjO/ULJSH8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DSKLoifG5khbikplgopsF3FUPRqRV3bubIGRxbx1u3YOPjrJwyS8Q3tjiWQt54jvuGUR+qDk+44HgFO9RK91XAZIAICejbwoNj1eIBqg9wydm6Mylk54EZQ++vioLy0pwb9qDdakJuWKbJM2WJeP3zxhyTNua47bghwHpDYMyi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UDGicDv5; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UDGicDv5"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3437c093ef5so7050791a91.0
        for <linux-xfs@vger.kernel.org>; Wed, 03 Dec 2025 04:47:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764766031; x=1765370831; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IjyvAGesvd3CUb5WuTwerR++ku5hNwb/4W2m6qlyq74=;
        b=UDGicDv5N2Od2nn1GnPAfxkdqshin9ajDnDcGbQlhYgiWkZswznyL5mtXW7A6xoF9q
         zI0Y+Cv20gz60BZ4pMu7K1gw4407Qhtgq1qRfAnEQbtSOXxf+4Vny8T/TD/GjuvidFXq
         IBJJwTls2zTbyMhfMZ4GqxmEsVWWyBDVRlVxW8McX216m9xux4JcyOoq35c2N4QS9muz
         lflzCSK7UwgL9q/1Ftgfnmn46+IgQN0Y4YyDfOASdwT8Tuqe766OOdtrUB3xHzQMpQDj
         KmZJQLzvggzKco8lnBEFnnn0Sl/LNQ+3JxAIwpgCEy6Kg5Vn5AE6xNtJWnkOclAIC6W2
         Nt4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764766031; x=1765370831;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IjyvAGesvd3CUb5WuTwerR++ku5hNwb/4W2m6qlyq74=;
        b=JpnF+qJWL+sdAiremaQsl4qAwEIf7QChgUHAwq8DWsUZym9MeGuUfiAkRr46MB+KGN
         g4EGEW8wV4yvVYPWNvBb/wsxlzzQcvPY/gJHhTVVb3YiQlD8mjfyilmL/Eb+G/o9yL81
         xexVVtE31f66dwFXhkZLbLZskv0eIgSpWotFu7CKu2bJT0DtxhwMwrnNZKpxPnNNqOGY
         SEhrMFDArBrM13al1EaDXEoTKL2b1zIQGRSN33j4KXQNzs5n+pVZO2jWZR/Chnq58lIf
         pUkGcMsr8K04a3KM8iHIV43GCX4htsGyWdycPQWR9zwKtpGq9GPCPWYB9X4J46KgRamO
         JuNQ==
X-Gm-Message-State: AOJu0YzluazXJwuu0PJPzolqDx/GvdHnVjHaPJKb6ddaAKKN6dC1zlAE
	kHApq0MDOMRO1Y4ioMV8Gx24T9/FqT4kqMlBtqeduyVkNPCYHHSd1BbJZU8PRQ==
X-Gm-Gg: ASbGncs9wQ+lD8bfnAEP4fwPIZjGgSLRjGP1f5Z4hYJ9QjHYtMLrCa3avMTZAB9CQXV
	Ox+AHfoNEUh4o16pCtEtpGo3tms0mhhW4XiBAUqSLXJQeQ+elPVG8T0gLMjVs3S89pEew5gSGKv
	1jNvLYs9HCiz16gwKLnreYTcTqa5V0W7TBPwByKU8OGpzwKsuNA3KI5tm6Z/mW5oCAU8ZaQGFS+
	5IAhS+Dg201X5EQCQ2ULe8ow/DN3+wZFCMZ0E6EiJpMZAJsU67Qva4NgBb6QXKwA/azh5rEBe54
	UQ5M8HNRa4k6Q1Oi0tTjlK19ZdkcJp4YWwNs1NxS1/h5SJjwnKH4sh7ePXb6jbMeTxlyp0Gw9PI
	vU5ta7zhmZ3TGyIkBlqgdd/lFzGx+cG4+9tfdSKImceJQ3AKc4ar3XHXb/YyuznkcUHnafSGIaR
	vS4tsFExtXIcfgstGuHciL8bxfsTQHBMd8XGNBsN7+o/jcD821Kqp9ZTW8iiLq5vcp
X-Google-Smtp-Source: AGHT+IGRSE3rQXfLiHrnRfrmjdZkJ9yHP4seAOjL9h9C4e0/Q6InxtYKnvlf8wFXDyK9aVTdKslaLQ==
X-Received: by 2002:a17:90b:3852:b0:335:2747:a9b3 with SMTP id 98e67ed59e1d1-349126bd337mr2239422a91.32.1764766030852;
        Wed, 03 Dec 2025 04:47:10 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.204.153])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-be50a51b919sm17794441a12.36.2025.12.03.04.47.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 04:47:10 -0800 (PST)
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: ritesh.list@gmail.com,
	ojaswin@linux.ibm.com,
	djwong@kernel.org,
	hch@infradead.org,
	nirjhar.roy.lists@gmail.com
Subject: [PATCH v1] xfs: Fix xfs_grow_last_rtg()
Date: Wed,  3 Dec 2025 18:15:45 +0530
Message-ID: <1e5fa7c83bd733871c04dd53b1060345599dcef9.1764765730.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The last rtg should be able to grow when the size of the
last is less than (and not equal to) sb_rgextents.
xfs_growfs with realtime groups fails without this
patch. The reason is that, xfs_growfs_rtg() tries
to grow the last rt group even when the last rt group
is at its maximal size i.e, sb_rgextents. It fails with
the following messages:

XFS (loop0): Internal error block >= mp->m_rsumblocks at line 253 of file fs/xfs/libxfs/xfs_rtbitmap.c.  Caller xfs_rtsummary_read_buf+0x20/0x80
XFS (loop0): Corruption detected. Unmount and run xfs_repair
XFS (loop0): Internal error xfs_trans_cancel at line 976 of file fs/xfs/xfs_trans.c.  Caller xfs_growfs_rt_bmblock+0x402/0x450
XFS (loop0): Corruption of in-memory data (0x8) detected at xfs_trans_cancel+0x10a/0x1f0 (fs/xfs/xfs_trans.c:977).  Shutting down filesystem.
XFS (loop0): Please unmount the filesystem and rectify the problem(s)

Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
---
 fs/xfs/xfs_rtalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 6907e871fa15..2666923a9b40 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1324,7 +1324,7 @@ xfs_grow_last_rtg(
 		return true;
 	if (mp->m_sb.sb_rgcount == 0)
 		return false;
-	return xfs_rtgroup_extents(mp, mp->m_sb.sb_rgcount - 1) <=
+	return xfs_rtgroup_extents(mp, mp->m_sb.sb_rgcount - 1) <
 			mp->m_sb.sb_rgextents;
 }
 
-- 
2.43.5

