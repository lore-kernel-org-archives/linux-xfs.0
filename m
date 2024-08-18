Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A33AE33D1
	for <linux-xfs@vger.kernel.org>; Sun, 18 Aug 2024 04:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723955764; cv=none; b=mCsPkRYiOggfGzIs+Jd+kJoCWcdfgIUwNZjhJgQsS2KuLhijjDskkkaocmSQpjE1mPSZZGxsXZ2QOAozhDPQf10dGaxPISe5lR6sw9lxqjqFQhPUXcfEq1brudh2djo2lQtNtMYN4y1PTuAkgu78gl/Xi8M4Mhsdg2TBDdcM6PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723955764; c=relaxed/simple;
	bh=40gGmdyokFBvxCelSJ88QlILapEFGa++UUEwevJF6q0=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=idgb7POgBTIk6U5zUdnriSRABYhEj6eDW9eyZseSZ7hbBLbmcgk1JW7u6yTwoiIwAp35+2D7rmD1d1/g855Pia06IYnyW+44BnHV8OzdHp4q0pRDUALoHOgseUYzINQex+3hlf9bP+rwQvB3GK0Jb0GwQKMluG4iZ7mYVorcfBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-39d3325ba79so12032505ab.2
        for <linux-xfs@vger.kernel.org>; Sat, 17 Aug 2024 21:36:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723955762; x=1724560562;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SBGDucmLSB6SFFjjtCvCnw5DXFy/m92XieUw3u0Lkac=;
        b=H9I1amnWyjw8RaQ6SbIoTcFZ2ozzjAA1DGTorO+YvlBmyrEtHetqSG8IRkDfWOJpdy
         z2M3k4OUqnMrU1rqluWyR4ScAfnnuQqb2m9RqCsRtYksapdsyBXIt8Izod3TnPwQY/yQ
         M/vYb4pDdFH6iZHU+2DlnXp3jC2VJgXQYbJrviMvQvTbxjpmpS1sn6aiJw9ZvUmMHs91
         vZ57IB+K1RLNGcPWMaV1goy2t8KUIKMemSVh4auVaEujF4RmYi3dE7cAC7T6mqi2hYxs
         IuiayrzT/maD2ePvQ1NdPSdqrTpA/tN8qyll/K37sPMm6XX5VM9eO0edRgawxMF75ES8
         /Sqw==
X-Forwarded-Encrypted: i=1; AJvYcCVrP1fIwP9EtWPDP1hStte4L4uJv43GULEUHSuw1HNHrRJSq2mTfv8DAj+SPdt2iM6Xvz51ZbO6OkHWfnPU2wyQ/POA2K/bMnfV
X-Gm-Message-State: AOJu0YygvObHZfy9xvLdW4kEA7fQGVw/vq7LHia/2UwIoF1r6gM6IryI
	9fWRJKFrL2lTE85X2UzJaCByNqo9ZJpVFOUOcCsU6C7+LMKCNrD/gCqntlNqMXfR6us1FpsMJcZ
	girELuuAStmoj0/zjeVx+/orKWCLZmJdRRI1H89ZyMqlFroVXwbErtuk=
X-Google-Smtp-Source: AGHT+IEWq/Yu9hdLGQwW6k3JHsiI0gqvNTR6cCMXhjpNdSYUh+p03hC5kWy36g2JAFm+WlRduDD8fopasmd5HOtYs73xuvK/+5rO
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d0f:b0:397:ca8e:d377 with SMTP id
 e9e14a558f8ab-39d26c42314mr5570365ab.0.1723955761765; Sat, 17 Aug 2024
 21:36:01 -0700 (PDT)
Date: Sat, 17 Aug 2024 21:36:01 -0700
In-Reply-To: <0000000000008905bf061fc61371@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c9eee7061fedbac5@google.com>
Subject: Re: [syzbot] [xfs?] INFO: task hung in xfs_buf_item_unpin (2)
From: syzbot <syzbot+837bcd54843dd6262f2f@syzkaller.appspotmail.com>
To: axboe@kernel.dk, chandan.babu@oracle.com, djwong@kernel.org, hch@lst.de, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 3eb96946f0be6bf447cbdf219aba22bc42672f92
Author: Christoph Hellwig <hch@lst.de>
Date:   Wed May 24 06:05:38 2023 +0000

    block: make bio_check_eod work for zero sized devices

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=178bfdcb980000
start commit:   85652baa895b Merge tag 'block-6.11-20240824' of git://git...
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=144bfdcb980000
console output: https://syzkaller.appspot.com/x/log.txt?x=104bfdcb980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=92c0312151c4e32e
dashboard link: https://syzkaller.appspot.com/bug?extid=837bcd54843dd6262f2f
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12350ad5980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=147927c5980000

Reported-by: syzbot+837bcd54843dd6262f2f@syzkaller.appspotmail.com
Fixes: 3eb96946f0be ("block: make bio_check_eod work for zero sized devices")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
