Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874CB4690
	for <linux-xfs@vger.kernel.org>; Tue,  1 Apr 2025 12:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743509186; cv=none; b=uagQVMfo9LGLtltGwJdncwTiwAvgYJBqiffBdENhpnnsyrtemv6LRx5DoEAiWq2PAtHb3O7x74zE8C3DnHtjQxb4MtLJqtMYahNNovWDxJB8m7jfXh4YccJ2iULQ5SobsWeZ/OqUiEOLpiBGk3aI1Ls5UEF8oBM0nnt0pGZgrDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743509186; c=relaxed/simple;
	bh=09E6v7PPW9mbzyl+tJYJFqvulKGcrCmtw41mWwMOeu4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=l732Z1PjfEmHphPbnySHK4PHjb5sa+V2panKJusL47mIy5o/VkOqwGDuLMxLlEBoZcZwB9Oe7OXCxocOIbYBiQxeXKVgDFKAIqBXQwuJRnluPvqertAJidRa/B4HsNTjes9NbIe/nWEWbLAYyjmArrhsHvhOrJVaNYvD/qtPWXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cJadeH81; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cJadeH81"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743509183;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=nMZiDrB7PdneIFjlMGOBmjCvVi1UPJ5DeuSNXPCx7cY=;
	b=cJadeH81DE9MJz4rWUcZbBs4IQOzkE77bPyeasbFZ3DiEg89a2sjZ4KvCNQNbzWx7clRp3
	xFSWhi2CUjC+YA1UtjliO7exNN0/4Uxsjx2Nmcjse8/Yo3wy6rykwFzNhpXDlq6qzUBKI+
	krWQBOgR2IzGWcVQnso99ZvIwfjNRLU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-638-pZ0gWWuUMWOROtHm68Fz1A-1; Tue, 01 Apr 2025 08:06:21 -0400
X-MC-Unique: pZ0gWWuUMWOROtHm68Fz1A-1
X-Mimecast-MFC-AGG-ID: pZ0gWWuUMWOROtHm68Fz1A_1743509181
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43947a0919aso44137125e9.0
        for <linux-xfs@vger.kernel.org>; Tue, 01 Apr 2025 05:06:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743509180; x=1744113980;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nMZiDrB7PdneIFjlMGOBmjCvVi1UPJ5DeuSNXPCx7cY=;
        b=Y9Fz2+kZEm1iNR79AQngG28F8tfXiVIY7XntcMJUeRwyRXupYW8HNl76e5lt+4q1MN
         loUbtQ0VsSd3zdcmcN9U0XCxZZETnpYvSfu3uDte55soZASXBeyI2khK/ufhtcRq/luk
         t/Geav5N9kiozB2ehtwfJWf55D2UKcqyOiGvTXColR+rBsG/3MWJHWPt2PoJJRmn7uCi
         msQg18a0G1dFeyASGO+pxhXF/+GwIdbNfVg0whRa4Z9dK8ZRsdKHHKtjoZ3Ko/ECIB2E
         8aAtGSzZlZegYTi3eePlMaCk/DQUXkaVt3aXDjV/VKJmrqfSVKYlhSxkeq+kkDH7ScOr
         Kurg==
X-Gm-Message-State: AOJu0YzUu+YW/2fQyFjhC6rq7fuEaFNCa3X+aaohZeNkuTrm29Tk8qU+
	c12pKYZu68xp0dYHUKtBH8WYHaiFRUe8ua0it2tIDOTR/KEjBOtJ5jeHSPBW6ZQgQJy1u9Dnlmx
	LA64+0b+/SBg0TCuSDjGNkH7k6Qi2rwi99Jy15NtGyw+TQ3DxTNaFreEL6j0aX0A2igqPVt4HUT
	ar5kuZ1rJAXwoB4/OZQNbZjjg4A7Hdb7Gg5aXQiwDD
X-Gm-Gg: ASbGnct5dJcpDTedX8O9rxqUIRTfsnVbMzV41hc0eEWmfdyE250N67nPB6C3LNJ+vXu
	x0zLV4g/KJiXpJwDpYPFPsvz3Z6ZC037weL24V4Qg9p9Ju0Y/hrYRcrTuaPdzYUan0Yn2vDjQwV
	FEIbLRW3yx+vXkLmoX7hLmHTyX4d3Nrw2Ocar99SxeHD8k8vgDRITcMe6ZM/ukMzZYdh7rhiH8W
	537+UxCxNzKy9m2htgtA9KrLy35mr0L8HnbhsZeZ1aLtiy/UnTCTLs/taVYFfRZ62eYgpNIEqO0
	bqcpZfOIuyy8WaovTo7HxG8xWY3bPl8LjZc=
