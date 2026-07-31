Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6562432E6BC;
	Fri, 31 Jul 2026 21:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785533392; cv=none; b=ZDnkWAY0xJIqtfHglUrZaQ7Yba9crm/+AAG1cttfkvDQhDX2NepbkK9EWSxQwNXyszDVJGBhLZRaPrI3C1RrEe44x1ElwSIl+fQyqEkr0sRI9eovKqryIfkJ718IVmn5mISRvJoNoGD5kmsqiyMvBJGFDIbAj6KIad/O/yBhEDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785533392; c=relaxed/simple;
	bh=mw2X0JhM/ZvPxvciZTmnWy/8YDUT1/16MCVAztTMHiA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q2bmtROLWVGWoGQDBDee1AKynLiSjyGvDn5Nqg/TpfMF/vV3DIGfK8w+8skG00EfPxhtkF8yhkKFWlEn9KjArXS6ydk8lESceJRnHxqfaJPdgm1MeYEoZ8c1jofffzx/5XC6qI6Xb2+SMpeE1OAzzxnDE0ZCQmZVUTtsyhQfOyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=FIlaoQTq; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="FIlaoQTq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1785533388; x=1786138188; i=quwenruo.btrfs@gmx.com;
	bh=no9Y2aVtEAf0uZ7mul7hOghjXFJZpEk/v9jp9yYbLPY=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=FIlaoQTqDHdxEZDcjlHmS+RPAMnt1ZFTxve06d6N6cMeynNmRQC2vgk9BeHcNKVg
	 7SXpjoz4xDXxl1BYrhWEYX5v4Cim5toBrJkg3hhD8gA8FlkObZVn1uLgQRtvEIOnV
	 RM9+dNhpDIiAY/7k+G30SgUUIaCxWYdpNKf/c45zRK6KVYDdYJ8ispiSyXlyw5iPL
	 0d5lWKme1Njda8vZhBVeG7DX+0GnpLaQje8NRl48FaTpwlqV4O9H/PN94FkeJmzCQ
	 erf2+YsgoYBhwnmmIO226XYfdM2Tgp2P2gO4KDDo3V7qk7mLjyIzxCOL01qV2lrpe
	 iyI5udbc/PZJ54HVRA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MxDou-1x9uWh1yjA-00w01a; Fri, 31
 Jul 2026 23:29:48 +0200
Message-ID: <5dde7abf-97f2-45d5-b6ed-0422bee777b6@gmx.com>
Date: Sat, 1 Aug 2026 06:59:42 +0930
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot ci] Re: iomap: follow the alignment requirement for
 iomap_dio_hole_iter()
To: syzbot ci <syzbot+ci731b4119b755b229@syzkaller.appspotmail.com>,
 linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-xfs@vger.kernel.org, wqu@suse.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
References: <6a6c89d9.77639fcc.3d4fd0.0026.GAE@google.com>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1YAUJEP5a
 sQAKCRDCPZHzoSX+qF+mB/9gXu9C3BV0omDZBDWevJHxpWpOwQ8DxZEbk9b9LcrQlWdhFhyn
 xi+l5lRziV9ZGyYXp7N35a9t7GQJndMCFUWYoEa+1NCuxDs6bslfrCaGEGG/+wd6oIPb85xo
 naxnQ+SQtYLUFbU77WkUPaaIU8hH2BAfn9ZSDX9lIxheQE8ZYGGmo4wYpnN7/hSXALD7+oun
 tZljjGNT1o+/B8WVZtw/YZuCuHgZeaFdhcV2jsz7+iGb+LsqzHuznrXqbyUQgQT9kn8ZYFNW
 7tf+LNxXuwedzRag4fxtR+5GVvJ41Oh/eygp8VqiMAtnFYaSlb9sjia1Mh+m+OBFeuXjgGlG
 VvQFzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1gQUJEP5a0gAK
 CRDCPZHzoSX+qHGpB/kB8A7M7KGL5qzat+jBRoLwB0Y3Zax0QWuANVdZM3eJDlKJKJ4HKzjo
 B2Pcn4JXL2apSan2uJftaMbNQbwotvabLXkE7cPpnppnBq7iovmBw++/d8zQjLQLWInQ5kNq
 Vmi36kmq8o5c0f97QVjMryHlmSlEZ2Wwc1kURAe4lsRG2dNeAd4CAqmTw0cMIrR6R/Dpt3ma
 +8oGXJOmwWuDFKNV4G2XLKcghqrtcRf2zAGNogg3KulCykHHripG3kPKsb7fYVcSQtlt5R6v
 HZStaZBzw4PcDiaAF3pPDBd+0fIKS6BlpeNRSFG94RYrt84Qw77JWDOAZsyNfEIEE0J6LSR/
