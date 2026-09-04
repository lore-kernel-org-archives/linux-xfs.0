Received: from mail-oa2-f1.google.com (mail-oa2-f1.google.com [74.125.231.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C103DA5B4
	for <linux-xfs@vger.kernel.org>; Fri,  4 Sep 2026 14:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788530614; cv=none; b=GxxSMGpdo5DKwcTXNPErUHErL5F/X+vquv2ZEG9sWlUlTbxq4PQcH+vZLm9/kDNolfOu68yg5tBwJV4p7VtpTZ10L7Y8ExL6N5AMjtt5LNCVSr89OHpCJmcjul1ojfLJBLyG25/uguOW9tPPC+SGQgZ/omSIHz3l8pjEf6yjuDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788530614; c=relaxed/simple;
	bh=KLQpm+4rW18F/LCxmpfihOOpO3cvxVC+reaLNVdE6vo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=PIBBMMP11jGn6rugHJkL2725d1J72X90nRvmh8BHi4yxZwMF8tfYrykaoObj0S6RrTAZxXLf/qTZZ4lV23Rdp1PzQE6zmmLYnSjZH4o8hSZD0wJKSVHCt4zy3VxCPnoe4TSBVRaU3shufEhNiBdM+RP/nrLH8nGwRfGNN5ZWlz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa2-f1.google.com with SMTP id 586e51a60fabf-448a12ddfb4so345742fac.1
        for <linux-xfs@vger.kernel.org>; Fri, 04 Sep 2026 07:03:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788530611; x=1789135411;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cfQPBot0l1tu7zjFYCxi2tGovOJQZpN5cLMRUsOMHVY=;
        b=ro8kyydxdBPDido83N3ckja1yNGlw6Uwt15IJIQ/in5lPyL7yoPbFUNZWpU3+zY0Ya
         yjjg/c2zMoUunu08lB4rVdbHwAHLCd0HOVpJhzB8HFY2FKV8IEK194V4XIIe7ZaiEQ0b
         L0g3KN6xn3eUrYVqdjfu5OpINo/psuhW7w5zx39F+vna6HTFaHvmZwKkqsAFoS33JDdR
         oeJZYdevlpUNZ+pGX3SvShUKu4uvTu2pwQ731nPoC45CqeDD81qWAMDn/Rx6xb1Uf7Uc
         ICpJrbw1WeQ7J+nG4n5jlY//RKxtELDeSD/1MwDYz/GqjFNzl0G+m+t7Q+bNqgR6Fo/J
         VM+w==
X-Forwarded-Encrypted: i=1; AKwUvBzuXMGX25C84PSXf1SICvPo/QSOh5BAhf5pKg9ZLgWU6jhOWUPbNsWQfjdOV/hAjScK3EF7iL54VyQ=@vger.kernel.org
X-Gm-Message-State: AFuF++lXOX8/d5PdBHEYYUZVXCBKEWhaTsMxDGi4qIvr5iLQjqXn3eSG
	1jzSEjY/16RUpgKh7XA/CC2ySmQn4p7BnWBWfoIMk4oMSI1F/zYMv+37naWpIQIKeCQ8JfpUSBG
	sLIcceFF8+YBjjv3CG/l7EVRoeWxbOUpjtS4phEcQjiv1tKodJ0SlJrEbWrA=
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1623:b0:6ae:8a52:ffa9 with SMTP id
 006d021491bc7-6b6fbdc5bdcmr4671256eaf.3.1788530611282; Fri, 04 Sep 2026
 07:03:31 -0700 (PDT)
Date: Fri, 04 Sep 2026 07:03:31 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a9acfb3.d07ac993.c20e9.0000.GAE@google.com>
Subject: [syzbot] [xfs?] WARNING in __xfs_healthmon_insert
From: syzbot <syzbot+ccdf3469f5f653bff7ac@syzkaller.appspotmail.com>
To: cem@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    9d80aa4617b3 Add linux-next specific files for 20260903
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=134908f9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bb4a32c282cc2ec7
dashboard link: https://syzkaller.appspot.com/bug?extid=ccdf3469f5f653bff7ac
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17422b49580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=174908f9580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/417a63e8ac61/disk-9d80aa46.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a1d004c189c1/vmlinux-9d80aa46.xz
kernel image: https://storage.googleapis.com/syzbot-assets/97413e5bd243/bzImage-9d80aa46.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/39404573136a/mount_0.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=113e0215580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ccdf3469f5f653bff7ac@syzkaller.appspotmail.com

XFS (loop0): Quotacheck needed: Please wait.
XFS (loop0): Quotacheck: 
XFS (loop0): Quotacheck: Done.
------------[ cut here ]------------
debug_locks && !(lock_is_held(&(&hm->lock)->dep_map) != 0)
WARNING: fs/xfs/xfs_healthmon.c:275 at __xfs_healthmon_insert+0x32b/0x4e0 fs/xfs/xfs_healthmon.c:275, CPU#0: syz-executor227/5634
Modules linked in:
CPU: 0 UID: 0 PID: 5634 Comm: syz-executor227 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
RIP: 0010:__xfs_healthmon_insert+0x32b/0x4e0 fs/xfs/xfs_healthmon.c:275
Code: 00 00 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc e8 84 1f 29 fe 90 0f 0b 90 e9 51 ff ff ff e8 76 1f 29 fe 90 <0f> 0b 90 e9 a9 fd ff ff e8 68 1f 29 fe 48 8d 3d 41 df e3 0c 67 48
RSP: 0018:ffffc90003c0fbe0 EFLAGS: 00010293
RAX: ffffffff839eb57a RBX: dffffc0000000000 RCX: ffff88807f2c9f40
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90003c0fc90 R08: ffffffff907a6a7f R09: 1ffffffff20f4d4f
R10: dffffc0000000000 R11: fffffbfff20f4d50 R12: 0000000000000000
R13: 1ffff92000781f80 R14: ffff8880342dec00 R15: ffffc90003c0fc20
FS:  0000555577e8a400(0000) GS:ffff888124cc0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000006a9ee0 CR3: 0000000075370000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 xfs_ioc_health_monitor+0x4ac/0x760 fs/xfs/xfs_healthmon.c:1222
 xfs_file_ioctl+0x9fb/0xf40 fs/xfs/xfs_ioctl.c:1534
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa707f17349
Code: c0 79 93 eb d5 48 8d 7c 1d 00 eb 99 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 d8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc0c2721a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007ffc0c2722d8 RCX: 00007fa707f17349
RDX: 0000200000000080 RSI: 0000000040205844 RDI: 0000000000000004
RBP: 0000000000000001 R08: 0000000000000000 R09: 00007ffc0c2722d8
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffc0c2722c8
R13: 0000000000000002 R14: 00007fa707fa9c80 R15: 0000000000000002
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
