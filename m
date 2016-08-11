Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A5CB47CA1
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2016 18:43:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 28777AC002
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2016 16:43:39 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	cZjw34HYUM2wjCMq for <xfs@oss.sgi.com>;
	Thu, 11 Aug 2016 16:43:37 -0700 (PDT)
Date: Fri, 12 Aug 2016 09:43:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH, RFC] xfs: remove i_iolock and use i_rwsem in the VFS
	inode instead
Message-ID: <20160811234335.GX16044@dastard>
References: <1470935423-12329-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1470935423-12329-1-git-send-email-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: peterz@infradead.org, xfs@oss.sgi.com

On Thu, Aug 11, 2016 at 10:10:23AM -0700, Christoph Hellwig wrote:
> This patch drops the XFS-own i_iolock and uses the VFS i_rwsem which
> recently replaced i_mutex instead.  This means we only have to take
> one looks instead of two in many fast path operations, and we can
> also shrink the xfs_inode structure.  Thanks to the xfs_ilock family
> there is very little churn as well.
> 
> There is one major issue with this change though:  lockdep currently
> doesn't have a facility to assert a rw_sempahore is held exclusively,
> which means we lose the nice ability to assert locking context in
> XFS.
> 
> Peter, I think you mentioned this would be fairly easy to add to
> lockdep and the rw_semaphore code.  Any chance to come up with a proof
> of concept?

I saw prototype patches with a writer field in the rswem to track
who holds it for optimisitic spinning support. I was waiting for
that to land before completely removing the mrlock abstraction
from the XFS code, then changing the iolock to use the VFS inode.

Regardless, if the rwsem code can be made to check for exclusive or
shared locking, we can get rid of the mrlock abstraction. Can we do
that first, Christoph, then make this lock change?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
