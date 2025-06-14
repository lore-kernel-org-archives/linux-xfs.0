Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A204817A316
	for <linux-xfs@vger.kernel.org>; Sat, 14 Jun 2025 09:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749894365; cv=none; b=c7OOjASB5ZbL+ZcCBXHh3fC7WSt8rr8B+YuwtKvhYu56BDAQbIsaRF0BT0/gT+TRIZ7Q9/+nI6YZES0dS94jFU8WCDKfZMxguHFW9CMFBar6CBvzrJ21bKlEXINFSRr4OFiCY6KLm3TCWuHlvUWHaR4YClbE/O/4r1EXcJ8vsDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749894365; c=relaxed/simple;
	bh=tb9mgmjJ0ev38mvO7oF2OEZBYaMFTRwRSfPnfq0Gfn4=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=n/UID4+FrwsQvdpTlRXvEgfkw4nsQdq5TsT28QnxiSVZTkMe77spQjiawEdTNTBnp0ZzrrIX40ksRq7a848jBgo3qRV/RmUJbgarGxCC9DCeBVoSZ+HXT+pkIB9/E8xNsfwXSU0vS17BdwBPNY/7dGsw8QGi96INaPMmVCsxWG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3ddccc79b55so20437775ab.0
        for <linux-xfs@vger.kernel.org>; Sat, 14 Jun 2025 02:46:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749894362; x=1750499162;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OOullEj6fbTIFAODytKrgDERNVpRSjN594Q2Nd4pVdg=;
        b=eLPQgSOaj1nYZsUIz9NM6DLZoT6v7rOO3yF8MnNGo1MFLYwlK0b2fj+2tdisMYwgoc
         9NBAxnKDrVfO/vfURpKS7ja/sq2sz1cgmIDPqpcOTAqB8fsAUil+HLvx8f1UyBqxqvLA
         CY998qkUuacwurVTkWNi3euo3Ac2jgtyLXehFFg1ZXvF4GbtLpaUAOrUIMwrh4f71gnI
         rFbB9ld2kWNmSWc+HsFvEJqXjbeN6z4oE04gMNOa3c7AnBThLic8Nyl3jCi6ZDumqFXa
         6vyuN1a9b6pE3Fon+SU/y/ZOimV1X6l3L1TTbznPC6TWNItTr1Z1asTLRC+DfE847X7m
         4CmA==
X-Forwarded-Encrypted: i=1; AJvYcCUChMkivXm7n/00tCd3+vkMJzQECzj/ZEAYxRVdcWQ04KkY1kFTqXb93ZHg4OpX1LnFSQAJMncueSE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFcN88d7oFOlufxQn90JFxqXhHB6NCztJWqMLIkOzS6sb+eq66
	SduJpY0g7d819vOuPC3tmaOv2LWfxcm0NycqlVsPP3wNAaveiNG96DoXvfQj/UHhzQqDEo6+sVY
	VqEu72zijaxAJNjfDzH14dG5sMxtKDI7hLHcg6mzymNcElEfeCi36ba+L/mg=
X-Google-Smtp-Source: AGHT+IEVUfA3mPXS3hA0DJoSSRV+Ghh9W3bYlbB4sUQ+RiorkpWaQkzcHee8EanONeMMSXpA5+N9R0E0c+PhDvzwN0h/7WUL0Klg
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:170b:b0:3dd:bfbc:2e84 with SMTP id
 e9e14a558f8ab-3de07cd17c6mr26890655ab.19.1749894362680; Sat, 14 Jun 2025
 02:46:02 -0700 (PDT)
Date: Sat, 14 Jun 2025 02:46:02 -0700
In-Reply-To: <684cb499.a00a0220.c6bd7.0010.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <684d44da.050a0220.be214.02b2.GAE@google.com>
Subject: Re: [syzbot] [iomap?] [erofs?] WARNING in iomap_iter (5)
From: syzbot <syzbot+d8f000c609f05f52d9b5@syzkaller.appspotmail.com>
To: brauner@kernel.org, chao@kernel.org, djwong@kernel.org, eadavis@qq.com, 
	hsiangkao@linux.alibaba.com, linux-erofs@lists.ozlabs.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com, xiang@kernel.org
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 1d191b4ca51d73699cb127386b95ac152af2b930
Author: Gao Xiang <hsiangkao@linux.alibaba.com>
Date:   Mon Mar 10 09:54:58 2025 +0000

    erofs: implement encoded extent metadata

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1352dd70580000
start commit:   02adc1490e6d Merge tag 'spi-fix-v6.16-rc1' of git://git.ke..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=10d2dd70580000
console output: https://syzkaller.appspot.com/x/log.txt?x=1752dd70580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=162faeb2d1eaefb4
dashboard link: https://syzkaller.appspot.com/bug?extid=d8f000c609f05f52d9b5
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=115f9e0c580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1688b10c580000

Reported-by: syzbot+d8f000c609f05f52d9b5@syzkaller.appspotmail.com
Fixes: 1d191b4ca51d ("erofs: implement encoded extent metadata")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
