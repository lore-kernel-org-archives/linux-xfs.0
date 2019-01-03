Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:54716 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725931AbfACXWT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Jan 2019 18:22:19 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 0B75425F3E
        for <linux-xfs@vger.kernel.org>; Thu,  3 Jan 2019 23:22:18 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202127] cannot mount or create xfs on a  597T device
Date: Thu, 03 Jan 2019 23:22:17 +0000
Message-ID: <bug-202127-201763-KTKmdFdh1n@https.bugzilla.kernel.org/>
In-Reply-To: <bug-202127-201763@https.bugzilla.kernel.org/>
References: <bug-202127-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=202127

--- Comment #11 from Dave Chinner (david@fromorbit.com) ---
On Thu, Jan 03, 2019 at 10:58:41PM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=202127
> 
> --- Comment #5 from daimh@umich.edu ---
> /dev/sda is a hardware raid. lspci -vvv output is below. By the way, /dev/sda
> has been working great with kernel 4.17.5-1-ARCH and mkfs.xfs version 4.17.0.
> I
> can create, mount and copy 200+ T data without any glitches. Further, If I
> downgrade linux kernel and xfsprogs, /dev/sda can work.

Sure, that's because newer kernels and tools are much more stringent
about validity checking the on-disk information. And, in this case,
newer tools have found a validity problem that the older tools and
kernel didn't.

You can use xfs_db to fix the broken alignment in the superblock,
but I'd like to get to the bottom of where the problem is coming
from first.

> 02:00.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID SAS-3 3316
> [Intruder] (rev 01)

Ok, so it's an lsi/broadcom 3316 hardware RAID controller. Which
means this is most likely a firmware bug. Can you update the raid
controller to the latest firmware and see if the block dvice still
reports the same iomin/ioopt parameters?

If so, you need to talk to your vendor about getting their hardware
bug fixed and ensure their QA deficiencies are addressed, then use
xfs_db to rewrite the stripe unit/stripe width to valid values so
you can continue to use the filesystem on modern kernels.

Cheers,

Dave.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
