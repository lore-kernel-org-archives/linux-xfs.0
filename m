Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF230C77B7F
	for <linux-xfs@archiver.kernel.org>; Sat, 13 May 2023 17:29:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbjEMR3o (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 13 May 2023 13:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbjEMR3o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 13 May 2023 13:29:44 -0400
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 943BF2D7F
        for <linux-xfs@vger.kernel.org>; Sat, 13 May 2023 10:29:42 -0700 (PDT)
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3318baf6a8bso72710135ab.1
        for <linux-xfs@vger.kernel.org>; Sat, 13 May 2023 10:29:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683998982; x=1686590982;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FbbmGkWIHFvHvZe0ffM+JCbiEheWBrVPtCvSgO2HARM=;
        b=d/ni1AfOiRnhSo0Ii8/DzZ7ua3GRa+e+ZoQmP0Fs3LupT6Sx3/tDxRsAwoGIPURGM7
         Lvmpt6wMwM5oDVoSQyXDgmA2Y26lXSyYvmDuBD1eDzI/0QziMaUUYNst9W6fpbC2rmiy
         Jsscs9BZ6M2ex9KPQYzRGo9BwwZuk88n9Hc8Fcw25nIWOQBJk3lOs++lFCQuT4kU8JjV
         6ebrs4Qy7g1YITsotRjLbLzLHNP10EdKjuoMpklSPyHIDemGprkSDlccKe9UcklFysrR
         MkVaPHC2CQK6koJIBDsTaDtQZjUU+p1RLN1xVkHlveIlY0g4VPewh/mgREeeBHO81uyg
         9Gog==
X-Gm-Message-State: AC+VfDzQgi75Jh4Dq6cD/x7HSPtgMPDir2XL7x9EevvbipZrXPEUzBIY
        rtlYQi+zIjbgDcvazIR7XK0HDpfNewy9BwNjxm55L/uEtMyA
X-Google-Smtp-Source: ACHHUZ6Bge/ArExOnk8wEIK3iLc7XEi++eAV73yB8VeTPDfq9sh9MV/yAB5YBU9N9xid7sAkfDKnO8KwEkvb97I4zV8FaBYXRj92
MIME-Version: 1.0
X-Received: by 2002:a02:b1da:0:b0:40f:91fd:6f3c with SMTP id
 u26-20020a02b1da000000b0040f91fd6f3cmr8105325jah.2.1683998981954; Sat, 13 May
 2023 10:29:41 -0700 (PDT)
Date:   Sat, 13 May 2023 10:29:41 -0700
In-Reply-To: <0000000000001ca8c205f0f3ee00@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001f239205fb969174@google.com>
Subject: Re: [syzbot] [xfs?] KASAN: use-after-free Read in xfs_btree_lookup_get_block
From:   syzbot <syzbot+7e9494b8b399902e994e@syzkaller.appspotmail.com>
To:     david@fromorbit.com, dchinner@redhat.com, djwong@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit 22ed903eee23a5b174e240f1cdfa9acf393a5210
Author: Darrick J. Wong <djwong@kernel.org>
Date:   Wed Apr 12 05:49:23 2023 +0000

    xfs: verify buffer contents when we skip log replay

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12710f7a280000
start commit:   1b929c02afd3 Linux 6.2-rc1
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=68e0be42c8ee4bb4
dashboard link: https://syzkaller.appspot.com/bug?extid=7e9494b8b399902e994e
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=172ff2e4480000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11715ea8480000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: xfs: verify buffer contents when we skip log replay

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
