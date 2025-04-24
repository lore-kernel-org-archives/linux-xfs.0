Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F6FC133
	for <linux-xfs@vger.kernel.org>; Thu, 24 Apr 2025 02:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745460150; cv=none; b=GpItkbzJZYAbidW0YWcQYaWq8ivqk48lW1dTZRQtTpHePQzgeK4gK3FzxgM4kW9ZaRMez6UpqWNcZ8fR2h5mUFilqLWQeX/KIAgLKtXzuDmxgxRJ6PUdZw6F8XJyuyj5x2ueyBxgzzXExYJ9XmE4eIgS7mRK6RfOm9s9YmMhYW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745460150; c=relaxed/simple;
	bh=Pv7OPVKtRbE+bbsu3UFh4FRokIglM5CMKW+YYq7hS5c=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=o4ycemgsai0vT1TruGiATSAQ4F3iRu07Bs7Vb8xYGuplwxaOoxU1Hx7D8YVgeI0gTIhUI3PUb40YrPrIfVnhxS3HFbnv9npqOrF7poaX1WPhBIDti9xfs0cNm9h1xd45UCEcwYZFF4HNhnhtaq+C3VobtRCfRkrJkYCJSB28BHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f78.google.com with SMTP id ca18e2360f4ac-85e318dc464so93935739f.1
        for <linux-xfs@vger.kernel.org>; Wed, 23 Apr 2025 19:02:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745460147; x=1746064947;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=flCF266RDJ50uYrZuYmER1ByNlJ8d8XpWuwoDVSeQb8=;
        b=usNpOXLpvDujhfRmMnkNGT2Mb8yb0/Hh2dUxQdYbrRAcOhPegFmbKhHktaK3VOTtw9
         jAxhAHPKbOsjRbo+RAINjPPx3A0w3L2lLf1HCi1yvAMiirZ3tp8GFKQOyXPhNUlXfqeM
         mSH4dCJYhndq+QfyE9nEh1k0tpqB+UdIB4lv1UIqvgPV8TS04dJBzseB2WOuyWcwiS5k
         WyAmne8yc8WLl55Y/jQGBnEbuzy1kgjIeRSEg48bE3zanaB4TbuGT1QtGIRABAvnzth8
         6ZRPJHcjmexPU3OpRgWfTuInDwod2q3MXfHPL/39SWVHKuvPdbaCq3kVojtThHlbfau4
         sUdA==
X-Forwarded-Encrypted: i=1; AJvYcCVh2cK5hToBy+30wRJFPPzCUdNDs180WCyKhQ+s0Tlxrio41K8pYtzv/SDCDNg99EUeGnk/jtHCSc0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzkRuaQ+Lgx+qQ3erN+1Qi0zSO8Po+pg3vo7T4WPKKz3cs0nlWM
	iVOvTHxB5cE1d6KlcRXHfI27dDhOgj16MmhEgDW1a5C4aDvs7rSECMWqE1aaqYmkAM82cQopdrF
	nHOmqs/rylB0GiHQbp/HdPtVALKUwzaTCHujdahWkVdIErIxAA6GUPZ4=
X-Google-Smtp-Source: AGHT+IEmuUMojlfHtPqnUcLFpQPaW42scl/IPXixvCJI0vAiAeHoRIeITY/anSfbffMbvUUsI0BovuOvhafvX08eQV1dnMkuRHal
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:19c5:b0:3d4:6e2f:b487 with SMTP id
 e9e14a558f8ab-3d93026df5fmr9248225ab.0.1745460146945; Wed, 23 Apr 2025
 19:02:26 -0700 (PDT)
