Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAA0CC7EE23
	for <linux-xfs@archiver.kernel.org>; Sun, 28 May 2023 12:10:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbjE1MKe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 28 May 2023 08:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjE1MKd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 May 2023 08:10:33 -0400
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55A79BB
        for <linux-xfs@vger.kernel.org>; Sun, 28 May 2023 05:10:31 -0700 (PDT)
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-76fe42b7f7dso384561039f.0
        for <linux-xfs@vger.kernel.org>; Sun, 28 May 2023 05:10:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685275830; x=1687867830;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wm6IKPj1vMMJrUxmKpUlCDI+xA2XUJA6ZIRpAJeh0E8=;
        b=RKvSP8ETWn7d4gVzYP9NjmIqCovLWnPC6hKJOBNMKRmNMxFscCfb1REKogY7Y046oF
         QWdsfoMyhUOZD80sja8yadsPG2nq1GNBmaBrGmqWuRPIefBV3pnvPg257YJwVQ5Pe9le
         uHNAXKgVR5UHgjIxiOBHZypcR/8U8WHiKxjm/0+/PfAgP8sdhqvQb5bFm1IDl7qBWdLe
         P7thFcR3CYGzkq15EjOEhPdSvp1fwOFiMm+AIArNDFigAUv03SSXtLif7v27eHsoY445
         vN/xGbbaPe3QCjLF15enjjJzTodWIxIX0iLx1NflKvDPQVy4IOjZlR4HecWYaEhfbEqy
         SEUQ==
X-Gm-Message-State: AC+VfDyCMphxPl4jWV/5NVlMscGr4AOaAyxfaihPif/zjXmUQPhNg89A
        Hei2EN26pVVjXGVuLZFnZa9+b+d7CpNZQ4/TloI3IDs9Ul2g
X-Google-Smtp-Source: ACHHUZ4CR5b8H0wmXLm7aJuF4Tdf0/z5aCLMklVGTfClc5kah2GMYkAu7IYkwVnC9s8+LAyLxMv4TPJTEkHgsZglzH11TYR1f/JW
MIME-Version: 1.0
X-Received: by 2002:a02:948d:0:b0:41c:feac:7a9a with SMTP id
 x13-20020a02948d000000b0041cfeac7a9amr1722550jah.5.1685275830699; Sun, 28 May
 2023 05:10:30 -0700 (PDT)
Date:   Sun, 28 May 2023 05:10:30 -0700
In-Reply-To: <000000000000540fc405f01401bf@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003ccc9b05fcbfdb68@google.com>
Subject: Re: [syzbot] [xfs?] general protection fault in __xfs_free_extent
From:   syzbot <syzbot+bfbc1eecdfb9b10e5792@syzkaller.appspotmail.com>
To:     dchinner@redhat.com, djwong@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit b2ccab3199aa7cea9154d80ea2585312c5f6eba0
Author: Darrick J. Wong <djwong@kernel.org>
Date:   Wed Apr 12 01:59:53 2023 +0000

    xfs: pass per-ag references to xfs_free_extent

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1007e5c1280000
start commit:   02bf43c7b7f7 Merge tag 'fs.xattr.simple.rework.rbtree.rwlo..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=8c59170b68d26a55
dashboard link: https://syzkaller.appspot.com/bug?extid=bfbc1eecdfb9b10e5792
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1798429d880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=161b948f880000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: xfs: pass per-ag references to xfs_free_extent

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
