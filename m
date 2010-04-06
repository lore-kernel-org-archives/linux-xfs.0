Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o36N9wHT142668 for <xfs@oss.sgi.com>; Tue, 6 Apr 2010 18:09:59 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DFED12A1A52
	for <xfs@oss.sgi.com>; Tue,  6 Apr 2010 16:11:47 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	MjOcCzmH2HALSbE2 for <xfs@oss.sgi.com>;
	Tue, 06 Apr 2010 16:11:47 -0700 (PDT)
Date: Wed, 7 Apr 2010 09:11:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.34-rc3: simple du (on a big xfs tree) triggers oom killer
	[bisected: 57817c68229984818fea9e614d6f95249c3fb098]
Message-ID: <20100406231144.GF11036@dastard>
References: <201004050049.17952.hpj@urpla.net>
	<201004051335.41857.hpj@urpla.net> <20100405230600.GA3335@dastard>
	<201004061652.58189.hpj@urpla.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201004061652.58189.hpj@urpla.net>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: opensuse-kernel@opensuse.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Apr 06, 2010 at 04:52:57PM +0200, Hans-Peter Jansen wrote:
> Hi Dave,
> 
> On Tuesday 06 April 2010, 01:06:00 Dave Chinner wrote:
> > On Mon, Apr 05, 2010 at 01:35:41PM +0200, Hans-Peter Jansen wrote:
> > > >
> > > > Oh, this is a highmem box. You ran out of low memory, I think, which
> > > > is where all the inodes are cached. Seems like a VM problem or a
> > > > highmem/lowmem split config problem to me, not anything to do with
> > > > XFS...

[snip]

> Dave, I really don't want to disappoint you, but a lengthy bisection session 
> points to:
> 
> 57817c68229984818fea9e614d6f95249c3fb098 is the first bad commit
> commit 57817c68229984818fea9e614d6f95249c3fb098
> Author: Dave Chinner <david@fromorbit.com>
> Date:   Sun Jan 10 23:51:47 2010 +0000
> 
>     xfs: reclaim all inodes by background tree walks

Interesting. I did a fair bit of low memory testing when i made that
change (admittedly none on a highmem i386 box), and since then I've
done lots of "millions of files" tree creates, traversals and destroys on
limited memory machines without triggering problems when memory is
completely full of inodes.

Let me try to reproduce this on a small VM and I'll get back to you.

> diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
> index 52e06b4..a76fc01 100644
> --- a/fs/xfs/linux-2.6/xfs_super.c
> +++ b/fs/xfs/linux-2.6/xfs_super.c
> @@ -954,14 +954,16 @@ xfs_fs_destroy_inode(
>  	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_IRECLAIM));
>  
>  	/*
> -	 * We always use background reclaim here because even if the
> -	 * inode is clean, it still may be under IO and hence we have
> -	 * to take the flush lock. The background reclaim path handles
> -	 * this more efficiently than we can here, so simply let background
> -	 * reclaim tear down all inodes.
> +	 * If we have nothing to flush with this inode then complete the
> +	 * teardown now, otherwise delay the flush operation.
>  	 */
> +	if (!xfs_inode_clean(ip)) {
> +		xfs_inode_set_reclaim_tag(ip);
> +		return;
> +	}
> +
>  out_reclaim:
> -	xfs_inode_set_reclaim_tag(ip);
> +	xfs_ireclaim(ip);
>  }

I don't think that will work as expected in all situations - the
inode clean check there is not completely valid as the XFS inode
locks aren't held, so it can race with other operations that need
to complete before reclaim is done. This was one of the reasons for
pushing reclaim into the background....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
