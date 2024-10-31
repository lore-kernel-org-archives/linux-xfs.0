Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B2619DF75
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 13:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730381885; cv=none; b=FfaTKBfVBwMIZOTvOj/DCnutXZ8Rh1TBlaeOiYn3l4ANpMuB8QlirCnAIs6V6JNRgsY5oe/1vNroJp/9lIdu9SwIKq9v4xkFRHK9067euflBV+2WRzGsDERLVw4wWKHQbJyTXnoa2pqLV5muZwyylDDMw89P2TaNWppV2v6W4nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730381885; c=relaxed/simple;
	bh=m8js9PKWrGpGx/94c0m/t/kG4l17mJ472kJ3T9476rQ=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=HHaCC1Gly4T1CCShFaBiFPsxRM1vX6iosneAiLXRl8N6QzePe9+UsLyMrPnP13NEWlmnmgc+JDJnRoWMCCzbmNf5qLr6++pmie4MH5GMUSAh7iknnbe3lF4q7alNKXtcfSagIsXT9mxZPLNHG4Z0A166zjskYzqvyRI1xKt9ErI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a4f32b0007so7751635ab.1
        for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 06:38:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730381882; x=1730986682;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z2wb21YsWwCYTNPoCuhRPi219SLTEoWZUiwx8XtsEeA=;
        b=pDHZk41eirI7KRmNb1iN1e6A0m58AbilbiA8erhMwK+WqA7uMSC+Kj3QAgXbvinUTV
         cU32tTC5gq9UAhexr4gWz+CshBV6TYwJh82oHLiSg2cIxEHWK3bVkFEcsOfk2vf7fLFF
         +lFP+NKCRvJWCuS5rZerh7gGYh1cGVTnaaRlAKdtzP2DyTYjw8x7Sc4WLLY9eAH23yC8
         n8c8n8PpoYjaJahI4gcsxktQv5MVUnIlfXw2dHWMUVWUrpNXna1Q//wiQ2vc9QGSzg44
         tfj0Y1N6h7EZ3ZJfRpymhaYIKrvrEAyPc2+Yjpx8QEUirQmzfWcf24aScjtwwYhZtLsY
         bnng==
X-Forwarded-Encrypted: i=1; AJvYcCV6Ry8UFabJig28VsB5YzXCZqwdxbbZ86vRyikfUlEPYzveS6AVEgMkpBftu7QWdwuwdm+iAgMWlhw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwWtzb35e1tW0BiXjIzrLe+IeQfBJgT8lS/NQO3xDzPOteATYxc
	f9YiM9pQ3ZmNz50Ih8ZDA8QLNPa4fYSuNJDH6MQyCnELifM6eN3qKPe5fZ5f0jG75LXwa1+T6wj
	xZkFCceQ9KK0hN6cNaKDo5ZtDIKUX5j6ZdnPcay63kwzEwI2Uiw2SYwk=
X-Google-Smtp-Source: AGHT+IE5AIK7chWjS9Qwruux0+MNbD0t873UJxKTJhPolIL7YKITplTj5kAbNAFrJUQcFTBg6qRbpSHAOE1fNivkZ+r2aqTjy8NZ
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1aa8:b0:3a3:f86f:2d0f with SMTP id
 e9e14a558f8ab-3a609a2add2mr39984325ab.3.1730381882619; Thu, 31 Oct 2024
 06:38:02 -0700 (PDT)
Date: Thu, 31 Oct 2024 06:38:02 -0700
In-Reply-To: <000000000000e6432a06046c96a5@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6723883a.050a0220.35b515.015f.GAE@google.com>
Subject: Re: [syzbot] [fs] INFO: task hung in __fdget_pos (4)
From: syzbot <syzbot+e245f0516ee625aaa412@syzkaller.appspotmail.com>
To: axboe@kernel.dk, brauner@kernel.org, david@fromorbit.com, 
	djwong@kernel.org, jack@suse.cz, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, llvm@lists.linux.dev, 
	mjguzik@gmail.com, nathan@kernel.org, ndesaulniers@google.com, 
	nogikh@google.com, syzkaller-bugs@googlegroups.com, trix@redhat.com, 
	tytso@mit.edu, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit 6f861765464f43a71462d52026fbddfc858239a5
Author: Jan Kara <jack@suse.cz>
Date:   Wed Nov 1 17:43:10 2023 +0000

    fs: Block writes to mounted block devices

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11fc5540580000
start commit:   3b47bc037bd4 Merge tag 'pinctrl-v6.7-2' of git://git.kerne..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=c2c74446ab4f0028
dashboard link: https://syzkaller.appspot.com/bug?extid=e245f0516ee625aaa412
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11026e54e80000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: fs: Block writes to mounted block devices

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
