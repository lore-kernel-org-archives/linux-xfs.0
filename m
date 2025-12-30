Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D14445038
	for <linux-xfs@vger.kernel.org>; Tue, 30 Dec 2025 15:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767108065; cv=none; b=qQe5w7b4op2TbOb0B8LxBsZP3XeX72rRlctGW4lfsrHAmp8lH1M1Ur1m9dOIlxVNDReSGv/OUMDqc22SIL/huOrsU3FDmqhv/zUGeI5LspBx0mG4Jl7YF0f0TI1+lx8Jw3gfOrZaOFpWtw0boKSEEP+oCErRwnzwxVeGUfQ5UMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767108065; c=relaxed/simple;
	bh=UqefMjhSVqeqxZ7cw9SZ3XXPaID45kiWVvBSiFES5nw=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=qix6vbkXv+jhl1pN5WzEeS8FNeUns1N7YH45hQ1rgB+X1is08YMqMM2HefkyngeH5ELcKCdPcTXNEtz5iUk3+V0ITH8Ddtx+zhmuod0iuhJfoAkgbDye3RbIQ75WmYfl/WJAMB7i05X3jazhvQ3BbLKJKGuDibJVL7GVrY/hSuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-65d004d4e48so19610238eaf.3
        for <linux-xfs@vger.kernel.org>; Tue, 30 Dec 2025 07:21:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767108063; x=1767712863;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2mGAIhaLqmqueebz091ruC6N1hhdYb289JyV9x3owoM=;
        b=aEB5KuFautUfQZj0etP9k77HY2oRRX/RB9mXYgKHv5fcCQI0v9s1Qn4P1dmWFH2Jlb
         Q+/EYG3KCn+PXmX90G7YitUkyMQYb4IXER1riiMExZZKaLZc8WEmP3YyoAMMVLsyZAYS
         m9ngePd2Lu8arfkKulpvGNBlbjCUeuDxfi2UJmsn+1e8V21by2m8OgFcur+y9sfSl3EF
         QyIRDzKvJvuqFJL/tZ37YKCJb3AbowCnE6uueBHBkKjhDAm1FMP/skKhi9JsT3NNU5tA
         P17XvMWC1vKm3BNC/XN/nP9C+K/OOlGJ1sGZFQcMYUuEFljT1Qbok4KyUIO0F9nSi3mZ
         JSUw==
X-Forwarded-Encrypted: i=1; AJvYcCVoD31t9mLaTdKQ9cOqDuFfyNVn6Y4kcjWqkQAfHRANJ16tkQSVkeH6TtKX+VuNpgJS1YWfkieGcVY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4ao6oyzo5COFdtMvJP+E7y2b7mCQkSSv5nJF+Zx3Wi8uKOZPI
	Dmu6WusHGuT9J70Ty/6zNiW3kCqDIl9slEZ8uGYcWjgn7oL5bcmL3LHtetQmd6aR9rw8aWAnCU0
	GEHHrFbK2N86CesiILIQFTODwusWvZI9O3sgL+YmIau5NDvF1XSB7bb3eQog=
X-Google-Smtp-Source: AGHT+IHkKUH30RxqdCakjTYB1Y4xBbuTNTd0OXa/1EH11X4dbUPXfPlYah/opolSsQ87AVuh34brTp8VvzOuaj9iGfTQpVdHJrW1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a4a:e1c9:0:b0:65c:fb86:8a94 with SMTP id
 006d021491bc7-65d0eaa2672mr11026884eaf.36.1767108063158; Tue, 30 Dec 2025
 07:21:03 -0800 (PST)
Date: Tue, 30 Dec 2025 07:21:03 -0800
In-Reply-To: <686ea951.050a0220.385921.0015.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6953eddf.050a0220.a1b6.02ff.GAE@google.com>
Subject: Re: [syzbot] [xfs?] INFO: task hung in xfs_file_fsync
From: syzbot <syzbot+9bc8c0586b39708784d9@syzkaller.appspotmail.com>
To: anna.luese@v-bien.de, cem@kernel.org, cmaiolino@redhat.com, corbet@lwn.net, 
	davem@davemloft.net, dchinner@redhat.com, djwong@kernel.org, 
	edumazet@google.com, horms@kernel.org, jhs@mojatatu.com, jiri@resnulli.us, 
	john.ogness@linutronix.de, kuba@kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	netdev@vger.kernel.org, pabeni@redhat.com, pmladek@suse.com, 
	rostedt@goodmis.org, senozhatsky@chromium.org, 
	syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit b9a176e54162f890aaf50ac8a467d725ed2f00df
Author: Darrick J. Wong <djwong@kernel.org>
Date:   Tue Sep 2 21:33:53 2025 +0000

    xfs: remove deprecated mount options

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1481829a580000
start commit:   d006330be3f7 Merge tag 'sound-6.16-rc6' of git://git.kerne..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=b309c907eaab29da
dashboard link: https://syzkaller.appspot.com/bug?extid=9bc8c0586b39708784d9
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15e24a8c580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10ed3582580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: xfs: remove deprecated mount options

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
