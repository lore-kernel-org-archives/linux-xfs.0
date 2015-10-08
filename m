Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6C2AF7F37
	for <xfs@oss.sgi.com>; Thu,  8 Oct 2015 16:38:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 092C8AC001
	for <xfs@oss.sgi.com>; Thu,  8 Oct 2015 14:38:18 -0700 (PDT)
Received: from mga11.intel.com ([192.55.52.93]) by cuda.sgi.com with ESMTP id
	9wwyrnX0zUKwBo6X for <xfs@oss.sgi.com>;
	Thu, 08 Oct 2015 14:38:17 -0700 (PDT)
Date: Thu, 8 Oct 2015 15:38:15 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH] xfs: pass total block res. as total xfs_bmapi_write()
	parameter
Message-ID: <20151008213815.GA1108@linux.intel.com>
References: <1444233538-52658-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1444233538-52658-1-git-send-email-bfoster@redhat.com>
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
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, xfs@oss.sgi.com

On Wed, Oct 07, 2015 at 11:58:58AM -0400, Brian Foster wrote:
> The total field from struct xfs_alloc_arg is a bit of an unknown
> commodity. It is documented as the total block requirement for the
> transaction and is used in this manner from most call sites by virtue of
> passing the total block reservation of the transaction associated with
> an allocation. Several xfs_bmapi_write() callers pass hardcoded values
> of 0 or 1 for the total block requirement, which is a historical oddity
> without any clear reasoning.
> 
> The xfs_iomap_write_direct() caller, for example, passes 0 for the total
> block requirement. This has been determined to cause problems in the
> form of ABBA deadlocks of AGF buffers due to incorrect AG selection in
> the block allocator. Specifically, the xfs_alloc_space_available()
> function incorrectly selects an AG that doesn't actually have sufficient
> space for the allocation. This occurs because the args.total field is 0
> and thus the remaining free space check on the AG doesn't actually
> consider the size of the allocation request. This locks the AGF buffer,
> the allocation attempt proceeds and ultimately fails (in
> xfs_alloc_fix_minleft()), and xfs_alloc_vexent() moves on to the next
> AG. In turn, this can lead to incorrect AG locking order (if the
> allocator wraps around, attempting to lock AG 0 after acquiring AG N)
> and thus deadlock if racing with another operation. This problem has
> been reproduced via generic/299 on smallish (1GB) ramdisk test devices.
> 
> To avoid this problem, replace the undocumented hardcoded total
> parameters from the iomap and utility callers to pass the block
> reservation used for the associated transaction. This is consistent with
> other xfs_bmapi_write() callers throughout XFS. The assumption is that
> the total field allows the selection of an AG that can handle the entire
> operation rather than simply the allocation/range being requested (e.g.,
> resulting btree splits, etc.). This addresses the aforementioned
> generic/299 hang by ensuring AG selection only occurs when the
> allocation can be satisfied by the AG.
> 
> Reported-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Verified that this solves the hang in my test setup.

Tested-by: Ross Zwisler <ross.zwisler@linux.intel.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
