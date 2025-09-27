Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F512367D7
	for <linux-xfs@vger.kernel.org>; Sat, 27 Sep 2025 20:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759005814; cv=none; b=PLKLKsKp4YV8RruzPO5wgmeGh/cRqEl+IkAHBqMkH6VJaX3ims27sjBNaXCc7shcT45jkwtgmppluZZzCmjGqiZU8/e/Bl5K+Nrjv21dHPRtJp2pu3AsIh2pCLfvB3PpaWsjaBCEXbibyfKggOlI22iXRn566oHwPV5WINLWf7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759005814; c=relaxed/simple;
	bh=dOpy1uFMogH9oUpga4sGkLtnXPycy0bQ8U8zm4cYFsY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=st/XhbJ2HE5AhW0q/iwCCqX0+E81O8dyehQi7gCnc2eJ9rbYeXAuJpcQ5MHzC+9gOzmYSkbZlNF3Gdh6RstfQRcI3TfeWjmRQIpD5ZVwGrkW/feU4Ejg7lBfq9b4WyvZKrM0sOD36kZtRY2KUzJo0la+IyiH1AM5KXF724KcugE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-427811cad57so49575025ab.1
        for <linux-xfs@vger.kernel.org>; Sat, 27 Sep 2025 13:43:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759005812; x=1759610612;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QlAW+0wrGfNlAnLDwb/Td7PyZFz7EaBiXfsOSWBu5UM=;
        b=lvHoIREbqGm54GuvWed2Sz37jE6j3OaZRRtVsyUAYdewspCScaS7YjsKZT5Ppm/D65
         QPcnV7t/PJg5OM9bL2Ml0MW3dqOtrAsf5+4OHv7tAW/6MdIZKqk05GlCNkIdHtAeE1no
         tx7Q7ymS33ycxr8oRwn0AlKpXv7avoVhl7eAjCAU6I1MfHAEALah6R9oUyHumCZAE0fF
         zSdPUV1KUP40R37K4wllugyVNHaOTIJUjGPXZ3Q0F/0QmXgoaxu+y7pk2XCFKy3/txJ5
         CLPZ0clhJz323YIIOXsYrfS2nDKyVVb8cNzBvTvQR33aS5XItIDZbTpBIpEPZ7pcHOud
         Vx5w==
X-Forwarded-Encrypted: i=1; AJvYcCXqHY/MIAk6DwfuSDaZQmIBHESv1QXWdPsgl/sqMZXhlUtzB4K7Ap93lcrDhd3vHa8QbHSQ35htObo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyeW3rnryfdiinzemFsx3Iqn+ljJIJe2auqv8yO+BkhyUF2O1BP
	0pqGLmhVsEhNlswhxhbho+VuxWqT9+gmJe/2I8Ib6MELxh20PizmtF0HIxvJXrYQ/+sDx/nRaCt
	+esBNez6MwxzjKDimy5LLNNl6YwW7q4i/xNUZdvAcsBYgdJqMO7TG0P6fyd4=
X-Google-Smtp-Source: AGHT+IE8+QEvDWEplb9mrqkOLIWlOZvmtg04ERRzNd5VCbE6l6R0DxWfVByHrj+3tU8cyg/NHN+Qw0vHAeA4lLZ5QvTGhD6Jmk79
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:482:b0:425:79b4:9ef6 with SMTP id
 e9e14a558f8ab-4259564482amr131687875ab.27.1759005812428; Sat, 27 Sep 2025
 13:43:32 -0700 (PDT)
Date: Sat, 27 Sep 2025 13:43:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68d84c74.a00a0220.102ee.001e.GAE@google.com>
Subject: [syzbot] Monthly xfs report (Sep 2025)
From: syzbot <syzbot+list07b27ac0a85d2c843468@syzkaller.appspotmail.com>
To: cem@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello xfs maintainers/developers,

This is a 31-day syzbot report for the xfs subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/xfs

During the period, 0 new issues were detected and 0 were fixed.
In total, 16 issues are still open and 27 have already been fixed.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 2750    Yes   INFO: task hung in sync_inodes_sb (5)
                  https://syzkaller.appspot.com/bug?extid=30476ec1b6dc84471133
<2> 232     Yes   KASAN: slab-use-after-free Read in xfs_inode_item_push
                  https://syzkaller.appspot.com/bug?extid=1a28995e12fd13faa44e
<3> 105     Yes   INFO: task hung in xfs_buf_item_unpin (2)
                  https://syzkaller.appspot.com/bug?extid=837bcd54843dd6262f2f
<4> 40      Yes   INFO: task hung in vfs_setxattr (7)
                  https://syzkaller.appspot.com/bug?extid=3d0a18cd22695979a7c6
<5> 13      Yes   INFO: task hung in xfs_ail_push_all_sync (3)
                  https://syzkaller.appspot.com/bug?extid=92fbc8b664c9bbc40bf6
<6> 13      Yes   KASAN: slab-out-of-bounds Read in xlog_cksum
                  https://syzkaller.appspot.com/bug?extid=9f6d080dece587cfdd4c
<7> 11      Yes   KASAN: slab-use-after-free Read in xfs_buf_rele (4)
                  https://syzkaller.appspot.com/bug?extid=0391d34e801643e2809b
<8> 1       Yes   INFO: task hung in xfs_file_fsync
                  https://syzkaller.appspot.com/bug?extid=9bc8c0586b39708784d9

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
