Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF9923A58B
	for <linux-xfs@vger.kernel.org>; Tue, 24 Jun 2025 13:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750771888; cv=none; b=Jgq2AFLCwGopW/5iUiMKRM46VkRK7i5p7vPR8v8A6+6S3ToHzP7DKvKh12RJC3tY2HRqx9Fk9ixzFcbStxSPjhYXP8ODtdepcRi+4mxFiMOWr9DNcbRujIelAse1qcylS1tvQb17+qpX0fURt255d5yPR4cNtsqvTYS40B4uFck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750771888; c=relaxed/simple;
	bh=NhuOmULemPMtdxKFQIKJrjBaICk9ba159znr5+QFVjE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=soy/dN0L3YA0edaer3kzVrmSqDCDsZkH7GLzkaYgsCvgHrgjFNdqdIRgTYPFTqGh1KioFBHOLDo2S6XBJiOovXsJ414Rt0Ko/yWmwm6aWNlul1Iw52wAElk3HQbRYoeW2u8OvbpQ+kMmC8GnCdatG1cy7omt6JgAg/oBmQwRi0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MmDo9yv2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MmDo9yv2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750771885;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=OYoJcL0cbREv2fbrTVLhP+vvAsmwiOOJNDKsT7uDLsM=;
	b=MmDo9yv2g9j8ZgvJiiG9h73UrmO74QQ/0ifVCWQfCQsZmBRl0lY18Z2jeK9UMkNDPkP24p
	mw9XxunSlij1ceAgZlCgXrOLkX5wlRdMBtfF4lPqNmUB5y3nV0tqFuPdvUtE7I+fJwN+qv
	933f310bYousSkJ5/qDZyVxLwDdq7EI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-142-kwjIJmkvOaWl96td4UTACg-1; Tue, 24 Jun 2025 09:31:23 -0400
X-MC-Unique: kwjIJmkvOaWl96td4UTACg-1
X-Mimecast-MFC-AGG-ID: kwjIJmkvOaWl96td4UTACg_1750771882
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a4f6ff23ccso308486f8f.2
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jun 2025 06:31:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750771881; x=1751376681;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OYoJcL0cbREv2fbrTVLhP+vvAsmwiOOJNDKsT7uDLsM=;
        b=ra1HhcxQ6A+p4vFbCxSbvqs4VsOoVzspYIImRhycZRAAqAl8QaP0EFdWo5Rhyqkbqn
         TIxoJkYpNxea+DiQ2AQEMumpyRgBeqOr7jMMX1stWt6uH10gXydHemKKqzQ5KBdYXj9s
         xW6ZlnHSs8CLY+5GtYi4gDjUEVSwZe8N570Xwkxs3wz5RZ67JMXGtthotaBILs3r6btP
         Mt67Rhtg0cl0RN7DbflK2Y75Adyr3b872xhsaRqNotQiU8HzTAe1Ii3HPJ2m/HJM3v23
         P0Q/+EGVt1/h7wcdbHINY/5w7+jIStdkPl+vyuSV66T9FC0J1hZih2nr8f4U5ovki+H2
         aPrQ==
X-Gm-Message-State: AOJu0YzLqEQ2H89A/aSRrSAF8IpQHqDs3KaFWXMXRLsQPM5MXRSrehLi
	U6h3SAn1+FTHSpYkC1aavOw+ELRjKfSMhlR3nCUQDyF/X63lJjlExO5N+ST37HKV69Bc+aM8wMg
	KydrtoQ7/FuVOIwbFlWyVIcMQVLW/l5dTx3owbb2nMLKryR5Q1cG+ZBk2JYUY+GI7fSTjW/eHOW
	TjfCCg/TI6YuiN/r09f715nz4CHp3CeAsMr21x+wmsh1rI
X-Gm-Gg: ASbGncv4NZ0l0QLnMzmF4hwW8Qv2xDyO3Qj+4gGlaxsNAz2zH6CEB+lBb/RMk7/AgCw
	NESqNdSVLjqYmMaL1LWf+CNpD+oRCRF8D3qfwZ6cHaYoCo3OXDD5JLs9ScjJ/lJvG9s8gwRUnCk
	y/hgTaUPGve31OUCTe1GVMuWq2qjJCsU8bCrPqs6FRgm7/Xn14dYjAPjY0TvKbAZo7wAjOrcRsG
	9Pw8zlsW9SF4YVjJfSGWPvKTMSi/lw0mVbiCadKN7fedDiMuJp9/VNt0H/0b5MV9ywS94HqXzO6
	0UaCogbkz4j0LyTq6/CwfcV7GAP1smP4yMtbB2JWYA==
X-Received: by 2002:a05:6000:2dc7:b0:39f:175b:a68d with SMTP id ffacd0b85a97d-3a6d12bb555mr13351387f8f.11.1750771881152;
        Tue, 24 Jun 2025 06:31:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGpOr3n1Gd55Irg3OR+0WMtcIWHXFqvp4WOTFOdFXZNCswCt/MSkA0SlXkMRt7lCfRFM6lCeg==
