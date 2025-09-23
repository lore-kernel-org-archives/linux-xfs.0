Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1365274B3A
	for <linux-xfs@vger.kernel.org>; Tue, 23 Sep 2025 04:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758601324; cv=none; b=s1EvND0HJ4RTaWjiIA0jVsOepZ+k6G0urkQ9VH63Ys9WatpEd1CtD0DbBbZWv46gzNSvxXzKNARCHDr/BOPs5uWRsp3Uj3id15UrSO7tCw6YvDGAKACL/yPSPf4dzGUXSARF76Wsa+Gal7YbeBKNwarJmDNLIlxPg7Q1h5klf7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758601324; c=relaxed/simple;
	bh=+QlMXBX3fIO2WsSlIyfqccXfJ3O6cuDiaAdLlHzXzPY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Qz23dlBbKzLLu9uY4wZ0zTS8lXcLEtub7OSDOo0Hic/4MTTnRSReme+6HtbYPspHNuyCy90DLosvEqj652ekdfTsqQOi8QIvoKoH6gH+cMpK5Z51N+E9AVZk4irGM1e3NuVYq2wUdO+S490O8l0SSEX3xhJSKR4VpSNYsYWZA7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dRyJteT+; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dRyJteT+"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-76e2ea933b7so4643410b3a.1
        for <linux-xfs@vger.kernel.org>; Mon, 22 Sep 2025 21:22:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758601322; x=1759206122; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fgtSPBN4qoSsBifl7HF2PLKbfZ3YMsx958plJG8wRIM=;
        b=dRyJteT+f6HjQ/KobfU6hmjRCXKruCQn405O+rf3M5sDOGWM+q2Pudeg/yzeTvWArw
         SMS/4n7T+vXppHi+3dwMhjQUxCpDjcgygRjQU8FbcPAaWc/SKCiSUCMleRvvSy6fc/Zy
         uYSF2RNOU0dVVT65eeuCa0Uo4CAQfyVHW49ktgZgnGfLr6uCU2B5CP2o4ahlhkE9bkDp
         RLxf37sonEHc1jx02vpgxmgbVPkSy9v+eWr4U3xZDDj2sgoR1TtqxjFISaCcAaid1vwy
         xdr/7SsYkMn9BL2UT4KDXXYLMv8Zb98uBJMtHNNHscd6EMhPJ5akfndDNKEeMFnCdOcG
         ISuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758601322; x=1759206122;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fgtSPBN4qoSsBifl7HF2PLKbfZ3YMsx958plJG8wRIM=;
        b=C6lzY6TAlGYEmjJ47eCdMKH0G+Y3+MmhK6qhEUqP9/EUH7fc2RFpNK5YOHBALNhQ78
         8ub0uU28KSafWKAnwQtayvhsUDVlynR6+0pN9nMQ80ZiF/5FRuXo7SD+Iqt+bNvkLWhV
         fb1TeT87MONguhKLl2IBhNYdYvI6YgWDUjTS55g1yzLumfWxgnpSIzVNXUpXoHsQGISZ
         LX48UAIUL6nWzPYDRy0VI73imAT95jDgvGCIXN4UVmimVGpNJIi2W9Ai7/ttypQrhyDx
         sTRGCI+mD/hvvZD271u+fFt70I1OPNoRASOW/Lh9s1ckvfykbHuEJaxtk/0fovvtYwGe
         +x9A==
X-Gm-Message-State: AOJu0YyEUdNCRI50Vwme49dncz4YMhRR7ztPp4aMymDO9XBEJP2+1p+o
	TGGqE1AZTkbdplvmpfn0wTuinHRQkuhq/cMKn5++W0g4JPhOsLgThjFBU09xTA==
X-Gm-Gg: ASbGnctpT6db0w0Jj3A0WaL/mc3vYA3xnI4jZLteo0dcoRimvbJF+Bj0Y1elKF9Gxbe
	NLmOr0t/78cjnSGpW7HzRZg47UXfSd4PF/LurX0UbR6OsmHXEPHH7s3u/zDqHzIK2k0HaK7fpdl
	OD35PJ7FiFMsmFz7w3hMAMMm8+uYgcfzRiPPbAlfSewFyv/MtTp8piDEe1pvRYL4w9S3vIyLqqL
	Ufgn6LzGMxiSz9/41YxSu8Ihm1M3/aLml5YhneOsN370jq45aUt6hf8Nq2KOx/qAciw6FApidPT
	+CWAtVM1pK8ip8KIZ0pDFbzh6vcvQw1Vxch+aBLcHnfF/Zo4dwRtLbEMo3NeBeK9mkk1IQt8oLg
	tIUWYFPZo8W+56mk+cihMA3wMIRV3uou/7g==
X-Google-Smtp-Source: AGHT+IEI6I2Ch27KIHx7rue7mtAXNkIvBUrcrNNPpGcyDYBvbhGNyE2n2O4SQBbgRfem9JRoLD9FtA==
X-Received: by 2002:a05:6a00:1706:b0:77e:76df:2705 with SMTP id d2e1a72fcca58-77f54866800mr1124514b3a.7.1758601322099;
        Mon, 22 Sep 2025 21:22:02 -0700 (PDT)
Received: from VM-16-24-fedora.. ([43.153.32.141])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77d8c3adfd4sm13316513b3a.82.2025.09.22.21.22.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Sep 2025 21:22:01 -0700 (PDT)
From: alexjlzheng@gmail.com
X-Google-Original-From: alexjlzheng@tencent.com
To: brauner@kernel.org,
	djwong@kernel.org,
	hch@infradead.org,
	kernel@pankajraghav.com
Cc: linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yi.zhang@huawei.com,
	Jinliang Zheng <alexjlzheng@tencent.com>
Subject: [PATCH v5 0/4] allow partial folio write with iomap_folio_state
Date: Tue, 23 Sep 2025 12:21:54 +0800
Message-ID: <20250923042158.1196568-1-alexjlzheng@tencent.com>
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

V5: patch[1]: use WARN_ON_ONCE() instead of WARN_ON(), suggested by Pankaj Raghav (Samsung)

V4: https://lore.kernel.org/linux-fsdevel/eyyshgzsxupyen6ms3izkh45ydh3ekxycpk5p4dbets6mpyhch@q4db2ayr4g3r/
    patch[4]: better documentation in code, and add motivation to the cover letter

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

