Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2EF019F13F
	for <linux-xfs@vger.kernel.org>; Wed, 23 Apr 2025 10:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745405160; cv=none; b=e+uueVuDRLjfat9Oqhwiqzz4IIDN+MeIJbfOBGlaOLAGbhf6hsoZ7kgBl1+znkZwaEEqqI06MTuawJlwBoghQGmxdofe0EjTnoroBjJo1WojWal0A2wgS0XdJrTLlwr7a0TfE4vDZoESdRWlRdWAXs5rC2iGmqnVIBmWJHUE0cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745405160; c=relaxed/simple;
	bh=Q1TduWJoFPfBteAMat6knj9/FCcfikuwnJL/moFPQr8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kU+j+IEH9Wgd48tvzwAk8S3TiqruKWCH2Ujm2bwdEQ3RdMyhqCn6hUQ06o4ejlUwNVEO6Algu/1d+aUEH4JWUn/W+MPOzTkK8bVgo1G1hA21j1t1+lsmghJHh9qI8G0cmxOpC/VuD7bcpsT6O3u6LQsO7JE2aobkoUbxQl08Av4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l+jGN3aH; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l+jGN3aH"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-39c0e0bc733so4940152f8f.1
        for <linux-xfs@vger.kernel.org>; Wed, 23 Apr 2025 03:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745405157; x=1746009957; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kIJZ7lR96JHD/FKt8H16vSykTdwhlr6zIX3cXsh7Wnc=;
        b=l+jGN3aH4sW8gHUGfZLWIr+bNXnaI18/gmmaoc5d2Lx41wMYDUbzrCsxWxa3Zu0M6b
         LvMGSlmdGwb4FEqxb4m47NBOcDRVj3HjVH7cdT9ZQDVc2lPjCqkJCtXs5Vj90VVz0gqs
         OWZjrZy2utgiVzKONSaKS9n6MXwuVXrGK550YUteDWQ6+9burtlXXg5zZnYIoibOY34T
         nNnm1fsRunmOVuHvpEhru0MEVSpVDQWy/pRnf9+0ufhlXYuKyMGtRoDGusXGDB2hnebb
         y33VJU1LH0uNrhub8gswepYuLQghLnRQNCybwDLywobF4sUs4nL7dzuG5fKlbu1PAmr8
         R0Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745405157; x=1746009957;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kIJZ7lR96JHD/FKt8H16vSykTdwhlr6zIX3cXsh7Wnc=;
        b=hhbZ9DXMN2DbrXBqlKbrTt6VzbNcblUch3v3Cqc5i5nvbWIWf/9QGttDSNRlaFyfXs
         6HCjwMq1KR9G+6/ZSkRA0f+mHKlVl0w5V8e3a+uCoZk0x4Z1+iI/zgzhHsDBiptnQ34d
         0zNlVtgiy1s7f1YENaYhH+BPefopfwIql/gyRcarcdM2lm6YTr3LiaylI4cVPimy/yye
         HKWmL5BEhQfJFgJuzTANBpTDZ4T0WeITlAOvbCUSv+kguNVIdM3U4xru1XDz9tQggaEg
         C7M6BY5JK+VzbZ6G5BbNYgatfnWRP5Mv+Aewv+vWRn5fFO4nvJ2QdMskxTZriRzc7qYy
         PD2Q==
X-Gm-Message-State: AOJu0YzRwHXcIcQY3Pmawppb7BjHNPT2p/T9smwR6LD7FiU8O4EvlIwq
	oypoDByr9ha+EjL0XEKDU6NwGb7xqBUCrqsozBv+Z5sXbIflAWDsuGGodw==
X-Gm-Gg: ASbGncvIWnElwiBc58LLF+NqISjL0Fz2MbV60CbU/MaUosGvMF9dojdZBpAT1reScGU
	Azw4h79jeu8AEFe1ccZwz5Go1yvuV3FlRBktr2M35XxtoeYvWk7aQaHi44YzWWsZz3Yce/w5FZB
	MSI9VnDLbx9HAky1gjzY+pUvCr/V2SyyEXchlUz28N2B+leRCfU0PSFRb+F5YEOC5BcqQ0Qbn+1
	Y5otLx5zNOMTHGffsEJ832qru4bj1/8MpfDSi7kMS92D4XyUUyoS0CMh4AS8sxSNeZTpxaz+1yD
	YBd2W9ZGtCyvuiridmw=
X-Google-Smtp-Source: AGHT+IF+Ra8I/BvKOgOEXuw8ozBBghIGyJO7XK8i7zCqNGHs/dRnYaPTe0HkPX/xLxVMsXvqqAFePw==
X-Received: by 2002:a5d:584e:0:b0:390:de33:b0ef with SMTP id ffacd0b85a97d-39efba6aa99mr15598743f8f.30.1745405156828;
        Wed, 23 Apr 2025 03:45:56 -0700 (PDT)
Received: from localhost.localdomain ([78.209.88.10])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39efa43ca78sm18214925f8f.47.2025.04.23.03.45.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Apr 2025 03:45:56 -0700 (PDT)
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Luca Di Maio <luca.dimaio1@gmail.com>,
	dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev,
	djwong@kernel.org,
	hch@infradead.org
Subject: [PATCH v5 0/4] mkfs: add ability to populate filesystem from directory
Date: Wed, 23 Apr 2025 12:45:31 +0200
Message-ID: <20250423104535.628057-1-luca.dimaio1@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently the only way to pre populate an XFS partition is via the
prototype file. While it works it has some limitations like:
  - not allowed spaces in file names
  - not preserving timestamps of original inodes

This series adds a new -P option to mkfs.xfs that allows users to
populate a newly created filesystem directly from an existing directory.
While similar to the prototype functionality, this doesn't require
writing a prototype file.
The implementation preserves file and directory attributes (ownership,
permissions, timestamps) from the source directory when copying content
to the new filesystem.

[v1] -> [v2]
  remove changes to protofile spec
  ensure backward compatibility
[v2] -> [v3]
  use inode_set_[acm]time() as suggested
  avoid copying atime and ctime
  they are often problematic for reproducibility, and
  mtime is the important information to preserve anyway
[v3] -> [v4]
  rewrite functionality to populate directly from an input directory
  this is similar to mkfs.ext4 option.
[v4] -> [v5]
  reorder patch to make it easier to review
  reflow to keep code below 80 chars
  use _() macro in prints
  add SPDX headers to new files
  fix comment styling
  move from typedef to structs
  move direntry handling to own function

Luca Di Maio (4):
  proto: expose more functions from proto
  populate: add ability to populate a filesystem from a directory
  mkfs: add -P flag to populate a filesystem from a directory
  man: document -P flag to populate a filesystem from a directory

 man/man8/mkfs.xfs.8.in |   7 +
 mkfs/Makefile          |   2 +-
 mkfs/populate.c        | 313 +++++++++++++++++++++++++++++++++++++++++
 mkfs/populate.h        |  10 ++
 mkfs/proto.c           |  33 ++---
 mkfs/proto.h           |  22 +++
 mkfs/xfs_mkfs.c        |  23 ++-
 7 files changed, 385 insertions(+), 25 deletions(-)
 create mode 100644 mkfs/populate.c
 create mode 100644 mkfs/populate.h

Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>

--
2.49.0
