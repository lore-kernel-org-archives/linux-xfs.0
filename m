Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0IHxEoC014764 for <xfs@oss.sgi.com>; Sun, 18 Jan 2009 11:59:15 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 037209AA10
	for <xfs@oss.sgi.com>; Sun, 18 Jan 2009 09:59:13 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 657xBWoDtklf3nmh for
	<xfs@oss.sgi.com>; Sun, 18 Jan 2009 09:59:13 -0800 (PST)
Date: Sun, 18 Jan 2009 12:58:42 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsprogs: allow xfs_freeze to work on non-xfs filesystems
Message-ID: <20090118175842.GA15675@infradead.org>
References: <496E6FB4.8070300@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <496E6FB4.8070300@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
Cc: xfs mailing list <xfs@oss.sgi.com>

On Wed, Jan 14, 2009 at 05:05:24PM -0600, Eric Sandeen wrote:
> allow xfs_freeze to freeze "foreign" filesystems
> 
> Now that the freeze ioctl has been elevated to the VFS,
> let's let xfs_io and xfs_freeze freeze other filesystems
> as well - add the CMD_FOREIGN_OK flag to freeze & thaw.
> 
> I think the worst that will happen on older kernels is that
> the command will fail with ENOSYS or EINVAL....

Looks good to me, but I thikn you should also update the
xfs_freeze manpage to mention that it works for non-XFS filesystems
on 2.6.29 or newer kernels.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
