Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0326B4C9D
	for <linux-xfs@vger.kernel.org>; Mon, 28 Jul 2025 20:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753734691; cv=none; b=cxxXHJbi3qJk1UkhrPyNaFgndiZQ2gl4BEuv6RB8AUK5A6fbXs+i5odOAsufeeAni7g8YmaWCf8luwGusftDouBD8IGHajdhoZwksu/Fh8LY37+wKUTeMSf/vfLpIo+4fPyt1HLeQqOS9hi8MBPtTC595Ap2k+0yffvGH4CLT9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753734691; c=relaxed/simple;
	bh=R9+5Lb1P8nVdkBaFU4wBZNzDcHY97ji498FxYqLBnkM=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=Og3R4Yq/ra9FuTMwvaYJhdtx8OjAHAHb0ivTw4OqjZNHPlMk9z014j+ErPh+8RI9wLp7J4XlYcwKdo5H/ebUZo5KQFaL0KcKF/XDfeVwMR/cETq3z9xY7iKDqApz6Sv1QjYJ7Kw1JxJ3HQhfZdADnFB/aSAjKfARKP1pYGjHxkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Jc/9QD+d; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jc/9QD+d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753734685;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=EKJwftSlaT22fO4beByVlIMH/g6yb1l1MUyokYspDhY=;
	b=Jc/9QD+dRvdRw6P9QPdYPlNMXSy9xu4pDKpQdgrwcIW/2KY94sUFnesGqabsZIJbJzJx6s
	iOQA6ZSykorjuyy5d6SRj1I3mDqO4+5iW/h2zrdQ3N7JPAvN/vOaO3DTADSwDh0hk3uxbh
	Su3PPjB7oDE/m/LojPmlUyUwWvhdIQk=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-49-9c0qncEAMui6aBxe-aFmZw-1; Mon, 28 Jul 2025 16:31:23 -0400
X-MC-Unique: 9c0qncEAMui6aBxe-aFmZw-1
X-Mimecast-MFC-AGG-ID: 9c0qncEAMui6aBxe-aFmZw_1753734682
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-6077833ae13so4416999a12.1
        for <linux-xfs@vger.kernel.org>; Mon, 28 Jul 2025 13:31:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753734682; x=1754339482;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EKJwftSlaT22fO4beByVlIMH/g6yb1l1MUyokYspDhY=;
        b=U3tMmf0MSPoChTDFksH6ultmKTQJViTiVDX1I/+kM2xC6Xz7DclYPw0sshGDmt5BIB
         RSTTYqgHK1ZFMeIoqenbi4/KLZL9gfr4xQ7i+6XwQNHP/AsnhasIxTPojre2g9/RTUcW
         pX88S5CrJSRQMPajlI7Trq9ebeLecTXcHrl9sQku8n9BKe8wYRX2tGEyOvwSSnqsEcba
         RwvabhrH9IdPPSgMmCPYd9waOkYxGuf6u1YDxJaPc0jNveJQOMLS60HZov9kOWAXnoS0
         zY89Bm5bX7GtN5tyY0cfT3YFeePRIAWgSRvnej9/xy8xajRGyFICqQNhg8PbwTSo1v24
         YOBg==
X-Forwarded-Encrypted: i=1; AJvYcCUUytUxzUgmWcoHYpojCRvUSsmSEpK76lHJ7lQHKJGtGVPxqijCwbOCL2YOrZXOGdXHgR83PH8CvWI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyTGZ6+NMFaUgeI6GTXtlBm3tsYUu2fyrhw1LR2SucIlk8pDDle
	vFs13JMAeJzPPG5xsVoP5UABXcI+bQXR6J+34eixH+DhrwwTYw4755f/WzKfyVymWgmfrP32zJH
	OI+6SG2xcp3dZ5fu3ihFUrU8Rk3dTvV5G32cONcWC1gxeitL5tNxWDKZJN0Cl
X-Gm-Gg: ASbGncst+JchmCD3mILpS1iFCPxjvEGy0gQPhaBsvU8Q8xpdFZIkhR16C2ZDvTp6gZs
	W9LMAxVwOdopt6dPgvvmZ5BlJ17MIEMk3wzWY4AmdSbfGkE4LBiqKce6ygt3Femd2bNmWqUdZb+
	V7kpx055ktdiMjCFHl+AkcB4RA5839edSQwW2bhm7SY3kS/cpN0DFmSIGZJN51nTKiOgMTeY1e0
	dL1BZC/J+/cFtd4QBM9PzgrS0B530Xuiw6fspdBFVfIv/OyJLABFADzoW/PJilWEuEB2flElqHi
	m/tTJbN8pxXZVNraKI57Yw3hgTBtcxgvkJutF1UXdLPIGQ==
