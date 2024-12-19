Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410F617580
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 01:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734570427; cv=none; b=Px3ZTbHHZ/CVTZRjTYfIUlZigth844mDSr6tsMDhs6UDtWiXRfb3SRJhGCahKDh8n/UF6rh4FFElHppsH1I0uCr4oKqRqYWb8gAgMLmmHJzDyrzCKlKLqkLUzrJ2IgqmUkgBHTAUMW+dyu09A3Yuh+MT+cKN87gJX/mKLwelmAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734570427; c=relaxed/simple;
	bh=fbV7XPqcUR5juGh1dODL6rHG0vJI4xQd2R7hEQ5ke24=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=f8cL2aOw6lGchseLvhVarQob0rPG74VJLa8pnFOfWBLX+Q++yQ75jEBhLw/2Eo65ULhOTyMnbFexl6OyS1R+rYYwU0CcphXDxAg+B/RTufNGuXvJXBjtTgMbK05cmA1rIwlODvrYxvjAXSr0iHsbbAEnmvpv6s02M/Iln+oNqVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a812f562bbso4802485ab.1
        for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 17:07:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734570425; x=1735175225;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rTb8flnD9tX7x7vUPqZAUIsEklofbVmlglCs8iH+TK0=;
        b=JAMULbQczcaDuAKmb2sgA8rayesPtjn/GQwR5oLknCI+s5t2X3PsneiF461dJA/srT
         GFXcHSOrNJMLcYj+nzKjTPw8zvIGTVQB66G39GSy9xiJTh7M1mJrXuy3CBwKPOKfD3e1
         jsZTCzX2SHqlZFs5e6EjXmAifcv4VaRaJfBYbNFFuimd6UrVPaPaItojDNbOat4bmOwc
         9609r/HGOvZidWeCUT82Iyv9dsF5t9Xx22bsJpcUvA7np1+WhP6fLoVM98Y2e4k7GZsw
         5Lk4v9U3+yxDaPeroD9ugrTVoxfs4VNDtkhNDEOJALo6mTfcOTK+oQYo7sHimpTKrkdF
         uZpQ==
X-Forwarded-Encrypted: i=1; AJvYcCUEdJPft2oOOXIpVoXvGQM3M1kCqxcKQfbiHYHElR5Ay/3ajMvcXzZ2agNiPJVpZ2osZ5w2+mH8GYk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQyghbZQDl5uWSsIKNek21Ej6DLKOXJSZWhF2IrzzMThmHnuXb
	KNE0yUUcY7QZELhj/mJdak7HB/Iq/H6CWoeauKeC8MM8Dz1VelSAoae0XprB+EghMO1dFOZzt3s
	4v+9blmAzMFbWikvP3M2lw6FpeakNPN6KZmKFi6UGxcpWEDVUrMreFMM=
X-Google-Smtp-Source: AGHT+IHtGLIdZYCIhGCWiz+ZylznNHX9D0JrOXfADTFqTZ65RELfxbKPYZfSokm6uOM9E1EfgOzqOPOvq4TpUmdZ6g25+GMvwm5P
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d94:b0:3a7:9860:d7e5 with SMTP id
 e9e14a558f8ab-3bdc4f185e6mr56200795ab.23.1734570425513; Wed, 18 Dec 2024
 17:07:05 -0800 (PST)
Date: Wed, 18 Dec 2024 17:07:05 -0800
In-Reply-To: <20241218200049.GC6174@frogsfrogsfrogs>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <676371b9.050a0220.15da49.0002.GAE@google.com>
Subject: Re: [syzbot] [xfs?] possible deadlock in xfs_dquot_detach_buf
From: syzbot <syzbot+3126ab3db03db42e7a31@syzkaller.appspotmail.com>
To: djwong@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+3126ab3db03db42e7a31@syzkaller.appspotmail.com
Tested-by: syzbot+3126ab3db03db42e7a31@syzkaller.appspotmail.com

Tested on:

commit:         1f253c4c xfs: release the dquot buf outside of qli_lock
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git fixes-6.13_2024-12-18
console output: https://syzkaller.appspot.com/x/log.txt?x=105ab730580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6fe704d2356374ad
dashboard link: https://syzkaller.appspot.com/bug?extid=3126ab3db03db42e7a31
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
