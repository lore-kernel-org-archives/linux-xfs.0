Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6787E2DECB3
	for <linux-xfs@vger.kernel.org>; Wed, 30 Jul 2025 16:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753891963; cv=none; b=RSw7LsbeNGYk5K9eH41ozcBY7pFti4Ot4QZZi7pa6lNLU9tfvzlNUtNzXUcwmK1PKJOYpaUXgLJ0wu4j6cL/0+iCcw62J5p0+AcmIX3sdxMN+uDFvAI73oXFbdL61gFEwbbAoJly6FdhyvVYEcGfpc6hSvcaTZl6tprfcus3fdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753891963; c=relaxed/simple;
	bh=owQ/VSrvMcfooluLEjjzarYhsJY+M6LcXKYnkQb3dnY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=H70Q6qaQ8qq4ahy5lwlhYHcMlyhL21DcU/A6/Q0cONZDaK2q6AS9NUeJEW73irQFFGrsDxjegGFid3x16XHBpZiIFfqkEpg9fj/btKtYae49SPAa6yoVR2+Ph2I4pS4/2GZc4Ck4T1xwjR7xi1hSSIUJMD5sMWuCNn5Zyk8mWfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dADXnf+t; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dADXnf+t"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4561ed868b5so45708525e9.0
        for <linux-xfs@vger.kernel.org>; Wed, 30 Jul 2025 09:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753891959; x=1754496759; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KZMhARLpDj8x+ENnZVYlBd6RZyhMwUFZq86GIBLZxX4=;
        b=dADXnf+t4mNiVO6lxgH+uOCl9s2x3EFu3uXDjuuso/0+4CJwrl7/B64CFAVrFxmHWA
         eJYeRPhPkca/QKPDovLNzMnAoIEMNEVoh4v1uSZU5n3GbcdvY3nDnONtjIzncEP6g5M2
         N/MtLqKYogLmnG54gagyaN43IxO7tOhVSNOlJa+EY/Fong1DOd60ZcesPr8fKIJLDkge
         gx1lU1SlKv8bpo2AcXeVLe35bxafeYR4hyaffmpkZ1IKqKd67tEQJYNpLtpR35q/Aek2
         PHw3xvi8H9QP7JBBNjljr4uQ2JheoWXCna2nrM4Y/asQm5Iti4Op6KqkbkVXlF4jzKu4
         eyOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753891959; x=1754496759;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KZMhARLpDj8x+ENnZVYlBd6RZyhMwUFZq86GIBLZxX4=;
        b=Ct+RSPE5Mss4GYvdudhRJPm/nhifyH0kjVEocCL3Uhq38rC6vkNS9R4D27aaFfrP/s
         sV4tnAzsV4Rq5cMiE/xtj4vHv4nf8Rf64o5TOR3JrKrdcPQ4CCg9kgIpfb13vg3J8mjU
         gRo+P8w1s+VZ2oJOl8xhNIKNDoD2yXn55j8Iad9yDhV9KXD3yCMteDnB3QGY3K31QUEB
         SGWznPFn7328UgeCfTHUAY2zdZ+OiRJ/PoD6PXQDSV0KHsEVDnZVRul5BmJp27mZscQ7
         mDS9B97veiRHpua55bZP8ectPaFEwiTj3TvhetHTeWIYMun4RRpUJqZwvhBCwBRGCIU1
         CCDg==
X-Gm-Message-State: AOJu0YxyhuH90cVSYzzsMnpORySAnzL2g31846NUbteBPQJeOJuCxFqk
	6uupLKnRaN3koXCZY9lp0NUeJmaVVoVTcQqpWOHS5/bp9wZSrnaAeOZgtzjipbfA
X-Gm-Gg: ASbGncvcVjdsmlMmGfx71BtboeSgFdzoXBekkDwrDtSyXsk0xiV42BQiyClUkY1/oOp
	VdUWOPK8B6NgbuvnUvij/RlSXpuoLuCPvQsBZWop0MhSxqYXmyZloSzYTvPPxO5jjp6rVX6OEYI
	S+M0sDrvmbEpHpwdDo+Ie1/IKCgm+DUxkowZuZKzi5cEnDTxaFzZzmG+PNBtHd6s5DCBsH6RDYD
	HnoXrysjl+9VXy7DO4515JivbaG8w2tGI4jjTOUDg4/dxsqGtOSoZ53BKJxDT2Ahb1nCZDuXP3Q
	lRZ5zWYJdooap/Gr1iZg3TGoYPz9a1CR8qwrL+3k9C+aP5R6AMspfm9+HD+ZWcJrZPcrhbD1I1T
	TnZaMLjgBIIqrEnktvxXPIqdq1NnYRd94/N8CxnueMixrbXPPXyydT5jzw97y+Vn52vrOj5wleC
	o7MyP9ww==
X-Google-Smtp-Source: AGHT+IG7wSUsfhqmnLCAbDMUHGTgH5lEMR7mxR0XYaIORGFPQrd27MT7INaLroaHeB1d8TrIa2YjDA==
X-Received: by 2002:a05:600c:1d19:b0:456:18f3:b951 with SMTP id 5b1f17b1804b1-45892ba16b5mr42481155e9.15.1753891958335;
        Wed, 30 Jul 2025 09:12:38 -0700 (PDT)
Received: from framework13.tail696c1.ts.net (93-44-110-195.ip96.fastwebnet.it. [93.44.110.195])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458952f24c2sm33680095e9.0.2025.07.30.09.12.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jul 2025 09:12:37 -0700 (PDT)
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Luca Di Maio <luca.dimaio1@gmail.com>,
	dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev,
	djwong@kernel.org,
	hch@infradead.org
Subject: [PATCH v12 0/1] mkfs: add ability to populate filesystem from directory
Date: Wed, 30 Jul 2025 18:12:21 +0200
Message-ID: <20250730161222.1583872-1-luca.dimaio1@gmail.com>
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
[v11] -> [v12]
  more indentation/formatting fixes
  fix leaking file descriptors
  fix unoptimized code handling path buffers
  fix wording of man page
  improve function names to better reflect what they do
  better handling of openat() with O_NOATIME when unprivileged

Luca Di Maio (1):
  proto: add ability to populate a filesystem from a directory

 man/man8/mkfs.xfs.8.in |  38 +-
 mkfs/proto.c           | 771 ++++++++++++++++++++++++++++++++++++++++-
 mkfs/proto.h           |  18 +-
 mkfs/xfs_mkfs.c        |  23 +-
 4 files changed, 817 insertions(+), 33 deletions(-)

--
2.50.0
