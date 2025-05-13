Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53ED28C5A5;
	Tue, 13 May 2025 12:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747139164; cv=none; b=fexyKxC6qwID/KR0LZjwC6cqyxI1c4Rd02tKVkiJsgWu6Ywdfgz/ctFjnaEJEvVC+NPM2BlYXHLfoeH4j8yIKiaTfimlaJp6kNhOQYMkRNkyqo9IwiSQlBJ/tot3LY0vXYwnVuz4afMWxGHg03qcIe5QyVd85qkdCUxJckLk9tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747139164; c=relaxed/simple;
	bh=tW480eH49xcBfzCNo26Sq6iZqDQU86rDdnAkFHAXhKQ=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=Jc+v56bqWYGEhmyE+t/8twS7OKLKwfqCLXynKieTztUpjw2E5UDC03UhkyPoM7WFxTn3QKbU2LSP2c73iQ4S2RMFZGtPWPzGK/Q8M94CEMb3DBmM6aHA2GCPHt6SfYpmiz2nO5D6dcpUv0CBlTEArKGlS3htECWksPTmBCdRRVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mp3Yx//u; arc=none smtp.client-ip=209.85.219.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mp3Yx//u"
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-e78e3200bb2so5147305276.3;
        Tue, 13 May 2025 05:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747139162; x=1747743962; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Y/nxMbje4NAmV1+2vn75NwptcTJZZoHKa3/FOzJ2AC8=;
        b=mp3Yx//uDERUyNGy+/sxndJJEmwzwebI+0PZqOXuQaATPDYGkc03u0472eEvy7nGpg
         oQXWG4mWSSkkGCmU4X6szxyN8XOq7w+ib9Infnzs5zDqKwRWay44P89K13wQR6rdF2HR
         Otf2+W1Lht+zc9jd2+ZcabrBchsEM1FtHTG7ywcmCm7WIRNthVQRc6j7JEfHMIzuKaxL
         zkRa3fC3KZRTpLMY1YuF6LJQ5J9jD7l01qx4ezp6Y+NSlqOjyfd+iDq1D/I1OX86JJIb
         kwiHX8rVD5872acW5zMHtawR3nyph3RECn8vE9/pMuMT8N+PwSLilisLBAQn7n5qz8dm
         Qotg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747139162; x=1747743962;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y/nxMbje4NAmV1+2vn75NwptcTJZZoHKa3/FOzJ2AC8=;
        b=T+iVG08bmg41ewhok79THjkXpFtGuoMeNfGoUrUZIz2En49obN5KzJ5y8dc8+HV0zJ
         HvDUBmv0iWzmaxNhDU7UvdqjncHFMjI3cCyvOMYE43ql9D/phYHOC32dD1viIsLOSY62
         Ao+f6ZxXtWz4nPPVdtY4qt1hZenXjqPkZKBLjbmKroknLRwH8HfUB0LbIZoRYVEc3YRb
         kCg8Of6uw1d0ig56aw6FDjiqOb7R8mOOKKY97ee5LfoELnOL0F8dcg/pltgz9I/qXovS
         fQq6Q3V+yVuK9laKyZQafVJQboOAP2Cq49LeAWa1P9l/Ufxklrrn0j9topxk3lKc3/aM
         ogyA==
X-Forwarded-Encrypted: i=1; AJvYcCWfQ6u4ZAPcDzC6kIEdyf/9OnGnDl8a87+ZH8mKfuDAE1NTvcqFxEhuAFiW39p0VBM1Iiny67v/SzHj2CU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZ8BGHTWiriEtqr4z5IYmQ+lPy2pEhGbzzUDYZR5OJei2kQAJS
	uQsS7mswMK+u01kxTqsFRRZjHdKRSVObgWU/pbpcQyxjbeb/LOOt8zHiIoi9+9YwNa0E8o77RfY
	xqAz2+yYc2DtNKz9NBZgUqigs1RE=
X-Gm-Gg: ASbGncuoP23re2/TGE+w9ZyZCGbRw6hdUlWRP0Oam9m4Xh+rTy2k8QQInxH7xBxMDlu
	qN+HCJLkbbhxQDJ4MrEOZJ7VN9YviWvmh3SJo8VHTFEAqdboutCR2areRU39fC2rWgf768NDzOC
	tA+uATaW9WJr/+EazprzERy/XY0/lQGUUjZGoClk3cQA==
