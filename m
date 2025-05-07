Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE9B28C5A0
	for <linux-xfs@vger.kernel.org>; Wed,  7 May 2025 16:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746636569; cv=none; b=R6fYpuz8vKuUssAd0wfX/x06Wr0HDvIN7xEjOM9L9YZJeBMtNMYcHEoYH+A8CeLnYD1tYU1zcrpAw3xbhymUgqywRUvi82ysqlykDGmpwftoWzvT+G1mDIS9bSp6sal1W5NA9JYtrKmJ7+58cURE5dl3PAjObD8HjxtQtDa37gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746636569; c=relaxed/simple;
	bh=Ymaav5hQoYIFsLQW2O0r1Ka3NLJqmnE9QoiCkYzCaKU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CBp/l0UGfDm5vmL6JcaZSVCzk4R7tJzTKETTqV2Mai4bqF0/TSAnJBKSB3i0oa9wTXHqGFlJRB1xj+Gba/qNg2AwwOhB/2s0u+4IJbsB3k9xHmH/TNVNdPa0M5wcZCMSwn0JPlCBDpAAdtAXOv/FO2byWGBRthj6Zku9g2NNzCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=girkmNPl; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="girkmNPl"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5fbe7a65609so55820a12.0
        for <linux-xfs@vger.kernel.org>; Wed, 07 May 2025 09:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746636566; x=1747241366; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9Uy2s4WeFkaEBhpCF6orDyJYSz3OrP2LZEHuV7+83mc=;
        b=girkmNPl9MneK3k0itrdBY2JDGSzA8K9kiVlGtEhDNlPN7QF1hCIxEVx5JfNO4Ca5U
         9fx7pBum8kQbrHVZxSj7rt0oEBw9d0EnmtycIQp4T4nYNxDhvLfWECLvWngfx1xO8hVZ
         95TEbphKDweikEtoiPbuLXx6u+ESwV/LJN9gUaUkp5v90Q8yjoAlx3KDd88XZV5z93Oi
         NJ78ORjXfxptiJsvzcpEP04U5papjuYKqKutreAZ/TneCYtTE1AaxXNk82jIbw1LLwTM
         pJJP5TH94v1uMZxg6/ZTVSp7Qq7US0v0jJuc3JRhvosEqz6MpO6TPydoh5KonBGecMyd
         JzEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746636566; x=1747241366;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9Uy2s4WeFkaEBhpCF6orDyJYSz3OrP2LZEHuV7+83mc=;
        b=sq6HLOKgvFiQO9+uN9ptpLlyBHHxqy1AaTd7KYsT+qiP5dHOa6KsqSQzIR0D4n//zh
         L/tvjnKNabewB6VDibKxNhIaS0Kfaw2igEe1H+gTGj7p5/OmQRnFM4BE8tnDH/jeh1AG
         hmNUpYLc1vmVh0cGSsboRCrhnMON4uQcEDPk0jHb0LtIorgNQQJ1yacpYhQEJkNoO61J
         0pnCIwTEUoNJhidHKzPWigPrEE+2sk2FTVGv0d2jhTui79NS05EUv87BmvS5BrZJ+h9h
         pbqzSyz9n+ph0S0itvbv4/dhVIvL3BNpiwvssAEF4uljJSACVB8Zpkz3yQCCWWYm3z55
         ZJ3w==
X-Gm-Message-State: AOJu0YyC7MqBzmTD857KOecurpxExbfb8YcJU6qE5xL1/PUyaMgSwkPc
	bvW0qQ5m1yiMHQpKSLCnuCVOjKhO6uz+bBXt3RWXwzrL4H1TkDRWykXlGOmF
X-Gm-Gg: ASbGncv7xvQ1mePB73DSK/cZMEhb6TQ07KtqkjD+tdeqOMUKS8NaGoaFIDMWaNeaFrP
	WzNr4juvIvifF1bINims7aVK8TVMkiXbNfgGo2cBL9SKVfm3hPl/NXpAW4y2k7Bga9KIat0zJM2
	06kqO3QKTUnHWaXUUYpHttztzo/K+AKZCYIQEZJwzvJukBoO24cOEJCrMddLQrCuzILrNsfYSBE
	WuGWGbiKnC8Ytzdmihy/LBWhdIleDlyHk+Z15FZEED9TKxMLCJ55lmRe8xjTMIir34WTIshui3z
	zL/PgTOGZUstP/7UtobY51H5z6IoHoGipHQ=
X-Google-Smtp-Source: AGHT+IHM+hmWDwEtwnrdyvVtRdObGcw+Ydy0uNTUl8+bQ95W+3eeZhl/q23ywe0bashA/16G9VAwyQ==
X-Received: by 2002:a05:6402:13ce:b0:5f6:c4ed:e24e with SMTP id 4fb4d7f45d1cf-5fbe9f3c567mr3937678a12.27.1746636565955;
        Wed, 07 May 2025 09:49:25 -0700 (PDT)
Received: from framework13.. ([2a01:e11:3:1ff0:a297:5d4:e836:bbde])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5fa777c8c56sm9733021a12.31.2025.05.07.09.49.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 09:49:25 -0700 (PDT)
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Luca Di Maio <luca.dimaio1@gmail.com>,
	dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev,
	djwong@kernel.org,
	hch@infradead.org
Subject: [PATCH v9 0/1] mkfs: add ability to populate filesystem from directory
Date: Wed,  7 May 2025 18:48:51 +0200
Message-ID: <20250507164852.379200-1-luca.dimaio1@gmail.com>
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
[v6] -> [v7]
  move functionality to common -p flag
  add noatime flag to skip atime copy and set to current time
  set ctime/crtime to current time
  preserve hardlinks
  preserve extended attributes for all file/dir types
  add fsxattr to copied files/dirs
[v7] -> [v8]
  changed directory source validation to use stat() instead of open()
  changed hardlink tracker to store inode numbers instead of inode pointers
  fixed path buffer handling for directory traversal
  handle blocking FIFOs filetypes
  handle hardlinks of symlinks
  improve setup_proto and parse proto using structured xfs_proto_source type
  renamed noatime to preserve_atime with inverted logic
  specify EBADF fgetxattr() and flistxattr() fallback for O_PATH fds
  switch to calloc() to initialize hardlinks_tracker
  switch to reallocarray() for hardlinks_tracker resize
[v8] -> [v9]
  squash commits in one
  clarify the linear search implications in the commit log
  fixed indentation and styling
  fail early for invalid inputs
  pass dir fd along to reduce amount of open()
  switch from ino_t to xfs_ino_t
  add support for socket files
  copy fsxattr also for cases where we don't have an fd

Luca Di Maio (1):
  proto: add ability to populate a filesystem from a directory

 man/man8/mkfs.xfs.8.in |  41 ++-
 mkfs/proto.c           | 750 ++++++++++++++++++++++++++++++++++++++++-
 mkfs/proto.h           |  18 +-
 mkfs/xfs_mkfs.c        |  23 +-
 4 files changed, 806 insertions(+), 26 deletions(-)

--
2.49.0
