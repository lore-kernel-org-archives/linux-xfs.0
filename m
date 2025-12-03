Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305A2261B96
	for <linux-xfs@vger.kernel.org>; Wed,  3 Dec 2025 19:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764788644; cv=none; b=cdXPHBZFSIMmDJ29RzrP0GuV9hPFA1JyJgJ/xdvoHBOqsXYVgMv66ai/K+yDnINAt3Qn7LifzWF8NgH4EfIdUiN8yMQ6g9A9rKaKe/T7VewWJ1e17W8FXqWvtcB3/T5I3WujiwS/OjYHvNWO69pTviyhvRtpVIaHRY0rC5Ox/Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764788644; c=relaxed/simple;
	bh=NY/RO1FruZfRNwynrG1/L4g3SzG4BwlIeJUbWVR4E3s=;
	h=From:Date:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=I7ZVhBDv7RVyMQjwoywlpxkw+N2vZ1SMR11tJiDiS4uoy5Xs2XftDdv3B6Fie6nAuOa1Evzy7i7LfIfd3z9R9dRyLxOGfC92ALOaBD8TctvueLRxjsPUBx+WOHjQXLhYBdFBtC2+CCVmJVRPnth5BwWPWjWbVK1iI4AyPkcJ4Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A/wca0oO; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=rLXD1yjy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A/wca0oO";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="rLXD1yjy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764788642;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=wMVR255bVbe+jLTC0cug2iKb9uXmy1h5p56KLI7iMFM=;
	b=A/wca0oOtcQaUhiy+C8TINQaruQR2Buz/0z8Akh4zktypBno0/D2jZgPmxFCxmtjAGa5V2
	qtXO9cty+SiOrH4QRGSTxDKgvs4MSz9pys2vGCpNfovns3Mvx5WeWvzhMXhbAmMU4IKmMn
	hJf/e063UTZ62nb/5HDy9VFWGWHSm2o=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-15-lfo_4FBeMCew6u7UVyTObw-1; Wed, 03 Dec 2025 14:04:01 -0500
X-MC-Unique: lfo_4FBeMCew6u7UVyTObw-1
X-Mimecast-MFC-AGG-ID: lfo_4FBeMCew6u7UVyTObw_1764788640
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-42e2e3c3e1aso64785f8f.1
        for <linux-xfs@vger.kernel.org>; Wed, 03 Dec 2025 11:04:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764788639; x=1765393439; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:to:date:from
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wMVR255bVbe+jLTC0cug2iKb9uXmy1h5p56KLI7iMFM=;
        b=rLXD1yjyldyX6CEGwCOv+Cp641REvij2qzUUFiPk6REfz+fAbT+ohQbzjQiNdxYJ1O
         L733oqLgZqx424SeL1Q7op/KAkhsyAwDclXOutx04d47DSRXhpojiY7QwIpHetMCCLgo
         IanrHd75Dk/39T8UbAi5Un+sDiryB84QePoP8Hf6zYoSHScWaNar8dtB70TCXQLMszP+
         QLMu5LW9sRewRhJOuuUKRBIfY3kf0fVQw+mDK5pl0pxoELcEejc+5Z3HOdNjdDMuNn27
         GdDqDJEWzvltec16wponGu94I/2nBaWDMi9Mu0I0sQCaMbvqp9vfFKqsszN5e7Ivg7wI
         zSpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764788639; x=1765393439;
        h=content-disposition:mime-version:message-id:subject:to:date:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wMVR255bVbe+jLTC0cug2iKb9uXmy1h5p56KLI7iMFM=;
        b=AWaEwmmgK2PehOeyGc1mxDcXIhBk5mnyiFalEeQ9NsF+S+8oncgNs+jaEpns7ycAhM
         jlC4G8kXAvOpaVt/7zq9IHYg/VX+KQgbwrqpreZF8umdou7iFMxIomkSbAls0HTzjYM4
         g3fenDLxTuJCl28dZ5E/ulhuajw7RHCwloY/DYOWlio1yPddm6FyTMC0TXA+TzYZRbp5
         9ktwUhjo73UGtrxUJnANoENL+/2wmvgEKVbROBtBRBqigUH1DNoIetIWBU91CDsfHpGT
         BSQBtV5yxFmReq863vxT9/LHL4YgKOLGraLZJuaOP2OWVoKlhsFD6uRhYIsc37EgYvqf
         YW0w==
X-Gm-Message-State: AOJu0Yz3ANXJ+x8PdtdNQJjlyIPWr1SX2RokuwBAIR2eH6qn9WiezOm1
	Nb/HzwktCr6BQNhtRrpToShmpydwoIxv6OA8768UypMZ5B4vLPW3DzoK73J1TYfmQZAEBD1hOhm
	tgeQDdWfanIBFCsmwRokY2DSWsGDgtCgtGPTEDIMxPiWud3aGd4s+kYnkUP31YXw1D6rxY3Tpyg
	3m9CAfzaFU2OdigENfdtoHVxFZB7pLnSKFDo56Pb0a0GyA
X-Gm-Gg: ASbGncvJhP9F/gcoFAR4S7RuVG9uMPl8HKs60zJPuY8mfywIizaGb/jJumZ8JMLAY2B
	PT0Xd74LxdcRO/+RY6xJf++awG/TwWTLPquXMTxglBEvdcNWNqVik7OH1oKW5URdy6mp7cNgyBj
	IcpFBD4zgDZXs/IzsKPwvvbJkYO48Fi4tsjnFUBP9G51qUUv2ybNt0iGADKGuX4GcQ1S0M3IVU+
	cWZ9bxbozV7u1Wl8ZfokNoIQ4XMpcx5p/Ed+RQiybGy4gWm0RGqbPJlbcJlQ3pnYIvEKzo96x7o
	q4e+vvRyLxWsMcEmAP/4y8TBP3YUJEKQoZo3PdAyUvFFOkU6vkF+3hN9SWmmx4aUK5HVjGdGnAU
	=
