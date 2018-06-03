Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:45917 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750964AbeFCBv5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 2 Jun 2018 21:51:57 -0400
Received: from Thorsten-PC.fritz.box ([5.147.28.226]) by mail.gmx.com
 (mrgmx102 [212.227.17.168]) with ESMTPSA (Nemesis) id
 0LuJDv-1gPGtI3icR-011hjR for <linux-xfs@vger.kernel.org>; Sun, 03 Jun 2018
 03:51:55 +0200
Message-ID: <e462d333d2089a7c3c59e7584fa83f720365fa46.camel@quantentunnel.de>
Subject: Strange XFS problem
From: Thorsten Hufnagel <Mondsuechtig@quantentunnel.de>
Date: Sun, 03 Jun 2018 03:51:55 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi there,

I've just a big problem with my XFS file system used on a mdraid raid 5
array.

It started with the situation that the mount of my device was not
possible any more (don't know why, hdd's are OK).

"xfs_repair" results in

"
ERROR: The log head and/or tail cannot be discovered. Attempt to mount
the
filesystem to replay the log or use the -L option to destroy the log
and
attempt a repair.
"

"xfs_repair -L " ran, but unfortunately it was interrupted by an
automatic server shutdown after it stuck after stage 7.

Now, "xfs_repair" results in

"
Phase 1 - Superblock finden und überprüfen...
        - Berichts-Prozess in Abständen von 15 Minutes
Phase 2 - ein internes Protokoll benutzen
        - Null-Protokoll...
Log inconsistent or not a log (last==0, first!=1)
empty log check failed
zero_log: cannot find log head/tail (xlog_find_tail=22)
ERROR: The log head and/or tail cannot be discovered. Attempt to mount
the
filesystem to replay the log or use the -L option to destroy the log
and
attempt a repair.
"

A mount attemp results in 

"
mount: /mnt/test: Falscher Dateisystemtyp, ungültige Optionen, der
Superblock von /dev/md2 ist beschädigt, fehlende Kodierungsseite oder
ein anderer Fehler.
"

And "xfs_repair -L" results in 

"
Phase 1 - Superblock finden und überprüfen...
        - Berichts-Prozess in Abständen von 15 Minutes
Phase 2 - ein internes Protokoll benutzen
        - Null-Protokoll...
Log inconsistent or not a log (last==0, first!=1)
empty log check failed
zero_log: cannot find log head/tail (xlog_find_tail=22)
"

Sounds linke some kind of "Hen-egg" problem.

Is there any change to get the XFS file sytem back running without
recreating the filesystem?

Kernel:

"
uname -r
4.16.12-1-default
"

Distribution: "Opensuse - Tumbleween"

XFS tools: "xfs_repair Version 4.15.1"

Thank you in advance,
Kind regards,

Thorsten Hufnagel


