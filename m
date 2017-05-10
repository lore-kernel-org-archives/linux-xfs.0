Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48202 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751267AbdEJOqD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 May 2017 10:46:03 -0400
Subject: Re: [PATCH 0.9/9] xfs: introduce the XFS_IOC_GETFSMAP ioctl
References: <149417257252.24656.2629280196308754994.stgit@birch.djwong.org>
 <20170508194755.GK5973@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <43c6b64f-cd5f-3cac-8270-7a292ed308dd@sandeen.net>
Date: Wed, 10 May 2017 09:46:01 -0500
MIME-Version: 1.0
In-Reply-To: <20170508194755.GK5973@birch.djwong.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
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

Thanks, I think it makes sense to pull in most of this via the normal
libxfs-sync method, then fix up the build infra for userspace
separately.  Sound ok?

-Eric
 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  configure.ac          |    1 
>  include/builddefs.in  |    7 +++
>  include/linux.h       |  109 +++++++++++++++++++++++++++++++++++++++++++++++++
>  libxfs/xfs_fs.h       |   13 ++++++
>  libxfs/xfs_rmap.c     |   28 +++++++++++++
>  libxfs/xfs_rmap.h     |    2 +
>  m4/package_libcdev.m4 |   19 +++++++++
>  7 files changed, 178 insertions(+), 1 deletion(-)
> 
