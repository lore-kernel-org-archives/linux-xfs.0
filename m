Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2F3D67F3F
	for <xfs@oss.sgi.com>; Tue, 18 Nov 2014 16:30:18 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 012108F8037
	for <xfs@oss.sgi.com>; Tue, 18 Nov 2014 14:30:14 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	WOAR8nI525Z4A0OI for <xfs@oss.sgi.com>;
	Tue, 18 Nov 2014 14:30:01 -0800 (PST)
Date: Wed, 19 Nov 2014 09:29:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 10/11] quota: Switch ->get_dqblk() and ->set_dqblk() to
	use bytes as space units
Message-ID: <20141118222952.GQ23575@dastard>
References: <1415739865-2438-1-git-send-email-jack@suse.cz>
	<1415739865-2438-11-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1415739865-2438-11-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Tue, Nov 11, 2014 at 10:04:24PM +0100, Jan Kara wrote:
> Currently ->get_dqblk() and ->set_dqblk() use struct fs_disk_quota which
> tracks space limits and usage in 512-byte blocks. However VFS quotas
> track usage in bytes (as some filesystems require that) and we need to
> somehow pass this information. Upto now it wasn't a problem because we
> didn't do any unit conversion (thus VFS quota routines happily stuck
> number of bytes into d_bcount field of struct fd_disk_quota). Only if
> you tried to use Q_XGETQUOTA or Q_XSETQLIM for VFS quotas (or Q_GETQUOTA
> / Q_SETQUOTA for XFS quotas), you got bogus results but noone really
> tried that. But when we want interfaces compatible we need to fix this.
> 
> So we bite the bullet and define another quota structure used for
> passing information from/to ->get_dqblk()/->set_dqblk. It's somewhat
> sad we have to have more conversion routines in fs/quota/quota.c but
> it seems cleaner than overloading e.g. units of d_bcount to bytes.

I don't really like the idea of having to copy the dquot information
an extra time. We now:

	- copy from internal dquot to the new qc_dqblk
	- copy from the new qc_dqblk to if_dqblk/xfs_dqblk
	- copy if_dqblk/xfs_dqblk to the user buffer.

That's now three copies, and when we are having to deal with quota
reports containing hundreds of thousands of dquots that's going to
hrut performance.

We could probably get away with just one copy by passing a
filldir()-like context down into the filesystems to format their
internal dquot information directly into the user buffer in the
appropriate format. That way fs/quota/quota.c doesn't need
conversion routines, filesystems can optimise the formating to
minimise copying, and we can still provide generic routines for
filesystems using the generic quota infrastructure....

[...]

> @@ -277,10 +287,73 @@ static int quota_getxstatev(struct super_block *sb, void __user *addr)
>  	return ret;
>  }
>  
> +/* XFS blocks to space conversion */
> +static u64 xfs_btos(u64 blocks)
> +{
> +	return blocks << 9;
> +}
> +
> +/* Space to XFS blocks conversion */
> +static u64 xfs_stob(u64 space)
> +{
> +	return (space + 511) >> 9;
> +}

Which is just redefining BBTOB() [Basic Blocks to Bytes] and BTOBB()
with magic numbers and no explanation of what a "block" actually is.
We already export those macros to userspace, and they are used by
xfs_quota to convert the block counts to bytes....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
