Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB0B036495E
	for <linux-xfs@vger.kernel.org>; Wed,  8 Apr 2026 06:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775630674; cv=none; b=YrL/QS4UXrE5pY8y+VgRH75pDSv3q1XJ76Zwa8ohA8PpM7fLml4aTlkN8ATDIDw5+U3jy2ocJR4CV6OM5cvBfUCCT3fMbcqBHB54MTNGGh9Rb305xNMQLSSlQlbM2N9jrJrDZYjoKEFDraeGxAwTfFyBw79X1c4PKImBiz9L8Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775630674; c=relaxed/simple;
	bh=zSGJK9KdJ5EnjD7a9x3B5gtOfmYjKvmMgCWjfvkWWIE=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Z5oaDUoHufIzHnRInsya/fo9C4XFBO0Ofn7u0j7uOtNIH5A6U1YPU9BHKj6DkoxxaT0ZhBgX4a34j3EFa8f6sJiCwbqZvdx3IDd2Wp26OkoMn1yegpIF2SnT0cpQ1GOuvFyPISj8zSIQtbF5pF3vhtCykjiYl1j9Ltsh2NlqbkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-7d7f7164b12so9043815a34.1
        for <linux-xfs@vger.kernel.org>; Tue, 07 Apr 2026 23:44:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775630672; x=1776235472;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=U42pTkDjswciJ6WWR6EgGjRDC6oR3tbZTeo/X3sh1w0=;
        b=lmp8y5mq8Frzi83B70T+IgzKMDgQNKbCXSjv0dBJHRb7pTvWF3+EGY0BPNeTtT2Ti5
         8papaUpiw+2jk1xi2mOIHoOYL4pGu2Fn/Idaq5iqAQrwpxoNS4DgRvZOK+4ZI5xrbSE5
         rXHFWbn4aJ6EuEJujQxWVLlWrpLZDC2lPsYYd+EIStth/zsoPeRo0HHcmQR0vCkGJqd0
         LVLyg1FywYgH2ZiyX+R+euUzSu3EZ0kYVsfX0H/8VQsQ4kP6/xuFOIIq9ayYrLTxnmU6
         X2uDUcRVklZaNAZXQ7JGLae1NZq81ObOvzLpnBRH5U9+cCzH8MokkKTtz05fpX6WzN8g
         iixQ==
X-Forwarded-Encrypted: i=1; AJvYcCUte3IqkNBROr5wUvL92TohEDaq8ZOqy5atmOgYYk5BaR7RA9DBL0Nnj9DXr9ddfWGdtpjoSkk2rF8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxpDIu/ra1tGG0hqQNv6+S+jKUw9vaCoML2JfdUYj5su7grqZ+U
	c6F5mVLNaJ7VPAnUVQKj7JpTNYamRG7vNk7sD5C8xvxef3GRZnVmf91d6CE12kdRAzTnS+zpu5H
	erswEqtssz4evmuB8C8gK0387gFt6jFQhYP4zVggbf9kmkX59ueQyQ069HtU=
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:3087:b0:67e:21c9:ab55 with SMTP id
 006d021491bc7-6821e8699famr12374687eaf.3.1775630672065; Tue, 07 Apr 2026
 23:44:32 -0700 (PDT)
Date: Tue, 07 Apr 2026 23:44:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69d5f950.a00a0220.468cb.0008.GAE@google.com>
Subject: [syzbot] Monthly xfs report (Apr 2026)
From: syzbot <syzbot+list533a806dfa7e1e324d69@syzkaller.appspotmail.com>
To: cem@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello xfs maintainers/developers,

This is a 31-day syzbot report for the xfs subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/xfs

During the period, 1 new issues were detected and 0 were fixed.
In total, 19 issues are still open and 28 have already been fixed.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 2945    Yes   INFO: task hung in sync_inodes_sb (5)
                  https://syzkaller.appspot.com/bug?extid=30476ec1b6dc84471133
<2> 856     Yes   possible deadlock in xfs_icwalk_ag (3)
                  https://syzkaller.appspot.com/bug?extid=789028412a4af61a2b61
<3> 515     Yes   inconsistent lock state in igrab
                  https://syzkaller.appspot.com/bug?extid=5eb0d61dfb76ca12670c
<4> 430     Yes   KASAN: slab-use-after-free Read in xfs_inode_item_push
                  https://syzkaller.appspot.com/bug?extid=1a28995e12fd13faa44e
<5> 122     Yes   INFO: task hung in xfs_buf_item_unpin (2)
                  https://syzkaller.appspot.com/bug?extid=837bcd54843dd6262f2f
<6> 62      Yes   INFO: task hung in vfs_setxattr (7)
                  https://syzkaller.appspot.com/bug?extid=3d0a18cd22695979a7c6
<7> 7       Yes   INFO: task hung in xlog_force_lsn (2)
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
