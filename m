Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A9C15539A
	for <linux-xfs@vger.kernel.org>; Fri, 20 Feb 2026 00:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771548431; cv=pass; b=EHlf5wV9Wkx6kAymGqY9WAUvKWZLQBiLFb6IqxERk6Suh0UtuPafIRgw8v6EfIGbrecGfyhc+JPtou0R/wpTUFk28Eq5gNEBiiATN8HVLnXII8HEpz3MuWhpvVnu6w9CntiZDkEkbsJX/jC1IKAfu4YDFHZHaXYvrjSxc9Ty+bA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771548431; c=relaxed/simple;
	bh=xTt0BEA591J0c9PAsPbBiOclLC5gI9Gqua7xciXt6k0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pFh3tuzb2WWxLjmpHXn5NslIUkBYSGnyVQ/hLkho45m1/JjsvZHY8vsieV2b95VLsJPBLWxJ/STlIxuHr1c5cPem5py4BpRtCjfca2hswBmyLn9W0vjUS64998U312xUfmKhsW+Ruylv59/3Pn0BtYFLrlX7KsuRGzddIvwETqY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R7WtjQ1y; arc=pass smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R7WtjQ1y"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-506a93ba42dso16137771cf.1
        for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 16:47:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771548429; cv=none;
        d=google.com; s=arc-20240605;
        b=hECqSyeWQUllgCLAOPM4me795EywHct0sPh5UcW8wt2r29Ws78r0ra/CiCV5CNPYLS
         /jzWnJUkKZcYubsdzfALFqLJkv6JF91zPSoLScE7JeRb080sU1XlaCUM9T1StC5gkQf2
         vsIu1RfA0TfidQh2ZC4nZAvGh756ekXbrxqCKx/27MEcpQD69+2enfKO7N0+m0v7ZrAC
         ItIeAfA8wvT2wWCNMRfpgoyJLTElfBRTmfuTwYcQ3gTyolcaSc2HtWXEEGS7O1cws0mE
         y9vis3xUFwC67tt43MDfAPmi6RCEcXAteqVk47PshzVws79xZuBbWZMdgOVDWF86nmVU
         fJxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qzyzcE29s5UWFgF3EvqaYj8fmDA9pHKzMIVbNGFxE/w=;
        fh=VMJOhBF29C/B2z47zeZdF/zc1d27ulpDb/IejbgttxQ=;
        b=V6XNjBpc1Ho37Cy6w6RQasAF+AZcJXmEFzxr+QbQ/pZ/ENwk7eEg3EGO3l+uAA/2ju
         QP9tCvz3/2vj0DHEGRpZr6xILLKD6U5t/4hEPco64AglrVYD8D6A3fWC3N30cKeGloEd
         +7MPOssvU8DZkJDwRrfHbS9U/ydwRb/ggynOcH+YRdJq1V0lEtUyrdoD+1FKFcUvbRLP
         POLtQ3YaKVb0aCwliCfOpbO6lVvZdbFXmF9Ac1DlrJGak+b/sKkt1j3nN04ecBs3FSJS
         m9dSx0FaEi/br2KubBUk8W51x1YPUi0UK2M8CX8JUeXjwvZ0tE1l8MiolekF1i/S3lHZ
         bj1g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771548429; x=1772153229; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qzyzcE29s5UWFgF3EvqaYj8fmDA9pHKzMIVbNGFxE/w=;
        b=R7WtjQ1yuzLQI9+tfQ0XeBCOSmLUTQd0zCFh/XLDcP3tYNOpm1gYK9VVvFLFi/v7rW
         c/bWgX8U8KtchZFP5ToPdrL3thScz1SenwavPmLO2Gn9AYJRFw7P24hmmlWlge70q7Nx
         evXMLDsrupJRM4y8IUr2V888olky+5cTWtt1nq+UN3C8LzyW3oaopLXTNGGRw/244+Vr
         aPWiC7kF+Lf/EQPZBt47BrY5dVCdqcLus0PVYnU4ny7ipFYiXADGrC5BUR6FxAJioSH5
         a2djpeNWjiB3NL4Cpi3tm7ynPqx+ZTHlZ3PzHASW9jteI1IFN6RotUF/iu6cx5BM5Nhd
         cUVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771548429; x=1772153229;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qzyzcE29s5UWFgF3EvqaYj8fmDA9pHKzMIVbNGFxE/w=;
        b=uzuf5cJVwAZfBqclehicQC7LG+af0B/e/hpP6l44425+PapxUvd/o5DipKw3swa28R
         3ymC+HSVhKGx8UmbRrbj2KFWdmDxRM+aHZ44qlBXY0+LuslVPH2xkWzWQg0bQGOyHb8i
         VIxeuHpMgX6o8kjc4oI4TIZUVoswi7BJevsnM+xgreaSIhAlzGbxe2i7O2SNjrNiRpzB
         DM2GZARAQMVpV8hAdCPseaS2d71U09D3wr7o1vjh+DiP7/3Myoh4veTzygqa2xxQmgOd
         2E8JKp4wXztiWv7yQsekSXFj7jGlTMdxlWB1SJnitTNsS+GknI7Y2WBp6HBtyrz5XBBH
         IMcA==
