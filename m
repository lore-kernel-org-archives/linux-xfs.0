Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121D01FBCB2
	for <linux-xfs@vger.kernel.org>; Wed, 25 Jun 2025 21:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750885804; cv=none; b=qyW5tLRNWFVtsGY2gpGS3NBrtiu+rDqLLz8bcRn8gQC9UdA8crDju9q3yrbAsIyc25QPpUVA2yAQdUYHFKWhqE7mC5S11iQlKvViA+EO6cumMWQU7hytWVwCyYiYl2zSq1MTB1pKUbt+7TNegt1hT8r5f+2p2j8oa1i873zRsiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750885804; c=relaxed/simple;
	bh=CNKw6tzEja4Qt6Nh8nMdXFeEWbdQjDHV1oVsSa0p4eQ=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=GUUNQTWqr1THPGHWuHxp3+4s0qQCKra9CuuWfp5GTN2+aCZ0jwPACwoG6kyNc3/gEIScu/zl+vcUJP6t5rNzRZVj5TLnq4HU+/LH+nd6zRlLaORagPlE884g/ePyzD72uUUX4GAWahBODpNiFZxzirYVZuGbiz2QJ+aKiz+v7bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-86d0aa2dc99so39508339f.1
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jun 2025 14:10:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750885802; x=1751490602;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Kc426aQB/Ls8eZ2ZTizs/1SQKrFEHeSjd9qsxqSJwL4=;
        b=Z4PkgodVMmsVzpIEV/3vcWOtGCBKUiw/nZZh37Brq3vdEm8/GxI1hVZaOY7WX2ELqC
         54wkcIj7/eliKHCKHNIVSAn/mTuOmH7pvFQzRBGWnq6YtoKZf02ERiA392qRX5XMAWsl
         XOhzkeGmhWxFUJtnj4yd2krRNzBFZspSZ8/3FtqmyMgl3oziPc3+GI27D2y4a85dnUAe
         /i0JWDoCc8FfeIVITBaoEm8kzhrLHxMNvma6lmeJw0Dl7TVqeVO+Ry9sNlJdAR6lqaA5
         DVTPu0quwIbfIOkglwLQD2kiVy2dRzBj6ShDFUUYL8nhKCd+yCw0fiDhddIH/N610pBN
         Z6bg==
X-Forwarded-Encrypted: i=1; AJvYcCUfAlsQdS0g/JdHBgnZvuNIbL+ddZziLiSqxsIpW4nvyNPtsz0O6Eh9Y6q5c387QSRo+QqrI0VvLs8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyn3cDV98gvo+rwC3ATPeAOIdBIvBVQ83mAUdHXqsZ7d/bJTzFz
	nZCOBpMtPdX0ZMhdLmJJbD9xESmDwT+xRgXqVU1L9PcSwhtD2uGKL0OAXiHYs7kka3ETm1G4nwi
	rSKMSKbcN4VWzQ30efSkGZC5+InQ9Q6ey/0JlZ44RBT9UFxlfLgC9/ZlC71c=
X-Google-Smtp-Source: AGHT+IFsLSGcBbmWtt1GPA7otyFNGoqQ39LiKIQmsCWWO9urExGRsP2gl2q2dUeo/rc0DVTmtRh5fh/sIrBSXo3bSUXE3QaQI689
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:a005:b0:86d:5b3:3b88 with SMTP id
 ca18e2360f4ac-8766b73e5f1mr592236639f.1.1750885802133; Wed, 25 Jun 2025
 14:10:02 -0700 (PDT)
Date: Wed, 25 Jun 2025 14:10:02 -0700
In-Reply-To: <0000000000008905bf061fc61371@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <685c65aa.050a0220.2303ee.0098.GAE@google.com>
Subject: Re: [syzbot] [xfs?] INFO: task hung in xfs_buf_item_unpin (2)
From: syzbot <syzbot+837bcd54843dd6262f2f@syzkaller.appspotmail.com>
To: axboe@kernel.dk, cem@kernel.org, chandan.babu@oracle.com, 
	david@fromorbit.com, djwong@kernel.org, hch@lst.de, john.g.garry@oracle.com, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit b1e09178b73adf10dc87fba9aee7787a7ad26874
Author: John Garry <john.g.garry@oracle.com>
Date:   Wed May 7 21:18:31 2025 +0000

    xfs: commit CoW-based atomic writes atomically

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1078f70c580000
start commit:   85652baa895b Merge tag 'block-6.11-20240824' of git://git...
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=92c0312151c4e32e
dashboard link: https://syzkaller.appspot.com/bug?extid=837bcd54843dd6262f2f
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12350ad5980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=147927c5980000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: xfs: commit CoW-based atomic writes atomically

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
