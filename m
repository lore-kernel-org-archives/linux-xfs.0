Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF69826FA6C
	for <linux-xfs@vger.kernel.org>; Tue,  8 Apr 2025 12:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116568; cv=none; b=RkphO7Pb6jyeNOXW7D05tW22R17dFTHRW7bdy/s9o7I1CpsibLcIGnknP/Heozk8PYsJMviLBNx1dw1nqmiPFLShfuM4U3je2FzZN2dAjgOH+fqFw4S7K58P2nPN+2ikSkZwptPYA6AMo6ZWraB3PgzFuQFzEb+yLHTcmLUmOUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116568; c=relaxed/simple;
	bh=pch9NfcEaAb6kTEmouM9XSRHR+9NzIggCml4uNOfBHE=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=aC/zmwVXFUawMpq/Buwolqtfe77++/VHZKTNrSUaUkAAmBkW5FCWSZL6IetQhPK9xtmXTh5DlAlRIYSpPP+3sGsB8llCLC6aCguOZQWY8tbW0Boi8yVRb/xR3V0MTyt4HJf9u8GcCcFSr9QY6KzDmPxSy9GT4IrUXBgXB1qUPwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3ce8dadfb67so66871055ab.1
        for <linux-xfs@vger.kernel.org>; Tue, 08 Apr 2025 05:49:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744116566; x=1744721366;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cNJL6LfHAiP3KJWb2wuOAHiaVr60J8JSQGmdiSuj5a4=;
        b=I41rz/rE8PNyMcOOZzq/g0LEQataSrE9SNlNz69XGgO9iJbsFsALAc8erhoiFMyjrE
         7EvFritvQAZJGPQtjtrHhE3CbfiVBMP/6c2AmeL6JHKQqslz4hDLao/3MhXwMPzyszkE
         zraismb/YWfY+GW88xl78qLrzDGCPPGimIdtcHUUfESOkSmWw8N1qZuOVU5ctEDLfLZY
         V/jBfFKAPEHpDOOa01/GQTlgl5GUm3n2wbWiNtpRifAHRdYxVc67U8agMKOdbEpJXQp5
         eWkKaGeM9TLrrIkgeLirJS2lJfkbVwKrRBY+alzMBeL6T8CweNWqztbo0c/1a/5hHYQA
         xzyw==
X-Forwarded-Encrypted: i=1; AJvYcCVVvB68MeKAPPT4tHBkccdIN6VyQyMRqWYIWnT0hag7NFSwn+nn4JD+j98y7dyZUsDi7iPXE7VaYeE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBPny0zB81cAosWM13AzpH9haU37Dq2tSd1PegTLj5qAnoLmZY
	oH+gC89SMBpYM0KqwWDeEIws2NOhCj2aBT84EsnW9TkFp35P7psi+62LsfoxWFwJATJ7P5AlnyJ
	B3ECiMJRB7XXyBBlmjVT7GRee7MmOjuOlEFQY2BvKII6ZKZ3eb9x/2Zk=
X-Google-Smtp-Source: AGHT+IEZHlhzQBj6HYESAaj7kpxM6PvfAq3EzWLH4KdtxIcaedQ92eIKUn9dcb9RdezdB3Aj5hKX971JeSI3WiwktVhjHzcLKxVS
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2785:b0:3d3:d965:62c4 with SMTP id
 e9e14a558f8ab-3d6e5329212mr153676435ab.10.1744116565947; Tue, 08 Apr 2025
 05:49:25 -0700 (PDT)
Date: Tue, 08 Apr 2025 05:49:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67f51b55.050a0220.107db6.05a9.GAE@google.com>
Subject: [syzbot] [xfs?] WARNING: Reset corrupted AGFL on AG NUM. NUM blocks
 leaked. Please unmount and run xfs_repair. (2)
From: syzbot <syzbot+e0e774741360f6c74414@syzkaller.appspotmail.com>
To: allison.henderson@oracle.com, amir73il@gmail.com, cem@kernel.org, 
	darrick.wong@oracle.com, dchinner@redhat.com, hch@lst.de, 
	hsiangkao@redhat.com, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    e48e99b6edf4 Merge tag 'pull-fixes' of git://git.kernel.or..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=12b18be4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=695196aa2bd08d99
dashboard link: https://syzkaller.appspot.com/bug?extid=e0e774741360f6c74414
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11aea7cf980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1727c94c580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/bacf2069a3a3/disk-e48e99b6.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/6b2b20d05f13/vmlinux-e48e99b6.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a5ab8f6aba17/bzImage-e48e99b6.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/635c0241b9a9/mount_0.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=1327c94c580000)

The issue was bisected to:

commit 29887a22713192509cfc6068ea3b200cdb8856da
Author: Darrick J. Wong <darrick.wong@oracle.com>
Date:   Mon Aug 17 17:00:01 2020 +0000

    xfs: enable big timestamps

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16ceafb0580000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=15ceafb0580000
console output: https://syzkaller.appspot.com/x/log.txt?x=11ceafb0580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e0e774741360f6c74414@syzkaller.appspotmail.com
Fixes: 29887a227131 ("xfs: enable big timestamps")

XFS (loop0): Mounting V5 Filesystem d7dc424e-7990-42cb-9f91-9cb7200a101d
XFS (loop0): Ending clean mount
XFS (loop0): WARNING: Reset corrupted AGFL on AG 0. 1 blocks leaked. Please unmount and run xfs_repair.
XFS (loop0): Unmounting Filesystem d7dc424e-7990-42cb-9f91-9cb7200a101d


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
