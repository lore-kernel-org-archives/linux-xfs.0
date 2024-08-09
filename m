Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8BE12C52E
	for <linux-xfs@vger.kernel.org>; Fri,  9 Aug 2024 18:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723229096; cv=none; b=j7fiUOyz1q3qGTT9rBRx1v0JvZmhYMyuD0yXkavvlY+3+iAJs9oXCAMS9AlKhFBTOb7f8TV943BbUkFXktyAlRor+EMcCVU9ntWlq2g+GECICOMthw5Zo4cJnqcqoZsVzF/1/zV/RXjeldmMKmYODH8oqOPxnAnMWnZusbotWRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723229096; c=relaxed/simple;
	bh=5TGwiTQjNXlGePzR5Q/mJD0pdX/O9bNYb4K7xod+MjI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=koZDW4cN6N9Ckrlg+hVpq8byRLC+uRpLrk4tMLGssCsQkUkBu/vTWk9soFiKDN58Ag68cYSmgjUQLjc7rKh79ZhY/I+wqXA+uEM+JH7Ikia6kD+ZgL+QYS30Rn+e5y2d715XIdjBzwYDBllaKQyHAV9t2PmLXDIkyDJwRgyVCAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=TzhFPzmn; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="TzhFPzmn"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-6bb687c3cceso13223266d6.0
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2024 11:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1723229093; x=1723833893; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=d1PZznfHxR4p21j9WCsE102uMWDO9dI2o6sLe8vY6Nc=;
        b=TzhFPzmnb5oCMSZr3YMzMO4ErevoD8JHT5jg+G2HhvwH7ib5vwiuz1TCWp5Z2PMjYF
         8/9oRngpccsEC5GY0XtHqwAI7wIfEcxHMkpwP0q56UFd4cHjsUBqMgEW3FlgK3DL/PdI
         X57oVjVlSEguURLWdFmkJp51mE6cAh+e7OXDvXwSj/fUAlnyik/r5l4gumdTRkivX4WT
         bpWhX0Hu5cq7REeYMU4e0w5WdagjH6YFVZ0Spaco00fjuaMOGMZTVrruVX1JmsKhBhwK
         xxfGryUG3s3np2/miDsc80UWyZPGAjy2ZmiyRpALW+PBb1Q8TNB2+EgvzmBPahzJn3Rd
         niWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723229093; x=1723833893;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d1PZznfHxR4p21j9WCsE102uMWDO9dI2o6sLe8vY6Nc=;
        b=OLq39ejnpwVbSQJGFUO88/19voDAUkqtM9NuCp7l1yf6wtM3mGbg+YvzA4LtNDH0wI
         z2aZiW+9fVNUDYgvU4Qsz/g7SEMPySdCxC85hJxry7gRU6jGBnclVCp4c0qp/6cUsgFh
         VVDFvBge3M++BmMI6YLY6/Dtw847O9BEkGw2U9gbCecbnB1WHYIRkUczbCNFw22DDlFc
         ydG7U2FccAJIFzlvUFneudXehB7JwWjQPc6G7IiXHUxgwnWm1WvglEmrgNFUzxYc9UID
         UoIWcXfHXX1zpX6aVEtGtNqXSWr1RVuodRY5QgJh+ZWjRAU+T7R87jOCAKRmsStAZgNa
         OR6Q==
X-Forwarded-Encrypted: i=1; AJvYcCXi1awRobbn0OZuY3Nt0F68WKZkdSjscJQe3dxqL2hc7e73C79/+XmBwreaCA1krGgL2OKrbm6FXEGXlD9V4GraEKH7OsQHkt0/
X-Gm-Message-State: AOJu0YzWxJanyJqIYHaDs6MJ42YVOIj1QlH3HHXuhlqiU2TIsvEZbQ/0
	5FwNudVw2rFRmA/osCB+esa6Nas/A504DyNU+mOfwPHOj0yD6Mp2obOP4Bm+w+w=
X-Google-Smtp-Source: AGHT+IFCcjPOlhBGCaWxyvOvSFsmzbg18+aGJmls0mZABl+rwgLrcJr3kubzK0fWN3U917IWZZunow==
X-Received: by 2002:a05:6214:419c:b0:6b5:d9ef:d56d with SMTP id 6a1803df08f44-6bd78d22066mr25219086d6.21.1723229092962;
        Fri, 09 Aug 2024 11:44:52 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6bd82e2f53asm612216d6.96.2024.08.09.11.44.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 11:44:52 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	linux-xfs@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v3 00/16] fanotify: add pre-content hooks
Date: Fri,  9 Aug 2024 14:44:08 -0400
Message-ID: <cover.1723228772.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v2: https://lore.kernel.org/linux-fsdevel/cover.1723144881.git.josef@toxicpanda.com/
v1: https://lore.kernel.org/linux-fsdevel/cover.1721931241.git.josef@toxicpanda.com/

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
 fs/notify/fanotify/fanotify.c      |  32 +++++--
 fs/notify/fanotify/fanotify.h      |  20 +++++
 fs/notify/fanotify/fanotify_user.c | 116 ++++++++++++++++++++-----
 fs/notify/fsnotify.c               |  14 ++-
 fs/xfs/xfs_file.c                  |   9 +-
 include/linux/fanotify.h           |  20 +++--
 include/linux/fsnotify.h           |  54 ++++++++++--
 include/linux/fsnotify_backend.h   |  59 ++++++++++++-
 include/linux/mm.h                 |   1 +
 include/uapi/linux/fanotify.h      |  17 ++++
 mm/filemap.c                       | 134 +++++++++++++++++++++++++++--
 mm/memory.c                        |  22 +++++
 mm/readahead.c                     |  13 +++
 security/selinux/hooks.c           |   3 +-
 17 files changed, 478 insertions(+), 53 deletions(-)

-- 
2.43.0

