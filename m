Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f170.google.com ([209.85.215.170]:38474 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727416AbfEOUxR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 May 2019 16:53:17 -0400
Received: by mail-pg1-f170.google.com with SMTP id j26so380398pgl.5
        for <linux-xfs@vger.kernel.org>; Wed, 15 May 2019 13:53:17 -0700 (PDT)
Date: Wed, 15 May 2019 13:53:14 -0700
From: Omar Sandoval <osandov@osandov.com>
Subject: Re: xfsdump confused by ino's < root ino
Message-ID: <20190515205314.GA4599@vader>
References: <20190515204732.GA4466@vader>
 <f37ae69d-39a6-b2d0-1cc9-806d1d597086@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f37ae69d-39a6-b2d0-1cc9-806d1d597086@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>

On Wed, May 15, 2019 at 03:51:07PM -0500, Eric Sandeen wrote:
> On 5/15/19 3:47 PM, Omar Sandoval wrote:
> > Hi,
> > 
> > We use xfsdump and xfsrestore (v3.1.7) to back up one of our storage
> > systems, and we ran into an issue where xfsdump prints the following for
> > a mount which isn't a bind mount:
> > 
> > /sbin/xfsdump: NOTE: root ino 136 differs from mount dir ino 256, bind mount?
> > 
> > Which also results in a crash from xfsrestore:
> > 
> > xfsrestore: tree.c:757: tree_begindir: Assertion `ino != persp->p_rootino || hardh == persp->p_rooth' failed.
> > 
> > Looking at [1], xfsdump uses bulkstat to get the minimum inode number on
> > the filesystem. But, at least one of our filesystems has a root inode
> > number of 256 and uses inode numbers 136-199, which tricks xfsdump into
> > thinking that the filesystem is bind mounted. Is this an invalid
> > assumption in xfsdump, or is it filesystem corruption?
> > 
> > Thanks!
> > 
> > 1: https://git.kernel.org/pub/scm/fs/xfs/xfsdump-dev.git/commit/?id=25195ebf107dc81b1b7cea1476764950e1d6cc9d
> 
> Yep, this is that heuristic going wrong.  We (I) didn't realize that we could ever
> get inode numbers allocated which were less than the root inode, but alas.
> 
> It's an invalid assumption in xfsdump.  I guess we need to find a way
> out of this ... the goal was to detect bind mounts, but apparently
> the situation you have is more common than expected (well, we expected
> it to not exist ...)
> 
> For now just using an older version of xfsdump should be a workaround,
> sorry about that.
> 
> -Eric

Great, thanks for the confirmation!