X-Received: by 2002:a05:6402:354e:b0:612:c4a1:1381 with SMTP id 4fb4d7f45d1cf-614f1df5cbbmr13035066a12.26.1753734682263;
        Mon, 28 Jul 2025 13:31:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEW5S0Y0Z+OJsUUAjaoiSY8D+vHt8hu3xP13H3f8LeLxORwrEN+Yh7uHxko4qmOtGByPbpMPw==
X-Received: by 2002:a05:6402:354e:b0:612:c4a1:1381 with SMTP id 4fb4d7f45d1cf-614f1df5cbbmr13035033a12.26.1753734681757;
        Mon, 28 Jul 2025 13:31:21 -0700 (PDT)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-615226558d3sm2730656a12.45.2025.07.28.13.31.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 13:31:21 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH RFC 00/29] fs-verity support for XFS with post EOF merkle
 tree
Date: Mon, 28 Jul 2025 22:30:04 +0200
Message-Id: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAMzdh2gC/y2MTQ6CMBBGr9LM2iZlDCWwNfEAbg2Ltkx1FoB0K
 tEQ7m6jLt/38zYQSkwCndog0crC81SgOigIdzfdSPNQGNBgbbBCHWUtj/zW5K0NFJtIrYcyfyS
 K/PqqrnA5n6D/hYmWZ9Hmf+OdkA7zOHLu1NHUQ9MiWmcd9Pv+AWCji9SPAAAA
X-Change-ID: 20250212-fsverity-eb66cef7fe9b
To: fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
 linux-xfs@vger.kernel.org, david@fromorbit.com, djwong@kernel.org, 
 ebiggers@kernel.org, hch@lst.de
Cc: Andrey Albershteyn <aalbersh@redhat.com>, 
 Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=6348; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=R9+5Lb1P8nVdkBaFU4wBZNzDcHY97ji498FxYqLBnkM=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIYMtrvie+MaxBTmb3r2XXpu5VzBVKecm//6LpHw0B38
 sOQHmndq50dpSwMYlwMsmKKLOuktaYmFUnlHzGokYeZw8oEMoSBi1MAJpK1mOG/34rozX9nMzPZ
 iH45lXo6O47XQdKed63kpLL3oWfjuI7oMzJMEj7ccDRei83Yn/HwLAkF11dzlgm/bLz378aMJ93
 vPhYxAQDS8UaI
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

Hi all,

This patchset adds fs-verity support for XFS. This version store merkle
tree beyond end of the file, similar as ext4 does it.

The first two patches introduce new iomap_read/write interface in iomap.
The reasons are:
- it is not bound by EOF,
- the iomap_read_region() also allocates folio and returns it to caller.

Then follows changes to the fs-verity core, per-filesystem workqueue,
iomap integration. These are mostly unchanged from previous patchsets.

The iomap read path has a bit of a fs-verity only zeroing logic for the
case when tree block size, fs block size and page size differ. As tree is
contiguous region of memory I just zero the tail of the tree region.

Preallocations. I just disabled preallocations by setting allocation
size to zero for Merkle tree data. This should not be a problem as these
files are read-only and in stable state when we get to Merkle tree
writing. It would be nice to allocate tree size on first write, but I
haven't got to it yet.

The tree is read by iomap into page cache at offset 1 << 53. This seems
to be far enough to handle any supported file size.

Testing. The -g verity is passing for 1k and 4k with/without quota, the
tests include different merkle tree block size.

I plan to look into readahead and whole tree allocation on first write
and xfsprogs requires a bit more work.

Feedback is welcomed :)

xfsprogs:
https://github.com/alberand/xfsprogs/tree/b4/fsverity

xfstests:
https://github.com/alberand/xfstests/tree/b4/fsverity

Cc: fsverity@lists.linux.dev
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org

Cc: david@fromorbit.com
Cc: djwong@kernel.org
Cc: ebiggers@kernel.org
Cc: hch@lst.de

[RFC] Directly mapped xattr data & fs-verity
[1]: https://lore.kernel.org/linux-xfs/20241229133350.1192387-1-aalbersh@kernel.org/

