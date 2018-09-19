Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f51.google.com ([209.85.128.51]:52544 "EHLO
        mail-wm1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727772AbeISTmW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Sep 2018 15:42:22 -0400
Received: by mail-wm1-f51.google.com with SMTP id y139-v6so6380293wmc.2
        for <linux-xfs@vger.kernel.org>; Wed, 19 Sep 2018 07:04:17 -0700 (PDT)
MIME-Version: 1.0
From: Jan Tulak <jtulak@redhat.com>
Date: Wed, 19 Sep 2018 16:04:05 +0200
Message-ID: <CACj3i72BoYea5juHP98nRcFB+YDzcigfb7UWO1KC0y+oh_Ff9A@mail.gmail.com>
Subject: [xfstests] xfs/191-input-validation issues
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Hi guys

I see that there are some failed assertions in the xfs/191 test and
they can be sorted into a few categories:

pass -n size=2b /dev/sda2
pass -d agsize=8192b /dev/sda2
pass -d agsize=65536s /dev/sda2
pass -l su=10b /dev/sda2
pass -d su=4096s,sw=64 /dev/sda2
pass -d su=4096b,sw=64 /dev/sda2

Here mkfs assumes a default block/sector size, so these checks can be deleted.

fail -n log=15 /dev/sda2
fail -i log=10 /dev/sda2

These checks can be removed too, log sizes have been removed from mkfs.xfs.

pass -d su=0,sw=64 /dev/sda2

And if I understand the current behaviour, -d su=0 is the same as su
not used at all, so this check should be changed to expect pass
instead of fail.

Everyone agrees with this assessment that the test 191 needs to be
updated and none of this is a bug of mkfs?

Cheers,
Jan

-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me
