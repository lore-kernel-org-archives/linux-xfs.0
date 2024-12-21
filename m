Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E671A0B08
	for <linux-xfs@vger.kernel.org>; Sat, 21 Dec 2024 08:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734771203; cv=none; b=Y5Je3CWymGqrFyDljdHtdSgTNPJI8I32TDwgI0WJsMMrO8cbVQwbUeHPUd8J8dX75/l98q8dGupXqPgSe+5y6j6Ts9rU4cMXT4BVTL/tQd8QWRRzK2mQwNyvUBhkgBExH6YntiNC5b1dvxCYqLWoNihqAKgF65+Qke/Yz8qCceg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734771203; c=relaxed/simple;
	bh=3rEuzNP6YmPOCo59mB+RlNx9hU2vAGwAbcUTrOY6n2k=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=mMGfW2dVDXIGJr9lBWesdEN7Y32qW39r9hAv49CT/vOot4qs0DaNxP7YJgPJaY0h6A789tb/48rhlCERIgv27bQ5LXt3DlbZNmbRb/VpOGFZsE1TQGoDsqwiXmW8lxKStn4YAZdWhZGyTs91cFAm6J9YBcqwieMavGu9jIRu7/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3a9d4ea9e0cso26258905ab.0
        for <linux-xfs@vger.kernel.org>; Sat, 21 Dec 2024 00:53:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734771201; x=1735376001;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u3Y13LdZmDM99CG6x5j/GoCUHORd5/wIung/neSYrBU=;
        b=tYYcXDMmj8pTacwG7jyRuaGyGmr0zAxOPEeXkL4dxC9/I8tu/bfOWFBgkvuLPmDuNn
         xhVMlSlHwOhmeJfeylYDcawM0S6IlzEQ6zG3Q2vYAbnYjifPOW3aJokPvPHnjvyeIBOK
         DWLFUUOEImHwflFhArOuEs+dKtwUMP6cM6YlJ8INbZdbNZWX8rD8oNIK9Jko9Fj88Cur
         48iTbYePbBOUR82VwA782jS+pyubxGTqgwxokYQNmMUt+WT4NyBZJu3Sm/f6wdzfV2G7
         hwfpZleilNOq/M5N3/eX+UlTZqi7P52FDypM8t01epXbSi8YeNUUgmubqysf7PFUc9Sy
         p+YQ==
X-Forwarded-Encrypted: i=1; AJvYcCUgjP3pmCl7EwI72wv0a15bR2e7cfK982uCgyr0ZYhOygxF3Zu+LDhr+Sy6iTQzd7bczuz7GS4nHdI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzuIFooEhAxrXoyiEH2pnSpCrAXP7mOFyXuFLKOq3bnkte9nTwz
	1tH9jaihFjXKPCI7TssPOSLNDnzM8hilIO/6kTtztXW4QAFyUenBYGGpzlJJv+DOEQp7415n8Gp
	UbX1/lSvXWefZ2XOVu3MOQAO5CYUrXI2RhGmHDo3HcYXshRo4s6chpNE=
X-Google-Smtp-Source: AGHT+IGIGuCUwjPx8x6tATSL4m9bxGaV3v2Lj2s2wZ4O7MjSE/S9YvHqMP/jyqjJAQsmuHSRdc8YXRGxl5Yc06gVAS8WJhPK4utZ
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a47:b0:3a7:e732:472e with SMTP id
 e9e14a558f8ab-3c2d1aa2beemr56112665ab.4.1734771200958; Sat, 21 Dec 2024
 00:53:20 -0800 (PST)
Date: Sat, 21 Dec 2024 00:53:20 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67668200.050a0220.226966.000b.GAE@google.com>
Subject: [syzbot] Monthly xfs report (Dec 2024)
From: syzbot <syzbot+listb6915fcacc72c717485c@syzkaller.appspotmail.com>
To: chandan.babu@oracle.com, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello xfs maintainers/developers,

This is a 31-day syzbot report for the xfs subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/xfs

During the period, 5 new issues were detected and 0 were fixed.
In total, 16 issues are still open and 25 have already been fixed.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 861     Yes   KASAN: stack-out-of-bounds Read in xfs_buf_lock
                  https://syzkaller.appspot.com/bug?extid=0bc698a422b5e4ac988c
<2> 147     Yes   KASAN: slab-use-after-free Read in xfs_inode_item_push
                  https://syzkaller.appspot.com/bug?extid=1a28995e12fd13faa44e
<3> 90      Yes   INFO: task hung in xfs_buf_item_unpin (2)
                  https://syzkaller.appspot.com/bug?extid=837bcd54843dd6262f2f
<4> 12      Yes   INFO: task hung in xfs_ail_push_all_sync (3)
                  https://syzkaller.appspot.com/bug?extid=92fbc8b664c9bbc40bf6
<5> 11      No    possible deadlock in xfs_qm_dqrele
                  https://syzkaller.appspot.com/bug?extid=da63448ae44acf902d11
<6> 7       No    possible deadlock in xfs_dquot_disk_alloc
                  https://syzkaller.appspot.com/bug?extid=0f440b139d96ada5b0fd
<7> 5       No    BUG: unable to handle kernel paging request in xfs_destroy_mount_workqueues
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
