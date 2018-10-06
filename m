Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it1-f174.google.com ([209.85.166.174]:39682 "EHLO
        mail-it1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726348AbeJGAig (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Oct 2018 20:38:36 -0400
Received: by mail-it1-f174.google.com with SMTP id w200-v6so6950663itc.4
        for <linux-xfs@vger.kernel.org>; Sat, 06 Oct 2018 10:34:25 -0700 (PDT)
MIME-Version: 1.0
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Date: Sat, 6 Oct 2018 22:34:13 +0500
Message-ID: <CABXGCsOxH-gfLL4Mo+RxNk4OoWgAdJzW2Sv2w2He7VkgKxqUug@mail.gmail.com>
Subject: Which fragmentation factor is allowable for xfs (not impact on performance)?
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Which fragmentation factor is allowable for xfs (not impact on performance)?

# xfs_db -c frag -r /dev/sda
actual 4908781, ideal 2801391, fragmentation factor 42.93%
Note, this number is largely meaningless.
Files on this filesystem average 1.75 extents per file

# mount | grep sda
/dev/sda on /home type xfs (rw,relatime,seclabel,attr2,inode64,noquota)

# df -h | grep sda
/dev/sda         11T  5.3T  5.7T  49% /home

I think it too much for partition which are half free.

It would also be interesting to see the fragmentation in the context
of files, but I have not found anywhere how to look at it.

Thanks.

--
Best Regards,
Mike Gavrilov.
