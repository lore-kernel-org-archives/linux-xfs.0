Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:55427 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750936AbeANIl2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 14 Jan 2018 03:41:28 -0500
Date: Sun, 14 Jan 2018 09:41:24 +0100
From: Heinz Diehl <htd+ml@fritha.org>
Subject: Re: XFS journal corruption after every reboot/shutdown
Message-ID: <20180114084124.GA1879@fritha.org>
References: <20180111224451.GA3413@fritha.org>
 <20180111231358.GW16421@dastard>
 <20180113081725.GA27564@fritha.org>
 <CAJCQCtS=qEmRtcqO+U-Ut_V5jFdyEjehiy+Vafxdt-PMvv-Z9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJCQCtS=qEmRtcqO+U-Ut_V5jFdyEjehiy+Vafxdt-PMvv-Z9g@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Murphy <lists@colorremedies.com>
Cc: xfs list <linux-xfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>

On 13.01.2018, Chris Murphy wrote: 

> You could try to mask the use of plymouth in systemd (or uninstall
> it). If the problem goes away, that's the culprit.

I removed plymouth a long time ago, because to me it's useless.

> If it doesn't you can probably track down what's holding up the remount ro with
> https://freedesktop.org/wiki/Software/systemd/Debugging/#index2h1
> And following the "eventually shuts down" section.

And that solved the problem! Not the debugging itself, but the debug script
that is mentioned in the text you directed me to. After placing the
debug script in /usr/lib/systemd/systemd-shutdown, the root fs is
clean after reboot/shutdown:

[htd@chiara ~]$ dmesg | grep XFS
[    2.085668] SGI XFS with ACLs, security attributes, no debug enabled
[    2.086856] XFS (nvme0n1p3): Mounting V5 Filesystem
[    2.093919] XFS (nvme0n1p3): Ending clean mount

Here's the debug script:

#!/bin/sh
mount -o remount,rw /
dmesg > /shutdown-log.txt
mount -o remount,ro /

It simply remounts the root fs rw, dumps the output of dmesg to disk,
and remounts the root fs ro afterwards. I tried to find out exactly
where and when in the shutdown process this script is executed, but
have to admit that my understanding of systemd is not deep enough.

I think something in how systemd performs a reboot/shutdown is
wrong. Will add this information to my bug report and hope this rings
a bell for the systemd developers. 

Thanks a lot,
Heinz




