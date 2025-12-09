Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1163322A2E
	for <linux-xfs@vger.kernel.org>; Tue,  9 Dec 2025 12:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765282993; cv=none; b=AYbP9YGRrsG8iWgcNnrbTzY2UcamN41wj2TfWLdIL0H+z/rr8d3aiu1lry0RwCrabidvsAttP8fXMJT6ni7+A49T5lYaKGFHj2xheSrLZ79ljvHkl6BBGWzAstTm46oF02S5plr2ksrYJBunXdQY8RBG/S+VE5tBSac3O/suwIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765282993; c=relaxed/simple;
	bh=2wSVnqhXt3k53GepktJHHpoMImvbnE3j8JKmtVK8wTc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=O1fnxVkF/XAaISTOkGsuRJJJ9c3+8zZRYJWmjbyTCGgklxCc0uU6Zd521fuXlltxSEJ+97T8783PSyHCj+Qk5tSUkmdIrx/iDwZfnM/a6lpkY4sLRlUhwWOVDJiJR2/Nmt8nJXtfdri4cHXMEFQX6SbkR/alp9A9WIgqihE5BrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b3D2oqoi; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Bsp6CFki; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b3D2oqoi";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bsp6CFki"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765282990;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=EznKO9sETrXpNK/qzX9g68NJgdoa5WdvhSXMReE6lTw=;
	b=b3D2oqoisCf/U7GiXs2u1Qle6c+4lGfpX9x5cscMxrNYrMY6gDaalYDlAvP1Xu5Kmhl0t6
	Jy/mxnxlKmrnFo1eidPFf/zM/uTasUDBz1Bq2iOQq+lbC/9BUieVNWLSpWRVaK7a4Umy+q
	RKH0zRwcQT1RLDvPerLPC0m6qlt8nSg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-329-HJzJi-UhN3y2vqFVCz3fng-1; Tue, 09 Dec 2025 07:23:09 -0500
X-MC-Unique: HJzJi-UhN3y2vqFVCz3fng-1
X-Mimecast-MFC-AGG-ID: HJzJi-UhN3y2vqFVCz3fng_1765282988
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-42e2e50cfaeso4457905f8f.3
        for <linux-xfs@vger.kernel.org>; Tue, 09 Dec 2025 04:23:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765282988; x=1765887788; darn=vger.kernel.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EznKO9sETrXpNK/qzX9g68NJgdoa5WdvhSXMReE6lTw=;
        b=Bsp6CFkiZAWuvjtzFld+SgRsQlpuT7laAXcw+z/1v2B5sO4G70ct/rL8e6iOZ4JkO6
         3Ls5H/6+3XWrrXcqzPtCglWYQhn3IJ357hjSc7j27TV7PSs3xoBX6ZXzjpDLOsR8vx4f
         psyJ4XQflvhjUSzDgf210Ok89NRSAaMXSlsre4LM4WZeZomkAbJZmDYWY8KCwWEUTcUX
         IjeMsfhV+r2FBrGhhuUTOBkDes0SUfUKSr9D72l6VvitQQY9UjKFOMfxVy4ppwL/gGWL
         E1c+b81mbJWI3DJnv2rz8zcHoyeEAxAutntJkKhhLXGtjzwsRW+Lz9tingQGNXbZYTd2
         BBPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765282988; x=1765887788;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EznKO9sETrXpNK/qzX9g68NJgdoa5WdvhSXMReE6lTw=;
        b=cIzyDqcJYE5knsZW0tAgsbsbcoP+4BetLOTwrC2HTmuJgV+2haNMub+suzECis1C6d
         uzGPWvenLIRGkGPS6eJV9FPO+UBeC8EVf9TjpKtv6+jXEvaFS5SVIHjzY1W3ksKOQh/5
         bfJyMDqil0trsXWa9jP3YDpI6Qh0dieYOra1UmiR15u6GmcaRMpXqVndfbkydcUESfLV
         a20yNc8SYuwQv7Z5Q8mwlRlR920IEiplYKU4hmWyIlN32hbBEseOsCX2AXLqvecffBnA
         MG4oEtOv+RobNcouvwVVObX1n3HDuSBEdqNhaC25t4gISolP1OSieUM3CgbMbfwrkHUB
         Q59A==
