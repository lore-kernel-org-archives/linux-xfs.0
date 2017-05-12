Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43476 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750952AbdELW3d (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 12 May 2017 18:29:33 -0400
Subject: Re: [PATCH 0.9/9] xfs: introduce the XFS_IOC_GETFSMAP ioctl
References: <149417257252.24656.2629280196308754994.stgit@birch.djwong.org>
 <20170508194755.GK5973@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <041fd06c-a3bc-e743-91b6-8ed6a33c78a5@sandeen.net>
Date: Fri, 12 May 2017 17:29:32 -0500
MIME-Version: 1.0
In-Reply-To: <20170508194755.GK5973@birch.djwong.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 5/8/17 2:47 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Introduce a new ioctl that uses the reverse mapping btree to return
> information about the physical layout of the filesystem.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  configure.ac          |    1 
>  include/builddefs.in  |    7 +++
>  include/linux.h       |  109 +++++++++++++++++++++++++++++++++++++++++++++++++

So, I'm torn about whether we should be adding all the fsmap definitions
into xfsprogs.  (I know... I did it for statx; I'm wondering if that was a
bad precedent, and/or if it being a syscall makes it a different situation...).

I don't know when we ever deprecate or remove this stuff.

If you use packaged kernels, you'll get updated headers pretty quickly, right,
or on a devel box you might install your own?

Not trying to be difficult, just trying to make sure we have a consistent
plan for new interfaces like this...

Thanks,
-Eric
