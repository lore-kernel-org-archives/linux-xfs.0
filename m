Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF2D139B;
	Mon, 21 Jul 2025 03:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753068591; cv=none; b=rpWzWqyB/tQbdQd6Iqz1U/Fv5tRAV7osm1Vk69EGNcpeFO/Av3nRscZUfVGdb/GkmIILcffdnhqCBJT2zhEky57qNZkraWoUEGvn/WwztMR5Y7oKaws40XKb7r6qM4VNF+Co7nHe/v7PSoTYrxPBh7qY08nvEYJWqO7pSwMu+fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753068591; c=relaxed/simple;
	bh=8rmXPgdXuISdsaKJUA6HComhHDhvI/AOgH+GvotnXPg=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=lU6FFTqlkGT0m0o5MrfOXgpy+pWMPf62RCMrZW4yLEu467HlOoijY1DaZcr/EdGEqLkLN9DS16YYrUefI9RHJU4k/BWulcHQsfAHo5SFFTfhAyMxy5yNb3ui+YfFImt/llnVNoes7UHZfeWaBjzhhOTk0RzaV/Ksb7nbkEOBbkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WcbRXoH1; arc=none smtp.client-ip=209.85.219.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WcbRXoH1"
Received: by mail-yb1-f169.google.com with SMTP id 3f1490d57ef6-e8da9b7386dso203032276.1;
        Sun, 20 Jul 2025 20:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753068588; x=1753673388; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Juerz8ZdRw7G+aiKRKUz1rPbWdjgiqsXStslfaaWcgk=;
        b=WcbRXoH1QubHBiRQXN8nB/t620U98h5jR3YTxMCiqaG+0XsujtoTOHAjqbXCNG8nKH
         /KDYLpuKuUayZ7mTube7vqf/teDLL8hEV0waUXT/fbp57sJrTr65gqn44BTO9ktQ43rX
         Kl/1UFizVEeT6ILmjEdBacakVOTi8tnFEcO5aymBUNkNtVwtUc+qpsRNsuL7Q7PIK/u5
         2SEN0TbcolyWqwXYVSFSfMkospOp9lh+UPsOLa0+zhsCuT8HISRMbhkjSh8FhXxKK2F7
         hJigwmZZ+MRLwlbk2qUjKNZKgzkwabpeZPwl0fRw7c8gyDR34Q7YWu0Ym/mIzkuCc8+E
         RI6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753068588; x=1753673388;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Juerz8ZdRw7G+aiKRKUz1rPbWdjgiqsXStslfaaWcgk=;
        b=uVlriMxBtF94Wex9M/1Z+5TiWql4ty5sxZCzwgoC4Czrlt3Ti6L48REYSgd4bxWefX
         jGH3UupF44I1l5SRAEeJ32GqzVbAw0UWrlr3xAz12jeC2cJMjrqYoii2L8KdTber1z8c
         Mk0MHx5/TBeefAAcoo88MldO5jdMmNEjNUKiQbODdAI2btGz/MSWWe343LZbFqcO6Ohi
         4tDraU6AxNI3TUgUb0efpcQAN4wqtHAW2eOze6cepMHGCkPSGyToEOBwTL7QIQd4y0T2
         rGJEdzTezz9GKyWS+gA3q3ESiBv9RZTMXwGSS/h63/hHEG6qzo7mcHQdG8cIeQF1z+5E
         4eOA==
X-Forwarded-Encrypted: i=1; AJvYcCXOMcqYBf4Yz9pp5fCAi8WxWmUl1ChQR37WSRZ/L5flRtAfH5k1FDdGhHBA9HCeDS200ZzzOjea3Nk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJBXLBcHMAejq8wXRevsCv51sxn+RrDWL0p+8jgam2WNwYOvg/
	1GSF2zNRJfos68GvYpyRGj7bTqyMSB2PO6eKze1MimjiyvxGLddxRJKYGLs/W8Om20r3eHRwsWM
	UbdiGttAVSep6YW1HfxsP33Kyv7yZgCo=
