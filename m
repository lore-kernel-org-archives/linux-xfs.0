Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F7F3DBD58
	for <linux-xfs@vger.kernel.org>; Wed,  8 Apr 2026 20:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775678585; cv=none; b=rxoGqwh0S2ccZBdAdCsUFlrJOmudaql0g2DBx0O8HfxhGm99h9gcHFGSjXq9EQgdGOudaGK9btdmZccFZEA1u1ZQ9AStr27ye7HibHSMQhZ4X3HCEexgH0//NxK7AgE4czjUeUFQlqII3fqp+RfCZ5w1FAxPIVOthMD/LdO3lhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775678585; c=relaxed/simple;
	bh=9ajHybwXaIz0+YgaYo5D7jpr6FjsIST9gaXQEoMPyNw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=sAOaVzbYfBYj/Dgjpt9//XI2eVxChFgMa7GxhGo/5lZawcwt3+i8cz3NOgN3oe9B2zoEbR6clI08npBH7mMaHWjPEpjTxiF58oOkAL5DVX+RDlvitJapbnY3c3kHAOtguyRo10oJnD/0MIpZpOYAvOtQ0PiEDYh02c0Av7xuVss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eC4PmEAw; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=C4eAs1wx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eC4PmEAw";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="C4eAs1wx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775678582;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=vvkgMz/+kRotQ2lEhJA9GUmFbv9ceDBl0OyA+OmBi3Q=;
	b=eC4PmEAwSd6KAQO4V6eKmgXuVMgAqZzdRuGdZJ1KBJL7GNLKhwkf+c1Jofa4vwKWAWJ/0I
	wxivRilE7DhrEy6OXFCk7bIBMLjAvL/LOhSRZ/2ZniQkOr6PeBuINIaWdGUoibfriUYHax
	JFhIVI0SaJ5/+RqzyPmvGmq+qqoe/qk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-504-6SdlzHRkMcSaPpSZtgKZDQ-1; Wed, 08 Apr 2026 16:03:00 -0400
X-MC-Unique: 6SdlzHRkMcSaPpSZtgKZDQ-1
X-Mimecast-MFC-AGG-ID: 6SdlzHRkMcSaPpSZtgKZDQ_1775678579
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-43d1dea12aaso68995f8f.1
        for <linux-xfs@vger.kernel.org>; Wed, 08 Apr 2026 13:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1775678578; x=1776283378; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vvkgMz/+kRotQ2lEhJA9GUmFbv9ceDBl0OyA+OmBi3Q=;
        b=C4eAs1wxGnpoO64OFJdIPuYzxk3OuhIw4wKePIJicLnDrpm1S0f/jAkYX/zzJkpyk/
         KZRdZZ/T4zpuKe/oiVzlux6JRHEFsIvzxqgmjgters7aL/9kVLHlFtpOT7Botm8x2mC2
         n+XZjyG6nz7lrTWFfez3+MRg2eHhC5z55DT79j3yku2SCPs/6R9m+2LK3ZHDMdbwhgtf
         DrOH6mp58hVRtrJ3UziJDgGl24NDYMtMWi9IppFqbPUVsDLHEibS9fQizkW+7MaAWkyP
         NA8LbiHTYl9KCbOOMhFO4LKanFP7px/JFMOOIVsy0hgsiF+4osqectm8gAez9hOBmoDl
         owig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775678578; x=1776283378;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vvkgMz/+kRotQ2lEhJA9GUmFbv9ceDBl0OyA+OmBi3Q=;
        b=ho1k1gzWl+7MATrECd6NSkHAEipV0P+MLmAYPEQS7u9CQtRGktIhk3ag1RxN1ENctZ
         2oHUAJ8S4tb4X20gBGZl5VLhxMEhe7aSO8eoel0TU3DtmvZhy1oLoT+X2pe39xQwtsTP
         kO+uGFS6Gc2PoxKlb9dQD7QdP5VRLU4p1pVX0qesRXL5ZLZ6wgBA9WXr6gzH/iZOYwk3
         t+2XAjUGg7R5y+ar4e8E6iPo2xxbOZB+sfgxhQQcoOSMM837Qed4yMwQf6qcnzFMyMuV
         5n9FpXf/jVdEoupdqj6GFW1xpKTl/SxqtMH+dg+jcgZuEVvI8Ja2h3qLWZ8MIpfT0DQV
         qwrQ==
