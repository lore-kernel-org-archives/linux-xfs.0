Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2919B1DE8A0
	for <linux-xfs@vger.kernel.org>; Wed,  7 May 2025 17:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746638125; cv=none; b=piOQ5LdGgtOBnZanEOACWtJNySrfMFvTERbfryVZXFQ8ZgUXtOC3ZSxLgNkob6IyqI24QsWHA1Yc472dhlv1SubQXanrs3CWnpiHb7ijAhFsqBkT9upTFNIdircJ4c1rOL6PP4hb5Zo3NFjdxOaiovJFZeTfOVnHOtomdcecUGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746638125; c=relaxed/simple;
	bh=XPH+6h1iLq5u8b4x4Rff+MbUy3D96sQd7mZ5yCp50qk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=rGj9tAT/O0h0Z1BBtVvrRM0Fj+CrsOAbeAJShEA4r3q40ODBfG8buGxSPox+RwI/1htMQL7kx+VxDFx1v0LDeHTNPrse0RgSpFoHSSdaqK0PWNrNcN0RFuNIzvjsMLB5ArJTj9DbW6ZACFaWBMlgr8tq4r8HKF3F9HQPh3lV+Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ePavmONO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ePavmONO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746638122;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=2A6rUc1/i0QJ4TOqT/sjQSzOTtLywukOlKfw1dPRnTU=;
	b=ePavmONOB/2p87ABxY4qct7yVdx7r2VTUKRiwsVsZxvCfSFuGqIjnSqkpmlSwkPa2FF9zI
	X6Hs5mC5LBKTXFGtutR2vy4WkMvJsmQOzh+jvjDjjXZoE3TAyMeJRBlnxbeRCGDYS/iNnb
	nqTC0i5o4OsR0dschNxkiQSdTbUSfAw=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-592-3-NCCFWvMieQzs6-8gtOkw-1; Wed, 07 May 2025 13:15:21 -0400
X-MC-Unique: 3-NCCFWvMieQzs6-8gtOkw-1
X-Mimecast-MFC-AGG-ID: 3-NCCFWvMieQzs6-8gtOkw_1746638120
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-ac293748694so6599066b.0
        for <linux-xfs@vger.kernel.org>; Wed, 07 May 2025 10:15:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746638119; x=1747242919;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2A6rUc1/i0QJ4TOqT/sjQSzOTtLywukOlKfw1dPRnTU=;
        b=dI+D3q5Hf0YaDtg4Co53iuGlmuH4QgQPGlu/rgcrhMwSG62NBQrBC02S2FtIW8q7Wt
         eCuoqZe1OKmiLEupjbT9GEPDNvR6Mbw2wQokCgAe3U6uBaU4f78a+/GnRoPCh+rts3S5
         rrlbGmUrG/LtbCZnr+ews7z+TzUkSuqAqk7pRGZVwKrh9QbtF7dAglnyrnsJjtnOx57V
         V4Ta8SipWxUXEFrZ7W/2CouB1Jw5Kts1lNuu/ApFJTiOoYqdJqnUHkQwxMLNikuhJmF5
         8H0EyCVJZremeMVK1hITOPZhpgAxZo3m6Ahj7KWqOHdvWmWQyAz2MSCMudgB9kZ1PNMU
         w/VA==
X-Gm-Message-State: AOJu0YyjbxzuJfrPaMQNZGZl8TwUQAnNr2z6Q9H2dA687UKb12132XEE
	/iW0igA3NO9CfgwQNqvAG7l7QDjPW6dCLdN23ivi84sNit8QbJfR76H34CXKkNEeG3nr7JI0pWj
	rzCH50Jb0qXRK4+O6N7x+7J2KfSy4J1n0N3adfeEqLRUcWn0ByecSBcmO0HiWK4KEaxvJFCBEFs
	Vo7paTdLvEpMlmW0/HiDozzCm3z9sDDbv3uZoimc1A
X-Gm-Gg: ASbGncvjmv8HevezXNGF/qFq7vgguFQztw/89U0e04SCISsAQ6H/m1Cq/PZBJnnNDip
	LqhFjZxV/TaQXd2qu2DP0agzRSDLNzhOey6WPSpwRTPrhRJW1QfxKD/R/RU7oudEmlBM047jP8e
	wuqMFURIu71GKPhnXucxaAbrufWVRI0rXUApUIpOcjKD4ROx0Q7ntMksLteSlcAOGdFP3fvuF/A
	iNONZ4I16BNenatmLydw7MKsbLVC8oakukRAQnj23InD8TOmZ2Bk5Z2I4brc8QK7FudjC8fEplX
	O9TxKnkRxPTD6KYU2VaBZyDs6th8wn+eWbD6Ygdq
