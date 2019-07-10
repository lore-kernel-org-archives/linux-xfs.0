Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bonobo.elm.relay.mailchannels.net ([23.83.212.22]:30959 "EHLO
        bonobo.elm.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727220AbfGJXn5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Jul 2019 19:43:57 -0400
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 0ED3C6A2364
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jul 2019 23:43:55 +0000 (UTC)
Received: from pdx1-sub0-mail-a44.g.dreamhost.com (100-96-1-113.trex.outbound.svc.cluster.local [100.96.1.113])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 69CB66A250E
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jul 2019 23:43:54 +0000 (UTC)
Received: from pdx1-sub0-mail-a44.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a44.g.dreamhost.com (Postfix) with ESMTP id 9010484229
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jul 2019 16:43:49 -0700 (PDT)
Received: from [172.23.0.131] (broadband-178-140-10-107.ip.moscow.rt.ru [178.140.10.107])
        (using TLSv1.1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: a-j@a-j.ru)
        by pdx1-sub0-mail-a44.g.dreamhost.com (Postfix) with ESMTPSA id F3F0A84222
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jul 2019 16:43:48 -0700 (PDT)
Date: Thu, 11 Jul 2019 02:43:40 +0300
From: Andrey Zhunev <a-j@a-j.ru>
Message-ID: <18310556842.20190711024340@a-j.ru>
Subject: Re: Need help to recover root filesystem after a power supply issue
In-Reply-To: <CAJCQCtS0EfAghBGoL-YVTEANfAXV4Oy7Q+4Q0Jp3xOF-uQhixA@mail.gmail.com>
References: <958316946.20190710124710@a-j.ru>
  <CAJCQCtTpdGxB4r04wPNE+PRV5Jx_m95kShwvLJ5zxdmfw2fnEw@mail.gmail.com>
  <1373677058.20190710182851@a-j.ru>
  <CAJCQCtSpkAS086zSDCfB1jMQXZuacfE-SfyqQ2td4Ven4GwAzg@mail.gmail.com>
  <1015034894.20190710190746@a-j.ru>
  <CAJCQCtSTPaor-Wo6b1NF3QT_Pi2rO7B9QMbfudZS=9TEt-Oemw@mail.gmail.com>
  <CAJCQCtQn17ktjatXU5vvFjfsfEJx8EDrq1+b8+O1yvAf7ij96w@mail.gmail.com>
  <816157686.20190710201614@a-j.ru>
  <CAJCQCtQ08-hu7Cr2Li4v07r8v1isxZu=_hP3aQpHqJw4D2jCmg@mail.gmail.com>
  <e1dea87a-a2d8-4f4c-8807-4027a1a03a41@telefonica.net>
  <CAJCQCtS0EfAghBGoL-YVTEANfAXV4Oy7Q+4Q0Jp3xOF-uQhixA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs list <linux-xfs@vger.kernel.org>


Ok, the ddrescue finished copying whatever it was able to recover.
There were many unreadable sectors near the end of the drive.
In total, there were over 170 pending sectors reported by SMART.

I then ran the following commands:

# smartctl -l scterc,900,100 /dev/sda
# echo 180 > /sys/block/sda/device/timeout

But this didn't help at all. The unreadable sectors still remained
unreadable.

So I wiped them with hdparm:
# hdparm --yes-i-know-what-i-am-doing --write-sector <sector_number> /dev/sda

I then re-read all these sectors, and they were all read correctly.

The number of pending sectors reported by SMART dropped down to 7.
Interestingly, there are still NO reallocated sectors reported.


Now, the xfs-repair reported the following:

# xfs_repair /dev/centos/root
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
ERROR: The filesystem has valuable metadata changes in a log which needs to
be replayed.  Mount the filesystem to replay the log, and unmount it before
re-running xfs_repair.  If you are unable to mount the filesystem, then use
the -L option to destroy the log and attempt a repair.
Note that destroying the log may cause corruption -- please attempt a mount
of the filesystem before doing this.


But I was still unable to momunt the filesystem:

# mount /dev/centos/root /tmp/root/
mount: mount /dev/mapper/centos-root on /tmp/root failed: Structure needs cleaning


So I went ahead with the '-L', and after some time the xfs_repair
completed the repair.


I can now mount my / partition successfully!
Most of the data seems to be there (I didn't check all of it, yet).

First thing I checked was the original kernel log. And yes, Chris was
right! There are a few warnings reporting read errors on /dev/sda.
These obviously were logged before the PSU failed. So the PSU might
have been just a coincidence...


Thanks a lot to everybody for your great help and support!!!



BTW, interestingly enough, those 7 pending sectors "disappeared" after
a power cycle. Maybe they were on some internal space on the HDD, not
accessible to users?
The SMART on this drive looks pretty clean now:

ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  Always       -       867
  3 Spin_Up_Time            0x0027   181   179   021    Pre-fail  Always       -       5916
  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Always       -       175
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Always       -       0
  7 Seek_Error_Rate         0x002e   100   253   000    Old_age   Always       -       0
  9 Power_On_Hours          0x0032   022   022   000    Old_age   Always       -       56949
 10 Spin_Retry_Count        0x0032   100   100   000    Old_age   Always       -       0
 11 Calibration_Retry_Count 0x0032   100   100   000    Old_age   Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       175
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Always       -       112
193 Load_Cycle_Count        0x0032   200   200   000    Old_age   Always       -       62
194 Temperature_Celsius     0x0022   117   091   000    Old_age   Always       -       33
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0030   100   253   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age   Always       -       0
200 Multi_Zone_Error_Rate   0x0008   100   253   000    Old_age   Offline      -       0




---
Best regards,
 Andrey
