Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Oct 2006 03:00:02 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k9Q9xqaG029530
	for <xfs@oss.sgi.com>; Thu, 26 Oct 2006 02:59:54 -0700
Date: Thu, 26 Oct 2006 19:58:49 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [REVIEW 3 of 4] Fix recalim handling in xfs_iget_core
Message-ID: <20061026095849.GN8394166@melbourne.sgi.com>
References: <20061024072054.GT11034@melbourne.sgi.com> <453E5A0F.4070902@agami.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <453E5A0F.4070902@agami.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Shailendra Tripathi <stripathi@agami.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, t-nagano@ah.jp.nec.com, xfs-dev@sgi.com

On Tue, Oct 24, 2006 at 11:23:11AM -0700, Shailendra Tripathi wrote:
> Hi David,
>               I can't really see why we need this test:
>                if (xfs_iflags_test(ip, XFS_IRECLAIMABLE))
>                I think, An inode with no VP can be possibly in only 3 
> states (NEW, RECLAIM or RECLAIMABLE). This check is being made inside 
> (inode_vp == NULL)  check. If I am correct, may be we can omit an extra 
> instruction here.

We can't have an I_NEW here - that is checked even before we we try
to get the vnode. Hence we can be in either RECLAIM or RECLAIMABLE state.
Then we check RECLAIm and retry. So only reclaimable can get here.

Yes, I think you're right. Good catch. I'll replace the test
with an ASSERT.

>              It appears that you can see inode with XFS_ISTALE can 
> potentially reach. I am not sure how it should reach that path. 
> Following code just after this assumes that it must be in reclaimable path:
>        
>                                XFS_MOUNT_ILOCK(mp);
>                                list_del_init(&ip->i_reclaim);
>                                XFS_MOUNT_IUNLOCK(mp);

That's a no-op if it's not on the reclaim list (next and prev both
point to itself) so it should be safe even on non-IRECLAIMABLE
inodes.

Thanks, Shailendra.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
