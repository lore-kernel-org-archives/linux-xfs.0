Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q15NBVQF083877 for <xfs@oss.sgi.com>; Sun, 5 Feb 2012 17:11:31 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	lUj643iLdl54WC1F for <xfs@oss.sgi.com>;
	Sun, 05 Feb 2012 15:11:29 -0800 (PST)
Date: Mon, 6 Feb 2012 10:11:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/8] xfs: Protect xfs_file_aio_write() &
	xfs_setattr_size() with sb_start_write - sb_end_write
Message-ID: <20120205231127.GH6922@dastard>
References: <1327091686-23177-1-git-send-email-jack@suse.cz>
	<1327091686-23177-6-git-send-email-jack@suse.cz>
	<4F2CB44D.4060006@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F2CB44D.4060006@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Alex Elder <elder@kernel.org>, Jan Kara <jack@suse.cz>, Surbhi Palande <csurbhi@gmail.com>, Kamal Mostafa <kamal@canonical.com>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, Dave Chinner <dchinner@redhat.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Fri, Feb 03, 2012 at 10:30:05PM -0600, Eric Sandeen wrote:
> On 1/20/12 2:34 PM, Jan Kara wrote:
> > Replace racy xfs_wait_for_freeze() check in xfs_file_aio_write() with
> > a reliable sb_start_write() - sb_end_write() locking.
> 
> Here's what I'm running with now.  With this and my modified
> patch6, I can pass xfstests 068 on xfs.

Just a quick question this raises - is .splice_write() protected?

Cheers,

Dave.
> 
> -Eric
> 
> 
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 7e5bc87..f1cacdc 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -874,11 +874,11 @@ xfs_file_aio_write(
>  	if (ocount == 0)
>  		return 0;
>  
> -	xfs_wait_for_freeze(ip->i_mount, SB_FREEZE_WRITE);
> -
>  	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
>  		return -EIO;
>  
> +	sb_start_write(inode->i_sb, SB_FREEZE_WRITE);
> +

This check really should go before the shutdown check - if the
filesystem shuts down while we are freezing or attempting to freeze,
we want to abort the write after we are woken....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
