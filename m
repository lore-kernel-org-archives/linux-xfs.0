Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from firestarter.dermichi.com ([194.177.153.153]:47776 "EHLO
        firestarter.dermichi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761956AbdDSL0f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Apr 2017 07:26:35 -0400
Received: from noclinksys.net4you.net ([194.177.153.180] helo=[192.168.34.111])
        by firestarter.dermichi.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim)
        (envelope-from <mw@dermichi.com>)
        id 1d0nJG-0000B9-60
        for linux-xfs@vger.kernel.org; Wed, 19 Apr 2017 12:58:06 +0200
From: Michael Weissenbacher <mw@dermichi.com>
Subject: xfsaild in D state seems to be blocking all other i/o sporadically
Message-ID: <e5f2ccc2-7923-934c-e655-59983903ca11@dermichi.com>
Date: Wed, 19 Apr 2017 12:58:05 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi List!
I have a storage server which primarily does around 15-20 parallel
rsync's, nothing special. Sometimes (3-4 times a day) i notice that all
I/O on the file system suddenly comes to a halt and the only process
that continues to do any I/O (according to iotop) is the process
xfsaild/md127. When this happens, xfsaild only does reads (according to
iotop) and consistently in D State (according to top).
Unfortunately this can sometimes stay like this for 5-15 minutes. During
this time even a simple "ls" our "touch" would block and be stuck in D
state. All other running processes accessing the fs are of course also
stuck in D state. It is a XFS V5 filesystem.
Then again, as sudden as it began, everything goes back to normal and
I/O continues. The problem is accompanied with several "process blocked
for xxx seconds" in dmesg and also some dropped connections due to
network timeouts.

I've tried several things to remedy the problem, including:
  - changing I/O schedulers (tried noop, deadline and cfq). Deadline
seems to be best (the block goes away in less time compared with the
others).
  - removing all mount options (defaults + usrquota, grpquota)
  - upgrading to the latest 4.11.0-rc kernel (before that i was on 4.9.x)

Nothing of the above seemed to have made a significant change to the
problem.

xfs_info output of the fs in question:
meta-data=/dev/md127             isize=512    agcount=33,
agsize=268435440 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1 spinodes=0 rmapbt=0
         =                       reflink=0
data     =                       bsize=4096   blocks=8789917696, imaxpct=10
         =                       sunit=16     swidth=96 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal               bsize=4096   blocks=521728, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

Storage Subsystem: Dell Perc H730P Controller 2GB NVCACHE, 12 6TB Disks,
RAID-10, latest Firmware Updates

I would be happy to dig out more information if needed. How can i find
out if the RAID Controller itself gets stuck? Nothing bad shows up in
the hardware and SCSI controller logs.

Thanks,
Michael
