Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3874D1CE71F
	for <linux-xfs@vger.kernel.org>; Sat, 14 Sep 2024 09:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726305665; cv=none; b=bm4lUSCaR9o7O+Kri8dcQ53kCkLegQmD/PrHCVoeRk67XiYVmNqd0M/2my5u95Otmq1TTOsFaEyeTcPXQF9asBn90Ju5D/aTXEW65RnMugF3Im/nt2r+Fh6vESpXYaXc+NH98Zjva8RthsitzjYqVm2n0ktitT7l/I5362EJ+OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726305665; c=relaxed/simple;
	bh=z5d/ggt3yfI97olGsHHbSMLccyXsRNVuW1KdhKDpsKA=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=prwaV8uRgYrGF46vz5FLhzNOE/mpQHI217Rt14elK1aEgqlzI7oZFb7edNG0A1SfcF3BWqdmu06cxLNsgFvZTAoBQgJR1eMHtRrWXBg8PQXLYUvkveZedUoerEklrt/TOy3R9xBSILPheGNevRu39XD5blGbiWv0l0cGwrx7mtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a0629ed658so58362995ab.1
        for <linux-xfs@vger.kernel.org>; Sat, 14 Sep 2024 02:21:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726305663; x=1726910463;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6nh+vMYDR40T13jEK9ffJJB+1B7wdqMgWUrcaG7M5Ko=;
        b=SVFoWUatB2GJybWf+4QYSm2TYKJfXV8r0uJG8x+br4EmRCrCllRFRnFiqPbz5/lADs
         Yzo8n1qADU5bkk83jcCDxvKIlV3gp9cFLzRVStPmVuqUs0BC/PsDTiNwnFYkBJDyrtuX
         bHIU9rPcpCUlgQi+5tlw1Q6mQocg7EUTN8Ggvs8q/csogbhPmeVvTw4w4D/uqX/QUlLY
         DcfuinZBV4l7grQxj9aFfg5fVlet9lUm9FecRRvgmHHp2RUSuBAuLwrdT6vC84cm2Gjl
         IJNXTpHhBylrpx3zV/gtZNqvHQcfCzTCcfyqHszs82soZ/pLXyhlsN/tys2RSyw3hztk
         F7cQ==
X-Forwarded-Encrypted: i=1; AJvYcCX1VxR98VzqSQx1xEBupLZv7pq1+W+KqllOouMfZWOaybNKR8lKfkf71sMZrNr48cVqnYQuRF9fmHA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwplSDF8D4RZjJdIqN+o8azO9mjQfABPPZSUbjzDAcGAyJwxELd
	Ag2zZv5jFhek/i3/2qryIuJPkhE3mmLXqYNg5L4+V1lmLYhwAWYHN7OQYAF9+BYYNgm78P02LCY
	d1m5o9nbtYOqreatMVbH/E3fmlueQqMFqjB5+eOQa7iplGIOUTw0cC8U=
X-Google-Smtp-Source: AGHT+IG9ui8jSh2Q9ot9S7bbxQ8NxRjmtemD8CF5RAJWqw5koDRdZ3z3kZV5tG9mDmbYI8QDCQ/AY/S/OOsj0S+29u7s9ohJ0WcZ
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c8d:b0:39f:797a:65f8 with SMTP id
 e9e14a558f8ab-3a084929ebdmr80280635ab.19.1726305663320; Sat, 14 Sep 2024
 02:21:03 -0700 (PDT)
Date: Sat, 14 Sep 2024 02:21:03 -0700
In-Reply-To: <20240914090051.636332-1-lizhi.xu@windriver.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66e5557f.050a0220.175489.0004.GAE@google.com>
Subject: Re: [syzbot] [xfs?] possible deadlock in xfs_can_free_eofblocks (2)
From: syzbot <syzbot+53d541c7b07d55a392ca@syzkaller.appspotmail.com>
To: chandan.babu@oracle.com, djwong@kernel.org, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, lizhi.xu@windriver.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+53d541c7b07d55a392ca@syzkaller.appspotmail.com
Tested-by: syzbot+53d541c7b07d55a392ca@syzkaller.appspotmail.com

Tested on:

commit:         b7718454 Merge tag 'pci-v6.11-fixes-4' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16e18407980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=709406cf7915cc0e
dashboard link: https://syzkaller.appspot.com/bug?extid=53d541c7b07d55a392ca
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=134350a9980000

Note: testing is done by a robot and is best-effort only.
