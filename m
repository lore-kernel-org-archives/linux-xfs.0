Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com [209.85.219.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B47F33F7;
	Mon, 12 May 2025 04:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747022529; cv=none; b=NQ9KiRedZVKBeGs8WbRbV3ofzqj7seqZOs2vz6T3UinCYT2PuT0OhYh0p/DtdusvXDjtnEQyhc9xQHctfF/7qTJLK85xxfbBdfjB9Q+QmQVkrxPQbQdJf1mp3cNDLo9mQuY534/JfBoi6L4S5/K9AuVtWXsPDbwyJHDGNXpczII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747022529; c=relaxed/simple;
	bh=exhwgALZtxyM8QIAfIGW2vu3ugfB8bk7RRdyn7oCExU=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=mJrrJUvKakbkp7qhtbipPDe2JTVJEFotma3dJbheOhmxryoF9daVR1kVTeEmB/F7AsaJf5TwXwW7crv2kcTexCYr0gCtj8NJ+LQ4uM9R3YB616E0icQzDpSN54qGTZiUn2WxS7EAD7rHAUUKtbkb9E8nAvuMepONJv9pS0NLNyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dfTQktpY; arc=none smtp.client-ip=209.85.219.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dfTQktpY"
Received: by mail-yb1-f174.google.com with SMTP id 3f1490d57ef6-e755cd8c333so3605952276.0;
        Sun, 11 May 2025 21:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747022526; x=1747627326; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IWMrZXfSdn2uBeEyMoDPcPf0v6LFe6cmBWApre0pkN8=;
        b=dfTQktpY/1NeI/wDzDgpZuj3AtEARzMGsUOe7FpMRybD+SKHXKbBL+gdK4Jzql0nVj
         0RDUJQ0cUfgQOELuYm7KPZ969Is8NTorfMOpwkE2kKs7Gm/5YWcHl1ZQDUpEXjMlHuXV
         X6DIQFPK0EHBnTvyPpEdoODBXrxUZi1DlVceTYYndItg/M85dBUmzIqA5VA6xH3jopDK
         bYk9Ar5gSCRYOtXu1p8WeTi1SsII0Z0Y+A0dyeKmMC7cCzxYIa3C5fX1BeKo/QSPsKIU
         fhfMwbMRr+G1st0Jxk/sPWILwsuc5AmBUAwKNY0+S0F0f3tj4W+GJafl/h3WmygHiCJ2
         Bjkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747022526; x=1747627326;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IWMrZXfSdn2uBeEyMoDPcPf0v6LFe6cmBWApre0pkN8=;
        b=U9p0vPp4ZXE5PU4a6tW7FB4FoNxqPZEROX4qK8eg8JDqT3eKrs52kWN0Qxfs4NahEh
         6Fy5QeTA0/RQXSGxjhEvCXpTZ1oqAAh+LIiuEP/rzbWpqMrlPDUBPUKCxQcqYKf1ByzY
         ARIsj1C8TYDX3UtY8/HgR6PRvjOpzBACT72TXFjTwnUUcO1h+IF3kO3YOB+7pRMK31EH
         8iqO3f5oOA7rKZLrfopvbx4wvFsSsYO8xgfVpBp9k0THXmdH9fO5yzHmf2LddwZU1mHm
         /20PFWb1VpvvUZEFHMHnKZK6LAK0dwu+Bs2Ewi7kiD9dNW75OOyW1YaHHjJ/PJEDdBCF
         b9XQ==
X-Forwarded-Encrypted: i=1; AJvYcCV4Cb2BfqWGqjS7RmmEqXkYuZzLap+zq2z4pGoMrhm+OQRfRYaz96QJFMcCZWRtcraNt4+Z++EmHjQy2Nw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyTaFLrukcdoMYjCi7F136BLYjyZZ70EKQ12H3+/cHeEFmc7pAS
	fyJQlcXHVnP5sJDCEIvueLa0ZwpzNgYlwqIC+dqMXE+Rne3xDZwiTf4XhjVzQW4uZUmY3F3WKgA
	Ki0KuwyqWjqJlXEtRu/hsHkshJD8=
X-Gm-Gg: ASbGncuj9ApX6ef74SXc0lnhbvQITmQa3zP+5bXOOBmEz/axVijbkGgEByQuYwT5+wM
	GG9SeJzOvbTUQNJDNgZstJbV79YCcx4EOh2WQqUp6wa7yOQcLsfbrweKVVPS0dLrATTJ4LKNMmh
	fiDOU6j2DQmQwBRwkKuzJ5TqvQLG8D6g==
X-Google-Smtp-Source: AGHT+IEx6eZMsfd7agP12p1naORA8r/QacvbgUsoZx1ZTVz2eppHlVNzgrIetKQa2be6eLk70TVjk2QNkDo6pNalQx0=
X-Received: by 2002:a05:6902:2846:b0:e72:f374:49b0 with SMTP id
 3f1490d57ef6-e78fdd4561emr13262362276.42.1747022526416; Sun, 11 May 2025
 21:02:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: cen zhang <zzzccc427@gmail.com>
Date: Mon, 12 May 2025 12:01:54 +0800
X-Gm-Features: AX0GCFu19OOe3fMpa44v2yI4Q5vMgB10vbQkkL0POYpY28RLJXMip0MDthIQamc
Message-ID: <CAFRLqsWw_6XYE5K+31UBV+DOUht1MG+6v=P587DP-Su3z8t3Rg@mail.gmail.com>
Subject: [BUG] Data race between xfs_file_release and xfs_bmap_del_extent_delay
 about i_delayed_blks
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	baijiaju1990@gmail.com, zhenghaoran154@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello maintainers,

I would like to report a data race bug detected in
the Btrfs filesystem on Linux kernel 6.14-rc4.
The issue was discovered by our tools,
which identified unsynchronized concurrent accesses to
`ip->i_delayed_blks`.

Kernel panic: =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D DATARACE =3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
VarName 17363501701721901078, BlockLineNumber 20, IrLineNumber 2, is write =
0
Function: watchpoints_monitor+0x1340/0x17c0 kernel/kccwf/wp_checker.c:73
Function: kccwf_rec_mem_access+0x7ec/0xab0 kernel/kccwf/core.c:359
Function: xfs_file_release+0x39e/0x910 fs/xfs/xfs_file.c:1325
Function: __fput+0x40b/0x970
Function: task_work_run+0x1ce/0x260
Function: do_exit+0x88c/0x2520
Function: do_group_exit+0x1d4/0x290
Function: get_signal+0xf7e/0x1060
Function: arch_do_signal_or_restart+0x44/0x600
Function: syscall_exit_to_user_mode+0x62/0x110
Function: do_syscall_64+0xd6/0x1a0
Function: entry_SYSCALL_64_after_hwframe+0x77/0x7f
Function: 0x0
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3DOTHER_INFO=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
VarName 16100634012471765034, BlockLineNumber 44, IrLineNumber 6,
watchpoint index 22144
Function: set_report_info+0xa6/0x1f0 kernel/kccwf/report.c:49
Function: watchpoints_monitor+0x7e8/0x17c0 kernel/kccwf/wp_checker.c:100
Function: kccwf_rec_mem_access+0x7ec/0xab0 kernel/kccwf/core.c:359
Function: xfs_bmap_del_extent_delay+0x91a/0x1cf0 fs/xfs/libxfs/xfs_bmap.c:4=
981
Function: __xfs_bunmapi+0x2c50/0x54f0 fs/xfs/libxfs/xfs_bmap.c:5673
Function: xfs_bunmapi_range+0x170/0x2c0 fs/xfs/libxfs/xfs_bmap.c:6437
Function: xfs_itruncate_extents_flags+0x50a/0x1070 fs/xfs/xfs_inode.c:1066
Function: xfs_itruncate_extents fs/xfs/xfs_inode.h:603 [inline]
Function: xfs_setattr_size+0xd78/0x1c80 fs/xfs/xfs_iops.c:1003
Function: xfs_vn_setattr_size+0x321/0x590 fs/xfs/xfs_iops.c:1054
Function: xfs_vn_setattr+0x2f4/0x910 fs/xfs/xfs_iops.c:1079
Function: notify_change+0x9f9/0xca0
Function: do_truncate+0x18d/0x220
Function: path_openat+0x2741/0x2db0
Function: do_filp_open+0x230/0x440
Function: do_sys_openat2+0xab/0x110
Function: __x64_sys_creat+0xd7/0x100
Function: do_syscall_64+0xc9/0x1a0
Function: entry_SYSCALL_64_after_hwframe+0x77/0x7f
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3DEND=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D

The code locations involved in the data race are:

Write (fs/xfs/xfs_bmap.c):
xfs_bmap_del_extent_delay  {
=E2=80=A6=E2=80=A6
    xfs_quota_unreserve_blkres(ip, del->br_blockcount);
    ip->i_delayed_blks -=3D del->br_blockcount;
=E2=80=A6=E2=80=A6
}

Reader (fs/xfs/xfs_file.c):
xfs_file_release  {
=E2=80=A6=E2=80=A6
        xfs_iflags_clear(ip, XFS_EOFBLOCKS_RELEASED);
        if (ip->i_delayed_blks > 0)
            filemap_flush(inode->i_mapping);
=E2=80=A6=E2=80=A6
}

I=E2=80=99ve verified that this issue still exists in the latest source tre=
e
in xfs_file.c:1552 and xfs_bmap.c:4702
