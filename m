Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3D18CE7A89
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Sep 2023 09:35:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233254AbjIYJf1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Sep 2023 05:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233245AbjIYJfZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Sep 2023 05:35:25 -0400
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBD6410D
        for <linux-xfs@vger.kernel.org>; Mon, 25 Sep 2023 02:35:17 -0700 (PDT)
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-6c4ecdd6dc9so2119407a34.1
        for <linux-xfs@vger.kernel.org>; Mon, 25 Sep 2023 02:35:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695634517; x=1696239317;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZXYTV27b/N8e9iQla3A3UJA2EkuMETgjqWyl7SSeebs=;
        b=o9+5XJWn/1NUzpM9eUmWxaOcGuIlWsLDDZyFs5qgH08Jd7b2XuFoU71xXFnLF2O0q4
         nFPqvNoI3XuVAFY+Ha/Adxhxu+N1dwxgT4Y5h0i+3OUzahln3oYWxofCvyQZx7RnMcSy
         eRxK/Ai4GesFLgcFZCI/+cdpi1hmj4FFU5JWadbHaAJ+XCTtBLlQaHymQvbn3WLAvI/W
         qyMrau2pW5qx85ZyDIKC8bX9+OWorYAOp65j0lQqbV30yiWsyfLJkuFTcZoezwTlVYnW
         MKYYQN6NeAaukKTQjKr5egOS0DqxRdbO53gVpr6ofgK0o+V6N6Y9h5E0gx5JYrY23+LU
         hxVA==
X-Gm-Message-State: AOJu0Yw2bHTQrZ8IHBNUeEky/9iXo/LcN25FIxi0osYGZqOKq4t8yMfp
        Zx9CF+hLulCGx699VrLhHtBG/DatnFozEKzQAh3zCOknrT0Y
X-Google-Smtp-Source: AGHT+IHDz9RoPAb2qZE9UPgDO/asesN/srR+GdA9z0sEGZ2bsprnsSEAzagQU+tQqe+y6Xo3Qy7f0U9VW6CgE3VRMxffklSI5wt0
MIME-Version: 1.0
X-Received: by 2002:a05:6830:3147:b0:6c4:e41c:6e6a with SMTP id
 c7-20020a056830314700b006c4e41c6e6amr1087261ots.4.1695634517333; Mon, 25 Sep
 2023 02:35:17 -0700 (PDT)
Date:   Mon, 25 Sep 2023 02:35:17 -0700
In-Reply-To: <ZRFOI/TUQwJEw5/s@infradead.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000131d7c06062bad29@google.com>
Subject: Re: [syzbot] [block] INFO: task hung in clean_bdev_aliases
From:   syzbot <syzbot+1fa947e7f09e136925b8@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, brauner@kernel.org, david@fromorbit.com,
        djwong@kernel.org, hare@suse.de, hch@infradead.org, hch@lst.de,
        johannes.thumshirn@wdc.com, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, mcgrof@kernel.org, nogikh@google.com,
        p.raghav@samsung.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+1fa947e7f09e136925b8@syzkaller.appspotmail.com

Tested on:

commit:         ca5e3ec4 iomap: add a workaround for racy i_size updat..
git tree:       git://git.infradead.org/users/hch/misc.git bdev-iomap-fix
console output: https://syzkaller.appspot.com/x/log.txt?x=16d98efa680000
kernel config:  https://syzkaller.appspot.com/x/.config?x=710dc49bece494df
dashboard link: https://syzkaller.appspot.com/bug?extid=1fa947e7f09e136925b8
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
