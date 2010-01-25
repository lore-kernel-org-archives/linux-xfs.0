Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0PBhVQS051909 for <xfs@oss.sgi.com>; Mon, 25 Jan 2010 05:43:32 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7BD041C77777
	for <xfs@oss.sgi.com>; Mon, 25 Jan 2010 03:44:35 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id YpsjHSThpALDCgJ5 for
	<xfs@oss.sgi.com>; Mon, 25 Jan 2010 03:44:35 -0800 (PST)
Date: Mon, 25 Jan 2010 06:44:33 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: don't hold onto reserved blocks on remount,ro
Message-ID: <20100125114433.GA8595@infradead.org>
References: <1264397572-18230-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1264397572-18230-1-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

On Mon, Jan 25, 2010 at 04:32:52PM +1100, Dave Chinner wrote:
> If we hold onto reserved blocks when doing a remount,ro we end
> up writing the blocks used count to disk that includes the reserved
> blocks. Reserved blocks are not actually used, so this results in
> the values in the superblock being incorrect.
> 
> Hence if we run xfs_check or xfs_repair -n while the filesystem is
> mounted remount,ro we end up with an inconsistent filesystem being
> reported. Also, running xfs_copy on the remount,ro filesystem will
> result in an inconsistent image being generated.
> 
> To fix this, unreserve the blocks when doing the remount,ro, and
> reserved them again on remount,rw. This way a remount,ro filesystem
> will appear consistent on disk to all utilities.

Looks good to me, the only thing that was rather confusing when trying
to read the patch is the m_resblks_ro field in struct xfs_mount, it's
more a m_resblks_save, as in the saved value before we modified the
block count during remount,ro.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
