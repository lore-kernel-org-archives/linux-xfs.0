Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:36459 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751384AbeD3Wsw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Apr 2018 18:48:52 -0400
Date: Tue, 1 May 2018 08:48:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS quotas: Skipping quotacheck in the initial mount
Message-ID: <20180430224849.GG13766@dastard>
References: <CAN==6Xc9aNnEShwAtCfdtNeYHVFORFjJhzOss=x2KBSp0Qb2=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN==6Xc9aNnEShwAtCfdtNeYHVFORFjJhzOss=x2KBSp0Qb2=Q@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jorge Garcia <jorge.garcia101011@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Apr 26, 2018 at 04:58:00PM +0200, Jorge Garcia wrote:
> Hi all,
> 
> I tried to add XFS quotas in a fileserver with a capacity of 260TB
> (112TB occupied), but after adding the user and project quota options
> for this disk in the fstab file and remounting it, the mount rest
> hanged running the quota check process. I waited for 20 minutes, but
> this process did not finish. Due to this server can't be unavailable,
> I had to cancel the process and remove the quota options from fstab
> file.
> 
> My question is: Would it be possible to run the quota check process in
> the background? If not, how could I get the estimated time to finish
> this process?
> 
> Additional info:
> 
> This server is running 3.10.0-693.21.1.el7.x86_64 kernel (CentOS 7.4),
> and here the number of inodes:
> 
> Filesystem         Inodes    IUsed      IFree IUse% Mounted on
> /dev/sda       5625717696 39592403 5586125293    1% /export

FYI, you have 39.5 million allocated inodes. Given optimal inode
chunk distribution, that requires (39.5 / 32) million IOs to run
a quota scan. If you have spinning disks, then you are looking at
300 IOs/s here, and so somewhere around (1.25 x 10^6 / 3 x 10^2) =
~4200 seconds.

So I'd expect quota check to take somewhere between 1.5-2 hours to
complete on a filesystem like this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
