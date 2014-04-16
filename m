Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EEA237F60
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 01:31:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 72EDFAC001
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 23:31:32 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	PX8a1iBBSTT4mHiv for <xfs@oss.sgi.com>;
	Tue, 15 Apr 2014 23:31:30 -0700 (PDT)
Date: Wed, 16 Apr 2014 16:31:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/19] XFS: ensure xfs_file_*_read cannot deadlock in
	memory allocation.
Message-ID: <20140416063129.GI15995@dastard>
References: <20140416033623.10604.69237.stgit@notabene.brown>
	<20140416040336.10604.90380.stgit@notabene.brown>
	<20140416060459.GE15995@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140416060459.GE15995@dastard>
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
To: NeilBrown <neilb@suse.de>
Cc: linux-mm@kvack.org, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Wed, Apr 16, 2014 at 04:04:59PM +1000, Dave Chinner wrote:
> On Wed, Apr 16, 2014 at 02:03:36PM +1000, NeilBrown wrote:
> > xfs_file_*_read holds an inode lock while calling a generic 'read'
> > function.  These functions perform read-ahead and are quite likely to
> > allocate memory.
> 
> Yes, that's what reading data from disk requires.
> 
> > So set PF_FSTRANS to ensure they avoid __GFP_FS and so don't recurse
> > into a filesystem to free memory.
> 
> We already have that protection via the

Oops, stray paste. Ignore that comment.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
