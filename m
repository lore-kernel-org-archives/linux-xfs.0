Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.75]:56783 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933287AbeAKWox (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Jan 2018 17:44:53 -0500
Received: from localhost ([88.90.245.8]) by mrelayeu.kundenserver.de (mreue101
 [212.227.15.183]) with ESMTPSA (Nemesis) id 0Letvr-1fDTzP0N9r-00qkMs for
 <linux-xfs@vger.kernel.org>; Thu, 11 Jan 2018 23:44:52 +0100
Date: Thu, 11 Jan 2018 23:44:51 +0100
From: Heinz Diehl <htd+ml@fritha.org>
Subject: XFS journal corruption after every reboot/shutdown
Message-ID: <20180111224451.GA3413@fritha.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi,

the root partition on three different Fedora 27 based machines is
XFS-formatted. After every reboot or shutdown, dmesgs shows the following lines after
restarting:

[htd@kiera ~]$ dmesg | grep XFS
[    2.773271] SGI XFS with ACLs, security attributes, no debug enabled
[    2.774950] XFS (sda2): Mounting V4 Filesystem
[    2.851266] XFS (sda2): Starting recovery (logdev: internal)
[    2.876522] XFS (sda2): Ending recovery (logdev: internal)

/dev/sda2 is the root partition. /home, which also is XFS formatted, is
fine. The journal gets automatically recovered in the boot process and
root mounts just fine. But this happens after every single reboot or
shutdown - on three different machines with two different kernels
(4.14.4 and 4.14.12) and three different harddisks. And it's always
and solely the root partition which is affected.

To me, it looks like the root partition doesn't get properly unmounted
on reboot or shutdown, but I can not find anything in the logs that is
suspicious. I have also looked into systemd sourcecode and the systemd shutdown
process, but can not see that the root partition is actually unmounted.

Do you have any advice what to do further, or any hint on what could be
happening here? Is this behaviour intended?

I have also filed a bug report here because there's F27 on all machines:
https://bugzilla.redhat.com/show_bug.cgi?id=1533620

Many thanks in advance,
 Heinz 
