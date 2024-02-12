Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD473D55D
	for <linux-xfs@vger.kernel.org>; Mon, 12 Feb 2024 16:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707757195; cv=none; b=qI7WsRS/z6Le9D8JeRsqDvJTz+BG6WR/tnIiySBeMY7NUfR3GW/qwoiNdQqGb0Qccok0b859ESg72FzpyMDcaL1w8L58DcHveM8aBwOhGQHoQYoN5B2v5ihXgPkPMzPjAeLIwqQ3Kkif5ij1dgXwTnRi7f3F6GmkCqb2BmEawXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707757195; c=relaxed/simple;
	bh=qWyOYgUJ7yXrKklC61LmyR4Nml6VAji65hLkpbOuRUo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=EcSTF3WDOIEBgd+1gNw/wxclSRZxbxLDkEB+1pVwq0Zz3WO+B1Wlhq88R3ZoE+8h3AtSIi3zFynvoTI7QEAg0lUV89rkRh7gUZId1ZniK454OGkXdjGthxYL+qCyZcjIHOqAvCGP6k0BLHcpw43s94Wwj0hIhROvGHBGdyDu8tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UNvn/NpR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UNvn/NpR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707757192;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=61D4IN0Kt7iuELlNRFVN1CWOL5uOtv1g99NthtfKGpM=;
	b=UNvn/NpRU5qYGJsbUWRJxru5AcSQtZDEmJvuPUcfqxIxUWrJrVK6OJKqzrcxZ4CcPY69aw
	eSZDeetaKyg9U9vtlWQFNOQiHij+cSw18+R5WR3YkitJGtGPBy5T915CZE2oamJT7XVDPY
	i97cdoewpwGPu+QZgQDONMRWrESDSdk=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-544-0r89aLFJOeejPNhPpv-QnQ-1; Mon, 12 Feb 2024 11:59:51 -0500
X-MC-Unique: 0r89aLFJOeejPNhPpv-QnQ-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-559555e38b0so3140313a12.3
        for <linux-xfs@vger.kernel.org>; Mon, 12 Feb 2024 08:59:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707757190; x=1708361990;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=61D4IN0Kt7iuELlNRFVN1CWOL5uOtv1g99NthtfKGpM=;
        b=kZ6ruTJ1o9L3mVVCM3vhMoq3WMP17SHs1A5WqYu+3pQmvqHjGYP8McLoC17orjmXOR
         nFoonorzpMlwP97ps6qrrHRu7s7AwLB2nMfCSG9SmOSr1blyhgGfXQo85hc6A08Q0ZkO
         oToWBvg0PdkckvPXRw0BQqKRF/CkUP/IQDc8J3OwiW7dsYfy1CTFeRwbhCvMWN3dppa9
         RYZPKmTEPSZfe6nX8y8jbk6VonL27ElNatmTlc7DjQ42pGuhOWFJR0glPdnw2G0lOsCh
         6pZju+lQoq3Pxqm+74xU/SEDnRSjvhOqnfMfzbspRL2hQO1Ae/+BYnlWcvnOWGqwC3DY
         jTBA==
X-Gm-Message-State: AOJu0Yz5TvzNsIbad5NFCv7y6KAqZYojMRkvgpyw7TUqJGRXa8zYpqm+
	yOELqsHepSYIQIdwym5+ctTOS2qaPU0sZVsuwzEnghQsvx5mnVO3v3qOM9bsAb2iCKZbCtcW91Q
	Ls8DIJ/DzVkxfyutDVLlYmX98VBXYvi7J7AYt8QOvj6Ip/Q66g+Usa7t2
X-Received: by 2002:a05:6402:1a41:b0:55f:c9cb:208a with SMTP id bf1-20020a0564021a4100b0055fc9cb208amr4875122edb.35.1707757189977;
        Mon, 12 Feb 2024 08:59:49 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHePths5qWvlMb4oKFzl9++euPqyv1mGTDHXW6ewp1zfKccZScCC64OtrHm7TzqTX72FfTw6Q==
X-Received: by 2002:a05:6402:1a41:b0:55f:c9cb:208a with SMTP id bf1-20020a0564021a4100b0055fc9cb208amr4875098edb.35.1707757189665;
        Mon, 12 Feb 2024 08:59:49 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVUlQDV3j/MHYGQfQ9ooeGDYx+O10qS/QYnnlsEeu8KTobbwyQqmetkAxmDSXf3aFj+GYnT6YMDKcSXIlTFLIoNNdk1X0e2HWJ71t0bMTMCyndsannx6y/5xW8gzleTihtCLKlXEHWABMr3Ds8FBAdq1Qxjs5nPYylrGRbfY6fgkjzfclPTD6zbf+hJ6wagKQv0P+9dykz4um7ln05GTbMe9RcGX24uEIjj
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id 14-20020a0564021f4e00b0056176e95a88sm2620261edz.32.2024.02.12.08.59.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Feb 2024 08:59:49 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: fsverity@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	chandan.babu@oracle.com,
	djwong@kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v4 00/25] fs-verity support for XFS
