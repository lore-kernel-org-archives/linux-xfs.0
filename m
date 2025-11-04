Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4098333E345
	for <linux-xfs@vger.kernel.org>; Tue,  4 Nov 2025 18:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762280755; cv=none; b=JB2jpWA8/oyCQ05KQp3EReRFuoo3x9Npb32FlmWINGUb9qUSPT9dsbu6qM8RRH6Htv0biUq7HZcDD8VW8LG6KzNQvQvzbIHqhriQ4YVHUfjDV4O9PiX7mtNalHLBVMt8LVKg9hzcIjkXqRNuCx/JWPfwWVbJoZgHw9/vryKodqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762280755; c=relaxed/simple;
	bh=xQr66sfWcYDPdt1OZVxS5cHO8GM9E9VyMkXI31644oE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FGRh5E1BQJs15DDQitPSazhurPRvd/HzclTt4MsWwKCm94bEnATJPAj6gnAYvbynMS7YS/SVRKCa/i4T1hGlEfaDtvirHyNoQ0o6t4/jgWocnODACQ9MJQKdveVJXzBNmMEPfFA6pxFTo8P9VcK5U/ggunLCC0gWWiNzWC6BH3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=X5qjeZyA; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="X5qjeZyA"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b710601e659so373553666b.1
        for <linux-xfs@vger.kernel.org>; Tue, 04 Nov 2025 10:25:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762280751; x=1762885551; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=YPkYNb3AdFbUUvWyK5+IEaMU2KcLnkNB85urH6+U/Jk=;
        b=X5qjeZyAUNH27ueKeS1/TnkFDc/bloo9oIINnR2Dr0BJep65ZuczAgP2Yp9roIXY9w
         a8vIW86MS8yoHbqApY3cHZ2+zP8XbrCpBlDSEpLaii11Wn926kZtKgavZ4rI+ohXQz32
         Api7RbuscN2JEwbS4zjdBesFzGpKfjs1T1nTb6QJlsKft0cXwIvU7Zv5Bg0t8z1oEDCG
         dTfvvWGvMtkL796BVLNY8kc+QSBAnIlTC7CAq4bnPVjGKgECIIhymFQIbyejBaTtVxpc
         qwxLDfd3O3761BNz5FewfCqYDuBplKMll9VOJL0s7FD1Ivi/rsP1mKUDrDt9j0VcxavN
         ReCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762280751; x=1762885551;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YPkYNb3AdFbUUvWyK5+IEaMU2KcLnkNB85urH6+U/Jk=;
        b=nRbyCN9k8/7kNp636keyNnE3Y+iDg+Uoil8d5Bn5gSOmplWEqhTU61w1G3DmMB0fas
         +ibM5riTHtiRVjZCYxn0PwE6+EBNr9FAEficv7+rp1qi4/s44ch5iDxDJEDWALbgq4J+
         h/SFqj+hS0zY4IL4Bls1INVy9BXFJ8Qoft3feS5Nr/5ZP3SOG2jRUJTLEYEFFYlZT6ZM
         wOeeqMyBWxyU0s9RT7Mnc8ZKhEjW19/T4ijtBdhEfsI8LZdKuQhgaXDzf3r+TFB/z59H
         cfbXVIWRGbGLqM/D0UHSpago+IlBjl6Di2x3swU8cbmNe03PmKCPUO+bDmAmZAcrQzGw
         sxBQ==
X-Forwarded-Encrypted: i=1; AJvYcCVttlLhB/7Qs15dLrdyyXIe29LvFDrxMoY2LBKyFtJe3rrRjFRDkH5lODjsSszlrcdXc9IvuVsOJkg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxIeGzVxdUW2AE7sZKxGR4hRNpMV5TMvBE5uS+9H3rd99EcHuk3
	OeZqY59M2qIcty+sDjnEEI+yuodeuBswOiqiX1bdjFAwFWsSwioe8NhM/EthEFDmTHc=
X-Gm-Gg: ASbGnctOHpCiJgvheOqZYtM62WpWtd56+wz+O/3OxcXAmO5PELpcMG/SqxIkJ/0nGI3
	tTxkhcw2Wbci6MxRC2e5Gm7mr81e5/ChpAeIsnFvu+LtXCOn9ORmMoUGlgqSE4RrkeEzYs97dBp
	X9P9teNg/4LzkJMSd6i4jdeTV90CM53I+m8S2TkTw/zPZkLjKUwgaEQSzmsrC+xo+FWJCpacySd
	VJrSzVcFmp0grqugZhMvcCxNCfgay8aaBiq36yeC89Jf/TP/w5qrZShheENnkEDI2xvhZ1M/eio
	DHCcTbNllssZAyG8/hQWppsv2jnRbbotHGBvOWPnbsY4b9INAf9mThG5g5WoxgCSgZ2DPPig2J8
	Tcv7OR6Xs+QBms4I+6NF7nPGUyN6dn2xCgCoeEjCgcJSjQxKLhBSu7STC8ajOCzaJCGgLG/6DiR
	jsnow=
