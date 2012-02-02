Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q12HqNZ9067290 for <xfs@oss.sgi.com>; Thu, 2 Feb 2012 11:52:23 -0600
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id E3SSogjcjwHFD5GT (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 02 Feb 2012 09:52:22 -0800 (PST)
Date: Thu, 2 Feb 2012 18:52:19 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/3] filemap: don't call generic_write_sync for
	-EIOCBQUEUED
Message-ID: <20120202175219.GB6640@quack.suse.cz>
References: <1327698949-12616-1-git-send-email-jmoyer@redhat.com>
	<1327698949-12616-4-git-send-email-jmoyer@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1327698949-12616-4-git-send-email-jmoyer@redhat.com>
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

  Hello,

On Fri 27-01-12 16:15:49, Jeff Moyer wrote:
> As it stands, generic_file_aio_write will call into generic_write_sync
> when -EIOCBQUEUED is returned from __generic_file_aio_write.  EIOCBQUEUED
> indicates that an I/O was submitted but NOT completed.  Thus, we will
> flush the disk cache, potentially before the write(s) even make it to
> the disk!
  Yeah. It seems to be a problem introduced by Tejun's rewrite of barrier
code, right? Before that we'd drain the IO queue when cache flush is issued
and thus effectively wait for IO completion...

>  Up until now, this has been the best we could do, as file
> systems didn't bother to flush the disk cache after an O_SYNC AIO+DIO
> write.  After applying the prior two patches to xfs and ext4, at least
> the major two file systems do the right thing.  So, let's go ahead and
> fix this backwards logic.
  But doesn't this break filesystems which you didn't fix explicitely even
more than they were? You are right they might have sent cache flush too
early but they'd at least propely force all metadata modifications (e.g.
from allocation) to disk. But after this patch O_SYNC will have simply no
effect for these filesystems.

Also I was thinking whether we couldn't implement the fix in VFS. Basically
it would be the same like the fix for ext4. Like having a per-sb workqueue
and queue work calling generic_write_sync() from end_io handler when the
file is O_SYNC? That would solve the issue for all filesystems...

								Honza

> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
> ---
>  mm/filemap.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index c4ee2e9..004442f 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2634,7 +2634,7 @@ ssize_t generic_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
>  	ret = __generic_file_aio_write(iocb, iov, nr_segs, &iocb->ki_pos);
>  	mutex_unlock(&inode->i_mutex);
>  
> -	if (ret > 0 || ret == -EIOCBQUEUED) {
> +	if (ret > 0) {
>  		ssize_t err;
>  
>  		err = generic_write_sync(file, pos, ret);
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
