Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88CB157E99
	for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 13:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735479587; cv=none; b=jgxaqlFUkr4YmZR3YDYGU2gyaNOghKE8SP21madMpOL4VST1VFvu+1LtlAt8a+MWxobhFZG0Sc5uY3lKrPqKvZLZb2w769Y54BYH4G2MzTH/tpFmY/ndTMnT/UvpOKRoQFMksjMu3KUAFvQuaJ/xuaMY2GaZNP66hYEZe8kU39w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735479587; c=relaxed/simple;
	bh=pb5LQ8RbQAC1U+ndK5+vE+9bLMt+ExDHkmvfCzy84uU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qgVj0yPvb7Mo8qFnp16XfuWCtmkaYYT/lTqKTdoncQXSKwlLxwcxIZoEE8dmzVov68oFed1Li1emUtdvHT/HQt9JeZEFd/VOke/KbXKNpG9Zi1BbFai3wK+os4Zl7xAYFjw/YJorjAZASnoVAhiXJy8bdBqXRlj6JgzotfeulsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bNBSkob9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bNBSkob9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735479584;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Jd34DVZgqyPqHS9uEK7ohjaUZzzaRh/lgy4bgZT5GRs=;
	b=bNBSkob9AwFLov6SCkUcCIORxpivvsR/FIzlrahTdQLohUEBHT9FSbZ0HL8FdhNkurolth
	ml0bObEsg8kPE2ZJzu27Wi03PfNMtTeS//rqcOBbfL9H2++GAO5Fb+hyQk6ALY+x3EW/bb
	cxhE+KT+VrxsREoH6U3l1+yj0wpRUhE=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-433-zSyesvcgN46_32lXdZLTaw-1; Sun, 29 Dec 2024 08:39:43 -0500
X-MC-Unique: zSyesvcgN46_32lXdZLTaw-1
X-Mimecast-MFC-AGG-ID: zSyesvcgN46_32lXdZLTaw
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-aa67f18cb95so155427166b.1
        for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 05:39:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735479582; x=1736084382;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jd34DVZgqyPqHS9uEK7ohjaUZzzaRh/lgy4bgZT5GRs=;
        b=SRUpwvGsGqG23qa82S9/YxYVvp0FHj4Qdk0Mqdn5gxhfGXm3PlqkBk9mUPWlnRY/9Y
         mGBD8xe67ES9w7xf65fJA9VgnJH+0UiyEEGMaulxhuN1vDp55QFOdC97XuYpvuwKjcQ/
         DQ+MDspDvMUwZGGIIOACXTLuQG+zaNa2K6/EgpS6290FLQk4iqlCdZXD6NC68bF8Ktbh
         L0ja93EQgJ0b/n4fSt/aon2RIrcPcscGSebAUEMDPUfIpKW18R6Goa4NudCQu+Ws06f6
         8g72R7S4QtOu2WJaNotPq8aLGoScEnIEDZhoxa0QpChsGpQgFgduWJmpSK9q3g2opwQv
         0JJw==
X-Gm-Message-State: AOJu0Yz/jBjouPrKxq4jkS611X11cONqzbv0aKG4oW6MVGUZd72jnnBg
	5pAP3Qf0xFU8So4PcOnQ42kRg0M+yVdXtWSPJQGQ7u21vjj642mcMCDNKpemE6FrgLLR+tqfvQY
	sBkbLeiLem2RSLlw57wXmrPvq+DAp7HZn4MiDsD8TmmkNg9TGntv5LMthA8Stw26Tphp3QoI57/
	aOl91Uw7P+RtJ9ahaGJF/Lpn6FSUE/4eqLGUvMClYe
X-Gm-Gg: ASbGncuHTTl0gebFcIqudvhjhoN+aYo/IBFEml8Xm8QlPi9nATvAwMme2JKIClaFjDQ
	GuXKrDD3f2e6OfxsQhIJwBsgMoJ+QRjQU/HFNgHJviUwsuIxfcXMt1ZKUT2bV6LdcoEeMPKFNFH
	OWUrqJVWSRPfdOjTwkuy7xS/EWzvC4Z690QwlEhaGyt13L9WTLGb0/YFCKaOcyWM/nGobrcIIoC
	mJLEBKKeICcYT4tQJmWTtAvL0YfQEcY1PwOFjYrbKBQqAwDcetNYrUSGsSc/POWqPS0z4ok4EaN
	DAjhDjt6SEZJzm4=
X-Received: by 2002:a05:6402:350d:b0:5d0:f81d:f555 with SMTP id 4fb4d7f45d1cf-5d81dd83fa3mr29914070a12.5.1735479581931;
        Sun, 29 Dec 2024 05:39:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGwep0k0X8VMSXZFu+t4YfDzyIAMZ5CaTaXe5NIVjLIlbnobCg1la1YY6jbutME7NUucQkZ3w==
X-Received: by 2002:a05:6402:350d:b0:5d0:f81d:f555 with SMTP id 4fb4d7f45d1cf-5d81dd83fa3mr29914036a12.5.1735479581486;
        Sun, 29 Dec 2024 05:39:41 -0800 (PST)