X-Gm-Message-State: AOJu0YwJbDdKOwq8ERKoniaZrFghn+bKOs7Cxae48q0f/4hkyCRF+Ehh
	JIXfD/C4uymwQE8JwON1bIeo3cGVYuNznFu0Ykjj3uxeB9mDQmVHThSVbv4DVtVpUaMvEs48reI
	khx83a0hOJ5sGfwnuP8GFbJsV7pgp6jR3ds2W05mYZSfZCMV2bR/gqF6G1ByN0UqT6g7gZPXhMf
	T2KPTpZCzgdkXBBt//N9Drr7RAEjINGpiKs+heK0/yzq/B
X-Gm-Gg: AeBDietM1AC5wi8qDfGJjNQhsOtg8wLB/fWKxClRBIps1xJbp9xxhH6zfoeDFJcxScg
	iV3EuNYuFXv3YLWy4yyNAZsiPGGwa7+Hub6MoHQHO+pXfU3MKlitBj3p7o4jNmWnLIoHv126ApW
	JFj4NQIHrfgXFqAxrzcUkzh+aGY/mr9m1xUEhFUoBmkho7e8eXv/u1WcCm2sOKkd1cT9YyyFxHs
	pB8MySBlH2+exh/vAhup37MAyoas8Vc4ECiYXTaSTNdLCSSiGH5lFnyy9wbDEiEzsxkNCm6lwO/
	PYzVAf0+ZxK/GQmWcq1pYtJq+6yxHLyEyc9r6P4lcrRB09aIlxBxm0FYdWK7gQw0p7Pc8It518/
	wcRC2D4IHsWtndg==
X-Received: by 2002:a05:6000:2282:b0:43b:4aba:8f52 with SMTP id ffacd0b85a97d-43d292dbb72mr34064977f8f.32.1775678578221;
        Wed, 08 Apr 2026 13:02:58 -0700 (PDT)
X-Received: by 2002:a05:6000:2282:b0:43b:4aba:8f52 with SMTP id ffacd0b85a97d-43d292dbb72mr34064903f8f.32.1775678577587;
        Wed, 08 Apr 2026 13:02:57 -0700 (PDT)
Received: from thinky ([91.245.205.131])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d1e4e56fesm58207099f8f.27.2026.04.08.13.02.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2026 13:02:57 -0700 (PDT)
Date: Wed, 8 Apr 2026 22:02:55 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org, cem@kernel.org, cmaiolino@redhat.com, 
	djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, hch@lst.de, 
	hongao@uniontech.com, kees@kernel.org, linux-xfs@vger.kernel.org, 
	mark.tinguely@oracle.com, nirjhar.roy.lists@gmail.com, shinsj4653@gmail.com, 
	souptick.joarder@hpe.com, tbecker@redhat.com, torvalds@linux-foundation.org, 
	wilfred.mallawa@wdc.com
Subject: [ANNOUNCE] xfsprogs: for-next updated to 9d0bd1ecce3d
Message-ID: <lcox24u4sq2b6iys3ojpk5njntgc3k4ro6kygk2wnq6ui4thvi@q2h5bxconrm2>
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

9d0bd1ecce3dc176a974d2021b1a329936294781

New commits:

Carlos Maiolino (3):
      [50d29084e53a] xfs: fix returned valued from xfs_defer_can_append
      [bf1007391a32] fsr: package function should check for negative errors
      [a799c98743c9] fsr: always print error messages from xfrog_defragrange()

Christoph Hellwig (9):
      [319921d5773b] xfs: move struct xfs_log_iovec to xfs_log_priv.h
      [d73928379174] xfs: directly include xfs_platform.h
      [13bfe767e058] xfs: remove xfs_attr_leaf_hasname
      [521c29955c4c] xfs: add a xfs_rtgroup_raw_size helper
      [08b2e420e141] xfs: split and refactor zone validation
      [1edef5ba034f] xfs: don't validate error tags in the I/O path
      [8d800684e9ef] xfs: add zone reset error injection
      [a4bb45b0e5ae] xfs: give the defer_relog stat a xs_ prefix
      [4b3284ed006f] xfs: remove metafile inodes from the active inode stat