X-Google-Smtp-Source: AGHT+IHb8AHRQyh8S0p+x17GYcEkXuAVdrjcYofLjZw0v85+sDroOK5vgZPqITYwzFq3mkrAdI4sboxWWavDl5rA1Ak=
X-Received: by 2002:a05:6902:114a:b0:e78:f1e2:8f3f with SMTP id
 3f1490d57ef6-e78fdb890c8mr22062302276.3.1747139161628; Tue, 13 May 2025
 05:26:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: cen zhang <zzzccc427@gmail.com>
Date: Tue, 13 May 2025 20:25:49 +0800
X-Gm-Features: AX0GCFsMBJ0wf2Vr9JB5mM0DO2Nsfy-vjkYJ9E521TGotvBluJ_P9yttMB7KxgQ
Message-ID: <CAFRLqsVtQ0CY-6gGCafMBJ1ORyrZtRiPUzsfwA2uNjOdfLHPLw@mail.gmail.com>
Subject: Subject: [BUG] Five data races in in XFS Filesystem,one potentially harmful
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	baijiaju1990@gmail.com, zhenghaoran154@gmail.com
Content-Type: text/plain; charset="UTF-8"

Hello maintainers,

I would like to report five data race bugs we discovered in the XFS
filesystem on Linux kernel v6.14-rc4. These issues were identified
using our in-kernel data race detector.

Among the five races, we believe that four may be benign and could be
annotated using `data_race()` to suppress false positives from
analysis tools. However, one races involve shared global state or
critical memory, and their effects are unclear.
We would appreciate your evaluation on whether those should be fixed
or annotated.

Below is a summary of the findings:

---

Benign Races
============

1. Race in `xfs_bmapi_reserve_delalloc()` and  `xfs_vn_getattr()`
----------------------------------------------------------------

A data race on `ip->i_delayed_blks`.

============ DATARACE ============
Function: xfs_bmapi_reserve_delalloc+0x292c/0x2fd0 fs/xfs/xfs_bmap.c:4138
Function: xfs_buffered_write_iomap_begin+0x27bb/0x3bc0 fs/xfs/xfs_iomap.c:1197
Function: iomap_iter+0x572/0xad0
Function: iomap_file_buffered_write+0x23a/0xd10
Function: xfs_file_buffered_write+0x66b/0x2000 fs/xfs/xfs_file.c:792
Function: xfs_file_write_iter+0x129e/0x19f0 fs/xfs/xfs_file.c:881
Function: do_iter_readv_writev+0x4d6/0x720
Function: vfs_writev+0x348/0xc20
Function: do_writev+0x129/0x280
Function: do_syscall_64+0xc9/0x1a0
Function: entry_SYSCALL_64_after_hwframe+0x77/0x7f
Function: 0x0
========================
Function: xfs_vn_getattr+0x13c4/0x4c40 fs/xfs/xfs_iops.c:645
Function: vfs_fstat+0x239/0x2d0
Function: __se_sys_newfstat+0x47/0x6b0
Function: do_syscall_64+0xc9/0x1a0
Function: entry_SYSCALL_64_after_hwframe+0x77/0x7f
=================END==============

2. Race on `xfs_trans_ail_update_bulk` in `xfs_inode_item_format`
-------------------------------------.

We observed unsynchronized access to `lip->li_lsn`, which may exhibit
store/load tearing. However, we did not observe any symptoms
indicating harmful behavior.