Received: from thinky.redhat.com (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0f070a7bsm1355017766b.201.2024.12.29.05.39.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2024 05:39:41 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	david@fromorbit.com,
	hch@lst.de,
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH 00/24] fsverity integration for XFS based on direct mapped xattrs
Date: Sun, 29 Dec 2024 14:39:03 +0100
Message-ID: <20241229133927.1194609-1-aalbersh@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241229133350.1192387-1-aalbersh@kernel.org>
References: <20241229133350.1192387-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use new format of extended attributes with filesystem block aligned
data (without header). The blocks are mapped through page cache via
iomap.

Andrey

Andrey Albershteyn (15):
  fs: add FS_XFLAG_VERITY for verity files
  fsverity: pass tree_blocksize to end_enable_verity()
  fsverity: add tracepoints
  fsverity: flush pagecache before enabling verity
  iomap: integrate fs-verity verification into iomap's read path
  xfs: add attribute type for fs-verity
  xfs: add fs-verity ro-compat flag
  xfs: add inode on-disk VERITY flag
  xfs: initialize fs-verity on file open and cleanup on inode
    destruction
  xfs: don't allow to enable DAX on fs-verity sealed inode
  xfs: disable direct read path for fs-verity files
  xfs: add fs-verity support
  xfs: add writeback page mapping for fs-verity
  xfs: add fs-verity ioctls
  xfs: enable ro-compat fs-verity flag

Darrick J. Wong (9):
  fsverity: pass the new tree size and block size to
    ->begin_enable_verity
  fsverity: expose merkle tree geometry to callers
  fsverity: report validation errors back to the filesystem
  xfs: use an empty transaction to protect xfs_attr_get from deadlocks
  xfs: don't let xfs_bmap_first_unused overflow a xfs_dablk_t
  xfs: use merkle tree offset as attr hash
  xfs: advertise fs-verity being available on filesystem
  xfs: check and repair the verity inode flag state
  xfs: report verity failures through the health system

 Documentation/filesystems/fsverity.rst |   8 +
 MAINTAINERS                            |   1 +
 fs/btrfs/verity.c                      |   7 +-
 fs/ext4/verity.c                       |   6 +-
 fs/f2fs/verity.c                       |   6 +-
 fs/ioctl.c                             |  11 +
 fs/iomap/buffered-io.c                 |  30 +-
 fs/verity/enable.c                     |  18 +-
 fs/verity/fsverity_private.h           |   2 +
 fs/verity/init.c                       |   1 +
 fs/verity/open.c                       |  37 ++
 fs/verity/verify.c                     |  13 +
 fs/xfs/Makefile                        |   2 +
 fs/xfs/libxfs/xfs_ag.h                 |   1 +
 fs/xfs/libxfs/xfs_attr.c               |  14 +
 fs/xfs/libxfs/xfs_attr_remote.c        |   3 +
 fs/xfs/libxfs/xfs_da_btree.c           |   3 +
 fs/xfs/libxfs/xfs_da_format.h          |  34 +-
 fs/xfs/libxfs/xfs_format.h             |  17 +-
 fs/xfs/libxfs/xfs_fs.h                 |   2 +
 fs/xfs/libxfs/xfs_health.h             |   4 +-
 fs/xfs/libxfs/xfs_inode_buf.c          |   8 +
 fs/xfs/libxfs/xfs_inode_util.c         |   2 +
 fs/xfs/libxfs/xfs_log_format.h         |   1 +
 fs/xfs/libxfs/xfs_ondisk.h             |   4 +
 fs/xfs/libxfs/xfs_sb.c                 |   4 +
 fs/xfs/libxfs/xfs_verity.c             |  74 ++++
 fs/xfs/libxfs/xfs_verity.h             |  14 +
 fs/xfs/scrub/attr.c                    |   7 +
 fs/xfs/scrub/common.c                  |  68 ++++
 fs/xfs/scrub/common.h                  |   3 +
 fs/xfs/scrub/inode.c                   |   7 +
 fs/xfs/scrub/inode_repair.c            |  36 ++
 fs/xfs/xfs_aops.c                      | 141 +++++++-
 fs/xfs/xfs_file.c                      |  23 +-
 fs/xfs/xfs_fsops.c                     |   1 +
 fs/xfs/xfs_fsverity.c                  | 482 +++++++++++++++++++++++++
 fs/xfs/xfs_fsverity.h                  |  54 +++
 fs/xfs/xfs_health.c                    |   1 +
 fs/xfs/xfs_inode.h                     |   2 +
 fs/xfs/xfs_ioctl.c                     |  16 +
 fs/xfs/xfs_iomap.h                     |   2 +
 fs/xfs/xfs_iops.c                      |   4 +
 fs/xfs/xfs_mount.c                     |   1 +
 fs/xfs/xfs_mount.h                     |   2 +
 fs/xfs/xfs_super.c                     |  11 +
 fs/xfs/xfs_trace.c                     |   1 +
 fs/xfs/xfs_trace.h                     |  42 ++-
 include/linux/fsverity.h               |  34 +-
 include/linux/iomap.h                  |   5 +
 include/trace/events/fsverity.h        | 162 +++++++++
 include/uapi/linux/fs.h                |   1 +
 52 files changed, 1400 insertions(+), 33 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_verity.c
 create mode 100644 fs/xfs/libxfs/xfs_verity.h
 create mode 100644 fs/xfs/xfs_fsverity.c
 create mode 100644 fs/xfs/xfs_fsverity.h
 create mode 100644 include/trace/events/fsverity.h

-- 
2.47.0

