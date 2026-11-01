Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793565214;
	b=A7zfObzRF35uLaKyerW6ARE4zSrVKjnHl7xCpv0citsrvNXEwf0W0boP6vPKuTsQsnKG
	 Ld+LYrQhhYNrvdqvC+LmrC1w6ya8k7X3GVk+4Q9rGmaYe+uCLUy0Wj3GNXRXHCVwWvmOf
	 Ux+DX3ruaCj0WxnbQQ1cdsTU/n1UTejq2IXWwdfFigCKvjFwHZVtCoj5uPd2xl1fJn+8B
	 PAoi5zF8iyR54UN1yYk8zJ6tyE54JB8xYSxDIvDLrnOhBHyYGfX8imNU9+3OBvwe0gaD0
	 e5hGBc4xP/lrCoQGBynjdtUwDU58XkTztCNCJ2malGd5m0z/3gojlQROsEn1JaVE+KQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793565214;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=2dTv+40A8MU9jbQstiny/cxNJ+aTnQerlecbgJEPaYA=;
	b=eFwYqD8is18JIoQoJ+aiCr2K7r1hLs1bBv5ZsumiTJ2NRHdYB564mKHs7ySSzzmUWBKF
	 joi1H/asI9vO68dP6u0xpg2UXIRGSnxWB1Ay66slL5Tzs9qRX6+L+FCcRnFIWBRIDxU9S
	 0HbmqTXq7j2bXzL+BKW6B5Gy1fq2kfhJ3EQxOEyg3jQTbT6RVkrmGFEVPb22j8/XqB5Co
	 dBfIFM7BkGVUcCxLQyuHSkgExQDEDZpGtt/yHCPkvykL2MDUJANig8ivWOCqgtJamI8tW
	 Ve5qrNLgMif9FhWasTHgudh/hm7fIs3sIrb9XhBybVTRHV+9Bti3/hPS47tQoYxo5bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.210.70
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E79606A327
	for <linux-xfs@vger.kernel.org>; Sun,  1 Nov 2026 20:33:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 06E79606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-83c2311eb1dso4294866a34.1
        for <linux-xfs@vger.kernel.org>; Sun, 01 Nov 2026 12:33:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793565213; x=1794170013;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2dTv+40A8MU9jbQstiny/cxNJ+aTnQerlecbgJEPaYA=;
        b=NULikNPHGbUUuvey0PLpWe6q97hNoBV3pnBhGYFET2+borIFGT/l8iqEaoS+SBwvuN
         isWTXSGkcpynw0OkeN0HF5y2KjJjAeLwUmiJNAzuGn30s5zxSfNFXQTkEX28qwxaFV0C
         L7CGX+DkyiTK8p7Y0elBsmusYKuBgSzfd8AIEx11QTXEfMXSi+sY4nLdRf/J84/KlufE
         IlXjlbjwwLU9fv4gOUJ54KBAgipG/udTGRLnq8M5C2viSZ4y29IHTDqv0kWDEnLIdn0B
         XdurTTtviFGzgueQTD4RuECujnGTnweFRxOhU/5LgrTBjG9XCay81+bQklQVyQZ8UUAM
         gAeA==
X-Forwarded-Encrypted: i=1; AKwUvBxb3mphqGTvFCGC9tm0A7ogld7A8ZKe7D1x+R+TGx1oSLN0hyd6TU1UBgflQY5OJxvpNhM/pMOF3Lo=@vger.kernel.org
X-Gm-Message-State: AFq9FYKVCierKiAWxAfHK8lIWZU/KRDEys9XoqjNtf7wKWRbAJu1Ii3k
	O2kNIdQGy0epXGVJM+s18unQ1fvRcYDzVDfGLjid4qiTFYCE37rRrXfluMx00Hg66g68mXS6u1O
	GBjQyHAkhL4a8wnynMO/Cpy82HImsOJYjwoBUamd48UIkFDncHkzrn2CUTLM=
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:181d:b0:523:dee6:7ae0 with SMTP id
 5614622812f47-5640de07f62mr5409409b6e.58.1793565213054; Sun, 01 Nov 2026
 12:33:33 -0800 (PST)
Date: Sun, 01 Nov 2026 12:33:33 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ae7a21d.7fe51036.1ecf7.002d.GAE@google.com>
Subject: [syzbot] Monthly xfs report (Nov 2026)
From: syzbot <syzbot+list16a9fddd1bb92a94c686@syzkaller.appspotmail.com>
To: cem@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello xfs maintainers/developers,

This is a 31-day syzbot report for the xfs subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/xfs

During the period, 0 new issues were detected and 0 were fixed.
In total, 11 issues are still open and 35 have already been fixed.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 910     Yes   possible deadlock in xfs_icwalk_ag (3)
                  https://syzkaller.appspot.com/bug?extid=789028412a4af61a2b61
<2> 27      Yes   KASAN: slab-use-after-free Read in xfs_defer_item_unpause
                  https://syzkaller.appspot.com/bug?extid=e7f24354da9f7915bc54
<3> 6       Yes   KASAN: slab-use-after-free Write in xlog_cil_push_work
                  https://syzkaller.appspot.com/bug?extid=c32ff62cf4913d345d0c

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
