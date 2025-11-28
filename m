Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ACF62C3768
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 21:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764364891; cv=none; b=nYa63bQPy7VkfhiW5m2VC+pnUXRkbrID4/NPpDC+iauhsR51GA71RZQd2w7dMhzNV8pZU70BYdmJH3H4NVn0w4WY2PcG6U5tGAHLub2QPelpQ2PwRqPHfC9xnOr0VLDNZVEeXzhGbaHdCsROs6V2wmGJpOjDfLxX/6IPXU11SqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764364891; c=relaxed/simple;
	bh=JdPAfRhCkRGoUrKZFjggyYEAy5pa9TzVopbXs6wdDz0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Cd+a1hrfGvpf03liuhuNRJyeg9qw5r7iw98e//Ny5J9OFiW+wSjtn31uBWdHVdv3wqpnKrtklQ9MMUZHqj0mMkRtS3eJ4WaQqSq8Gf32bKLoIEj27xu7IDr5IJqnzcuTLJtdNZsz3HBfzNtDM5Xb84imu6DKqQiJm1o2JtmJOVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-435a4ea3e62so19529795ab.1
        for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 13:21:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764364889; x=1764969689;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ujojG6nebwaIjtRMUOhPezmrXW0E4y8xiQAGch7Te7s=;
        b=cRZnXGAGq3JIXUTf4EzVD9uc6O9AXJENYW7R2MjXSrY56M6/SFaKza+SoBswa+ui4m
         721pP4PbuZH9bVxbU5rVD6NQeCVo8RhykaELc0Cg0W1Wr+77t82KLEauLItMH4cdh+rG
         J7UjXUUy3fflpiKvbZWuCHPEN/ZmPomhSTf3f+DBHRr6V5OA4Jd50oIrWfqGbeNmXoDE
         qJbMRIZEep010DDiP/gfn+wzBoE3XQ72Lll7Te8PTbjyDExGrQVLyJOze7hjZpPt/7BR
         x/SU8QuGh/kZ/XwNCX2JCbNvkjLCTn+0ePtPoWMzaEbcmkQOKJSaH2IUadv5N7lXWsea
         piAA==
X-Forwarded-Encrypted: i=1; AJvYcCVqCaa8esDlUL+8PVayS0oObTzu96Auw53R5qxeYN2KmxCgQSitfvmVRdz+LC4+VaGJkfzF5bHgxb4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5keSJDhZAQVIp5b2qupa6VUSrOAXJazlmvtSFm2tmXwbLv2JM
	2GqoENYyCJ531bZZ85B4w2i3Ch1xroZweQwOy8Q8/4uWV63yrvpN7YPNZrf6RA9iTXaVl7niNKW
	BhX/y1bExGiPzKKfDz0L8m+62yQYjdGbpKC3+7IEXD3i+HRSkgal5ghwKTc8=
X-Google-Smtp-Source: AGHT+IFuqc9K1oQ9XheiAq0rEhe30RTlWcVVWeKClfoYDJEuQegNmpaf9H9OwPWb2401/UOhmlG27qi0txTa7SPZgY17wwkBzzt/
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d96:b0:434:74a6:48ff with SMTP id
 e9e14a558f8ab-435dd0716e5mr127635415ab.18.1764364889401; Fri, 28 Nov 2025
 13:21:29 -0800 (PST)
Date: Fri, 28 Nov 2025 13:21:29 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <692a1259.a70a0220.d98e3.014e.GAE@google.com>
Subject: [syzbot] Monthly xfs report (Nov 2025)
From: syzbot <syzbot+list9ca9b72187b209be55b6@syzkaller.appspotmail.com>
To: cem@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello xfs maintainers/developers,

This is a 31-day syzbot report for the xfs subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/xfs

During the period, 0 new issues were detected and 0 were fixed.
In total, 17 issues are still open and 27 have already been fixed.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 2818    Yes   INFO: task hung in sync_inodes_sb (5)
                  https://syzkaller.appspot.com/bug?extid=30476ec1b6dc84471133
<2> 269     Yes   KASAN: slab-use-after-free Read in xfs_inode_item_push
                  https://syzkaller.appspot.com/bug?extid=1a28995e12fd13faa44e
<3> 109     Yes   INFO: task hung in xfs_buf_item_unpin (2)
                  https://syzkaller.appspot.com/bug?extid=837bcd54843dd6262f2f
<4> 57      Yes   INFO: task hung in vfs_setxattr (7)
                  https://syzkaller.appspot.com/bug?extid=3d0a18cd22695979a7c6
<5> 22      Yes   KASAN: slab-use-after-free Read in xfs_buf_rele (4)
                  https://syzkaller.appspot.com/bug?extid=0391d34e801643e2809b
<6> 4       Yes   KASAN: slab-use-after-free Write in xlog_cil_committed
                  https://syzkaller.appspot.com/bug?extid=4e6ee73c0ae4b6e8753f
<7> 3       Yes   INFO: task hung in xlog_force_lsn (2)
                  https://syzkaller.appspot.com/bug?extid=c27dee924f3271489c82

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
