Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:49624 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726475AbfEOUvI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 May 2019 16:51:08 -0400
Subject: Re: xfsdump confused by ino's < root ino
References: <20190515204732.GA4466@vader>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <f37ae69d-39a6-b2d0-1cc9-806d1d597086@sandeen.net>
Date: Wed, 15 May 2019 15:51:07 -0500
MIME-Version: 1.0
In-Reply-To: <20190515204732.GA4466@vader>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Omar Sandoval <osandov@osandov.com>, linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>

On 5/15/19 3:47 PM, Omar Sandoval wrote:
> Hi,
> 
> We use xfsdump and xfsrestore (v3.1.7) to back up one of our storage
> systems, and we ran into an issue where xfsdump prints the following for
> a mount which isn't a bind mount:
> 
> /sbin/xfsdump: NOTE: root ino 136 differs from mount dir ino 256, bind mount?
> 
> Which also results in a crash from xfsrestore:
> 
> xfsrestore: tree.c:757: tree_begindir: Assertion `ino != persp->p_rootino || hardh == persp->p_rooth' failed.
> 
> Looking at [1], xfsdump uses bulkstat to get the minimum inode number on
> the filesystem. But, at least one of our filesystems has a root inode
> number of 256 and uses inode numbers 136-199, which tricks xfsdump into
> thinking that the filesystem is bind mounted. Is this an invalid
> assumption in xfsdump, or is it filesystem corruption?
> 
> Thanks!
> 
> 1: https://git.kernel.org/pub/scm/fs/xfs/xfsdump-dev.git/commit/?id=25195ebf107dc81b1b7cea1476764950e1d6cc9d

Yep, this is that heuristic going wrong.  We (I) didn't realize that we could ever
get inode numbers allocated which were less than the root inode, but alas.

It's an invalid assumption in xfsdump.  I guess we need to find a way
out of this ... the goal was to detect bind mounts, but apparently
the situation you have is more common than expected (well, we expected
it to not exist ...)

For now just using an older version of xfsdump should be a workaround,
sorry about that.

-Eric
