Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E987CE7A89
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Sep 2023 08:58:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233120AbjIYI6j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Sep 2023 04:58:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233127AbjIYI6a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Sep 2023 04:58:30 -0400
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD757107
        for <linux-xfs@vger.kernel.org>; Mon, 25 Sep 2023 01:58:23 -0700 (PDT)
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-3ab7fb11711so15878008b6e.2
        for <linux-xfs@vger.kernel.org>; Mon, 25 Sep 2023 01:58:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695632303; x=1696237103;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EurnUkomrOybXfcgrXZuQitSP0zinzawJwrJpWfbiPA=;
        b=hexku7zUodfdcfoy02BiK6i0iRuYK2ix/gYEiLwPveMARV3gIxGDX9Xtth40pds12P
         fAJpvgCs0viByeEdrwl6VnRfxrYcWHL4pE2bpf3ZFvnVGg63FyVZDfbM6Sx8yZ0hPmf/
         7WtJn/TLfp9YeQy52CcZ21ZHEB9AFRbmL14x6Dd3oGyCaANpB+Y0c6e9si1aEuS0V1VY
         cepnn2HbOk8PgnsS+2dgrOfIPDcukf70h+2v1Zjx746oqyORQpE/pRpIsq2H3M6tNGW3
         GS+gQ70NxbFZdqR0lCaGdXcGi7ZlBn1RZNMuh21dLSTKpp0Hg6zJ8215YJsSZRFYSXUd
         KCrw==
X-Gm-Message-State: AOJu0YzC+lF7nN9tYJESIbqChztRYM9ZcOHXuByP+q5X1jqtyvbj6OPp
        cq/0T5THbFkBt3S5nEELk5LbUHnkH9Dr1deWAiswtLYlB1V8
X-Google-Smtp-Source: AGHT+IF3v5GRFV5mmAfWXw6rV+f8k2QYVWCdAFdC5hzNpU1JfWvb6u1WrQ/KqONLjzxllMrwh858YJvldWtAWl1Gi75391tr4cJK
MIME-Version: 1.0
X-Received: by 2002:a05:6808:20a0:b0:3a7:3b45:74ed with SMTP id
 s32-20020a05680820a000b003a73b4574edmr3859910oiw.0.1695632303202; Mon, 25 Sep
 2023 01:58:23 -0700 (PDT)
Date:   Mon, 25 Sep 2023 01:58:23 -0700
In-Reply-To: <ZRFKBxoRjVQclPS0@infradead.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001a28c006062b292e@google.com>
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

syzbot tried to test the proposed patch but the build/boot failed:

fs/buffer.c:2068:40: error: 'return' with a value, in function returning void [-Werror=return-type]


Tested on:

commit:         b8908de1 iomap: add a workaround for racy i_size updat..
git tree:       git://git.infradead.org/users/hch/misc.git bdev-iomap-fix
kernel config:  https://syzkaller.appspot.com/x/.config?x=999148c170811772
dashboard link: https://syzkaller.appspot.com/bug?extid=1fa947e7f09e136925b8
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Note: no patches were applied.
