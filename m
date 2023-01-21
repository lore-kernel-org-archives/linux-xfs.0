Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA144C54E94
	for <linux-xfs@archiver.kernel.org>; Sat, 21 Jan 2023 20:19:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbjAUUTn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 21 Jan 2023 15:19:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjAUUTm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 21 Jan 2023 15:19:42 -0500
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 112AB23653
        for <linux-xfs@vger.kernel.org>; Sat, 21 Jan 2023 12:19:19 -0800 (PST)
Received: by mail-il1-f200.google.com with SMTP id o10-20020a056e02102a00b003006328df7bso5937699ilj.17
        for <linux-xfs@vger.kernel.org>; Sat, 21 Jan 2023 12:19:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Pe29fqGB5jw0Lc13jqigdvwWKgCeBel/2NyFQTzRKFU=;
        b=FSGrJ9Y1Nsc4hh1yz8sxa/fo8QiMAEokjhuPYAlztA0YPHitXlBjUjHqgeAfdVusj+
         OgaOfpI69rzt0BKBkGjv7qrGqrfvLajzbLRrfd3WHffHrFsG+x5fQw+7O9w2Y9a/BhJI
         8DzSGjxGLHKWakOYkTwaBRC/aPrzqwV5znw6A4tQ/+H5idcEYJejqzm0BOIGoQoDs0dN
         ZJ/urZ+tthZZLcH1R9NGDn7pGgv4v79ZycxZcsU2buW5hSDx0l5afEpzHKTuD6GEcLLX
         GsL5zIsavfRfqg0h2O/5K3Rt2LmtqmiBxq6N4AgSLBNATVKyQhsSJllyAk9+uO0AgTyY
         8wrQ==
X-Gm-Message-State: AFqh2kqgXJJuKcjFplNwAG2tSXZxmchIh6Qr1f7yqppkPcVT1wSDeg7V
        Y9HQ2yO7vrq5gbVGLAnzyIe9pb5xG0SJ3lN6Nd/uctiIs3xw
X-Google-Smtp-Source: AMrXdXsMhd7fYTsq8AER0qV8wQz7Ln6057/YOLIm7ow9udsEXxqSp9CcJM7BO7xCaulaDj1Cf8u+Mwjm49RoRMxr6/2pXgX+5eSL
MIME-Version: 1.0
X-Received: by 2002:a05:6638:24c:b0:3a6:c95:e160 with SMTP id
 w12-20020a056638024c00b003a60c95e160mr1517664jaq.34.1674332359101; Sat, 21
 Jan 2023 12:19:19 -0800 (PST)
Date:   Sat, 21 Jan 2023 12:19:19 -0800
In-Reply-To: <0000000000004ab8ac05ef9b1578@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008016d805f2cbe102@google.com>
Subject: Re: [syzbot] [xfs?] KASAN: stack-out-of-bounds Read in xfs_buf_lock
From:   syzbot <syzbot+0bc698a422b5e4ac988c@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, dan.j.williams@intel.com,
        djwong@kernel.org, hch@lst.de, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-xfs@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

syzbot has bisected this issue to:

commit 679a99495b8fda800037b25af8cd990eb7dd72c9
Author: Christoph Hellwig <hch@lst.de>
Date:   Mon Nov 29 10:21:41 2021 +0000

    xfs: factor out a xfs_setup_dax_always helper

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17708805480000
start commit:   7dd4b804e080 Merge tag 'nfsd-6.2-3' of git://git.kernel.or..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=14f08805480000
console output: https://syzkaller.appspot.com/x/log.txt?x=10f08805480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2b6ecad960fc703e
dashboard link: https://syzkaller.appspot.com/bug?extid=0bc698a422b5e4ac988c
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10c58bd2480000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11cc664a480000

Reported-by: syzbot+0bc698a422b5e4ac988c@syzkaller.appspotmail.com
Fixes: 679a99495b8f ("xfs: factor out a xfs_setup_dax_always helper")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
