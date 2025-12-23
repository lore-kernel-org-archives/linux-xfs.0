Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F1027F754
	for <linux-xfs@vger.kernel.org>; Tue, 23 Dec 2025 01:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766453587; cv=none; b=L+ynXHRtH1PDLbUnpGMJlnnezcWfIuMPC8N3BjKEV2RED8ShP+rbpeDaQLjN4zTThHiX1BxAzBS1D7OTfRHaphHv3qOAnIoEt4caURgQcOcmCYMLE6hJ0gMyEnY/aXVMvjgqAxCV6gYJb8ouG7U1smKmc+U4jNVhUS3OKFxvIQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766453587; c=relaxed/simple;
	bh=SP+GaiCYuN2M2+xFFnDwK4yIuut+xKCKAjpjpumTHY4=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=ALSPu7lOtI0IKD2qZb8fq62hXp739/UX4nef/7zdr5casiBruR1nDpYMK5SMG9dKERuo2DF0SLZiisXM95P7X20GyECYyaykjlO7hPqew3p786b9uUJG2LEmOPPWDEJPjxsqotopwb8zkIpKx+8mXQ5gtlDx6Co8A6V94MurlbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-65d12f446c2so6135317eaf.1
        for <linux-xfs@vger.kernel.org>; Mon, 22 Dec 2025 17:33:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766453584; x=1767058384;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U0m2ApQPISoQ1H75VqhHliy3dNQn6hllI/yvhM5v7Lk=;
        b=EohSxmGHKQq6rvcJ/hOaZuglydLdd+ZMwc3dBPVZReGm1cxLT6BxNbKzjPHsrU23EU
         QM3nGL1oRFNy7xWFpmjpKP7jmoEKNAUdAFIEQu9hYxB2Fvu0gqiZbl3Zu9JtflY2Moiy
         YlZyZhtzUSkZFEIaVuBIG3+vrP/nbP8dKwL5ou3FQvkm8MEVkWxsvQYeM3jQWJOJXQQO
         r4zSExbqFH/N1IR7BQP0j/lwzlRfD0EvSDQf5RIN4R9exSoymAqzL0XU/RRfREjMBFUE
         t7BrfWukCCokb6pbkBox0cujwxhcidQEQNHDJT7jYz1Ol/XNigU7cnQXikFu78/PiEah
         GQbw==
X-Forwarded-Encrypted: i=1; AJvYcCXE/HqAWEq5e4eZm2duUAELOvk2tTcXWSstkSqLDY98Nz4vb1xRkEgm8O7i+Ou5gci3Cql0bR3cl9k=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+am2Y6DAOSUg0L/syS1ftay+TV1jewK12O+DDKX0F1E9hTlHj
	kEAqxpLi9lrUx8mIF3e/kw4XaXJQ7ckEE0T76gGWNWjLIH3pko7/V50zPRa357nFCOds4ce6MkP
	hfgZssT3LaPfp7YJORsIsqh8ajiIJ/AI+aqhB92yEReA/HsNJJjTFpic/vQs=
X-Google-Smtp-Source: AGHT+IHtP2DOlHW6k5FdZTWgBmECBIw/OVxec6XgeB1Npqd5Hqrut3nMJycncDEhBsjAgRsyhcPFqGYdeJHUNcDSIVN5kWigJN6G
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1c9e:b0:659:9a49:8e8a with SMTP id
 006d021491bc7-65d0e9f3b7emr5999684eaf.14.1766453583902; Mon, 22 Dec 2025
 17:33:03 -0800 (PST)
Date: Mon, 22 Dec 2025 17:33:03 -0800
In-Reply-To: <6841da10.a00a0220.68b4a.0018.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6949f14f.050a0220.19928e.0013.GAE@google.com>
Subject: Re: [syzbot] [xfs?] INFO: task hung in vfs_setxattr (7)
From: syzbot <syzbot+3d0a18cd22695979a7c6@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, cem@kernel.org, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com, urezki@gmail.com, 
	vishal.moola@gmail.com
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit a0615780439938e8e61343f1f92a4c54a71dc6a5
Author: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Date:   Tue Oct 21 19:44:56 2025 +0000

    mm/vmalloc: request large order pages from buddy allocator

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12ce0bb4580000
start commit:   f83ec76bf285 Linux 6.17-rc6
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=4d8792ecb6308d0f
dashboard link: https://syzkaller.appspot.com/bug?extid=3d0a18cd22695979a7c6
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13e15762580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: mm/vmalloc: request large order pages from buddy allocator

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
