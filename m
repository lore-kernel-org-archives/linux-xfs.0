Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D1C2AC17
	for <linux-xfs@vger.kernel.org>; Sun, 17 Nov 2024 12:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731847985; cv=none; b=trnoNu9WSQ0WxlQhwlZxvRDMEn33TjilL7wXWau/yOSwWptnKYRcXBNrgBf8K+6m60/kUzcvfu51KoSa8lrRK9h9H/9TJfZ1kK3rAIVxz6tkouxggKv//Qe2R6iKrWuxGWTPEDPOnYXbgwcwwQS8LADkSO6+8eCIlJaVS//ZuOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731847985; c=relaxed/simple;
	bh=XrRdWMJXBrdN4f/8l6l7kAcSLbQ0kZAZKwgyHlkcuwI=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=oEwnJrWRzBdB7E0CkfzeDrvii+Gkt0pUIw4seKZIyyq3MHxm8Y4Gbin8/MmfvWQNkzZCy69hB348JE0pJeekG1v0kun2MUDFq90lKvn/2VQeSd25mVMpzaJJ1NYyg5alBElzpXFoK2n3sBkYM+dqB8uLx7/9ioZgQvvdPZGohQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a743d76ed9so24560045ab.0
        for <linux-xfs@vger.kernel.org>; Sun, 17 Nov 2024 04:53:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731847983; x=1732452783;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VQFhShpCFFfqPZwz2aZH0sjh2uJyuJz+k8kyZhQ1m2E=;
        b=s2QK3bOwYD400Y5YZJRtze0CaSJQV3XvV2mqBeIqf51XucaDMswNvt/BVwKFIn2a0s
         rIzEC0heWD1E37W04s83g9N7tUM5Y0BUrTTud0iVaepSPHOg2hF9kstAE0NIj27BNGg8
         aV2j3R/Xc9pfkATT4yJ+3SHrnqnTC5ZxfiA4rdo7A4G9JqhuCUbBwgI/8ru4HjnXJL+3
         GO5o5jeJEQsL3N5+XLpiog6HY1ZexxTbWj7uGh4iFiQYpQ1RClznNyuQXqL6OvwKNCcs
         f4JBE7QcZuqXrmjPkpdJMqKXkPw1UxLcypfjgErVDxJE9WuaaaRybikk+2LchYXb7uqU
         YOMg==
X-Forwarded-Encrypted: i=1; AJvYcCVNj9Fj618cPgjAXdpsZBlL9jMez34CEdwzDmqRy0j//BvsidGdbQDXRVhWEY1TdDoNzO0varsPpKo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7okMfQTMNYKceARzSeOQqQu6ZRyqRT9un8EPf2eNb4dmO44zL
	9jDYsiqN0up+Km6IN5BeHtwc8tumx7afUFQAsS6hhFQ5FepROmALmg3XwYvWGhBTN4bVbJdsFvF
	UDp6LcvMGBtB5iNWgPWmUqhiM/6QpTic4i6TZgpPiTVtmtGPTBCr6Sgc=
X-Google-Smtp-Source: AGHT+IHH42tRIhFkR/AgZmPHwUk0sE72aX9yFGbSTU9HuCw52hfPuXvwon0zb3cTuC/NEMyQeriJMsyFdp7bupcvK2YJp/vVZLtN
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:dcc6:0:b0:3a7:47ff:546a with SMTP id
 e9e14a558f8ab-3a747ff559bmr70003765ab.0.1731847983117; Sun, 17 Nov 2024
 04:53:03 -0800 (PST)
Date: Sun, 17 Nov 2024 04:53:03 -0800
In-Reply-To: <79b938a8-ecb9-4d3a-b1a3-76f1a9c9f351@linux.alibaba.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6739e72f.050a0220.e1c64.0014.GAE@google.com>
Subject: Re: [syzbot] [iomap?] [erofs?] WARNING in iomap_iter (4)
From: syzbot <syzbot+6c0b301317aa0156f9eb@syzkaller.appspotmail.com>
To: brauner@kernel.org, chao@kernel.org, djwong@kernel.org, hch@infradead.org, 
	hsiangkao@linux.alibaba.com, linux-erofs@lists.ozlabs.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com, xiang@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+6c0b301317aa0156f9eb@syzkaller.appspotmail.com
Tested-by: syzbot+6c0b301317aa0156f9eb@syzkaller.appspotmail.com

Tested on:

commit:         2795294b erofs: handle NONHEAD !delta[1] lclusters gra..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git dev-test
console output: https://syzkaller.appspot.com/x/log.txt?x=1058db5f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=921b01cbfd887a9b
dashboard link: https://syzkaller.appspot.com/bug?extid=6c0b301317aa0156f9eb
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