X-Received: by 2002:a05:6000:2dc7:b0:39f:175b:a68d with SMTP id ffacd0b85a97d-3a6d12bb555mr13351302f8f.11.1750771880423;
        Tue, 24 Jun 2025 06:31:20 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6e8051f58sm2030765f8f.12.2025.06.24.06.31.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 06:31:20 -0700 (PDT)
Date: Tue, 24 Jun 2025 15:31:19 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org, bodonnel@redhat.com, cem@kernel.org, 
	cmaiolino@redhat.com, dchinner@redhat.com, djwong@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, john.g.garry@oracle.com, linux-xfs@vger.kernel.org, 
	liuhuan01@kylinos.cn, luca.dimaio1@gmail.com, ritesh.list@gmail.com, 
	sandeen@redhat.com, sandeen@sandeen.net
Subject: [ANNOUNCE] xfsprogs: v6.15.0 released
Message-ID: <heflr7waa26pntvhgboskw3n65tewwyborgbl5k7ln6aucxpas@bkdmcvk32zzq>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

The xfsprogs master branch in repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed
on the list and not included in this update, please let me know.

The for-next branch has also been updated to match the state of master.

The new head of the master branch is commit:

d0884c436c82dddbf5f5ef57acfbf784ff7f7832

New commits:

Andrey Albershteyn (2):
      [03a824e42ad9] gitignore: update gitignore with python scripts
      [d0884c436c82] xfsprogs: Release v6.15.0

Bill O'Donnell (1):
      [140fd5b16357] xfs_repair: phase6: scan longform entries before header check

Christoph Hellwig (39):
      [91643efd0e4c] xfs: generalize the freespace and reserved blocks handling
      [7e427bb1b734] xfs: make metabtree reservations global
      [433f46a5b7d3] xfs: reduce metafile reservations
      [9b705e1a55aa] xfs: add a rtg_blocks helper
      [b5e9bf4ec26c] xfs: move xfs_bmapi_reserve_delalloc to xfs_iomap.c
      [5dc014c0672f] xfs: support XFS_BMAPI_REMAP in xfs_bmap_del_extent_delay
      [475b5c5cb22d] xfs: add a xfs_rtrmap_highest_rgbno helper
      [611ad47ee44b] xfs: define the zoned on-disk format
      [9840f7e09e2f] xfs: allow internal RT devices for zoned mode
      [be3bc69f4fee] xfs: export zoned geometry via XFS_FSOP_GEOM
      [554360cdc6e2] xfs: disable sb_frextents for zoned file systems
      [48ccc2459039] xfs: parse and validate hardware zone information
      [7681c8b64e81] xfs: add the zoned space allocator
      [d22f260a04fe] xfs: add support for zoned space reservations
      [d648bcdbbb87] xfs: implement zoned garbage collection
      [6b1ed216be17] xfs: enable fsmap reporting for internal RT devices
      [c035d90a655c] xfs: enable the zoned RT device feature
      [584e4dcd2357] xfs: support zone gaps
      [75808b660cb7] libfrog: report the zoned geometry
      [09836e4da195] xfs_repair: support repairing zoned file systems
      [049a4797a652] xfs_repair: fix the RT device check in process_dinode_int
      [ff6737fe5749] xfs_repair: validate rt groups vs reported hardware zones
      [b578151091ab] xfs_mkfs: factor out a validate_rtgroup_geometry helper
      [2e5a737a61d3] xfs_mkfs: support creating file system with zoned RT devices
      [b62352d0db16] xfs_mkfs: calculate zone overprovisioning when specifying size
      [308f80b53f5e] xfs_mkfs: default to rtinherit=1 for zoned file systems
      [a5142cfe6d1c] xfs_mkfs: reflink conflicts with zoned file systems for now
      [adec6f3afea2] xfs_mkfs: document the new zoned options in the man page
      [0dddd8096138] man: document XFS_FSOP_GEOM_FLAGS_ZONED
      [551948d6e6ea] xfs_io: correctly report RGs with internal rt dev in bmap output
      [5e169f3d0afe] xfs_io: don't re-query fs_path information in fsmap_f
      [fdbf36f53db3] xfs_io: handle internal RT devices in fsmap output
      [e741e275e9f2] xfs_spaceman: handle internal RT devices
      [37591ef3f4f1] xfs_scrub: support internal RT device
      [e21b93e8fa67] xfs_mdrestore: support internal RT devices
      [fd4eb274c828] xfs_growfs: support internal RT devices
      [94ef61b5bba0] xfs: kill XBF_UNMAPPED
      [9a6b49d23aaf] xfs: remove the flags argument to xfs_buf_get_uncached
      [1bee63ac33e4] xfs_mdrestore: don't allow restoring onto zoned block devices

