Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E805133BBCC
	for <linux-xfs@vger.kernel.org>; Fri,  5 Dec 2025 15:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764946916; cv=none; b=nAQ5ArQ/Y6k64Y+KFyvmUzqioCLg0hStrpngLsQWdfB/zPI6niR7J5isrYnxHRwGDR2hp7/SaAs0EOCt/EWPbn5uK9wNhpPNN4lyxozqarWXOjcKi+rhqrdICCjEQMUXi0NJVtkczVstT3EX+GBKIFFjhCkza3XLIa1PbSUY1yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764946916; c=relaxed/simple;
	bh=Rq7P1uOlHFBmEXkIBOBzTVK4a+xqA2H0Wlm5iWY1gQE=;
	h=From:Date:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=lT42ShMZlwwnSnJ32zg+ih+ozo7lydToRqLFMriEFKvdxwhb8POWua+7skqxNEwF8G3Gwu6l3e8Oc8vNBipvf7F656ODXLJc81quBGK143w5nB2+WhzPwueMMyVWaaea1l3dPX559RIAYpl3WqL5wfckBAPUKh6I5xnuNdQJBMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iCQECTF5; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=F7nPnVKn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iCQECTF5";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="F7nPnVKn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764946890;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=FfFYJwXyR60fbWNNYL0ZlNE7PC4PHOHPG5MSkL6eawY=;
	b=iCQECTF5E1xzuxDdSO3D4PfrpkAigxX/VjZi3WTMkq4oGFGmq5jgfDZvcDodqQOYxb4loj
	YDghJqcPT+kasA0k/rzBNXbdvn2TUJJOu/B0jmp2lnKUX0JfEt4LXxWsZe5Zs1Yq2Md/BF
	kosdsUGVo9hNiAHPULETcc3UViK588c=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-235-jSnCOpzPMOK9TS_Jk3J8Qw-1; Fri, 05 Dec 2025 10:01:29 -0500
X-MC-Unique: jSnCOpzPMOK9TS_Jk3J8Qw-1
X-Mimecast-MFC-AGG-ID: jSnCOpzPMOK9TS_Jk3J8Qw_1764946888
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-47918084ac1so18537805e9.2
        for <linux-xfs@vger.kernel.org>; Fri, 05 Dec 2025 07:01:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764946887; x=1765551687; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:to:date:from
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FfFYJwXyR60fbWNNYL0ZlNE7PC4PHOHPG5MSkL6eawY=;
        b=F7nPnVKn9pPTSlX3nxQdEGojbVCOLrfcY3PzWKvogtGjQ6UXL1qKMLTcT0EObGPGFV
         uVdQXZefWi1VsJCFF5jjOX+J6oMpnXbylG0b4Ee611h2pGdIhejvjxvrOG4c6INQUScB
         vFoiBJFEjKhJovS5xpihEPUyUTAwDwNJgnXsep2tJQzT1H6kUAFPuMc4MVIn351TRYYK
         AgRQ6iCXPgZ7ZBmDHnxesCEYkDQPxADinA9lHWA+ExCUIWcuR1zpwSikN8/6UKogmMpe
         Oaz9GHNXKTJIGDP4d9R90u6Em/Roga4txzkpsjQctY4cclmQHq4aFeUlMqay3zvTGqcn
         V9PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764946887; x=1765551687;
        h=content-disposition:mime-version:message-id:subject:to:date:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FfFYJwXyR60fbWNNYL0ZlNE7PC4PHOHPG5MSkL6eawY=;
        b=v4exhk9wxq4bop9xp486naQdn1si4FJjIKRCfQjJ9C935NJvbqK2liTJof9/6RS7vb
         DVKo4GYrZlqozm+tQ/OqNSKwJXC0zbIlT/d8ZztNPAqb3FSbUCO1TxcIds7x9LEIRKBG
         gNCvyCebZodfxcJGlMU2Lo1htY2jqgBE6d9czKs4jUQuJEwcAdr0cRhGQapnn70Kl1xi
         mNPxJh3dXw0uRvIBChbBxxBC6BlUU7YDT05Pv1rw1qOrQxl4VAZTifWvbYe42h2+Qcpq
         MV1Kocu69AE5apJCVLyz/yBYUkfvXRYEXdid099+FO0n6Z0d2EZjqB7LyYVCDnKuf7Zo
         BG1g==
X-Gm-Message-State: AOJu0YyOSUo5FOhMVZ8tJaoTM1WLAcOPHA8BMgBqYYUMvhZWdMnFDaOQ
	K4A3wx+4K3jYPK8uRXbFUhf6C+j9N2mRA+P2Nzp1i2ZeWbCoydo6wp/dcmqLOQDi786Bsm0YW+z
	LNexB1ZNAh8lGp8DtS3c8d4CKwIbbdFQXuu/5WR6Bg7n5o5IE4fW3Rj1PrQmG1haoCStYsnyJ7L
	xT1E/Y2XcpuZEKqqxI2n9Rgp3NBPr4bG+T/A13b0biBHd+
X-Gm-Gg: ASbGncvLZiOfHu3UMIGKyu3Fnh6B2kj1Q9eUPRLGK+Y6b0enSO1sA2ONiogUMbhe8Nk
	oFLUXGPp4DSE/Epjb6Yv6KDNpSSqRZnwJE5Z0m/p17qkiCtzw9rakbYAF1gCXwJSDDO3Hhp0PpF
	f4Pxn3bSF2Iqbq0a51+dNO8Ig8xQ1bLyJ2Ps8+886kIsP1x1Ho6dVmAh/+WeIK+Agm13flAIEf1
	VgRCW14ud0dFe/x9u8DsWi/tiyk3dD7M9Cj0IprEdOv1SaFSg0Ed+f5J1vifsKdQPeRF9QlvDd1
	UbUPwKSaXvdSeqPWMKMDuWDFTCeDEOy5bLPTbit4uLftffBvV2C7rXu58JoDzShNkGwfUdl6G28
	=
X-Received: by 2002:a05:600c:1c2a:b0:477:8985:4039 with SMTP id 5b1f17b1804b1-4792af1b697mr126327605e9.17.1764946887432;
        Fri, 05 Dec 2025 07:01:27 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHbaYa8Ws9aKWeNVd+cpiYDo1+nqkFgQypqkQ2FTLkgTtmfxpx/ukBuB3zKTNBq6MNzRVEPfw==
X-Received: by 2002:a05:600c:1c2a:b0:477:8985:4039 with SMTP id 5b1f17b1804b1-4792af1b697mr126326725e9.17.1764946886779;
        Fri, 05 Dec 2025 07:01:26 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4792b04e1c1sm60331165e9.5.2025.12.05.07.01.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 07:01:26 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Fri, 5 Dec 2025 16:01:25 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH v2 0/34] xfsprogs: libxfs sync v6.18
Message-ID: <cover.1764946339.patch-series@thinky>
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

v2:
- Moved all newly added "convert ... typedef to struct" before typedef
  removal commits
- Remove some retabs to not interfere with futher typedef cleanups

Andrey Albershteyn <aalbersh@kernel.org>:
  xfs: remove deprecated mount options
  xfs: remove deprecated sysctl knobs
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

Diffstat:
  include/xfs_trans.h       |   2 +-
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
  logprint/log_print_all.c  |  14 +++++++-------
  logprint/log_redo.c       |  89 +++++++++++++++++++++++++++++++++++++++++++++++------------------------------------------
  logprint/logprint.h       |   2 +-
  31 files changed, 203 insertions(+), 233 deletions(-)

-- 
- Andrey

