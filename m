Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46216 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754333AbdAEOCn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 5 Jan 2017 09:02:43 -0500
Date: Thu, 5 Jan 2017 09:02:35 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: xfs/181 trigger xfs corruption on ppc64le
Message-ID: <20170105140235.GA3345@bfoster.bfoster>
References: <20160921030841.GQ12847@dhcp12-143.nay.redhat.com>
 <20170105040115.GB1946@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170105040115.GB1946@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org

On Thu, Jan 05, 2017 at 12:03:13PM +0800, Eryu Guan wrote:
> On Wed, Sep 21, 2016 at 11:08:41AM +0800, Zorro Lang wrote:
> > Hi,
> > 
> > There's a XFS (v4/v5) corruption from xfs/181. If run xfs/181 on ppc64le
> > 10~100 times (more or less) with 1k or 4k block size, it'll trigger a
> > corruption:
> > *** xfs_repair -n output ***
> > Phase 1 - find and verify superblock...
> > Phase 2 - using internal log
> >         - zero log...
> >         - scan filesystem freespace and inode maps...
> >         - found root inode chunk
> > Phase 3 - for each AG...
> >         - scan (but don't clear) agi unlinked lists...
> >         - process known inodes and perform inode discovery...
> >         - agno = 0
> > attribute entry #0 in attr block 0, inode 25194 is INCOMPLETE
> > problem with attribute contents in inode 25194
> > would clear attr fork
> > bad nblocks 33 for inode 25194, would reset to 0
> > bad anextents 1 for inode 25194, would reset to 0
> >         - agno = 1
> >         - agno = 2
> >         - agno = 3
> >         - process newly discovered inodes...
> > Phase 4 - check for duplicate blocks...
> >         - setting up duplicate extent list...
> >         - check for inodes claiming duplicate blocks...
> >         - agno = 0
> >         - agno = 1
> >         - agno = 2
> >         - agno = 3
> > No modify flag set, skipping phase 5
> > Phase 6 - check inode connectivity...
> >         - traversing filesystem ...
> >         - traversal finished ...
> >         - moving disconnected inodes to lost+found ...
> > Phase 7 - verify link counts...
> > No modify flag set, skipping filesystem flush and exiting.
> > *** end xfs_repair output
> 
> I hit this corruption again today with 4.10-rc2 kernel & latest master
> branch of xfsprogs, still ppc64le host.
> 
> *** xfs_repair -n output ***
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - zero log...
>         - scan filesystem freespace and inode maps...
>         - found root inode chunk
> Phase 3 - for each AG...
>         - scan (but don't clear) agi unlinked lists...
>         - process known inodes and perform inode discovery...
>         - agno = 0
> attribute entry #0 in attr block 0, inode 10236 is INCOMPLETE
> problem with attribute contents in inode 10236
> would clear attr fork
> bad nblocks 10 for inode 10236, would reset to 0
> bad anextents 1 for inode 10236, would reset to 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
>         - process newly discovered inodes...
> Phase 4 - check for duplicate blocks...
>         - setting up duplicate extent list...
>         - check for inodes claiming duplicate blocks...
>         - agno = 0
>         - agno = 2
>         - agno = 3
>         - agno = 1
> No modify flag set, skipping phase 5
> Phase 6 - check inode connectivity...
>         - traversing filesystem ...
>         - traversal finished ...
>         - moving disconnected inodes to lost+found ...
> Phase 7 - verify link counts...
> No modify flag set, skipping filesystem flush and exiting.
> *** end xfs_repair output
> 

Isn't this the same as rhbz 1377163 (not sure why that bug appears to be
locked)? E.g., this is basically due to the fact that remote attribute
block allocation occurs in a separate transaction. The existence of the
incomplete flag means that by design, logging doesn't guarantee
consistency for such attributes.

Brian

> I attached compressed xfs-181.full file, in case someone has interest to
> look into it.
> 
> Thanks,
> Eryu