X-Gm-Gg: ASbGnctPmZqnRiIUZ5vloksKr2fj+irmkx1jMjS6OrqHtuSNyN7JujxoKMMB2QlJonV
	ptrX44ZzmqplP8FV0BngkMru67CzZCrR4W62Vm7h47jMel2qfXAvle/ixRp0gqhF6oUVHMvyw38
	pbusuG7KBROCcQOmunzTK3ZVNo+RelJhbjZxJbaqAJ7649VSWlf3uQa+8zsSwA8wVb0gsEUjn7v
	IZzjpIAHKZsj+Mb
X-Google-Smtp-Source: AGHT+IGCd/xK01geJBvM30A7t1xk1QfBKaXZxPhz2bAdJBIuWvUH8SxonQfe8d/0dkxmC7sNPk0BDmeBQKhZPGCcFaY=
X-Received: by 2002:a05:6902:6d01:b0:e8d:86eb:4a3b with SMTP id
 3f1490d57ef6-e8d86eb4fe5mr7067932276.16.1753068588510; Sun, 20 Jul 2025
 20:29:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: cen zhang <zzzccc427@gmail.com>
Date: Mon, 21 Jul 2025 11:29:36 +0800
X-Gm-Features: Ac12FXwOY79vW1kN_CryfktSa9PmOOJ51Oo9aJLYHTPjymrkoMCS_8tXmWQrfAE
Message-ID: <CAFRLqsU-k2GYx4D9HUmu+tSTvmMbY_ea9aYwE+2yvHwLP_+JDQ@mail.gmail.com>
Subject: [BUG] xfs: Assertion failed in xfs_iwalk_args triggered by XFS_IOC_INUMBERS
To: cem@kernel.org
Cc: linux-kernel@vger.kernel.org, baijiaju1990@gmail.com, 
	zhenghaoran154@gmail.com, r33s3n6@gmail.com, gality365@gmail.com, 
	linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello maintainers,

This is a bug report for a kernel BUG found by Syzkaller on the XFS filesys=
tem.

The crash occurs on kernel 6.16.0-rc6 at git commit 155a3c003e55. It
is an assertion failure in xfs_iwalk_args.constprop.0() located in
fs/xfs/xfs_iwalk.c:548.

The assertion that fails is !(flags & ~XFS_IWALK_FLAGS_ALL). This
seems to be triggered by an ioctl call with the command
XFS_IOC_INUMBERS (0x80405880), where the provided arguments contain
invalid flags.

