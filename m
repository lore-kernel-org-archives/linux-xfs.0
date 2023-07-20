Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42A08C001DE
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jul 2023 03:14:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbjGTDOn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jul 2023 23:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbjGTDOc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jul 2023 23:14:32 -0400
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 931CC2127
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jul 2023 20:14:27 -0700 (PDT)
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-3a337ddff03so704893b6e.0
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jul 2023 20:14:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689822867; x=1690427667;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3dLS1fkmLNfQarBUbxDLjlgSZFQxrkiWfFAKGUoVwgg=;
        b=U/RW84APW1cr4oilPiuDxYO6nwHLcxO+Dz/ON5YX9kFCqTY8lpjn8RefiqCQbmuD71
         MiUnJFIwEDOKmzPNchkchNN6vBorW2Y6JKOsgcV0F7JcXI3wRBZ18X8HAB6WM2nYzRz/
         REVw+zxHvYPoGJPl2loc3Cx8t5PsMG+tSOJ6y1zLDW1/8O1TX+2m6/5MlUms70bDlI62
         SXOdIN6cKjMyFe/LWOw4iu26JwbEUsz+UCdldPo4BzmLxo7udATPwXJjmbT5k8691sb+
         SDkKwywAjaxuv41SanlaojTx6qSZlAXAInZT/E6ofT1kk7ra+2++r02n0oni/K60qsn+
         Tw6g==
X-Gm-Message-State: ABy/qLbxcUaNciPBDV8L7Y7S9peiq/Lz8j0qEkwKDkBhePZnmZcdmoxr
        R4xrr1DcD7hXEzX7OCkxS1H3acFzFX4zGmbFlwmm1EhNljaZ
X-Google-Smtp-Source: APBJJlFnA8rvYk9d/lGUaDr/IfIskxW4K8tYC6PqQDXp5UAdWWBsS51r9xWXOWnTExCP8AKfzol60XBIwVv36pGSqoDsUx8WPCbZ
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1149:b0:3a0:3d3c:1f03 with SMTP id
 u9-20020a056808114900b003a03d3c1f03mr763746oiu.11.1689822866925; Wed, 19 Jul
 2023 20:14:26 -0700 (PDT)
Date:   Wed, 19 Jul 2023 20:14:26 -0700
In-Reply-To: <00000000000029729c05fe5c6f5c@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b76f3a0600e28b22@google.com>
Subject: Re: [syzbot] [xfs?] KASAN: slab-out-of-bounds Read in xlog_pack_data
From:   syzbot <syzbot+b7854dc75e15ffc8c2ae@syzkaller.appspotmail.com>
To:     david@fromorbit.com, dchinner@redhat.com, djwong@kernel.org,
        hch@lst.de, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit f1e1765aad7de7a8b8102044fc6a44684bc36180
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Jun 28 18:04:33 2023 +0000

    xfs: journal geometry is not properly bounds checked

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13d43cc6a80000
start commit:   fb054096aea0 Merge tag 'mm-hotfixes-stable-2023-06-12-12-2..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=5bcee04c3b2a8237
dashboard link: https://syzkaller.appspot.com/bug?extid=b7854dc75e15ffc8c2ae
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1482afc7280000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1429c5e7280000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: xfs: journal geometry is not properly bounds checked

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
