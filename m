Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFEFD2144C7
	for <linux-xfs@vger.kernel.org>; Tue, 30 Dec 2025 17:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767115251; cv=none; b=Cka+QbOBkQbtqEduAo66Y3+XQsktdCK7Dc+rBpSdV3W3VrV19UaiK+X5V9WSCX8FQpO5njwTfhuCTWxJO0ocLUXbP4qe2Sf8NQ8kMf1JsJ1U6kSskqcTunuEwJUSRjQqRfNnEf+Ivz+HRR5nxDEPcx2LISBjRwO4tJtdInqiJu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767115251; c=relaxed/simple;
	bh=MN6VvxEdSO3vfduDKrYihNJO36W73LeS1f9FWv/eSOA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=nQRBz9+wfWZ6jAADxsmvlE92rP2/2KCZIVYgm8Dqix4JU9UkvTLDu18297neb6B0GEw2LrfIuEe9b55K/ESIrj8CRbb958UAHiOo3cXeSkB+973xD++TQFJdupA71a+BEfXQmYL3h36gpmpnRnIYKkjqji62GCPqRvpxey+EnTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J2RD1Sc5; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=JKjr8zXO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J2RD1Sc5";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="JKjr8zXO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767115248;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=BctC9kz5mxOcOfEVxeZwH7ge1FfG9vA7gzUyXP7v8EM=;
	b=J2RD1Sc53lNKNdto66ImjYdC141p4ZSbNJ3Zfy8XGlFL/LYlZQCmbNE2ANurrWOpqRfPme
	IZJqW6pVlgMnrz85EejIqbsE7XNl4aZVVGQQEca0799Rjfv2N9Cb3+q65hyBy4M4xaAjRG
	ysp6iMfcQdTqrLV/PZv3jWgH9pPifrU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-653-P8-OsCS0N92Ab4k0czc52w-1; Tue, 30 Dec 2025 12:20:47 -0500
X-MC-Unique: P8-OsCS0N92Ab4k0czc52w-1
X-Mimecast-MFC-AGG-ID: P8-OsCS0N92Ab4k0czc52w_1767115246
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-430f527f5easo6044979f8f.1
        for <linux-xfs@vger.kernel.org>; Tue, 30 Dec 2025 09:20:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767115246; x=1767720046; darn=vger.kernel.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BctC9kz5mxOcOfEVxeZwH7ge1FfG9vA7gzUyXP7v8EM=;
        b=JKjr8zXOhWnyhSjrVE9c6wirx4kehQS0AbkIJznFrhGZWXPsQl1Bp7bbVotDqIS3NB
         kuJe2dWQCDrEQHLQUokbfqQheyR6GInzFjyO0hCX4KOksxfblbEEJHcyKx3pBrlyW7Eo
         VvX3IG+Xue3pMPW0NhTJ6XGSKvfZWxXggdBzzUFf8feSX3IPk5UBwF4clKKjRFG20kX2
         NXQWGhh3nFzw2QfKq8oxY7A6nVN1j3C/bECqrlhlsR0ytoO4auviLLE/l/Cu30pbI43x
         uKokzp7FmsH4ti2zRKl1KvvndtPoqk7pvdozjwAL2WBMTCsvcJPjS9Mg4pupn7qiorkC
         bwnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767115246; x=1767720046;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BctC9kz5mxOcOfEVxeZwH7ge1FfG9vA7gzUyXP7v8EM=;
        b=dpJtQBsvtpGulUbu7d+hWaj3kxErwZyb+MB6ZrIUNQATwR+xHMttX3N46Ym6fcMPim
         LfEV9+WZOp++j/9NpWzISJUzUKoOthCd1u8YQQUJt6BxRqXbmpo4qQkJHyVUBst6oieY
         Dv8Mvklh17bphIAl1tg0AvMzQlZj5BfWxaww2XwW7FuyYhrdZ0s/NxGTJ902AJ6gMLfh
         jMT+hYLFo7UM/rF/8gGAhIEnGv+Hv6TWROkc/w8JdM2a4XqBwAVDvnhBafBaN1yxbc3q
         3bPdx2zlryFEi7nYfqJgs3YSS3ZuLhTYrd+acu3Kd+yTus7mL4SXxqFdr6BWjWvbrb+P
         ZdFA==
