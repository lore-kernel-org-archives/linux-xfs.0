Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 551C1C77B73
	for <linux-xfs@archiver.kernel.org>; Tue,  2 May 2023 04:07:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbjEBEHX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 May 2023 00:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjEBEHW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 May 2023 00:07:22 -0400
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D95402114
        for <linux-xfs@vger.kernel.org>; Mon,  1 May 2023 21:07:19 -0700 (PDT)
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3311ec66613so2687125ab.2
        for <linux-xfs@vger.kernel.org>; Mon, 01 May 2023 21:07:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683000439; x=1685592439;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1sun8IGOZKfcXnn6ZeN9QAEArnmcog0Uu2cpeM9kwUI=;
        b=jgjmFwoDKlHGh4UWvXWqVP/Zw7yN7WxJrt0fyb6aQND0Sw0ANbKPeRN57t7O3CwqPj
         0eKi1vJo4cn1NOFWq4zQdNjP3X7BQRryYA6KC49zOr8dKC+alw3yZj56otnCp4QtBhyp
         sMWYirkOa055yZ563SIar5sFzf90jclc560lBN0SvtWS2B/Mo5VnLhICzll3P2CllqVp
         z1zioUMcnMf5OKfYhp+juuvrItyHf8JVoyKo3a6FtrUru66M5TuZ7E8ROG3C3syrBaRP
         z4LUoawA+Zygu2Sc2qfcmC3c8CcKv4Dgb2kAIWOX+XNBXwnpr2+Men1slW/2Xmtl2r/U
         6q8A==
X-Gm-Message-State: AC+VfDx1uOkb7zALR4QPA8rPbcy+9UKSme4w9grwTA8PXRBX4MsK8QOE
        Gp9gOzlygHsyjAbv54IbFp6Dh6JNkZ1VrfPcHRaALILbvpKw
X-Google-Smtp-Source: ACHHUZ6HteCvjq8AgQxcAHWcEz8BI0SGep+xEoEPUn42TgCm6UnDnPtPQMvVh6TaW82nUTZSDkGQJ9vcsdO4VFR616JuAkgADzru
MIME-Version: 1.0
X-Received: by 2002:a02:b1ca:0:b0:40f:7193:87dd with SMTP id
 u10-20020a02b1ca000000b0040f719387ddmr7128974jah.5.1683000439247; Mon, 01 May
 2023 21:07:19 -0700 (PDT)
Date:   Mon, 01 May 2023 21:07:19 -0700
In-Reply-To: <000000000000c5beb705faa6577d@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000569d3405faae13db@google.com>
Subject: Re: [syzbot] [xfs?] KASAN: slab-out-of-bounds Read in xfs_getbmap
From:   syzbot <syzbot+c103d3808a0de5faaf80@syzkaller.appspotmail.com>
To:     david@fromorbit.com, dchinner@redhat.com, djwong@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        yebin10@huawei.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

syzbot has bisected this issue to:

commit 8ee81ed581ff35882b006a5205100db0b57bf070
Author: Ye Bin <yebin10@huawei.com>
Date:   Wed Apr 12 05:49:44 2023 +0000

    xfs: fix BUG_ON in xfs_getbmap()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1235f544280000
start commit:   58390c8ce1bd Merge tag 'iommu-updates-v6.4' of git://git.k..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1135f544280000
console output: https://syzkaller.appspot.com/x/log.txt?x=1635f544280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5eadbf0d3c2ece89
dashboard link: https://syzkaller.appspot.com/bug?extid=c103d3808a0de5faaf80
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12e25f2c280000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14945d10280000

Reported-by: syzbot+c103d3808a0de5faaf80@syzkaller.appspotmail.com
Fixes: 8ee81ed581ff ("xfs: fix BUG_ON in xfs_getbmap()")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