X-Google-Smtp-Source: AGHT+IFAz3YGZNVaEACS46pBOhwodMBp8mAa30t1ei+hvvakkC32yROwn5/v/BY4HZBMgQz5jF71mw==
X-Received: by 2002:a17:907:3f1b:b0:b43:b7ec:b8a1 with SMTP id a640c23a62f3a-b726529edfemr13155566b.24.1762280751465;
        Tue, 04 Nov 2025 10:25:51 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b723d3a3d4asm277568566b.2.2025.11.04.10.25.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Nov 2025 10:25:51 -0800 (PST)
Date: Tue, 4 Nov 2025 19:25:48 +0100
From: Petr Mladek <pmladek@suse.com>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: syzbot <syzbot+3686758660f980b402dc@syzkaller.appspotmail.com>,
	"amurray@thegoodpenguin.co.uk" <amurray@thegoodpenguin.co.uk>,
	brauner@kernel.org, chao@kernel.org, djwong@kernel.org,
	jaegeuk@kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com,
	John Ogness <john.ogness@linutronix.de>
Subject: Re: [syzbot] [iomap?] kernel BUG in folio_end_read (2)
Message-ID: <aQpFLJM96uRpO4S-@pathway.suse.cz>
References: <CAJnrk1bF8sLU6tG2MGkt_KR4BoTd_k01CMVZJ9js2-eyh80tbw@mail.gmail.com>
 <69096836.a70a0220.88fb8.0006.GAE@google.com>
 <CAJnrk1Yo4dRVSaPCaAGkHc+in03KaTXJ+KxckhLoSrRxbEdDBg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJnrk1Yo4dRVSaPCaAGkHc+in03KaTXJ+KxckhLoSrRxbEdDBg@mail.gmail.com>

Adding John into Cc.

On Tue 2025-11-04 09:45:27, Joanne Koong wrote:
> On Mon, Nov 3, 2025 at 6:43 PM syzbot
> <syzbot+3686758660f980b402dc@syzkaller.appspotmail.com> wrote:
> >
> > Hello,
> >
> > syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> > WARNING in get_data
> >
> > loop0: detected capacity change from 0 to 16
> > ------------[ cut here ]------------
> > WARNING: kernel/printk/printk_ringbuffer.c:1278 at get_data+0x48a/0x840 kernel/printk/printk_ringbuffer.c:1278, CPU#1: syz.0.585/7652

It seems to trigger an "Illegac block description" warning, see :

   1263         /* Regular data block: @begin less than @next and in same wrap. */
   1264         if (!is_blk_wrapped(data_ring, blk_lpos->begin, blk_lpos->next) &&
   1265             blk_lpos->begin < blk_lpos->next) {
   1266                 db = to_block(data_ring, blk_lpos->begin);
   1267                 *data_size = blk_lpos->next - blk_lpos->begin;
   1268 
   1269         /* Wrapping data block: @begin is one wrap behind @next. */
   1270         } else if (!is_blk_wrapped(data_ring,
   1271                                    blk_lpos->begin + DATA_SIZE(data_ring),
   1272                                    blk_lpos->next)) {
   1273                 db = to_block(data_ring, 0);
   1274                 *data_size = DATA_INDEX(data_ring, blk_lpos->next);
   1275 
   1276         /* Illegal block description. */
   1277         } else {
   1278                 WARN_ON_ONCE(1);		<-----------
   1279                 return NULL;
   1280         }