X-Received: by 2002:a17:906:6a0f:b0:aca:a162:67bb with SMTP id a640c23a62f3a-ad1e8b958a3mr504708766b.4.1746638119459;
        Wed, 07 May 2025 10:15:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE7wgwmOIN06ez6hlq55b9BXEZWfAwTWqFlPa0fRJUFr/p0JLW3253y65ia4kJkY1GfyK/wiw==
X-Received: by 2002:a17:906:6a0f:b0:aca:a162:67bb with SMTP id a640c23a62f3a-ad1e8b958a3mr504704466b.4.1746638119042;
        Wed, 07 May 2025 10:15:19 -0700 (PDT)
Received: from thinky (109-92-26-237.static.isp.telekom.rs. [109.92.26.237])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad1894c01b2sm949819666b.109.2025.05.07.10.15.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 10:15:18 -0700 (PDT)
Date: Wed, 7 May 2025 19:15:17 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org, bodonnel@redhat.com, djwong@kernel.org, 
	hans.holmberg@wdc.com, hch@lst.de, john.g.garry@oracle.com, linux-xfs@vger.kernel.org, 
	liuhuan01@kylinos.cn, ritesh.list@gmail.com, sandeen@redhat.com, sandeen@sandeen.net
Subject: [ANNOUNCE] xfsprogs: for-next updated to 72d5abe1d8c3
Message-ID: <molw4bdrkw7m7efumwg32afrzlqdaygvs74ofsv3h4zu7iec6p@butimcnapehb>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

The xfsprogs for-next branch in repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed
on the list and not included in this update, please let me know.

The for-next branch has also been updated to match the state of master.

The new head of the for-next branch is commit:

72d5abe1d8c3cf184a1c53cea267c57e7957e6f9

New commits:

Andrey Albershteyn (1):
      [03a824e42ad9] gitignore: update gitignore with python scripts

Bill O'Donnell (1):
      [140fd5b16357] xfs_repair: phase6: scan longform entries before header check

Christoph Hellwig (36):
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

Darrick J. Wong (6):
      [86e28b9548aa] man: fix missing cachestat manpage
      [95264b115d86] xfs_io: catch statx fields up to 6.15
      [077560c53953] xfs_io: redefine what statx -m all does
      [d6721943d668] xfs_io: make statx mask parsing more generally useful
      [044e134fffff] mkfs: fix blkid probe API violations causing weird output
      [72d5abe1d8c3] xfs_repair: fix libxfs abstraction mess

Eric Sandeen (1):
      [454fab69c484] xfs_repair: Bump link count if longform_dir2_rebuild yields shortform dir

liuh (1):
      [81f646b0d6af] mkfs: fix the issue of maxpct set to 0 not taking effect

Code Diffstat:

 .gitignore                      |   5 +-
 db/convert.c                    |   6 +-
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
 libxfs/libxfs_priv.h            |  16 +-
 libxfs/rdwr.c                   |   2 +
 libxfs/topology.c               |   3 +-
 libxfs/xfs_bmap.c               | 314 ++-----------------
 libxfs/xfs_bmap.h               |   7 +-
 libxfs/xfs_format.h             |  20 +-
 libxfs/xfs_fs.h                 |  14 +-
 libxfs/xfs_group.h              |  31 +-
 libxfs/xfs_ialloc.c             |   2 +-
 libxfs/xfs_inode_buf.c          |  21 +-
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
 m4/package_libcdev.m4           |   2 +-
 man/man2/ioctl_xfs_fsgeometry.2 |  21 +-
 man/man8/mkfs.xfs.8.in          |  17 +
 man/man8/xfs_io.8               |  17 +-
 mdrestore/xfs_mdrestore.c       |  20 +-
 mkfs/proto.c                    |   3 +-
 mkfs/xfs_mkfs.c                 | 672 +++++++++++++++++++++++++++++++++++-----
 repair/Makefile                 |   1 +
 repair/agheader.c               |   4 +-
 repair/dinode.c                 |   8 +-
 repair/phase5.c                 |   6 +
 repair/phase6.c                 |  21 +-
 repair/rt.c                     |   2 +
 repair/rtrmap_repair.c          |  33 ++
 repair/xfs_repair.c             |   9 +-
 repair/zoned.c                  | 139 +++++++++
 repair/zoned.h                  |  10 +
 scrub/phase1.c                  |   3 +-
 scrub/phase6.c                  |  65 ++--
 scrub/phase7.c                  |  28 +-
 scrub/spacemap.c                |  17 +-
 spaceman/freesp.c               |  11 +-
 61 files changed, 1944 insertions(+), 627 deletions(-)
 create mode 100644 libxfs/xfs_zones.c
 create mode 100644 libxfs/xfs_zones.h
 create mode 100644 repair/zoned.c
 create mode 100644 repair/zoned.h

-- 
- Andrey