Darrick J. Wong (7):
      [86e28b9548aa] man: fix missing cachestat manpage
      [95264b115d86] xfs_io: catch statx fields up to 6.15
      [077560c53953] xfs_io: redefine what statx -m all does
      [d6721943d668] xfs_io: make statx mask parsing more generally useful
      [044e134fffff] mkfs: fix blkid probe API violations causing weird output
      [72d5abe1d8c3] xfs_repair: fix libxfs abstraction mess
      [ec9909785b86] man: adjust description of the statx manpage

Eric Sandeen (1):
      [454fab69c484] xfs_repair: Bump link count if longform_dir2_rebuild yields shortform dir

Luca Di Maio (1):
      [6b66b1ab513f] xfs_protofile: fix permission octet when suid/guid is set

liuh (1):
      [81f646b0d6af] mkfs: fix the issue of maxpct set to 0 not taking effect

Code Diffstat:

 .gitignore                      |   5 +-
 VERSION                         |   2 +-
 configure.ac                    |   2 +-
 db/convert.c                    |   6 +-
 debian/changelog                |   6 +
 doc/CHANGES                     |  32 ++
 growfs/xfs_growfs.c             |   9 +-
 include/libxfs.h                |   6 +
 include/spinlock.h              |   5 +
 include/xfs_inode.h             |  12 +-
 include/xfs_mount.h             |  64 +++-
 io/bmap.c                       |  23 +-
 io/fsmap.c                      |  52 ++--
 io/stat.c                       | 130 +++++++-
 io/statx.h                      |  33 +-
 libfrog/fsgeom.c                |  24 +-
 libxfs/Makefile                 |   6 +-
 libxfs/init.c                   |  15 +-
 libxfs/libxfs_api_defs.h        |   1 +
 libxfs/libxfs_io.h              |   2 +-
 libxfs/libxfs_priv.h            |  17 +-
 libxfs/rdwr.c                   |   3 +-
 libxfs/topology.c               |   3 +-
 libxfs/xfs_ag.c                 |   2 +-
 libxfs/xfs_bmap.c               | 314 ++-----------------
 libxfs/xfs_bmap.h               |   7 +-
 libxfs/xfs_format.h             |  20 +-
 libxfs/xfs_fs.h                 |  14 +-
 libxfs/xfs_group.h              |  31 +-
 libxfs/xfs_ialloc.c             |   4 +-
 libxfs/xfs_inode_buf.c          |  23 +-
 libxfs/xfs_inode_util.c         |   1 +
 libxfs/xfs_log_format.h         |   7 +-
 libxfs/xfs_metafile.c           | 167 ++++++----
 libxfs/xfs_metafile.h           |   6 +-
 libxfs/xfs_ondisk.h             |   6 +-
 libxfs/xfs_rtbitmap.c           |  11 +
 libxfs/xfs_rtgroup.c            |  39 ++-
 libxfs/xfs_rtgroup.h            |  50 ++-
 libxfs/xfs_rtrmap_btree.c       |  19 ++
 libxfs/xfs_rtrmap_btree.h       |   2 +
 libxfs/xfs_sb.c                 |  82 ++++-
 libxfs/xfs_types.h              |  28 ++
 libxfs/xfs_zones.c              | 188 +++++++++++
 libxfs/xfs_zones.h              |  35 +++
 libxlog/xfs_log_recover.c       |   2 +-
 m4/package_libcdev.m4           |   2 +-
 man/man2/ioctl_xfs_fsgeometry.2 |  21 +-
 man/man8/mkfs.xfs.8.in          |  17 +
 man/man8/xfs_io.8               |  19 +-
 mdrestore/xfs_mdrestore.c       |  28 +-
 mkfs/proto.c                    |   3 +-
 mkfs/xfs_mkfs.c                 | 676 +++++++++++++++++++++++++++++++++++-----
 mkfs/xfs_protofile.py.in        |   4 +-
 repair/Makefile                 |   1 +
 repair/agheader.c               |   4 +-
 repair/dinode.c                 |   8 +-
 repair/phase5.c                 |   6 +
 repair/phase6.c                 |  21 +-
 repair/rt.c                     |   4 +-
 repair/rtrmap_repair.c          |  33 ++
 repair/xfs_repair.c             |   9 +-
 repair/zoned.c                  | 139 +++++++++
 repair/zoned.h                  |  10 +
 scrub/phase1.c                  |   3 +-
 scrub/phase6.c                  |  65 ++--
 scrub/phase7.c                  |  28 +-
 scrub/spacemap.c                |  17 +-
 spaceman/freesp.c               |  11 +-
 69 files changed, 2005 insertions(+), 640 deletions(-)
 create mode 100644 libxfs/xfs_zones.c
 create mode 100644 libxfs/xfs_zones.h
 create mode 100644 repair/zoned.c
 create mode 100644 repair/zoned.h

-- 
- Andrey

