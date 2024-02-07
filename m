Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1351CD1E
	for <linux-xfs@vger.kernel.org>; Wed,  7 Feb 2024 06:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707285727; cv=none; b=RXUhZ/u+rnTg9g1++P95/lDdOvQj+MoukBEYr868NX/2E9v8C/Z2Ur8+iDxoz9kAsrbF/euLM2ighRwZbSAO1AARmqqzSRKl2qGT+cWGBtp9mFpXi8Spl62IZXKqkCTEdnnLe74X0Zuox5UvfQRTFEp3kVcS65SGNsKma3DmBtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707285727; c=relaxed/simple;
	bh=W19/zAXKBnDkLw1UIPDhY+WYdjbLhcPYZmVYQEr3zEU=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=H2Xfn9nXc4ENugTKGl/EuYa4gDzK/6x5lNXdi1VJhzWKUtVzRMsTMux5sb6ZcEajI2B8ww//OhAVD7dU5e3c1ZfW1VF8uqVa1qR6g9S8l3aivcKP6+Fs7EYLh0qk0WqAZYXkyRQzfwDdKM6/+j1XuvZUfOeTaqHmUxssY7j3r8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7c02ed38aa5so19292839f.3
        for <linux-xfs@vger.kernel.org>; Tue, 06 Feb 2024 22:02:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707285725; x=1707890525;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SZ1gCDcb+RtG3f11aogn1DQnpz/Zdh4uxrx+5jZ2eQg=;
        b=YBAxk5DD8WBUbWMT92b+SXVejbYM/jSx4J8jPJbCGtbip5BjX60nOvrga+ZNrzVk5p
         Mu6Mu8bNWqmFVRqB16futUUquYrMjyu+XgmyGxc4o1Cp3Fz017DdmIMQ4BMjblrlBIJd
         hqUVx3lrtcIvWdDIi1lWPz4ToIkMK3TF+zTcVB5H7vzqegiQbh3uWImNwLuMtxI6OsuM
         yw6PTHCwRMPjAUqqoHzXD75zvfEFmKp/CFtpG5Vo75Q/hZTXM8gQUdFZnMSL21PiPjl7
         8N3fHZytE+HnG7KTHi1Cdrqtjxd2Uh/8sNf1ZlZheqxw30BQQ4JNkbPPBjBct5Oufj/E
         5kVg==
X-Gm-Message-State: AOJu0YzU+wlbW4t7mFEF7Guc8HlT2/FC5td35Cc+svz+QtuXySV6pteG
	p1iM3AKE2oyfJ92+0yqo+SwYLx69557HTwq6n5wTsjXE9SRUUNhVrB2QNz1fSyHCqYa7GbYftW9
	z4TxEL/RF4f7sZsBTh0tlL6DrbDjFN/SJnxp7vWamvD5U6NK3W1SIHXw=
X-Google-Smtp-Source: AGHT+IGS3g4uJC9tM7VOBdG4+aYdZLltLW1qPFOR9ZIHza5GYhX73zd2xr+AUSSKHy0O0ytRUwYF3rbHoO1LHl1ONfWMu0QPh1GY
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1586:b0:7c2:cc50:c70b with SMTP id
 e6-20020a056602158600b007c2cc50c70bmr206826iow.1.1707285725505; Tue, 06 Feb
 2024 22:02:05 -0800 (PST)
Date: Tue, 06 Feb 2024 22:02:05 -0800
In-Reply-To: <0000000000001bebd305ee5cd30e@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000032f84a0610c46f89@google.com>
Subject: Re: [syzbot] [xfs?] WARNING in xfs_bmapi_convert_delalloc
From: syzbot <syzbot+53b443b5c64221ee8bad@syzkaller.appspotmail.com>
To: axboe@kernel.dk, brauner@kernel.org, chandan.babu@oracle.com, 
	dchinner@redhat.com, djwong@kernel.org, jack@suse.cz, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit 6f861765464f43a71462d52026fbddfc858239a5
Author: Jan Kara <jack@suse.cz>
Date:   Wed Nov 1 17:43:10 2023 +0000

    fs: Block writes to mounted block devices

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12b0ad7be80000
start commit:   e8c127b05766 Merge tag 'net-6.6-rc6' of git://git.kernel.o..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=11e478e28144788c
dashboard link: https://syzkaller.appspot.com/bug?extid=53b443b5c64221ee8bad
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14a6f291680000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=116bc355680000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: fs: Block writes to mounted block devices

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
