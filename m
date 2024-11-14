Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F6C2AD39
	for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2024 00:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731544637; cv=none; b=hyCyEAK8vnNR2q4LOccKKZz82e008TMF/rYUrLLtm3zfuuJTehnyUTcxoacNar9icrW6TwqFt9vsL2RWBjrb44KyTAnbzSSp4R8Tsvh799tcq8ECQ3/jm+prlTE7WBo44tuHujjNp7wivkkJv7IALDts+IT75/rYXoGD9GmNUio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731544637; c=relaxed/simple;
	bh=QPrG53eiGGqVOY8cqda1uKvaeMNMMQSz5E31mtFgkTY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QR2hQSpWBfla/zgkgEfujX9OQdUlNEvmKzWNuBk6t7dewAeDTQUmqsZLirNIWGbngBr8pPt9AaY4jML3ZJcCJ5S3OZNT6SUAgWenA1hIQ3dGvGLVFqlJiOTgCsbtgPQRcYKeNvxPB7FDg5ryhHmVSvrYc4RACeZRPGOLin8jifY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=CHNubFvf; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="CHNubFvf"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-20cceb8d8b4so79845ad.1
        for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2024 16:37:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1731544635; x=1732149435; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jL1bq/cs3DwHGudCjECuU0svhY9jIgo9sOD6hc9Njrw=;
        b=CHNubFvfxNi8ZllZMxVMh+kA2TR3/pxcfbRzXihouDIjx6DJUe4SI7KL3tV3M4SSkS
         ZaT2axF8zizwWKEx+vZGwVJ7JOf5PW28uMErXhANVNAPuEsakWK3AF7nZanyIAeK1rOF
         D+cNYHlKhb1EzbZgxtUOUSjxYCA+05mHOoZMy5Gw/ECguqYJsKI3whLG8F/94pRwYDLK
         HudHSBxQSChA0vD8Lnn++vnYyO2M6RN89erodHrdpsVVMn2Ho2ga2vN0NIKXuha/d+ng
         yn1GcbHu9dZH7oHbpNnPfDlY3jW5TsWXktlc5FeACuRXNzmDTMhgGOumud9Ubb/7S8BJ
         nyZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731544635; x=1732149435;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jL1bq/cs3DwHGudCjECuU0svhY9jIgo9sOD6hc9Njrw=;
        b=a4O+7vIGrzDp9ZcRQxhyUTskYNRQjO+kDjjepx3eRk3MsOvLrvmJXjwS20YDkdS6aM
         zvv5KU/02bUltlfc0zxkdRE1BsWWS2iqfj/yIA8VLr6j4yvAjktDmTSS0anef2HlmbN/
         HcTUInF8rhSiU8ttc5wZwuAfPmxzu3fyExrSycfKUWmTSgS79UR81Bsf/zQA9QcJAbPT
         WjzO3mjgoeb8EFszFxFNLMLiI3s5sJTIzRmgzDRfUC4osUNsSj4NqqBwcT2j6xZziPw3
         utcQlR1fgPEeF2X4GwuEUgts/Jo2M8OEvHT12EotO/VTofsM4Ym3grJp6BsF3COBv+UN
         R6Nw==
X-Forwarded-Encrypted: i=1; AJvYcCVsHhiecXgV+piXmx/e7PRRTtcaJYt0URClgJSLmqaarVRUzzAn2QwIerNNk6wz/XBMStU6PHeglm8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBWb3o1t3Ut/sjkpAANfmMo3Z79FVqlhoLlNurkmeYXDqUmIBc
	N71Onk6z4WaEyArFbG/zbBDOrSz25SAWI7C/UrcmI+TM8uAN4jD76VYNVHQzmb0=
X-Google-Smtp-Source: AGHT+IEbvuImRnO77YgC/dY5K85BskHZNK65tOmH0Zaa7ILqfZYPsHP613mLFhEWCU0U/8qr0ttT/g==
X-Received: by 2002:a17:903:244b:b0:20c:c18f:c39e with SMTP id d9443c01a7336-211c0fab017mr20154665ad.21.1731544635527;
        Wed, 13 Nov 2024 16:37:15 -0800 (PST)
