Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD971C32773
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Aug 2022 19:30:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345263AbiHRTaL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Aug 2022 15:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245740AbiHRTaK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Aug 2022 15:30:10 -0400
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2059CB5F7
        for <linux-xfs@vger.kernel.org>; Thu, 18 Aug 2022 12:30:08 -0700 (PDT)
Received: by mail-il1-f199.google.com with SMTP id a4-20020a056e0208a400b002e4621942dfso1776122ilt.0
        for <linux-xfs@vger.kernel.org>; Thu, 18 Aug 2022 12:30:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc;
        bh=+AlttEUJA20N8NczqgtZNbuuO2ikQ4TymwOUxEi3ryw=;
        b=Ft8X4VrIgkrpQ6aPJ6szaCEGwYYYhi07Ns7Ga0bAwLnOnzlKU0VhegEifNTCPdMgV6
         SUwVyS2mj9ft9mV9VSzOGScLDLrHbjsDEAX/eSUVuXkTP/ChJgVNylVKvaeNLMCMx5Ml
         Lncbte9QXyvNRRM1rR2TCasGcq6QZMWjpSaqRZlbnnNCJYbYt3TArErkrNabwHJ/7dgc
         TpE0E16K3YSZ/D/fXMM74//ek6bNwlHDfd/yC7xsQgLJHoGQ9nCaPHTrpBJuXOjMNaDB
         OmaVcak/2He4oZ1njMBd2IYOPoDuA60L1VTR/qUpGY+Qfn0BEUI5HIrs5CymE+IqicAO
         iDHA==
X-Gm-Message-State: ACgBeo0CB4bC90HKZKUVkBeFehXzU20SK+ESS93ynCvFYmY/CX1qmd9y
        cozSEgjCQ8R7ovGpjVO/mqSwQRbFvhqQiw45QrToZYHkUant
X-Google-Smtp-Source: AA6agR4UAmMezLXz1QdL+Jr/HN7ZuXxWjt6l79XDTRgUmOm2Q3m/Ad0paUKaIsuluGGFd2/gPgZAmRNnn2rPNDCOfdhWSkBvggvZ
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:198c:b0:2e0:8759:f959 with SMTP id
 g12-20020a056e02198c00b002e08759f959mr2099905ilf.223.1660851008232; Thu, 18
 Aug 2022 12:30:08 -0700 (PDT)
Date:   Thu, 18 Aug 2022 12:30:08 -0700
In-Reply-To: <20220818111117.102681-1-code@siddh.me>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005ee4d705e6890242@google.com>
Subject: Re: [syzbot] WARNING in iomap_iter
From:   syzbot <syzbot+a8e049cd3abd342936b6@syzkaller.appspotmail.com>
To:     code@siddh.me, david@fromorbit.com, djwong@kernel.org,
        fgheet255t@gmail.com, hch@infradead.org,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        riteshh@linux.ibm.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+a8e049cd3abd342936b6@syzkaller.appspotmail.com

Tested on:

commit:         573ae4f1 tee: add overflow check in register_shm_helpe..
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=1334aaeb080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d9d854f607a68b32
dashboard link: https://syzkaller.appspot.com/bug?extid=a8e049cd3abd342936b6
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=117e96d3080000

Note: testing is done by a robot and is best-effort only.
