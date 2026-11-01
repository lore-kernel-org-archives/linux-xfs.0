Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793550487;
	b=2HyVxxCNxPxOHoiKiOnTmy+3w8zkXxkqVpLu4Yu1ocghDBVxPwG3wdpGiRvDiRwuHkOP
	 DEg2upvU0pfS9R2gf2op+XtlISWQCLBv7216XMVr6tw/7n4ZzFVYuX7fu7z8rga50dHTH
	 TCqCZ8G/vEPG4+E7pGw1Ai2jtDhgObqw46SN6pSRjeAWcREVapPmxsP8DUUVyDqBifTkT
	 LOgEWS/SY+SNu1mrYsVNnBroGXXe5EECd4Zh3SoiYY3N10e6IcmWlbauWSA3KFnysXHFM
	 ItfsuQO8dVn4KRGarOKDdI4NwKVG3Kc1BoGsxylKBPuAYyFVscm2+rbrvjDd/6RfAlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793550487;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b3X7tmZ6ZPCx2umNISBeMMD61ZO/zf2nwzQTuecr2P8=;
	b=RCFqv/1zjxOz8cpP0PihsQhdrBg8MT7jjUJCm9bu7kLWxnIu1mzB/5XcgI0X2HdNG4vt
	 diDYUgeW8QkVCHJPwf2zWBWb2Mw7ANFaKwQc2vvXKqfEwxU1eRKVLky43dYUo9ygpmPUy
	 T/aDpcEiFFlehchkqjVEauZ2BS0S6TTN/+DpimGe6v9qHF70SXbxCE5pi6f/JpRHgHO7K
	 5E5H4c3PIBg59dSxRtSQL9+jZvdqSE6blx64P0BsVjn5r980lJ2G7riFPQtTpcKNtmwti
	 MQpl/+Ra6pE5M4Ik029fs9ku5EwMStiOCQk18KdVe9jn05+DEglCu9TOk3j/ydL2Z4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=J0k7B6DF;
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0059A606A326
	for <linux-xfs@vger.kernel.org>; Sun,  1 Nov 2026 16:28:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0059A606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=J0k7B6DF
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a59100fa83so19087085e9.0
        for <linux-xfs@vger.kernel.org>; Sun, 01 Nov 2026 08:28:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793550485; x=1794155285; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=b3X7tmZ6ZPCx2umNISBeMMD61ZO/zf2nwzQTuecr2P8=;
        b=J0k7B6DFPzOoOIaJ9tVEoU0Ycy8aNCGnXZKrUCulDpX9/fGkoUDEZiIEMOQEeuZ2Or
         /37yrqC0Se9MERBFdvzMmGgzKqiuz3E4khRvSW6/zk2z2QTNZjybMmtBnvtnKPMDAHix
         LTiBnKV5aRusW38z15+vULScq6yZ0PSyjxOWSm+VnJPKUWFevW4zypUg/SYYDxAzOCKX
         PiaRy/2Us+R2brvWuEnUeqjqzi7/j9simvnJNXKY7zoRRTS7SZqgO26kMMG/sfgKrxQ4
         gX/SlEEcGscdVnXdxEZ3ZaaUqCq8uKB/U+tc2NIasKe0CD1FjxMMVKkniYT5IDigK4OT
         kxlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793550485; x=1794155285;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=b3X7tmZ6ZPCx2umNISBeMMD61ZO/zf2nwzQTuecr2P8=;
        b=1W55Xs0AJhnVEr1MzShw7OpmoFNr29eDGnoYTNSVeiw9YjkJscB5y4/2m3pbp8XO6s
         MZAaXaRSQozXZYRRJsDumwVOgMNZ2oAQy/sbLs71WqWL/mfstQshVwuP0o7qLzX0HSuk
         Dk9v+73qhJXvTqv5QluZhS5iDbOxYqlPhgfv2yNr6LAZDnYdu70E7C0aTk39fXdDNl3O
         2HgstspnDTNmsP0djJ8fRnz2LbKk9DXXvzlWl1wL5BWeQwrvDfIzocauW4FQngFAfqMy
         qPhJ/BNou2v6WSizn8IWDe5iWekaMSchrQ44uxSSuEVJe9g7KKyjXUQI4V5Emdj6XryB
         mfSA==