Kernel panic: ============ DATARACE ============
Function: xfs_trans_ail_update_bulk+0xac0/0x25d0 fs/xfs/xfs_trans_ail.c:832
Function: xlog_cil_ail_insert_batch fs/xfs/xfs_log_cil.c:703 [inline]
Function: xlog_cil_ail_insert fs/xfs/xfs_log_cil.c:857 [inline]
Function: xlog_cil_committed+0x1e23/0x3220 fs/xfs/xfs_log_cil.c:904
Function: xlog_cil_process_committed+0x4d8/0x6a0 fs/xfs/xfs_log_cil.c:934
Function: xlog_state_do_callback+0xe52/0x1d70 fs/xfs/xfs_log.c:2525
Function: xlog_state_done_syncing+0x264/0x540 fs/xfs/xfs_log.c:2603
Function: xlog_ioend_work+0x24e/0x320 fs/xfs/xfs_log.c:1247
Function: process_scheduled_works+0x6c7/0xea0
Function: worker_thread+0xaac/0x1010
Function: kthread+0x341/0x760
Function: ret_from_fork+0x4d/0x80
Function: ret_from_fork_asm+0x1a/0x30
============OTHER_INFO============
Function: xfs_inode_item_format+0xe6e/0x6c00 fs/xfs/xfs_inode_item.c:637
Function: xlog_cil_commit+0x39ce/0xa1e0 fs/xfs/xfs_log_cil.c:513
Function: __xfs_trans_commit+0xa3b/0x23f0 fs/xfs/xfs_trans.c:896
Function: xfs_trans_commit+0x494/0x690 fs/xfs/xfs_trans.c:954
Function: xfs_setattr_nonsize+0x1c24/0x2e60 fs/xfs/xfs_iops.c:802
Function: xfs_setattr_size+0x628/0x2610 fs/xfs/xfs_iops.c:877
Function: xfs_vn_setattr_size+0x3ac/0x6a0 fs/xfs/xfs_iops.c:1054
Function: xfs_vn_setattr+0x43b/0xaf0 fs/xfs/xfs_iops.c:1079
Function: notify_change+0x9f9/0xca0
Function: do_truncate+0x18d/0x220
Function: path_openat+0x2741/0x2db0
Function: do_filp_open+0x230/0x440
Function: do_sys_openat2+0xab/0x110
Function: __x64_sys_creat+0xd7/0x100
Function: do_syscall_64+0xc9/0x1a0
Function: entry_SYSCALL_64_after_hwframe+0x77/0x7f
=================END==============

3. Race on `pag->pagf_freeblks`
-------------------------------

Although concurrent, this race is unlikely to affect correctness.

Kernel panic: ============ DATARACE ============
Function: xfs_alloc_longest_free_extent+0x164/0x580
fs/xfs/libxfs/xfs_alloc.c:2427
Function: xfs_bmapi_allocate+0x4349/0xb410 fs/xfs/libxfs/xfs_bmap.c:3314
Function: xfs_bmapi_write+0x2594/0x54b0 fs/xfs/libxfs/xfs_bmap.c:4551
Function: xfs_attr_rmtval_set_blk+0x496/0x9c0
fs/xfs/libxfs/xfs_attr_remote.c:633
Function: xfs_attr_set_iter+0x60e/0xf730 fs/xfs/libxfs/xfs_attr.c:637
Function: xfs_attr_finish_item+0x329/0xa00 fs/xfs/xfs_attr_item.c:505
Function: xfs_defer_finish_one+0x109d/0x28b0 fs/xfs/libxfs/xfs_defer.c:595
Function: xfs_defer_finish_noroll+0x1d91/0x4130 fs/xfs/libxfs/xfs_defer.c:707
Function: xfs_trans_commit+0x392/0x690 fs/xfs/xfs_trans.c:947
Function: xfs_attr_set+0x2a70/0x3e80 fs/xfs/libxfs/xfs_attr.c:1150
Function: xfs_attr_change+0xc03/0x10a0 fs/xfs/xfs_xattr.c:128
Function: xfs_xattr_set+0x535/0x870 fs/xfs/xfs_xattr.c:186
Function: __vfs_setxattr+0x3b6/0x3f0
Function: __vfs_setxattr_noperm+0x115/0x5c0
Function: vfs_setxattr+0x165/0x300
Function: file_setxattr+0x1a9/0x280
Function: path_setxattrat+0x2f4/0x370
Function: __x64_sys_fsetxattr+0xbc/0xe0
Function: do_syscall_64+0xc9/0x1a0
Function: entry_SYSCALL_64_after_hwframe+0x77/0x7f
Function: 0x0
============OTHER_INFO============
Function: xfs_alloc_update_counters+0x238/0x720 fs/xfs/libxfs/xfs_alloc.c:908
Function: xfs_free_ag_extent+0x22e7/0x4f10 fs/xfs/libxfs/xfs_alloc.c:2363
Function: __xfs_free_extent+0x747/0xba0 fs/xfs/libxfs/xfs_alloc.c:4025
Function: xfs_extent_free_finish_item+0x8be/0x18f0 fs/xfs/xfs_extfree_item.c:541
Function: xfs_defer_finish_one+0x109d/0x28b0 fs/xfs/libxfs/xfs_defer.c:595
Function: xfs_defer_finish_noroll+0x1d91/0x4130 fs/xfs/libxfs/xfs_defer.c:707
Function: xfs_defer_finish+0x3e/0x590 fs/xfs/libxfs/xfs_defer.c:741
Function: xfs_bunmapi_range+0x1fe/0x380 fs/xfs/libxfs/xfs_bmap.c:6443
Function: xfs_itruncate_extents_flags+0x660/0x1420 fs/xfs/xfs_inode.c:1066
Function: xfs_itruncate_extents fs/xfs/xfs_inode.h:603 [inline]
Function: xfs_setattr_size+0x12f1/0x2610 fs/xfs/xfs_iops.c:1003
Function: xfs_vn_setattr_size+0x3ac/0x6a0 fs/xfs/xfs_iops.c:1054
Function: xfs_vn_setattr+0x43b/0xaf0 fs/xfs/xfs_iops.c:1079
Function: notify_change+0x9f9/0xca0
Function: do_truncate+0x18d/0x220
Function: path_openat+0x2741/0x2db0
Function: do_filp_open+0x230/0x440
Function: do_sys_openat2+0xab/0x110
Function: __x64_sys_open+0x18d/0x1c0
Function: do_syscall_64+0xc9/0x1a0
Function: entry_SYSCALL_64_after_hwframe+0x77/0x7f
=================END==============

