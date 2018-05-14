Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:60690 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752011AbeENUtt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 May 2018 16:49:49 -0400
Date: Mon, 14 May 2018 12:11:14 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: xfsprogs 4.16.0 format change, GRUB error unknown filesystem
Message-ID: <20180514191114.GB4937@magnolia>
References: <CAJCQCtQbns7bbE=mWvYuWMi+R5wdphfEjF1F995PVBsoUovnpg@mail.gmail.com>
 <20180514173610.GC4933@magnolia>
 <CAJCQCtQ04viW=GzfTBWdQPab8orRmzQ2MjHGCSy_VY_k7-PdRw@mail.gmail.com>
 <d6405778-f3cb-57c8-33d6-6ea66fe06b44@sandeen.net>
 <CAJCQCtSSEmwAzED6uzkevV_o4cxwhcZ9sf398wG-7HNCg3dOsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJCQCtSSEmwAzED6uzkevV_o4cxwhcZ9sf398wG-7HNCg3dOsA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Murphy <lists@colorremedies.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs list <linux-xfs@vger.kernel.org>

On Mon, May 14, 2018 at 01:08:45PM -0600, Chris Murphy wrote:
> On Mon, May 14, 2018 at 12:34 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> >
> >
> > On 5/14/18 12:52 PM, Chris Murphy wrote:
> >> On Mon, May 14, 2018 at 11:36 AM, Darrick J. Wong
> >> <darrick.wong@oracle.com> wrote:
> >>> On Mon, May 14, 2018 at 11:15:27AM -0600, Chris Murphy wrote:
> >>>> Downstream bug, Fedora Rawhide being a canary in the coal mine!
> >>>> https://bugzilla.redhat.com/show_bug.cgi?id=1575797
> >>>>
> >>>> Comment 8 about the kernel warning related to freeze/thaw is curious
> >>>> but ends up being unrelated to this problem.
> >>>>
> >>>> The gist is that xfsprogs 4.16.0 formatted volumes aren't recognized
> >>>> by either GRUB user space tools, or the GRUB core.img (whether of the
> >>>> embedded BIOS variety or the grubx64.efi variety)
> >>>>
> >>>> Anyway, open question for XFS devs if this should be fixed in xfsprogs
> >>>> or GRUB. I haven't tested this with syslinux to know if it has a
> >>>> similar problem.
> >>>
> >>> mkfs.xfs 4.16 enables sparse inodes by default, which is why grub
> >>> doesn't recognise the boot fs.  grub needs fixing, or $installer needs
> >>> to disable sparse inodes, I think.
> >>
> >> Is there a reason why this was made default before GRUB was fixed? Or
> >> would XFS devs prefer to not support /boot on XFS?
> >
> > Coordination would have been good, but nobody thought about this issue.
> > It was a mistake, not a preference.
> >
> 
> Can someone point to documentation for the change to include in a
> report for GRUB devs?
> 
> I found this:
> https://www.spinics.net/lists/xfs/msg36686.html
> 
> But all the documentation here seems stale:
> http://xfs.org/index.php/XFS_Papers_and_Documentation
> http://xfs.org/docs/xfsdocs-xml-dev/XFS_Filesystem_Structure/tmp/en-US/html/index.html

https://mirrors.edge.kernel.org/pub/linux/utils/fs/xfs/docs/xfs_filesystem_structure.pdf

We're working on moving all that to Documentation/, time permitting.

--D
> 
> 
> 
> -- 
> Chris Murphy
