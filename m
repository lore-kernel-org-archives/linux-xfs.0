Received: from mail-oi1-f205.google.com (mail-oi1-f205.google.com [209.85.167.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F27D449985
	for <linux-xfs@vger.kernel.org>; Sun, 12 Jul 2026 19:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783882831; cv=none; b=m3Vh3SE82N7g6aRIQBwBX9hC0fbegtYUwYuXTexlSKlGOdtGYSUrgJzdPPI2+bH017fyr7a40OB8Uv5m1uwxlrUzAcK78psXLa+WUh04WfxDDPrZ/HmCtYbB4h2KdxZV+8bfsNuyw+UxZovrbOA1ZIeADbrRN9A/AK3maJIzkmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783882831; c=relaxed/simple;
	bh=BllOnMAYTBujHoNK2zJTD2rBGNqzSQ2aK4e9hVD1GPA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=qD3C2yIAnFN+R15qrXgNYnBW7Q8lVZx+bskQstEOTTxln2HsraZMIl1n2k/qpQsItU48sTcAGvgUJLVzJD+fQO74e9Y75ckK6J63hE6BevHbr1wh41leOXAgaofT+jsVSOf3KAXVIiAXysfc/vlkYHB8ICpuFZiH2omFTv47uLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f205.google.com with SMTP id 5614622812f47-4a36606e230so3657530b6e.2
        for <linux-xfs@vger.kernel.org>; Sun, 12 Jul 2026 12:00:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783882829; x=1784487629;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ghtKxJ3OaQI/PmJfXiDpHLhe8efrgfgSBHpJrRdJftU=;
        b=ltkvi26TjS51G8x6v5BfPzH9tOybawDz+5yin+kAk8KIdUUKQ1DNC4BmF8IINN5/ck
         AjyjR6JQ+2qAGR2lNOkT8wi01hr/K8PFDohmfDVW403kZYUwdMV+oJ/4SQxCQdDHuJfu
         V/l/6JhcwThXFoxg2IqWGgcJwGcH5DhmD2rD2kpYfrGzjdmyr/TJjPcOjPIn2Yq35m+t
         PAIJ8BPi4FmdgSoxJq3ROmFvK2mEnF7e7IwD7wHN9/HBzDKZhi1GskVdMDeO0XWvuZbr
         T0VjcuYyvIWsBehidLfy3pceEsqixx4JmwX7zoQs0Li4Cn6F9lLvmUfoVkexVeNVv/OR
         ashQ==
X-Forwarded-Encrypted: i=1; AFNElJ+u0wuX1n17LyI3JgQiepGkPMzxr6nhL7v19Jlekfy3sxLKQ1mtvT6gaUV6GDFHVnHPnXTeyv2A+nQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKgSSdmQperx+WmvPFs+Gg78HQkshPmNvB0iIdlGb13A3Se62i
	o/4sc28nHAn40tE8DRfYACLr2NVx1ttDbyR/6MXC8R6Z+B+BVERvgzWS/NThkns8ejfi177F6D+
	OoJkPRgyyUA4UA8RIj2CyAvbGXnw6Efw5tu698kZSLg5UnRQywX2Asn+GSaE=
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1916:b0:494:fa8b:d061 with SMTP id
 5614622812f47-4a42ae86b61mr4551576b6e.29.1783882829321; Sun, 12 Jul 2026
 12:00:29 -0700 (PDT)
Date: Sun, 12 Jul 2026 12:00:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a53e44d.574492cf.19a3b.0013.GAE@google.com>
Subject: [syzbot] [xfs?] kernel BUG in xrep_tempfile_rele
From: syzbot <syzbot+a7f8b4c78caca340c561@syzkaller.appspotmail.com>
To: cem@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    0e35b9b6ec0f Merge tag 'mm-hotfixes-stable-2026-07-06-17-4..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14e7f832580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=20c9876b0f77b546
dashboard link: https://syzkaller.appspot.com/bug?extid=a7f8b4c78caca340c561
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-0e35b9b6.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2a17ca6db8f5/vmlinux-0e35b9b6.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c885024dccba/bzImage-0e35b9b6.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a7f8b4c78caca340c561@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
=======================================================
WARNING: The mand mount option has been deprecated and
         and is ignored by this kernel. Remove the mand
         option from the mount to silence this warning.
=======================================================
XFS (loop0): Mounting V5 Filesystem bfdc47fc-10d8-4eed-a562-11a831b3f791
XFS (loop0): Ending clean mount
XFS (loop0): Quotacheck needed: Please wait.
XFS (loop0): Quotacheck: Done.
loop0: detected capacity change from 32768 to 32767
XFS (loop0): Metadata CRC error detected at xfs_dquot_buf_verify_crc+0x281/0x300 fs/xfs/libxfs/xfs_dquot_buf.c:180, xfs_dquot block 0x4920 xfs_dquot_buf_verify_crc
XFS (loop0): Unmount and run xfs_repair
XFS (loop0): First 128 bytes of corrupted metadata buffer:
00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000020: 00 00 00 00 00 00 08 00 00 00 00 00 00 00 09 00  ................
00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000060: 00 00 00 14 bb 9d fa 00 00 00 00 00 00 00 00 bf  ................
00000070: dc 47 fc 10 d8 4e ed a5 62 11 a8 31 b3 f7 91 44  .G...N..b..1...D
XFS (loop0): metadata I/O error in "xfs_dquot_attach_buf+0x20c/0x3d0" at daddr 0x4920 len 4 error 74
XFS (loop0): Metadata I/O Error (0x1) detected at xfs_trans_read_buf_map+0x47f/0x820 fs/xfs/xfs_trans_buf.c:280 (fs/xfs/xfs_trans_buf.c:280).  Shutting down filesystem.
XFS (loop0): Please unmount the filesystem and rectify the problem(s)
VFS_BUG_ON_INODE(inode_state_read_once(inode) & (I_FREEING | I_CLEAR)): inode:ffff888042718910 fs:xfs mode:120000 opflags:0x20 flags:0x1200 state:0x300 count:0
------------[ cut here ]------------
kernel BUG at fs/inode.c:2039!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5323 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:iput+0xecc/0xf00 fs/inode.c:2039
Code: fb 75 ff 48 89 df 48 c7 c6 a0 eb fe 8b e8 2c 29 00 00 90 0f 0b e8 d4 fb 75 ff 48 89 df 48 c7 c6 00 ee fe 8b e8 15 29 00 00 90 <0f> 0b e8 bd fb 75 ff 48 89 df 48 c7 c6 40 fd fe 8b e8 fe 28 00 00
RSP: 0018:ffffc9000e7e7560 EFLAGS: 00010246
RAX: c4ce6ffeb2b29e00 RBX: ffff888042718910 RCX: c4ce6ffeb2b29e00
RDX: ffffc9000eb19000 RSI: 0000000000008085 RDI: 0000000000008086
RBP: dffffc0000000000 R08: ffffc9000e7e7147 R09: 1ffff92001cfce28
R10: dffffc0000000000 R11: fffff52001cfce29 R12: 0000000000000300
R13: 1ffff110084e3161 R14: 0000000000000300 R15: 1ffffffff20af900
FS:  00007ffbf46256c0(0000) GS:ffff88808c54e000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fcaff4b1636 CR3: 0000000012d79000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 xrep_tempfile_rele+0xd5/0x140 fs/xfs/scrub/tempfile.c:403
 xchk_teardown+0x397/0x810 fs/xfs/scrub/scrub.c:270
 xfs_scrub_metadata+0x13b2/0x1910 fs/xfs/scrub/scrub.c:766
 xfs_ioc_scrubv_metadata+0x7ac/0xb70 fs/xfs/scrub/scrub.c:981
 xfs_file_ioctl+0x916/0x1590 fs/xfs/xfs_ioctl.c:1308
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7ffbf379de59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffbf4624fe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007ffbf3a25fa0 RCX: 00007ffbf379de59
RDX: 0000200000000000 RSI: 00000000c0285840 RDI: 0000000000000004
RBP: 00007ffbf3833e6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffbf3a26038 R14: 00007ffbf3a25fa0 R15: 00007ffce4f66e88
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:iput+0xecc/0xf00 fs/inode.c:2039
Code: fb 75 ff 48 89 df 48 c7 c6 a0 eb fe 8b e8 2c 29 00 00 90 0f 0b e8 d4 fb 75 ff 48 89 df 48 c7 c6 00 ee fe 8b e8 15 29 00 00 90 <0f> 0b e8 bd fb 75 ff 48 89 df 48 c7 c6 40 fd fe 8b e8 fe 28 00 00
RSP: 0018:ffffc9000e7e7560 EFLAGS: 00010246
RAX: c4ce6ffeb2b29e00 RBX: ffff888042718910 RCX: c4ce6ffeb2b29e00
RDX: ffffc9000eb19000 RSI: 0000000000008085 RDI: 0000000000008086
RBP: dffffc0000000000 R08: ffffc9000e7e7147 R09: 1ffff92001cfce28
R10: dffffc0000000000 R11: fffff52001cfce29 R12: 0000000000000300
R13: 1ffff110084e3161 R14: 0000000000000300 R15: 1ffffffff20af900
FS:  00007ffbf46256c0(0000) GS:ffff88808c54e000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000560754415168 CR3: 0000000012d79000 CR4: 0000000000352ef0


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