Date: Mon, 12 Feb 2024 17:57:57 +0100
Message-Id: <20240212165821.1901300-1-aalbersh@redhat.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

Here's v4 of my patchset of adding fs-verity support to XFS.

This implementation uses extended attributes to store fs-verity
metadata. The Merkle tree blocks are stored in the remote extended
attributes. The names are offsets into the tree.

A few key points of this patchset:
- fs-verity can work with Merkle tree blocks based caching (xfs) and
  PAGE caching (ext4, f2fs, btrfs)
- iomap does fs-verity verification. Filesystem has to provide
  workqueue only.
- In XFS, fs-verity metadata is stored in extended attributes
- New global XFS workqueue for verification processing
- Inodes with fs-verity have new on-disk diflag
- xfs_attr_get() can return a buffer with an extended attribute
- xfs_buf can allocate double space for Merkle tree blocks. Part of
  the space is used to store  the extended attribute data without
  leaf headers
- xfs_buf tracks verified status of merkle tree blocks

The patchset consists of five parts:
- [1]: fs-verity spinlock removal pending in fsverity/for-next
- [2..4]: Parent pointers adding binary xattr names
- [5]: Expose FS_XFLAG_VERITY for fs-verity files
- [6..9]: Changes to fs-verity core
- [10]: Integrate fs-verity to iomap
- [11-25]: Add fs-verity support to XFS

Testing:
The patchset is tested with xfstests -g quick on xfs_1k, xfs_4k,
xfs_1k_quota, xfs_4k_quota, ext4_4k, and ext4_4k_quota. With
KMEMLEAK and KASAN enabled. More testing on the way.

Changes from V3:
- redone changes to fs-verity core as previous version had an issue
  on ext4
- add blocks invalidation interface to fs-verity
- move memory ordering primitives out of block status check to fs
  read block function
- add fs-verity verification to iomap instead of general post read
  processing
Changes from V2:
- FS_XFLAG_VERITY extended attribute flag
- Change fs-verity to use Merkle tree blocks instead of expecting
  PAGE references from filesystem
- Change approach in iomap to filesystem provided bio_set and
  submit_io instead of just callouts to filesystem
- Add possibility for xfs_buf allocate more space for fs-verity
  extended attributes
- Make xfs_attr module to copy fs-verity blocks inside the xfs_buf,
  so XFS can get data without leaf headers
- Add Merkle tree removal for error path
- Makae scrub aware of new dinode flag
Changes from V1:
- Added parent pointer patches for easier testing
- Many issues and refactoring points fixed from the V1 review
- Adjusted for recent changes in fs-verity core (folios, non-4k)
- Dropped disabling of large folios
- Completely new fsverity patches (fix, callout, log_blocksize)
- Change approach to verification in iomap to the same one as in
  write path. Callouts to fs instead of direct fs-verity use.
- New XFS workqueue for post read folio verification
- xfs_attr_get() can return underlying xfs_buf
- xfs_bufs are marked with XBF_VERITY_CHECKED to track verified
  blocks

kernel:
[1]: https://github.com/alberand/linux/tree/fsverity-v4

xfsprogs:
[2]: https://github.com/alberand/xfsprogs/tree/fsverity-v4

xfstests:
[3]: https://github.com/alberand/xfstests/tree/fsverity-v4

v1:
[4]: https://lore.kernel.org/linux-xfs/20221213172935.680971-1-aalbersh@redhat.com/

v2:
[5]: https://lore.kernel.org/linux-xfs/20230404145319.2057051-1-aalbersh@redhat.com/

v3:
[6]: https://lore.kernel.org/all/20231006184922.252188-1-aalbersh@redhat.com/

fs-verity:
[7]: https://www.kernel.org/doc/html/latest/filesystems/fsverity.html

Thanks,
Andrey

Allison Henderson (3):
  xfs: add parent pointer support to attribute code
  xfs: define parent pointer ondisk extended attribute format
  xfs: add parent pointer validator functions

