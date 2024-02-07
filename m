Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B978C05
	for <linux-xfs@vger.kernel.org>; Wed,  7 Feb 2024 00:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707265446; cv=none; b=Z+oXgAQEMsISDdsknO0D+tL0PbWlBnneydljhDHuacH+EJDcL7aI98Te+ZXKjB7Ut+pw+F/hrvfx22V2eewzEiEnmVWwhQCb1QIlXIhuUf6NI4vGO+2DWH4NmQaUzk4zkVrLyK+RIL0Vb8uewyjt6QZoOrB25Up+LnM+or13L5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707265446; c=relaxed/simple;
	bh=FvGwLh3a2Cxs8K8H1nUa9MNxFNq9OpjLnn9QY7wF60c=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=aNNmwv5gjWe2Y9hYKq5fjb2ncT9ID6zY04Pn6Ksbui5wcm69ZbzTV1y2wxZB//HWxPBKR2xGghOxmcpLQK2893r7iZ6KBTA/+7XFWvwPJImQdt+Fk14jxP/G/T/3bYcg2BU9Om+YOQoCl/SkLRKdZfNky7m47NBGISOlr+nllpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7bf2a953988so7244539f.3
        for <linux-xfs@vger.kernel.org>; Tue, 06 Feb 2024 16:24:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707265444; x=1707870244;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t82BCGkmVQ9OM0x5g9ohFaasHwdqLaYvJRRmgTlXJ0w=;
        b=ww+IV3ZqrLfJ5eWldY/v9QWNDl2e0hP1uERkSNvaZuYXUc8IJ+Isc5EvZjUc4mizPH
         T01E9uLLh5NL6baB/JQkVY2JyvC1ujED2Y+Rcvpj/n0BoBj3zXYsLJLemkef9Cmu9HqN
         a3xlxp5oMM7LSqeKIpMsN1vgIdvMdPDpFpoMeMIL77Napl5XgiDSFUZzrjlGwOgS/J/E
         YvtJ8kpcSIpOOe6+y8aq65WbGzetplf14it+550lOcf3ZjPx+OnH61YWtn+biV4moGHC
         t1t5WdZVL0zzllPP0Wqx1eU6y4n3jInsPz40hMOITPcZdhV4At2GKeyviYfi91pv+BSw
         5r2A==
X-Gm-Message-State: AOJu0YxFxtpimTg9BkzQoG6N5pX/BR1ZL8zmwSRmYu+yDusrw/vSniRI
	Ovr9O9VkgE3IH1y2+dkj5iRpPPU7N1Zf5zDCvMJAFPnhMdNbdushexGiubHO4EfLz+6g7l2Q5aq
	5nOu7/gXMYDkD1KtSGdBSHDEsNFay02xgVJBJhl6ekaQ2FzO1ihXsX6E=
X-Google-Smtp-Source: AGHT+IGruLywxe70WptZVf6C5ihVm9XYYIv1NvmVukssSd+6s3ITylJhlf/9TmGmL8HB1YPW0wgOOD5Mz6wXVEVNOOqJiBnJIJs4
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1ca1:b0:363:ba7e:ddc0 with SMTP id
 x1-20020a056e021ca100b00363ba7eddc0mr225431ill.0.1707265444013; Tue, 06 Feb
 2024 16:24:04 -0800 (PST)
Date: Tue, 06 Feb 2024 16:24:04 -0800
In-Reply-To: <000000000000ffcb2e05fe9a445c@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000053ecb50610bfb6f0@google.com>
Subject: Re: [syzbot] [xfs?] WARNING: Reset corrupted AGFL on AG NUM. NUM
 blocks leaked. Please unmount and run xfs_repair.
From: syzbot <syzbot+9d0b0d54a8bd799f6ae4@syzkaller.appspotmail.com>
To: axboe@kernel.dk, brauner@kernel.org, chandan.babu@oracle.com, 
	david@fromorbit.com, dchinner@redhat.com, djwong@kernel.org, 
	ebiggers@kernel.org, hch@lst.de, jack@suse.cz, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, sandeen@sandeen.net, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit 6f861765464f43a71462d52026fbddfc858239a5
Author: Jan Kara <jack@suse.cz>
Date:   Wed Nov 1 17:43:10 2023 +0000

    fs: Block writes to mounted block devices

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1110ad7be80000
start commit:   40f71e7cd3c6 Merge tag 'net-6.4-rc7' of git://git.kernel.o..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=7ff8f87c7ab0e04e
dashboard link: https://syzkaller.appspot.com/bug?extid=9d0b0d54a8bd799f6ae4
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16ab4537280000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=148326ef280000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: fs: Block writes to mounted block devices

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
