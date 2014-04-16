Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AF13F7F3F
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 00:38:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 981068F8049
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 22:38:37 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	kMo8en3WUDSz1V8Y for <xfs@oss.sgi.com>;
	Tue, 15 Apr 2014 22:38:32 -0700 (PDT)
Date: Wed, 16 Apr 2014 15:37:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/19] Make effect of PF_FSTRANS to disable __GFP_FS
	universal.
Message-ID: <20140416053756.GC15995@dastard>
References: <20140416033623.10604.69237.stgit@notabene.brown>
	<20140416040336.10604.58240.stgit@notabene.brown>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140416040336.10604.58240.stgit@notabene.brown>
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
Cc: linux-mm@kvack.org, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>, xfs@oss.sgi.com

On Wed, Apr 16, 2014 at 02:03:36PM +1000, NeilBrown wrote:
> Currently both xfs and nfs will handle PF_FSTRANS by disabling
> __GFP_FS.
> 
> Make this effect global by repurposing memalloc_noio_flags (which
> does the same thing for PF_MEMALLOC_NOIO and __GFP_IO) to generally
> impost the task flags on a gfp_t.
> Due to this repurposing we change the name of memalloc_noio_flags
> to gfp_from_current().
> 
> As PF_FSTRANS now uniformly removes __GFP_FS we can remove special
> code for this from xfs and nfs.
> 
> As we can now expect other code to set PF_FSTRANS, its meaning is more
> general, so the WARN_ON in xfs_vm_writepage() which checks PF_FSTRANS
> is not set is no longer appropriate.  PF_FSTRANS may be set for other
> reasons than an XFS transaction.

So PF_FSTRANS no longer means "filesystem in transaction context".
Are you going to rename to match whatever it's meaning is now?
I'm not exactly clear on what it means now...


> As lockdep cares about __GFP_FS, we need to translate PF_FSTRANS to
> __GFP_FS before calling lockdep_alloc_trace() in various places.
> 
> Signed-off-by: NeilBrown <neilb@suse.de>
....
> diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
> index 64db0e53edea..882b86270ebe 100644
> --- a/fs/xfs/kmem.h
> +++ b/fs/xfs/kmem.h
> @@ -50,8 +50,6 @@ kmem_flags_convert(xfs_km_flags_t flags)
>  		lflags = GFP_ATOMIC | __GFP_NOWARN;
>  	} else {
>  		lflags = GFP_KERNEL | __GFP_NOWARN;
> -		if ((current->flags & PF_FSTRANS) || (flags & KM_NOFS))
> -			lflags &= ~__GFP_FS;
>  	}

I think KM_NOFS needs to remain here, as it has use outside of
transaction contexts that set PF_FSTRANS....

>  	if (flags & KM_ZERO)
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index db2cfb067d0b..207a7f86d5d7 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -952,13 +952,6 @@ xfs_vm_writepage(
>  			PF_MEMALLOC))
>  		goto redirty;
>  
> -	/*
> -	 * Given that we do not allow direct reclaim to call us, we should
> -	 * never be called while in a filesystem transaction.
> -	 */
> -	if (WARN_ON(current->flags & PF_FSTRANS))
> -		goto redirty;

We still need to ensure this rule isn't broken. If it is, the
filesystem will silently deadlock in delayed allocation rather than
gracefully handle the problem with a warning....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
