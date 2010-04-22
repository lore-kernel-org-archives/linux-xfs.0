Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3MJ7adj226164 for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 14:07:36 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A595610527C8
	for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 12:09:35 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id J6eFVMX2iBRtC8iS for <xfs@oss.sgi.com>;
	Thu, 22 Apr 2010 12:09:35 -0700 (PDT)
Date: Thu, 22 Apr 2010 21:09:37 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/4] xfs: remove nr_to_write writeback windup.
Message-ID: <20100422190936.GB19286@quack.suse.cz>
References: <1271731314-5893-1-git-send-email-david@fromorbit.com>
	<1271731314-5893-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1271731314-5893-5-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tue 20-04-10 12:41:54, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that the background flush code has been fixed, we shouldn't need to
> silently multiply the wbc->nr_to_write to get good writeback. Remove
> that code.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/linux-2.6/xfs_aops.c |    8 --------
>  1 files changed, 0 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
> index 9962850..2b2225d 100644
> --- a/fs/xfs/linux-2.6/xfs_aops.c
> +++ b/fs/xfs/linux-2.6/xfs_aops.c
> @@ -1336,14 +1336,6 @@ xfs_vm_writepage(
>  	if (!page_has_buffers(page))
>  		create_empty_buffers(page, 1 << inode->i_blkbits, 0);
>  
> -
> -	/*
> -	 *  VM calculation for nr_to_write seems off.  Bump it way
> -	 *  up, this gets simple streaming writes zippy again.
> -	 *  To be reviewed again after Jens' writeback changes.
> -	 */
> -	wbc->nr_to_write *= 4;
> -
  Hum, are you sure about this? I thought it's there because VM passes at
most 1024 pages to write from background writeback and you wanted to write
more in one go (at least ext4 wants to do this).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
