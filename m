Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01EEC239562
	for <linux-xfs@vger.kernel.org>; Sat,  6 Dec 2025 19:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765050845; cv=none; b=qXancbhYYotOblF3V4BR6/SMW8xJ5qjb6HRTvlmwPgZ3enr4lFe+gtkdFfKqTjthVT/HjybwGX+c6yikM+uEVBBvgZmtEm9+BE00SA/5LDni5rGdzhopb8xeXhuzahJL/AwSbVGR5Ydj7LgHMXTl2/JY9ccXE+V0e4r/JqwiqIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765050845; c=relaxed/simple;
	bh=g7c1MXDOxBT+UEnnv60eRig7h88JVCaSiWb/CIMfpfk=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=KpX9lmV4Ou512xOm7r2NscHY8FM3DNxJGDo3FoJ/plBtcY/ePxgN0Rob33acFYbOIwaZyET2ZQfxsqIb/luaVAtzRBZCzlN6pEVCsB+CqV9eSTg9IjS3NtAM0+faIL/p3lHdRKMys7l6cM83g+saq3rCuiFM6RawuJuJ29w8GKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-65997ee5622so1549730eaf.1
        for <linux-xfs@vger.kernel.org>; Sat, 06 Dec 2025 11:54:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765050843; x=1765655643;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/7ZTbcXkFeTJgPKb5pSyPef7lfMct4EiFIfkMP3W7XY=;
        b=UDlWmTNbJxo9hQqeajm+uLPo1v7uu8sWgCFQEX/25MHWoJn52rHqt8n9P6qhzZlR0m
         snJnWIhuk1PTTYYaaSqtNQKVYRHG92qpL27qESSgqx5Su/y8m0CyqRUDE4xT+Fk8BnWc
         KzlejCPFBkMe1z8ISO6ZF3uht2cgdFDFXo2ilPJsxm15caZwLbf9/Qi/WqZpJRGk4Ctw
         KhxCnn+pjZOClNMo+/ZZ5duyPZ1xA9RBZXYFPVttGpjRJzI6Sgyc7HxL5lDec1k2Qb2R
         tb7I1Kx3H1d6tMvSqj4Q/HnHGOY8Bc0Dhz4QOATodOToU3GYH0MXOztDvQOs5S1qm99n
         zmDw==
X-Forwarded-Encrypted: i=1; AJvYcCWTxqKoSm25/dKVc6jkLd+bowcDdZSQG5wi/7SRLahqA7I7Dp8f3+YU9tXeCN05nE4CrsHpjyH+iAc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVxe2lcY9uUr6IL1GFv8mXOnUjFHPpQccwb0uyh1xRJRZHQ3hI
	iavtGqNHYDY+eGnAVh3XDGZaLZNetjamHzIg4bUi1tQT3ivkOUY3eXy7fB0PAEsppvXtWIGZFhM
	RRRUcyynC2Y8YvlXS9qItw8V0znaXmLjzhVwa82MPhmeiiZiQlxBWK6kPP5o=
X-Google-Smtp-Source: AGHT+IHU0DXLCq+hpfsS7Fg8vMPv8EChZ7ujTnOYQ+JmHStVSW2Iji8d1hA8XrZ+hd1ons7o6MDYWQAugtLBAkfVQ5claDSDuLLp
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a4a:edcb:0:b0:659:9a49:8e8e with SMTP id
 006d021491bc7-6599a8c0c00mr1307396eaf.18.1765050843136; Sat, 06 Dec 2025
 11:54:03 -0800 (PST)
Date: Sat, 06 Dec 2025 11:54:03 -0800
In-Reply-To: <686ea916.050a0220.385921.0012.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <693489db.a70a0220.38f243.0037.GAE@google.com>
Subject: Re: [syzbot] [xfs?] INFO: task hung in xfs_setfilesize
From: syzbot <syzbot+d42ea321837890ff464b@syzkaller.appspotmail.com>
To: anna.luese@v-bien.de, cem@kernel.org, cmaiolino@redhat.com, corbet@lwn.net, 
	dchinner@redhat.com, djwong@kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit b9a176e54162f890aaf50ac8a467d725ed2f00df
Author: Darrick J. Wong <djwong@kernel.org>
Date:   Tue Sep 2 21:33:53 2025 +0000

    xfs: remove deprecated mount options

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=178cc21a580000
start commit:   d006330be3f7 Merge tag 'sound-6.16-rc6' of git://git.kerne..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=b309c907eaab29da
dashboard link: https://syzkaller.appspot.com/bug?extid=d42ea321837890ff464b
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10a87f70580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16602a8c580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: xfs: remove deprecated mount options

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
