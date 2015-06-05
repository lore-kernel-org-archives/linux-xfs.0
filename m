Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D09847FB3
	for <xfs@oss.sgi.com>; Thu,  4 Jun 2015 19:56:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BE3B1304048
	for <xfs@oss.sgi.com>; Thu,  4 Jun 2015 17:56:50 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	dWzeBqtPI9h12a0k for <xfs@oss.sgi.com>;
	Thu, 04 Jun 2015 17:56:48 -0700 (PDT)
Date: Fri, 5 Jun 2015 10:56:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 18/28] repair: scan and track sparse inode chunks correctly
Message-ID: <20150605005646.GM9143@dastard>
References: <1433270521-62026-1-git-send-email-bfoster@redhat.com>
	<1433270521-62026-19-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1433270521-62026-19-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Jun 02, 2015 at 02:41:51PM -0400, Brian Foster wrote:
> Phase 2 of xfs_repair scans the on-disk inobt and creates in-core
> records for all inodes in the fs. This also involves marking
> free/allocated state of all inodes, internal record verification and
> block state management for the inode chunks tracked by inode records.
> Various parts of the inobt scan mechanism assume fully allocated inode
> records and thus lead to spurious errors when sparse inode records are
> encountered.
> 
> Update the inobt scan to detect and handle sparse inode records
> correctly. Do not set the allocation state of blocks in sparse inode
> regions as these blocks do not belong to the record. Do not account
> sparse inodes against the ir_freecount as these inodes do not exist and
> are not available for allocation by the fs. Finally, track the sparse
> status of each individual inode in the in-core inode records for future
> reference.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  include/libxfs.h    | 16 ++++++++++++++++
>  repair/incore.h     | 14 ++++++++++++++
>  repair/incore_ino.c |  1 +
>  repair/scan.c       | 48 +++++++++++++++++++++++++++++++++++++++++-------
>  4 files changed, 72 insertions(+), 7 deletions(-)
> 
> diff --git a/include/libxfs.h b/include/libxfs.h
> index 6a59cc0..3321c50 100644
> --- a/include/libxfs.h
> +++ b/include/libxfs.h
> @@ -183,6 +183,22 @@ extern unsigned long	libxfs_physmem(void);	/* in kilobytes */
>  #define XFS_INOBT_IS_FREE_DISK(rp,i)		\
>  			((be64_to_cpu((rp)->ir_free) & XFS_INOBT_MASK(i)) != 0)
>  
> +static inline bool
> +XFS_INOBT_IS_SPARSE_DISK(

Shouty! ;)

I changed this lower case, otherwise ok.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