X-Gm-Message-State: AOJu0YwVaDy6FqLzkLVg686bPl+Z+EmJNbp1ztgftTC1OtxS0Be1hvuG
	uuvBX34P5Vv77k9a/qNFmsdbjwqo/sEnKvsrmO68lO87d26KceRyG2nVgG2LlyXBsQYVtjnBHxV
	SZZcVVa5wBWq4Bd+P6WVtnUP5sNhBVS8xcBxKhU1HQj7TLAlNOoCBtVLa1ylWAyQUk6Knh3dVnB
	6WU7fcD21M7tHtbePJOQcQR0yQ8YRUh6SAyyOvV0vaGQs0
X-Gm-Gg: AY/fxX7E/Ye8XdY5wvp4MWYIAGb2+en7gILem8RUWgYFSazxqG0ROkMKZq0bhkR25Xp
	/mO8UxekJ/FDPbru4AFvpRH7osvAJoJkk7pNc8vxZMDc6p91GExWQHMFSz/cOiCd9dFHN94xFIi
	Cf3ifi9SUXy0ECOIZ5Wag1dUEWb0ebNH0Y1xWjDewg8IAIwQat4bIxboto2Q+cBEY69cAdMWr24
	s3cEP7NuL7iS/RSBLXpYHq3jKUM7ZkQOaVKKsmVNn2ndA36Mpo1ptBi8T5GhB/EOxNT7Hv2mwmu
	PnzIzIyDF3O69hBjcVDW80P/0SMj36r4E9qMjmmLMEZ9TutJAnb2/VM6BUohS2wCwMWWZSdxRkL
	HKg==
X-Received: by 2002:a05:6000:18a8:b0:430:f16b:d8cc with SMTP id ffacd0b85a97d-43244795353mr44619973f8f.3.1767115245705;
        Tue, 30 Dec 2025 09:20:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFY7wdjtfIYsxPhgx81XYyht5cuZw2fQQ1BCzTCr8tDwsR1LTl35BGKR6Urw9ZY3Q7gi8Ifkw==
X-Received: by 2002:a05:6000:18a8:b0:430:f16b:d8cc with SMTP id ffacd0b85a97d-43244795353mr44619925f8f.3.1767115245104;
        Tue, 30 Dec 2025 09:20:45 -0800 (PST)
Received: from thinky ([91.245.205.131])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43277b0efefsm36410743f8f.25.2025.12.30.09.20.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 09:20:44 -0800 (PST)
Date: Tue, 30 Dec 2025 18:20:43 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org, arekm@maven.pl, cem@kernel.org, 
	chandanbabu@kernel.org, cmaiolino@redhat.com, david@fromorbit.com, djwong@kernel.org, 
	dlemoal@kernel.org, hans.holmberg@wdc.com, hch@lst.de, hubjin657@outlook.com, 
	linux-xfs@vger.kernel.org, luca.dimaio1@gmail.com, preichl@redhat.com, torsten.rupp@gmx.net
Subject: [ANNOUNCE] xfsprogs: v6.18.0 released
Message-ID: <jzrly2kwodtwgrwltlkhsskoprvi5prntfcfmgbkktmzgsymnm@sggavy2z7uon>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi folks,

The xfsprogs master branch in repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Release notes:
- Enable parent pointer by default in mkfs
- Add 6.18 2025 LTS config file
- Refactoring of the discard and reset zones code in mkfs allowing skipping discard
  of data section for zoned fs.
