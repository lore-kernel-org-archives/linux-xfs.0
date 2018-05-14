Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:57934 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752347AbeENRgO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 May 2018 13:36:14 -0400
Date: Mon, 14 May 2018 10:36:10 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: xfsprogs 4.16.0 format change, GRUB error unknown filesystem
Message-ID: <20180514173610.GC4933@magnolia>
References: <CAJCQCtQbns7bbE=mWvYuWMi+R5wdphfEjF1F995PVBsoUovnpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJCQCtQbns7bbE=mWvYuWMi+R5wdphfEjF1F995PVBsoUovnpg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Murphy <lists@colorremedies.com>
Cc: xfs list <linux-xfs@vger.kernel.org>

On Mon, May 14, 2018 at 11:15:27AM -0600, Chris Murphy wrote:
> Downstream bug, Fedora Rawhide being a canary in the coal mine!
> https://bugzilla.redhat.com/show_bug.cgi?id=1575797
> 
> Comment 8 about the kernel warning related to freeze/thaw is curious
> but ends up being unrelated to this problem.
> 
> The gist is that xfsprogs 4.16.0 formatted volumes aren't recognized
> by either GRUB user space tools, or the GRUB core.img (whether of the
> embedded BIOS variety or the grubx64.efi variety)
> 
> Anyway, open question for XFS devs if this should be fixed in xfsprogs
> or GRUB. I haven't tested this with syslinux to know if it has a
> similar problem.

mkfs.xfs 4.16 enables sparse inodes by default, which is why grub
doesn't recognise the boot fs.  grub needs fixing, or $installer needs
to disable sparse inodes, I think.

--D

> 
> -- 
> Chris Murphy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
