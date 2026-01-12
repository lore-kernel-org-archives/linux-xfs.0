Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865E62BDC34
	for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 14:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768229392; cv=none; b=rZM3oa9cQoiXjbX1cvuHtDmlnBfOdUkqoG4jxuuZ7YBWWHzXIps88LGTgKymkzzOUe08JEdpWQ3uFxUs/QdbMuFWwDYAYLcAb2vQG3iKSSKPnU9cXZBvvLb1QpzO5hdLgiwFjt/jJNF27m5s/BPZRmU/SOe6k+EmGavnZEfqp1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768229392; c=relaxed/simple;
	bh=KR0cTxHaJS3TcZGRenZGtFBXNangwhA2X4UcgUh+yz4=;
	h=From:Date:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=JgxOd7Z+rYIzcwINPFuX5wAftrUtCmWYd6fZfTNFcxhVTtYVG+1vfuL9ptPQNRnKxA+5M8+k+UBP4/IuqkKetRsR6b7zTtjkJ8cTmDQiKv2W9juxPdPnSMb2+4+vCmh98pnbuucGFkELfESIHMQ4Ga100lPpHue33o0qXbUJd1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NeaEwV/s; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=n5EtrRwo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NeaEwV/s";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="n5EtrRwo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768229390;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=JtQ4ZpPQA3h2q2Fz6cxHWY8WGs2l4npsNwLGIggSgs8=;
	b=NeaEwV/sGPh2qF7m8FOHW0ml3CSwKvLIiNepihce99VtE7Sr1Gl3TLSb2Na/2tqw3vuViC
	bCUPbXsht77OUxNCuFZDX8EqRL70DGD0/cjfnYOjNB3D+TAhhmLPaVDj83i0F4EdevXViJ
	RkG97+4nUBMy7UXaFBzPLfMxALH2Z7I=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-608-21h9vnIvOhGK4VOgl5l2Qw-1; Mon, 12 Jan 2026 09:49:48 -0500
X-MC-Unique: 21h9vnIvOhGK4VOgl5l2Qw-1
X-Mimecast-MFC-AGG-ID: 21h9vnIvOhGK4VOgl5l2Qw_1768229386
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-b8720608e53so106950466b.1
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 06:49:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768229386; x=1768834186; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:date:from
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JtQ4ZpPQA3h2q2Fz6cxHWY8WGs2l4npsNwLGIggSgs8=;
        b=n5EtrRwowlfN7Y69e2VE2te5kSfFqVKETfqCjJpgf7vV/WiaPtBzuVqRrFeGVgvNO6
         G3H+cJ/GA8aAySYh7oHqd4LRlLQ7E3vd0WJ4VD1lI2E0j1/8qfrpOsxInVgpIAx53NJ/
         4TM+bQB3s2+MbnL3RxRlYLO7+OSdunU4KN4JEDNPMdnUGlw7NBP0t3XegrCw0kln/Yy6
         g24Ax+CxRQ3NUgiusvbQBCvIlJvrBWB2SYx4RWE2PKyO91BHqmDvbzZxjfCzZIJV9RSU
         R9nu4eHmBcuhCnC9glNeczKuxhT9yP+h3fNUkJdigCztUZbI5d2SF+44H07D2opeA/oH
         f0cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768229386; x=1768834186;
        h=content-disposition:mime-version:message-id:subject:cc:to:date:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JtQ4ZpPQA3h2q2Fz6cxHWY8WGs2l4npsNwLGIggSgs8=;
        b=rN5EDngFtHJfh5UDeWPewnkoik7oTdo3UWRj6IabUDW4cCzGyohvj8xgA5dVvE8T/+
         R75OrEWu5AzFf4BktFkGa25P6bf0nbby+n1U0cv19CKu/ZqhWPOKe7VTF6mTojYJXkHU
         6QJo0cPJHZ4fritmC63W5XG94VIugI239OL4ph9uMhL1s6oyRh03Jg34hux56DwiUlrg
         Gz2NsXRfHtG67Tm9ZaxXYqjnJHRB28W3+yr/fuFVK9KbEFocP8xYr0BQnjifbx3b57RL
         deZQvIX99vhL/bPaVdSjhuUge74FTqxrsDEO8l/JER49zDUEH6CYWITSC1a6KX49JLgh
         WWWQ==