X-Forwarded-Encrypted: i=1; AJvYcCUHkjh08X6E680jHZEsXNmMugTg60jd+bBGZ6DNZOQZKhWlYIksSfG/qKvt262m6EjSa4ZLO/EveF8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwfU6pFUiH7hp3Yz/ZvEUu7kjMANFchW02Zwpc/D4vdHuFd3bEf
	GQRevT6RPtLQqdOkEKQ7DWsmN7dh8nPC72sEXjvl15gkLhQqAirxYLVNWv9W+r1w7zUHkEnk5Q/
	vdHsPH91ytiPKe5bRf/n7j6Es9rAJgwY=
X-Gm-Gg: AZuq6aI9T1SAPXvYTAUY+3/YS3vtM8N9o1FCylWFH62Iee0D0fGRqzR2Umiy+4BieVv
	Wopl0vvsd5ML5lxxWV5xaLayBsS+ogtcej6fAUfYZiaXDxxZYOvE1YC6P0FlGU2WFs8E68Bx2xQ
	L/GDCXOqEY0hM8S1P3j3mkTk/9X4Sth6aZE6QXh4FTPPNtUhNzyhZY6mpzejObKm5WgFzUsT+qL
	qhev+H6Z7V4wu7wPBsKEVZIFlX+WCRT9FNV3aR+TMwDxf+eMgUkPYjCTCcmWX0lmXXC+OR7qvxN
	GidpmA==
X-Received: by 2002:a05:622a:1392:b0:502:f291:615e with SMTP id
 d75a77b69052e-506b40012c4mr255736501cf.52.1771548429056; Thu, 19 Feb 2026
 16:47:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <6968a164.050a0220.58bed.0011.GAE@google.com> <699777ce.050a0220.b01bb.0031.GAE@google.com>
In-Reply-To: <699777ce.050a0220.b01bb.0031.GAE@google.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 19 Feb 2026 16:46:58 -0800
X-Gm-Features: AaiRm53qLMVjJECGwYdBMHzFC2E7SY8nFWKsmtIAWKtQ0mVWd43M2D_UQOVJujo
Message-ID: <CAJnrk1bk7jN8SfHny9nVWZZS6tP8bnQbMZHTCuFma6-YuMugAg@mail.gmail.com>
Subject: Re: [syzbot] [iomap?] WARNING in ifs_free
To: syzbot <syzbot+d3a62bea0e61f9d121da@syzkaller.appspotmail.com>
Cc: brauner@kernel.org, djwong@kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 19, 2026 at 12:51=E2=80=AFPM syzbot
<syzbot+d3a62bea0e61f9d121da@syzkaller.appspotmail.com> wrote:
>
> syzbot has found a reproducer for the following issue on:
>
> HEAD commit:    2b7a25df823d Merge tag 'mm-nonmm-stable-2026-02-18-19-56'=
 ..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D10c2172258000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D65722f41f7edc=
17e
> dashboard link: https://syzkaller.appspot.com/bug?extid=3Dd3a62bea0e61f9d=
121da
> compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25=
a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D1501dc02580=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D1357f65258000=
0
>
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d=
900f083ada3/non_bootable_disk-2b7a25df.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/f3a54d09b17c/vmlinu=
x-2b7a25df.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/fb704901bce5/b=
zImage-2b7a25df.xz
> mounted in repro: https://storage.googleapis.com/syzbot-assets/b778b9903d=
e5/mount_0.gz
>
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+d3a62bea0e61f9d121da@syzkaller.appspotmail.com
>
> ------------[ cut here ]------------
> ifs_is_fully_uptodate(folio, ifs) !=3D folio_test_uptodate(folio)
> WARNING: fs/iomap/buffered-io.c:256 at ifs_free+0x358/0x420 fs/iomap/buff=
ered-io.c:255, CPU#0: syz-executor/5453
> Modules linked in:
> CPU: 0 UID: 0 PID: 5453 Comm: syz-executor Not tainted syzkaller #0 PREEM=
PT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.=
16.3-2 04/01/2014
> RIP: 0010:ifs_free+0x358/0x420 fs/iomap/buffered-io.c:255
> Code: 41 5f 5d e9 7a fb bd ff e8 45 5a 5e ff 90 0f 0b 90 e9 d0 fe ff ff e=
8 37 5a 5e ff 90 0f 0b 90 e9 0a ff ff ff e8 29 5a 5e ff 90 <0f> 0b 90 eb c3=
 44 89 e1 80 e1 07 80 c1 03 38 c1 0f 8c 06 fe ff ff
