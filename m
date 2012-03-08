Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q28NKjgq093008 for <xfs@oss.sgi.com>; Thu, 8 Mar 2012 17:20:45 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ket5vSTiaElPXQha for <xfs@oss.sgi.com>;
	Thu, 08 Mar 2012 15:20:43 -0800 (PST)
Date: Fri, 9 Mar 2012 10:20:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 11/19] xfs: Convert to new freezing code
Message-ID: <20120308232041.GU3592@dastard>
References: <1330963277-26336-1-git-send-email-jack@suse.cz>
	<1330963277-26336-12-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1330963277-26336-12-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: sandeen@redhat.com, Alex Elder <elder@kernel.org>, Kamal Mostafa <kamal@canonical.com>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, Al Viro <viro@ZenIV.linux.org.uk>, dchinner@redhat.com, linux-fsdevel@vger.kernel.org

On Mon, Mar 05, 2012 at 05:01:09PM +0100, Jan Kara wrote:
> Generic code now blocks all writers from standard write paths. So we block all
> writers coming from ioctl and replace blocking of transactions on frozen
> filesystem with a debugging check. As a bonus, we get a protection of ioctl
> against racing remount read-only. We also convert xfs_file_aio_write() to a
> non-racy freeze protection.
....
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 329b06a..6468a2a 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -577,7 +577,6 @@ xfs_trans_alloc(
>  	xfs_mount_t	*mp,
>  	uint		type)
>  {
> -	xfs_wait_for_freeze(mp, SB_FREEZE_TRANS);
>  	return _xfs_trans_alloc(mp, type, KM_SLEEP);
>  }

So what is there to stop internal XFS threads from starting
transactions when the filesystem is frozen? Previously this
SB_FREEZE_TRANS would guarantee even internal fucntions would get
stopped, but now there's nothing?

I do beleive that ext4 has the same problem (the issue reported with
the lazy inode init background thread), and I can see that any other
filesystem that can make modifications via internal triggers will
see the same problem - freeze doesn't block them any more...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
