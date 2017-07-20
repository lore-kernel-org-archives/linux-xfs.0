Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from smtpq2.tb.mail.iss.as9143.net ([212.54.42.165]:38867 "EHLO
        smtpq2.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932416AbdGSWZc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jul 2017 18:25:32 -0400
Received: from [212.54.42.135] (helo=smtp11.tb.mail.iss.as9143.net)
        by smtpq2.tb.mail.iss.as9143.net with esmtp (Exim 4.86_2)
        (envelope-from <richardwbb@versatel.nl>)
        id 1dXxPO-0003QL-3w
        for linux-xfs@vger.kernel.org; Thu, 20 Jul 2017 00:25:30 +0200
Received: from dhcp-077-251-156-033.chello.nl ([77.251.156.33] helo=[192.168.178.3])
        by smtp11.tb.mail.iss.as9143.net with esmtp (Exim 4.86_2)
        (envelope-from <richardwbb@versatel.nl>)
        id 1dXxPO-0003nH-0Z
        for linux-xfs@vger.kernel.org; Thu, 20 Jul 2017 00:25:30 +0200
Message-ID: <1500510327.1939.36.camel@versatel.nl>
Subject: is there a useful purpose to keep "xfs meta-data" when mkfs.xfs has
 created a new file system
From: Richard Waterbeek <richardwbb@versatel.nl>
Date: Thu, 20 Jul 2017 00:25:27 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

I wonder, since I have decided to not follow proper advice, that for
example ext2 is meant for a usb removable volume, while journalling fs
aren't [benchmarking wasn't real slow, but I don't seem to appreciate
i-nodes], nor that the operating system says it has finished copying and
unmount the device seems impossible/ give a long waiting time, and the
hardware blinker on this usb stick I have isn't "lying". That was enough
annoyance to drop the whole ext<n> thing for me.

Now that I've came to the conclusion that jfs somehow didn't want to be
fsck'd at all, I again went with xfs for usb [only this time I attempt
to learn about what I can do and do not. Because instead of backing up,
restoring is just as important as the backup itself.

Now I've learnt that xfs has to be treated well, I saw the following
output with the command "mkfs.xfs /dev/sd<n>"
---
meta-data=/dev/sdc               isize=256    agcount=4, agsize=244928
blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=0        finobt=0
data     =                       bsize=4096   blocks=979712, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
---

I am not only curious but also interested, what xfs is trying to tell
me, when I just asked it to create a new xfs. Since I couldn't get jfs
to do a simple 'fsck -n', and fat and ntfs are of no importance to me,
and that btrfs simply isn't meant that way and on top of that, that ext2
is a bit dated, ext3 isn't clear to me, and ext4 doesn't seem to add
much [I find], the only conclusion that I have now, is to stick with
xfs, and most of the internet advices otherwise.

I wonder if someone on this list can tell me more on the meta-data of
xfs, not my bias to xfs while I wasn't able to give jfs a proper chance.
It is kind of important for a usb backup to know what could go wrong
before anything goes wrong with the data trusted to it. That is why I am
asking here, in the hope that a knowledgeable/ experienced person could
shed some light on this. [for my main purpose, having a "pre-prepared"
disaster recovery plan, instead of just backups].