X-Gm-Message-State: AOJu0Yw82Vv24uJcp6FsFhh/UPbZMz+cxdo2YT9trcYbn/2DmM7JC1Bb
	7MTVOdFgyNIYpXnt83qsyyJTtFh/xVpPmrBBrnPi+P4LGd5sWe4p7GJqqiM6JMPOSsz4iV32ykX
	JkdGPlnzxoG2OXlus76I/vS16maOLbpra3Zdi3iU1BPMCRf1d+ZbrEnEj/2stjEkGYJxcHrLUKa
	7QBSEJZvOcGq2Ic1lpmlFZVXM3s95kP9EuzgnucihOwq4s
X-Gm-Gg: AY/fxX5YRHrnx7pnoN4Byls1ehxi6fVjlXKkR78LbzY6goCEn7YQlaG9F4xwzxp9ZlL
	APID0pWV4R5fCxnu5QeJuTW4Z0EjSh4oK9/uQorDyzNbE34AQIesP/W8CWPagnbnUBWHAQjua6S
	zOrN/RAVD+uHwGq2or6spB4GKVc0wJ30GSLpVsxbUHtAQYroMK7KlIStiqjxpRgDJtDwSo45HLU
	J8V/klRXCMqS7uQg8/MJFr8i74s01GOb1x2IPjhlYT1AqjcA2E/Dm0eYaT5/1cuyGEMTMcCZ7N7
	bbbwR1x8UGchr6e4UhCNIZIUk5pOzCxNC+cRV/mjSyPnk8wcxmgHnSc9N+awM9omKjggfoB3Ft8
	=
X-Received: by 2002:a05:6000:2c0d:b0:429:cd3f:f45f with SMTP id ffacd0b85a97d-42f89f09434mr9964134f8f.7.1765282987731;
        Tue, 09 Dec 2025 04:23:07 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGZJecRLufF56NHqTqcbatuBXOvqLNPVAuAwFx4Spmx7vTKA7gnmdHF+n6RS8HcmXTEouIoMg==
X-Received: by 2002:a05:6000:2c0d:b0:429:cd3f:f45f with SMTP id ffacd0b85a97d-42f89f09434mr9964088f8f.7.1765282987067;
        Tue, 09 Dec 2025 04:23:07 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7d331df0sm32367392f8f.36.2025.12.09.04.23.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 04:23:06 -0800 (PST)
Date: Tue, 9 Dec 2025 13:23:04 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org, arekm@maven.pl, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, linux-xfs@vger.kernel.org, preichl@redhat.com
Subject: [ANNOUNCE] xfsprogs: for-next updated to 3147d1d643c8
Message-ID: <qlaiaka4vz5xllquevsb3g6hadazucpzc2e4jgz3rynsld4yjc@rx3rmamowj3h>
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

The xfsprogs for-next branch in repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed
on the list and not included in this update, please let me know.

The for-next branch has also been updated to match the state of master.

The new head of the for-next branch is commit:

3147d1d643c8278f1b75dedf3a64037bece7da53

New commits:

Andrey Albershteyn (11):
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

Arkadiusz Miśkiewicz (1):
      [3147d1d643c8] libfrog: fix incorrect FS_IOC_FSSETXATTR argument to ioctl()

Christoph Hellwig (44):
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

Damien Le Moal (1):
      [cab8d3d9f493] xfs: improve default maximum number of open zones

Darrick J. Wong (5):
      [050f309cb853] libxfs: fix build warnings
      [6743140685dd] xfs_db: document the rtsb command
      [f274ed718111] man2: fix getparents ioctl manpage
      [7d00aed6e308] xfs: remove deprecated mount options
      [4b08d653fb25] xfs: remove deprecated sysctl knobs

Code Diffstat:

 include/linux.h                 |    2 +-
 include/xfs_trans.h             |    8 +-
 libfrog/file_attr.c             |    2 +-
 libxfs/defer_item.c             |    2 +-
 libxfs/libxfs_priv.h            |    2 +-
 libxfs/rdwr.c                   |    4 +-
 libxfs/util.c                   |   14 +-
 libxfs/xfs_ag_resv.c            |    7 +-
 libxfs/xfs_alloc.c              |    5 +-
 libxfs/xfs_attr_leaf.c          |   25 +-
 libxfs/xfs_bmap.c               |   31 +-
 libxfs/xfs_btree.c              |    2 +-
 libxfs/xfs_da_btree.c           |    2 +-
 libxfs/xfs_dir2.c               |    2 +-
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
 36 files changed, 1525 insertions(+), 1489 deletions(-)

-- 
- Andrey

