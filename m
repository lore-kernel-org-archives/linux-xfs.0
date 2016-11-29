Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ishtar.tlinx.org ([173.164.175.65]:53006 "EHLO
        Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751726AbcK2Xvk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2016 18:51:40 -0500
Received: from [192.168.3.12] (Athenae [192.168.3.12])
        by Ishtar.sc.tlinx.org (8.14.7/8.14.4/SuSE Linux 0.8) with ESMTP id uATNpbn8015199
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2016 15:51:39 -0800
Message-ID: <583E1488.7090502@tlinx.org>
Date: Tue, 29 Nov 2016 15:51:36 -0800
From: "L.A. Walsh" <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Fwd: default mount options
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org


Is it possible for the 'mount' man page to be enhanced to show
what the defaults are?  Or if that's not possible,
maybe the xfs(5) manpage?

Also, I'm again "unclear" on barriers.

The xfs(5) man page says:

 "barrier|nobarrier - Enables/disables the use of block layer write
 barriers... this allows for drive level write caching to be enabled.
 Barriers are enabled by default.

This seems to say that barriers are enabled.  Does that mean
the the barriers are implemented in the HW of the disk, or that
SW adds "barriers" for disks that don't have them implemented in HW?

It also says drives may enable write-caching -- but this should
only be done if they support write barriers.  How is this "decided"?
I.e is it done "automatically" in HW? in SW? 
Or should the user "know"?

Is this related to whether or not the drives support "state" over
power interruptions?  By having non-volatile "write-cache" memory,
battery-backed cache, or backed by a UPS?  Wouldn't SSD's be
considers safe for this purpose (because their state is non-volatile?).

I seem to "get" this topic periodically, but after some time passes,
and upon rereading the associated manpages, I realize I'm not
real clear which way is what and realize the lack of defaults
being specified and whether or not SSD's and/or UPS-backed disks
were safe whether barriers were present or not was still vague.


Thanks!
-linda








