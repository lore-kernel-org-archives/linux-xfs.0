Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C79619E99F
	for <linux-xfs@vger.kernel.org>; Thu, 30 Oct 2025 07:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761810125; cv=none; b=tRnP20k0uKlQDDeOznxCMF/dbkUkuFkHsKJqAR+8vmdiwcgA5tka4qoejgeLEqi04wb0LItjOY1g/9uu7SMmUiG/SLIZZLfaVGxL2XC9Jy5EYhA1SRC15f+tZ4r+fKGzgluqrgk6hPaAvpvWYny9CROXmXxnHq8I21dYnL09vfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761810125; c=relaxed/simple;
	bh=lCojzIsTFGl1TVJIPtjeU7f+5UW+iwMFJ+6iUln5nXE=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=Ti2BAfahejNJRXF4ljwrcAWQaukO0pHtYR/bQd4UsTZfIcTfD5H6pjO8wgWSR+lOqDH4r9NgztvRpnpzSIBg7IUAcgAJwv6ojnxxGWs3gBOAUztxb9S2RrFZ/tYaoq5nu63XFcLyQlOlT31x2KM5o1plkaQx+MD15dvXrRuXqak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-430d4ed5cfcso23494005ab.0
        for <linux-xfs@vger.kernel.org>; Thu, 30 Oct 2025 00:42:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761810123; x=1762414923;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RSmf8987BpTQJqzmW0Dxhs15YbQGxphnSa8IuxRBHno=;
        b=mxnZL/LgEZF8CyK4IxIyJ1Ss5FbTjbtGIiHAvcA0RfkLIJUlXkhvnKyqGPiO/q1j5D
         ZYLWHZOO1xUa03bk6IhWvq8kHIRqdOGuppV2fvMrHgCMI19sa7mT3QoUiKvwzTD/CiMv
         EnNUQSa5cZNzLzZVaDPhHj61ABHm53peNYDaM7DQtJJJaElb60iOM8OfkOBSrMOVZx1l
         EZ2eHoU+bThcQ5WE1ic2H8rJUMyxfuXEVpUumFoBxgcEbEvkRdgLr8fU2H/v5JC9DU0g
         uf6IPfIovPdVYxrhFb6IpZiHHyZPCX2eXpXC0VbBlmb11mRJydbRGDYpLdySbrldKIkw
         R2Uw==
X-Forwarded-Encrypted: i=1; AJvYcCV8leJuAkxDbjqehxkWYGVrZ8vozUO9ErR5TVta0zaH6NtcGzwqPYKBEGthnNMu3pPMxeIJC5Why70=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8KXuJDBaE+hb3+6ZlH6plLKCR+T9TU6aCoIFxkF0PaS+isu87
	Uz8+tAWsNhcVp/auAfSRveTkA0ybeCZSMKxZLgYPU0uMfiZj2rd/5Ufm12gOHIQ4OJmy5eCejLq
	oybqaKOdbUrG4Q6D2Yjcw4rDX5yv202Rya+46AfvTViBWLyA34nS3pmAwXCo=
X-Google-Smtp-Source: AGHT+IGVSmseTcLwLx0sUVIor4xbNG/ZXWrT6/VOsNCt/mE4ld9elES5xUBU7Ha9LNxul3PwAA6NfCUeY/19kjw5xT/P5YzGhDRL
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3e02:b0:425:7534:ab09 with SMTP id
 e9e14a558f8ab-432f8f81afdmr76672795ab.7.1761810123398; Thu, 30 Oct 2025
 00:42:03 -0700 (PDT)
Date: Thu, 30 Oct 2025 00:42:03 -0700
In-Reply-To: <aQMPqDAxyM3i3pQk@infradead.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <690316cb.050a0220.32483.0228.GAE@google.com>
Subject: Re: [syzbot] [xfs?] KASAN: slab-use-after-free Read in xfs_buf_rele (4)
From: syzbot <syzbot+0391d34e801643e2809b@syzkaller.appspotmail.com>
To: hch@infradead.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

failed to checkout kernel repo git://git.infradead.org/users/hch/xfs.git/xfs-buf-hash: failed to run ["git" "fetch" "--force" "679bdfc056221ae86d16104d6de6223afaafa4b7" "xfs-buf-hash"]: exit status 128


Tested on:

commit:         [unknown 
git tree:       git://git.infradead.org/users/hch/xfs.git xfs-buf-hash
kernel config:  https://syzkaller.appspot.com/x/.config?x=8c5ac3d8b8abfcb
dashboard link: https://syzkaller.appspot.com/bug?extid=0391d34e801643e2809b
compiler:       
userspace arch: arm64

Note: no patches were applied.