In-Reply-To: <6a6c89d9.77639fcc.3d4fd0.0026.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:7aXo6vp9hJB04aZ77IYgkUxJPZ7e5Opm36BY6faZAuNYGrDqDLs
 qA/RQCeG/z6BDx4R1bzQOkMIIwH5rffczlMqo7IfhcwX2XfZhpu8uX2Y6mgW1xavLTnpMLM
 UqrR0sMMfCA5/v9svHy9L7BiqqWgbGt7on/mru1n1fmo/aAw0m+Bq2fJ2WQ90fYUb3B+DwC
 6ZNznHUu6N5FkOWL6t/3g==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Z55y99Oo0FM=;mt6+ja1niDY1eq1vHVBg6akFMRq
 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
 LY+ykHRjJ5XZuGAwf62YINmX9vcnMk7PuhDWo=



=E5=9C=A8 2026/7/31 21:11, syzbot ci =E5=86=99=E9=81=93:
> syzbot ci has tested the following series
>=20
> [v1] iomap: follow the alignment requirement for iomap_dio_hole_iter()
> https://lore.kernel.org/all/e69cc8a4a9c3f641b97872b50f04c397880077cd.178=
5374485.git.wqu@suse.com
> * [PATCH] iomap: follow the alignment requirement for iomap_dio_hole_ite=
r()
>=20
> and found the following issue:
> general protection fault in __iomap_dio_rw
>=20
> Full report is available here:
> https://ci.syzbot.org/series/81e0fbae-4715-4d62-8e9e-bcd19e46b164
>=20
> ***
>=20
> general protection fault in __iomap_dio_rw
>=20
> tree:      vfs
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/vfs/=
vfs.git
> base:      70c2cbf8600c7d3a622b77e31136b83d6ac7d86c
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~=
exp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/8d5fee65-291c-46a2-9f9a-d512f8fa=
d82b/config
> syz repro: https://ci.syzbot.org/findings/c9f79a18-3316-44ec-b805-b805b1=
c49325/syz_repro
>=20
> loop0: rw=3D2049, sector=3D53248, nr_sectors =3D 976 limit=3D40427
> Oops: general protection fault, probably for non-canonical address 0xdff=
ffc0000000003: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
> CPU: 0 UID: 0 PID: 5842 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(=
full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1=
.16.2-1 04/01/2014
> RIP: 0010:bdev_get_queue include/linux/blkdev.h:1058 [inline]
> RIP: 0010:bdev_logical_block_size include/linux/blkdev.h:1403 [inline]
> RIP: 0010:iomap_dio_alignment fs/iomap/direct-io.c:415 [inline]
> RIP: 0010:iomap_dio_hole_iter fs/iomap/direct-io.c:595 [inline]
> RIP: 0010:iomap_dio_iter fs/iomap/direct-io.c:643 [inline]
> RIP: 0010:__iomap_dio_rw+0x1142/0x2130 fs/iomap/direct-io.c:815
> Code: e2 5a ff 83 e3 08 75 5c e8 ab de 5a ff 48 8b 9c 24 68 01 00 00 48 =
83 c3 18 48 89 d8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 =
74 08 48 89 df e8 d0 75 c8 ff 48 8b 1b b8 58 01 00 00
> RSP: 0018:ffffc90003fef560 EFLAGS: 00010206
> RAX: 0000000000000003 RBX: 0000000000000018 RCX: dffffc0000000000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffffc90003fef860 R08: ffff8881148d8fff R09: 0000000000000000
> R10: ffff8881148d8000 R11: ffffed102291b200 R12: 1ffff920007fdecc
> R13: 0000000000000000 R14: ffff888166b45340 R15: 0000000000001000
> FS:  00007fd77743d6c0(0000) GS:ffff88818d951000(0000) knlGS:000000000000=
0000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000078000 CR3: 000000011606a000 CR4: 00000000000006f0
> Call Trace:
>   <TASK>
>   f2fs_dio_read_iter fs/f2fs/file.c:4887 [inline]

This looks like f2fs is not populating iomap->bdev for holes, which is=20
not unreasonable for a hole.

So I need to update iomap_dio_alignment() for @bdev =3D=3D NULL cases.

Thanks for the report,
Qu


>   f2fs_file_read_iter+0x60b/0x940 fs/f2fs/file.c:4950
>   copy_splice_read+0x5ff/0xaa0 fs/splice.c:362
>   do_splice_read fs/splice.c:979 [inline]
>   splice_direct_to_actor+0x4b6/0xcb0 fs/splice.c:1084
>   do_splice_direct_actor fs/splice.c:1202 [inline]
>   do_splice_direct+0x195/0x290 fs/splice.c:1228
>   do_sendfile+0x52e/0x7c0 fs/read_write.c:1371
>   __do_sys_sendfile64 fs/read_write.c:1432 [inline]
>   __se_sys_sendfile64+0x144/0x1a0 fs/read_write.c:1418
>   do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>   do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fd77659df99
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 =
f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 =
ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fd77743d028 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
> RAX: ffffffffffffffda RBX: 00007fd776825fa0 RCX: 00007fd77659df99
> RDX: 0000000000000000 RSI: 0000000000000004 RDI: 0000000000000004
> RBP: 00007fd776634ec4 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000800000009 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fd776826038 R14: 00007fd776825fa0 R15: 00007fff168f4a18
>   </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:bdev_get_queue include/linux/blkdev.h:1058 [inline]
> RIP: 0010:bdev_logical_block_size include/linux/blkdev.h:1403 [inline]
> RIP: 0010:iomap_dio_alignment fs/iomap/direct-io.c:415 [inline]
> RIP: 0010:iomap_dio_hole_iter fs/iomap/direct-io.c:595 [inline]
> RIP: 0010:iomap_dio_iter fs/iomap/direct-io.c:643 [inline]
> RIP: 0010:__iomap_dio_rw+0x1142/0x2130 fs/iomap/direct-io.c:815
> Code: e2 5a ff 83 e3 08 75 5c e8 ab de 5a ff 48 8b 9c 24 68 01 00 00 48 =
83 c3 18 48 89 d8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 =
74 08 48 89 df e8 d0 75 c8 ff 48 8b 1b b8 58 01 00 00
> RSP: 0018:ffffc90003fef560 EFLAGS: 00010206
> RAX: 0000000000000003 RBX: 0000000000000018 RCX: dffffc0000000000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffffc90003fef860 R08: ffff8881148d8fff R09: 0000000000000000
> R10: ffff8881148d8000 R11: ffffed102291b200 R12: 1ffff920007fdecc
> R13: 0000000000000000 R14: ffff888166b45340 R15: 0000000000001000
> FS:  00007fd77743d6c0(0000) GS:ffff8882a8f51000(0000) knlGS:000000000000=
0000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007faa8f64dc80 CR3: 000000011606a000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>     0:	e2 5a                	loop   0x5c
>     2:	ff 83 e3 08 75 5c    	incl   0x5c7508e3(%rbx)
>     8:	e8 ab de 5a ff       	call   0xff5adeb8
>     d:	48 8b 9c 24 68 01 00 	mov    0x168(%rsp),%rbx
>    14:	00
>    15:	48 83 c3 18          	add    $0x18,%rbx
>    19:	48 89 d8             	mov    %rbx,%rax
>    1c:	48 c1 e8 03          	shr    $0x3,%rax
>    20:	48 b9 00 00 00 00 00 	movabs $0xdffffc0000000000,%rcx
>    27:	fc ff df
> * 2a:	80 3c 08 00          	cmpb   $0x0,(%rax,%rcx,1) <-- trapping instr=
uction
>    2e:	74 08                	je     0x38
>    30:	48 89 df             	mov    %rbx,%rdi
>    33:	e8 d0 75 c8 ff       	call   0xffc87608
>    38:	48 8b 1b             	mov    (%rbx),%rbx
>    3b:	b8 58 01 00 00       	mov    $0x158,%eax
>=20
>=20
> ***
>=20
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
>    Tested-by: syzbot@syzkaller.appspotmail.com
>=20
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
>=20
> To test a patch for this bug, please reply with `#syz test`
> (should be on a separate line).
>=20
> The patch should be attached to the email.
> Note: arguments like custom git repos and branches are not supported.
>=20

