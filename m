Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:61238 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731172AbfCaWtV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 31 Mar 2019 18:49:21 -0400
Date: Mon, 1 Apr 2019 09:49:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: File system corruption in two hard disks
Message-ID: <20190331224918.GO23020@dastard>
References: <20181211183203.7fdbca0f@lud1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181211183203.7fdbca0f@lud1.home>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Luciano ES <lucmove@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Sun, Mar 31, 2019 at 04:41:47PM -0300, Luciano ES wrote:
> I have two hard disks that have been kept in storage for a little
> more than one year. I can read neither of them.
> 
> DISK 1: I tried to open it with cryptsetup. It wasn't recognized 
> as a LUKS partition, which is weird because I always use LUKS.
> 
> But it pops up as a mountable file system on the pcmanfm file manager.
> Clicking it to mount it as is gives me this error message:
> 
> Error mounting /dev/sdc1 at /media/ext/sm640: Command-line 
> `mount -t "xfs" -o "uhelper=udisks2,nodev,nosuid" "/dev/sdc1" "/media/ext/sm640"' 
> exited with non-zero exit status 32: mount: 
> mount /dev/sdc1 on /media/ext/sm640 failed: Structure needs cleaning

And the errors that XFS emitted in dmesg are... ?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
