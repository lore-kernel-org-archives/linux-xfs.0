Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:38420 "EHLO
        mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753648AbeEYRCt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 May 2018 13:02:49 -0400
Received: by mail-io0-f170.google.com with SMTP id z4-v6so7137774iof.5
        for <linux-xfs@vger.kernel.org>; Fri, 25 May 2018 10:02:48 -0700 (PDT)
MIME-Version: 1.0
From: "Patrick J. LoPresti" <lopresti@gmail.com>
Date: Fri, 25 May 2018 10:02:47 -0700
Message-ID: <CAKGkouuK6Dz82JBx2s8cccC-ST_enhF3jyVCHr+w=O_-QeppRw@mail.gmail.com>
Subject: Temporary drive failure leads to massive data corruption?
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi. We are using XFS on a hardware RAID6 container with around 100
terabytes of data in 500K files. (Actually, we have four such
containers per server and around a dozen servers.)

Anyway, we had a power event a couple of nights ago that took several
of the drives -- and thus the container -- offline.

We got the drives, and thus the hardware RAID6, back online, but when
we tried to mount the file system the message said it was corrupted
and we should run xfs_repair. Running xfs_repair complained that there
were uncommitted entries in the transaction log and we should try to
mount the file system.

Ultimately, we had to use "xfs_repair -L" to get the file system to mount.

Now, I understand that any files or directories being modified during
the event could be corrupted. But we are seeing something completely
different; namely...

Tens of thousands of our files -- each 100-ish megabytes -- appear to
have had large sections replaced with zeroes. (We are still evaluating
the damage.) None of these files were being modified at the time; in
fact, the majority were written years ago and are never changed.

Is this an expected failure mode for XFS? I understand we may have
corrupted a few disk blocks, but should we expect that to corrupt a
significant fraction of our at-rest data?

This is using Red Hat Enterprise Linux 6.6 (kernel
2.6.32-504.16.2.el6.x86_64 of Tue Apr 21 10:35:19 CDT 2015), if it
makes a difference.

Thanks!

 - Pat