4. Race on `pag->pagf_longest`
------------------------------

Similar to the previous race, this field appears to be safely used
under current access patterns.

Kernel panic: ============ DATARACE ============
Function: xfs_alloc_fixup_longest+0x3d0/0x760 fs/xfs/libxfs/xfs_alloc.c:555
Function: xfs_alloc_fixup_trees+0x1331/0x2190 fs/xfs/libxfs/xfs_alloc.c:757
Function: xfs_alloc_cur_finish+0x3d1/0xd40 fs/xfs/libxfs/xfs_alloc.c:1119
Function: xfs_alloc_ag_vextent_near+0x38b2/0x46a0 fs/xfs/libxfs/xfs_alloc.c:1778
Function: xfs_alloc_vextent_iterate_ags+0xcef/0x1400
fs/xfs/libxfs/xfs_alloc.c:3741
Function: xfs_alloc_vextent_start_ag+0x830/0x14d0 fs/xfs/libxfs/xfs_alloc.c:3816
Function: xfs_bmapi_allocate+0x5016/0xb410 fs/xfs/libxfs/xfs_bmap.c:3764
Function: xfs_bmapi_write+0x2594/0x54b0 fs/xfs/libxfs/xfs_bmap.c:4551
Function: xfs_iomap_write_direct+0x7fc/0x1310 fs/xfs/xfs_iomap.c:322
Function: xfs_direct_write_iomap_begin+0x3278/0x42a0 fs/xfs/xfs_iomap.c:933
Function: iomap_iter+0x572/0xad0
Function: __iomap_dio_rw+0xbc1/0x1e50
Function: iomap_dio_rw+0x46/0xa0
Function: xfs_file_dio_write_unaligned+0x6cc/0x1030 fs/xfs/xfs_file.c:692
Function: xfs_file_write_iter+0x1403/0x19f0 fs/xfs/xfs_file.c:725
Function: do_iter_readv_writev+0x4d6/0x720
Function: vfs_writev+0x348/0xc20
Function: do_writev+0x129/0x280
Function: do_syscall_64+0xc9/0x1a0
Function: entry_SYSCALL_64_after_hwframe+0x77/0x7f
Function: 0x0
============OTHER_INFO============
Function: xfs_alloc_longest_free_extent+0x1f9/0x580
fs/xfs/libxfs/xfs_alloc.c:2427
Function: xfs_bmapi_allocate+0x4349/0xb410 fs/xfs/libxfs/xfs_bmap.c:3314
Function: xfs_bmapi_write+0x2594/0x54b0 fs/xfs/libxfs/xfs_bmap.c:4551
Function: xfs_attr_rmtval_set_blk+0x496/0x9c0
fs/xfs/libxfs/xfs_attr_remote.c:633
Function: xfs_attr_set_iter+0x60e/0xf730 fs/xfs/libxfs/xfs_attr.c:637
Function: xfs_attr_finish_item+0x329/0xa00 fs/xfs/xfs_attr_item.c:505
Function: xfs_defer_finish_one+0x109d/0x28b0 fs/xfs/libxfs/xfs_defer.c:595
Function: xfs_defer_finish_noroll+0x1d91/0x4130 fs/xfs/libxfs/xfs_defer.c:707
Function: xfs_trans_commit+0x392/0x690 fs/xfs/xfs_trans.c:947
Function: xfs_attr_set+0x2a70/0x3e80 fs/xfs/libxfs/xfs_attr.c:1150
Function: xfs_attr_change+0xc03/0x10a0 fs/xfs/xfs_xattr.c:128
Function: xfs_xattr_set+0x535/0x870 fs/xfs/xfs_xattr.c:186
Function: __vfs_setxattr+0x3b6/0x3f0
Function: __vfs_setxattr_noperm+0x115/0x5c0
Function: vfs_setxattr+0x165/0x300
Function: file_setxattr+0x1a9/0x280
Function: path_setxattrat+0x2f4/0x370
Function: __x64_sys_fsetxattr+0xbc/0xe0
Function: do_syscall_64+0xc9/0x1a0
Function: entry_SYSCALL_64_after_hwframe+0x77/0x7f
=================END==============
---

