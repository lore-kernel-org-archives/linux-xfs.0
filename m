Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272E61B4C42
	for <linux-xfs@vger.kernel.org>; Wed, 14 Aug 2024 21:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723670766; cv=none; b=JILOZDsbFHC5Ey/e6A3+BdAVjUW1FCvybh3muuz/nFBGj/KWL6fuRY7w1WE1GzTPEO/yjJtIUB/le4vLAuL9SFOHJlluPqLmTlhBxbhQ7WV/xeCi9U5ukCTObeCk1bhWs0XS9+CwjgHSgyuHIEa/U6TTH8+PMmW1hcQkXigvsi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723670766; c=relaxed/simple;
	bh=GWaaaFa5p9YV8pWOdymeo3ub/M+DKWgxitUWjUW2hSU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=QgqJnMYD4yNzVPTm74uOzcAKFz+R6MZbLj5K1GvfOYDBptJjqMyxxWw3t21tYGUDJgN2Mz5yt7IC23xao3asJ/IqHpS/Vbjah5w6IW8JiCJpY+3lkDCRx9TjMjEuYsN2kvPIwajrKkryoFVp33YEf0EpeLUYkNNUK3rxPLwo2Jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=jVibL81K; arc=none smtp.client-ip=209.85.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="jVibL81K"
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-5d5de0e47b9so205089eaf.0
        for <linux-xfs@vger.kernel.org>; Wed, 14 Aug 2024 14:26:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1723670764; x=1724275564; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=Pyau8aOJuyZnZfGNcIVxqfibv2avRjwgFV+ZdZpslNc=;
        b=jVibL81KoTI+z5PO2jZyD1uBfNfYwaUdOYs+fABzlNFmbGlJK7S5WiNg9ZcY6NG4h6
         uOdv57E9cSR89XoVQY8dFZ2h4F+7JTESMRwk1CtpO0oFHQlVcpicIkGWkQtwJyc/7uK+
         A4SeRwJv6z0PiAg659NHE2cMDGDPGbTkRSNkm7p9K9GqKf+lsk75y7t5jrpwFGBKv2DO
         0xRj9PqqeLGV4fe6/RsjDQLUgKonl77sPVmNz3vTRqDHLwaibilVWl0ocERXEDxRGJCW
         0sXjkk00e+mqXO99bQhaXIqGzagF9UrMqhE092QYmOzZUJp90tCTw8QNPG3u9usaZHwb
         3l0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723670764; x=1724275564;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Pyau8aOJuyZnZfGNcIVxqfibv2avRjwgFV+ZdZpslNc=;
        b=WN0H2IA1Kv6x3qOH8nhY05S4TXtGIKDK7BSBIxjIn7z0nKbVd32g+JKxjni15mCvow
         ++IexEwS+UDUHLX0rRmFKYC15jG0bUu1U02+SEBpuX+gvHZYZrq5rdbrIFn8qIXHTgJZ
         N/V9SsiShRFadC0V/d+5HzhAsd6T09Ud5mPhRxvZRk/RbSg2wYT65JXyRfHX+Mu3JDj+
         By0grCKsM1g8WpOhfpwR4EegWs6CEnwKEJgSEs961ICNBs1uA6P3z9vCMxHBNOg0aNhp
         U57HsbHtaCw4fVvmMJEkBzYEd1DbsJdnwiIDn0lQtYo2G6NlbepLQmznMeLCfpNmhWZH
         EdpA==
X-Forwarded-Encrypted: i=1; AJvYcCXVM8bvIM9jeEvOyCjsWNPReFTSAaeEyxdVgGyatmT1THIYeDOOpZrUjOotFjHcIbBLEPSqO1qcj+BMNrG6C9WBxRBlmIDofbyU
X-Gm-Message-State: AOJu0Yy0/Tencdq1VCsGspc0Kjbkks4PaQiz5QI9QyOoF+4cqbnxNarO
	+84MfJYv2gK4f7zZYtRB6Iha7MK+NzSscRQheSN+6BZcZDfmXcdFBu0CYQLdN6s=
X-Google-Smtp-Source: AGHT+IEJyMAMyA8U3woOzIEEj3JSvwjQmFqO5kjZauXzQokagOUrsDyTtU+QTE5PXpZ2YP7fpxx74w==
X-Received: by 2002:a05:6358:6f15:b0:1b1:a666:2bba with SMTP id e5c5f4694b2df-1b1aad5368dmr492206355d.24.1723670764131;
        Wed, 14 Aug 2024 14:26:04 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6bf6fe06fdfsm642966d6.34.2024.08.14.14.26.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 14:26:03 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	linux-xfs@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v4 00/16] fanotify: add pre-content hooks
Date: Wed, 14 Aug 2024 17:25:18 -0400
Message-ID: <cover.1723670362.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v3: https://lore.kernel.org/linux-fsdevel/cover.1723228772.git.josef@toxicpanda.com/
v2: https://lore.kernel.org/linux-fsdevel/cover.1723144881.git.josef@toxicpanda.com/
v1: https://lore.kernel.org/linux-fsdevel/cover.1721931241.git.josef@toxicpanda.com/

v3->v4:
- Trying to send a final verson Friday at 5pm before you go on vacation is a
  recipe for silly mistakes, fixed the xfs handling yet again, per Christoph's
  review.
- Reworked the file system helper so it's handling of fpin was a little less
  silly, per Chinner's suggestion.
