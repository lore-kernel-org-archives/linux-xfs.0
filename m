Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C025156C6F
	for <linux-xfs@vger.kernel.org>; Wed, 14 May 2025 19:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747252144; cv=none; b=DWYHXhPqLSn61g0IVH2vXA3Llb7TzbeUs2IonacdGx8ONsBTZmdvRdpyX6vO0kMNR51W4Sp6AFlYTy8p7gBnVuYE1BSCFQ2b8WtA3wtGsfD3BUFAlMiZIcZXiULlku9sXz1Ck87LyMH+MxIGn39s3Uk9oYUCulbzXYSJW2oxW0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747252144; c=relaxed/simple;
	bh=oIrs49oF22LdOayzkJxHulEMqFcJxB98u0gpNzS1tJw=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=L/n100PW6KLm0EfW6Iw7PyYGb7Z+1idY5kO4ZPv0xUC/FjrvwdqisXZFcrdBCx34nJcpbtdmIYEesigWltKFaQ9yuoeTjYOcPXrPKujAtrZ6mh6tbdpOrXWLl30j2mFwxfkpaouzIIp/wHrW/qiqffJINtZ1fUhNKYtTd4TFUxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-85e4f920dacso18294939f.2
        for <linux-xfs@vger.kernel.org>; Wed, 14 May 2025 12:49:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747252142; x=1747856942;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Im8wekS7D0YSdnMIfDocgAHGRdGBxTKIXIfbrUkKCCY=;
        b=s7r/Z9haDrjWYKBe3snsEqq680cb+s9bG3PPFUkHNoRaxy9uP29W8JqG+hhP0VQCbd
         bYCmo+Bk6BM/jx/3XcZN2wOPQ5butY43aQlJ6vX1YrikK5DQY4OrTnGuUW0teH+mDQAR
         nPztS+3xsWsclAUeOSPYL3YnIo8TZn0ZY1bhZIM9O3gr0Zq2wEfBSJMdhlg1EGaHG2xl
         dnATfi8pCEf3dZAVtaCtOpmVg0ojVCdE/00POxCGgWrbtReigsqYv/CXGhshwKoPILEq
         3PYm1FAzB+aMlQpYBItXZKnMadYiFix7v5YsK830FUrn/bDUGx2fcbets+ZBwaJv7uN9
         hjkA==
X-Forwarded-Encrypted: i=1; AJvYcCWPmYlca7cxrL98CKISiTGIi/z1sL5QoifdxhDIAoZWjrR5xtDVqm8syGJBwfsLQYJuAuQcdnX0Qss=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPo+EjWIVIvoTl1wnaI4/wUT/EiIr6nxZi8U8QlDw+ZlLErcCp
	pPwLYTX5MNqgLsOe1WJP4V3GhaEGTABv6JsPd1UWhQWoNhluphPuqF0VtZKfitU3W8weAzOaDyL
	ugSKK0bPrLpuX85zm1CVB9tQxZxvWEGkO+jEDHU8fk06JpaN/mDSh1Rk=
X-Google-Smtp-Source: AGHT+IHi1nA9q05RgsrvMcaw4+vkrl4VzwVZ7QmhuqaphmWHt3YXymWvrvMvRn2WUOpe2Ha7COf3DHODkvj9pxX72z9wyoUxAbTe
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:368e:b0:85b:4afc:11d1 with SMTP id
 ca18e2360f4ac-86a08dccf99mr546554139f.5.1747252142169; Wed, 14 May 2025
 12:49:02 -0700 (PDT)
Date: Wed, 14 May 2025 12:49:02 -0700
In-Reply-To: <20250514184652.GP2023217@ZenIV>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6824f3ae.a70a0220.3e9d8.001b.GAE@google.com>
Subject: Re: [syzbot] [xfs?] general protection fault in do_move_mount (3)
From: syzbot <syzbot+799d4cf78a7476483ba2@syzkaller.appspotmail.com>
To: brauner@kernel.org, cem@kernel.org, jack@suse.cz, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+799d4cf78a7476483ba2@syzkaller.appspotmail.com
Tested-by: syzbot+799d4cf78a7476483ba2@syzkaller.appspotmail.com

Tested on:

commit:         cfaefc95 fix a braino in "do_move_mount(): don't leak ..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git
console output: https://syzkaller.appspot.com/x/log.txt?x=11865cd4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b9683d529ec1b880
dashboard link: https://syzkaller.appspot.com/bug?extid=799d4cf78a7476483ba2
compiler:       Debian clang version 20.1.2 (++20250402124445+58df0ef89dd6-1~exp1~20250402004600.97), Debian LLD 20.1.2

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
