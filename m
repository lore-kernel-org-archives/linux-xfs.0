Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62CA41922EE
	for <linux-xfs@vger.kernel.org>; Sun, 23 Mar 2025 22:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742768669; cv=none; b=MKHqo0nAmVsfH4T9jTuah+m2dreN+QyZJfggZ5OuvEdlAkzNSDLKKDFGS060NAyAX34o34drkeafoNBXe7I+QlHcx+gqDwddPAewRo6CxU1wxGWpOJ0i9cLYSlTywpZMBnenvof89yzGkk2N0bRjqIXFBYs65cER159/KbwOcVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742768669; c=relaxed/simple;
	bh=e93NaZcK5YQEteWySfSzqPEL6aqg0cgUQnOjoxtN6Tw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=gHZHeazpiGY+6hFitbBxVDmcm3JbJWh1s5y3UCvcfMaMJSzWyuhCn4e8+nqwTnoEEi76KlVmeoLbE/mKz6GGv8GBvKbOGUWDQInMMCV150Xmsteb4JNH33ChxG4RaWSpsiCjncHRWBsZFM/jURVTQQL6d2oSeEZi1drNjUfn3hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3ce3bbb2b9dso41595495ab.3
        for <linux-xfs@vger.kernel.org>; Sun, 23 Mar 2025 15:24:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742768666; x=1743373466;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=T5KlCy6Q8RD8sDEwc7MlxQAo++rAefTBGZtRiPfhOzo=;
        b=qE2ma20JA4BeLsrpj4aNPm74bFZIg9uolPTXzQobt1iz/zXKeWB7sDM8vP2EljAWqO
         qfk9RBnr0Ja20jL5GiSIlim+Buc63ZRUs4EWajk9YiokvX81G7kc5PN9r7grhruR/OA0
         kXgnbZWTIKEuqHjAbNUn+T0kTMjnFPkMAmqRKI7xvk5LVsNLxeYckO/b5toJZg8wuFSw
         rHDeP3QkH66zSp4KRz0CSkaJbK94CglkJlxF+w6iYuKczecrHzX+Q5uMHp76wPm8MEVz
         oRDXjrLC0uuNo7KOw9eecIz6+grrFiumoKWPiW77UD0uZj1AjSLCipWzP2cB/EaAbXTj
         hkbw==
X-Forwarded-Encrypted: i=1; AJvYcCWzsrnjh9JOIt2W/IzigFIj+RiB7S18MfTSY4jl7mnMP2CFX7P+nRwJwETX5ItXOW74zuuN4abfWIQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxdLU8EbavcXtoCoOGC5bBGGGONcNSKfY1vTyFlJUvMu794U0v7
	KcW8VfD3nCsncc1cjBn5FaNUGlhhfvDdYaNma5XDltGqSCQlNWwp0BHHQfBJiumpuulywXFLs8Y
	suzn1dFKTRg9sH6fQTmLHhtCR/ddj/ucmFa6vPEst+5Be5ZGyOOD5Lgc=
X-Google-Smtp-Source: AGHT+IEHtrbk1CRW9UDW9T6uDfYShMOVxVnjtCancFyNNOByM9MTHzx2i0riRFA6Exwj9Dt0JvxVFYE0YbuqxYcDSlGSxv63DWGJ
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:152e:b0:3d0:4e2b:9bbb with SMTP id
 e9e14a558f8ab-3d59617bef5mr121532135ab.21.1742768666679; Sun, 23 Mar 2025
 15:24:26 -0700 (PDT)
Date: Sun, 23 Mar 2025 15:24:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67e08a1a.050a0220.a7ebc.0005.GAE@google.com>
Subject: [syzbot] Monthly xfs report (Mar 2025)
From: syzbot <syzbot+list5cd62fbbe518216907d5@syzkaller.appspotmail.com>
To: cem@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello xfs maintainers/developers,

This is a 31-day syzbot report for the xfs subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/xfs

During the period, 1 new issues were detected and 1 were fixed.
In total, 21 issues are still open and 27 have already been fixed.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 184     Yes   KASAN: slab-use-after-free Read in xfs_inode_item_push
                  https://syzkaller.appspot.com/bug?extid=1a28995e12fd13faa44e
<2> 156     Yes   BUG: Bad page state in iomap_write_begin
                  https://syzkaller.appspot.com/bug?extid=c317c107c68f8bc257d9
<3> 94      Yes   INFO: task hung in xfs_buf_item_unpin (2)
                  https://syzkaller.appspot.com/bug?extid=837bcd54843dd6262f2f
<4> 21      No    possible deadlock in xfs_fs_dirty_inode (2)
                  https://syzkaller.appspot.com/bug?extid=1116a7b7b96b9c426a1a
<5> 15      No    possible deadlock in xfs_qm_dqrele
                  https://syzkaller.appspot.com/bug?extid=da63448ae44acf902d11
<6> 13      No    BUG: unable to handle kernel paging request in xfs_destroy_mount_workqueues
                  https://syzkaller.appspot.com/bug?extid=63340199267472536cf4
<7> 10      Yes   WARNING in __folio_rmap_sanity_checks (2)
                  https://syzkaller.appspot.com/bug?extid=c0673e1f1f054fac28c2
<8> 4       Yes   WARNING in xfs_bmapi_convert_delalloc (2)
                  https://syzkaller.appspot.com/bug?extid=1fcaeac63a6a5f2cc94d

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
