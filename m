Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:7222 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S965031AbeFNXgD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Jun 2018 19:36:03 -0400
Date: Fri, 15 Jun 2018 09:35:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_repair: Fix root inode's parent when it's bogus for
 sf directory
Message-ID: <20180614233551.GN10363@dastard>
References: <20180614221646.20017-1-mbenatto@redhat.com>
 <1ddae533-b040-fdba-4350-01b59d5ddcba@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ddae533-b040-fdba-4350-01b59d5ddcba@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Marco Benatto <mbenatto@redhat.com>, linux-xfs@vger.kernel.org, sandeen@redhat.com

On Thu, Jun 14, 2018 at 05:20:56PM -0500, Eric Sandeen wrote:
> On 6/14/18 5:16 PM, Marco Benatto wrote:
> > Currently when root inode is in short-form and its parent ino
> > has an invalid value, process_sf_dir2() ends up not fixing it,
> > because if verify_inum() fails we never get to the next case which
> > would fix the root inode's parent pointer.
> > 
> > This behavior triggers the following assert on process_dir2():
> > 
> >    ASSERT((ino != mp->m_sb.sb_rootino && ino != *parent) ||
> >         (ino == mp->m_sb.sb_rootino &&
> >         (ino == *parent || need_root_dotdot == 1)));
> > 
> > This patch fixes this behavior by making sure we always properly
> > handle rootino parent pointer in process_sf_dir2()
> > 
> > Signed-off-by: Marco Benatto <mbenatto@redhat.com>
> 
> This looks correct to me, thanks.
> 
> FWIW the problem can be demonstrated by setting the root inode's
> parent to 0 on a freshly made fs:
> 
> # mkfs.xfs -f -dfile,name=fsfile,size=1g
> # xfs_db -x -c "sb 0" -c "addr rootino" -c "write u3.sfdir3.hdr.parent.i4 0" fsfile
> # xfs_repair fsfile

xfstest please (also to check that xfs_scrub detects it)?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