> RSP: 0018:ffffc9000dfcf688 EFLAGS: 00010293
> RAX: ffffffff82674207 RBX: 0000000000000008 RCX: ffff88801f834900
> RDX: 0000000000000000 RSI: 0000000000000008 RDI: 0000000000000000
> RBP: 000000008267bc01 R08: ffffea00010fb747 R09: 1ffffd400021f6e8
> R10: dffffc0000000000 R11: fffff9400021f6e9 R12: ffff888051c7da44
> R13: ffff888051c7da00 R14: ffffea00010fb740 R15: 1ffffd400021f6e9
> FS:  0000555586def500(0000) GS:ffff88808ca5b000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000555586e0aa28 CR3: 00000000591fe000 CR4: 0000000000352ef0
> Call Trace:
>  <TASK>
>  folio_invalidate mm/truncate.c:140 [inline]
>  truncate_cleanup_folio+0xcb/0x190 mm/truncate.c:160
>  truncate_inode_pages_range+0x2ce/0xe30 mm/truncate.c:404
>  ntfs_evict_inode+0x19/0x40 fs/ntfs3/inode.c:1861
>  evict+0x61e/0xb10 fs/inode.c:846
>  dispose_list fs/inode.c:888 [inline]
>  evict_inodes+0x75a/0x7f0 fs/inode.c:942
>  generic_shutdown_super+0xaa/0x2d0 fs/super.c:632
>  kill_block_super+0x44/0x90 fs/super.c:1725
>  ntfs3_kill_sb+0x44/0x1c0 fs/ntfs3/super.c:1889
>  deactivate_locked_super+0xbc/0x130 fs/super.c:476
>  cleanup_mnt+0x437/0x4d0 fs/namespace.c:1312
>  task_work_run+0x1d9/0x270 kernel/task_work.c:233
>  resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
>  __exit_to_user_mode_loop kernel/entry/common.c:67 [inline]
>  exit_to_user_mode_loop+0xed/0x480 kernel/entry/common.c:98
>  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline=
]
>  syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [=
inline]
>  syscall_exit_to_user_mode include/linux/entry-common.h:325 [inline]
>  do_syscall_64+0x32d/0xf80 arch/x86/entry/syscall_64.c:100
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fb0f859d897
> Code: a2 c7 05 5c ee 24 00 00 00 00 00 eb 96 e8 e1 12 00 00 90 31 f6 e9 0=
9 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05 <48> 3d 00 f0 ff=
 ff 77 01 c3 48 c7 c2 e8 ff ff ff f7 d8 64 89 02 b8
> RSP: 002b:00007ffd23732b28 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
> RAX: 0000000000000000 RBX: 00007fb0f8631ef0 RCX: 00007fb0f859d897
> RDX: 0000000000000000 RSI: 0000000000000009 RDI: 00007ffd23732be0
> RBP: 00007ffd23732be0 R08: 00007ffd23733be0 R09: 00000000ffffffff
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffd23733c70
> R13: 00007fb0f8631ef0 R14: 000000000001b126 R15: 00007ffd23733cb0
>  </TASK>
>

I ran the repro locally to see if it's the same issue fixed by [1] but
this is a different unrelated issue.

The folio is uptodate but the ifs uptodate bitmap is not reflected as
fully uptodate. I think this is because ntfs3 handles writes for
compressed files through its own interface that doesn't go through
iomap where it calls folio_mark_uptodate() but the ifs bitmap doesn't
get updated. fuse-blk servers that operate in writethrough mode run
into something like this as well [2].

This doesn't lead to any data corruption issues. Should we get rid of
the  WARN_ON_ONCE(ifs_is_fully_uptodate(folio, ifs) !=3D
folio_test_uptodate(folio))? The alternative is to make a modified
version of the functionality in "iomap_set_range_uptodate()" a public
api callable by subsystems.

Thanks,
Joanne

[1] https://lore.kernel.org/linux-fsdevel/20260219003911.344478-1-joannelko=
ong@gmail.com/
[2] https://lore.kernel.org/linux-fsdevel/20251223223018.3295372-2-sashal@k=
ernel.org/
