Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135C11993AD
	for <linux-xfs@vger.kernel.org>; Tue, 22 Oct 2024 10:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729591865; cv=none; b=N0pO8Sdi5vtX/WalROINH3txJSfeGj43aNCTnYidKP1VS5Hc+iLKh5OkIRYmNwz0wioFox6Dv6taEktNNw2/CZ4Q43uL6pW5feCFf7iRL1cZHbnXmafZlpGb1c1vHPn3NuLnr0wEMGPwx7BKaudZxgLMeJAUTHWq2nuf4/72qHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729591865; c=relaxed/simple;
	bh=L8Uyi649s2m40I0JLwCAzmHXr0Df5flHBX+NVq+nmVA=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=AKaUg3/OchvCm98gyvym0tNs/X9haH05fVi9mVQ9PgNJ03DGa9McfzaGk5ymzaoudj6/Wu6nIVvN6zKM/5/1+wO+qqiXxywo4GZt90ZNceNOnjQuH+GGpQEkwg3+uzMf2zXJD9JVLTF4aMQYinZNWIfBDD2CDjKuQhXujF973nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a3b9c5bcd8so48822715ab.2
        for <linux-xfs@vger.kernel.org>; Tue, 22 Oct 2024 03:11:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729591863; x=1730196663;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q3o3zq1GU4yds7lbg+NbzU2tEJq57lSCyXfB510B+bA=;
        b=f5iomQ+l80XC7H6qL8j2XsJ7KvwdJmkGCC0/MOp3JyYuq0CjBMgPk71dYiiMmbZDD6
         M9F/OomYVLn8ngSeQNzqCI/g6pylIdsM6I5eS2HpVtjDYug4IvB7jFWwzvSD5Z/oTVon
         BxAqCDXIMmglngm29lG1mcSCYB4hK95wLz6IHCQzra96KoU/nMYpTXPqFS37UYoMET+i
         ZB6IVpVz00LTeh7r0Y4tYFsnSJDMsAt0peKlMYAUk6agnLQM5EYBbCgLR+WVCvybzwuv
         vR0l3UwViiz8pA2/RnAwJnL2kvIUBfLA8bbZ2TLJ4zAlL4gs7k/o4JUTz1/5y8dS7+WW
         SUNA==
X-Forwarded-Encrypted: i=1; AJvYcCW4d7t05yQeSY9iBdJHzcMbjm46L5jm5+udpBWe/1mn+nsn2eTuFjI0ZgXmJpua0sz7qqnnIi4ANL4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhS8mh7S4cxb+WNMG6tAyTRnF8hP4Y/txC0DENF3bKy8Aevpnm
	xI6uO6iYSrvHwEnBMtqFVKvkwYXv84b1cjvFgVWhq9MJNB2i6RQO1JXBvhwxoklsuA+j+NfKKhf
	8mnSnl9FgE+WOF1pdVrFdF8GS0VfUvCC20Jzd5uDj1J3zVRmPFYs6YME=
X-Google-Smtp-Source: AGHT+IF18dfHmvud1MzhNbZ/LjtNSGQIhn0kTO0Rx03lSMiSnRyNSbXOWomnvfZ4QkDs1XGPdLbQTaXb+gv+SRRhJchVuyK3+gej
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:174c:b0:3a3:b209:650d with SMTP id
 e9e14a558f8ab-3a3f40cbd4dmr126799525ab.26.1729591863099; Tue, 22 Oct 2024
 03:11:03 -0700 (PDT)
Date: Tue, 22 Oct 2024 03:11:03 -0700
In-Reply-To: <ZxdzTL4UYZtgsIiK@infradead.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67177a37.050a0220.1e4b4d.0074.GAE@google.com>
Subject: Re: [syzbot] [xfs?] KASAN: null-ptr-deref Write in
 xfs_filestream_select_ag (2)
From: syzbot <syzbot+4125a3c514e3436a02e6@syzkaller.appspotmail.com>
To: cem@kernel.org, chandan.babu@oracle.com, djwong@kernel.org, 
	hch@infradead.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+4125a3c514e3436a02e6@syzkaller.appspotmail.com
Tested-by: syzbot+4125a3c514e3436a02e6@syzkaller.appspotmail.com

Tested on:

commit:         0338c38c xfs: fix finding a last resort AG in xfs_file..
git tree:       git://git.infradead.org/users/hch/misc.git xfs-filesystems-pick-fix
console output: https://syzkaller.appspot.com/x/log.txt?x=11150287980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=41330fd2db03893d
dashboard link: https://syzkaller.appspot.com/bug?extid=4125a3c514e3436a02e6
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
