Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA853D3484
	for <linux-xfs@vger.kernel.org>; Wed,  4 Mar 2026 18:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772648672; cv=none; b=bkdh3Qq3zDZIlJ5HcaSjCCjT8OrAJoy3LY5rUn0bB8nZbWpB2vXDWj8vzpTLY0EAg0jNCxS65AS4SDco01hJEUMgsSJb2fg401vGEAOBiMKD/cYA8yVlCVFuLI/Wlo2CsXfJP5UaKKE5eRdkeDS32G9QjhVAGlxXy9TRJcPOgVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772648672; c=relaxed/simple;
	bh=VtgM19PrT8vLK6zBA63HxqeFwpJy2jgB7OhwT2INTHw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=isXKBnXVPCLXXUf+zZHuZl2NP5IjYpYQXwP6CrPFdnNALyRqWzb000TWep23DJS19mQQikD1vj3qWfH16CvRq9xdPZYmzTnJkFwTThyg6UU7/9L/PpSqeWU3MuWkVfnGHGNQO0L57YPOoL1MEZXs7bfIFGslXH0m510KcDKDAj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-6798747187eso111251362eaf.1
        for <linux-xfs@vger.kernel.org>; Wed, 04 Mar 2026 10:24:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772648670; x=1773253470;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=osaiu1+CEKd4sdOVSwyso1K8nlflVflsib8WB8EwwlM=;
        b=twD/zFeVso6NadkEUSB5rdIesmPnz+15sYyuqDswAlySWYZdGD1OFoU619z7ffmlux
         H2OFNaYr0no7m98myfa0f2azAok54QKerBoaWIFi98aKz3R0KE4GkChT723a2oj9ihl+
         vEWdnSys+PGRp1/EtyfWEIPMcOp8YveuC4ac2/FzC1ESU+xUo0uj8PUlxf9HQgmnkBRF
         kmY1UGHjmzGX5kGeX4ONZJ36ek9UaPAZGfkqx7/T/2/93Jq1Ez+ktSacMUcVDMv45aWJ
         hXVcgxcUd4EC9TuAKmTkZfwt6RcgwboKZLpAcD2O91ZcTJ4RcJqN9gS7nQT+Vkd/GUsx
         qknw==
X-Forwarded-Encrypted: i=1; AJvYcCVbq6RPHWEhwmmzAnlS1WwONB/+LfLkq3WD3c203ga2KDO0ZjnoomARZ+Bt6sJDhrWJ6jzO3EzjBgo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6AYSZDWGOmyPq1W+VHF5BVrb/u77OUs7P9lmjwvQB+9ohziAw
	cw8nzXnXHnGiaAsPH4qI7/Hdwj+PHXkLyWyz4McS5kxZZ4TexUx3KAdXJMt30HY8o/sg5z+omvV
	z8yp3Jynr2W+ckyZk4lZpClDOb1waoYqAwn0WrU4Kk3zDHul+wc1n0qEZChU=
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2913:b0:67a:1c77:4bb5 with SMTP id
 006d021491bc7-67b17706629mr1839855eaf.25.1772648669954; Wed, 04 Mar 2026
 10:24:29 -0800 (PST)
Date: Wed, 04 Mar 2026 10:24:29 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69a878dd.a70a0220.135158.0011.GAE@google.com>
Subject: [syzbot] Monthly xfs report (Mar 2026)
From: syzbot <syzbot+list6f294b4cf6287e6480f5@syzkaller.appspotmail.com>
To: cem@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello xfs maintainers/developers,

This is a 31-day syzbot report for the xfs subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/xfs

During the period, 2 new issues were detected and 0 were fixed.
In total, 21 issues are still open and 28 have already been fixed.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 2936    Yes   INFO: task hung in sync_inodes_sb (5)
                  https://syzkaller.appspot.com/bug?extid=30476ec1b6dc84471133
<2> 364     Yes   KASAN: slab-use-after-free Read in xfs_inode_item_push
                  https://syzkaller.appspot.com/bug?extid=1a28995e12fd13faa44e
<3> 117     Yes   INFO: task hung in xfs_buf_item_unpin (2)
                  https://syzkaller.appspot.com/bug?extid=837bcd54843dd6262f2f
<4> 51      Yes   KASAN: slab-use-after-free Read in xfs_buf_rele (4)
                  https://syzkaller.appspot.com/bug?extid=0391d34e801643e2809b
<5> 42      Yes   KASAN: slab-use-after-free Read in fserror_worker
                  https://syzkaller.appspot.com/bug?extid=fbf6ff30de890ff32ec5
<6> 17      Yes   inconsistent lock state in igrab
                  https://syzkaller.appspot.com/bug?extid=5eb0d61dfb76ca12670c
<7> 6       Yes   INFO: task hung in xlog_force_lsn (2)
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
