Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A54242D64
	for <linux-xfs@vger.kernel.org>; Wed, 23 Apr 2025 16:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745424954; cv=none; b=UqQgFKOlWioTt1/Ja0rz/mEnCYP2tr5pGHSvUpImbfcZmFrRO4nPo9TAxHQm2mTNMDB7/UPYWfX8ljfaAu4kbh1uFZuTN4tspEqOZy/JFnxDGmfp2MmzcpqVxse+FTAf2yh+A/IWUAl9yUoWMzoZ9pRebpENVXHzcLBYKVn0lIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745424954; c=relaxed/simple;
	bh=smFj1YeEGhf7Xt80Ow6NFyKiK1AWmH8oDQdvNNVmxiE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cGrScMLA+daDfhp6laQtCICFnFvwQw4a/zFrB4CAJUHROddarGNlM5xwKe15ke6LtQcYLgsCbh7iZgdQGv7GVCX9s/F79mwwILlwg+eYoq01Nuki2RKJXid9yjG206UUAD9uSqZDLsT2/R8FxzRaA0gZjDygguko6FZrhvKyvVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kCQNSGi7; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kCQNSGi7"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-43ce70f9afbso206935e9.0
        for <linux-xfs@vger.kernel.org>; Wed, 23 Apr 2025 09:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745424951; x=1746029751; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lkjRHFBLJ3Uj6+H/rNOOJNppMoLk/63ENUBT/kITDo4=;
        b=kCQNSGi7EEPxISn15QOxRlvVQd8LdTx96ZdiEHnPsTqFb6rSyeN0vffd0gg7HhMIbB
         UxoZZaOPiLUHRXuhSZIYxnvQQSxDVP69zpqaSJJjgKG5vtEAQA5rrKOS9DYDiJ2Qnp23
         JdJ+dxcl0LjLiw1MHnjauclZnPF1dzWVQxLdKNlvRnSZxrdkOZ7rUGTCUljqoW9ZBdVa
         4jnyIzFo6cG3qOHvN84SNzysxqisaZ+IumzSliIHRwcdNG86OlIrnqZGAS9OMGnLKn8I
         /j55w61tWXl71LmN1/zB2KtmHws0Hph4YLOzynER6ETeiUnmxnxWii343E+0ubwthZ+5
         78dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745424951; x=1746029751;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lkjRHFBLJ3Uj6+H/rNOOJNppMoLk/63ENUBT/kITDo4=;
        b=TAC3xF6/u56KtA7HBHziX/gvgvIoV7EVh7LE/sOTpdk3db3sqzymSyCYs9Y6TYPkV+
         rb+lOgyyoJ1Czf10mj6qr0qOQzwLkZMCDSyC9UjBPPSiwofl9H2jA5+Yxq87h1x70Ms2
         cyp6CwTlD2FrQ4SVFiLAxNrX08tt31fsUjDixmDnnCWuqtPDj580EyUXZOvKedRzpD+h
         Zj7Xe6kEBMKzyNH/2cPeol4owqhFFOHUlxPTboMXJXho6YCIViFZwjWbxcCJW3ZA9Ld0
         yW/cATeNxoPmQH5PnfBod869wheMVE5Dv0oQLma9taC0e0XkQEd9cwI4yzZ18uYMLeBX
         vW8w==
X-Gm-Message-State: AOJu0YwCbIbQ8qfeevUoJX5/FZr0zzlwFO/GsbxPhsLdH7p5b6cPFvIJ
	216RrLlLa4K6oY+YDCkU5mRMGWmdKMpuHeMiSJGkvJu56bIIaBjoysurng==
X-Gm-Gg: ASbGncs2mY03OXNCYdES4joB4/aZCXyy9h3BuXwQyFXR61vDCDXgCMOODJ6zGuytWG/
	aGhuxGSfk99mXtZ6AYX/j7VlxmMgGIVh7uJkP6e2ANi1zT95w2VjMCQ0eH7PlRK3OpQK1fdGAU/
	JUimHtLxPqEu7Wd2WIPnP6j65zD2VFo0WhPl6GRJsgm6nedVCnrn04TuI7KQ5G45k2W048DKGh2
	yuF0o5DiCf3lZagWaGOX/1cFfuTMg9Vh61FsNCvGEAQPZcn9Tc0tcwuKMM9mLPY2A+isCGeLGWo
	G9bzYBxKF9KmaY3GaX/E
X-Google-Smtp-Source: AGHT+IH3JaPa3zEDQNg7QD2OCTKk+7F7xTb7NwM8T6/k4vTblUqAZn7Li1GOFLHQbaYh1QoMfyzeSw==
X-Received: by 2002:a05:600c:511e:b0:43d:ac5:11e8 with SMTP id 5b1f17b1804b1-4406abfad78mr122967225e9.21.1745424951279;
        Wed, 23 Apr 2025 09:15:51 -0700 (PDT)
Received: from localhost.localdomain ([78.209.93.220])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39efa421c79sm19083567f8f.1.2025.04.23.09.15.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Apr 2025 09:15:50 -0700 (PDT)
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Luca Di Maio <luca.dimaio1@gmail.com>,
	dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev,
	djwong@kernel.org,
	hch@infradead.org
Subject: [PATCH v6 0/4] mkfs: add ability to populate filesystem from directory
Date: Wed, 23 Apr 2025 18:03:15 +0200
Message-ID: <20250423160319.810025-1-luca.dimaio1@gmail.com>
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
[v5] -> [v6]
  rebase on 6.14

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