X-Forwarded-Encrypted: i=1; AJvYcCXSTVTcJenhry4CZ5YiEj1zGRSGU44+V5VvJCwkGjoNJyZnlVnRKini+Zwpu+qcT0M0nWUOJqNdkxM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNILGRzTtxXknP/FkQawRVc+Z8+WhxSNN44J4Y6QJRLavGsgAL
	8p4NaAS59Wa4rvj+1rpTiHyvuSAE/PsoW8Qd2d+FoWWJqKEMv8obORs/0VysrJY4A64JQNpQBql
	HIo06Ge8O4+JIWx+vlXVkW3n3/z5jJZ9OfFMJzzZ12rxTe1QLYdCTc3U4f8oI
X-Gm-Gg: AY/fxX5pcqpIEQGqsv0/3GzbuzVHtTxss4CLwhDToKaxJp2zIbcQdbclrojIErFYrWH
	l8PYKrkTJuBVq/Q7UEEu9dwwPC5/H68gO47/H68JBJVQi9xLN1zw1Ml7HwhAinwNC/cRbyZqNXl
	1DDB+YTUgnSeVqrSh48X65W8jWw5aQ8TvrvVjNxkNoGiNl0C+7qWUzrsyf8UzNv3c0BZzm9K1td
	/lrubAon4MkddtAODinQNRDfXfFiNsBr5bKTZyCJWJgbp3LXCNFYe43tDVu37MviRoxbKmonI6F
	86Npi/0V8HAJv/sTt2Sn92eiakkySAzPZVEV6UQEBoefIGXchdfyQ2wS9ejVQ3MQ6ZGLhUrVUiU
	=
X-Received: by 2002:a17:906:fe4c:b0:b73:826a:9102 with SMTP id a640c23a62f3a-b8444fd0a3dmr1812182066b.49.1768229386360;
        Mon, 12 Jan 2026 06:49:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGEJfpQO2bUi21cHmaMt6C52aF3UlwMys3fAQFJkDRHMGLFiJve64PAQ/gKcqGFmeCzVUIjhw==
X-Received: by 2002:a17:906:fe4c:b0:b73:826a:9102 with SMTP id a640c23a62f3a-b8444fd0a3dmr1812179366b.49.1768229385851;
        Mon, 12 Jan 2026 06:49:45 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6507b8c4484sm18054453a12.7.2026.01.12.06.49.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 06:49:45 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Mon, 12 Jan 2026 15:49:44 +0100
To: fsverity@lists.linux.dev, linux-xfs@vger.kernel.org, 
	ebiggers@kernel.org, linux-fsdevel@vger.kernel.org, aalbersh@kernel.org, 
	aalbersh@redhat.com, djwong@kernel.org
Cc: djwong@kernel.org, david@fromorbit.com, hch@lst.de
Subject: [PATCH v2 0/23] fs-verity support for XFS with post EOF merkle tree
Message-ID: <cover.1768229271.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all,

This patch series adds fs-verity support for XFS. This version stores
merkle tree beyond end of the file, the same way as ext4 does it. The
verity descriptor is stored at the tail of the merkle tree.

The patchset starts with a few fs-verity preparation patches. Then, a few
patches to allow iomap to work in post EOF region. The XFS fs-verity
implementation follows.

Preallocations. The preallocations are disabled for fs-verity files. If
inode is fs-verity one the allocation size is set to zero. This is fine
as the only writing happening is merkle tree data and descriptor. It
would be nice to allocate tree size on first write, this could be
improved in the future.

The tree is read by iomap into page cache at offset 1 << 53. This is far
enough to handle any supported file size.

