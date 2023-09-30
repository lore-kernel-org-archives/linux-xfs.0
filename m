Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F631E7737D
	for <linux-xfs@archiver.kernel.org>; Sat, 30 Sep 2023 17:57:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234684AbjI3R5b (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 30 Sep 2023 13:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234703AbjI3R5a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 30 Sep 2023 13:57:30 -0400
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com [209.85.160.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16848E1
        for <linux-xfs@vger.kernel.org>; Sat, 30 Sep 2023 10:57:29 -0700 (PDT)
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-1d66b019a27so31764733fac.0
        for <linux-xfs@vger.kernel.org>; Sat, 30 Sep 2023 10:57:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696096648; x=1696701448;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x3Gp6kmS+fykC4M2bQvmNXWwpBIaXxl++sWiM3iH1lM=;
        b=TXuFLyaPzGJnyb44pV/tMrsGVq4tFK2RASNpbaDyPgAjGOw64MaJ68PRxtoiSDuSph
         dnEjOp1pEEgpIQpU01Vnw1xSB5YpZ2pvtIOIqfLYlCNdz89W8Zp0bcq5dHJm+uwKUFll
         SLCMrBG8zjGEdYJuw1wGNFwUx6SffVZV/HMBFA1kblOg0LyrUO7dcPzQdm7uALZiPdKO
         2LsgcKKN7gMuqtMuzQFbfGnsUCvOeMMJd6pzxU2f9/KFuxFsBRiBG9DMevcSN0jO4abs
         9E+ehwMyCGhxyzG03+b580UAwEjCgtZRxOoAD6kYu9D3MvOPI1rleNJzo1Lrx1VouubB
         /nMg==
X-Gm-Message-State: AOJu0Yx5LldhbklPfHCZNqgaQA/XPWOGBPn9QfAOdeSPCTPR6XAK3M0/
        YqwWxnZAYrDaTaxya51/XwQxS1oo5m5pSmvjbTCe/TqsrcqL
X-Google-Smtp-Source: AGHT+IE18cqh4JXNl6uQxBP/a23swgy+FwpamgscMAObJ9M7l5hmBxY2Rxui2X8zH1T9Z/3YkdWmpxVHSllM5OftvTuZR+eXBiKI
MIME-Version: 1.0
X-Received: by 2002:a05:6870:c342:b0:1d5:a24a:c33 with SMTP id
 e2-20020a056870c34200b001d5a24a0c33mr2785411oak.8.1696096648433; Sat, 30 Sep
 2023 10:57:28 -0700 (PDT)
Date:   Sat, 30 Sep 2023 10:57:28 -0700
In-Reply-To: <0000000000001c8edb05fe518644@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003c16100606974653@google.com>
Subject: Re: [syzbot] [xfs?] UBSAN: array-index-out-of-bounds in xfs_attr3_leaf_add_work
From:   syzbot <syzbot+510dcbdc6befa1e6b2f6@syzkaller.appspotmail.com>
To:     chandan.babu@oracle.com, david@fromorbit.com, djwong@kernel.org,
        ebiggers@kernel.org, hch@lst.de, keescook@chromium.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, mukattreyee@gmail.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit a49bbce58ea90b14d4cb1d00681023a8606955f2
Author: Darrick J. Wong <djwong@kernel.org>
Date:   Mon Jul 10 16:12:20 2023 +0000

    xfs: convert flex-array declarations in xfs attr leaf blocks

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12eef28a680000
start commit:   f8566aa4f176 Merge tag 'x86-urgent-2023-07-01' of git://gi..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=3f27fb02fc20d955
dashboard link: https://syzkaller.appspot.com/bug?extid=510dcbdc6befa1e6b2f6
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1652938f280000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14c10c40a80000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: xfs: convert flex-array declarations in xfs attr leaf blocks

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
