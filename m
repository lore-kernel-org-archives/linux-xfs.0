Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3BD5CD3432
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Sep 2023 02:52:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231191AbjISCwq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Sep 2023 22:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231136AbjISCwp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2023 22:52:45 -0400
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 972BC10D
        for <linux-xfs@vger.kernel.org>; Mon, 18 Sep 2023 19:52:39 -0700 (PDT)
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-6c0b345d6acso7461641a34.0
        for <linux-xfs@vger.kernel.org>; Mon, 18 Sep 2023 19:52:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695091959; x=1695696759;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U1IjXmLLQ87nu+7+2vWII1so1UkZOVn9xt4tJ2B60iA=;
        b=irenWCJINkRaJ1gzG+uy9OZatGr/YGKHencAr6JtaRkGTj1LBqGlBqRaoiO8LeyJD4
         Iit5L0Hp1ecxeSdd/EvpeBFMNZKFDnS73IE3ZOOIyDjyBY+pT1zOfrv8WCrX7Q4ERBO+
         rYxodqjeoRJXRLQxfNwo99Y03qWenbKgvnaFFqr7s3NhVs3dRWg8D/b0ZEOfvriLu0Bl
         ybQS1eDFxTpfsePO2HQwtjWYJdy5mj0Qq6uc1oDLZ/Qjktzyk18w5+duUJz4DRZeM4pf
         Encn1xR9cjqPK5VlDn482QRFy7kePUO+TTLAPRNGsH8jy5OblQI85x/LhHylr5UxiYR3
         87DA==
X-Gm-Message-State: AOJu0YyX30YFCY1Nw0mBNjmGGj6nR3UnUFpHkwMv1IK6wkkpOc8AFrfe
        IaQnPJNxBM7R9eDFpxuuofn/sw5yU1xuIamj7hlFARN2a+EO
X-Google-Smtp-Source: AGHT+IGwx53gLAoDlfe5EQgVNwxeuxguK8KPzmoyLvOPdDG6yB0m7AVz3DPTOccsWpwx3pYf7y/rCxOLDGdPEvSWIiS7Pn5s9+g4
MIME-Version: 1.0
X-Received: by 2002:a05:6808:2da:b0:3ad:da36:1dd6 with SMTP id
 a26-20020a05680802da00b003adda361dd6mr648710oid.1.1695091959036; Mon, 18 Sep
 2023 19:52:39 -0700 (PDT)
Date:   Mon, 18 Sep 2023 19:52:38 -0700
In-Reply-To: <000000000000e534bb0604959011@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001486250605ad5abc@google.com>
Subject: Re: [syzbot] [block] INFO: task hung in clean_bdev_aliases
From:   syzbot <syzbot+1fa947e7f09e136925b8@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, brauner@kernel.org, david@fromorbit.com,
        djwong@kernel.org, hare@suse.de, hch@lst.de,
        johannes.thumshirn@wdc.com, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, mcgrof@kernel.org, nogikh@google.com,
        p.raghav@samsung.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

syzbot has bisected this issue to:

commit 487c607df790d366e67a7d6a30adf785cdd98e55
Author: Christoph Hellwig <hch@lst.de>
Date:   Tue Aug 1 17:22:00 2023 +0000

    block: use iomap for writes to block devices

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1086cb74680000
start commit:   f0b0d403eabb Merge tag 'kbuild-fixes-v6.6' of git://git.ke..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1286cb74680000
console output: https://syzkaller.appspot.com/x/log.txt?x=1486cb74680000
kernel config:  https://syzkaller.appspot.com/x/.config?x=999148c170811772
dashboard link: https://syzkaller.appspot.com/bug?extid=1fa947e7f09e136925b8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16148d74680000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13e10762680000

Reported-by: syzbot+1fa947e7f09e136925b8@syzkaller.appspotmail.com
Fixes: 487c607df790 ("block: use iomap for writes to block devices")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