- Refactoring of error tags for easier code maintainability
- Refactoring of logprint code
- Refactoring of libxfs to get rid of typedef's
- Fix file descriptor leak in mkfs proto
- Fix double cache allocation/destruction in libxfs
- Fix zone capacity check for sequential zones
- Fix array overflow in xfs_metadump
- Fix null pointer in xfs_scrub (found by generic/453 and generic/454)
- Fix "no previous prototype" build warning in libxfs
- Fix incorrect FS_IOC_FSSETXATTR argument to ioctl() in xfs_quota
- Fix failing length check in xfs_mdrestore on little-endian arch's
- Fix xfs_logprint incorrect pointer introduced by refactoring
- Fix RT device size in zoned filesystem on conventional devices in mkfs

Patches often get missed, so if your outstanding patches are properly reviewed
on the list and not included in this update, please let me know.

The for-next branch has also been updated to match the state of master.

The new head of the master branch is commit:

8b892adad226bb9fef4009c4cba4dbc25b70b011

New commits:

Andrey Albershteyn (13):
      [9ad52fc99722] xfs: centralize error tag definitions
      [fc064b0eaee3] xfs: convert xfs_buf_log_format_t typedef to struct
      [69a385f4d85d] xfs: convert xlog_op_header_t typedef to struct
      [9ea0f7182fa9] xfs: convert xfs_trans_header_t typdef to struct
      [6488dabd357f] xfs: convert xfs_log_iovec_t typedef to struct
      [5fb2bdf25c18] xfs: convert xfs_qoff_logformat_t typedef to struct
      [1fb674606f0f] xfs: convert xfs_dq_logformat_t typedef to struct
      [073e7103df19] xfs: convert xfs_efi_log_format typedef to struct
      [2712027253b8] xfs: convert xfs_efd_log_format_t typedef to struct
      [22f016f8365d] xfs: convert xfs_efi_log_format_32_t typedef to struct
      [9f37e5d1ad4e] xfs: convert xfs_extent_t typedef to struct
      [aab512e0fd58] xfs: convert xfs_efi_log_format_64_t typedef to struct
      [8b892adad226] xfsprogs: Release v6.18.0

Arkadiusz Miśkiewicz (1):
      [3147d1d643c8] libfrog: fix incorrect FS_IOC_FSSETXATTR argument to ioctl()

Carlos Maiolino (2):
      [d7c096df3e8c] mkfs: fix zone capacity check for sequential zones
      [2a30566311e6] metadump: catch used extent array overflow

Chandan Babu R (2):
      [9a79db51caca] libfrog: Prevent unnecessary waking of worker thread when using bounded workqueues
      [17aa67421d0e] repair/prefetch.c: Create one workqueue with multiple workers