Here is the full kernel oops log:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
kernel BUG at fs/xfs/xfs_message.c:102!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 3 UID: 0 PID: 281 Comm: syz-executor167 Not tainted
6.16.0-rc6-00002-g155a3c003e55 #8 PREEMPT(voluntary)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/=
2014
RIP: 0010:assfail+0x9d/0xa0 fs/xfs/xfs_message.c:102
Code: 75 22 e8 76 88 3a ff 90 0f 0b 90 5b 5d 41 5c 41 5d e9 87 2d 78
02 48 c7 c7 78 af c3 89 e8 eb 59 6f ff eb ca e8 54 88 3a ff 90 <0f> 0b
90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 66 0f 1f
RSP: 0018:ffff8881107877c0 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffffffff86122a6c
RDX: ffff8881114e9e80 RSI: 0000000000000000 RDI: 0000000000000001
RBP: 0000000000000000 R08: 0000000000000001 R09: ffffed10220f0e8d
R10: 0000000000000001 R11: 737341203a534658 R12: ffffffff88bcbee0
R13: 0000000000000224 R14: ffffffff8611baf0 R15: 0000000000000000
FS:  00005555560fd3c0(0000) GS:ffff8882652aa000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000010 CR3: 000000012023a000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 xfs_iwalk_args.constprop.0+0x325/0x3e0 fs/xfs/xfs_iwalk.c:548
 xfs_inobt_walk+0x11c/0x170 fs/xfs/xfs_iwalk.c:758
 xfs_inumbers+0x294/0x3a0 fs/xfs/xfs_itable.c:471
 xfs_ioc_inumbers.constprop.0+0x1d1/0x2b0 fs/xfs/xfs_ioctl.c:340
 xfs_file_ioctl+0x11b1/0x1c40 fs/xfs/xfs_ioctl.c:1241
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:907 [inline]
 __se_sys_ioctl fs/ioctl.c:893 [inline]
 __x64_sys_ioctl+0x18f/0x210 fs/ioctl.c:893
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xa8/0x270 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f444b67600d
Code: 28 c3 e8 46 1e 00 00 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fffbb37fa88 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fffbb37fc88 RCX: 00007f444b67600d
RDX: 0000000020000080 RSI: 0000000080405880 RDI: 0000000000000004
RBP: 0000000000000001 R08: 0000000000000000 R09: 00007fffbb37fc88
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 00007fffbb37fc78 R14: 00007f444b6f3530 R15: 0000000000000001
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:assfail+0x9d/0xa0 fs/xfs/xfs_message.c:102
Code: 75 22 e8 76 88 3a ff 90 0f 0b 90 5b 5d 41 5c 41 5d e9 87 2d 78
02 48 c7 c7 78 af c3 89 e8 eb 59 6f ff eb ca e8 54 88 3a ff 90 <0f> 0b
90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 66 0f 1f
RSP: 0018:ffff8881107877c0 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffffffff86122a6c
RDX: ffff8881114e9e80 RSI: 0000000000000000 RDI: 0000000000000001
RBP: 0000000000000000 R08: 0000000000000001 R09: ffffed10220f0e8d
R10: 0000000000000001 R11: 737341203a534658 R12: ffffffff88bcbee0
R13: 0000000000000224 R14: ffffffff8611baf0 R15: 0000000000000000
FS:  00005555560fd3c0(0000) GS:ffff8882652aa000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000010 CR3: 000000012023a000 CR4: 00000000000006f0
journal-offline (282) used greatest stack depth: 25016 bytes left
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Below is a C reproducer generated by Syzkaller=EF=BC=9A
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
// autogenerated by syzkaller (https://github.com/google/syzkaller)

#define _GNU_SOURCE

#include <endian.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <unistd.h>

uint64_t r[1] =3D {0xffffffffffffffff};

int main(void)
{
syscall(__NR_mmap, /*addr=3D*/0x1ffff000ul, /*len=3D*/0x1000ul,
/*prot=3D*/0ul, /*flags=3D*/0x32ul, /*fd=3D*/-1, /*offset=3D*/0ul);
syscall(__NR_mmap, /*addr=3D*/0x20000000ul, /*len=3D*/0x1000000ul,
/*prot=3D*/7ul, /*flags=3D*/0x32ul, /*fd=3D*/-1, /*offset=3D*/0ul);
syscall(__NR_mmap, /*addr=3D*/0x21000000ul, /*len=3D*/0x1000ul,
/*prot=3D*/0ul, /*flags=3D*/0x32ul, /*fd=3D*/-1, /*offset=3D*/0ul);
intptr_t res =3D 0;
memcpy((void*)0x20000000, "/mnt/xfs/testdir\000", 17);
syscall(__NR_open, /*dir=3D*/0x20000000ul, /*flags=3D*/0x8441ul, /*mode=3D*=
/0ul);
memcpy((void*)0x20000040, "/mnt/xfs/testdir\000", 17);
res =3D syscall(__NR_open, /*dir=3D*/0x20000040ul, /*flags=3D*/0ul, /*mode=
=3D*/0ul);
if (res !=3D -1)
r[0] =3D res;
*(uint64_t*)0x20000080 =3D 0;
*(uint64_t*)0x20000088 =3D 0x8000000000000005;
*(uint64_t*)0x20000090 =3D 0;
syscall(__NR_ioctl, /*fd=3D*/r[0], /*cmd=3D*/0x80405880, /*arg=3D*/0x200000=
80ul);
return 0;
}
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Best regards,
Cen Zhang
