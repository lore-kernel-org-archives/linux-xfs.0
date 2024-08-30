Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6CA192D79
	for <linux-xfs@vger.kernel.org>; Fri, 30 Aug 2024 12:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725019447; cv=none; b=sn733tS1ygcwaOO7yqz6pg/HGpNhU8Nosxustf4WfH+ZJhaKmQeI9GRugOpp0l2FKuIGRRVW9Lnj9rTWieVYr/LrJMlv+hAymH2bEGj3p8h7uA1xdxOsBJOW+ouJvy7D2expMkQ83NgNRyox0/8sHgVq2/jezMDtMM2WYxdWQrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725019447; c=relaxed/simple;
	bh=LzYJkrUnXtqxg2sI+D1UMYC84BooZXybirjBd4noWGE=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=b1W/46N0BwG6aACDqN+jNcpscPqTK9WaS0+cU2iQ9C+0H/AqarhmM1ILVDAOM5FPT1Alq2aeMQRQyFbEt5uq7nNE9vtMt88BDhwrV1eTXC10WEs8zYFUC/WVaGrpn56nYz6e5llBzM86LzhdSkQXgbBrcU5aTJ/o115U9efvwXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-82a1c81b736so176017739f.1
        for <linux-xfs@vger.kernel.org>; Fri, 30 Aug 2024 05:04:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725019444; x=1725624244;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rHDsUT4NRjm0E62nv5pzyF9OkIWVCQzkDjrSQv8pAQQ=;
        b=fQm28gF8KI6U+uWw5CHARat8tqKByLg3MYLRuSEYVtq3D1VqIZKnN+4kd+2DcoTSOB
         g2VAksCyJ3/BcOIkTpQQBRITUeHPJuB0DvrZ0qjW+Wwf8JUR0BEhKMlVmJDl2t3tJmMF
         Kd8q8pJn2LOVm2vac1WUv/gtHTmYsxLZyyfegAP7LMPwb0UeUqLzNbkkDOGM2wmMBlWJ
         IdXTYX0sJo+FfCbzpUiKe9E+rI6lVfx+USg23OzsSuQ9yUIMN81mkJEcWDcFK8VpwC+/
         Ri5umnXkq2+sjfVfH3lfJ5R8eqORqUmyJqldh9fPFEcYqvsdTCbgH4V5I9q5CZo59DrV
         OR0w==
X-Forwarded-Encrypted: i=1; AJvYcCUeIwFux72VIEAZyrqyyaSBjoQzJxheDb7zgFGMIRRxpOXfFFw+yXLN2Y/hrwOEt1tW9qQ5oFAAzng=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2u6E5sdVwwvDCLUBDc4JdXfqtv8NutjzgbQiuXswhxKVGQbeH
	t1zyl8zOzgMg/O/iPrVZqJ9WBsYC095pXcoLd4uQQszDT6Wuu6qk7gXTWx9HM5sVAy46uamfNpf
	GJyusXDvt+rDzaq+2OEFW110rajM1VAezcGPHd9m/bNRf9115HcyJDEw=
X-Google-Smtp-Source: AGHT+IHkeMWqDAvDeGYJgg5YMOaQK7jdsKqdGcqreZ4lgwJEgGVi024TdtI8UpS+TYuDnfDMd5R10l/KDFcFhGhDgP0x6rTs28HB
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:8907:b0:4c0:838e:9fd1 with SMTP id
 8926c6da1cb9f-4d017ed76a4mr83432173.5.1725019443909; Fri, 30 Aug 2024
 05:04:03 -0700 (PDT)
Date: Fri, 30 Aug 2024 05:04:03 -0700
In-Reply-To: <20240830113130.165574-1-sunjunchao2870@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002f63ae0620e563e2@google.com>
Subject: Re: [syzbot] [iomap?] [xfs?] WARNING in iomap_write_begin
From: syzbot <syzbot+296b1c84b9cbf306e5a0@syzkaller.appspotmail.com>
To: brauner@kernel.org, chandan.babu@oracle.com, djwong@kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, sunjunchao2870@gmail.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+296b1c84b9cbf306e5a0@syzkaller.appspotmail.com
Tested-by: syzbot+296b1c84b9cbf306e5a0@syzkaller.appspotmail.com

Tested on:

commit:         ee9a43b7 Merge tag 'net-6.11-rc3' of git://git.kernel...
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=14a8e347980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9358cc4a2e37fd30
dashboard link: https://syzkaller.appspot.com/bug?extid=296b1c84b9cbf306e5a0
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=13101f8d980000

Note: testing is done by a robot and is best-effort only.
