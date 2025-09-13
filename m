Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE5AA935
	for <linux-xfs@vger.kernel.org>; Sat, 13 Sep 2025 03:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757734649; cv=none; b=Cs/DtPX48zRjbYXPz74viKV5XTyfdjOzRHGs5nJFpbCB2PYgXDxjXAvb3HhWeSPLtBSNnjfpp3pjYchUKgFJA1Fe8InHftd9HrVv4qlV+FM+DKfNm8pGTyJTkNYi5A/CYt4UEHxOHMLr9cVEedt/QHfHB45g/gSr2/RpGKFiKKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757734649; c=relaxed/simple;
	bh=S9RgEf0sKLoUujoXKzI5jyp7RRc7a0WMvLCahxrVDpE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EpyeZgPD2PxLXOV+NgDyNIil2tcrn6jv0mQ7lVUTTQs9QlKCFznthsb8dC3JtugiNGgMTW4oirndDxuQTccHUsP3JigzC7m/vKcwLNAfByHBmzekg27Gn2KY5Yqo63w97aFR6qcsJRAcaCNXP+MN+zZD1SgFgcN4jvYgUxcKscA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IunoaQ7d; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IunoaQ7d"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-32ddfe3c8ccso2506674a91.3
        for <linux-xfs@vger.kernel.org>; Fri, 12 Sep 2025 20:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757734648; x=1758339448; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=K4uUqLHm1wv3jT3tEGcJTrI2K+259prtijoUXxYVBhQ=;
        b=IunoaQ7dcbaWAqtC+oSt9VEMhBLJnUdDbD/bDWOD87mf0pDoH7E7DKuyr70tzldnVd
         z+aq/DloV4IXdyQXGXjJdoc5in/TVUEB0bzILsWpACyXwg1WS+fWkgvlZuSdszWxxuQb
         WKLfDxDztr3hvAOanUXMc08ySQvShxdTHRTvMOGpv9TeZTXzRh+DvYwXqnMnH4s1Vvwo
         S2q9YNRB7kLrgY2WTsk8cL2778Wc0x7zuFTC8b0CcU60F5u6+MvEowdC8n2nZK4xWmm/
         X6XOe05CbqjWPGjCyj26ZakuC3QvcTh/2HWtmreOFv9N2ZvJSz3V/0pK5Drdz1Q61w3e
         EKSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757734648; x=1758339448;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K4uUqLHm1wv3jT3tEGcJTrI2K+259prtijoUXxYVBhQ=;
        b=LoEHcQgTihkqyHmj08IHYdJpk4wha6ojSuCBhpgnZbisPam8bosnWLHjQl/Qb/1u2U
         ZFNHuPuyIrbNqB8YTo5telSMV58MDPoCiI/YktwUppdCvjBeqZxmcn9i3wjSztjTA2oZ
         KQF5yPXaSt3uphN7waF1jmBtmLv8wURhQ3fyoigi8NoWC9juCkxF5mxevhaYCJpDODih
         FEawDivntFl8ktUs3ctY6nVyFp2El3G/jUHuTos2I1qvXhIgtj6DrHcXyQn4tmTobIfw
         CQMJzUX1+/nbBKsyRE0cTjYipG3WmC+POI+MeSejH/pUoS4ED5RVnvfeLiIoGKNJq+Oc
         o4OA==
X-Forwarded-Encrypted: i=1; AJvYcCU5WJupk+N7EgERIvzL1+w8Iv1ls76ggIr6nFHLd3w1cMJo68X4DrrchsMBHg9CjCiq7YaOe6rJc90=@vger.kernel.org
X-Gm-Message-State: AOJu0YyWzYIjMsapPUqH2iGObq+UJDVAlrMgLQJDtr6BxYk4Ojcw4EpF
	kw3zOhOC28ZPgzw5am1KrIaBekyDGSQGfY2SszvAolMuloyOdQE+7O2GKwhDTY1K
X-Gm-Gg: ASbGncvGj59d+j66a01QtjocDLOLUNayX5o+ClBSK9t2QVxn6YSnLQWxM68pt3WgaNT
	OAGSZs19ruXg2xRtzlkMCeDVvJeGzjHG1DMediOgRP7mnexCIghICp96bKPthXOKjkuaaVyClot
	bWD+fRBFlRPYa0YU/9C4+UUKmLuYJ2zvNNaatubB5KBSdsf53vKM5oaiiHEPHp0XTHcAWXfjvPe
	FOpqzJp8wUBXSWJI9kWN57/SBPdctiihuoTj3tC9Z3//a+9ghBbr60H5OJQ+CBGuAmVzw2CzVU0
	ShsNIv3Hwws2rHzbNjIIGNY4WxE+fFDMu8KLYZZM2hFT1HVwvzXLt4rVc/Ef5iVJePd4JBDSUBF
	YojuBo9OQN7Tb2G5I/1+yLsIOCoA4GDX9dA==
