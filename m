Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com [209.85.160.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA943346A0
	for <linux-xfs@vger.kernel.org>; Fri, 30 Jan 2026 10:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769767770; cv=none; b=qweeiZ2Qk6vpgiQnr2KEiQ3T8gZ/xFebHeBpZQW08gcUXkX2oU2c/2/iBiSHdNxEA28rA0czyP2WvnVezq6f53wSD3fxft7lw+9g+z7aVUH4M4ZGcjrMoRvlUgJJ6UhFmbYkKFWoHiItJFbfwOk7njSt4gLaJwIFCwh3AtEErZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769767770; c=relaxed/simple;
	bh=ZM8P0cQVR+4DlHU6H2k9ZtncrT1rU1cvDaFwfiMFivE=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=iV7vzDkcelc/1RCT5zl777kzKD64TQ/r9Vo8CAZTqAYZiCqN4PmOZgeYYjidAGBTT+tbqhE75o3WAyTc/6Ht2jZfeG7GPyJKMwEVKn91z4yJBE4pTpddPrkySxhXFpuGEvM62Hie7nTEcaEMqH22aakCrduNdlX0QWZIRwRmJGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-4081db82094so5644766fac.0
        for <linux-xfs@vger.kernel.org>; Fri, 30 Jan 2026 02:09:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769767768; x=1770372568;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vudG9C0l4MF2Oy0GyX45FWvhu2UROcXetlGACN64r0A=;
        b=Ht804wTGwmfm45FkDcgWT0rSb1SSkdrpDYMkep9uWQfteAzoXvApJ4nRVOeu9ooD5b
         4VwepVXAbE71xM5lY/DXa9PSH6xFVtyEimDW+EP3cH55lMVPGvliHynNdl5WIrvQy/ru
         NOmenc4DVY8yMG6JsCP4ETkQ75jAkP7qQbPrpRYov/Dn5vWUiIXi851PjIDCnlhK6C4c
         9NWE82phgZPVO2SRatVNkEz5hroQInq5m8uxWzD6xhcRScWUOfbyAhLFnnKWpnoBhQe2
         puJA+Bg2darAZX67rA5iHGEdhmmJOd+JHB1QHVs1epGbqHxdeJeGfU5TJlVLrSu3O8B8
         cSGQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQKOAqRRhmcTkmaQjHnNIZIIECt7tIYeeGLCzvoMKgdRQjCCfHSFRtKHt4kgvevGU+omEAvs1UJrI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyOy/n8mWCECpUHhy5tYJ123zp9A/K0+9mCJ0/orU5FI9q/T0nA
	IxP3z35jVzF8e18DKJpyPg2Xq9Tm+mewHQ5M/0okI89toJ8ocXxrA7qVjZyRhSYwtF0IBdb/j8/
	9/M450UShsHEp45Bthp1DST5d4Ac8c2yeKjQM7gvDJvNw4a/EmfU7lMVOlLs=
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2217:b0:662:f74d:69f5 with SMTP id
 006d021491bc7-6630f05100emr1247267eaf.31.1769767767852; Fri, 30 Jan 2026
 02:09:27 -0800 (PST)
Date: Fri, 30 Jan 2026 02:09:27 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <697c8357.a70a0220.9914.0484.GAE@google.com>
Subject: [syzbot] Monthly xfs report (Jan 2026)
From: syzbot <syzbot+listb85a7a162ab0a876fae7@syzkaller.appspotmail.com>
To: cem@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello xfs maintainers/developers,

This is a 31-day syzbot report for the xfs subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/xfs

During the period, 3 new issues were detected and 0 were fixed.
In total, 21 issues are still open and 27 have already been fixed.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 3445    Yes   possible deadlock in xfs_buffered_write_iomap_begin
                  https://syzkaller.appspot.com/bug?extid=5f5f36a9ed0aadd614f3
<2> 853     Yes   possible deadlock in xfs_icwalk_ag (3)
                  https://syzkaller.appspot.com/bug?extid=789028412a4af61a2b61
<3> 318     Yes   KASAN: slab-use-after-free Read in xfs_inode_item_push
                  https://syzkaller.appspot.com/bug?extid=1a28995e12fd13faa44e
<4> 113     Yes   INFO: task hung in xfs_buf_item_unpin (2)
                  https://syzkaller.appspot.com/bug?extid=837bcd54843dd6262f2f
<5> 107     No    possible deadlock in xfs_can_free_eofblocks (3)
                  https://syzkaller.appspot.com/bug?extid=a8a73f25200041b89d40
<6> 20      No    possible deadlock in xfs_trans_alloc
                  https://syzkaller.appspot.com/bug?extid=f4c587833618ec4a76f9
<7> 9       No    general protection fault in workingset_refault (3)
                  https://syzkaller.appspot.com/bug?extid=ccf9f05f06b4b951f3cd
<8> 8       Yes   KASAN: slab-use-after-free Write in xlog_cil_committed
                  https://syzkaller.appspot.com/bug?extid=4e6ee73c0ae4b6e8753f
<9> 4       Yes   KASAN: slab-use-after-free Read in xlog_cil_push_work
                  https://syzkaller.appspot.com/bug?extid=95170b2e7d9e80b8a7d7

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
