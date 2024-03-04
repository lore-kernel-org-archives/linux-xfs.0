Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 103C078B6C
	for <linux-xfs@vger.kernel.org>; Mon,  4 Mar 2024 19:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709579539; cv=none; b=Hqcf/WAiZPohqdXCidBri1AfJYOF+LSSFS06uxlrhcn6oR4sFBz0XfM2Y1CJGW/ahRfy+7igowkJnW7m00vP6T93VYQXIZ0IzCd+fHU+R967FTe01QtlR/zxt/e2LGHbbesfLykIfnSj/KcIxKTipCeNunEbv38ZC1ugYhXK4Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709579539; c=relaxed/simple;
	bh=b716iRld+aBnMeeLJlE9iVTKBwA95x3WGvcsShnKQ4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eljrmNMR5anpfY2R1TaGpE5RlM+hEVP9FzoII1JBAvLnQHIM/qCfOB+pTZUidzeTbuDywW2BP1ad1qEjiTMQDBwNpi0MqelUL4hvNSUqnaXmM+vVG5wM7qQH82BBR9Chcbk1i6YKCCCv7R6aBrG795S6x8n0aDUBHjdjM1a4boQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M9IQTJ68; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M9IQTJ68"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709579535;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=9rvY9NAnktd7qrJBPND0eU4Bzb1qb3lS3RyMgKXjGL4=;
	b=M9IQTJ68XYk0n4ZriV6nOiPGGpZJ0jJjB/cRyV7+bJE3IjZpiiRUmwAT0LaBzi2dBIPeE+
	ZCxvrNt4gPDO2Ge0xcnwT8iq6Fo1C0B/SoQh3YrsXC6iidmJfCNbF+syAc5HSEzf9+XhQe
	75Us1EQ2zVmvPXIjznIFhsCffq9LtUQ=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-248-6Jx3gOUAMx2ULRHkztRI4w-1; Mon, 04 Mar 2024 14:12:12 -0500
X-MC-Unique: 6Jx3gOUAMx2ULRHkztRI4w-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a35ef7abe08so351799866b.2
        for <linux-xfs@vger.kernel.org>; Mon, 04 Mar 2024 11:12:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709579531; x=1710184331;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9rvY9NAnktd7qrJBPND0eU4Bzb1qb3lS3RyMgKXjGL4=;
        b=NyQl/KQzXjxKttbTEqtn9RPZXivBSzABSLoQzvIb75usTPqxxtoVpqwQt0LnfSd9Il
         GwGmlcH7cc2cOMS5/LaDvA5Z+ZRD5SwoxFTAXsOGLxO4cTwBA+5B+2pEcFY4FjRg9bA1
         Mlqn6lDZ8ehAK4zlY7aTRIan7lmJPvdXOzoN4AZvUhc3/4BitSSN2Q2DbM3ZhkSHlDWh
         b7yKOpv/QE7OZQhqE+JLoceVYl/192LkQUPtSiy8gG1RtxSmN+I/y6LMglhnYMczW7r0
         hV0tBu88ynNSPUKilbZug9aoboGuUpQJTZh4299xvhrgqsUxgCPvZAdBNYYgbFcd9byv
         Fj7A==
X-Forwarded-Encrypted: i=1; AJvYcCXuDQQ/H+0PAcrz3DWni+dSmFSCHHK+G5I0jJOt0dg1V7TooRRMWPiNH7+mnQ8B6BLzezE1oLnefG7vVJwFB2prtlVC/1Yqa7fN
X-Gm-Message-State: AOJu0YxxdyXTvei0bU+gFgNa+0O1UWznZ9umd/85oI2Y0ICvWlXb8ipk
	01FEpIv63ongIgy6wU+olGqefHCbwNqailvOY1ujZuo+dl3y/1GbuMiB3Qr+NnK7cNahU6M8mEo
	FMTauNORTgsAAU1YFIhZtxxcVxIKduONPmyz8/GbH3ww2s5+6WpmvdtOl
X-Received: by 2002:a17:906:ca55:b0:a44:7a25:736e with SMTP id jx21-20020a170906ca5500b00a447a25736emr6600727ejb.27.1709579531338;
        Mon, 04 Mar 2024 11:12:11 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGLrKjot8O9tItCOwisX+Rpbi8SoT4XpvmbEPdj84ymD6Chc8jK8Q3hrIr9DvC3L0PmBOpnZA==
X-Received: by 2002:a17:906:ca55:b0:a44:7a25:736e with SMTP id jx21-20020a170906ca5500b00a447a25736emr6600706ejb.27.1709579530649;
        Mon, 04 Mar 2024 11:12:10 -0800 (PST)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id a11-20020a1709064a4b00b00a44a04aa3cfsm3783319ejv.225.2024.03.04.11.12.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Mar 2024 11:12:10 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: fsverity@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	chandan.babu@oracle.com,
	djwong@kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v5 00/24] fs-verity support for XFS
Date: Mon,  4 Mar 2024 20:10:23 +0100
Message-ID: <20240304191046.157464-2-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

Here's v5 of my patchset of adding fs-verity support to XFS.

This implementation uses extended attributes to store fs-verity
metadata. The Merkle tree blocks are stored in the remote extended
attributes. The names are offsets into the tree.

A few key points of this patchset:
- fs-verity can work with Merkle tree blocks based caching (xfs) and
  PAGE caching (ext4, f2fs, btrfs)
- iomap does fs-verity verification
- In XFS, fs-verity metadata is stored in extended attributes
- per-sb workqueue for verification processing
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
- [11-24]: Add fs-verity support to XFS

