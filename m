Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED081378D8D
	for <linux-xfs@vger.kernel.org>; Mon, 19 Jan 2026 15:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768835826; cv=none; b=ifXdWkelYfAcFPmPpD5uNBBXDptHHAb47DurJm7Ru9iFoqH2dBjNz5fFhcS93hD3oztQ3LVYPUf7Jk1C9wTbndpxvr9xyoI/chVs/ownTcmvCLIKAAn7XAnkg2y434m+NUCOlSIx7melIzUO8CN2yzjKwmW6gNUIuKQnM3A5PD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768835826; c=relaxed/simple;
	bh=xmeMG33KvxQU2SnXuN6Vj3+LxGEdXTsMcru4LUYM4A8=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=iOAH0IzdZz6+LJRVG1NvVTu/dopqoZvbqxva7Ae1Is8gW2x79Sb/YfT7zZm9WUbrNHtGTbvUTEHYdclh5XCcghSMI4rCplhsJJsrgJDWbCTlakns3q07rtGvCoMqmroJUlX2WdKy+A5iUq8ugKCK5lOHmjNoe4FaweaVSMLpoJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7ce1dd077bdso9282449a34.1
        for <linux-xfs@vger.kernel.org>; Mon, 19 Jan 2026 07:17:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768835822; x=1769440622;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5yY0RLKS8os/RR4JdW0hF3GgpSfUCcITuU/NkFyH4Eo=;
        b=A68to02gWnUEVkgJ+m1CGCO48y8tfrI8QD/AaQ5sXJ2Z/1n4hrTWxU8HD/rc+jxlyy
         ymQCrcdNoCC34zsPEGZTm+vYd5J94ZmIjpDTF9MAlvlVMp4Zr+X5V2Txc14nvIgd3rQc
         fOzZgYbud0Uk/26h2hyfZ1heoJYjcwnwiIL8WOSyGhOlsr8xCwwmwL/9fjzjxvl5YToK
         og6uhk/XbINrMnJ4V69UJ7IeZE0KMpyKTnzkkdk06JNPAsERE8qHV6IpO8FJtFJ5obYt
         ddpsfmH7adbE+5UCqchNOqKKM5NWyzO5TPtmQwq2vy+P6YQIWcs7zQc1gGRmcIIt/TAj
         rWgg==
X-Forwarded-Encrypted: i=1; AJvYcCXspOYAooZuEiRPKFELmt5BvVqoDGpvF14ozTTONc9Ef52iVQOgTcBtE9Tfu1zjiNF1nAvb9vzkTMg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5M1+oWEtNk11xa89uw3M4TME+zX09e12Ji5GQyTXsfoE/d/uA
	9zuCOljEEV95erty1DtN+z/6H1LN/Y2B2VOHbk9ys9h4IrPmCXt/StWqu4WifT7FluwTxd5J7jG
	jNf96LAqfRcfP7Td1QgYE6EX92T4Er2eeVpPlwfqP05oRaGKp/GD8iqK1F+s=
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4df0:b0:65e:e522:bf0a with SMTP id
 006d021491bc7-66117983ddcmr5176938eaf.36.1768835821794; Mon, 19 Jan 2026
 07:17:01 -0800 (PST)
Date: Mon, 19 Jan 2026 07:17:01 -0800
In-Reply-To: <aW5Do2YeRpq2IJZ_@infradead.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <696e4aed.050a0220.3390f1.004d.GAE@google.com>
Subject: Re: [syzbot] [xfs?] KASAN: slab-use-after-free Read in xfs_buf_rele (4)
From: syzbot <syzbot+0391d34e801643e2809b@syzkaller.appspotmail.com>
To: hch@infradead.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+0391d34e801643e2809b@syzkaller.appspotmail.com
Tested-by: syzbot+0391d34e801643e2809b@syzkaller.appspotmail.com

Tested on:

commit:         5dc79b07 disable lockdep
git tree:       git://git.infradead.org/users/hch/xfs.git xfs-buf-hash
console output: https://syzkaller.appspot.com/x/log.txt?x=16604bfc580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3433733714e92ec3
dashboard link: https://syzkaller.appspot.com/bug?extid=0391d34e801643e2809b
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
userspace arch: arm64

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
