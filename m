Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA3036CE02
	for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 18:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756233594; cv=none; b=LZ2OhnRzYc6ixrbWSFVy7nmCMDuZY9rE45qY+jpZB5qLMhrkwKkAiCjkT2P25j5IGe5uUiZ2oTv1oeS5oX8EnSZXCRaZ4H6ET8hWumF2P8jT4FAnNRmuj+emtJedNzbn4TtxUHqNW/1rihReXNxLfgIz1gmYsPklTcuJENmzM8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756233594; c=relaxed/simple;
	bh=KjLkuPrHz71g7dFg0kc/ufw10+edhz7aULE033Hc8SY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=tiPrS37n1K4fGmgjIQhtlw2XqNyWEZMEjug1BHMVdMqVZ9cVZEluru4GDY/o9Eb+lwjOj9RSBsVWPgvrnOd186dBhOS6H0dW6LafQvZemUUEWeDawnksqj7SIFQfskN5NXW6SGvlzYzgMXIZNB81kjNLC5YwODaSaiNQ+eDtWp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BFIHVGux; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BFIHVGux"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756233591;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=yp3c7hiCHKUBSdLYc2ShPsfLYNyxpY+VSyFQd2ynqDs=;
	b=BFIHVGuxx18ApuUTbrSe9C/F54jSdiCXnNRrx4BjxWpX3yy3ZEFQybWn+BqGZtA2vYpPtd
	rFu1Av6ajNmo6YBmAgO77uDoDexjPMGAiXk4C+m8kriH9qxw6Mvab1y7BTkwnw7nDbHNms
	PjdxOpV7owxO+ebPsrfTBEwOj9dyAtQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-269-nDTJydlYM8G7kOvaNFOiqg-1; Tue, 26 Aug 2025 14:39:49 -0400
X-MC-Unique: nDTJydlYM8G7kOvaNFOiqg-1
X-Mimecast-MFC-AGG-ID: nDTJydlYM8G7kOvaNFOiqg_1756233588
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45a1b0bd6a9so33031845e9.2
        for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 11:39:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756233588; x=1756838388;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yp3c7hiCHKUBSdLYc2ShPsfLYNyxpY+VSyFQd2ynqDs=;
        b=nDrrwNJ7t7Fl8zrJiOG5gMDeNMkIGgo3e2IEMUgTQ7YoqT4kBfGJWZzb8RmW75xir+
         QyibGl/7TBRCyCL0VY8i5RITcLmd93Ngn7jNYqDKxXcvSlZhSQzHNHWCiXkfRnXugTOV
         5c3sNL2TYwiVKq75RJGdfiBdmMvPsfwBk2ZmS2j39DNE+Lgjimy4aACXul0vyZAt64ju
         CT1T7MPdLZutimlDipMdoYEe6QYOfasvuDawebm+iiM/3S1CkaNiNcTjo2fgj6W1ybws
         E1fmy+JOTFSub3MHaD0RRUexFdQFtwAqE2iAw9YXsQruuu1j+r+ByLyg277WHLpsSzby
         6tFQ==
X-Gm-Message-State: AOJu0YyMU3Ax0yX+/OgJXmHZF1lGfbYOSKtFGR7zLLqfccwF/JdarX5C
	OhfuGeSvBZk8xMqzRlK8xyMHePeyRelYqR3k5MV0LYA7s8YN4AKahKiBO7ncITo8s9T35W4aset
	EuZvyDuuigNLDeFDt7cJdFgalbGyp0OPjKP/xhd1RLxEGUWVL8QIrnwVKlA+VVx21OMnvcxoY7K
	H5TC7q+kzmgGAJujO8NcwabkQ+5U7M5NsRKnZ6yUbv9ljV
X-Gm-Gg: ASbGnctvp4+8sVEQcubk7xK8yPKtYmTQiiLDC7XNUGiaIhXSkoajt3hsLYMNb+uJFN+
	5qNVUeHmT8xOXcF0+PtNe3kCSpUeiKcUnQwIBntDt8Z9MTP9uVgiHu+yVSeqYvna5aw0MbfBAqx
	4xEllNKySoSFp8EVSp78LqPEag3dNWSuqCUOuc1JXhUUjU9WCXH5wnYw/1+FXIt80kowqAaDx9W
	zotFiNKTbscji8yCEFh35p/vxPKTDiorecR6GL7GUDSMeoSuvmkiHGdGovbfpNwHHfQg/qKoOH4
	U5GSi/xoZr4ak3y13jqTLHz3kFTQbf8=
X-Received: by 2002:a5d:5d08:0:b0:3cb:71cf:2c54 with SMTP id ffacd0b85a97d-3cb71cf30b7mr3076979f8f.53.1756233587748;
        Tue, 26 Aug 2025 11:39:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHexzu8z64Yabw/NoI51SrET84WsizHNhCA3q8BTaV5JjoSIRfZKDj1XGLHJMBmS5VvIEtnMA==
X-Received: by 2002:a5d:5d08:0:b0:3cb:71cf:2c54 with SMTP id ffacd0b85a97d-3cb71cf30b7mr3076949f8f.53.1756233587246;
        Tue, 26 Aug 2025 11:39:47 -0700 (PDT)