Possibly Harmful Race
======================

1. Race on `bp->b_addr` between `xfs_buf_map_pages()` and `xfs_buf_offset()`
----------------------------------------------------------------------------

Concurrent access to bp->b_addr happens during buffer preparation and
usage. Since this is pointer manipulation of page mappings, store/load
tearing or unexpected reuse might lead to memory corruption or invalid
log item formats. We are not confident in classifying this race as
benign or harmful and would appreciate your guidance on whether it
should be fixed or annotated.

Kernel panic: ============ DATARACE ============
Function: _xfs_buf_map_pages+0x881/0xd20 fs/xfs/xfs_buf.c:450
Function: xfs_buf_get_map+0x1cf3/0x38d0 fs/xfs/xfs_buf.c:767
Function: xfs_buf_read_map+0x1f2/0x1d80 fs/xfs/xfs_buf.c:863
Function: xfs_trans_read_buf_map+0x3c4/0x1dd0 fs/xfs/xfs_trans_buf.c:304
Function: xfs_imap_to_bp+0x415/0x8c0 fs/xfs/xfs_trans.h:212
Function: xfs_inode_item_precommit+0x1555/0x2780 fs/xfs/xfs_inode_item.c:188
Function: __xfs_trans_commit+0x7d7/0x23f0 fs/xfs/xfs_trans.c:826
Function: xfs_trans_commit+0x494/0x690 fs/xfs/xfs_trans.c:954
Function: xfs_create+0x21d8/0x2fe0 fs/xfs/xfs_inode.c:753
Function: xfs_generic_create+0x188b/0x2d90 fs/xfs/xfs_iops.c:215
Function: xfs_vn_create+0x50/0x70 fs/xfs/xfs_iops.c:298
Function: path_openat+0x1190/0x2db0
Function: do_filp_open+0x230/0x440
Function: do_sys_openat2+0xab/0x110
Function: __x64_sys_open+0x18d/0x1c0
Function: do_syscall_64+0xc9/0x1a0
Function: entry_SYSCALL_64_after_hwframe+0x77/0x7f
Function: 0x0
============OTHER_INFO============
Function: xfs_buf_offset+0xbd/0x450 fs/xfs/xfs_buf.c:1676
Function: xfs_inode_item_format+0x2854/0x6c00 fs/xfs/xfs_inode_item.c:533
Function: xlog_cil_commit+0x39ce/0xa1e0 fs/xfs/xfs_log_cil.c:513
Function: __xfs_trans_commit+0xa3b/0x23f0 fs/xfs/xfs_trans.c:896
Function: xfs_trans_commit+0x494/0x690 fs/xfs/xfs_trans.c:954
Function: xfs_setattr_nonsize+0x1c24/0x2e60 fs/xfs/xfs_iops.c:802
Function: xfs_vn_setattr+0x678/0xaf0 fs/xfs/xfs_iops.c:1086
Function: notify_change+0x9f9/0xca0
Function: chmod_common+0x1fe/0x410
Function: __x64_sys_fchmod+0xd4/0x130
Function: do_syscall_64+0xc9/0x1a0
Function: entry_SYSCALL_64_after_hwframe+0x77/0x7f
=================END==============

---

Thank you for your attention to these matters.

Best regards,
Cen Zhang
