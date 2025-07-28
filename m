Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6386B272815
	for <linux-xfs@vger.kernel.org>; Mon, 28 Jul 2025 15:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753716628; cv=none; b=QeaxQrMoT+x49BOIih8apQ85dCfT5tV3n6ooMRR5SJnc66W0GMJ+bEryKHhta780FBbWTrBwst8Q81rIWcky4ERsRlbH+/43Faq1qt5F8y3IAf7A7f5qLANHMDify/6zjtmzCo7IVhEvT+nWASWsDCwdeN8UGjyuPENGaDRGLro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753716628; c=relaxed/simple;
	bh=/G0rS8wc1ixz7YNSDQmQAD9Yc6t2xuhS6hvFUkAsHvg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Dzrr+ly3yxezYqVH1dTAsWZT85U/AiqJb9I/+Pa/uYxPZzd7kvDUKSLYH69ipD+bdan9x7TwT2mRe9Rl7b+HmKVK4+2yqBSO/OKJinTAiBrKbxgwovn5RD3hbbRXbg3dvyi/gruiNXFZl8HvYTfAh84eKEM44y5lRYZ70yt5/uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=igAHgPy9; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="igAHgPy9"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-45600581226so46767595e9.1
        for <linux-xfs@vger.kernel.org>; Mon, 28 Jul 2025 08:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753716625; x=1754321425; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Dzo1qlXKNa65xCUhuqr2S2+c+zullLfLMtzvuMXQJMI=;
        b=igAHgPy9ZghEd0GdqlZKaN6l2MZCq4kKRiU0ZZo16iiWWSfXPhpPeyEY/gzm1VkWlF
         7fbq3vk9eX3Vg95zauidTzzoaK8tRz1DmJBN6qlT4/dT6UIKbgGbAKfbHqI2qQANM/H4
         cioas/7cSqz6g1TIIR7KijIuuRbc+BENqNu9NGPUlEUfPvH2uq2leZf2BY1RVd3UeKDo
         8tiDsudeJV0J84YDBpy5uOu5lFiPRH17eHEFsym6d4vKQ3QjgqGcZEqtLqAcrV074Fta
         ziyixU0MQ/MD87tHnBW72FzvYU92QnAnZeOIMuj4KQyDMawWoDnySwyWZk4XF835K7RV
         OkVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753716625; x=1754321425;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Dzo1qlXKNa65xCUhuqr2S2+c+zullLfLMtzvuMXQJMI=;
        b=KW9XHmEi6tHWAeFOr00xd/hxZgnze1LLBPrLj4RlBrDSGLcGlMEJiQUp7Az6ZiwL7E
         eSa622FI8DVvEavXaM/piomf8e1c80KCzmL++zsGVgv/pNlZdOPgEVO53lbgoknGByrl
         bYoQNiprpJE7YhkrTqUNy9vvfYxualel22HweN6Dh8Ii50DWbg0f0kwn90sNCrGmbmv3
         aS5tPZoIzb+aSnTyGh1vCNVNJeL/+KGWkbqMMayKG6fCbEeOk1c1pByM4+CX2m9JO8qG
         SqC1CyGPGc4yjbRZCtS5HE+rqk99G5mNXZwI1PGsv2KLI64KA+mQDC+07F9kAWN8rBLM
         MrCw==
X-Gm-Message-State: AOJu0YyAaAWosuGeR0Lyeuy3wuYu+AvfiFrWJfrP6zueE6kihNUsbkH9
	/BT0g2NBrvPpZ+hH6SbFnHpd7vqRNDWMQiCFItAqrJsXq0Mtven7eNl35Dn9ZrPr
X-Gm-Gg: ASbGnctHLTMNoL8yf9QBofTImmHjgV5WXNjN6FBawoWMW9aw0/FY6PZigKqpsIn2451
	WE8m6VPZ9MOmoJnqqUhB2qI/yyNm88tJ82mbnpZGmy117/s2jOAZbtPi8Z+fYzDwtBeD3+lvM2W
	OwDs0Qw0jmdfqcJAqUTEZ9k8cauHwisl164Y4TthqKHdl9onrk0n3smM0kU59ZRXVTpQlOz6p1K
	oUI6WKvzto7CFpCqPBTeZ6f/+D2teV095+OWGksLe2jY+r7Xm0A6MYPd0EwRR+zkAH3/exk6Ei3
	eI/tNU+kdumLuj8fTQvscBZ7Tk6yfAjoYt1GoH9SZ5YUPbEvoRmJXiWoWz7VpWjG06wrcB0lNYT
	61zK2/I0R0xD4b5CX49aybQMrvlo8GF9sis7eXonyU95xGqwqIFC+6Lp1LUqmHqLrsYJIl5MvzU
	0l
X-Google-Smtp-Source: AGHT+IEKR/2Q+VYhEbTVAI8e/vks4xWFq5Wvi1f2IIC5No7uiyw14xMvSHaI63qcsgE2mYVtG2HFqQ==
X-Received: by 2002:a05:600c:4f09:b0:456:1dd2:4e47 with SMTP id 5b1f17b1804b1-458763242famr110740045e9.15.1753716624282;
        Mon, 28 Jul 2025 08:30:24 -0700 (PDT)
Received: from framework13.tail696c1.ts.net (na-19-90-8.service.infuturo.it. [151.19.90.8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b788f5f27esm3241427f8f.14.2025.07.28.08.30.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 08:30:23 -0700 (PDT)
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Luca Di Maio <luca.dimaio1@gmail.com>,
	dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev,
	djwong@kernel.org,
	hch@infradead.org
Subject: [PATCH v11 0/1] mkfs: add ability to populate filesystem from directory
Date: Mon, 28 Jul 2025 17:29:19 +0200
Message-ID: <20250728152919.654513-2-luca.dimaio1@gmail.com>
X-Mailer: git-send-email 2.50.0
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
[v9] -> [v10]
  fix indentation, alignment and style
  improve comments
  avoid unneeded casts from ino_t to xfs_ino_t for source inodes
  avoid global hardlink_tracker as pointer
  avoid mixing code and declarations
  symlink target string now respects XFS_SYMLINK_MAXLEN
  set root directory ownership/mode/attrs/fsxattrs from source dir
[v10] -> [v11]
  fix indentation and comment style
  avoid TOCTOU races by first opening file, then using fstat on it
  use openat() to avoid string manipulation
  properly cleanup hardlink tracker
  cleanup the henalde_direntry() switch statement
  unify all file types except directories in a single create_inode()
  function
  create a separate create_directory_inode() function

Luca Di Maio (1):
  proto: add ability to populate a filesystem from a directory

 man/man8/mkfs.xfs.8.in |  41 ++-
 mkfs/proto.c           | 748 ++++++++++++++++++++++++++++++++++++++++-
 mkfs/proto.h           |  18 +-
 mkfs/xfs_mkfs.c        |  23 +-
 4 files changed, 804 insertions(+), 26 deletions(-)

--
2.50.0