> > Modules linked in:
> > CPU: 1 UID: 0 PID: 7652 Comm: syz.0.585 Not tainted syzkaller #0 PREEMPT(full)
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/02/2025
> > RIP: 0010:get_data+0x48a/0x840 kernel/printk/printk_ringbuffer.c:1278
> > Code: 83 c4 f8 48 b8 00 00 00 00 00 fc ff df 41 0f b6 04 07 84 c0 0f 85 ee 01 00 00 44 89 65 00 49 83 c5 08 eb 13 e8 a7 19 1f 00 90 <0f> 0b 90 eb 05 e8 9c 19 1f 00 45 31 ed 4c 89 e8 48 83 c4 28 5b 41
> > RSP: 0018:ffffc900035170e0 EFLAGS: 00010293
> > RAX: ffffffff81a1eee9 RBX: 00003fffffffffff RCX: ffff888033255b80
> > RDX: 0000000000000000 RSI: 00003fffffffffff RDI: 0000000000000000
> > RBP: 0000000000000012 R08: 0000000000000e55 R09: 000000325e213cc7
> > R10: 000000325e213cc7 R11: 00001de4c2000037 R12: 0000000000000012
> > R13: 0000000000000000 R14: ffffc90003517228 R15: 1ffffffff1bca646
> > FS:  00007f44eb8da6c0(0000) GS:ffff888125fda000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00007f44ea9722e0 CR3: 0000000066344000 CR4: 00000000003526f0
> > Call Trace:
> >  <TASK>
> >  copy_data kernel/printk/printk_ringbuffer.c:1857 [inline]
> >  prb_read kernel/printk/printk_ringbuffer.c:1966 [inline]
> >  _prb_read_valid+0x672/0xa90 kernel/printk/printk_ringbuffer.c:2143
> >  prb_read_valid+0x3c/0x60 kernel/printk/printk_ringbuffer.c:2215
> >  printk_get_next_message+0x15c/0x7b0 kernel/printk/printk.c:2978
> >  console_emit_next_record kernel/printk/printk.c:3062 [inline]
> >  console_flush_one_record kernel/printk/printk.c:3194 [inline]
> >  console_flush_all+0x4cc/0xb10 kernel/printk/printk.c:3268
> >  __console_flush_and_unlock kernel/printk/printk.c:3298 [inline]
> >  console_unlock+0xbb/0x190 kernel/printk/printk.c:3338
> >  vprintk_emit+0x4c5/0x590 kernel/printk/printk.c:2423
> >  _printk+0xcf/0x120 kernel/printk/printk.c:2448
> >  _erofs_printk+0x349/0x410 fs/erofs/super.c:33
> >  erofs_fc_fill_super+0x1591/0x1b20 fs/erofs/super.c:746
> >  get_tree_bdev_flags+0x40e/0x4d0 fs/super.c:1692
> >  vfs_get_tree+0x92/0x2b0 fs/super.c:1752
> >  fc_mount fs/namespace.c:1198 [inline]
> >  do_new_mount_fc fs/namespace.c:3641 [inline]
> >  do_new_mount+0x302/0xa10 fs/namespace.c:3717
> >  do_mount fs/namespace.c:4040 [inline]
> >  __do_sys_mount fs/namespace.c:4228 [inline]
> >  __se_sys_mount+0x313/0x410 fs/namespace.c:4205
> >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> >  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > RIP: 0033:0x7f44ea99076a
> > Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> > RSP: 002b:00007f44eb8d9e68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
> > RAX: ffffffffffffffda RBX: 00007f44eb8d9ef0 RCX: 00007f44ea99076a
> > RDX: 0000200000000180 RSI: 00002000000001c0 RDI: 00007f44eb8d9eb0
> > RBP: 0000200000000180 R08: 00007f44eb8d9ef0 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000246 R12: 00002000000001c0
> > R13: 00007f44eb8d9eb0 R14: 00000000000001a1 R15: 0000200000000080
> >  </TASK>
> >
> 
> This looks unrelated to the iomap changes and seems tied to the recent
> printk console flushing changes. Hmm, maybe one of these changes
> [1,2,3]?
>> 
> [1] https://lore.kernel.org/all/20251020-printk_legacy_thread_console_lock-v3-1-00f1f0ac055a@thegoodpenguin.co.uk/
> [2] https://lore.kernel.org/all/20251020-printk_legacy_thread_console_lock-v3-2-00f1f0ac055a@thegoodpenguin.co.uk/
> [3] https://lore.kernel.org/all/20251020-printk_legacy_thread_console_lock-v3-3-00f1f0ac055a@thegoodpenguin.co.uk/

These patches modified the callers of the printk_ringbuffer API.
I doubt that they might cause the problem.

It rather looks like an internal bug in the printk_ringbuffer code.
And there is only one recent patch:

   https://patch.msgid.link/20250905144152.9137-2-d-tatianin@yandex-team.ru

The scenario leading to the WARN() is not obvious to me. But the patch
touched this code path. So it is a likely culprit. I have to think
more about it.

Anyway, I wonder if the WARNING is reproducible and if it happens even after
reverting the commit 67e1b0052f6bb82be84e3 ("printk_ringbuffer: don't
needlessly wrap data blocks around")

Best Regards,
Petr

> Thanks,
> Joanne
> 
> >
> > Tested on:
> >
> > commit:         98231209 Add linux-next specific files for 20251103
> > git tree:       linux-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=1370a292580000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=43cc0e31558cb527
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3686758660f980b402dc
> > compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> >
> > Note: no patches were applied.
