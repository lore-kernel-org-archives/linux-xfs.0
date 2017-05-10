Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39103 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752992AbdEJRDy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 May 2017 13:03:54 -0400
Date: Wed, 10 May 2017 10:03:46 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 0.9/9] xfs: introduce the XFS_IOC_GETFSMAP ioctl
Message-ID: <20170510170346.GA5639@birch.djwong.org>
References: <149417257252.24656.2629280196308754994.stgit@birch.djwong.org>
 <20170508194755.GK5973@birch.djwong.org>
 <43c6b64f-cd5f-3cac-8270-7a292ed308dd@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43c6b64f-cd5f-3cac-8270-7a292ed308dd@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Wed, May 10, 2017 at 09:46:01AM -0500, Eric Sandeen wrote:
> On 5/8/17 2:47 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Introduce a new ioctl that uses the reverse mapping btree to return
> > information about the physical layout of the filesystem.
> 
> Thanks, I think it makes sense to pull in most of this via the normal
> libxfs-sync method, then fix up the build infra for userspace
> separately.  Sound ok?

Sure.  If you post a libxfs-sync-4.12 later I'll rebase on that and
send you the remaining pieces + review fixes.

--D

> 
> -Eric
>  
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  configure.ac          |    1 
> >  include/builddefs.in  |    7 +++
> >  include/linux.h       |  109 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  libxfs/xfs_fs.h       |   13 ++++++
> >  libxfs/xfs_rmap.c     |   28 +++++++++++++
> >  libxfs/xfs_rmap.h     |    2 +
> >  m4/package_libcdev.m4 |   19 +++++++++
> >  7 files changed, 178 insertions(+), 1 deletion(-)
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
