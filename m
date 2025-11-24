Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A89030148C
	for <linux-xfs@vger.kernel.org>; Mon, 24 Nov 2025 12:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763988545; cv=none; b=RMatgZguk/bIhrZSdsO696iXXtavPQLRB2mM+8Joj3DrBo3BMMHBjr/5cJAv7hi0jPhC6IY69493aSi0ympwRjexcVAoTJwbnMFPnITew1JGsagxqN4rWNDr4hiFzvTeh/Y8ST65/UYA6K0UWVYMK3SWMVYk9pUBO7gVnQq5z2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763988545; c=relaxed/simple;
	bh=aTBk5wv19Muo+2YnrH6f1y6i8RWb75+ynZVuEOxj3xQ=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=VT5DbomtSGFdQ7H3IVWjuWOXx797AnFQB3YSzFGF2XGjLq/q7ZCvGTGKx8mKjZ8mjxD0Xq5dJzvhkNrG0DmjLUcRcCvu60XC/zIsI2tOTloLpvVunb30zBXpnGvDQbfSQNerl+siZruF/2MocJWNILL+mgJWOh9DwbwZV3RBaQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-9490b354644so339346439f.1
        for <linux-xfs@vger.kernel.org>; Mon, 24 Nov 2025 04:49:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763988543; x=1764593343;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KSZ0UBzx7Do0RZn2Lqa+4OV3iFUI/WAfqveTON61e6U=;
        b=Kiq5KFfmxMeALe6durSzBFN1mPS+w7JeDEa579g4UtmCzhWYAA8zVYzSnkAThJojah
         4TkMv0qs30VmJyjqkP7wtA3jF8pYDoajOa23VyeH9N+UeqQ9NvxaqT+Kq9a/QaAkwYCW
         kLdpvS1RDWfKFL4UZxmskyZSyb5kgpaaIpsg9ODP+etmyN77A6yN8fwbvylIVUJrP87Z
         upxX8kWxaXGWVmt62O/jYmkB105D9EAgEjiF+EyWQk0YGfkUbN9sFUQ6MBTluRXQqWp/
         JlBSeRranXbIxMCyyhzgkuygAOOyVf/+xXK2hH1SqB2ErADlPwQcFnK/6KKLls5OH5TF
         XGJw==
X-Forwarded-Encrypted: i=1; AJvYcCUKKz3dRclzPUaRlebxGT9EON08SwRZzXNJyCRx576md4BkMKM+GF1+gv2b8E8ZY6SNL7aXvtLhBNg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyjewMErDNaHyHBneVB3XIwid+EdzH8fvwAuRTZAeNqJ2+COEeM
	Zt9RBeviXIhCeADJvpLOgK1LrcMlyX0GYKUezsQRbHp9hYhuXeNIlEV0cnQavovFnGNoVlYRIeK
	PMhEPNtLAND9kmAYd3ygAYXhcJhZPEz0Dsg/vDZJqhvrMH0THczu35atfOi4=
X-Google-Smtp-Source: AGHT+IGBBr3IIE4ZeKrQ7xmh7rz8JmRd+QYgzIma29JVdy9OqyF8T6hDHLeH7MsHmtpCXlQrb+hhY3J3LUjqLMe422QXceU8K2Pj
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:18cb:b0:433:79e4:7adb with SMTP id
 e9e14a558f8ab-435b8c09e62mr94945835ab.11.1763988542832; Mon, 24 Nov 2025
 04:49:02 -0800 (PST)
Date: Mon, 24 Nov 2025 04:49:02 -0800
In-Reply-To: <aSQlrJxWxNyCVt3z@infradead.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6924543e.a70a0220.d98e3.008c.GAE@google.com>
Subject: Re: [syzbot] [iomap?] general protection fault in iomap_dio_bio_end_io
From: syzbot <syzbot+a2b9a4ed0d61b1efb3f5@syzkaller.appspotmail.com>
To: brauner@kernel.org, djwong@kernel.org, hch@infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+a2b9a4ed0d61b1efb3f5@syzkaller.appspotmail.com
Tested-by: syzbot+a2b9a4ed0d61b1efb3f5@syzkaller.appspotmail.com

Tested on:

commit:         660f4047 iomap: allocate s_dio_done_wq for async reads..
git tree:       git://git.infradead.org/users/hch/misc.git iomap-dio-read-fix
console output: https://syzkaller.appspot.com/x/log.txt?x=15c4c612580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=68d11c703cf8e4a0
dashboard link: https://syzkaller.appspot.com/bug?extid=a2b9a4ed0d61b1efb3f5
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