Date: Wed, 23 Apr 2025 19:02:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68099bb2.050a0220.10d98e.0005.GAE@google.com>
Subject: [syzbot] [xfs?] KMSAN: uninit-value in xfs_dialloc_ag_inobt
From: syzbot <syzbot+b4a84825ea149bb99bfc@syzkaller.appspotmail.com>
To: cem@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    8560697b23dc Merge tag '6.15-rc2-smb3-client-fixes' of git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11d3dfe4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a27b81e0cf56c60b
dashboard link: https://syzkaller.appspot.com/bug?extid=b4a84825ea149bb99bfc
compiler:       Debian clang version 15.0.6, Debian LLD 15.0.6

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/03806cf4a3af/disk-8560697b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/6d86507d5b30/vmlinux-8560697b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/f5f2020007a8/bzImage-8560697b.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b4a84825ea149bb99bfc@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in xfs_dialloc_ag_inobt+0x99b/0x2550 fs/xfs/libxfs/xfs_ialloc.c:1173
 xfs_dialloc_ag_inobt+0x99b/0x2550 fs/xfs/libxfs/xfs_ialloc.c:1173
 xfs_dialloc_ag fs/xfs/libxfs/xfs_ialloc.c:1585 [inline]
 xfs_dialloc_try_ag fs/xfs/libxfs/xfs_ialloc.c:1835 [inline]
 xfs_dialloc+0x14c4/0x3470 fs/xfs/libxfs/xfs_ialloc.c:1945
 xfs_create_tmpfile+0x496/0x12c0 fs/xfs/xfs_inode.c:827
 xfs_generic_create+0x65c/0x1610 fs/xfs/xfs_iops.c:227
 xfs_vn_tmpfile+0x6b/0x140 fs/xfs/xfs_iops.c:1194
 vfs_tmpfile+0x5e4/0xe40 fs/namei.c:3896
 do_tmpfile+0x19d/0x460 fs/namei.c:3961
 path_openat+0x4837/0x6280 fs/namei.c:3995
 do_filp_open+0x26b/0x610 fs/namei.c:4031
 io_openat2+0x5d5/0xa50 io_uring/openclose.c:140
 io_openat+0x35/0x40 io_uring/openclose.c:177
 __io_issue_sqe io_uring/io_uring.c:1734 [inline]
 io_issue_sqe+0x394/0x1de0 io_uring/io_uring.c:1753
 io_wq_submit_work+0xaf8/0xde0 io_uring/io_uring.c:1868
 io_worker_handle_work+0xc4d/0x2090 io_uring/io-wq.c:615
 io_wq_worker+0x403/0x1470 io_uring/io-wq.c:669
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:153
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Uninit was stored to memory at:
 xfs_dialloc_ag_inobt+0x1cc1/0x2550 fs/xfs/libxfs/xfs_ialloc.c:1227
 xfs_dialloc_ag fs/xfs/libxfs/xfs_ialloc.c:1585 [inline]
 xfs_dialloc_try_ag fs/xfs/libxfs/xfs_ialloc.c:1835 [inline]
 xfs_dialloc+0x14c4/0x3470 fs/xfs/libxfs/xfs_ialloc.c:1945
 xfs_create_tmpfile+0x496/0x12c0 fs/xfs/xfs_inode.c:827
 xfs_generic_create+0x65c/0x1610 fs/xfs/xfs_iops.c:227
 xfs_vn_tmpfile+0x6b/0x140 fs/xfs/xfs_iops.c:1194
 vfs_tmpfile+0x5e4/0xe40 fs/namei.c:3896
 do_tmpfile+0x19d/0x460 fs/namei.c:3961
 path_openat+0x4837/0x6280 fs/namei.c:3995
 do_filp_open+0x26b/0x610 fs/namei.c:4031
 io_openat2+0x5d5/0xa50 io_uring/openclose.c:140
 io_openat+0x35/0x40 io_uring/openclose.c:177
 __io_issue_sqe io_uring/io_uring.c:1734 [inline]
 io_issue_sqe+0x394/0x1de0 io_uring/io_uring.c:1753
 io_wq_submit_work+0xaf8/0xde0 io_uring/io_uring.c:1868
 io_worker_handle_work+0xc4d/0x2090 io_uring/io-wq.c:615
 io_wq_worker+0x403/0x1470 io_uring/io-wq.c:669
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:153
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Local variable trec created at:
 xfs_dialloc_ag_inobt+0x139/0x2550 fs/xfs/libxfs/xfs_ialloc.c:1101
 xfs_dialloc_ag fs/xfs/libxfs/xfs_ialloc.c:1585 [inline]
 xfs_dialloc_try_ag fs/xfs/libxfs/xfs_ialloc.c:1835 [inline]
 xfs_dialloc+0x14c4/0x3470 fs/xfs/libxfs/xfs_ialloc.c:1945

CPU: 1 UID: 0 PID: 7854 Comm: iou-wrk-7829 Not tainted 6.15.0-rc2-syzkaller-00404-g8560697b23dc #0 PREEMPT(undef) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2025
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
