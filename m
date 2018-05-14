Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:40928 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754024AbeENRP3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 May 2018 13:15:29 -0400
Received: by mail-oi0-f54.google.com with SMTP id c203-v6so11372258oib.7
        for <linux-xfs@vger.kernel.org>; Mon, 14 May 2018 10:15:29 -0700 (PDT)
MIME-Version: 1.0
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 14 May 2018 11:15:27 -0600
Message-ID: <CAJCQCtQbns7bbE=mWvYuWMi+R5wdphfEjF1F995PVBsoUovnpg@mail.gmail.com>
Subject: xfsprogs 4.16.0 format change, GRUB error unknown filesystem
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs list <linux-xfs@vger.kernel.org>

Downstream bug, Fedora Rawhide being a canary in the coal mine!
https://bugzilla.redhat.com/show_bug.cgi?id=1575797

Comment 8 about the kernel warning related to freeze/thaw is curious
but ends up being unrelated to this problem.

The gist is that xfsprogs 4.16.0 formatted volumes aren't recognized
by either GRUB user space tools, or the GRUB core.img (whether of the
embedded BIOS variety or the grubx64.efi variety)

Anyway, open question for XFS devs if this should be fixed in xfsprogs
or GRUB. I haven't tested this with syslinux to know if it has a
similar problem.


-- 
Chris Murphy
