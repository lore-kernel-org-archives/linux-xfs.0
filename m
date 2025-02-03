Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40C31FAC23
	for <linux-xfs@vger.kernel.org>; Mon,  3 Feb 2025 08:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738571765; cv=none; b=mYGqX8UNzJPgKD2tpvstjtHGTkb12995d9c/z+2oLLxweTStDNEXljYyTK07+3Wh0hh0c/FaAU5YRHHGQHNnX0cEH53QGkwMqVHfHbZnoPkAWbgPNg0i8rmhBM0azRoTYtWIPiz3cd3VNdgDCA+NGi+cDBR2I3+yIon3Q6jbEBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738571765; c=relaxed/simple;
	bh=nLMQUiJrSymcoOK6tOhS/3Kpg+i2oTL/2JaG2kvtitA=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=i3sxz4o4oCOEaJQivav8p4Cb8krfr5sJ5qaE4um6vw1+vZ0AxuHbdviJeY2IrTwC0kupwJ7m5BXxcvk7IU+fZwnpR29gm/nyTZPIIgYZ4m3AiLAK9QKmaxlVpqRkmxiKHpZxTPLnCgHCzBcldj8w8Vev8FWR50KSZXU7u/SkVVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3cffe6b867fso58872075ab.2
        for <linux-xfs@vger.kernel.org>; Mon, 03 Feb 2025 00:36:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738571762; x=1739176562;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VqGhZb9IpC/7mhlJOWcHHHeqT/g/+3pVvwtNgr1D9Lg=;
        b=py41QfPUgVRFzNAS1c6J539daa0EMLizRnTTF2i/bfzI/9l/36+qOEuI8Fw6SzbkyS
         E+BDFdIOWXtiA5cduxXtX4/qlAP2kpnTXZLt5Sf4jucuvWGXLDPRtSAoPXsdBm5a1M12
         TsL66HeC8so10z3VdX9SH88P09DemhxCn8hu4Q0Dub3hD0bngcZ6hjJvJH9DCARxqdoM
         3VW9Jqi94C9GttXa6rmyiLfoyYdDcySvHEgpmMPQnyxRPDHDe3wgNjvGo+hyatmKRKH5
         5eCTbF86gbNySl6mwWUOCxptyFS01h8rUZMZv6LfTs/GQJ4JI/U/bah5dbZI7+6V7fRS
         RTww==
X-Forwarded-Encrypted: i=1; AJvYcCXDS3LLP5aIvA321XQfuLZyYb48QZLvQ84/vZ9N2kLijJhfyuEVGhX9bdpfE/91ugpDVOcU2mqStdM=@vger.kernel.org
X-Gm-Message-State: AOJu0YytkdQDj6jmEf8KM98ZS1/brU74nODkJp4WFI6P3KgPU0FIG82+
	3VDBI4RB84TkKvU99Ms48B6b8YQjwTwzRcLQR0OmGgGE2POaMAaRcGDnObZ/YtmsPKqp+66ancp
	DRbMsDCKFXUJqUu2OpqbsE7gbWHQCHMnIgJ2BqQEeYnihBKti3N2YedQ=
X-Google-Smtp-Source: AGHT+IHVErUDQLWNOHaR37ANcNaoG/nlsP5RgLvFdM1LGhzcflOEYIdHUQHEcK99wqFvTNv3b9z7bPqxsb+/N3EpKVcoBFy4h1Df
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:490c:b0:3d0:28fe:2008 with SMTP id
 e9e14a558f8ab-3d028fe23b3mr43149425ab.19.1738571762665; Mon, 03 Feb 2025
 00:36:02 -0800 (PST)
Date: Mon, 03 Feb 2025 00:36:02 -0800
In-Reply-To: <20250203080720.GA18459@lst.de>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67a07ff2.050a0220.163cdc.003e.GAE@google.com>
Subject: Re: [syzbot] [xfs?] possible deadlock in xfs_buf_find_insert
From: syzbot <syzbot+acb56162aef712929d3f@syzkaller.appspotmail.com>
To: cem@kernel.org, chandan.babu@oracle.com, djwong@kernel.org, hch@lst.de, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+acb56162aef712929d3f@syzkaller.appspotmail.com
Tested-by: syzbot+acb56162aef712929d3f@syzkaller.appspotmail.com

Tested on:

commit:         2014c95a Linux 6.14-rc1
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=10fa43df980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=793f583a4388e6da
dashboard link: https://syzkaller.appspot.com/bug?extid=acb56162aef712929d3f
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=12b3b5f8580000

Note: testing is done by a robot and is best-effort only.
