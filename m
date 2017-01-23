Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48736 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750714AbdAWNut (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Jan 2017 08:50:49 -0500
Date: Mon, 23 Jan 2017 08:50:48 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: XFS issues with NVMe SSD
Message-ID: <20170123135048.GB33287@bfoster.bfoster>
References: <8a562e13-6d86-d9ef-de22-f71d5aa79b60@jlbond.com>
 <dbcc14e5-73e7-4ba0-22d2-646d3e466927@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dbcc14e5-73e7-4ba0-22d2-646d3e466927@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Bond Masuda <bond.masuda@jlbond.com>, linux-xfs@vger.kernel.org

On Mon, Jan 23, 2017 at 07:41:58AM -0600, Eric Sandeen wrote:
> On 1/21/17 7:20 PM, Bond Masuda wrote:
> > Hi linux-xfs list:
> > 
> > I've been having XFS file system corruption issues when used with
> > Intel NVMe SSD in Fedora 25 Linux as reported here:
> > 
> > https://bugzilla.redhat.com/show_bug.cgi?id=1402533
> > 
> > I don't know if this is XFS issue or not, but ext4 on the same Intel
> > NVMe SSD doesn't appear to be a problem. Are linux/xfs devs already
> > aware of the problem?
> > 
> > Bond 
> 
> Well, the bug languished under anaconda, so no, we haven't seen it.
> 
> It's pretty light on details.  Please provide the install logs, dmesg output,
> xfs_repair output etc.  I'll update the bug.
> 

Since this is limited hardware (I don't have access to such hardware, at
least), it might also be helpful to see if you can isolate the problem
from a full distro install. For example, can you format such a device
external to the rootfs, mount, copy some stuff and reproduce the
corruption after some sequence of unmount/remount/reboot operations?

>From the bug, it does seem like a reboot is a consistent factor to
reproduce the corruption. I wonder whether it's enough to have the
device mounted at reboot time, or if being a rootfs device is a primary
factor...

Brian

> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
