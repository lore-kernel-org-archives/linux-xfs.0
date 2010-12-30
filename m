Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBUNBsrj045715 for <xfs@oss.sgi.com>; Thu, 30 Dec 2010 17:11:54 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 050E6229FC8
	for <xfs@oss.sgi.com>; Thu, 30 Dec 2010 15:13:57 -0800 (PST)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	33jBSSSTv6OtWPfa for <xfs@oss.sgi.com>;
	Thu, 30 Dec 2010 15:13:57 -0800 (PST)
Date: Fri, 31 Dec 2010 10:13:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS handling of synchronous buffers in case of EIO error
Message-ID: <20101230231353.GC15179@dastard>
References: <AANLkTi=Tmh9m_Rwy-bUZQEzcZ3M+6X9tZxFMO-J2Rvec@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTi=Tmh9m_Rwy-bUZQEzcZ3M+6X9tZxFMO-J2Rvec@mail.gmail.com>
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
To: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Cc: xfs@oss.sgi.com

On Thu, Dec 30, 2010 at 05:58:36PM +0530, Ajeet Yadav wrote:
> Kernel: 2.6.30.9
> 
> I am trouble shooting a hang in XFS during umount.
> Test scenerio: Copy large number of files files using below script, and
> remove the USB after 3-5 second

FWIW, in future can you please report what kernel you are testing on?

> 
> index=0
> while [ "$?" == 0 ]
> do
>         index=$((index+1))
>         sync
>         cp $1/1KB.txt $2/"$index".test
> done
> 
> In rare scenerio during USB unplug the umount process hang at xfs_buf_lock.
> Below log shows the hung process
> 
> We have put printk to buffer handling functions xfs_buf_iodone_callbacks(),
> xfs_buf_error_relse(), xfs_buf_relse() and xfs_buf_rele()
> 
> We always observed the hang only comes when bp->b_relse =
> xfs_buf_error_relse(). i.e when xfs_buf_iodone_callbacks() execute
> XFS_BUF_SET_BRELSE_FUNC(bp,xfs_buf_error_relse);
> XFS_BUF_DONE(bp);
> XFS_BUF_FINISH_IOWAIT(bp);
> 
>  buf its never called by xfs_buf_relse() because b_hold = 3.
> 
> Also we have seen that this problem always comes when bp->relse != NULL &&
> bp->hold > 1.

This appears to be the same problem as reported here:

http://oss.sgi.com/archives/xfs/2010-12/msg00380.html


> I do not know whether below prints will help you, but I have taken printk
> for super block buffer tracing
> S-functionname ( Start of function)
> E-functionname (End of function)

If you have a recent enough kernel, you can get all this information
from the tracing built into XFS.

As it is, the cause of the problem is that setting bp->b_relse
changes the behaviour of xfs_buf_relse() - if bp->b_relse is set, it
doesn't unlock the buffer. This is normally just fine, because
xfs_buf_rele() has a special case to handle buffers with
bp->b_relse(), which adds a hold count and call the release function
when the hold count drops to zero. The b_relse function is supposed
to unlock the buffer by calling xfs_buf_relse() again.

Unfortunately, the superblock buffer is special - the hold count on
it never drops to zero until very late in the unmont process because
it is managed by the filesystem.  Hence the bp->b_relse function is
never called, and hence the buffer is never unlocked in this case.
Hence future attempts to access it hang.

I'll need to think about this one for a bit...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
