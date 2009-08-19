Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7JGWSSQ217219 for <xfs@oss.sgi.com>; Wed, 19 Aug 2009 11:32:43 -0500
Date: Wed, 19 Aug 2009 12:33:15 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 14/17] xfs: Use new syncing helper
Message-ID: <20090819163315.GA19969@infradead.org>
References: <1250697884-22288-1-git-send-email-jack@suse.cz>
	<1250697884-22288-15-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1250697884-22288-15-git-send-email-jack@suse.cz>
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
Cc: hch@infradead.org, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Wed, Aug 19, 2009 at 06:04:41PM +0200, Jan Kara wrote:
> diff --git a/fs/xfs/linux-2.6/xfs_lrw.c b/fs/xfs/linux-2.6/xfs_lrw.c
> index 7078974..aeb5a39 100644
> --- a/fs/xfs/linux-2.6/xfs_lrw.c
> +++ b/fs/xfs/linux-2.6/xfs_lrw.c
> @@ -817,7 +817,7 @@ write_retry:
>  		xfs_iunlock(xip, iolock);
>  		if (need_i_mutex)
>  			mutex_unlock(&inode->i_mutex);
> -		error2 = sync_page_range(inode, mapping, pos, ret);
> +		error2 = generic_write_sync(file, pos, ret);

I don't think this is very optimal for XFS.  This first starts an
asynchronous writeout of the range in generic_write_sync,
then calls into ->fsync which waits for all I/O on the file to finish,
then forces the log inside xfs_fsync,  then waits for the range again in
generic_write_sync, and after this code calls into
xfs_write_sync_logforce which forces to log _again_.

We should be fine just doing your new filemap_fdatawrite_range helper
here and let xfs_write_sync_logforce do the work.  Long term we should
just get rid of this stupid submit writes before syncing the iode, then
wait crap which is a pain for all modern filesystems.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
