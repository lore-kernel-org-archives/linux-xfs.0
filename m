Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ms55.multrix.com ([87.233.41.159]:33748 "EHLO ms55.multrix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751882AbdHQPPv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Aug 2017 11:15:51 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by ms55.multrix.com (Postfix) with ESMTP id 807BB1F7576
        for <linux-xfs@vger.kernel.org>; Thu, 17 Aug 2017 16:54:49 +0200 (CEST)
Received: from ms55.multrix.com ([127.0.0.1])
        by localhost (ms55.multrix.com [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id wmVSUrk-9uSQ for <linux-xfs@vger.kernel.org>;
        Thu, 17 Aug 2017 16:54:49 +0200 (CEST)
Received: from dmzsha2063.multrix.com (ms16.multrix.local [192.168.6.58])
        by ms55.multrix.com (Postfix) with ESMTP id 6B33C1F73D7
        for <linux-xfs@vger.kernel.org>; Thu, 17 Aug 2017 16:54:49 +0200 (CEST)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by dmzsha2063.multrix.com (Postfix) with ESMTP id 76AB65010B
        for <linux-xfs@vger.kernel.org>; Thu, 17 Aug 2017 16:54:48 +0200 (CEST)
Received: from dmzsha2063.multrix.com ([127.0.0.1])
        by localhost (dmzsha2063.multrix.local [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id IyOb8PqmxLUK for <linux-xfs@vger.kernel.org>;
        Thu, 17 Aug 2017 16:54:48 +0200 (CEST)
Received: from CLDSHA2122.cloud.local (unknown [192.168.116.47])
        by dmzsha2063.multrix.com (Postfix) with ESMTP id 62331500F4
        for <linux-xfs@vger.kernel.org>; Thu, 17 Aug 2017 16:54:48 +0200 (CEST)
From: Sander van Schie / True <Sander.vanSchie@true.nl>
Subject: Issue with "no space left on device"
Date: Thu, 17 Aug 2017 14:54:48 +0000
Message-ID: <1502981688167.22881@true.nl>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

Hello,

I have a 35 GB XFS partition with both plenty of free space and inodes, but I'm still getting the error "No space left on device" when trying to create new files.

Mount options:

# mount | grep vdc1
/dev/vdc1 on /mnt type xfs (rw,relatime,attr2,inode64,noquota)

Used disk space:

# df /dev/vdc1
Filesystem     1K-blocks     Used Available Use% Mounted on
/dev/vdc1       36681200 16066576  20614624  44% /mnt

Used inodes:

# df -i /dev/vdc1
Filesystem     Inodes  IUsed  IFree IUse% Mounted on
/dev/vdc1      917440 199616 717824   22% /mnt

xfs info:

# xfs_info /dev/vdc1
meta-data=/dev/vdc1              isize=2048   agcount=4, agsize=2293695 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1 spinodes=0
data     =                       bsize=4096   blocks=9174779, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal               bsize=4096   blocks=4479, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


I've already tried repairing and rebooting, which unfortunately didn't help.

Any idea what's wrong?

Thanks!

- Sander