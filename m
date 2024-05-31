Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCDF980600
	for <linux-xfs@vger.kernel.org>; Fri, 31 May 2024 06:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717138114; cv=none; b=fR6PIli6fvVCnytVZ9B1GYoagKBuz96p0ejwfwQz5oz6NIWNUa1ipJMwdQ1Zxbsnq2pAEW8WwYBg41TAGSgDgXA6TNo1ILp3bIqV3EVOl7s5iidp3OLboQRmiq8h/zJ5AVesrhPvHAGw4veeJmdsKT3cN0uq6L0xYkp/Sr15qAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717138114; c=relaxed/simple;
	bh=JQjo0eMRUrtDRYAzFt/rgP2lLlrIbIHkpCinR2YfJYs=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=QfaB7TXFL2BF/BaPQV/JdLbOsesc//CoWkx6FmP47GqOsbXU++WcYyZouH0Hx2gTe9QhFBxt4B9BdEV0RLWQ1vI6zvnF47cnvdv7iG5+L+4f1Pvb4Okl/lSLtnd6cqxy0X9HkJlFc1FQiqve9jN/0GhUDrv70UE05t3mvwfJjfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3738db5b07dso15373485ab.1
        for <linux-xfs@vger.kernel.org>; Thu, 30 May 2024 23:48:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717138112; x=1717742912;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TixudRcneHSDOjcZa3mtszer4Ues1F+sIN8Vl/IV5T8=;
        b=lx2Q4wolFjhYdbs1468zkWBds6oCRJ4ZbLXMpAYLAaERm+iVhZPfQ9ANymHAAeCe7M
         5VhxmKtjYGztE087HrHbzc3DBgNvwDLbSGsphx2JUIW1Ag/t3O8XsyIAn7oSrV+gxV1m
         8SvqHbM2NYk0aYGL7VfXvThZeB2u7B3uhgpqq5rSqAowkW6I8FIc7PqLhn6+dVWOHMOn
         gpJHeEpmKINs00m3gUiN0Tvdb1CPb4OeEfy3jW9cZosJKLUq/SqBfvYBeSc8ghcirf2W
         Iy2fF5XAteZm3C19EnZq/oZHSjINjdeTlAapm1QfZb25j2iKv6QvY9IvauWksij93i/a
         KdVw==
X-Forwarded-Encrypted: i=1; AJvYcCWC6q4VOFK1fSsgST2gKjOEJ9hfp5DJa31YQsINAECXpryT/ixmZ2+f6BZRTUXT9O0m0x8ccB8nKI2Id77juqDVxQb5O7MGY/kS
X-Gm-Message-State: AOJu0Yy+MJHsWObKfpCxot7RXH1BHxgaajxNqEi/S8HMDmbEl3IN0ibE
	DAsV8nrKrJkQk4RXfzYCqJWYhPyMX/qkJ1kTpvwaWwJzorWUfGzmq77XSGEPFm6jqSkvGKr1bea
	duqZHVwHGHwoMABbzs+PEUWQ+gFSFYH8F+kh1OZDrHVa1QUQawU6Bwrw=
X-Google-Smtp-Source: AGHT+IElYXT7baMvmzvScRp1iy9Kxn/fzrJ4ops/teIm3XW07S63iEhsT38ziMPA3suWqkG4wC260k5VuE5Fa4YkyDwghe+m1miW
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:16ca:b0:36b:2731:4084 with SMTP id
 e9e14a558f8ab-3748b97bafcmr661295ab.2.1717138112035; Thu, 30 May 2024
 23:48:32 -0700 (PDT)
Date: Thu, 30 May 2024 23:48:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000032c4940619ba5fa1@google.com>
Subject: [syzbot] Monthly xfs report (May 2024)
From: syzbot <syzbot+list7ecb28f76477d00e16c9@syzkaller.appspotmail.com>
To: chandan.babu@oracle.com, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello xfs maintainers/developers,

This is a 31-day syzbot report for the xfs subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/xfs

During the period, 7 new issues were detected and 0 were fixed.
In total, 14 issues are still open and 22 have been fixed so far.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 790     No    possible deadlock in xfs_ilock (2)
                  https://syzkaller.appspot.com/bug?extid=c6d7bff58a2218f14632
<2> 696     Yes   KASAN: stack-out-of-bounds Read in xfs_buf_lock
                  https://syzkaller.appspot.com/bug?extid=0bc698a422b5e4ac988c
<3> 59      No    possible deadlock in xfs_icwalk_ag (2)
                  https://syzkaller.appspot.com/bug?extid=4248e91deb3db78358a2
<4> 25      No    KASAN: slab-use-after-free Read in xfs_inode_item_push
                  https://syzkaller.appspot.com/bug?extid=1a28995e12fd13faa44e
<5> 24      No    general protection fault in xfs_destroy_mount_workqueues
                  https://syzkaller.appspot.com/bug?extid=8905ded1b49ae88b96a6
<6> 1       No    WARNING in mod_delayed_work_on
                  https://syzkaller.appspot.com/bug?extid=d9c37490b32d66c6bc78
<7> 1       No    possible deadlock in xfs_ilock_attr_map_shared
                  https://syzkaller.appspot.com/bug?extid=069cc167ecbee6e3e91a

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