X-Received: by 2002:a05:600c:870c:b0:43d:683:8cb2 with SMTP id 5b1f17b1804b1-43db624a3dbmr117986075e9.14.1743509180158;
        Tue, 01 Apr 2025 05:06:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGrpCjOcQsRV5U4JtxHDpdmMhNcOR822hZqbGNnWaK7HBj1Id8Hd8jvBWhQ10dxhFwdEJlL1w==
X-Received: by 2002:a05:600c:870c:b0:43d:683:8cb2 with SMTP id 5b1f17b1804b1-43db624a3dbmr117983795e9.14.1743509178260;
        Tue, 01 Apr 2025 05:06:18 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d82dedd6fsm203348085e9.7.2025.04.01.05.06.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 05:06:17 -0700 (PDT)
Date: Tue, 1 Apr 2025 14:06:15 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org, axboe@kernel.dk, bodonnel@redhat.com, 
	cem@kernel.org, cmaiolino@redhat.com, djwong@kernel.org, hch@lst.de, 
	linux-xfs@vger.kernel.org, ritesh.list@gmail.com, sandeen@redhat.com, tytso@mit.edu, 
	willy@infradead.org
Subject: [ANNOUNCE] xfsprogs: for-next updated to 8cd85addd72f
Message-ID: <4yada2zb4jx64zopubteaogmffkwqsgw5zpcqt2myugcaxquga@j2i7xwu4x7ah>
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

8cd85addd72f1f6e569bd286f6a44dfce90355f1

New commits:

Bill O'Donnell (1):
      [8cd85addd72f] xfs_repair: handling a block with bad crc, bad uuid, and bad magic number needs fixing

Darrick J. Wong (5):
      [e6caefbdcf10] xfs_repair: fix wording of error message about leftover CoW blocks on the rt device
      [28db545be050] xfs_repair: don't recreate /quota metadir if there are no quota inodes
      [b26d16875213] xfs_repair: fix crash in reset_rt_metadir_inodes
      [bbd8ba73e64b] xfs_repair: fix infinite loop in longform_dir2_entry_check*
      [06adb3cb38be] xfs_repair: fix stupid argument error in verify_inode_chunk

Matthew Wilcox (Oracle) (1):
      [0b4156b99b2a] xfs: Use abs_diff instead of XFS_ABSDIFF

Ritesh Harjani (IBM) (4):
      [c2dcf4a8a3a5] xfs_io: Add support for preadv2
      [92c62bdfa1d2] xfs_io: Add RWF_DONTCACHE support to pwritev2
      [840b472675ed] xfs_io: Add RWF_DONTCACHE support to preadv2
      [2d5aa51bee12] xfs_io: Add cachestat syscall support

Theodore Ts'o (1):
      [d2d034be62f4] make: remove the .extradep file in libxfs on "make clean"

Code Diffstat:

 configure.ac             |  1 +
 include/builddefs.in     |  1 +
 include/buildrules       |  2 +-
 include/linux.h          |  5 ++++
 include/platform_defs.h  | 19 ++++++++++++
 io/Makefile              |  7 ++++-
 io/cachestat.c           | 77 ++++++++++++++++++++++++++++++++++++++++++++++++
 io/init.c                |  1 +
 io/io.h                  |  6 ++++
 io/pread.c               | 62 +++++++++++++++++++++++++++-----------
 io/pwrite.c              | 14 +++++++--
 libxfs/libxfs_api_defs.h |  1 +
 libxfs/xfs_alloc.c       |  8 ++---
 m4/package_libcdev.m4    | 19 ++++++++++++
 man/man8/xfs_io.8        | 16 ++++++++--
 repair/dino_chunks.c     |  2 +-
 repair/phase6.c          | 46 ++++++++++++++++++++++++-----
 repair/scan.c            |  2 +-
 18 files changed, 251 insertions(+), 38 deletions(-)
 create mode 100644 io/cachestat.c

-- 
- Andrey

