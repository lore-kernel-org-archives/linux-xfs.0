Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32914 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751407AbdELXFT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 May 2017 19:05:19 -0400
Date: Fri, 12 May 2017 16:05:09 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 0.9/9] xfs: introduce the XFS_IOC_GETFSMAP ioctl
Message-ID: <20170512230509.GJ4519@birch.djwong.org>
References: <149417257252.24656.2629280196308754994.stgit@birch.djwong.org>
 <20170508194755.GK5973@birch.djwong.org>
 <041fd06c-a3bc-e743-91b6-8ed6a33c78a5@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <041fd06c-a3bc-e743-91b6-8ed6a33c78a5@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Fri, May 12, 2017 at 05:29:32PM -0500, Eric Sandeen wrote:
> On 5/8/17 2:47 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Introduce a new ioctl that uses the reverse mapping btree to return
> > information about the physical layout of the filesystem.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  configure.ac          |    1 
> >  include/builddefs.in  |    7 +++
> >  include/linux.h       |  109 +++++++++++++++++++++++++++++++++++++++++++++++++
> 
> So, I'm torn about whether we should be adding all the fsmap definitions
> into xfsprogs.  (I know... I did it for statx; I'm wondering if that was a
> bad precedent, and/or if it being a syscall makes it a different situation...).
> 
> I don't know when we ever deprecate or remove this stuff.
> 
> If you use packaged kernels, you'll get updated headers pretty quickly, right,
> or on a devel box you might install your own?
> 
> Not trying to be difficult, just trying to make sure we have a consistent
> plan for new interfaces like this...

I was under the impression that we employ this evil hackery so that
developers (at least) can build binaries for testing until the kernel
headers in their build environments catch up.

...unfortunately, that sort of implies that the sunset horizon is
quite a ways out since I've never seen this stuff get removed.

--D

> 
> Thanks,
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