- Updated the return values to not or in VM_FAULT_RETRY, as we have a comment
  in filemap_fault that says if VM_FAULT_ERROR is set we won't have
  VM_FAULT_RETRY set.

v2->v3:
- Fix the pagefault path to do MAY_ACCESS instead, updated the perm handler to
  emit PRE_ACCESS in this case, so we can avoid the extraneous perm event as per
  Amir's suggestion.
- Reworked the exported helper so the per-filesystem changes are much smaller,
  per Amir's suggestion.
- Fixed the screwup for DAX writes per Chinner's suggestion.
- Added Christian's reviewed-by's where appropriate.

v1->v2:
- reworked the page fault logic based on Jan's suggestion and turned it into a
  helper.
- Added 3 patches per-fs where we need to call the fsnotify helper from their
  ->fault handlers.
- Disabled readahead in the case that there's a pre-content watch in place.
- Disabled huge faults when there's a pre-content watch in place (entirely
  because it's untested, theoretically it should be straightforward to do).
- Updated the command numbers.
- Addressed the random spelling/grammer mistakes that Jan pointed out.
- Addressed the other random nits from Jan.

--- Original email ---

Hello,

These are the patches for the bare bones pre-content fanotify support.  The
majority of this work is Amir's, my contribution to this has solely been around
adding the page fault hooks, testing and validating everything.  I'm sending it
because Amir is traveling a bunch, and I touched it last so I'm going to take
all the hate and he can take all the credit.

There is a PoC that I've been using to validate this work, you can find the git
repo here

https://github.com/josefbacik/remote-fetch

This consists of 3 different tools.

1. populate.  This just creates all the stub files in the directory from the
   source directory.  Just run ./populate ~/linux ~/hsm-linux and it'll
   recursively create all of the stub files and directories.
2. remote-fetch.  This is the actual PoC, you just point it at the source and
   destination directory and then you can do whatever.  ./remote-fetch ~/linux
   ~/hsm-linux.
3. mmap-validate.  This was to validate the pagefault thing, this is likely what
   will be turned into the selftest with remote-fetch.  It creates a file and
   then you can validate the file matches the right pattern with both normal
   reads and mmap.  Normally I do something like

   ./mmap-validate create ~/src/foo
   ./populate ~/src ~/dst
   ./rmeote-fetch ~/src ~/dst
   ./mmap-validate validate ~/dst/foo

I did a bunch of testing, I also got some performance numbers.  I copied a
kernel tree, and then did remote-fetch, and then make -j4

Normal
real    9m49.709s
user    28m11.372s
sys     4m57.304s

HSM
real    10m6.454s
user    29m10.517s
sys     5m2.617s

So ~17 seconds more to build with HSM.  I then did a make mrproper on both trees
to see the size

[root@fedora ~]# du -hs /src/linux
1.6G    /src/linux
[root@fedora ~]# du -hs dst
125M    dst

This mirrors the sort of savings we've seen in production.

Meta has had these patches (minus the page fault patch) deployed in production
for almost a year with our own utility for doing on-demand package fetching.
The savings from this has been pretty significant.

The page-fault hooks are necessary for the last thing we need, which is
on-demand range fetching of executables.  Some of our binaries are several gigs
large, having the ability to remote fetch them on demand is a huge win for us
not only with space savings, but with startup time of containers.

There will be tests for this going into LTP once we're satisfied with the
patches and they're on their way upstream.  Thanks,

Josef

Amir Goldstein (8):
  fsnotify: introduce pre-content permission event
  fsnotify: generate pre-content permission event on open
  fanotify: introduce FAN_PRE_ACCESS permission event
  fanotify: introduce FAN_PRE_MODIFY permission event
  fanotify: pass optional file access range in pre-content event
  fanotify: rename a misnamed constant
  fanotify: report file range info with pre-content events
  fanotify: allow to set errno in FAN_DENY permission response

Josef Bacik (8):
  fanotify: don't skip extra event info if no info_mode is set
  fanotify: add a helper to check for pre content events
  fanotify: disable readahead if we have pre-content watches
  mm: don't allow huge faults for files with pre content watches
  fsnotify: generate pre-content permission event on page fault
  bcachefs: add pre-content fsnotify hook to fault
  gfs2: add pre-content fsnotify hook to fault
  xfs: add pre-content fsnotify hook for write faults

 fs/bcachefs/fs-io-pagecache.c      |   4 +
 fs/gfs2/file.c                     |   4 +
 fs/namei.c                         |   9 ++
 fs/notify/fanotify/fanotify.c      |  32 ++++++--
 fs/notify/fanotify/fanotify.h      |  20 +++++
 fs/notify/fanotify/fanotify_user.c | 116 +++++++++++++++++++++-----
 fs/notify/fsnotify.c               |  14 +++-
 fs/xfs/xfs_file.c                  |   4 +
 include/linux/fanotify.h           |  20 +++--
 include/linux/fsnotify.h           |  54 ++++++++++--
 include/linux/fsnotify_backend.h   |  59 ++++++++++++-
 include/linux/mm.h                 |   1 +
 include/uapi/linux/fanotify.h      |  17 ++++
 mm/filemap.c                       | 128 +++++++++++++++++++++++++++--
 mm/memory.c                        |  22 +++++
 mm/readahead.c                     |  13 +++
 security/selinux/hooks.c           |   3 +-
 17 files changed, 469 insertions(+), 51 deletions(-)

-- 
2.43.0

