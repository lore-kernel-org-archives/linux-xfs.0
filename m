Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D67CC77B78
	for <linux-xfs@archiver.kernel.org>; Wed,  3 May 2023 00:14:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbjECAOW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 May 2023 20:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjECAOV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 May 2023 20:14:21 -0400
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC2302680
        for <linux-xfs@vger.kernel.org>; Tue,  2 May 2023 17:14:20 -0700 (PDT)
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-32f240747cdso5750525ab.1
        for <linux-xfs@vger.kernel.org>; Tue, 02 May 2023 17:14:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683072860; x=1685664860;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aEdJNQ3lVemRBJ6NDcWKHIv1GrI4GPEwiZ9AMbObejI=;
        b=SsGip3lDuLe53K5WPw7ycZX7HbGs9dgIiUkEwz8QOPA65gQNpbwu9psheoMQzvzeh8
         0O6l2wAvoGpzXatdtBsjd9BEDFa06QJxRJNHmfNRXfH/yHoQK3lQtbNcRvNpYYuRYR3e
         qihUmTv1RmqFglFVdMzxsQ9+b0sJRNMAlo6F10Sq3y9jGAHU4h3UGHz116zcTUhPAm39
         gu9mEqiqG6w+D1DNcejHz7uR+iIqBJFb5FjePdLiENmhZgHA7jppTmPQ/hqyZu035hJ+
         zjQuxGiR1P4JEuqA52ZAG+qKE65otBJRGvZPv1vbY0cSH0gI83QIImPDjA2yNGaQ/Q/3
         4F+g==
X-Gm-Message-State: AC+VfDye3rxyjCxpWatcpyT4HHzKKQHDbLKzFo08spOlEfND/njFnrZ8
        k63w8IlhLFyFUIqbw9uGH8pSfl0xIDPTQIYQCL77FHdY3BU/
X-Google-Smtp-Source: ACHHUZ5e2IPTjcLMfP6jQLHxh4OYc6OTUlfjWdAA5ZTwkTyRYf//kTp+GPJd+erhDob5I1HICqBbh/IITvBBI5MUjeGLg8TdIa1F
MIME-Version: 1.0
X-Received: by 2002:a02:966f:0:b0:40f:9d2e:24ae with SMTP id
 c102-20020a02966f000000b0040f9d2e24aemr275427jai.0.1683072860029; Tue, 02 May
 2023 17:14:20 -0700 (PDT)
Date:   Tue, 02 May 2023 17:14:20 -0700
In-Reply-To: <20230502220039.GC15394@frogsfrogsfrogs>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f40bf505fabeeff7@google.com>
Subject: Re: [syzbot] [xfs?] KASAN: slab-out-of-bounds Read in xfs_getbmap
From:   syzbot <syzbot+c103d3808a0de5faaf80@syzkaller.appspotmail.com>
To:     djwong@kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+c103d3808a0de5faaf80@syzkaller.appspotmail.com

Tested on:

commit:         55901cd7 xfs: fix xfs_inodegc_stop racing with mod_del..
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git inodegc-fixes-6.4_2023-05-02
console output: https://syzkaller.appspot.com/x/log.txt?x=11a2556fc80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=64660a60375eadd7
dashboard link: https://syzkaller.appspot.com/bug?extid=c103d3808a0de5faaf80
compiler:       Debian clang version 15.0.7, GNU ld (GNU Binutils for Debian) 2.35.2

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
