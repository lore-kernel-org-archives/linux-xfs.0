Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:38643 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750913AbeFCCc0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 2 Jun 2018 22:32:26 -0400
Received: from Thorsten-PC.fritz.box ([5.147.28.226]) by mail.gmx.com
 (mrgmx001 [212.227.17.190]) with ESMTPSA (Nemesis) id
 0M0h9K-1gIvfr1C2g-00uswj for <linux-xfs@vger.kernel.org>; Sun, 03 Jun 2018
 04:32:25 +0200
Message-ID: <0ae6d0d5984dcd9c703720bdf41b6da1333267b0.camel@quantentunnel.de>
Subject: Re: Strange XFS problem
From: Thorsten Hufnagel <Mondsuechtig@quantentunnel.de>
Date: Sun, 03 Jun 2018 04:32:24 +0200
In-Reply-To: <e462d333d2089a7c3c59e7584fa83f720365fa46.camel@quantentunnel.de>
References: <e462d333d2089a7c3c59e7584fa83f720365fa46.camel@quantentunnel.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

I just Got it.

The issue seemed to got fixed with 4.16.0-rc1.

Downloading / compiling / using the 4.16.1 version solved my issue.

Sorry for bothering,

Thorsten


Am Sonntag, den 03.06.2018, 03:51 +0200 schrieb Thorsten Hufnagel:
> Hi there,
> 
> I've just a big problem with my XFS file system used on a mdraid raid
> 5
> array.
> 
> It started with the situation that the mount of my device was not
> possible any more (don't know why, hdd's are OK).
> 
> "xfs_repair" results in
> 
> "
> ERROR: The log head and/or tail cannot be discovered. Attempt to
> mount
> the
> filesystem to replay the log or use the -L option to destroy the log
> and
> attempt a repair.
> "
> 
> "xfs_repair -L " ran, but unfortunately it was interrupted by an
> automatic server shutdown after it stuck after stage 7.
> 
> Now, "xfs_repair" results in
> 
> "
> Phase 1 - Superblock finden und überprüfen...
>         - Berichts-Prozess in Abständen von 15 Minutes
> Phase 2 - ein internes Protokoll benutzen
>         - Null-Protokoll...
> Log inconsistent or not a log (last==0, first!=1)
> empty log check failed
> zero_log: cannot find log head/tail (xlog_find_tail=22)
> ERROR: The log head and/or tail cannot be discovered. Attempt to
> mount
> the
> filesystem to replay the log or use the -L option to destroy the log
> and
> attempt a repair.
> "
> 
> A mount attemp results in 
> 
> "
> mount: /mnt/test: Falscher Dateisystemtyp, ungültige Optionen, der
> Superblock von /dev/md2 ist beschädigt, fehlende Kodierungsseite oder
> ein anderer Fehler.
> "
> 
> And "xfs_repair -L" results in 
> 
> "
> Phase 1 - Superblock finden und überprüfen...
>         - Berichts-Prozess in Abständen von 15 Minutes
> Phase 2 - ein internes Protokoll benutzen
>         - Null-Protokoll...
> Log inconsistent or not a log (last==0, first!=1)
> empty log check failed
> zero_log: cannot find log head/tail (xlog_find_tail=22)
> "
> 
> Sounds linke some kind of "Hen-egg" problem.
> 
> Is there any change to get the XFS file sytem back running without
> recreating the filesystem?
> 
> Kernel:
> 
> "
> uname -r
> 4.16.12-1-default
> "
> 
> Distribution: "Opensuse - Tumbleween"
> 
> XFS tools: "xfs_repair Version 4.15.1"
> 
> Thank you in advance,
> Kind regards,
> 
> Thorsten Hufnagel
> 