Andrey Albershteyn (22):
  fsverity: remove hash page spin lock
  fs: add FS_XFLAG_VERITY for verity files
  fsverity: pass log_blocksize to end_enable_verity()
  fsverity: support block-based Merkle tree caching
  fsverity: calculate readahead in bytes instead of pages
  fsverity: add tracepoints
  iomap: integrate fsverity verification into iomap's read path
  xfs: add XBF_VERITY_SEEN xfs_buf flag
  xfs: add XFS_DA_OP_BUFFER to make xfs_attr_get() return buffer
  xfs: introduce workqueue for post read IO work
  xfs: add attribute type for fs-verity
  xfs: make xfs_buf_get() to take XBF_* flags
  xfs: add XBF_DOUBLE_ALLOC to increase size of the buffer
  xfs: add fs-verity ro-compat flag
  xfs: add inode on-disk VERITY flag
  xfs: initialize fs-verity on file open and cleanup on inode
    destruction
  xfs: don't allow to enable DAX on fs-verity sealsed inode
  xfs: disable direct read path for fs-verity files
  xfs: add fs-verity support
  xfs: make scrub aware of verity dinode flag
  xfs: add fs-verity ioctls
  xfs: enable ro-compat fs-verity flag

 Documentation/filesystems/fsverity.rst |  12 +
 fs/btrfs/verity.c                      |   4 +-
 fs/erofs/data.c                        |   4 +-
 fs/ext4/verity.c                       |   3 +-
 fs/f2fs/verity.c                       |   3 +-
 fs/gfs2/aops.c                         |   4 +-
 fs/ioctl.c                             |  11 +
 fs/iomap/buffered-io.c                 | 102 +++++++-
 fs/verity/enable.c                     |   9 +-
 fs/verity/fsverity_private.h           |  30 ++-
 fs/verity/init.c                       |   1 +
 fs/verity/open.c                       |   9 +-
 fs/verity/read_metadata.c              |  48 ++--
 fs/verity/signature.c                  |   2 +
 fs/verity/verify.c                     | 315 +++++++++++++++-------
 fs/xfs/Makefile                        |   2 +
 fs/xfs/libxfs/xfs_attr.c               |  31 ++-
 fs/xfs/libxfs/xfs_attr.h               |   3 +-
 fs/xfs/libxfs/xfs_attr_leaf.c          |  24 +-
 fs/xfs/libxfs/xfs_attr_remote.c        |  39 ++-
 fs/xfs/libxfs/xfs_da_btree.h           |   5 +-
 fs/xfs/libxfs/xfs_da_format.h          |  68 ++++-
 fs/xfs/libxfs/xfs_format.h             |  14 +-
 fs/xfs/libxfs/xfs_log_format.h         |   2 +
 fs/xfs/libxfs/xfs_ondisk.h             |   4 +
 fs/xfs/libxfs/xfs_parent.c             | 113 ++++++++
 fs/xfs/libxfs/xfs_parent.h             |  19 ++
 fs/xfs/libxfs/xfs_sb.c                 |   4 +-
 fs/xfs/scrub/attr.c                    |   4 +-
 fs/xfs/xfs_aops.c                      |  15 +-
 fs/xfs/xfs_attr_item.c                 |   6 +-
 fs/xfs/xfs_attr_list.c                 |  14 +-
 fs/xfs/xfs_buf.c                       |   6 +-
 fs/xfs/xfs_buf.h                       |  23 +-
 fs/xfs/xfs_file.c                      |  23 +-
 fs/xfs/xfs_inode.c                     |   2 +
 fs/xfs/xfs_inode.h                     |   3 +-
 fs/xfs/xfs_ioctl.c                     |  22 ++
 fs/xfs/xfs_iops.c                      |   4 +
 fs/xfs/xfs_linux.h                     |   1 +
 fs/xfs/xfs_mount.h                     |   3 +
 fs/xfs/xfs_super.c                     |  19 ++
 fs/xfs/xfs_trace.h                     |   4 +-
 fs/xfs/xfs_verity.c                    | 348 +++++++++++++++++++++++++
 fs/xfs/xfs_verity.h                    |  33 +++
 fs/xfs/xfs_xattr.c                     |  10 +
 fs/zonefs/file.c                       |   4 +-
 include/linux/fsverity.h               |  73 +++++-
 include/linux/iomap.h                  |   6 +-
 include/trace/events/fsverity.h        | 184 +++++++++++++
 include/uapi/linux/fs.h                |   1 +
 51 files changed, 1494 insertions(+), 199 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_parent.c
 create mode 100644 fs/xfs/libxfs/xfs_parent.h
 create mode 100644 fs/xfs/xfs_verity.c
 create mode 100644 fs/xfs/xfs_verity.h
 create mode 100644 include/trace/events/fsverity.h

-- 
2.42.0

