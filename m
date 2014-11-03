Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DF9F17F5E
	for <xfs@oss.sgi.com>; Mon,  3 Nov 2014 16:19:42 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CDA52304048
	for <xfs@oss.sgi.com>; Mon,  3 Nov 2014 14:19:39 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	NASPP9FlRcHXEG77 for <xfs@oss.sgi.com>;
	Mon, 03 Nov 2014 14:19:37 -0800 (PST)
Date: Tue, 4 Nov 2014 09:18:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: your patch "mm: Remove false WARN_ON from
	pagecache_isize_extended()"
Message-ID: <20141103221849.GB23575@dastard>
References: <5457BE390200007800044838@mail.emea.novell.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5457BE390200007800044838@mail.emea.novell.com>
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
To: Jan Beulich <JBeulich@suse.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Nov 03, 2014 at 04:41:13PM +0000, Jan Beulich wrote:
> Jan,
> 
> having run into that warning too, I looked into it a little, and now
> having found that patch am pretty uncertain: Both truncate_setsize()
> and pagecache_isize_extended() document that they want to be
> called with i_mutex held, so removing the WARN_ON() alone seems
> either incomplete or wrong. What I found to work without violating
> this documented requirement is the patch below.

Or, just perhaps, the comments are wrong....

Some filesystems have stronger, more robust internal serialisation
than the VFS provides with i_mutex....

> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -797,7 +797,7 @@ xfs_file_fallocate(
>  		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE))
>  		return -EOPNOTSUPP;
>  
> -	xfs_ilock(ip, XFS_IOLOCK_EXCL);
> +	xfs_rw_ilock(ip, XFS_IOLOCK_EXCL);
>  	if (mode & FALLOC_FL_PUNCH_HOLE) {
>  		error = xfs_free_file_space(ip, offset, len);
>  		if (error)

The i_mutex is completely redundant here. Not to mention there are
multiple callers of these xfs_*_file_space() functions used to
implement fallocate(), and we're not about to change the locking
model for them....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
