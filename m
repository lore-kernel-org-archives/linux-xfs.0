Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4414214A9B
	for <linux-xfs@vger.kernel.org>; Sun,  2 Nov 2025 05:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762061946; cv=none; b=co/oArSLsSqhIEQ5uVRbCWkPF3NZPmb+KzxvH3b80x/AGRuau5ZeANmDgoyx8eK7ovDfThp7ObNkQx9UnkLm0mODs3tP1UouGQhN71mYZSgjNuGvlb50eHQtXK79aHXpXmEz01iE6u38f068RBRCz6SaQgBH+2nggo5JeWVkOEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762061946; c=relaxed/simple;
	bh=WImCX7SvTyP9WE4YKYQAr5TtP5ayByld5OhLfhadDPQ=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=phEMEO+b1BuJZtKIeqSVIqhJG6fkQi5TBmNA71PvXy+Az7M3BJ88nHcRFCgt8ATAp0KCTk0pLEQUtRSpQ7AmmsbuG1gHhuQUecjbp4eMG84QUHxzssXtSGA/tN70zOBYLVRtjAcWx4CJWpReUwTvz+zCsShWj5SMBRR3DVAT834=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-431d3a4db56so136879625ab.1
        for <linux-xfs@vger.kernel.org>; Sat, 01 Nov 2025 22:39:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762061942; x=1762666742;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I5gofQLv9ATheBLZFs5eVxjk1NYdTx1xDPMzfJ3PQe4=;
        b=rwlGr0Q2jHat8ZQw8cC+9mbz7VNZdw3SSlPNjQkK9P7zcLahjRq7VHBhEYZ8YloPoZ
         oC4nhLJgnYnLD3sCoNfMpdz0113sIIPRUhFfewGjl2OdLo696h8vUaZDb5u1QFJgwuZk
         qm5oyokRvmzngSWueC2oHLqIISLOCkS6GGsEPkjKCaVulmynoiI7KgMs8lxZt3sM+INd
         SJfb/0TMXLTWl5Uv9hy2F/gANW5qPgEyjG7xC/21cx1dR5r4O63pz1vNxlcDPe3hb79d
         0l/l79HKeM1cohd8x6CxOqv8bMjTR9xttNFG2LMRydvkEUa7Ra/7Wppp4lTYZGXeppDV
         ZCPw==
X-Forwarded-Encrypted: i=1; AJvYcCVmZpfJU0m3/ux0jJ27KYCKuWetsuarutMpg0qGAQtI9RyeoSYoWO/4NM8NR+Fw9F227cLnOuxT1vY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2S5z82cj4I0rwuVGz9UPeKGZYDr/i3XXba/n1G85jUkuhmipB
	EpCzYZYJivTCQptSUgshNdSxfQN/ywJWlhN/FN+IAFFNk5QlU5BPOhpnkQ7o4xA4xkjhAjw2shh
	JoXMw/PRUbLJS+LFblSnS+xJX8477gSpQqp0WC6fi5WOpdl+OvsQb9vorVlY=
X-Google-Smtp-Source: AGHT+IHCp5x9Csze7ts1+FeJTWPJ23oGo3DuAx7NFNbgLSzgUoEWPJQbXpSqgSY8kC3XvptviGA3Mx7pJPxr111i/n4AQSQen7Gh
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:4c18:b0:433:2389:e0ad with SMTP id
 e9e14a558f8ab-4332389e21fmr37683605ab.8.1762061942596; Sat, 01 Nov 2025
 22:39:02 -0700 (PDT)
Date: Sat, 01 Nov 2025 22:39:02 -0700
In-Reply-To: <68cc0578.050a0220.28a605.0006.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6906ee76.050a0220.29fc44.0016.GAE@google.com>
Subject: Re: [syzbot] [iomap?] kernel BUG in folio_end_read (2)
From: syzbot <syzbot+3686758660f980b402dc@syzkaller.appspotmail.com>
To: brauner@kernel.org, chao@kernel.org, djwong@kernel.org, jaegeuk@kernel.org, 
	joannelkoong@gmail.com, linux-f2fs-devel@lists.sourceforge.net, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 51311f045375984dabdf8cc523e80d39a4c3dd5a
Author: Joanne Koong <joannelkoong@gmail.com>
Date:   Fri Sep 26 00:26:02 2025 +0000

    iomap: track pending read bytes more optimally

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=103a0012580000
start commit:   98bd8b16ae57 Add linux-next specific files for 20251031
git tree:       linux-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=123a0012580000
console output: https://syzkaller.appspot.com/x/log.txt?x=143a0012580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=63d09725c93bcc1c
dashboard link: https://syzkaller.appspot.com/bug?extid=3686758660f980b402dc
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=176fc342580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10403f34580000

Reported-by: syzbot+3686758660f980b402dc@syzkaller.appspotmail.com
Fixes: 51311f045375 ("iomap: track pending read bytes more optimally")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
