Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D65AE214801
	for <linux-xfs@vger.kernel.org>; Thu, 20 Feb 2025 19:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740078206; cv=none; b=si7f6bQ4x2L8PVyWqhzj9t6BzjsxwkYb2G4F+32cRe/5ISfI1/mu8aU9gITAO9YEV7+kMvYqlVaChNTfRnO2zsjU23hVXbh6VqFxU6znujY++iIjZ/usMup561eSVhzPd5pliKDEFygZZimhdplKTH+dkQrLL8lH6ssjerSQKkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740078206; c=relaxed/simple;
	bh=d3l8CS1D4AR7C0awY6wO7jlChCwpNEUfxkadXODt4/0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=E+ds7ddrlfoUtXu4bFtsE/sPbHsRfOzF3qWkMCxWVNeYolhHAm3dyr+rsZxrP6j6sCruxCwwZZ7IawMn6db9BNfbkvdJwdD27inKtOTi/co/rteGNrKGGv7NS3fc0Ui5wDTtOvK0jfay2I0Z4kSIGeAunqJYjqh4KoKoyExLytM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3d2a60faa44so23599635ab.0
        for <linux-xfs@vger.kernel.org>; Thu, 20 Feb 2025 11:03:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740078204; x=1740683004;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=asha2d+gaWgF7tXpH4ijjuoW/rkiwLBPdgYVataGXuc=;
        b=PMx5mDAe2N6SAEJC23hrXIlgGqMSoWg2fN0k0sAnV38c8E1YndkxtT6D4YUmPDFHy9
         hT57yPNvO2+ZMq0Ss60he7isoZhFzPpTKxVlZcXdtlm4hzSmUAIWGGE199zbQGsvMq/Z
         +UnZxakud7oIEz7v59y/pMuEbejhHcdPH+RSgUjosH4hl8pDooqzXkEDxw0pc2StgfYK
         AYUlHKt2MOfZPred/zfubEMQY/eweYSFpuCkKnYwxBrMY4WkKb1oGitlmEC8Hcx+Fxos
         R4mvJ9UoxR4PeI1Bt6XN3z8IFVNpuTfKP6xWrrE02wMG0X/FHfkDY9SDjFt0IArOD0UH
         VjzA==
X-Forwarded-Encrypted: i=1; AJvYcCUAw7bQVib4XA+lY/YCmZfrhmZloB5UsuTlpoQAHCV3GWjiX4qjdHaFw7Mq0cALPDmU8JH5BFXiBj4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxEHHgk+MKptmGWYSQFjY6yAzhw00oSwCwIuMwsgwSkhQzbr2je
	RxDZ4pz6jIYj7wuoXrdpBxdaP6j7lg22CnEwLWlX1He7+v5ZeJrEU6coI9WGyvM7zrWvmcBKi7V
	sCZk2mpkCwP3Qra0X/C9JHR+TKKUTJXzhXbemDblIHyBNqL6RzNUY5UY=
X-Google-Smtp-Source: AGHT+IG5NIfus11FtMwEICWdt6qwkZVAAbwAfbNMEzWrbpTfafx7LHufOVPGuIKDnYXQaTjWBBlBMbXHuh9AeHh51RZexJNBHEH3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a67:b0:3d0:3851:c3cc with SMTP id
 e9e14a558f8ab-3d2caf19e17mr2079135ab.16.1740078203833; Thu, 20 Feb 2025
 11:03:23 -0800 (PST)
Date: Thu, 20 Feb 2025 11:03:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67b77c7b.050a0220.14d86d.02f7.GAE@google.com>
Subject: [syzbot] Monthly xfs report (Feb 2025)
From: syzbot <syzbot+list8dc11289063655991065@syzkaller.appspotmail.com>
To: chandan.babu@oracle.com, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello xfs maintainers/developers,

This is a 31-day syzbot report for the xfs subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/xfs

During the period, 1 new issues were detected and 0 were fixed.
In total, 20 issues are still open and 26 have already been fixed.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 160     Yes   possible deadlock in xfs_can_free_eofblocks (2)
                  https://syzkaller.appspot.com/bug?extid=53d541c7b07d55a392ca
<2> 125     Yes   BUG: Bad page state in iomap_write_begin
                  https://syzkaller.appspot.com/bug?extid=c317c107c68f8bc257d9
<3> 94      Yes   INFO: task hung in xfs_buf_item_unpin (2)
                  https://syzkaller.appspot.com/bug?extid=837bcd54843dd6262f2f
<4> 20      No    possible deadlock in xfs_fs_dirty_inode (2)
                  https://syzkaller.appspot.com/bug?extid=1116a7b7b96b9c426a1a
<5> 15      Yes   possible deadlock in xfs_buf_find_insert
                  https://syzkaller.appspot.com/bug?extid=acb56162aef712929d3f
<6> 9       No    BUG: unable to handle kernel paging request in xfs_destroy_mount_workqueues
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
