Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F182E54A3
	for <linux-xfs@vger.kernel.org>; Wed, 29 Oct 2025 09:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761731426; cv=none; b=qRve/BF/aSNgNj/pMi/A2HqS2rr5v0d5BbmHbOgvL8HXNXMT0lOBMdjg5X9n0rguV4KgMj2rB0AHH0tJXf98R3QfhMWeaAxB/O3WniQK7IH8LR2CmDQLJq1Q8wYRUwGh3EHTubZVvpSAbqyzHBwcdeie71DnS2cfHVc/T6K4ZCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761731426; c=relaxed/simple;
	bh=BMvFhu2JQpaF4T3E9tc1blugVNdOnldVDb7ENcjLjqI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Gm29f6kfSnl85J8febPjZ281Nm5yCIv3sV9OmGbXY6VhnoEd4rE9wdNuQh2NVge1j3GkDBCDnPA+QB83ZHP0ecd2MlbfraK7Aa6gYgNIVvUgOATm7YUh8In8FqVhH/nM3VV5LftexY9Dgz3fZoZ/aycILly+C2riqEnAfgvc30Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-430d83d262fso280905815ab.2
        for <linux-xfs@vger.kernel.org>; Wed, 29 Oct 2025 02:50:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761731424; x=1762336224;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zRFPHqBvWqE41m7o5rfMlavGfndw1tlWRpHHn/CNEBo=;
        b=JvaR0aR3ikSSbgOtR5Ibo4B4FWdWLM7w20K3ZuK8ROC5g3nuOJCAfdKrRqMG91BiGa
         V6tKI0bz7AiLkXQuzTV2MWqpqusOfGt18zAI6WAUBhkxJYbiaKIxf1/KpWBi6KI2Cam4
         mZ45PJvnQlcJn1h/PIQuFQJprZrws11ua7EOG89I8rGzfwdttsrRMFJ+r1OLZu40g3SS
         0nifPsCbkT9XLBsC24BL9peDAhsu0CBmO6WAUngqDFheDzpvMeknjOedSMLyZ7HGnzLZ
         BvPBZfdcyq+k9nxCqGo+sJi80cuTjftaLVg8KOyK68tUfLrkYAX1fsKJeQeHHW8qAxi+
         Y/Kg==
X-Forwarded-Encrypted: i=1; AJvYcCXLaFay6xnqsqYXEEGzHffTyELeq1Up0QvVU+duKUvbiiSGLvWTMNJhG5H8fxVhdWuYD6hZWEjsD7c=@vger.kernel.org
X-Gm-Message-State: AOJu0YyWZwlaMoC7t7jd37OyFjAMRp/Hpd9/4ylza2SnU+fpE4LWbAMf
	SOpjzsmb+7ODGDs5zs3PBazBKBITs4x1uLPoCF85Dw7/Kt3v7Z9EHirvFKbaaUJXfQCX4ZWPJKX
	MnOsFDwqpA9rre9+li12LjJF34YVwxf/uFNBfa8/S8G5YMjBYiZJY2JvAjpQ=
X-Google-Smtp-Source: AGHT+IHzKNuLQKknWwbqJmjw7SumWQ7v695K1Sy9XomlF/7maRIeOSfPAicmFWK1kqWHpy8bD71ucg6XtZulYHJM1NQS07uPNA8i
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2183:b0:431:d721:266d with SMTP id
 e9e14a558f8ab-432f9090ee3mr27884615ab.31.1761731424434; Wed, 29 Oct 2025
 02:50:24 -0700 (PDT)
Date: Wed, 29 Oct 2025 02:50:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6901e360.050a0220.32483.0208.GAE@google.com>
Subject: [syzbot] Monthly xfs report (Oct 2025)
From: syzbot <syzbot+list2a4b52d8d4fbe066ed08@syzkaller.appspotmail.com>
To: cem@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello xfs maintainers/developers,

This is a 31-day syzbot report for the xfs subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/xfs

During the period, 1 new issues were detected and 0 were fixed.
In total, 16 issues are still open and 27 have already been fixed.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 2779    Yes   INFO: task hung in sync_inodes_sb (5)
                  https://syzkaller.appspot.com/bug?extid=30476ec1b6dc84471133
<2> 254     Yes   KASAN: slab-use-after-free Read in xfs_inode_item_push
                  https://syzkaller.appspot.com/bug?extid=1a28995e12fd13faa44e
<3> 108     Yes   INFO: task hung in xfs_buf_item_unpin (2)
                  https://syzkaller.appspot.com/bug?extid=837bcd54843dd6262f2f
<4> 53      Yes   INFO: task hung in vfs_setxattr (7)
                  https://syzkaller.appspot.com/bug?extid=3d0a18cd22695979a7c6
<5> 17      Yes   KASAN: slab-use-after-free Read in xfs_buf_rele (4)
                  https://syzkaller.appspot.com/bug?extid=0391d34e801643e2809b
<6> 13      Yes   KASAN: slab-out-of-bounds Read in xlog_cksum
                  https://syzkaller.appspot.com/bug?extid=9f6d080dece587cfdd4c
<7> 8       Yes   INFO: task hung in xfs_buf_get_map
                  https://syzkaller.appspot.com/bug?extid=d74d844bdcee0902b28a
<8> 3       Yes   INFO: task hung in xlog_force_lsn (2)
                  https://syzkaller.appspot.com/bug?extid=c27dee924f3271489c82
<9> 1       Yes   INFO: task hung in xfs_file_fsync
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