---
Andrey Albershteyn (19):
      iomap: add iomap_writepages_unbound() to write beyond EOF
      iomap: introduce iomap_read/write_region interface
      fs: add FS_XFLAG_VERITY for verity files
      fsverity: add per-sb workqueue for post read processing
      fsverity: add tracepoints
      iomap: integrate fs-verity verification into iomap's read path
      xfs: add attribute type for fs-verity
      xfs: add fs-verity ro-compat flag
      xfs: add inode on-disk VERITY flag
      xfs: initialize fs-verity on file open and cleanup on inode destruction
      xfs: don't allow to enable DAX on fs-verity sealed inode
      xfs: disable direct read path for fs-verity files
      xfs: disable preallocations for fsverity Merkle tree writes
      xfs: add writeback and iomap reading of Merkel tree pages
      xfs: add fs-verity support
      xfs: add fs-verity ioctls
      xfs: fix scrub trace with null pointer in quotacheck
      xfs: add fsverity traces
      xfs: enable ro-compat fs-verity flag

Darrick J. Wong (10):
      fsverity: report validation errors back to the filesystem
      fsverity: pass super_block to fsverity_enqueue_verify_work
      ext4: use a per-superblock fsverity workqueue
      f2fs: use a per-superblock fsverity workqueue
      btrfs: use a per-superblock fsverity workqueue
      fsverity: remove system-wide workqueue
      fsverity: expose merkle tree geometry to callers
      xfs: advertise fs-verity being available on filesystem
      xfs: check and repair the verity inode flag state
      xfs: report verity failures through the health system

 Documentation/filesystems/fsverity.rst |   8 +
 MAINTAINERS                            |   1 +
 fs/btrfs/super.c                       |  14 ++
 fs/buffer.c                            |   7 +-
 fs/ext4/readpage.c                     |   4 +-
 fs/ext4/super.c                        |  11 ++
 fs/f2fs/compress.c                     |   3 +-
 fs/f2fs/data.c                         |   2 +-
 fs/f2fs/super.c                        |  11 ++
 fs/ioctl.c                             |  11 ++
 fs/iomap/buffered-io.c                 | 301 ++++++++++++++++++++++++++++--
 fs/iomap/ioend.c                       |  41 +++-
 fs/super.c                             |   3 +
 fs/verity/enable.c                     |   4 +
 fs/verity/fsverity_private.h           |   2 +-
 fs/verity/init.c                       |   2 +-
 fs/verity/open.c                       |  37 ++++
 fs/verity/verify.c                     |  52 +++---
 fs/xfs/Makefile                        |   1 +
 fs/xfs/libxfs/xfs_da_format.h          |  15 +-
 fs/xfs/libxfs/xfs_format.h             |  13 +-
 fs/xfs/libxfs/xfs_fs.h                 |   2 +
 fs/xfs/libxfs/xfs_health.h             |   4 +-
 fs/xfs/libxfs/xfs_inode_buf.c          |   8 +
 fs/xfs/libxfs/xfs_inode_util.c         |   2 +
 fs/xfs/libxfs/xfs_log_format.h         |   1 +
 fs/xfs/libxfs/xfs_sb.c                 |   4 +
 fs/xfs/scrub/attr.c                    |   7 +
 fs/xfs/scrub/common.c                  |  74 ++++++++
 fs/xfs/scrub/common.h                  |   3 +
 fs/xfs/scrub/inode.c                   |   7 +
 fs/xfs/scrub/inode_repair.c            |  36 ++++
 fs/xfs/scrub/trace.h                   |   2 +-
 fs/xfs/xfs_aops.c                      |  21 ++-
 fs/xfs/xfs_bmap_util.c                 |   7 +
 fs/xfs/xfs_file.c                      |  23 ++-
 fs/xfs/xfs_fsverity.c                  | 330 +++++++++++++++++++++++++++++++++
 fs/xfs/xfs_fsverity.h                  |  28 +++
 fs/xfs/xfs_health.c                    |   1 +
 fs/xfs/xfs_inode.h                     |   6 +
 fs/xfs/xfs_ioctl.c                     |  16 ++
 fs/xfs/xfs_iomap.c                     |  22 ++-
 fs/xfs/xfs_iops.c                      |   4 +
 fs/xfs/xfs_mount.h                     |   2 +
 fs/xfs/xfs_super.c                     |  22 +++
 fs/xfs/xfs_trace.h                     |  49 ++++-
 include/linux/fs.h                     |   2 +
 include/linux/fsverity.h               |  49 ++++-
 include/linux/iomap.h                  |  32 ++++
 include/trace/events/fsverity.h        | 162 ++++++++++++++++
 include/uapi/linux/fs.h                |   1 +
 51 files changed, 1399 insertions(+), 71 deletions(-)
---
base-commit: 305d79226a6a797b193ca681e9f26f3bf081397b
change-id: 20250212-fsverity-eb66cef7fe9b

Best regards,
-- 
Andrey Albershteyn <aalbersh@kernel.org>

