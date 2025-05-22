Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A52C2522BB
	for <linux-xfs@vger.kernel.org>; Thu, 22 May 2025 21:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747948226; cv=none; b=VrdIFcZSA7WHfr9vqPIegM8KYGZPXeWuKz4f/ggzn20Ns8M04OOSmj+Ffq56X5+2SDU+z1br+lTsyg9IkfqZlyx8K3+EOMj9EtZLNi8hXMuBPWcEPoBHAG1ZEqR319JxuHeImoMuPJFWWH1djuyDTtrA7svCwTV5ZibO3pWQKnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747948226; c=relaxed/simple;
	bh=logTJecJVCAFfSzXENHorMUG84tYSub9GJZhWoehM1c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Mz/x4mowLHG83bnX7kluWodqbTXriG0KQubZCoDQnP9lNdi8vDJzZWa7RbgJQDbxMvmKoSWRnlzdXwFVFVltU/m6OtVUUqIq/xZfPfpyoX29DETdoBjTHsuZssGmtN79Oy1LsKUdfxT4Iea3q6oVO2lcR4uoOnrKwGKou7hA5a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NwDwceYL; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NwDwceYL"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-47692b9d059so116498411cf.3
        for <linux-xfs@vger.kernel.org>; Thu, 22 May 2025 14:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747948224; x=1748553024; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wZe9MrUN1m74VpkJU7a652+/JG5Hy0nXiX+xRa7+OFs=;
        b=NwDwceYLGg55fFJMlTewsUMPqmh/EqlhD/2Wxdus+SsvugnXHswk8eY5H2IuVsu3H6
         QaSExOI41Z7R8kpODrgx8EG6OC7hJb+EsWZBn2Yk88/ef4pJgYQnB564BmXHebzCTij9
         LBDECNJIzQv5AtgtSurcrKiSrIqQ/xdKdUD4VWdZitRIbgSm+eTZ5svMOUW59rjE12ME
         58EfgBOWm2fYo3tLERzYppYQXbhi6NEmh5kDuyarulTVxOR9nx6+l4/ZG4yfqPpRxt+U
         tcI023STW6HhHR0r6J6G7znlAedxbEJKHv9luxedJ25caslfvbmbhyOimqiRDYfOkMUR
         iU2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747948224; x=1748553024;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wZe9MrUN1m74VpkJU7a652+/JG5Hy0nXiX+xRa7+OFs=;
        b=ipXnx9jMs9If3kkESM49VA7lKzj5AqencZ63jnScL2xak5GWDyaghkBVqo4KhnMKE/
         4LGrgSKYgML7bu+qJ3sTtWToAZuVYI4tiBByTckUm89ZMDTNj1RsYzgRoCW7gZkRXVut
         DkAg4VvsKF3YIhOa/S23Qa57ZHKcWOj9m6b1x0IuGNt806/YBAZZ66RMV6mB45eSghR4
         3bndams6whvbv4BHPusP02sOptvPM/PW5iw0kdAMIeD5EhU1sKh5ivZrs77y8HEAME/y
         DMLXDDr3YlxcrquSTvTp/PZl2bP4ZwwTehjwafrADFbOM6oFlL9Os0/OjNVQL6bSDnhs
         /y9A==
X-Gm-Message-State: AOJu0YwKfqSgOpvaMbokS1ZKW8ln4pFuAMWpSv8afJeDDvAfOie3MF+i
	wcUnfUieF4C9APLlu1cGNmvlRQFWE4hVHTA9Zie/BsAyQQRWAXZUKOWE2Ii3hFY1
X-Gm-Gg: ASbGncuRQr85q00AIKIabDEGaGj0q68zkONchX/2kPhkf7QgkMAGCgJ8UDyL/pE/m0B
	D4nObXkTiFbhnjn2Mtu2X98b58zIc1Gs+gLfe4Sf26ohgf/vtoTKIAzbb+l8v1EZ+I1TUE4Ty6u
	lIordOXAz4qJSLfQzIAkC3Z2KWYVnk4j7DGJtRnzANyS+vQ4XGpCYpD31dnq2D62uTLKhv8q3Uj
	rS3LU4vxhnGE5egKX/e7pX5L6o3wgiyoG9rR7Fd+KZ2Nmyl0VM+m0X5fPI9YDY1S2ea7CoOsUFd
	GTBbBirbVKcofwbIb5E=
X-Google-Smtp-Source: AGHT+IE2J1uPldH/5yujRWN/opXHJvPXwdvcsZJSB7bXyVguNQSQ1Ub8YmkXyGJotDXaxrSo89mfAQ==
X-Received: by 2002:a05:622a:1f8b:b0:472:6aa:d6be with SMTP id d75a77b69052e-494b079b8b3mr374042161cf.17.1747948223939;
        Thu, 22 May 2025 14:10:23 -0700 (PDT)
Received: from framework13.. ([12.44.18.162])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6f8b096585dsm103839906d6.83.2025.05.22.14.10.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 May 2025 14:10:23 -0700 (PDT)
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Luca Di Maio <luca.dimaio1@gmail.com>,
	dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev,
	djwong@kernel.org,
	hch@infradead.org
Subject: [PATCH v10 0/1] mkfs: add ability to populate filesystem from directory
Date: Thu, 22 May 2025 17:10:02 -0400
Message-ID: <20250522211003.85919-1-luca.dimaio1@gmail.com>
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
[v9] -> [v10]
  fix indentation, alignment and style
  improve comments
  avoid unneeded casts from ino_t to xfs_ino_t for source inodes
  avoid global hardlink_tracker as pointer
  avoid mixing code and declarations
  symlink target string now respects XFS_SYMLINK_MAXLEN
  set root directory ownership/mode/attrs/fsxattrs from source dir

Luca Di Maio (1):
  proto: add ability to populate a filesystem from a directory

 man/man8/mkfs.xfs.8.in |  41 ++-
 mkfs/proto.c           | 765 ++++++++++++++++++++++++++++++++++++++++-
 mkfs/proto.h           |  18 +-
 mkfs/xfs_mkfs.c        |  23 +-
 4 files changed, 821 insertions(+), 26 deletions(-)

--
2.49.0