Testing. The -g verity is passing for 1k, 8k and 4k with/without quota,
the tests include different merkle tree block size.

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


Andrey Albershteyn <aalbersh@kernel.org>:
  fsverity: expose ensure_fsverity_info()
  iomap: introduce IOMAP_F_BEYOND_EOF
  iomap: allow iomap_file_buffered_write() take iocb without file
  iomap: integrate fs-verity verification into iomap's read path
  xfs: add fs-verity ro-compat flag
  xfs: add inode on-disk VERITY flag
  xfs: initialize fs-verity on file open and cleanup on inode destruction
  xfs: don't allow to enable DAX on fs-verity sealed inode
  xfs: disable direct read path for fs-verity files
  xfs: add verity info pointer to xfs inode
  xfs: introduce XFS_FSVERITY_CONSTRUCTION inode flag
  xfs: introduce XFS_FSVERITY_REGION_START constant
  xfs: disable preallocations for fsverity Merkle tree writes
  xfs: add writeback and iomap reading of Merkle tree pages
  xfs: add fs-verity support
  xfs: add fs-verity ioctls
  xfs: add fsverity traces
  xfs: enable ro-compat fs-verity flag
Darrick J. Wong <djwong@kernel.org>:
  fsverity: report validation errors back to the filesystem
  xfs: advertise fs-verity being available on filesystem
  xfs: check and repair the verity inode flag state
  xfs: report verity failures through the health system

Diffstat:
  fs/iomap/bio.c                  |  66 +++++++++++++++++++++++++---
  fs/iomap/buffered-io.c          |  31 ++++++++++---
  fs/iomap/ioend.c                |  41 ++++++++++++++++-
  fs/iomap/trace.h                |   3 +-
  fs/verity/open.c                |   4 +-
  fs/verity/verify.c              |   4 +
  fs/xfs/Makefile                 |   1 +
  fs/xfs/libxfs/xfs_format.h      |  13 +++--
  fs/xfs/libxfs/xfs_fs.h          |  24 ++++++++++
  fs/xfs/libxfs/xfs_health.h      |   4 +-
  fs/xfs/libxfs/xfs_inode_buf.c   |   8 +++
  fs/xfs/libxfs/xfs_inode_util.c  |   2 +
  fs/xfs/libxfs/xfs_sb.c          |   4 +
  fs/xfs/scrub/attr.c             |   7 +++
  fs/xfs/scrub/common.c           |  53 +++++++++++++++++++++++
  fs/xfs/scrub/common.h           |   2 +
  fs/xfs/scrub/inode.c            |   7 +++
  fs/xfs/scrub/inode_repair.c     |  36 +++++++++++++++
  fs/xfs/xfs_aops.c               |  20 +++++++-
  fs/xfs/xfs_bmap_util.c          |   7 +++
  fs/xfs/xfs_file.c               |  23 ++++++++--
  fs/xfs/xfs_fsverity.c           | 395 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  fs/xfs/xfs_fsverity.h           |  12 +++++
  fs/xfs/xfs_health.c             |   1 +
  fs/xfs/xfs_icache.c             |   3 +
  fs/xfs/xfs_inode.h              |  11 ++++
  fs/xfs/xfs_ioctl.c              |  16 +++++++
  fs/xfs/xfs_iomap.c              |  28 ++++++++++--
  fs/xfs/xfs_iops.c               |   4 +
  fs/xfs/xfs_message.c            |   4 +
  fs/xfs/xfs_message.h            |   1 +
  fs/xfs/xfs_mount.h              |   2 +
  fs/xfs/xfs_super.c              |  16 +++++++
  fs/xfs/xfs_trace.h              |  46 ++++++++++++++++++++
  include/linux/fsverity.h        |  16 +++++++
  include/linux/iomap.h           |  16 +++++++
  include/trace/events/fsverity.h |  19 ++++++++
  37 files changed, 924 insertions(+), 26 deletions(-)

-- 
- Andrey