Christoph Hellwig (57):
      [a5523d4575bb] xfs_copy: improve the error message when mkfs is in progress
      [74274e6e61a1] mkfs: improve the error message from check_device_type
      [42fffb1475e3] mkfs: improve the error message in adjust_nr_zones
      [586ee95d8098] mkfs: move clearing LIBXFS_DIRECT into check_device_type
      [8d1b3cc5e1c8] libxfs: cleanup get_topology
      [8d8ba5006e3e] mkfs: remove duplicate struct libxfs_init arguments
      [75bbfce9dd3e] mkfs: split zone reset from discard
      [d6d78495a0c8] xfs_io: use the XFS_ERRTAG macro to generate injection targets
      [44df5a636d14] include: remove struct xfs_qoff_logitem
      [1fc548d023e3] logprint: remove xlog_print_dir2_sf
      [9d0613372d04] logprint: re-indent printing helpers
      [b8f52c536a3b] logprint: cleanup xlog_print_op_header
      [313bee27831c] logprint: cleanup struct xlog_split_item handling
      [22ed13ab1df5] logprint: cleanup xlog_print_trans_header
      [d490c90209e2] logprint: split per-type helpers out of xlog_print_trans_buffer
      [6c63115825f5] logprint: cleanup xlog_print_trans_buffer
      [36609bf8b1a6] logprint: cleanup xlog_print_trans_qoff
      [27db768bb42b] logprint: cleanup xlog_print_trans_inode_core
      [17da769c68e2] logprint: move xfs_inode_item_format_convert up
      [9ac25410e58a] logprint: cleanup xlog_print_trans_inode
      [2cfcbfcd9246] logprint: cleanup xlog_print_trans_dquot
      [78e497ff5be0] logprint: re-indent print_lseek / print_lsn
      [63fb14009944] logprint: factor out a xlog_print_process_region helper
      [5a9b7e951408] logprint: factor out a xlog_print_op helper
      [330dca0684fd] logprint: factor out a xlog_unpack_rec_header
      [32fdf169c9b2] logprint: cleanup xlog_print_record
      [9c822727890c] logprint: cleanup xlog_print_rec_head
      [71181d6ad2d7] logprint: cleanup xlog_print_rec_xhead
      [19225ac58999] logprint: re-indent print_xlog_bad_*
      [6bcb161d2233] logprint: cleanup xlog_reallocate_xhdrs
      [1bb5252fe6eb] logprint: factor out a xlog_print_ext_header helper
      [99ae97b6f8d4] logprint: cleanup xlog_print_extended_headers
      [1dc2075c2199] logprint: cleanup xfs_log_print
      [aa68656da248] xfs: remove the xlog_op_header_t typedef
      [ea57d274ccb6] xfs: remove the xfs_trans_header_t typedef
      [21880e6e25dd] xfs: remove the xfs_extent_t typedef
      [6dafb1681672] xfs: remove the xfs_extent32_t typedef
      [55ba59ba4d10] xfs: remove the xfs_extent64_t typedef
      [9d5f25fd58ea] xfs: remove the xfs_efi_log_format_t typedef
      [68b3953dae90] xfs: remove the xfs_efi_log_format_32_t typedef
      [18031671eacb] xfs: remove the xfs_efi_log_format_64_t typedef
      [5384c05c66e9] xfs: remove the xfs_efd_log_format_t typedef
      [24168e1337c9] xfs: remove the unused xfs_efd_log_format_32_t typedef
      [ad773facd36b] xfs: remove the unused xfs_efd_log_format_64_t typedef
      [68b1a66ff986] xfs: remove the unused xfs_buf_log_format_t typedef
      [d8821a4de913] xfs: remove the unused xfs_dq_logformat_t typedef
      [ed1fd5024a5b] xfs: remove the unused xfs_qoff_logformat_t typedef
      [8a877bb9bf07] xfs: remove the unused xfs_log_iovec_t typedef
      [fb0b6eafa5c4] xfs: fix log CRC mismatches between i386 and other architectures
      [6598addaef1e] xfs: move the XLOG_REG_ constants out of xfs_log_format.h
      [62fefd9888b9] xfs: remove the expr argument to XFS_TEST_ERROR
      [eb1e9586ee67] xfs: prevent gc from picking the same zone twice
      [0c6d67befe98] repair: add a enum for the XR_INO_* values
      [5d157c568e3d] repair: add canonical names for the XR_INO_ constants
      [a439b4155fd5] repair: factor out a process_dinode_metafile helper
      [f4b5df44edd8] repair: enhance process_dinode_metafile
      [b5d372d96db1] mkfs: adjust_nr_zones for zoned file system on conventional devices

Damien Le Moal (1):
      [cab8d3d9f493] xfs: improve default maximum number of open zones

Darrick J. Wong (9):
      [b1b0f1a507b3] xfs_scrub: fix null pointer crash in scrub_render_ino_descr
      [050f309cb853] libxfs: fix build warnings
      [6743140685dd] xfs_db: document the rtsb command
      [f274ed718111] man2: fix getparents ioctl manpage
      [7d00aed6e308] xfs: remove deprecated mount options
      [4b08d653fb25] xfs: remove deprecated sysctl knobs
      [54aad16b4b9b] mkfs: enable new features by default
      [fe1591e7d03c] mkfs: add 2025 LTS config file
      [20796eec31f8] xfs_logprint: fix pointer bug