X-Received: by 2002:a05:6000:40c9:b0:42b:3746:3b88 with SMTP id ffacd0b85a97d-42f731cc0d4mr3834713f8f.57.1764788639472;
        Wed, 03 Dec 2025 11:03:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGv3Gt4JsYAvEn2BTzsNnpKSFFIn1juzxO2RYYUYl3GHGMw7zLQmq1NpT6VlAHAcd7ngMO/og==
X-Received: by 2002:a05:6000:40c9:b0:42b:3746:3b88 with SMTP id ffacd0b85a97d-42f731cc0d4mr3834665f8f.57.1764788638813;
        Wed, 03 Dec 2025 11:03:58 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42e1c5c3c8csm49674907f8f.2.2025.12.03.11.03.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 11:03:58 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 3 Dec 2025 20:03:57 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH 0/34] xfsprogs: libxfs sync v6.18
Message-ID: <cover.1764788517.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all,

This is libxfs sync for v6.18. A lot of typedef cleanups mostly.

I replaced removed typedefs throughout xfsprogs and adjusted formating a
bit around these changes, and updated XFS_TEST_ERROR() macro in the
original commit to ignore expr argument. Nothing else changed.

Andrey Albershteyn <aalbersh@kernel.org>:
  xfs: remove deprecated mount options
  xfs: remove deprecated sysctl knobs
  xfs: remove the xlog_op_header_t typedef
  xfs: remove the xfs_trans_header_t typedef
  xfs: remove the xfs_extent_t typedef
  xfs: remove the xfs_extent32_t typedef
  xfs: remove the xfs_extent64_t typedef
  xfs: remove the xfs_efi_log_format_t typedef
  xfs: remove the xfs_efi_log_format_32_t typedef
  xfs: remove the xfs_efi_log_format_64_t typedef
  xfs: remove the xfs_efd_log_format_t typedef
  xfs: remove the unused xfs_efd_log_format_32_t typedef
  xfs: remove the unused xfs_efd_log_format_64_t typedef
  xfs: remove the unused xfs_buf_log_format_t typedef
  xfs: remove the unused xfs_dq_logformat_t typedef
  xfs: remove the unused xfs_qoff_logformat_t typedef
  xfs: remove the unused xfs_log_iovec_t typedef
  xfs: fix log CRC mismatches between i386 and other architectures
  xfs: move the XLOG_REG_ constants out of xfs_log_format.h
  xfs: remove the expr argument to XFS_TEST_ERROR
  xfs: improve default maximum number of open zones
  xfs: prevent gc from picking the same zone twice
  xfs: convert xfs_buf_log_format_t typedef to struct
  xfs: convert xlog_op_header_t typedef to struct
  xfs: convert xfs_trans_header_t typdef to struct
  xfs: convert xfs_log_iovec_t typedef to struct
  xfs: convert xfs_qoff_logformat_t typedef to struct
  xfs: convert xfs_dq_logformat_t typedef to struct
  xfs: convert xfs_efi_log_format typedef to struct
  xfs: convert xfs_efd_log_format_t typedef to struct
  xfs: convert xfs_efi_log_format_32_t typedef to struct
  xfs: convert xfs_extent_t typedef to struct
  xfs: convert xfs_efi_log_format_64_t typedef to struct

Diffstat:
  include/xfs_trans.h       |  10 +++++-----
  libxfs/defer_item.c       |   2 +-
  libxfs/libxfs_priv.h      |   2 +-
  libxfs/rdwr.c             |   4 ++--
  libxfs/util.c             |  10 +++++-----
  libxfs/xfs_ag_resv.c      |   7 +++----
  libxfs/xfs_alloc.c        |   5 ++---
  libxfs/xfs_attr_leaf.c    |  25 ++++++-------------------
  libxfs/xfs_bmap.c         |  31 +++++++++++--------------------
  libxfs/xfs_btree.c        |   2 +-
  libxfs/xfs_da_btree.c     |   2 +-
  libxfs/xfs_dir2.c         |   2 +-
  libxfs/xfs_exchmaps.c     |   4 ++--
  libxfs/xfs_ialloc.c       |   6 +++---
  libxfs/xfs_inode_buf.c    |   4 ++--
  libxfs/xfs_inode_fork.c   |   3 +--
  libxfs/xfs_inode_util.c   |  11 -----------
  libxfs/xfs_log_format.h   | 150 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------------------------------------------------------------------
  libxfs/xfs_log_recover.h  |   2 +-
  libxfs/xfs_metafile.c     |   2 +-
  libxfs/xfs_ondisk.h       |   2 ++
  libxfs/xfs_refcount.c     |   7 +++----
  libxfs/xfs_rmap.c         |   2 +-
  libxfs/xfs_rtbitmap.c     |   2 +-
  libxfs/xfs_rtgroup.h      |   6 ++++++
  libxfs/xfs_sb.c           |   9 +++------
  libxfs/xfs_zones.h        |   7 +++++++
  libxlog/xfs_log_recover.c |  20 ++++++++++----------
  logprint/log_print_all.c  |  28 ++++++++++++++--------------
  logprint/log_redo.c       |  89 +++++++++++++++++++++++++++++++++++++++++++++++------------------------------------------
  logprint/logprint.h       |   2 +-
  31 files changed, 214 insertions(+), 244 deletions(-)

-- 
- Andrey

