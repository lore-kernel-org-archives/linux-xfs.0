Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96FCF35503C
	for <linux-xfs@vger.kernel.org>; Mon, 19 Jan 2026 09:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768814944; cv=none; b=mCTxXGbjcDaaZk67GZU6J3jib5DIZsvd+4ebaP0qwQUB4ev2EpG24O1TRMaB8FQ+GRYrtxuGHskYM1vboqXP+ZPbR/hJSV1RK0J371BqdmRZMszO+uyMYutRxgctpKPcHqb2SjUk2mycRG0qy2kLbw5TJj2DqC7Y5xhk3a5g9SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768814944; c=relaxed/simple;
	bh=KzD/DO9s97PK3wQim45Nr0UZ5dgmvMQwLfeLBtBrzkk=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=c/Bn3MWCke3kSM7+Yv5lkWVSWhWw2b3147gXwlMCbRu5tWb1aTf8kHpm7RpUmKIVLaK1eUhwKG97LSEhIdMycJ2PrNfxvMtp0eiMZhrvBxoVUgCK9Csv+XEefy2bZ186i+HkR3PtOymeCj6uItmpjmMrShyotP3BUpGKsEA4YLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-7cfcf550e23so4185570a34.2
        for <linux-xfs@vger.kernel.org>; Mon, 19 Jan 2026 01:29:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768814941; x=1769419741;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p3PtKB9K45KxXODXSn46X6W9ezFYyMHU6J6DqYHYNus=;
        b=DPJ4v2xwj+Z+5r7iyoFNn7Fi+veOkM1EmlgZl1dD3PFPmzHRN6XSjCYQDWEk1Y0rx8
         8eLZo0KjCpz6moFpLw2TQhgUsxIo6WpLFn01R/rY3h7uAnBSs3+HiA3oy11AffG+Gu61
         UqRAJarqm8fSkF8oiQ3t85H3gockWst1VX8SlmKEQdJ2WO/X4u95SsI0/8M6WhT3J/wS
         LYBX9b7qno/Km6ODH/GuDZAs5CjAbwCerv/lgnkrwDbROBdywm4TPa4qBm1IFtXS6FEy
         7yJAiuVWYY//ecAUh7yycKPdr0TgSbbsaQYGBy1C5wuGUCMgX/21PImnFROJcfCdu6Ap
         /5YA==
X-Forwarded-Encrypted: i=1; AJvYcCX1gP1du5KAwMkOuv6WFaWswnv+qg2uDXqLfJCCBhQgi42jWH2AHSdpytfSrA+BeF5Y6uwYTr+iiLk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwmnbHP25QLt3B+KeW8kJVzgkHujZVSLy1w8+47NSqySw4CLg+R
	G1bk9GPt0mQxUVRniaqheP83xfkvabgpD5IXyIxuylMc0n/OkneufK+FIWC3eIuYLsfh8U4B765
	HvWABTCTKZVtJ+WwXXwDhuHSkYl3BEOQ0vOjLGajanvmMZUGSolmY5NMkjSw=
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4c06:b0:659:9a49:8e54 with SMTP id
 006d021491bc7-661188e2502mr4546639eaf.36.1768814941508; Mon, 19 Jan 2026
 01:29:01 -0800 (PST)
Date: Mon, 19 Jan 2026 01:29:01 -0800
In-Reply-To: <aW3zct8OHdx5QJpG@infradead.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <696df95d.050a0220.3390f1.0045.GAE@google.com>
Subject: Re: [syzbot] [xfs?] KASAN: slab-use-after-free Read in xfs_buf_rele (4)
From: syzbot <syzbot+0391d34e801643e2809b@syzkaller.appspotmail.com>
To: hch@infradead.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

./include/linux/srcu.h:197:2: error: call to undeclared function 'lock_sync'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
./include/linux/semaphore.h:52:28: error: field designator 'name' does not refer to any field in type 'struct lockdep_map'
./include/linux/semaphore.h:52:28: error: field designator 'wait_type_inner' does not refer to any field in type 'struct lockdep_map'


Tested on:

commit:         9f73447f disable lockdep
git tree:       git://git.infradead.org/users/hch/xfs.git xfs-buf-hash
kernel config:  https://syzkaller.appspot.com/x/.config?x=8c5ac3d8b8abfcb
dashboard link: https://syzkaller.appspot.com/bug?extid=0391d34e801643e2809b
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
userspace arch: arm64

Note: no patches were applied.
