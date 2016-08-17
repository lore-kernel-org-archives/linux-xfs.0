Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6E50B7CA0
	for <xfs@oss.sgi.com>; Tue, 16 Aug 2016 19:34:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CFB80AC01B
	for <xfs@oss.sgi.com>; Tue, 16 Aug 2016 17:34:02 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id YhqDWHL1GglVIXpM (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 16 Aug 2016 17:34:00 -0700 (PDT)
Date: Tue, 16 Aug 2016 17:33:50 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [ANNOUNCE] xfs: master branch updated to v4.8-rc2, for-next
	branch updated to d25ed4d
Message-ID: <20160817003350.GA8268@birch.djwong.org>
References: <20160816233659.GE19025@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160816233659.GE19025@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Wed, Aug 17, 2016 at 09:36:59AM +1000, Dave Chinner wrote:
> Hi folks,
> 
> I've just updated the master branch of hte XFS kernel repository to
> v4.8-rc2. If you have outstanding patches, can you check they apply
> to this updated branch, and if not rebase your patches and resend
> them?

I think this is missing "xfs: remove OWN_AG rmap when allocating a block from
the AGFL", a.k.a. the fix for the generic/299 crash you were seeing.

--D

> 
> I've also updated with the for-next branch with the fixes I intend
> to send to Linus at the end of the week. This does not include
> Christoph's delayed allocation rework - that still needs more testing
> before merging. Full details of the commits merged are below.
> 
> -Dave.
> 
> The for-next branch of the xfs kernel repository at
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git
> 
> has just been updated.
> 
> The new head of the for-next branch is commit:
> 
> d25ed4d Merge branch 'iomap-fixes-4.8-rc3' into for-next
> 
> New Commits:
> 
> Brian Foster (1):
>       [4dd3fd7] xfs: don't assert fail on non-async buffers on ioacct decrement
> 
> Christoph Hellwig (6):
>       [0af32fb] xfs: fix bogus space reservation in xfs_iomap_write_allocate
>       [97dd8c9] iomap: remove superflous mark_page_accessed from iomap_write_actor
>       [274c887] iomap: remove superflous pagefault_disable from iomap_write_actor
>       [f20ac7a] iomap: mark ->iomap_end as optional
>       [b95a212] xfs: simplify xfs_file_iomap_begin
>       [1d4795e] xfs: (re-)implement FIEMAP_FLAG_XATTR
> 
> Darrick J. Wong (1):
>       [f32866fd] xfs: store rmapbt block count in the AGF
> 
> Dave Chinner (4):
>       [8b2180b] xfs: don't invalidate whole file on DAX read/write
>       [8896b8f] iomap: fiemap should honor the FIEMAP_FLAG_SYNC flag
>       [ac2dc05] iomap: prepare iomap_fiemap for attribute mappings
>       [d25ed4d] Merge branch 'iomap-fixes-4.8-rc3' into for-next
> 
> 
> Code Diffstat:
> 
>  fs/iomap.c                     | 21 ++++++++------
>  fs/xfs/libxfs/xfs_alloc.c      |  1 +
>  fs/xfs/libxfs/xfs_format.h     | 11 ++++++--
>  fs/xfs/libxfs/xfs_rmap_btree.c |  6 ++++
>  fs/xfs/xfs_buf.c               |  1 -
>  fs/xfs/xfs_file.c              | 13 ++++++++-
>  fs/xfs/xfs_fsops.c             |  1 +
>  fs/xfs/xfs_iomap.c             | 69 ++++++++++++++++++++++++++++++++++++---------
>  fs/xfs/xfs_iomap.h             |  1 +
>  fs/xfs/xfs_iops.c              |  9 +++++-
>  fs/xfs/xfs_trace.h             |  1 -
>  11 files changed, 106 insertions(+), 28 deletions(-)
> -- 
> Dave Chinner
> david@fromorbit.com



> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