Luca Di Maio (2):
      [01c46f93ffcd] proto: fix file descriptor leak
      [4a54700b4385] libxfs: support reproducible filesystems using deterministic time/seed

Pavel Reichl (1):
      [98f05de13e78] mdrestore: fix restore_v2() superblock length check

Torsten Rupp (1):
      [ac7ab8b0b80b] Fix alloc/free of cache item

Code Diffstat:

 VERSION                         |    2 +-
 configure.ac                    |    2 +-
 copy/xfs_copy.c                 |    2 +-
 db/metadump.c                   |   27 +-
 debian/changelog                |    6 +
 doc/CHANGES                     |   30 +
 include/linux.h                 |    2 +-
 include/xfs_trans.h             |    8 +-
 io/inject.c                     |  108 +-
 libfrog/file_attr.c             |    2 +-
 libfrog/workqueue.c             |    4 -
 libxfs/defer_item.c             |    2 +-
 libxfs/init.c                   |    4 -
 libxfs/libxfs_priv.h            |    2 +-
 libxfs/rdwr.c                   |    4 +-
 libxfs/topology.c               |    9 +-
 libxfs/topology.h               |    7 +-
 libxfs/util.c                   |  124 +-
 libxfs/xfs_ag_resv.c            |    7 +-
 libxfs/xfs_alloc.c              |    5 +-
 libxfs/xfs_attr_leaf.c          |   25 +-
 libxfs/xfs_bmap.c               |   31 +-
 libxfs/xfs_btree.c              |    2 +-
 libxfs/xfs_da_btree.c           |    2 +-
 libxfs/xfs_dir2.c               |    2 +-
 libxfs/xfs_errortag.h           |  114 +-
 libxfs/xfs_exchmaps.c           |    4 +-
 libxfs/xfs_ialloc.c             |    6 +-
 libxfs/xfs_inode_buf.c          |    4 +-
 libxfs/xfs_inode_fork.c         |    3 +-
 libxfs/xfs_inode_util.c         |   11 -
 libxfs/xfs_log_format.h         |  150 ++-
 libxfs/xfs_log_recover.h        |    2 +-
 libxfs/xfs_metafile.c           |    2 +-
 libxfs/xfs_ondisk.h             |    2 +
 libxfs/xfs_refcount.c           |    7 +-
 libxfs/xfs_rmap.c               |    2 +-
 libxfs/xfs_rtbitmap.c           |    2 +-
 libxfs/xfs_rtgroup.h            |    6 +
 libxfs/xfs_sb.c                 |    9 +-
 libxfs/xfs_zones.h              |    7 +
 libxlog/xfs_log_recover.c       |   20 +-
 logprint/log_misc.c             | 2558 ++++++++++++++++++++-------------------
 logprint/log_print_all.c        |   14 +-
 logprint/log_redo.c             |   89 +-
 logprint/logprint.h             |    2 +-
 man/man2/ioctl_xfs_getparents.2 |    2 +-
 man/man8/xfs_db.8               |    4 +
 mdrestore/xfs_mdrestore.c       |    2 +-
 mkfs/Makefile                   |    3 +-
 mkfs/lts_6.18.conf              |   19 +
 mkfs/proto.c                    |    1 +
 mkfs/xfs_mkfs.c                 |  260 ++--
 repair/dinode.c                 |  300 +++--
 repair/incore.h                 |   19 -
 repair/prefetch.c               |   10 +-
 repair/sb.c                     |    3 +-
 scrub/common.c                  |   11 +-
 58 files changed, 2110 insertions(+), 1957 deletions(-)
 create mode 100644 mkfs/lts_6.18.conf

-- 
- Andrey

