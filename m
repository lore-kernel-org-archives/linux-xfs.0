Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B13037CB6
	for <xfs@oss.sgi.com>; Wed, 23 Mar 2016 18:46:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 911FE304051
	for <xfs@oss.sgi.com>; Wed, 23 Mar 2016 16:46:31 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	wqMiBFrOUCkDAQd4 for <xfs@oss.sgi.com>;
	Wed, 23 Mar 2016 16:46:28 -0700 (PDT)
Date: Thu, 24 Mar 2016 10:45:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] xfs: set up inode operation vectors later
Message-ID: <20160323234554.GA30721@dastard>
References: <1458740935-31260-1-git-send-email-hch@lst.de>
	<1458740935-31260-3-git-send-email-hch@lst.de>
	<20160323230500.GZ30721@dastard> <20160323232630.GA5646@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160323232630.GA5646@lst.de>
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
Cc: xfs@oss.sgi.com

On Thu, Mar 24, 2016 at 12:26:30AM +0100, Christoph Hellwig wrote:
> On Thu, Mar 24, 2016 at 10:05:00AM +1100, Dave Chinner wrote:
> > >  	d_instantiate(dentry, inode);
> > >  	xfs_finish_inode_setup(cip);
> > 
> > I think there are more places than this that need xfs_setup_iops()
> > calls - a quick look around makes me think they need to be paired
> > with every path that calls xfs_finish_inode_setup().
> 
> Most calls to xfs_finish_inode_setup are for error cases that
> just drop the inode instantly and don't need it.

Fair enough.

> The other
> cases are:
> 
>  - xfs_generic_create, xfs_vn_symlink and xfs_setup_existing_inode,
>    which are handled in this patch
>  - xfs_qm_qino_alloc, which is for the quota inode that doesn't have
>    inode operations

*nod*

>  - xfs_rename_alloc_whiteout which probably needs it.  This seems
>    to be recent and has no apparent test coverage, so I'm not sure
>    how to verify it, though.

Yup, that's the one I first noticed. generic/078 tests
RENAME_WHITEOUT functionality through renameat2() and it includes
operations on symlinks, so there is some coverage in xfstests for
it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
