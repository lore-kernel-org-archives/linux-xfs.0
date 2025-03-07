Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89703219EA0
	for <linux-xfs@vger.kernel.org>; Fri,  7 Mar 2025 16:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741366145; cv=none; b=WeZJ5ZFJeKJG2CmVGkw+NI5dwHPIkgP5SZEaJGEXWedW9g7RXCKBSWxlIeOoDOLMvUEnWV20LRvJG5tBuBibsVUk9euJ18Nj3TNKzaQfDY+YUmfyKnO8ohDMJCEHyx2ZS5iVOCSdxehZwkv/KYgdspKHmaLvNHIG6FeekGAexb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741366145; c=relaxed/simple;
	bh=/wJpuBYFGqyGsKcbfLoTIr0DnUogrkKUH5AuAlKld8E=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=ZW8x1Hwx4wNyaaA0l1R7UHQsOsfXKaaxCpeGK2fB/YfkRzSuHoXgrE/GG6W1tZdmjBe59GAwYo5RYim3lpO6Bg/eDtmg4DJ7QBC9gsuZ6ozeSaUt8pk5MTPX/qdNZUv1fPIMIwBz+vvkQ0YICcNEbFgXyhhf44KJkVndMpLtoGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3d443811f04so6932185ab.1
        for <linux-xfs@vger.kernel.org>; Fri, 07 Mar 2025 08:49:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741366142; x=1741970942;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IStmfP5lSAveeL/IsEub3Jooz8LSUrjwYZpqh/aSwSc=;
        b=TAa0j5Sv0TgGxDXps5Ib1JqA/rjmfHkz2avgOL2GWEmzvOV3nZBaQcr5P/8D62yzL9
         hM1xytc5lOq2jkyD7fZZ5EByd+WJ0A3gVWs27eOQAKY3RsguAYPmhlFGxDUHLkYP2gKY
         MNPadB+96R4Kep42rc3GH5vEexAAd1dZ8xPiDLhYL1AmNMGQEj0OyMbRojZw2Q7EjrQm
         oIBVtWTn+GlRRL9N/YVueKANFKs0HmPiODyTGRQgMFA41dGq6Yf2Nkt7dKTzgO/TJzcm
         CeOCD4kbhnbwq5N/GZ9BRi2e3dF9ZQiwxoDH3u5PS8zdCee7y8bgM/PzT2RT+UV9EXOC
         q7wQ==
X-Forwarded-Encrypted: i=1; AJvYcCU7H+HR2lOIDAeuvIWPuZpCkyLpd6uobSiF5HfjrbkU2Ir4nDpM+sbkTxP7M6jj7SCtx3X9wAgEHTc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4dLhW4/PuiEjZzHwW7MN0BpIPF9DYFPyxk9H88GayviYIaevo
	0SDhnLiSrUaqXU7TuiDOoRUgZcM0o2iDcV0D/DWb4A7g8QfG5HjEGWUMF23G06TuKUyQgsGbLDQ
	+CcK90Vgu4YMDeI8x9gHksQVhe4buVcC9RuAPyTvWqdrxcUzu0jpJ+Zw=
X-Google-Smtp-Source: AGHT+IEQEA3LcE1eWTG3gvh0ZwCgkrms9t2GE5rGU0lzz95rIXyhA51eK+YLb5oJtrQ5onsKI2ZsJZJE+ZXfTS9GGEQJuyO9T+Vh
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:174b:b0:3a7:820c:180a with SMTP id
 e9e14a558f8ab-3d441a12ce3mr52846825ab.19.1741366142691; Fri, 07 Mar 2025
 08:49:02 -0800 (PST)
Date: Fri, 07 Mar 2025 08:49:02 -0800
In-Reply-To: <CAOQ4uxjxbhJPDCBnuMMmkPchFiDOwX82-35jbhbrQkbp2Rsy6g@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67cb237e.050a0220.15b4b9.0083.GAE@google.com>
Subject: Re: [syzbot] [xfs?] WARNING in fsnotify_file_area_perm
From: syzbot <syzbot+7229071b47908b19d5b7@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, amir73il@gmail.com, axboe@kernel.dk, 
	brauner@kernel.org, cem@kernel.org, chandan.babu@oracle.com, 
	djwong@kernel.org, jack@suse.cz, josef@toxicpanda.com, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+7229071b47908b19d5b7@syzkaller.appspotmail.com
Tested-by: syzbot+7229071b47908b19d5b7@syzkaller.appspotmail.com

Tested on:

commit:         ea33db4d fsnotify: avoid possible deadlock with HSM ho..
git tree:       https://github.com/amir73il/linux fsnotify-fixes
console output: https://syzkaller.appspot.com/x/log.txt?x=12494878580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=afb3000d0159783f
dashboard link: https://syzkaller.appspot.com/bug?extid=7229071b47908b19d5b7
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