Testing:
The patchset is tested with xfstests -g verity on xfs_1k, xfs_4k,
xfs_1k_quota, xfs_4k_quota, ext4_4k, and ext4_4k_quota. With
KMEMLEAK and KASAN enabled. More testing on the way.

Changes from V4:
- Mainly fs-verity changes; removed unnecessary functions
- Replace XFS workqueue with per-sb workqueue created in
  fsverity_set_ops()
- Drop patch with readahead calculation in bytes
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
[1]: https://github.com/alberand/linux/tree/fsverity-v5

xfsprogs:
[2]: https://github.com/alberand/xfsprogs/tree/fsverity-v5

xfstests:
[3]: https://github.com/alberand/xfstests/tree/fsverity-v5

v1:
[4]: https://lore.kernel.org/linux-xfs/20221213172935.680971-1-aalbersh@redhat.com/

v2:
[5]: https://lore.kernel.org/linux-xfs/20230404145319.2057051-1-aalbersh@redhat.com/

v3:
[6]: https://lore.kernel.org/all/20231006184922.252188-1-aalbersh@redhat.com/

v4:
[7]: https://lore.kernel.org/linux-xfs/20240212165821.1901300-1-aalbersh@redhat.com/

fs-verity:
[7]: https://www.kernel.org/doc/html/latest/filesystems/fsverity.html

Thanks,
Andrey

Allison Henderson (3):
  xfs: add parent pointer support to attribute code
  xfs: define parent pointer ondisk extended attribute format
  xfs: add parent pointer validator functions

Andrey Albershteyn (21):
  fsverity: remove hash page spin lock
  fs: add FS_XFLAG_VERITY for verity files
  fsverity: pass tree_blocksize to end_enable_verity()
  fsverity: support block-based Merkle tree caching
  fsverity: add per-sb workqueue for post read processing
  fsverity: add tracepoints
  iomap: integrate fs-verity verification into iomap's read path
  xfs: add XBF_VERITY_SEEN xfs_buf flag
  xfs: add XFS_DA_OP_BUFFER to make xfs_attr_get() return buffer
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

 Documentation/filesystems/fsverity.rst |   8 +
 MAINTAINERS                            |   1 +
 fs/btrfs/verity.c                      |   4 +-
 fs/ext4/verity.c                       |   3 +-
 fs/f2fs/verity.c                       |   3 +-
 fs/ioctl.c                             |  11 +
 fs/iomap/buffered-io.c                 |  92 ++++++-
 fs/super.c                             |   7 +
 fs/verity/enable.c                     |   9 +-
 fs/verity/fsverity_private.h           |  11 +-
 fs/verity/init.c                       |   1 +
 fs/verity/open.c                       |   9 +-
 fs/verity/read_metadata.c              |  64 +++--
 fs/verity/signature.c                  |   2 +
 fs/verity/verify.c                     | 180 +++++++++----
 fs/xfs/Makefile                        |   2 +
 fs/xfs/libxfs/xfs_attr.c               |  31 ++-
 fs/xfs/libxfs/xfs_attr.h               |   3 +-
 fs/xfs/libxfs/xfs_attr_leaf.c          |  24 +-
 fs/xfs/libxfs/xfs_attr_remote.c        |  39 ++-
 fs/xfs/libxfs/xfs_btree_mem.c          |   2 +-
 fs/xfs/libxfs/xfs_da_btree.h           |   5 +-
 fs/xfs/libxfs/xfs_da_format.h          |  68 ++++-
 fs/xfs/libxfs/xfs_format.h             |  14 +-
 fs/xfs/libxfs/xfs_log_format.h         |   2 +
 fs/xfs/libxfs/xfs_ondisk.h             |   4 +
 fs/xfs/libxfs/xfs_parent.c             | 113 ++++++++
 fs/xfs/libxfs/xfs_parent.h             |  19 ++
 fs/xfs/libxfs/xfs_sb.c                 |   4 +-
 fs/xfs/scrub/attr.c                    |   4 +-
 fs/xfs/xfs_attr_item.c                 |   6 +-
 fs/xfs/xfs_attr_list.c                 |  14 +-
 fs/xfs/xfs_buf.c                       |   6 +-
 fs/xfs/xfs_buf.h                       |  23 +-
 fs/xfs/xfs_file.c                      |  23 +-
 fs/xfs/xfs_inode.c                     |   2 +
 fs/xfs/xfs_inode.h                     |   3 +-
 fs/xfs/xfs_ioctl.c                     |  22 ++
 fs/xfs/xfs_iops.c                      |   4 +
 fs/xfs/xfs_mount.h                     |   2 +
 fs/xfs/xfs_super.c                     |  12 +
 fs/xfs/xfs_trace.h                     |   4 +-
 fs/xfs/xfs_verity.c                    | 355 +++++++++++++++++++++++++
 fs/xfs/xfs_verity.h                    |  33 +++
 fs/xfs/xfs_xattr.c                     |  10 +
 include/linux/fs.h                     |   2 +
 include/linux/fsverity.h               |  91 ++++++-
 include/trace/events/fsverity.h        | 181 +++++++++++++
 include/uapi/linux/fs.h                |   1 +
 49 files changed, 1395 insertions(+), 138 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_parent.c
 create mode 100644 fs/xfs/libxfs/xfs_parent.h
 create mode 100644 fs/xfs/xfs_verity.c
 create mode 100644 fs/xfs/xfs_verity.h
 create mode 100644 include/trace/events/fsverity.h

-- 
2.42.0