X-Gm-Message-State: AFq9FYKbnlDApLL3kOMVg7cnR4NVa4fqEdkXABgphqcUgWRmG5jo1F5j
	TnAG2WMNCI2IDmgD7shC/MdjndS+HkQqh618MhrdoeW4cFdKSv3hwCaG2trs
X-Gm-Gg: AYBFou2wcvzjDqsxc06HHTdXNDpFobqP6u6tqgErYerTr16wjXVcPEmgHB+fLP2Ds78
	ox8CeTKNz63aD9oQEy1v3wSnQcqBSBdf+XotQwd32h4SFs13iqvH0BelC2VMYY2VC3PZObeUMIU
	eXcpJssK3JraT7UTPc04m1gRovyJ7tqntZ7pw6FBr8hHGOEYUnkNp9w3spfMgS6UKXISgEUefHX
	BerCWBg1rsc6zHHIpUTBO/lZ/adfUQ8xvlaXEj4SBRLKI2bDZ+vWvJNZzqurIb0Mt4f322724iv
	t9l8cvwpOpPubX25GmNwERAoCQMlXUG+tSsM9+qTvD3JMJCKhZy49o6wC/bShiyDmRQc0wgYsTJ
	sl6JPcEh/+SIjezpzCE65T+uPKSfpWDOPDGzhYXvNT2ntRHUAXnxCDW+mABYNW0JWWELPWqtYZV
	/XYyr3bErjPLsF7TFKq9e8HqBPDn00ErV8loNN1XmucStF9iHt/AltJvRu+De9rgNOGbRlbovBs
	EGg3S5tKslCiloUIF+gIp8KtXnOxN3fSreqTBNN/maIs139MFmaAx/MDh132iJfhzouiApd6C6d
	2ihxk3vcP+k=
X-Received: by 2002:a05:600c:a012:b0:49f:fd2d:23c7 with SMTP id 5b1f17b1804b1-4ac17b2ce18mr177141675e9.27.1793550485307;
        Sun, 01 Nov 2026 08:28:05 -0800 (PST)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abf0b36853sm192023245e9.0.2026.11.01.08.28.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 08:28:04 -0800 (PST)
From: Tristan Madani <tristmd@gmail.com>
X-Google-Original-From: Tristan Madani <tristan@talencesecurity.com>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org,
	djwong@kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH xfsprogs 0/5] xfsprogs: add missing bounds checks for on-disk fields
Date: Sun,  1 Nov 2026 16:27:58 +0000
Message-ID: <20261101162804.1444159-1-tristan@talencesecurity.com>
X-Mailer: git-send-email 2.47.3
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

Hi Andrey,

These five patches add missing bounds checks for on-disk fields that
are used as loop counts or copy lengths in xfs_repair, xfs_copy,
xfs_db, and xfs_logprint. In each case, sibling code paths in the
same codebase already validate these fields correctly -- these patches
close the gaps.

Tristan Madani (5):
  repair: validate MAC label attribute length before stack copy
  copy: validate bb_numrecs before iterating alloc btree records
  repair: cap extent record count at physical fork capacity
  db: validate symlink target length in rdump_symlink
  logprint: bounds-check continued log record copies

 copy/xfs_copy.c      |  8 ++++++++
 db/rdump.c           |  6 ++++++
 logprint/log_redo.c  | 15 ++++++++++-----
 repair/attr_repair.c |  6 ++++++
 repair/dinode.c      |  5 +++++
 repair/prefetch.c    |  3 ++-
 6 files changed, 37 insertions(+), 6 deletions(-)

--
2.53.0

