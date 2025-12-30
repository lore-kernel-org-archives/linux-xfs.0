Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C371A2D7DD9
	for <linux-xfs@vger.kernel.org>; Tue, 30 Dec 2025 09:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767088404; cv=none; b=J8UKcxK6bIx+VDxBpPtbgMCGT23VAtJPEj8ecj6ItP/+F+t8HZGGt1ZROStiCOFf7jfQfJbrwhQ8sNmtKaUN3g6+g3WYGV6oq1Q3ZQxLbVrKIvkn4DytNjPl5FRP6KkltlN+kWwSU54GBWLGYw0UwJTJN8hgd3YH9rSVrM1cA3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767088404; c=relaxed/simple;
	bh=ZTuSwHVlojTAMSQCS/Wmod3Z8HndfXWq0hRp+VNHGsc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=BQ85jscaWQyqn/zlfUmGZN2+e/4GFV2IFGQiyfawZf4TdST5rJGixT8RpVUy8pa/0EM89wmX4LfUp3z+QX5p6V/xRIGZ5Kzv2GG4ArXusHeiN/LMQ5qXzEZwcbAxZq0+AmIFkDklOun8xPc8uwo8cHvTRBQ3fgwADnOxgUvIHwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7c705ffd76fso11585781a34.3
        for <linux-xfs@vger.kernel.org>; Tue, 30 Dec 2025 01:53:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767088402; x=1767693202;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0ZcDuMewUoo5/LxUSUrLOPC6WCYdft/w01YBOtxsc4Q=;
        b=SH0dE/MX0sokQ/T8C1LlaJ0sWHrv5/xwna/egriae3Dur6e380ZgvCV9t7ROOpG2n+
         EnLXzpvjh5gs76hTQHx37IhDz48dXCoctm3vW+5W+A6LoSuMLJsZbthHktkVVdQ2qtIw
         95OqCm6H6Xk9x2EiHEdbE6ElChjsK/+6RiyAESvvoFWdwLyHaI3IFY1XUVUc7dO8KPsx
         vnJ+Ue5K0FzkhrbVK3CNlD2rec1CwM2c5VnQj9XmcPH7L0DpZmXQjFCLgRhyTZm+tMXs
         K1DKvePUlMupjEFMnsvVTKT6L+ZznNOB1Gwm4SvT0Tftg3ZgPheDqtPoAO9pncawkVmX
         XyWA==
X-Forwarded-Encrypted: i=1; AJvYcCUx6qc5KuvMpSFBEA5/3dq7dO20omISxexEpCZxx6EQTPP54JB5Uhcw5NEizHJ7vHm3AE4VrDWb26U=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvhQTsGwgBc+XSeq9qYz1zPET7J0H7r10FEagtYaqxD2yuosiB
	db0xyNQxGY331ocxR5I/lnFbsy1sD2zsQu/tHwB11nVr7ZBBrc+lV3BOEtyeTls9yzUdjaVfXtj
	vZ172JMWKUMR/fi6W0Zqiw+FU0g1rbRfNf1zOQcQ5KQp2cmprsfjIh36X/08=
X-Google-Smtp-Source: AGHT+IGNLNF8kjmyhTo9YvYn1h08yIgQ0+l4M3RO1qyuQZ7xWUnZOhAka1rVEE1dmMIlzsUT4vj9gOInRqut5KdIKL/hb786aOTU
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:6501:b0:65b:25e8:13fb with SMTP id
 006d021491bc7-65d0ec13271mr8710173eaf.82.1767088401824; Tue, 30 Dec 2025
 01:53:21 -0800 (PST)
Date: Tue, 30 Dec 2025 01:53:21 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6953a111.050a0220.329c0f.0572.GAE@google.com>
Subject: [syzbot] Monthly xfs report (Dec 2025)
From: syzbot <syzbot+list2d4681db995f99c38fcb@syzkaller.appspotmail.com>
To: cem@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello xfs maintainers/developers,

This is a 31-day syzbot report for the xfs subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/xfs

During the period, 3 new issues were detected and 0 were fixed.
In total, 20 issues are still open and 27 have already been fixed.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 2913    Yes   INFO: task hung in sync_inodes_sb (5)
                  https://syzkaller.appspot.com/bug?extid=30476ec1b6dc84471133
<2> 1936    Yes   possible deadlock in xfs_buffered_write_iomap_begin
                  https://syzkaller.appspot.com/bug?extid=5f5f36a9ed0aadd614f3
<3> 519     Yes   possible deadlock in xfs_icwalk_ag (3)
                  https://syzkaller.appspot.com/bug?extid=789028412a4af61a2b61
<4> 294     Yes   KASAN: slab-use-after-free Read in xfs_inode_item_push
                  https://syzkaller.appspot.com/bug?extid=1a28995e12fd13faa44e
<5> 52      No    possible deadlock in xfs_can_free_eofblocks (3)
                  https://syzkaller.appspot.com/bug?extid=a8a73f25200041b89d40
<6> 30      Yes   KASAN: slab-use-after-free Read in xfs_buf_rele (4)
                  https://syzkaller.appspot.com/bug?extid=0391d34e801643e2809b
<7> 14      Yes   KASAN: slab-out-of-bounds Read in xlog_cksum
                  https://syzkaller.appspot.com/bug?extid=9f6d080dece587cfdd4c
<8> 13      No    possible deadlock in xfs_trans_alloc
                  https://syzkaller.appspot.com/bug?extid=f4c587833618ec4a76f9
<9> 4       Yes   INFO: task hung in xlog_force_lsn (2)
                  https://syzkaller.appspot.com/bug?extid=c27dee924f3271489c82

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
