Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A3F907CFF
	for <xfs@oss.sgi.com>; Tue, 26 Apr 2016 18:07:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1E844AC006
	for <xfs@oss.sgi.com>; Tue, 26 Apr 2016 16:07:19 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	yTOxNG2awycjmdMO for <xfs@oss.sgi.com>;
	Tue, 26 Apr 2016 16:07:16 -0700 (PDT)
Date: Wed, 27 Apr 2016 09:07:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] mm: add PF_MEMALLOC_NOFS
Message-ID: <20160426230702.GG26977@dastard>
References: <1461671772-1269-1-git-send-email-mhocko@kernel.org>
	<1461671772-1269-2-git-send-email-mhocko@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1461671772-1269-2-git-send-email-mhocko@kernel.org>
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
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Chris Mason <clm@fb.com>, linux-ntfs-dev@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>, reiserfs-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, logfs@logfs.org, cluster-devel@redhat.com, linux-mm@kvack.org, Michal Hocko <mhocko@suse.com>, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com, ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-afs@lists.infradead.org

On Tue, Apr 26, 2016 at 01:56:11PM +0200, Michal Hocko wrote:
> From: Michal Hocko <mhocko@suse.com>
> 
> GFP_NOFS context is used for the following 4 reasons currently
> 	- to prevent from deadlocks when the lock held by the allocation
> 	  context would be needed during the memory reclaim
> 	- to prevent from stack overflows during the reclaim because
> 	  the allocation is performed from a deep context already
> 	- to prevent lockups when the allocation context depends on
> 	  other reclaimers to make a forward progress indirectly
> 	- just in case because this would be safe from the fs POV

- silencing lockdep false positives

> Introduce PF_MEMALLOC_NOFS task specific flag and memalloc_nofs_{save,restore}
> API to control the scope. This is basically copying
> memalloc_noio_{save,restore} API we have for other restricted allocation
> context GFP_NOIO.
> 
> Xfs has already had a similar functionality as PF_FSTRANS so let's just
> give it a more generic name and make it usable for others as well and
> move the GFP_NOFS context tracking to the page allocator. Xfs has its
> own accessor functions but let's keep them for now to reduce this patch
> as minimum.

Can you split this into two patches? The first simply does this:

#define PF_MEMALLOC_NOFS PF_FSTRANS

and changes only the XFS code to use PF_MEMALLOC_NOFS.

The second patch can then do the rest of the mm API changes that we
don't actually care about in XFS at all.  That way I can carry all
the XFS changes in the XFS tree and not have to worry about when
this stuff gets merged or conflicts with the rest of the work that
is being done to the mm/ code and whatever tree that eventually
lands in...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
