Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 399662D77FE
	for <linux-xfs@vger.kernel.org>; Wed,  3 Sep 2025 06:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756879455; cv=none; b=jgURFSiDxOeNm88dDe/Z5ORlR4gdEttmcHpY6TCfKyCAtwjDW2mZiY2BLcPaiplDu4mGffAeJhTk7pa34m/SbyKkPETD4jwK4hCAaVxKY9mZMxvQiiXLKixLGaN4yQHcT0ucp0ZVZG257FnSRQb1j/QuTYlBCrDRz19motO57Do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756879455; c=relaxed/simple;
	bh=pwP5ewIrHo3p9vhx09GxG9320nyXHCTGwSq1UycDJEY=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=a8lc0qZinmpjIghe0XGixhnm33eOaUFsVQrqyscc0bDdUPDGkbpaYjRqZZb88DKwg0d8gboBK8KWn7T4CGT4mqIj/0HCMDJ7cDJq64+K7pDHX1uviKdRHkVIkxfhHQYD54w5X/bCL/GbG5mNsu/WIgyhqc5QfGlwFpF9xQug5hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3f4ebcbf96dso34746195ab.1
        for <linux-xfs@vger.kernel.org>; Tue, 02 Sep 2025 23:04:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756879453; x=1757484253;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pwP5ewIrHo3p9vhx09GxG9320nyXHCTGwSq1UycDJEY=;
        b=MRk+Pjh70EnFD61F96O6cHscWchtRD/SaN/nLqUmlQycawmAridWbFixiJ+rEelZfx
         tuLfOwvki/mJBAwJOH8RbSJ40kpjm0xwv1mzm54VkJvHK9FyXa3wTiniRr01yWVEHHcS
         DDYrIgw3o/C++GQtXqrZCe4PiJ6tgrRZK584H9Awz6XSUCnrIDZV3MM5ksbh16KtMhr4
         RqwM4oCFEMyao0i2uSJVahQPbRkEc0Sli+llWV4YRPq4b7cZ/oyQ9rRt93yV1nTcpal9
         If+uCfXj3rXnEZ5KCAdZrU+WIoFgmLhhjhbybb+iAslVeZ1FU33ixDyxaAQaRdZraYwQ
         5e/Q==
X-Forwarded-Encrypted: i=1; AJvYcCViJkbOLDibq0qVZs3Ta2SrMrZyo3ZgPFEuue9MeEltMnTL4flLglTqkOnkxcQI9mqKQcXXH2nNcVg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy32U91Xf62zp9Qm3tt8E59TaiOYL4P/Kxn7cj626Y86vCkYyFX
	PcORuU9nltbjJUDE7QfQVPGsc5JvD+Uo4fgNA+X4VkoVI/TDM0usnyCfsa+tPFbbB6nM5mN3YhC
	A2FF3PbfGK0poVLdItS97WqGGeBXjsmS3f9jgCmoYBzhAuKwFoZbhWUogqug=
X-Google-Smtp-Source: AGHT+IEt6ZqiWWXxUWxDmlgK0/HVBVIHLncOIb0H6+F+B6N+xFAkygcb5Aaby3CE0mrnU2dZfc/kxoUv4gE8ixOJmMChKqZoxTS2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2504:b0:3eb:f2eb:6037 with SMTP id
 e9e14a558f8ab-3f400286788mr250289885ab.12.1756879453388; Tue, 02 Sep 2025
 23:04:13 -0700 (PDT)
Date: Tue, 02 Sep 2025 23:04:13 -0700
In-Reply-To: <aLfaWUYaqDk1d85i@infradead.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68b7da5d.050a0220.3db4df.01e7.GAE@google.com>
Subject: Re: [syzbot] [xfs?] WARNING in xfs_trans_alloc
From: syzbot <syzbot+ab02e4744b96de7d3499@syzkaller.appspotmail.com>
To: hch@infradead.org
Cc: cem@kernel.org, hch@infradead.org, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

> #syz test v6.17-rc4

want either no args or 2 args (repo, branch), got 1

>
