Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0319717988
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2024 08:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706086212; cv=none; b=PwbVcTOOKf2nBpQEFBXH4Y4eUasl78LzdTYfPS5CZjAjgU5wTdMMSRNs+RC1RM76uGSTPt52s6S3tYLlkqhGLG0dN++hzoxXq4VAY0Z+Gooh1TkiFg6hYC9j1mDeV8gsoHLtj51MxYWVcDNloGNDxzwgKkwI5beg41Ye/AMrqSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706086212; c=relaxed/simple;
	bh=5SRGXfUtzcx4CHNTX1CcNoOlAEBV5500++BZdb1Q86k=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=YUMjg9U9HVFZwpF6T1aAit+JCv8TYcQIm9npxri9AdpX9n88f1TUF0TLKu/2N773jB04404bJmtolCYSdp5lyp0Cn1JomGeDIyW+RTjUw7YKBv26X7hkJr1y/LroTtWKq43EaRb8EJBeOj8uOYxXE2m0yOgGZLb2TBwENsqeuZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-361a800f629so42995575ab.1
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2024 00:50:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706086210; x=1706691010;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cRSbUiiNcXaQ+lmznn7ZLwAAFNsMsOx+iXxoA2C4u2k=;
        b=Q7grE45jxn0UmkjGSEvUIaWcrLZSweTmqqk+TSFkUl+HQTsgqZOfDsGGWt0xsXd/Q4
         8OvvbsLYiXcBDMhlbxQg8hHH3cwox0Z+wibhk6Hipx0tacei9Yidvc9PrDIpH+TjGZMU
         w5y2mnXH/uw3Tc3WGOH0xNHZfPuyP9qgTwnhB+GjgNHkA2mH64cxsGj5BWJ+vOVQSxAo
         pwKuZf9Yu60hxjH9NM9ewM9G3DzOuVvfZrO7bA+b8aI556IY1Dkcdvd/I3RDiGBSPF21
         FA+SCc5Zj0pNvio0iQ5RJJ6WTXY84pdzmzBOEuj5wHwnBFt0cP46LrNK9atr1wQOKw6S
         sPbg==
X-Gm-Message-State: AOJu0YzPO+z/ViPtYvKybAH550bbNkuiC7wl29N8Po5IYhsGdhoHeWgq
	N6i7g9F2jtbprDFwqnCqc/e+Agh265UYYT/YB0PEgXaVknl/57oHGGgsY6hIKVie/4epUmLqNsA
	0sMkc0kcFocl0jHobEb48pDs1GVyM7fJw9p8toZ/Dxdw9J2RF62MuWSo=
X-Google-Smtp-Source: AGHT+IGmS5JwVqumT9uCpn/1NCTHaiv9XrPDAljw1ESdj/EbdOddxKHG86bIuSNbGY3kyp3Yv089DYfxmtQvC/kJ6C1mPCi85Rjz
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3202:b0:360:96fd:f542 with SMTP id
 cd2-20020a056e02320200b0036096fdf542mr150429ilb.1.1706086210249; Wed, 24 Jan
 2024 00:50:10 -0800 (PST)
Date: Wed, 24 Jan 2024 00:50:10 -0800
In-Reply-To: <000000000000d207ef05f7790759@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000084a9da060fad26bf@google.com>
Subject: Re: [syzbot] [xfs?] KASAN: null-ptr-deref Write in xfs_filestream_select_ag
From: syzbot <syzbot+87466712bb342796810a@syzkaller.appspotmail.com>
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

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=119af36be80000
start commit:   17214b70a159 Merge tag 'fsverity-for-linus' of git://git.k..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=d40f6d44826f6cf7
dashboard link: https://syzkaller.appspot.com/bug?extid=87466712bb342796810a
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1492946ac80000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12e45ad6c80000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: fs: Block writes to mounted block devices

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