Damien Le Moal (1):
      [df9839b1dd08] xfs: add missing forward declaration in xfs_zones.h

Darrick J. Wong (21):
      [eb06f16ca2e9] xfs_repair: don't fail on INCOMPLETE attrs in leaf blocks
      [b8719a1dd2a0] libxfs: fix XFS_STATS_DEC
      [1b8bca4e0bd1] libxfs: port various kernel apis from 7.0
      [68cbbe7c8c4d] libfrog: hoist some utilities from libxfs
      [a6ff7e6e175c] libfrog: fix missing gettext call in current_fixed_time
      [a1f2281c5987] xfs: start creating infrastructure for health monitoring
      [d5017c673367] xfs: create event queuing, formatting, and discovery infrastructure
      [b8f406861a22] xfs: convey filesystem unmount events to the health monitor
      [207a7d1e6b7c] xfs: convey metadata health events to the health monitor
      [47ab0cd74ec5] xfs: convey filesystem shutdown events to the health monitor
      [e2d9636f998f] xfs: convey externally discovered fsdax media errors to the health monitor
      [00cb02ecf24b] xfs: convey file I/O errors to the health monitor
      [ac360cbefe20] xfs: check if an open file is on the health monitored fs
      [b669642fe6fa] xfs: add media verification ioctl
      [3d1a4fec942d] xfs: delete attr leaf freemap entries when empty
      [726d84515668] xfs: fix freemap adjustments when adding xattrs to leaf blocks
      [eec406054fb1] xfs: refactor attr3 leaf table size computation
      [31d5bf696c60] xfs: strengthen attr leaf block freemap checking
      [75d34e4a58f5] xfs: reduce xfs_attr_try_sf_addname parameters
      [7ba08aabba0c] xfs: speed up parent pointer operations when possible
      [f61109373545] xfs: add a method to replace shortform attrs

Kees Cook (1):
      [7c7f99c57a13] treewide: Replace kmalloc with kmalloc_obj for non-scalar types

Linus Torvalds (1):
      [e89513b094c0] Convert 'alloc_obj' family to use the new default GFP_KERNEL argument

Nirjhar Roy (IBM) (2):
      [1dff948c0bbd] xfs: Refactoring the nagcount and delta calculation
      [806d742e6d03] xfs: Add a comment in xfs_log_sb()

Shin Seong-jun (1):
      [d0dd6ec5156a] xfs: fix spacing style issues in xfs_alloc.c

Thiago Becker (1):
      [9d0bd1ecce3d] libxfs: fix printing of cache.c_maxcount.

Wilfred Mallawa (3):
      [5f18c380c619] xfs: fix code alignment issues in xfs_ondisk.c
      [b6a84a375fe0] xfs: remove duplicate static size checks
      [43b6c8457c1a] xfs: add static size checks for ioctl UABI

hongao (1):
      [8a5e47ac6985] xfs: Remove redundant NULL check after __GFP_NOFAIL

