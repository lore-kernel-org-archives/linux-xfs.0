Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:36486 "EHLO
        mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750821AbdHQFep (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Aug 2017 01:34:45 -0400
Received: by mail-qk0-f178.google.com with SMTP id o124so22905312qke.3
        for <linux-xfs@vger.kernel.org>; Wed, 16 Aug 2017 22:34:45 -0700 (PDT)
Date: Thu, 17 Aug 2017 02:34:40 -0300
From: Ernesto =?utf-8?Q?A=2E_Fern=C3=A1ndez?=
        <ernesto.mnd.fernandez@gmail.com>
Subject: Re: [PATCH] xfs: preserve i_mode if __xfs_set_acl() fails
Message-ID: <20170817053436.GA2382@debian.home>
References: <20170814081806.GA3924@debian.home>
 <20170815020018.GF21024@dastard>
 <20170815061857.GA2803@debian.home>
 <20170815084430.GK21024@dastard>
 <20170815192938.GA1247@debian.home>
 <20170816002511.GM21024@dastard>
 <20170816071649.GA4143@debian.home>
 <20170816133502.GN21024@dastard>
 <20170816193100.GA1216@debian.home>
 <20170817000042.GO21024@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170817000042.GO21024@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Zorro Lang <zlang@redhat.com>, Ernesto =?utf-8?Q?A=2E_Fern=C3=A1ndez?= <ernesto.mnd.fernandez@gmail.com>

On Thu, Aug 17, 2017 at 10:00:42AM +1000, Dave Chinner wrote:
> On Wed, Aug 16, 2017 at 04:31:01PM -0300, Ernesto A. Fernández wrote:
> > xfs_repair, phase 3:
> > bad magic number febe in block 512 (14452) for directory inode 131
> 
> Hmmmm - that's a magic number for a non-crc DA node. Kinda implies
> that it ENOSPC'd in the middle of a tree split.
> 
> Can you test on a CRC enabled filesystem and see if there are any
> other errors that are detected either at runtime or by repair?

No other errors, no.

> If it does fail, can youpost the full output of xfs_repair?

Of course. I don't think it will be of much help though:


Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
bad magic number 3ebe in block 506 (14446) for directory inode 67
problem with attribute contents in inode 67
would clear attr fork
bad nblocks 11894 for inode 67, would reset to 11268
bad anextents 1 for inode 67, would reset to 0
        - agno = 1
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
No modify flag set, skipping filesystem flush and exiting.


> > It seems to be caused by setting too many extended attributes to a
> > file.
> 
> Yeah, > 500 blocks in the attribute tree implies at least several
> megabytes of xattrs on a file, which is something that pretty much
> never happens on production workloads. It's not likely to be a
> frequently exercised path...
>
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

Perhaps this can be of some use:

In my test I'm setting as many xattrs with 1k values as possible. If I
change that to 64k values this bug is no longer seen.

The cutoff seems to be when the name+value of the xattr are above 3072+1
bytes. This does not depend on the amount of free space of the
filesystem, so this is probably not just about the number of xattrs as I
first thought.

If I change the block size to 2048 the cutoff is now 1537 bytes, that
is, still 3/4 the block size plus one. For bsize=1024, the cutoff is
when the value alone is longer than 756 bytes.

Also you don't actually need to max out the number of xattrs to see
this bug. For example: if the block size is 1024, the value size is 757
and the name size is 18 bytes, you can trigger this bug by setting 2010
xattrs.

Let me know if you need more info.

Ernest
