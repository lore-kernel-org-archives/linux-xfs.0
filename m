Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693751922FD
	for <linux-xfs@vger.kernel.org>; Mon, 20 Jan 2025 08:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737360866; cv=none; b=RlSKJ2yOu+49ME16c3qJfMsIR5xynd4LI1LuoLuvGj7Xdq6urqIgyhSno88dUhMtpdFdESQdkzNfYdN8oRFgWQ2yID9UVlVJQVPJnWKIFaVe+BlkvsVDQgS2UwhMNMPLxnzyQwD4MpJ5qj5ZcHSMhik7HvwIy7Fiah/X2ts3Udc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737360866; c=relaxed/simple;
	bh=MGWhmJX8lqcL8FHLyjgiYEi4RcN9+x8nAITWycT0GrA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Tlk2j6SUnctk+jN1WQW4TlF2WSV13Z6fqNJ1rrUX0I7l5Ed5xWmQkRCtjhsGbBHTZN2lQQxqm+lycUPLQl0lyiARPWTBHH65TDZWbnErC7Eg8bCd/7cYkYBotlJvsQrUldb3kF/lGrEm3C8xKsYd4xNWlk+jbDnEi2TGE3YVLP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3ce7aec7368so28177845ab.3
        for <linux-xfs@vger.kernel.org>; Mon, 20 Jan 2025 00:14:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737360864; x=1737965664;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RN1ut9YyCo2w4BXnWeLtqFWW7U3TJDnt7DX4lyG/g8I=;
        b=j59GqETLVolYroEVY4rabi2C2EZMB8v+QaYgVrXuMw03vGSj2wQw8TFecKMe8Ef8ZO
         a6Z0AeLA0vrVIyF5xL6yVW7HHz5Y8jOdoexzQ/kfbKb/a/YomVqjRu4XhOWCBDlf368t
         9UXasRWphJ/i5cnAExh2VbCaVdbiN5ttjlbxmIx7oiAjY19wu0gRLXbWN9wi7lrrOgZ6
         fxOSI+QeGReegxrBEnaNExkwkbIE0GYQjIYlaoSsAnn4l4cF6tJov4LhfwSKQnCioRJx
         5oMWQDgbYgkVDdF33Bwu7f4IrKTu7Eb2RLRnm1IypnbXVN2s10MuKhXzINiqU6Y6tDV3
         LyBg==
X-Forwarded-Encrypted: i=1; AJvYcCWjx0FbNuWk3s6TEK1DyhQYOu9dbBdXuOZGJ7qRR4sCuUfQTWc/nwZfKomhOZBzHrsckjny9HeXURo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6u2x6K6gOAgcMSNDmjVjFiXIr1ttL/P3QdzuvYVzQHYGHHAOi
	bXxlYGXzxEx3k9EwJoF7KOITwtriHmOGSjGHFsDNlIsAHngv//mNqCQXbwBceMHjxGJFcRB+iDn
	+bBPmg5WBfYMiRv2xo2gTdaTf6xqBfCsW9J6AsuPzaZrKvwnT198xMxg=
X-Google-Smtp-Source: AGHT+IEKbMjpUP7xpxnhzjNY/y4799s3MIuJrwstmv8bH5JSWww9izFxnXI5z72j/11NoPhyMm1NrVodvj03f5xf8Qz+tllyNL4d
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:260f:b0:3ce:8693:728e with SMTP id
 e9e14a558f8ab-3cf743c97e5mr102503965ab.3.1737360864597; Mon, 20 Jan 2025
 00:14:24 -0800 (PST)
Date: Mon, 20 Jan 2025 00:14:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <678e05e0.050a0220.303755.0070.GAE@google.com>
Subject: [syzbot] Monthly xfs report (Jan 2025)
From: syzbot <syzbot+list7e7905dfe65ae535d3b2@syzkaller.appspotmail.com>
To: chandan.babu@oracle.com, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello xfs maintainers/developers,

This is a 31-day syzbot report for the xfs subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/xfs

During the period, 3 new issues were detected and 0 were fixed.
In total, 18 issues are still open and 25 have already been fixed.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 6194    Yes   possible deadlock in xfs_dquot_detach_buf
                  https://syzkaller.appspot.com/bug?extid=3126ab3db03db42e7a31
<2> 865     Yes   KASAN: stack-out-of-bounds Read in xfs_buf_lock
                  https://syzkaller.appspot.com/bug?extid=0bc698a422b5e4ac988c
<3> 177     Yes   KASAN: slab-use-after-free Read in xfs_inode_item_push
                  https://syzkaller.appspot.com/bug?extid=1a28995e12fd13faa44e
<4> 92      Yes   INFO: task hung in xfs_buf_item_unpin (2)
                  https://syzkaller.appspot.com/bug?extid=837bcd54843dd6262f2f
<5> 10      No    possible deadlock in xfs_dquot_disk_alloc
                  https://syzkaller.appspot.com/bug?extid=0f440b139d96ada5b0fd
<6> 6       No    BUG: unable to handle kernel paging request in xfs_destroy_mount_workqueues
                  https://syzkaller.appspot.com/bug?extid=63340199267472536cf4

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
