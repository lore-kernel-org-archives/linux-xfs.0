Return-Path: <SRS0=aYBA=4Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A415C3F2CF
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 08:01:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E96C24677
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 08:01:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725877AbgB1IBJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 03:01:09 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:39687 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725871AbgB1IBI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Feb 2020 03:01:08 -0500
Received: by mail-il1-f200.google.com with SMTP id s71so2549283ill.6
        for <linux-xfs@vger.kernel.org>; Fri, 28 Feb 2020 00:01:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=1F6QPB2AKxQKkbwngYuex+ythgWDXEu9f8wBzkprX/k=;
        b=USA4z+MOweZzm8K39QS0GE/8FYW+LGNyC/+RqfydsU1tjSTsJZCLluniBCsDfD2WiB
         ejC2/cCxgxO8K86eKqrGdCQwtLxiQt0uk4ArWHYZYOUaWgLv5cWwu0HxMedVu2L+ttCQ
         abqdBfuLIXg1ntgC9C/XiRXpcImmSHA63q81xYY/6BOlYItb+QJQ8Dx19CjAr3o+MNAr
         BIR3xh5FQXS9E7PUDV0YII8QYfGui4IehyT3tQW3GPICSwcI9swLe4eaFoDTu7nRyQxd
         vIu7vG0pPoJZv5dH+f8bCcjmVRLuF/DpUCu28NPfCf81rdRBNDzOys3vopBpJgvrxurF
         urDg==
X-Gm-Message-State: APjAAAXReib9N95q+eoUqUlX592HJQFIEACrgVcZETzzk0O2f9cYjacs
        54SBnhwDJkvoMK+etm9a7/QHLcBMze+H8utissLDZNc8MUcu
X-Google-Smtp-Source: APXvYqyCdCt0FOj0yuszPQuUzfZt28lIMDARNbm9oe7j9Fsm9wccCAjjlvl9UJmifoWVHQmVmtgJmGe483ST03I3G5Kn1N1InVd3
MIME-Version: 1.0
X-Received: by 2002:a92:d608:: with SMTP id w8mr3044015ilm.95.1582876868273;
 Fri, 28 Feb 2020 00:01:08 -0800 (PST)
Date:   Fri, 28 Feb 2020 00:01:08 -0800
In-Reply-To: <0000000000005f386305988bb15f@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000074eed3059f9e3d0a@google.com>
Subject: Re: BUG: unable to handle kernel paging request in xfs_sb_read_verify
From:   syzbot <syzbot+6be2cbddaad2e32b47a0@syzkaller.appspotmail.com>
To:     allison.henderson@oracle.com, bfoster@redhat.com,
        darrick.wong@oracle.com, dchinner@redhat.com, dja@axtens.net,
        dvyukov@google.com, kasan-dev@googlegroups.com,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        sandeen@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This bug is marked as fixed by commit:
kasan: support vmalloc backing of vm_map_ram()
But I can't find it in any tested tree for more than 90 days.
Is it a correct commit? Please update it by replying:
#syz fix: exact-commit-title
Until then the bug is still considered open and
new crashes with the same signature are ignored.
