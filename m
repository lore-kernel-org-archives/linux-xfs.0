Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0SF891F143261 for <xfs@oss.sgi.com>; Sat, 28 Jan 2012 09:08:09 -0600
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id lCYD91I8RXZvsfNg for
	<xfs@oss.sgi.com>; Sat, 28 Jan 2012 07:08:08 -0800 (PST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: [PATCH 3/3] filemap: don't call generic_write_sync for
	-EIOCBQUEUED
Date: Sat, 28 Jan 2012 16:08:06 +0100
References: <1327698949-12616-1-git-send-email-jmoyer@redhat.com>
	<1327698949-12616-4-git-send-email-jmoyer@redhat.com>
	(sfid-20120127_225408_201177_50791DCC)
In-Reply-To: <1327698949-12616-4-git-send-email-jmoyer@redhat.com>
MIME-Version: 1.0
Message-Id: <201201281608.07348.Martin@lichtvoll.de>
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
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

Adding linux-btrfs to Cc.

Am Freitag, 27. Januar 2012 schrieb Jeff Moyer:
> Hi,

Hi,
 
> As it stands, generic_file_aio_write will call into generic_write_sync
> when -EIOCBQUEUED is returned from __generic_file_aio_write. 
> EIOCBQUEUED indicates that an I/O was submitted but NOT completed. 
> Thus, we will flush the disk cache, potentially before the write(s)
> even make it to the disk!  Up until now, this has been the best we
> could do, as file systems didn't bother to flush the disk cache after
> an O_SYNC AIO+DIO write.  After applying the prior two patches to xfs
> and ext4, at least the major two file systems do the right thing.  So,
> let's go ahead and fix this backwards logic.

Would this need an adaption to BTRFS as well?

Thanks,
Martin

> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
> ---
>  mm/filemap.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index c4ee2e9..004442f 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2634,7 +2634,7 @@ ssize_t generic_file_aio_write(struct kiocb
> *iocb, const struct iovec *iov, ret = __generic_file_aio_write(iocb,
> iov, nr_segs, &iocb->ki_pos); mutex_unlock(&inode->i_mutex);
> 
> -	if (ret > 0 || ret == -EIOCBQUEUED) {
> +	if (ret > 0) {
>  		ssize_t err;
> 
>  		err = generic_write_sync(file, pos, ret);


-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