X-Google-Smtp-Source: AGHT+IHs2Rsk72hJiBcf1dG1IHcVl6K6BhYFOSeWdIg9w0otcC2YgzWP62rCvvQj7XJcIaLvM51cww==
X-Received: by 2002:a17:90b:1d0d:b0:32d:f4cb:7486 with SMTP id 98e67ed59e1d1-32df4cb757cmr3628309a91.19.1757734647593;
        Fri, 12 Sep 2025 20:37:27 -0700 (PDT)
Received: from VM-16-24-fedora.. ([43.153.32.141])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32dd98b439asm7150770a91.15.2025.09.12.20.37.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 20:37:27 -0700 (PDT)
From: alexjlzheng@gmail.com
X-Google-Original-From: alexjlzheng@tencent.com
To: hch@infradead.org,
	brauner@kernel.org
Cc: djwong@kernel.org,
	yi.zhang@huawei.com,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jinliang Zheng <alexjlzheng@tencent.com>
Subject: [PATCH v4 0/4] allow partial folio write with iomap_folio_state
Date: Sat, 13 Sep 2025 11:37:14 +0800
Message-ID: <20250913033718.2800561-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jinliang Zheng <alexjlzheng@tencent.com>

Currently, if a partial write occurs in a buffer write, the entire write will
be discarded. While this is an uncommon case, it's still a bit wasteful and
we can do better.

With iomap_folio_state, we can identify uptodate states at the block
level, and a read_folio reading can correctly handle partially
uptodate folios.

Therefore, when a partial write occurs, accept the block-aligned
partial write instead of rejecting the entire write.

For example, suppose a folio is 2MB, blocksize is 4kB, and the copied
bytes are 2MB-3kB.

Without this patchset, we'd need to recopy from the beginning of the
folio in the next iteration, which means 2MB-3kB of bytes is copy
duplicately.

 |<-------------------- 2MB -------------------->|
 +-------+-------+-------+-------+-------+-------+
 | block |  ...  | block | block |  ...  | block | folio
 +-------+-------+-------+-------+-------+-------+
 |<-4kB->|

 |<--------------- copied 2MB-3kB --------->|       first time copied
 |<-------- 1MB -------->|                          next time we need copy (chunk /= 2)
                         |<-------- 1MB -------->|  next next time we need copy.

 |<------ 2MB-3kB bytes duplicate copy ---->|

With this patchset, we can accept 2MB-4kB of bytes, which is block-aligned.
This means we only need to process the remaining 4kB in the next iteration,
which means there's only 1kB we need to copy duplicately.

 |<-------------------- 2MB -------------------->|
 +-------+-------+-------+-------+-------+-------+
 | block |  ...  | block | block |  ...  | block | folio
 +-------+-------+-------+-------+-------+-------+
 |<-4kB->|

 |<--------------- copied 2MB-3kB --------->|       first time copied
                                         |<-4kB->|  next time we need copy

                                         |<>|
                              only 1kB bytes duplicate copy

Although partial writes are inherently a relatively unusual situation and do
not account for a large proportion of performance testing, the optimization
here still makes sense in large-scale data centers.

This patchset has been tested by xfstests' generic and xfs group, and
there's no new failed cases compared to the lastest upstream version kernel.

Changelog:

V4: path[4]: better documentation in code, and add motivation to the cover letter

V3: https://lore.kernel.org/linux-xfs/aMPIDGq7pVuURg1t@infradead.org/
    patch[1]: use WARN_ON() instead of BUG_ON()
    patch[2]: make commit message clear
    patch[3]: -
    patch[4]: make commit message clear

V2: https://lore.kernel.org/linux-fsdevel/20250810101554.257060-1-alexjlzheng@tencent.com/ 
    use & instead of % for 64 bit variable on m68k/xtensa, try to make them happy:
       m68k-linux-ld: fs/iomap/buffered-io.o: in function `iomap_adjust_read_range':
    >> buffered-io.c:(.text+0xa8a): undefined reference to `__moddi3'
    >> m68k-linux-ld: buffered-io.c:(.text+0xaa8): undefined reference to `__moddi3'

V1: https://lore.kernel.org/linux-fsdevel/20250810044806.3433783-1-alexjlzheng@tencent.com/

Jinliang Zheng (4):
  iomap: make sure iomap_adjust_read_range() are aligned with block_size
  iomap: move iter revert case out of the unwritten branch
  iomap: make iomap_write_end() return the number of written length again
  iomap: don't abandon the whole copy when we have iomap_folio_state

 fs/iomap/buffered-io.c | 80 +++++++++++++++++++++++++++++-------------
 1 file changed, 55 insertions(+), 25 deletions(-)

-- 
2.49.0

