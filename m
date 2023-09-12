Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E7A1CA0EF2
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Sep 2023 16:10:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234670AbjILQKU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Sep 2023 12:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236620AbjILQJo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Sep 2023 12:09:44 -0400
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 571FF1723
        for <linux-xfs@vger.kernel.org>; Tue, 12 Sep 2023 09:09:40 -0700 (PDT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-577af71a2a8so741825a12.3
        for <linux-xfs@vger.kernel.org>; Tue, 12 Sep 2023 09:09:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694534980; x=1695139780;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AARlkl615ZUGGLFRfA9oVBXF7htkT9kJFgokf8340Ec=;
        b=RM4FnWESJeHebUWPJMM3nLzy+hufnlHnZvP24Wu1hNsHg/+oQsaNhVV+e5BzW45zsI
         b0sQchdim3F822EQoE+EJC9iEvWDBzLpJhRt46QvqUx5AzI0ZP9eavz2RfiR6qz4lOIN
         iG+w/hMJ3LEEgDOgXStIxWHzcTLvkNQsXC8R9R/luEZpbtg8DgpVDBP8OYdGUmZBwCfH
         N+dDDCyM4GViOoi9f6fHKyyfiZm1nsAtw+nNrf2wQ5CunlywzdIuThtA0Y1aROI78MR1
         gbIse3m91TGK9KJv7Vf8xs/nIarsYPM94SHc+QRE4qQBKgFDIBCfuOTTtG7xdLzYqSmZ
         RMUA==
X-Gm-Message-State: AOJu0YybvOZ3jPVjaYbk6HScXB1ou1f24KGrA0huk7+0m0EIHEwPBn0M
        W4PC9kdeX+EI/Cmu36elrYShPUs9F0OxECQqfLEqervl5yqr
X-Google-Smtp-Source: AGHT+IGmbnURw9iUYORzpx4zYzKhO+uYCyE7mL3DVcRhUXuaET8MI50eU927MgZ+N8oEvTnRJI6eHK1KQne2J49J5nuKknxf1Mkr
MIME-Version: 1.0
X-Received: by 2002:a63:3409:0:b0:563:e937:5e87 with SMTP id
 b9-20020a633409000000b00563e9375e87mr2908645pga.5.1694534979875; Tue, 12 Sep
 2023 09:09:39 -0700 (PDT)
Date:   Tue, 12 Sep 2023 09:09:39 -0700
In-Reply-To: <00000000000019e05005ef9c1481@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000088fbf106052bab18@google.com>
Subject: Re: [syzbot] [xfs?] KASAN: stack-out-of-bounds Read in xfs_buf_delwri_submit_buffers
From:   syzbot <syzbot+d2cdeba65d32ed1d2c4d@syzkaller.appspotmail.com>
To:     chandan.babu@oracle.com, davem@davemloft.net, djwong@kernel.org,
        hdanton@sina.com, jiri@nvidia.com, kuba@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit d772781964415c63759572b917e21c4f7ec08d9f
Author: Jakub Kicinski <kuba@kernel.org>
Date:   Fri Jan 6 06:33:54 2023 +0000

    devlink: bump the instance index directly when iterating

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15554ba4680000
start commit:   3ecc37918c80 Merge tag 'media/v6.1-4' of git://git.kernel...
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=d58e7fe7f9cf5e24
dashboard link: https://syzkaller.appspot.com/bug?extid=d2cdeba65d32ed1d2c4d
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=170a950b880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1625948f880000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: devlink: bump the instance index directly when iterating

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
