Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE05314D6EE
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 05:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725254884; cv=none; b=X80h+aO9rR0tXPZ3kN/VkAAVQh072zdtXuBMHm71BK9Z0HJ9OgbvFZiTS+A/W3m0WKFKb4IbiAv6pDojq6gSQOfGq+cD8+cJJkJYMfTpdazxPeWuTUkDjc5v+LSToX4yimQk4F1jNh8868MEQzilfOgEVbeR3MnhmU3jgE0ks5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725254884; c=relaxed/simple;
	bh=PIWg1kV2O8zg6jx9p3Pbr33e5KlEZhEQxtJASrgjHpk=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=HpDb3fAUUOgoW2QKkx86lnYGB6aE3BZiWomW+sCPAz7A/kITgDjCB1pgrOAI6INAJsUBGsyoSNHn16Z2QQZSwoSHx6YgpTr1Z635bcs1QHojGbHKvjYkvlZuJohtRUfrfA2ezh3g8LHf2RYv8bWqmGnf23a0tiKfm8by/UB55Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-82a21f28d87so385289839f.3
        for <linux-xfs@vger.kernel.org>; Sun, 01 Sep 2024 22:28:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725254882; x=1725859682;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z6/R7U0VqDiPHR7JhVGpk+mBdbkz6KtFGSnvxfDuXFI=;
        b=l5md5JyeiktnFEU2yghSnFZNIeoGITzDctru2Y4cLUwXjRMMC2FAFOQbvbJvq4uUC8
         JJ0l7Gj6+mTkNusDGv6Crct0z1XvPifYAb9/G1NTFPDZBY6dsxuMW3KyUgxMNPrvTYXb
         HvwSDxpnsx0mTl+VG/PlfvgsWG/QluytnA+VxmvXisnWW710dK8CoJMdMrQgmdYbZ4Ye
         lRyiShSGGWyegkZADAxS4Ph7GwxqeFRE0eLu+KfwpIxQNC26c9L0xnHpltAlf/CZnYCh
         erDUKmMpD0mdS5Jb52oJtP+kFrXITucRPKZJHyFdeR/7+72h+HFtsto57E6zvNzU6aoo
         d+vw==
X-Forwarded-Encrypted: i=1; AJvYcCUbLcIT6tI9Wby7vpVgvjNTqT3URDnjTw/TNeRnOrrUbbtvRnD/wq0BzrcTmXYIJQTgexovho60zPw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyg9w6za1iY4EJ7CJA8EJ/GyHNSPfJgSdwnBJVzUIthOXwhzFUd
	WLKOt+FdGGcmnXRNX2V2QYXogEf6rBayLQOIZdgs/DcjuuzW1qlYLHxfi64IhYIUbF3yPZhYBc3
	6hQU/J2017FEQhyqSFi0U2f1XMg0lYY/KLkWW7vDOsLrJNxP2FlwJj1k=
X-Google-Smtp-Source: AGHT+IEGJzdjUqwdJUazymn+LrA+gjDAEdrAgDe9ts5jMjlBpRNDON9BwywuQpAbcrk21B2MMgOldPJZdwVKYwxr8wfyfW8BymTa
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:13c3:b0:4c2:9573:49af with SMTP id
 8926c6da1cb9f-4d017f12e62mr647003173.6.1725254881854; Sun, 01 Sep 2024
 22:28:01 -0700 (PDT)
Date: Sun, 01 Sep 2024 22:28:01 -0700
In-Reply-To: <20240902050455.474396-1-sunjunchao2870@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006156d606211c3444@google.com>
Subject: Re: [syzbot] [iomap?] [xfs?] WARNING in iomap_write_begin
From: syzbot <syzbot+296b1c84b9cbf306e5a0@syzkaller.appspotmail.com>
To: brauner@kernel.org, chandan.babu@oracle.com, djwong@kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, sunjunchao2870@gmail.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+296b1c84b9cbf306e5a0@syzkaller.appspotmail.com
Tested-by: syzbot+296b1c84b9cbf306e5a0@syzkaller.appspotmail.com

Tested on:

commit:         ee9a43b7 Merge tag 'net-6.11-rc3' of git://git.kernel...
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=1710c453980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9358cc4a2e37fd30
dashboard link: https://syzkaller.appspot.com/bug?extid=296b1c84b9cbf306e5a0
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=14f2e529980000

Note: testing is done by a robot and is best-effort only.
