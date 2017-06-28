Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from smtpq2.tb.mail.iss.as9143.net ([212.54.42.165]:39742 "EHLO
        smtpq2.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751511AbdF1TmS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Jun 2017 15:42:18 -0400
Received: from [212.54.42.136] (helo=smtp12.tb.mail.iss.as9143.net)
        by smtpq2.tb.mail.iss.as9143.net with esmtp (Exim 4.86_2)
        (envelope-from <richardwbb@versatel.nl>)
        id 1dQIqu-0003ns-20
        for linux-xfs@vger.kernel.org; Wed, 28 Jun 2017 21:42:16 +0200
Received: from c16067.upc-c.chello.nl ([212.187.16.67] helo=[192.168.0.3])
        by smtp12.tb.mail.iss.as9143.net with esmtp (Exim 4.86_2)
        (envelope-from <richardwbb@versatel.nl>)
        id 1dQIqt-0007SC-VT
        for linux-xfs@vger.kernel.org; Wed, 28 Jun 2017 21:42:16 +0200
Message-ID: <1498686205.13847.1.camel@versatel.nl>
Subject: non mountable xfs with 2 primary and 2 logical
From: Richard Waterbeek <richardwbb@versatel.nl>
Date: Wed, 28 Jun 2017 21:43:25 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi linux-xfs mailinglist,

I've recently subscribed to this list. I've seen many messages, but have
little understading of the 'XFS' file system. I know about mkfs.xfs.
I've benched my hardware. But, now my harddrive had a collision with the
mbr somehow. [or something]

But, now I've 'hexdumped', the first 512 bytes, [because after a
disaterous reboot, cfdisk is now saying; "/dev/sda empty".

I'm aware of two primary and two logical partitions. I feel that I know
the size of the first and second primary, but the xfs/ sda5 and, xfs
sda6, are no longer appearing. I had to '#' the /etc/fstab, because it
won't boot [long waiting].

Now I would like to restore the first 512 bytes which is the MBR.

I have absolutely no understanding of -where-, "the SuperBlock" [or how
that should be called], happens to be.

But, I feel that 512 bytes missing and no reason to believe a whole
Terabyte would be "ones and/ or zero's", now, I wonder, how to restore
this. I have not made backup of this harddrive, just an rsync, which is
a little outdated and a bit incomplete, because difference in size of
both drives.

I might be able to create a XFS-something [from /dev/sda, for example],
and write that with dd. 

But, before I would 'try this out', I would like to gain some
understanding, of what -should- be on the first 512 bytes of a
harddrive, besides what I have now, cfdisk is saying empty.

Hoping to receive a reply, Richard, the Netherlands