Code Diffstat:

 fsr/xfs_fsr.c                            |  12 +-
 include/kmem.h                           |  50 ++++++++
 include/libxfs.h                         |   7 +-
 include/platform_defs.h                  |   8 ++
 include/xfs_fs_compat.h                  |   8 --
 include/xfs_trace.h                      |   1 +
 libfrog/Makefile                         |   4 +
 libfrog/util.c                           | 166 ++++++++++++++++++++++++++
 libfrog/util.h                           |  21 ++++
 libxfs/Makefile                          |   4 +-
 libxfs/buf_mem.c                         |   2 +-
 libxfs/cache.c                           |   4 +-
 libxfs/defer_item.c                      |   2 +-
 libxfs/init.c                            |   2 +-
 libxfs/inode.c                           |   2 +-
 libxfs/iunlink.c                         |   2 +-
 libxfs/kmem.c                            |   2 +-
 libxfs/libxfs_api_defs.h                 |   2 +-
 libxfs/logitem.c                         |   2 +-
 libxfs/rdwr.c                            |   2 +-
 libxfs/topology.c                        |   2 +-
 libxfs/trans.c                           |   2 +-
 libxfs/util.c                            | 162 +------------------------
 libxfs/xfblob.c                          |   2 +-
 libxfs/xfile.c                           |   2 +-
 libxfs/xfs_ag.c                          |  32 ++++-
 libxfs/xfs_ag.h                          |   3 +
 libxfs/xfs_ag_resv.c                     |   2 +-
 libxfs/xfs_alloc.c                       |  10 +-
 libxfs/xfs_alloc_btree.c                 |   2 +-
 libxfs/xfs_attr.c                        | 191 ++++++++++++++++++++----------
 libxfs/xfs_attr.h                        |   6 +-
 libxfs/xfs_attr_leaf.c                   | 197 +++++++++++++++++++++++++------
 libxfs/xfs_attr_leaf.h                   |   1 +
 libxfs/xfs_attr_remote.c                 |   2 +-
 libxfs/xfs_bit.c                         |   2 +-
 libxfs/xfs_bmap.c                        |   2 +-
 libxfs/xfs_bmap_btree.c                  |   2 +-
 libxfs/xfs_btree.c                       |   2 +-
 libxfs/xfs_btree_mem.c                   |   2 +-
 libxfs/xfs_btree_staging.c               |   2 +-
 libxfs/xfs_da_btree.c                    |  10 +-
 libxfs/xfs_da_format.h                   |   2 +-
 libxfs/xfs_defer.c                       |   8 +-
 libxfs/xfs_dir2.c                        |  21 ++--
 libxfs/xfs_dir2_block.c                  |   2 +-
 libxfs/xfs_dir2_data.c                   |   2 +-
 libxfs/xfs_dir2_leaf.c                   |   2 +-
 libxfs/xfs_dir2_node.c                   |   2 +-
 libxfs/xfs_dir2_sf.c                     |   2 +-
 libxfs/xfs_dquot_buf.c                   |   2 +-
 libxfs/xfs_errortag.h                    |   8 +-
 libxfs/xfs_exchmaps.c                    |   2 +-
 libxfs/xfs_fs.h                          | 189 +++++++++++++++++++++++++++++
 libxfs/xfs_group.c                       |   2 +-
 libxfs/xfs_health.h                      |   5 +
 libxfs/xfs_ialloc.c                      |   2 +-
 libxfs/xfs_ialloc_btree.c                |   2 +-
 libxfs/xfs_iext_tree.c                   |   2 +-
 libxfs/xfs_inode_buf.c                   |   6 +-
 libxfs/xfs_inode_fork.c                  |   2 +-
 libxfs/xfs_inode_util.c                  |   2 +-
 libxfs/xfs_log_format.h                  |   7 --
 libxfs/xfs_log_rlimit.c                  |   2 +-
 libxfs/xfs_metadir.c                     |   2 +-
 libxfs/xfs_metafile.c                    |   7 +-
 libxfs/xfs_ondisk.h                      |  52 +++++---
 libxfs/xfs_parent.c                      |  16 +--
 libxfs/{libxfs_priv.h => xfs_platform.h} |  25 +---
 libxfs/xfs_refcount.c                    |   6 +-
 libxfs/xfs_refcount_btree.c              |   2 +-
 libxfs/xfs_rmap.c                        |   2 +-
 libxfs/xfs_rmap_btree.c                  |   2 +-
 libxfs/xfs_rtbitmap.c                    |   2 +-
 libxfs/xfs_rtgroup.c                     |   4 +-
 libxfs/xfs_rtgroup.h                     |  15 +++
 libxfs/xfs_rtrefcount_btree.c            |   2 +-
 libxfs/xfs_rtrmap_btree.c                |   2 +-
 libxfs/xfs_sb.c                          |   5 +-
 libxfs/xfs_symlink_remote.c              |   2 +-
 libxfs/xfs_trans_inode.c                 |   2 +-
 libxfs/xfs_trans_resv.c                  |   2 +-
 libxfs/xfs_trans_space.c                 |   2 +-
 libxfs/xfs_types.c                       |   2 +-
 libxfs/xfs_zones.c                       | 151 +++++++----------------
 libxfs/xfs_zones.h                       |   6 +-
 libxlog/xfs_log_recover.c                |   4 +-
 repair/attr_repair.c                     |  22 +++-
 repair/zoned.c                           |   7 +-
 89 files changed, 1012 insertions(+), 547 deletions(-)
 rename libxfs/{libxfs_priv.h => xfs_platform.h} (96%)

-- 
- Andrey

