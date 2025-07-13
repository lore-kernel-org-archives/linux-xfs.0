Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A9B7BAEC
	for <linux-xfs@vger.kernel.org>; Sun, 13 Jul 2025 05:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752383764; cv=none; b=aRZrMAfbUMqwEH1qpasMN4fQe9uqN27/CIZtBUpg0j+Wb9RRjD2Ibn7NZOVsbRF8/pMHLGGhZ7jccCLdZ29kumyD61IEsaMFHOjw/v5vynctI3vRfmv2cSuNu120AnEyGa2zPwItAJGWoek7y/KABdCoF316on3IWvZUXKjcets=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752383764; c=relaxed/simple;
	bh=KaX8JZDBQRrknH5V1BiCsjLxPQHPtL4K/I4ePVO5df0=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=snxaE7G9IUcTdJQVnIiYgAyq8LHa94el6WW1EUjgQfZQh8TJ5n0w0uqsKLlEQOb8TrpDlkEr3OCNrvmcyFKCjl0tohyxOgZgzr/ELuHktsOi1CAsSUDZoqgtbF4AQ1wKD9yA05T2NCoj3Wezt6Gh6PbOCezwHi+QhAyPUdcjpmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-86cfff5669bso323852139f.0
        for <linux-xfs@vger.kernel.org>; Sat, 12 Jul 2025 22:16:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752383762; x=1752988562;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tgpX6hD7GrjQcqjiIlbZW6vXkUDki5U8wW6v/gISqd0=;
        b=U99VDKxBOe49Xl0JtlU6eZyOMQSFq4VFcHqjPzIshKZ/LkFswcgp4Ov5zV5q+lcFDO
         nych1IJAbwTT1CjE1I9RdgXlLsKv7DL4jSY3nSyTPlzxA2+mFXDiKIWvJPXsLwdVM3I9
         9ILpjPVKJjKPle84dWZr3diOu5nwEv2jABPiky9W1rQ4QjGLe0VU+tC47okk/zAT0pVv
         HPGMQLsx0bxhQaC9u/fuEEpBebXR5g5sGGP6Dhwjo8OYSQF7fG1UY7MLPP5EXZaoXVCk
         NLWgQ89pyfulCas5HN/lGlSMOi14qIHiMusoWiOiKDf0LAy3A3IAXJ70nrkYien+zxkc
         sNJA==
X-Forwarded-Encrypted: i=1; AJvYcCW4eW/pGSFgysEp+547XJomeR+aawHJFO2NTXYb8iEZw5qcxeqlh2XYgpSdaGYs4DYsBUC9hYm8e8w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0VHxTLX4f9HrqjNbwKuBDSOA3glqOOiW7NofUEz8o/HHTvHwx
	bCjmTf3Vmsa/DKS3JOTBDQO07mMTt3bPYvKo8vtPFzGWBv24nF/utvaHwbyegFvHwpoH+zj1hE7
	6jeWLM2YXQSU5xTksKiGZW6WMkVTjGA5r3ar1N60F+WVrNt71tMkihqIAHH0=
X-Google-Smtp-Source: AGHT+IE5TAj6ixNXi3mwMFFkvM1B20dWMHYj8zdo+DgdUZ+dVVXcK6/2wL3n9BrJ2Wqj1AVmU6DrbMY60n+7W6uE/VpW/4b4J7xJ
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a5d:8553:0:b0:86a:441:25ca with SMTP id
 ca18e2360f4ac-87966fd24aemr1318525839f.6.1752383762008; Sat, 12 Jul 2025
 22:16:02 -0700 (PDT)
Date: Sat, 12 Jul 2025 22:16:01 -0700
In-Reply-To: <6824d556.a00a0220.104b28.0012.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68734111.a70a0220.3b380f.0020.GAE@google.com>
Subject: Re: [syzbot] [fs?] general protection fault in do_move_mount (3)
From: syzbot <syzbot+799d4cf78a7476483ba2@syzkaller.appspotmail.com>
To: brauner@kernel.org, cem@kernel.org, jack@suse.cz, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, lis@redhat.com, syzkaller-bugs@googlegroups.com, 
	viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit 3b5260d12b1fe76b566fe182de8abc586b827ed0
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Fri May 23 23:20:36 2025 +0000

    Don't propagate mounts into detached trees

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=160a018c580000
start commit:   bec6f00f120e Merge tag 'usb-6.15-rc6' of git://git.kernel...
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=b9683d529ec1b880
dashboard link: https://syzkaller.appspot.com/bug?extid=799d4cf78a7476483ba2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17eb1670580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17794cf4580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: Don't propagate mounts into detached trees

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
