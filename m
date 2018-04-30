Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:35961 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752348AbeD3J1z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Apr 2018 05:27:55 -0400
Received: by mail-wr0-f195.google.com with SMTP id u18-v6so7370754wrg.3
        for <linux-xfs@vger.kernel.org>; Mon, 30 Apr 2018 02:27:54 -0700 (PDT)
Date: Mon, 30 Apr 2018 11:27:50 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: XFS quotas: Skipping quotacheck in the initial mount
Message-ID: <20180430092750.nrayrqztinehfi6l@odin.usersys.redhat.com>
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

Hi,

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

No, otherwise you would get an inconsistency in the quotas, let's say for
example, it runs in background, and an user with limited quotas starts to write
to the filesystem, how would you check if the user has already used its space
share if the filesystem didn't read yet its current used space?

The quotacheck though only runs for the first time (as long FS consistency is
kept at least), so you won't have this delay on mount time every time you mount
your filesystem.

So, you can simply umount/mount the filesystem before rebooting your system, so
the quotacheck can run with your system up.

About the time it will need, it's hard to do, it all depends of your disk(s)
speed, the layout of the files in your disk(s), etc. XFS will need to walk
through all inodes and check to which user it belongs to, size used, etc, so, it
really depends a lot on how fast XFS can read all inodes from your disk(s).

Cheers.

> Additional info:
> 
> This server is running 3.10.0-693.21.1.el7.x86_64 kernel (CentOS 7.4),
> and here the number of inodes:
> 
> Filesystem         Inodes    IUsed      IFree IUse% Mounted on
> /dev/sda       5625717696 39592403 5586125293    1% /export
> 
> Thanks in advance!
> Jorge
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