Received: from thinky ([91.245.205.131])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c70ef566dcsm17099482f8f.24.2025.08.26.11.39.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 11:39:46 -0700 (PDT)
Date: Tue, 26 Aug 2025 20:39:45 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org, cem@kernel.org, cmaiolino@redhat.com, 
	contact@xavierclaude.be, dchinner@redhat.com, djwong@kernel.org, hch@lst.de, 
	john.g.garry@oracle.com, linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsprogs: v6.16.0 released
Message-ID: <kakabo6b6w6pk7hnzvfixictwdxp7xfvf5lw4l3eatfzee723f@pxjxhgdb2cfp>
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

1d287f3d958ebc425275d6a08ad6977e13e52fac

New commits:

Andrey Albershteyn (1):
      [1d287f3d958e] xfsprogs: Release v6.16.0

Christoph Hellwig (3):
      [f3fe5f5eecfa] xfs: don't allocate the xfs_extent_busy structure for zoned RTGs
      [ea5d15f34e81] move xfs_log_recover.h to libxfs/
      [0c5c99ee8669] libxfs: update xfs_log_recover.h to kernel version as of Linux 6.16

Darrick J. Wong (12):
      [1705e1fabf77] xfs: add helpers to compute transaction reservation for finishing intent items
      [4c6a63fdb9d4] libxfs: add helpers to compute log item overhead
      [1ba98d1f4fd9] xfs: allow sysadmins to specify a maximum atomic write limit at mount time
      [fe8cfecb916f] libfrog: move statx.h from io/ to libfrog/
      [b5b477a38244] xfs_db: create an untorn_max subcommand
      [55b28badd9c1] xfs_io: dump new atomic_write_unit_max_opt statx field
      [875e57e81ce4] mkfs: don't complain about overly large auto-detected log stripe units
      [5015906cf669] mkfs: autodetect log stripe unit for external log devices
      [b245cf325293] mkfs: try to align AG size based on atomic write capabilities
      [3423827c2ed3] mkfs: allow users to configure the desired maximum atomic write size
      [854665693e67] xfs_scrub: remove EXPERIMENTAL warnings
      [466e8aa6e0e8] misc: fix reversed calloc arguments

Dave Chinner (1):
      [68facb8397c5] xfs: catch stale AGF/AGF metadata

John Garry (4):
      [5049ea2e832a] xfs: allow block allocator to take an alignment hint
      [8ccf3002f5f7] xfs: commit CoW-based atomic writes atomically
      [9ae045b77d88] xfs: add xfs_calc_atomic_write_unit_max()
      [264762bb42b9] mkfs: require reflink for max_atomic_write option

Xavier Claude (1):
      [9ec44397ea2a] Document current limitation of shrinking fs

Code Diffstat:

 VERSION                   |   2 +-
 configure.ac              |   2 +-
 db/logformat.c            | 129 ++++++++++++++++++
 db/namei.c                |   2 +-
 debian/changelog          |   6 +
 doc/CHANGES               |  11 ++
 include/bitops.h          |  12 ++
 include/libxfs.h          |   1 +
 include/platform_defs.h   |  14 ++
 include/xfs_log_recover.h |  47 -------
 include/xfs_trace.h       |   3 +
 io/stat.c                 |  21 +--
 libfrog/Makefile          |   1 +
 {io => libfrog}/statx.h   |  23 +++-
 libxcmd/input.c           |   2 +-
 libxfs/defer_item.c       |  51 +++++++
 libxfs/defer_item.h       |  14 ++
 libxfs/libxfs_api_defs.h  |   5 +
 libxfs/topology.c         |  36 +++++
 libxfs/topology.h         |   6 +-
 libxfs/xfs_alloc.c        |  41 ++++--
 libxfs/xfs_bmap.c         |   5 +
 libxfs/xfs_bmap.h         |   6 +-
 libxfs/xfs_group.c        |  14 +-
 libxfs/xfs_ialloc.c       |  31 ++++-
 libxfs/xfs_log_recover.h  | 174 ++++++++++++++++++++++++
 libxfs/xfs_log_rlimit.c   |   4 +
 libxfs/xfs_trans_resv.c   | 339 +++++++++++++++++++++++++++++++++++++++++-----
 libxfs/xfs_trans_resv.h   |  25 ++++
 logprint/log_misc.c       |   2 +-
 m4/package_libcdev.m4     |   2 +-
 man/man8/mkfs.xfs.8.in    |   7 +
 man/man8/xfs_db.8         |  10 ++
 man/man8/xfs_growfs.8     |   1 +
 man/man8/xfs_scrub.8      |   6 -
 mkfs/xfs_mkfs.c           | 257 +++++++++++++++++++++++++++++++++--
 repair/phase3.c           |   2 +-
 repair/quotacheck.c       |   2 +-
 scrub/xfs_scrub.c         |   3 -
 39 files changed, 1177 insertions(+), 142 deletions(-)
 delete mode 100644 include/xfs_log_recover.h
 rename {io => libfrog}/statx.h (94%)
 create mode 100644 libxfs/xfs_log_recover.h

-- 
- Andrey