Received: from dread.disaster.area (pa49-186-86-168.pa.vic.optusnet.com.au. [49.186.86.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21177dc7d1csm116754865ad.51.2024.11.13.16.37.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2024 16:37:15 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1tBNrE-00EJXl-00;
	Thu, 14 Nov 2024 11:37:12 +1100
Date: Thu, 14 Nov 2024 11:37:11 +1100
From: Dave Chinner <david@fromorbit.com>
To: syzbot <syzbot+3c653ce382d9a9b6fbc3@syzkaller.appspotmail.com>
Cc: cem@kernel.org, chandan.babu@oracle.com, djwong@kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [xfs?] WARNING in mod_delayed_work_on (2)
Message-ID: <ZzVGN3gvt4Pw2pwG@dread.disaster.area>
References: <67342365.050a0220.1324f8.0003.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67342365.050a0220.1324f8.0003.GAE@google.com>

On Tue, Nov 12, 2024 at 07:56:21PM -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    f1dce1f09380 Merge tag 'slab-for-6.12-rc7' of git://git.ke..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=143eaea7980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=347f0ef7656eeb41
> dashboard link: https://syzkaller.appspot.com/bug?extid=3c653ce382d9a9b6fbc3
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/290169b0e6d0/disk-f1dce1f0.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/e26fb82ee406/vmlinux-f1dce1f0.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/d26ba056ed6b/bzImage-f1dce1f0.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+3c653ce382d9a9b6fbc3@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 8571 at kernel/workqueue.c:2498 __queue_delayed_work+0x212/0x250 kernel/workqueue.c:2498
> Modules linked in:
> CPU: 0 UID: 0 PID: 8571 Comm: syz-executor Not tainted 6.12.0-rc6-syzkaller-00192-gf1dce1f09380 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/30/2024
> RIP: 0010:__queue_delayed_work+0x212/0x250 kernel/workqueue.c:2498

WARN_ON_ONCE(!list_empty(&work->entry));

> Code: 0f 0b 90 e9 39 fe ff ff e8 8b 9f 37 00 90 0f 0b 90 e9 65 fe ff ff e8 7d 9f 37 00 90 0f 0b 90 e9 81 fe ff ff e8 6f 9f 37 00 90 <0f> 0b 90 e9 9f fe ff ff e8 61 9f 37 00 48 89 df 44 89 f6 eb ac 89
> RSP: 0018:ffffc90002d5fac8 EFLAGS: 00010093
> RAX: ffffffff815d3a91 RBX: ffffe8ffffc43440 RCX: ffff888028098000
> RDX: 0000000000000000 RSI: ffff88805a2f1800 RDI: 0000000000000000
> RBP: ffffe8ffffc43448 R08: ffffffff815d3c06 R09: 0000000000000000
> R10: ffffc90002d5fb40 R11: fffff520005abf69 R12: 0000000000000001
> R13: dffffc0000000000 R14: 0000000000000000 R15: ffff88805a2f1800
> FS:  000055556c4f5500(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fdcb605fe07 CR3: 000000005d732000 CR4: 00000000003526f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  mod_delayed_work_on+0x153/0x370 kernel/workqueue.c:2588
>  xfs_inodegc_queue fs/xfs/xfs_icache.c:2158 [inline]
>  xfs_inode_mark_reclaimable+0x7a6/0xf60 fs/xfs/xfs_icache.c:2194
>  destroy_inode fs/inode.c:315 [inline]
>  evict+0x7b5/0x9b0 fs/inode.c:756
>  do_unlinkat+0x512/0x830 fs/namei.c:4540

AFAICT there is nothing wrong with the way XFS is using
mod_delayed_work_on() here - the internal work entry state that the
workqueue infrastructure manages appears to be in an incorrect
state.

This is not obviously an XFS issue.

-Dave.

-- 
Dave Chinner
david@fromorbit.com
